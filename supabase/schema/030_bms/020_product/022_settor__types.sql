CREATE TABLE IF NOT EXISTS "bms"."product__settore___types" (
  "id"            uuid NOT NULL DEFAULT gen_random_uuid (),
  "name"          text NOT NULL,
  "parent_sector" uuid NOT NULL,
  "description"   text     NULL,
  CONSTRAINT product__settore__type_pkey PRIMARY KEY ("id")
);

ALTER TABLE "bms"."product__settore___types" ENABLE ROW LEVEL SECURITY;

-- CLS
REVOKE
  ALL
ON TABLE
  "bms"."product__settore___types"
FROM
  "anon",
  "authenticated";

GRANT
  SELECT
ON TABLE
  "bms"."product__settore___types"
TO
  "authenticated";

-- RLS
ALTER TABLE "bms"."product__settore___types" ENABLE ROW LEVEL SECURITY;

CREATE POLICY
  "Enable read access for auth users"
ON
  "bms"."product__settore___types"
FOR SELECT
TO
  "authenticated"
USING (
  true
);

-- SEED
INSERT INTO "bms"."product__settore___types" (
  "name",
  "parent_sector",
  "description"
)
VALUES
  ('Electric', (SELECT id FROM "bms"."product__sector" WHERE "name" = 'Energy'), NULL),
  ('Gas',      (SELECT id FROM "bms"."product__sector" WHERE "name" = 'Energy'), NULL);
