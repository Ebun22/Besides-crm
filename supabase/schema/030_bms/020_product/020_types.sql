CREATE TABLE IF NOT EXISTS "bms"."product__types" (
  "id"          uuid NOT NULL DEFAULT gen_random_uuid (),
  "name"        text NOT NULL,
  "description" text     NULL,
  CONSTRAINT product__type_pkey PRIMARY KEY ("id")
);

ALTER TABLE "bms"."product__types" ENABLE ROW LEVEL SECURITY;

-- CLS
REVOKE
  ALL
ON TABLE
  "bms"."product__types"
FROM
  "anon",
  "authenticated";

GRANT
  SELECT
ON TABLE
  "bms"."product__types"
TO
  "authenticated";

-- RLS
ALTER TABLE "bms"."product__types" ENABLE ROW LEVEL SECURITY;

CREATE POLICY
  "Enable read access for auth users"
ON
  "bms"."product__types"
FOR SELECT
TO
  "authenticated"
USING (
  true
);

-- SEED
INSERT INTO "bms"."product__types" (
  "name",
  "description"
)
VALUES
  ('Electric',          NULL),
  ('Gas',               NULL),
  ('Telecommunication', NULL);
