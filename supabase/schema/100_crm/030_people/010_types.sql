CREATE TABLE IF NOT EXISTS "crm"."people__types" (
  "id"          uuid NOT NULL DEFAULT gen_random_uuid (),
  "name"        text NOT NULL,
  "description" text     NULL,
  CONSTRAINT people__types_pkey PRIMARY KEY ("id")
);

ALTER TABLE "crm"."people__types" ENABLE ROW LEVEL SECURITY;

-- CLS
REVOKE
  ALL
ON TABLE
  "crm"."people__types"
FROM
  "anon";

GRANT
  SELECT,
  REFERENCES,
  TRIGGER,
  TRUNCATE,
  MAINTAIN
ON TABLE
  "crm"."people__types"
TO
  "authenticated";

GRANT
  ALL
ON TABLE
  "crm"."people__types"
TO
  "service_role";

-- RLS
ALTER TABLE "crm"."people__types" ENABLE ROW LEVEL SECURITY;

CREATE POLICY
  "Enable read access for all users"
ON
  "crm"."people__types"
FOR SELECT
TO
  "authenticated"
USING (
  true
);

-- SEED
INSERT INTO "crm"."people__types" (
  "name",
  "description"
)
VALUES
  ('PRIVATE_CUSTOMER', NULL),
  ('BUSINESS_CUSTOMER', NULL),
  ('CONDOMINIUM', NULL),
  ('LEGAL_REP', NULL);
