CREATE TABLE IF NOT EXISTS "public"."permission__roles" (
  "id"          uuid NOT NULL DEFAULT gen_random_uuid (),
  "name"        text NOT NULL,
  "description" text     NULL,
  CONSTRAINT pemission_roles_pkey PRIMARY KEY ("id")
);

ALTER TABLE "public"."permission__roles" OWNER TO "postgres";

-- CLS
REVOKE
  ALL
ON TABLE "public"."permission__roles"
FROM
  "anon";

GRANT
  SELECT,
  REFERENCES,
  TRIGGER,
  TRUNCATE,
  MAINTAIN
ON TABLE "public"."permission__roles" 
TO
  "authenticated";

GRANT
  ALL
ON TABLE "public"."permission__roles"
TO
  "service_role";

-- RLS
ALTER TABLE "public"."permission__roles" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Enable read access for all users"
ON
  "public"."permission__roles"
FOR SELECT
TO
  "authenticated"
USING (
  true
);

-- SEED
INSERT INTO "public"."permission__roles"
(
  "name",
  "description"
)
VALUES
 ('Admin',      NULL),
 ('Consultant', NULL);
