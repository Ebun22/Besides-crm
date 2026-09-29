CREATE TABLE IF NOT EXISTS "bms"."product__channel" (
  "id"          uuid NOT NULL DEFAULT gen_random_uuid (),
  "name"        text NOT NULL,
  "description" text     NULL,
  CONSTRAINT product__channel_pkey PRIMARY KEY ("id")
);

ALTER TABLE "bms"."product__channel" ENABLE ROW LEVEL SECURITY;

-- CLS
REVOKE
  ALL
ON TABLE
  "bms"."product__channel"
FROM
  "anon",
  "authenticated";

GRANT
  SELECT
ON TABLE
  "bms"."product__channel"
TO
  "authenticated";

-- RLS
ALTER TABLE "bms"."product__channel" ENABLE ROW LEVEL SECURITY;

CREATE POLICY
  "Enable read access for auth users"
ON
  "bms"."product__channel"
FOR SELECT
TO
  "authenticated"
USING (
  true
);

-- SEED
INSERT INTO "bms"."product__channel" (
  "name",
  "description"
)
VALUES
  ('Fixed',      NULL),
  ('Mobile',     NULL),
  ('Convergent', NULL);
