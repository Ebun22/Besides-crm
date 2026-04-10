-- 1. Validation Trigger Function
CREATE OR REPLACE FUNCTION "public"."validate_status_update_to_approved"()
RETURNS TRIGGER
AS $$
DECLARE
  v_missing_fields      text := '';
  v_draft_status__id    uuid;
  v_approved_status__id uuid;
BEGIN
  SELECT "id"
  INTO v_draft_status__id
  FROM "public"."people__status"
  WHERE "name" = 'DRAFT'
  LIMIT 1;
  IF v_draft_status__id  IS NULL
  THEN 
    RAISE EXCEPTION 'Setup Error: DRAFT status not found in people__status.';
  END IF;

  SELECT "id"
  INTO v_approved_status__id
  FROM "public"."people__status"
  WHERE "name" = 'APPROVED'
  LIMIT 1;
  IF v_approved_status__id IS NULL
  THEN
    RAISE EXCEPTION 'Setup Error: APPROVED status not found in people__status.';
  END IF;

  IF (NEW."status" = v_approved_status__id AND OLD."status" = v_draft_status__id ) THEN
    -- CHECK 1: Required fields on people__details
    IF NEW."cognome"        IS NULL THEN v_missing_fields := v_missing_fields || '- Cognome (Surname)'         || E'\n'; END IF;
    IF NEW."nome"           IS NULL THEN v_missing_fields := v_missing_fields || '- Nome (Name)'               || E'\n'; END IF;
    IF NEW."cod_fis"        IS NULL THEN v_missing_fields := v_missing_fields || '- Codice Fiscale'            || E'\n'; END IF;
    IF NEW."cl_celnum"      IS NULL THEN v_missing_fields := v_missing_fields || '- Cellulare (Mobile)'        || E'\n'; END IF;
    IF NEW."cl_fixnum"      IS NULL THEN v_missing_fields := v_missing_fields || '- Telefono Fisso (Landline)' || E'\n'; END IF;
    IF NEW."email"          IS NULL THEN v_missing_fields := v_missing_fields || '- Email'                     || E'\n'; END IF;
    IF NEW."pec"            IS NULL THEN v_missing_fields := v_missing_fields || '- PEC'                       || E'\n'; END IF;
    IF NEW."id_type"        IS NULL THEN v_missing_fields := v_missing_fields || '- ID Document Type'          || E'\n'; END IF;
    IF NEW."id_number"      IS NULL THEN v_missing_fields := v_missing_fields || '- ID Document Number'        || E'\n'; END IF;
    IF NEW."tit_birthplace" IS NULL THEN v_missing_fields := v_missing_fields || '- Birth Place'               || E'\n'; END IF;
    IF NEW."tit_birth_date" IS NULL THEN v_missing_fields := v_missing_fields || '- Birth Date'                || E'\n'; END IF;
    IF NEW."tit_gender"     IS NULL THEN v_missing_fields := v_missing_fields || '- Gender'                    || E'\n'; END IF;
    IF NEW."cust_address_1" IS NULL THEN v_missing_fields := v_missing_fields || '- Customer Address 1'        || E'\n'; END IF;
    IF NEW."cust_address_2" IS NULL THEN v_missing_fields := v_missing_fields || '- Customer Address 2'        || E'\n'; END IF;
    IF NEW."cust_zip"       IS NULL THEN v_missing_fields := v_missing_fields || '- Customer Zip Code'         || E'\n'; END IF;
    IF NEW."cust_town"      IS NULL THEN v_missing_fields := v_missing_fields || '- Customer Town'             || E'\n'; END IF;
    IF NEW."cust_pr"        IS NULL THEN v_missing_fields := v_missing_fields || '- Customer Province'         || E'\n'; END IF;
    IF NEW."type"           IS NULL THEN v_missing_fields := v_missing_fields || '- Personnel Type'            || E'\n'; END IF;

    IF v_missing_fields <> '' THEN
        RAISE EXCEPTION 'Cannot approve. The following fields are missing:\n%', v_missing_fields;
    END IF;

    -- CHECK 2: A fully filled supply address is linked via the join table
    IF NOT EXISTS (
        SELECT 1
        FROM  "public"."people__supply__address" "psa"
        JOIN  "public"."supply__address"         "sa"  ON "sa"."id" = "psa"."supp_ref"
        WHERE "psa"."cust_ref"       = NEW."id"
        AND   "sa"."supp_address_1" IS NOT NULL
        AND   "sa"."supp_zip"       IS NOT NULL
        AND   "sa"."supp_town"      IS NOT NULL
        AND   "sa"."supp_pr"        IS NOT NULL
    ) THEN
        RAISE EXCEPTION 'Validation Failed: Linked supply address is missing or incomplete (Address, Zip, Town, Province required).';
    END IF;

    -- CHECK 3: Payment details exist for this person with key fields filled
    IF NOT EXISTS (
        SELECT 1
        FROM  "public"."payment__details"
        WHERE "cust_ref"     = NEW."id"
        AND   "pay_type"    IS NOT NULL
        AND   "cv_cognome"  IS NOT NULL
        AND   "cv_nome"     IS NOT NULL
        AND   "pag_codfisc" IS NOT NULL
    ) THEN
        RAISE EXCEPTION 'Validation Failed: Payment details are missing or incomplete for this record.';
    END IF;

    -- TENTATIVE: CHECK that customer has invoice
    IF NOT EXISTS (
        SELECT 1
        FROM "public"."document__details" "dd"
        JOIN "public"."document__types"   "dt"
        ON "dt"."id"        = "dd"."type"
        WHERE "dd"."owner"  = NEW."id"
        AND   "dt"."name"   = 'invoice'
    ) THEN
        RAISE EXCEPTION 'Validation Failed: A document of type "invoice" is required but was not found.';
    END IF;

    -- TENTATIVE: A linked company exists via the join table with required fields filled
    IF NOT EXISTS (
        SELECT 1
        FROM  "public"."people__company"  "pc"
        JOIN  "public"."company__details" "cd" ON "cd"."id" = "pc"."comp_ref"
        WHERE "pc"."cust_ref"        = NEW."id"
        AND   "cd"."ragione_sociale" IS NOT NULL
        AND   "cd"."p_iva"           IS NOT NULL
        AND   "cd"."cf_azienda"      IS NOT NULL
    ) THEN
        RAISE EXCEPTION 'Validation Failed: Linked company is missing or incomplete (Ragione Sociale, P.IVA, CF Azienda required).';
    END IF;

  END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS "tr_ensure_CRM_ready_for_approval" ON "public"."people__details";

CREATE TRIGGER "tr_ensure_CRM_ready_for_approval"
BEFORE UPDATE ON "public"."people__details"
FOR EACH ROW
EXECUTE FUNCTION "public"."validate_status_update_to_approved"();
