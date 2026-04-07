CREATE TABLE IF NOT EXISTS "public"."permission__user_roles" (
  "id"   uuid NOT NULL DEFAULT gen_random_uuid (),
  "user" uuid NOT NULL,
  "role" uuid NOT NULL,
  CONSTRAINT permission__user_roles_pkey PRIMARY KEY ("id")
);

ALTER TABLE "public"."permission__user_roles" ENABLE ROW LEVEL SECURITY;

-- CLS
REVOKE
  ALL
ON TABLE
  "public"."permission__user_roles"
FROM
  "anon";

GRANT
  SELECT,
  REFERENCES,
  TRIGGER,
  TRUNCATE,
  MAINTAIN
ON TABLE
  "public"."permission__user_roles"
TO
  "authenticated";

GRANT
  ALL
ON TABLE
  "public"."permission__user_roles"
TO
  "service_role";

-- RLS
ALTER TABLE "public"."permission__user_roles" ENABLE ROW LEVEL SECURITY;

CREATE POLICY
  "Enable read access for all users"
ON
  "public"."permission__user_roles"
FOR SELECT
TO
  "authenticated"
USING (
  true
);
