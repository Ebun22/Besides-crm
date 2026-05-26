CREATE TABLE IF NOT EXISTS "bms"."product__offer_types" (
  "id"          uuid NOT NULL DEFAULT gen_random_uuid (),
  "name"        text NOT NULL,
  "description" text     NULL,
  CONSTRAINT product__offer_types_pkey PRIMARY KEY ("id")
);

ALTER TABLE "bms"."product__offer_types" ENABLE ROW LEVEL SECURITY;

-- CLS
REVOKE
  ALL
ON TABLE
  "bms"."product__offer_types"
FROM
  "anon",
  "authenticated";

GRANT
  SELECT
ON TABLE
  "bms"."product__offer_types"
TO
  "authenticated";

-- RLS
ALTER TABLE "bms"."product__offer_types" ENABLE ROW LEVEL SECURITY;

CREATE POLICY
  "Enable read access for auth users"
ON
  "bms"."product__offer_types"
FOR SELECT
TO
  "authenticated"
USING (
  true
);

-- SEED
INSERT INTO "bms"."product__offer_types" (
  "name",
  "description"
)
VALUES
  ('Fixed price',    NULL),
  ('Variable price', NULL),
  ('Other',          NULL);
