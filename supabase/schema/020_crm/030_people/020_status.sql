CREATE TABLE IF NOT EXISTS "crm"."people__status" (
  "id"          uuid NOT NULL DEFAULT gen_random_uuid (),
  "name"        text NOT NULL,
  "description" text     NULL,
  CONSTRAINT people__status_pkey PRIMARY KEY ("id")
);

ALTER TABLE "crm"."people__status" OWNER TO "postgres";

ALTER TABLE "crm"."people__status" ENABLE ROW LEVEL SECURITY;

-- CLS
REVOKE
  ALL
ON TABLE
  "crm"."people__status"
FROM
  "anon";

GRANT
  ALL
ON TABLE
  "crm"."people__status"
TO
  "authenticated";

GRANT
  ALL
ON TABLE
  "crm"."people__status"
TO
  "service_role";

-- RLS
CREATE POLICY
  "Enable read access for all users"
ON
  "crm"."people__status"
FOR SELECT
TO
  "authenticated"
USING (
  true
);

-- SEED
INSERT INTO "crm"."people__status" (
  "name",
  "description"
)
VALUES
  ('DRAFT', NULL),
  ('APPROVED', NULL);
