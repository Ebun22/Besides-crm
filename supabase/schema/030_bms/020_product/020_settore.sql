CREATE TABLE IF NOT EXISTS "bms"."product__settore" (
  "id"   uuid NOT NULL DEFAULT gen_random_uuid (),
  "name" text NOT NULL,
  CONSTRAINT product__settore_pkey PRIMARY KEY ("id")
);

ALTER TABLE "bms"."product__settore" ENABLE ROW LEVEL SECURITY;

-- CLS
REVOKE
  ALL
ON TABLE
  "bms"."product__settore"
FROM
  "anon",
  "authenticated";

GRANT
  SELECT
ON TABLE
  "bms"."product__settore"
TO
  "authenticated";

-- RLS
ALTER TABLE "bms"."product__settore" ENABLE ROW LEVEL SECURITY;

CREATE POLICY
  "Enable read access for auth users"
ON
  "bms"."product__settore"
FOR SELECT
TO
  "authenticated"
USING (
  true
);

-- SEED
INSERT INTO "bms"."product__settore" (
  "name",
  "description"
)
VALUES
  ('Energy',            NULL),
  ('Telecommunication', NULL);
  ('Others',            NULL);
