CREATE TABLE IF NOT EXISTS "public"."permission__role_actions" (
  "id"        uuid NOT NULL DEFAULT gen_random_uuid (),
  "role_id"   uuid NOT NULL,
  "action_id" uuid NOT NULL,
  CONSTRAINT permission__role_actions_pkey PRIMARY KEY ("id")
);

ALTER TABLE "public"."permission__role_actions" OWNER TO "postgres";

ALTER TABLE "public"."permission__role_actions" ENABLE ROW LEVEL SECURITY;

-- CLS
REVOKE
  ALL
ON TABLE
  "public"."permission__role_actions"
FROM
  "anon";

GRANT
  SELECT,
  REFERENCES,
  TRIGGER,
  TRUNCATE,
  MAINTAIN
ON TABLE
  "public"."permission__role_actions"
TO
  "authenticated";

GRANT
  ALL
ON TABLE
  "public"."permission__role_actions"
TO
  "service_role";

-- RLS
CREATE POLICY
  "Enable read access for all users"
ON
  "public"."permission__role_actions"
FOR SELECT
TO
  "authenticated"
USING (
  true
);
