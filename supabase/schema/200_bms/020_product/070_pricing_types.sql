CREATE TABLE IF NOT EXISTS "bms"."product__pricing_types" (
  "id"          uuid NOT NULL DEFAULT gen_random_uuid (),
  "name"        text NOT NULL,
  "description" text     NULL,
  CONSTRAINT product__pricing_types_pkey PRIMARY KEY ("id")
);

ALTER TABLE "bms"."product__pricing_types" ENABLE ROW LEVEL SECURITY;

-- CLS
REVOKE
  ALL
ON TABLE
  "bms"."product__pricing_types"
FROM
  "anon",
  "authenticated";

GRANT
  SELECT
ON TABLE
  "bms"."product__pricing_types"
TO
  "authenticated";

-- RLS
ALTER TABLE "bms"."product__pricing_types" ENABLE ROW LEVEL SECURITY;

CREATE POLICY
  "Enable read access for auth users"
ON
  "bms"."product__pricing_types"
FOR SELECT
TO
  "authenticated"
USING (
  true
);

-- SEED
INSERT INTO "bms"."product__pricing_types" (
  "name",
  "description"
)
VALUES
  ('Fixed price',    NULL),
  ('Variable price', NULL),
  ('Other',          NULL);
