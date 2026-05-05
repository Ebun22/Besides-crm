CREATE TABLE IF NOT EXISTS "bms"."product__operazione__sub_category" (
  "id"              uuid NOT NULL DEFAULT gen_random_uuid (),
  "name"            text NOT NULL,
  "parent_category" uuid NOT NULL,
  "description"     text     NULL,
  CONSTRAINT product__operazione__sub_category_pkey PRIMARY KEY ("id")
);

ALTER TABLE "bms"."product__operazione__sub_category" ENABLE ROW LEVEL SECURITY;

-- CLS
REVOKE
  ALL
ON TABLE
  "bms"."product__operazione__sub_category"
FROM
  "anon",
  "authenticated";

GRANT
  SELECT
ON TABLE
  "bms"."product__operazione__sub_category"
TO
  "authenticated";

-- RLS
ALTER TABLE "bms"."product__operazione__sub_category" ENABLE ROW LEVEL SECURITY;

CREATE POLICY
  "Enable read access for auth users"
ON
  "bms"."product__operazione__sub_category"
FOR SELECT
TO
  "authenticated"
USING (
  true
);

-- SEED
INSERT INTO "bms"."product__operazione__sub_category" (
  "name",
  "parent_category",
  "description",
)
VALUES
  ('Switch with concurrent transfer of ownership', (SELECT id FROM "bms"."product__operazione" WHERE "name" = 'Extra Switch'), NULL),
  ('Taking over',                                  (SELECT id FROM "bms"."product__operazione" WHERE "name" = 'Extra Switch'), NULL),
  ('Activation with installation',                 (SELECT id FROM "bms"."product__operazione" WHERE "name" = 'Extra Switch'), NULL),
  ('Activation on pre-installed Line',             (SELECT id FROM "bms"."product__operazione" WHERE "name" = 'Extra Switch'), NULL);
