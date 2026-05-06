CREATE TABLE IF NOT EXISTS "bms"."product__sectors" (
  "id"   uuid NOT NULL DEFAULT gen_random_uuid (),
  "name" text NOT NULL,
  CONSTRAINT product__sectors_pkey PRIMARY KEY ("id")
);

ALTER TABLE "bms"."product__sectors" ENABLE ROW LEVEL SECURITY;

-- CLS
REVOKE
  ALL
ON TABLE
  "bms"."product__sectors"
FROM
  "anon",
  "authenticated";

GRANT
  SELECT
ON TABLE
  "bms"."product__sectors"
TO
  "authenticated";

-- RLS
ALTER TABLE "bms"."product__sectors" ENABLE ROW LEVEL SECURITY;

CREATE POLICY
  "Enable read access for auth users"
ON
  "bms"."product__sectors"
FOR SELECT
TO
  "authenticated"
USING (
  true
);

-- SEED
INSERT INTO "bms"."product__sectors" (
  "name",
  "description"
)
VALUES
  ('Energy',            NULL),
  ('Telecommunication', NULL);
  ('Others',            NULL);
