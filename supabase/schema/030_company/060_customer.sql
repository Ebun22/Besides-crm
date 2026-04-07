CREATE TABLE IF NOT EXISTS "public"."customer__company" (
  "id"       uuid NOT NULL DEFAULT gen_random_uuid (),
  "cust_ref" uuid NOT NULL,
  "comp_ref" uuid NOT NULL,
  CONSTRAINT customer__company_pkey          PRIMARY KEY ("id"),
  CONSTRAINT customer__company_cust_ref_fkey FOREIGN KEY ("cust_ref") 
    REFERENCES customer__details (id) 
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT customer__company_comp_ref_fkey FOREIGN KEY ("comp_ref") 
    REFERENCES company__details (id) 
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

ALTER TABLE "public"."customer__company" OWNER TO "postgres";

REVOKE
  ALL
ON TABLE
  "public"."customer__company"
FROM
  "anon";

GRANT
  ALL
ON TABLE
  "public"."customer__company"
TO
  "authenticated",
  "service_role";

-- RLS
ALTER TABLE "public"."customer__company" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Enable read access for all users"
ON
  "public"."customer__company"
FOR SELECT
TO
 "authenticated"
USING (
  true
);

CREATE POLICY "Enable insert for authenticated users only"
ON
  "public"."customer__company"
FOR INSERT
TO
  "authenticated"
WITH CHECK (
  true
);

ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."customer__company";