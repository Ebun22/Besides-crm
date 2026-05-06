CREATE TABLE IF NOT EXISTS "crm"."people__ID_types" (
  "id"          uuid NOT NULL DEFAULT gen_random_uuid (),
  "name"        text NOT NULL,
  "description" text     NULL,
  CONSTRAINT people__ID_types_pkey PRIMARY KEY ("id")
);

ALTER TABLE "crm"."people__ID_types" ENABLE ROW LEVEL SECURITY;

-- CLS
REVOKE
  ALL
ON TABLE
  "crm"."people__ID_types"
FROM
  "anon";

GRANT
  SELECT,
  REFERENCES,
  TRIGGER,
  TRUNCATE,
  MAINTAIN
ON TABLE
  "crm"."people__ID_types"
TO
  "authenticated";

GRANT
  ALL
ON TABLE
  "crm"."people__ID_types"
TO
  "service_role";

-- RLS
ALTER TABLE "crm"."people__ID_types" ENABLE ROW LEVEL SECURITY;

CREATE POLICY
  "Enable read access for all users"
ON
  "crm"."people__ID_types"
FOR SELECT
TO
  "authenticated"
USING (
  true
);

-- SEED
INSERT INTO "crm"."people__ID_types" (
  "name",
  "description"
)
VALUES
  ('Passport', NULL),
  ('ID Card', NULL);
