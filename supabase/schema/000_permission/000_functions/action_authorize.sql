CREATE OR REPLACE FUNCTION "public"."permission__action_authorize"
(
  "requested_action" "text"
)
RETURNS boolean
LANGUAGE "plpgsql" STABLE
SECURITY DEFINER
SET "search_path"
TO 'public'
AS
$$
DECLARE
  user_roles          uuid[];
  requested_action_id uuid;
  bind_permissions    int;
BEGIN
  -- Get the ID of the requested action based on its name
  SELECT id
  INTO requested_action_id
  FROM "public"."permission__actions"
  WHERE name = requested_action;

  -- If no such action found, deny access
  IF requested_action_id IS NULL THEN
    RAISE LOG 'WARNING: role action does not exist';
    RETURN false;
  END IF;

  -- Get all role_ids for the current user
  SELECT array_agg(role_id)
  INTO user_roles
  FROM "public"."permission__user_roles"
  WHERE "user" = auth.uid();

  -- If the user has no roles, deny access
  IF user_roles IS NULL THEN
    RETURN false;
  END IF;

  -- Check if any of the user's roles are authorized for the action
  SELECT count(*)
  INTO bind_permissions
  FROM "public"."permission__role_actions"
  WHERE "role" = any(user_roles)
    AND action_id = requested_action_id;

  RETURN bind_permissions > 0;
END;
$$;

ALTER FUNCTION "public"."permission__action_authorize"
(
  "requested_action" "text"
) OWNER TO "postgres";
