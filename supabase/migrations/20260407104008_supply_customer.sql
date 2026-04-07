CREATE TABLE IF NOT EXISTS "public"."supply__address__customer" (
  "id"       uuid NOT NULL DEFAULT gen_random_uuid (),
  "supp_ref" uuid NOT NULL,
  "cust_ref" uuid NOT NULL,
  CONSTRAINT supply__address__customer_pkey     PRIMARY KEY ("id"),
  CONSTRAINT supply__address_ref_fkey           FOREIGN KEY ("supp_ref")
    REFERENCES supply__address__customer_details ("id")
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT supply__address__customer_ref_fkey FOREIGN KEY ("cust_ref")
    REFERENCES people__details ("id")
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

ALTER TABLE "public"."customer__supply_details" OWNER TO "postgres";

-- CLS
REVOKE
  ALL
ON TABLE
  "public"."customer__supply_details"
TO
  "anon";

GRANT
  ALL
ON TABLE
  "public"."customer__supply_details"
TO
  "authenticated",
  "service_role";

-- RLS
ALTER TABLE "public"."customer__supply_details" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Enable insert for authenticated users only"
ON
  "public"."customer__supply_details"
FOR INSERT
TO
  "authenticated"
WITH CHECK (
  true
);

CREATE POLICY "Enable read access for all users"
ON
  "public"."customer__supply_details"
FOR SELECT
TO
  "authenticated"
USING (
  true
);

-- TODO: add update policy
