CREATE TABLE IF NOT EXISTS "bms"."document__product" (
  "id"          uuid NOT NULL DEFAULT gen_random_uuid (),
  "product"     uuid NOT NULL,
  "customer"    uuid NOT NULL,
  CONSTRAINT document__product_pkey PRIMARY KEY ("id")
  CONSTRAINT document__product_customer_fkey FOREIGN KEY ("customer")
    REFERENCES "crm"."people__details" ("id")
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

ALTER TABLE "bms"."document__product" OWNER TO "postgres";

-- CLS
REVOKE
  ALL
ON TABLE
  "bms"."document__product"
FROM
  "anon",
  "authenticated";

GRANT
  ALL
ON TABLE
  "bms"."document__product"
TO
  "authenticated",
  "service_role";

-- RLS
ALTER TABLE "bms"."document__product" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Enable insert for authenticated users only"
ON
  "bms"."document__product"
FOR INSERT
TO
  "authenticated"
WITH CHECK (
  true
);

CREATE POLICY "Enable read access for all users"
ON
  "bms"."document__product"
FOR SELECT
TO
  "authenticated"
USING (
  true
);

-- TODO: add update policy
