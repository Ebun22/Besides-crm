CREATE TABLE IF NOT EXISTS "bms"."product__operazione" (
  "id"             uuid    NOT NULL DEFAULT gen_random_uuid (),
  "name"           text    NOT NULL,
  "subcategory"    boolean NOT NULL DEFAULT FALSE,
  "description"    text        NULL,
  "service_sector" uuid        NULL,
  CONSTRAINT product__operazione_pkey                PRIMARY KEY ("id"),
  CONSTRAINT product__operazione_service_sector_fkey FOREIGN KEY ("service_sector")
    REFERENCES "bms"."product__settore" ("id")
    ON UPDATE CASCADE
    ON DELETE CASCADE
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
  "subcategory",
  "description"
)
VALUES
  ('Switch-in',       FALSE, NULL),
  ('Extra Switch',    TRUE,  NULL),
  ('MNP',             FALSE, NULL),
  ('GNP',             FALSE, NULL),
  ('New mobile line', FALSE, NULL),
  ('New fixed line',  FALSE, NULL);
