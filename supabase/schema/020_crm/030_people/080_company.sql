CREATE TABLE IF NOT EXISTS "crm"."people__company" (
  "id"       uuid NOT NULL DEFAULT gen_random_uuid (),
  "cust_ref" uuid NOT NULL,
  "comp_ref" uuid NOT NULL,
  CONSTRAINT people__company_pkey          PRIMARY KEY ("id"),
  CONSTRAINT people__company_cust_ref_fkey FOREIGN KEY ("cust_ref")
    REFERENCES "crm"."people__details" ("id")
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT people__company_comp_ref_fkey FOREIGN KEY ("comp_ref")
    REFERENCES "crm"."company__details" ("id")
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

ALTER TABLE "crm"."people__company" OWNER TO "postgres";

REVOKE
  ALL
ON TABLE
  "crm"."people__company"
FROM
  "anon";

GRANT
  ALL
ON TABLE
  "crm"."people__company"
TO
  "authenticated",
  "service_role";

-- RLS
ALTER TABLE "crm"."people__company" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Enable read access for all users"
ON
  "crm"."people__company"
FOR SELECT
TO
 "authenticated"
USING (
  true
);

CREATE POLICY "Enable insert for authenticated users only"
ON
  "crm"."people__company"
FOR INSERT
TO
  "authenticated"
WITH CHECK (
  true
);

ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "crm"."people__company";