CREATE TABLE IF NOT EXISTS "public"."permission__role_actions" (
  "id"        uuid NOT NULL DEFAULT gen_random_uuid (),
  "role_id"   uuid NOT NULL,
  "action_id" uuid NOT NULL,
  CONSTRAINT permission__role_actions_pkey           PRIMARY KEY ("id"),
  CONSTRAINT permission__role_actions_role_id_fkey   FOREIGN KEY ("role_id")
    REFERENCES "public"."permission__roles" ("id")
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT permission__role_actions_action_id_fkey FOREIGN KEY ("action_id")
    REFERENCES "public"."permission__actions" ("id")
    ON UPDATE CASCADE
    ON DELETE CASCADE
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

-- SEED
INSERT INTO "public"."permission__role_actions"
(
  "role_id",
  "action_id"
)
VALUES
  ((SELECT id FROM "public"."permission__roles" WHERE role = 'Consultant'), (SELECT id FROM "public"."permission__actions" WHERE name = 'global.create')),
  ((SELECT id FROM "public"."permission__roles" WHERE role = 'Consultant'), (SELECT id FROM "public"."permission__actions" WHERE name = 'global.update')),
  ((SELECT id FROM "public"."permission__roles" WHERE role = 'Consultant'), (SELECT id FROM "public"."permission__actions" WHERE name = 'global.delete')),
  ((SELECT id FROM "public"."permission__roles" WHERE role = 'Consultant'), (SELECT id FROM "public"."permission__actions" WHERE name = 'status.approve'));