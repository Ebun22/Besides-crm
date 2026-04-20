CREATE TABLE IF NOT EXISTS "public"."permission__user_roles" (
  "id"   uuid NOT NULL DEFAULT gen_random_uuid (),
  "user" uuid NOT NULL DEFAULT "auth"."uid"(),
  "role" uuid NOT NULL,
  CONSTRAINT permission__user_roles_pkey PRIMARY KEY ("id"),
  CONSTRAINT permission__user_roles_user_fkey FOREIGN KEY ("user")
    REFERENCES "auth"."users" ("id")
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT permission__user_roles_role_fkey FOREIGN KEY ("role")
    REFERENCES "public"."permission__roles" ("id")
    ON UPDATE CASCADE
    ON DELETE CASCADE
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


CREATE OR REPLACE FUNCTION "public"."auto_assign_consultant_role"()
RETURNS TRIGGER
AS $$
DECLARE
  v_role_id uuid;
BEGIN
  IF NEW.email = 'roldofo@besides.com' THEN
    SELECT id INTO v_role_id
    FROM "public"."permission__roles"
    WHERE "name" = 'Consultant'
    LIMIT 1;

    IF v_role_id IS NOT NULL THEN
      INSERT INTO "public"."permission__user_roles"
      (
        "user_id",
        "role_id"
      )
      VALUES
        (NEW.id, v_role_id)
      ON CONFLICT DO NOTHING;
    END IF;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE TRIGGER trg_auto_assign_consultant_role
AFTER INSERT ON "auth"."users"
FOR EACH ROW
EXECUTE FUNCTION "public"."auto_assign_consultant_role"();
