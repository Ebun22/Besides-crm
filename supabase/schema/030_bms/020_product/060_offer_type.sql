CREATE TABLE IF NOT EXISTS "bms"."product__offer_type" (
  "id"   uuid NOT NULL DEFAULT gen_random_uuid (),
  "name" text NOT NULL,
  CONSTRAINT product__offer_type_pkey PRIMARY KEY ("id")
);

ALTER TABLE "bms"."product__offer_type" ENABLE ROW LEVEL SECURITY;

-- CLS
REVOKE
  ALL
ON TABLE
  "bms"."product__offer_type"
FROM
  "anon",
  "authenticated";

GRANT
  SELECT
ON TABLE
  "bms"."product__offer_type"
TO
  "authenticated";

-- RLS
ALTER TABLE "bms"."product__offer_type" ENABLE ROW LEVEL SECURITY;

CREATE POLICY
  "Enable read access for auth users"
ON
  "bms"."product__offer_type"
FOR SELECT
TO
  "authenticated"
USING (
  true
);

-- SEED
INSERT INTO "bms"."product__offer_type" (
  "name",
  "description"
)
VALUES
  ('Fixed price',    NULL),
  ('Variable price', NULL);
  ('Other',          NULL);
