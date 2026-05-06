CREATE TABLE IF NOT EXISTS "bms"."negotiation__tipo_lead" (
  "id"          uuid NOT NULL DEFAULT gen_random_uuid (),
  "name"        text NOT NULL,
  "description" text     NULL,
  CONSTRAINT negotiation__tipo_lead_pkey PRIMARY KEY ("id")
);

ALTER TABLE "bms"."negotiation__tipo_lead" ENABLE ROW LEVEL SECURITY;

-- CLS
REVOKE
  ALL
ON TABLE
  "bms"."negotiation__tipo_lead"
FROM
  "anon",
  "authenticated";

GRANT
  SELECT
ON TABLE
  "bms"."negotiation__tipo_lead"
TO
  "authenticated";

-- RLS
ALTER TABLE "bms"."negotiation__tipo_lead" ENABLE ROW LEVEL SECURITY;

CREATE POLICY
  "Enable read access for auth users"
ON
  "bms"."negotiation__tipo_lead"
FOR SELECT
TO
  "authenticated"
USING (
  true
);

-- SEED
INSERT INTO "bms"."negotiation__tipo_lead" (
  "name",
  "description"
)
VALUES
  ('New',     NULL),
  ('Renewal', NULL);
