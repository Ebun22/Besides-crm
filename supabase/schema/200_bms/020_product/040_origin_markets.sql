CREATE TABLE IF NOT EXISTS "bms"."product__origin_market" (
  "id"           uuid NOT NULL DEFAULT gen_random_uuid (),
  "name"         text NOT NULL,
  "settore_type" uuid NOT NULL,
  "description"  text     NULL,
  CONSTRAINT product__origin_market_pkey PRIMARY KEY ("id")
);

ALTER TABLE "bms"."product__origin_market" ENABLE ROW LEVEL SECURITY;

-- CLS
REVOKE
  ALL
ON TABLE
  "bms"."product__origin_market"
FROM
  "anon",
  "authenticated";

GRANT
  SELECT
ON TABLE
  "bms"."product__origin_market"
TO
  "authenticated";

-- RLS
ALTER TABLE "bms"."product__origin_market" ENABLE ROW LEVEL SECURITY;

CREATE POLICY
  "Enable read access for auth users"
ON
  "bms"."product__origin_market"
FOR SELECT
TO
  "authenticated"
USING (
  true
);

-- SEED
INSERT INTO "bms"."product__origin_market" (
  "name",
  "settore_type",
  "description"
)
VALUES
  ('Free',                             (SELECT id FROM "bms"."product__settore___types" WHERE "name" = 'Gas'),      NULL),
  ('Fornitore di Ultima Istanza (FUI)',(SELECT id FROM "bms"."product__settore___types" WHERE "name" = 'Gas'),      NULL),
  ('Free',                             (SELECT id FROM "bms"."product__settore___types" WHERE "name" = 'Electric'), NULL),
  ('Gradual Protections Service',      (SELECT id FROM "bms"."product__settore___types" WHERE "name" = 'Electric'), NULL),
  ('Standard Offer Service',           (SELECT id FROM "bms"."product__settore___types" WHERE "name" = 'Electric'), NULL),
  ('Safeguard Service',                (SELECT id FROM "bms"."product__settore___types" WHERE "name" = 'Electric'), NULL);
