CREATE TABLE IF NOT EXISTS "public"."people__supply__address" (
  "id"       uuid NOT NULL DEFAULT gen_random_uuid (),
  "supp_ref" uuid NOT NULL,
  "cust_ref" uuid NOT NULL,
  CONSTRAINT people__supply__address_pkey     PRIMARY KEY ("id"),
  CONSTRAINT supply__address_ref_fkey           FOREIGN KEY ("supp_ref")
    REFERENCES supply__address ("id")
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT supply__address__cust_ref_fkey FOREIGN KEY ("cust_ref")
    REFERENCES people__details ("id")
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

ALTER TABLE "public"."people__supply__address" OWNER TO "postgres";

-- CLS
REVOKE
  ALL
ON TABLE
  "public"."people__supply__address"
FROM
  "anon";

GRANT
  ALL
ON TABLE
  "public"."people__supply__address"
TO
  "authenticated",
  "service_role";

-- RLS
ALTER TABLE "public"."people__supply__address" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Enable insert for authenticated users only"
ON
  "public"."people__supply__address"
FOR INSERT
TO
  "authenticated"
WITH CHECK (
  true
);

CREATE POLICY "Enable read access for all users"
ON
  "public"."people__supply__address"
FOR SELECT
TO
  "authenticated"
USING (
  true
);

-- TODO: add update policy
