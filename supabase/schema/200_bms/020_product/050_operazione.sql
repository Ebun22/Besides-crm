CREATE TABLE IF NOT EXISTS "bms"."product__operazione" (
  "id"           uuid    NOT NULL DEFAULT gen_random_uuid (),
  "name"         text    NOT NULL,
  "sub_category" boolean NOT NULL DEFAULT FALSE,
  "description"  text        NULL,
  CONSTRAINT product__operazione_pkey PRIMARY KEY ("id")
);

ALTER TABLE "bms"."product__operazione" ENABLE ROW LEVEL SECURITY;

-- CLS
REVOKE
  ALL
ON TABLE
  "bms"."product__operazione"
FROM
  "anon",
  "authenticated";

GRANT
  SELECT
ON TABLE
  "bms"."product__operazione"
TO
  "authenticated";

-- RLS
ALTER TABLE "bms"."product__operazione" ENABLE ROW LEVEL SECURITY;

CREATE POLICY
  "Enable read access for auth users"
ON
  "bms"."product__operazione"
FOR SELECT
TO
  "authenticated"
USING (
  true
);

-- SEED
INSERT INTO "bms"."product__operazione" (
  "name",
  "sub_category",
  "description",
)
VALUES
  ('Switch-in',       FALSE, NULL),
  ('Extra Switch',    TRUE,  NULL),
  ('MNP',             FALSE, NULL),
  ('GNP',             FALSE, NULL),
  ('New mobile line', FALSE, NULL),
  ('New fixed line',  FALSE, NULL);
