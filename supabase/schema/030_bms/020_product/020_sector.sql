CREATE TABLE IF NOT EXISTS "bms"."product__sector" (
  "id"   uuid NOT NULL DEFAULT gen_random_uuid (),
  "name" text NOT NULL,
  CONSTRAINT product__sector_pkey PRIMARY KEY ("id")
);

ALTER TABLE "bms"."product__sector" ENABLE ROW LEVEL SECURITY;

-- CLS
REVOKE
  ALL
ON TABLE
  "bms"."product__sector"
FROM
  "anon",
  "authenticated";

GRANT
  SELECT
ON TABLE
  "bms"."product__sector"
TO
  "authenticated";

-- RLS
ALTER TABLE "bms"."product__sector" ENABLE ROW LEVEL SECURITY;

CREATE POLICY
  "Enable read access for auth users"
ON
  "bms"."product__sector"
FOR SELECT
TO
  "authenticated"
USING (
  true
);

-- SEED
INSERT INTO "bms"."product__sector" (
  "name",
  "description"
)
VALUES
  ('Energy',            NULL),
  ('Telecommunication', NULL);
  ('Others',            NULL);
