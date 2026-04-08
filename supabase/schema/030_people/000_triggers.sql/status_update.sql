-- 1. Create the Validation updateLogic Function
CREATE OR REPLACE FUNCTION validate_status_update_to_approved()
RETURNS TRIGGER AS $$
BEGIN
    -- Only trigger the check if status is changing TO 'Approved'
    -- (OLD.status IS DISTINCT FROM 'Approved') handles cases where old status was NULL
    IF (NEW.status = 'APPROVED' AND (OLD.status IS 'DRAFT')) THEN

        -- CHECK 1: Ensure people__details required fields are not NULL
       IF NEW.cognome IS NULL THEN RAISE EXCEPTION 'Missing: Cognome (Surname)'; END IF;
       IF NEW.nome IS NULL THEN RAISE EXCEPTION 'Missing: Nome (Name)'; END IF;
       IF NEW.cod_fis IS NULL THEN RAISE EXCEPTION 'Missing: Codice Fiscale'; END IF;
       IF NEW.cl_celnum IS NULL THEN RAISE EXCEPTION 'Missing: Cellulare (Mobile)'; END IF;
       IF NEW.cl_fixnum IS NULL THEN RAISE EXCEPTION 'Missing: Telefono Fisso (Landline)'; END IF;
       IF NEW.email IS NULL THEN RAISE EXCEPTION 'Missing: Email'; END IF;
       IF NEW.pec IS NULL THEN RAISE EXCEPTION 'Missing: PEC'; END IF;
       IF NEW.id_type IS NULL THEN RAISE EXCEPTION 'Missing: ID Document Type'; END IF;
       IF NEW.id_number IS NULL THEN RAISE EXCEPTION 'Missing: ID Document Number'; END IF;
       IF NEW.tit_birthplace IS NULL THEN RAISE EXCEPTION 'Missing: Birth Place'; END IF;
       IF NEW.tit_birth_date IS NULL THEN RAISE EXCEPTION 'Missing: Birth Date'; END IF;
       IF NEW.tit_gender IS NULL THEN RAISE EXCEPTION 'Missing: Gender'; END IF;
       IF NEW.cust_address_1 IS NULL THEN RAISE EXCEPTION 'Missing: Customer Address 1'; END IF;
       IF NEW.cust_address_2 IS NULL THEN RAISE EXCEPTION 'Missing: Customer Address 2'; END IF;
       IF NEW.cust_zip IS NULL THEN RAISE EXCEPTION 'Missing: Customer Zip Code'; END IF;
       IF NEW.cust_town IS NULL THEN RAISE EXCEPTION 'Missing: Customer Town'; END IF;
       IF NEW.cust_pr IS NULL THEN RAISE EXCEPTION 'Missing: Customer Province'; END IF;
       IF NEW.type IS NULL THEN RAISE EXCEPTION 'Missing: Personnel Type'; END IF;

        -- CHECK 2: Linked Supply Data (Cross-Table Check)
        IF NOT EXISTS (
            SELECT 1 
            FROM personnel_supply ps
            JOIN supply s ON ps.supply_id = s.id
            WHERE ps.personnel_id = NEW.id
            AND s.supp_address_1 IS NOT NULL
            AND s.supp_address_2 IS NOT NULL
            AND s.supp_zip       IS NOT NULL
            AND s.supp_town      IS NOT NULL
            AND s.supp_pr        IS NOT NULL
        ) THEN
            RAISE EXCEPTION 'Validation Failed: Linked Supply Address is missing or incomplete (Address, Zip, Town, or Province required).';
        END IF;

        -- CHECK 2: Ensure Payment Details exist for this person
        -- Assuming 'payment_details' table has a 'personnel_id' column
        IF NOT EXISTS (
            SELECT 1 
            FROM payment_details 
            WHERE personnel_id = NEW.id 
            AND iban IS NOT NULL
        ) THEN
            RAISE EXCEPTION 'Validation Failed: Cannot approve. No valid IBAN/Payment Details found for this record.';
        END IF;

        -- CHECK 3: Ensure an 'Invoice' document is linked
        -- Assuming 'document_details' table has a 'personnel_id' and 'type' column
        IF NOT EXISTS (
            SELECT 1 
            FROM document_details 
            WHERE personnel_id = NEW.id 
            AND document_type = 'invoice'
        ) THEN
            RAISE EXCEPTION 'Validation Failed: Cannot approve. The required "Invoice" document is missing.';
        END IF;

    END IF;

    -- If all checks pass, or if status isn't being set to 'Approved', allow the update
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 2. Bind the Trigger to the Personnel Table
-- We use DROP first so the script can be re-run safely
DROP TRIGGER IF EXISTS tr_ensure_personnel_ready_for_approval ON personnel_details;

CREATE TRIGGER tr_ensure_personnel_ready_for_approval
BEFORE UPDATE ON personnel_details
FOR EACH ROW
EXECUTE FUNCTION fn_validate_personnel_approval_requirements();
