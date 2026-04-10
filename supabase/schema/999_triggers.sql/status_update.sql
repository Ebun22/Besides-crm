-- 1. Validation Trigger Function
CREATE OR REPLACE FUNCTION "public"."validate_status_update_to_approved"()
RETURNS TRIGGER AS $$
BEGIN
    -- Only run checks when transitioning specifically from DRAFT → APPROVED
    IF (NEW."status" = 'APPROVED' AND OLD."status" = 'DRAFT') THEN

        -- CHECK 1: Required fields on people__details
        IF NEW."cognome"        IS NULL THEN RAISE EXCEPTION 'Missing: Cognome (Surname)';          END IF;
        IF NEW."nome"           IS NULL THEN RAISE EXCEPTION 'Missing: Nome (Name)';                END IF;
        IF NEW."cod_fis"        IS NULL THEN RAISE EXCEPTION 'Missing: Codice Fiscale';             END IF;
        IF NEW."cl_celnum"      IS NULL THEN RAISE EXCEPTION 'Missing: Cellulare (Mobile)';         END IF;
        IF NEW."cl_fixnum"      IS NULL THEN RAISE EXCEPTION 'Missing: Telefono Fisso (Landline)';  END IF;
        IF NEW."email"          IS NULL THEN RAISE EXCEPTION 'Missing: Email';                      END IF;
        IF NEW."pec"            IS NULL THEN RAISE EXCEPTION 'Missing: PEC';                        END IF;
        IF NEW."id_type"        IS NULL THEN RAISE EXCEPTION 'Missing: ID Document Type';           END IF;
        IF NEW."id_number"      IS NULL THEN RAISE EXCEPTION 'Missing: ID Document Number';         END IF;
        IF NEW."tit_birthplace" IS NULL THEN RAISE EXCEPTION 'Missing: Birth Place';                END IF;
        IF NEW."tit_birth_date" IS NULL THEN RAISE EXCEPTION 'Missing: Birth Date';                 END IF;
        IF NEW."tit_gender"     IS NULL THEN RAISE EXCEPTION 'Missing: Gender';                     END IF;
        IF NEW."cust_address_1" IS NULL THEN RAISE EXCEPTION 'Missing: Customer Address 1';         END IF;
        IF NEW."cust_zip"       IS NULL THEN RAISE EXCEPTION 'Missing: Customer Zip Code';          END IF;
        IF NEW."cust_town"      IS NULL THEN RAISE EXCEPTION 'Missing: Customer Town';              END IF;
        IF NEW."cust_pr"        IS NULL THEN RAISE EXCEPTION 'Missing: Customer Province';          END IF;
        IF NEW."type"           IS NULL THEN RAISE EXCEPTION 'Missing: Personnel Type';             END IF;

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
            AND   "cc_cognome"  IS NOT NULL
            AND   "cc_nome"     IS NOT NULL
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
