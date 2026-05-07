CREATE TABLE IF NOT EXISTS "bms"."product__negotiation__customer" (
  "id"          uuid NOT NULL DEFAULT gen_random_uuid (),
  "product"     uuid NOT NULL,
  "negotiation" uuid NOT NULL,
  "customer"    uuid NOT NULL,
  CONSTRAINT product__negotiation__customer_pkey PRIMARY KEY ("id")
  CONSTRAINT product__negotiation__customer_neg_fkey     FOREIGN KEY ("negotiation")
    REFERENCES "bms"."negotiation__details" ("id")
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT product__negotiation__customer_product_fkey FOREIGN KEY ("customer")
    REFERENCES "crm"."people__details" ("id")
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

ALTER TABLE "bms"."product__negotiation__customer" OWNER TO "postgres";

-- CLS
REVOKE
  ALL
ON TABLE
  "bms"."product__negotiation__customer"
FROM
  "anon",
  "authenticated";

GRANT
  ALL
ON TABLE
  "bms"."product__negotiation__customer"
TO
  "authenticated",
  "service_role";

-- RLS
ALTER TABLE "bms"."product__negotiation__customer" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Enable insert for authenticated users only"
ON
  "bms"."product__negotiation__customer"
FOR INSERT
TO
  "authenticated"
WITH CHECK (
  true
);

CREATE POLICY "Enable read access for all users"
ON
  "bms"."product__negotiation__customer"
FOR SELECT
TO
  "authenticated"
USING (
  true
);

-- TODO: add update policy
