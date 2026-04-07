CREATE TABLE IF NOT EXISTS "public"."ID__types" (
  "id"          uuid NOT NULL DEFAULT gen_random_uuid (),
  "name"        text NOT NULL,
  "description" text     NULL,
  CONSTRAINT ID__types_pkey PRIMARY KEY ("id")
);

ALTER TABLE "public"."ID__types" ENABLE ROW LEVEL SECURITY;

-- CLS
REVOKE
  ALL
ON TABLE
  "public"."ID__types"
FROM
  "anon";

GRANT
  SELECT,
  REFERENCES,
  TRIGGER,
  TRUNCATE,
  MAINTAIN
ON TABLE
  "public"."ID__types"
TO
  "authenticated";

GRANT
  ALL
ON TABLE
  "public"."ID__types"
TO
  "service_role";

-- RLS
ALTER TABLE "public"."ID__types" ENABLE ROW LEVEL SECURITY;

CREATE POLICY
  "Enable read access for all users"
ON
  "public"."ID__types"
FOR SELECT
TO
  "authenticated"
USING (
  true
);

-- SEED
INSERT INTO "public"."ID__types" (
  "name",
  "description"
)
VALUES
  ('Passport', NULL),
  ('ID Card', NULL);
