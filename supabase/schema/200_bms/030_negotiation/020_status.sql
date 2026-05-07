CREATE TABLE IF NOT EXISTS "bms"."negotiation__status" (
  "id"          uuid NOT NULL DEFAULT gen_random_uuid (),
  "name"        text NOT NULL,
  "description" text     NULL,
  CONSTRAINT negotiation__status_pkey PRIMARY KEY ("id")
);

ALTER TABLE "bms"."negotiation__status" ENABLE ROW LEVEL SECURITY;

-- CLS
REVOKE
  ALL
ON TABLE
  "bms"."negotiation__status"
FROM
  "anon",
  "authenticated";

GRANT
  SELECT
ON TABLE
  "bms"."negotiation__status"
TO
  "authenticated";

-- RLS
ALTER TABLE "bms"."negotiation__status" ENABLE ROW LEVEL SECURITY;

CREATE POLICY
  "Enable read access for auth users"
ON
  "bms"."negotiation__status"
FOR SELECT
TO
  "authenticated"
USING (
  true
);

-- SEED
INSERT INTO "bms"."negotiation__status" (
  "name",
  "description"
)
VALUES
  ('DRAFT',    NULL),
  ('APPROVED', NULL);
