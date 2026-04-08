CREATE TABLE IF NOT EXISTS "public"."people__ID_types" (
  "id"          uuid NOT NULL DEFAULT gen_random_uuid (),
  "name"        text NOT NULL,
  "description" text     NULL,
  CONSTRAINT people__ID_types_pkey PRIMARY KEY ("id")
);

ALTER TABLE "public"."people__ID_types" ENABLE ROW LEVEL SECURITY;

-- CLS
REVOKE
  ALL
ON TABLE
  "public"."people__ID_types"
FROM
  "anon";

GRANT
  SELECT,
  REFERENCES,
  TRIGGER,
  TRUNCATE,
  MAINTAIN
ON TABLE
  "public"."people__ID_types"
TO
  "authenticated";

GRANT
  ALL
ON TABLE
  "public"."people__ID_types"
TO
  "service_role";

-- RLS
ALTER TABLE "public"."people__ID_types" ENABLE ROW LEVEL SECURITY;

CREATE POLICY
  "Enable read access for all users"
ON
  "public"."people__ID_types"
FOR SELECT
TO
  "authenticated"
USING (
  true
);

-- SEED
INSERT INTO "public"."people__ID_types" (
  "name",
  "description"
)
VALUES
  ('Passport', NULL),
  ('ID Card', NULL);
