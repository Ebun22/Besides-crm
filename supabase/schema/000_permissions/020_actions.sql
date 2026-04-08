CREATE TABLE IF NOT EXISTS "public"."permission__actions" (
  "id"          uuid NOT NULL DEFAULT gen_random_uuid(),
  "action"      text NOT NULL,
  "description" text NULL,
  CONSTRAINT permission__actions_pkey PRIMARY KEY ("id")
);

ALTER TABLE "public"."permission__actions" OWNER TO "postgres";

-- CLS
REVOKE
  ALL
ON TABLE
  "public"."permission__actions"
FROM
 "anon";

GRANT
  SELECT,
  REFERENCES,
  TRIGGER,
  TRUNCATE,
  MAINTAIN
ON TABLE
  "public"."permission__actions"
TO
  "authenticated";

GRANT
  ALL
ON TABLE
  "public"."permission__actions"
TO
  "service_role";

-- RLS
ALTER TABLE "public"."permission__actions" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Enable read access for all users"
ON
  "public"."permission__actions"
FOR SELECT
TO
  "authenticated"
USING (
  true
);

-- SEED
INSERT INTO "public"."permission__actions"
(
  "action",
  "description"
)
VALUES
 ('global.create', 'can insert into all CRM fields'),
 ('global.update', 'can insert into all CRM fields'),
 ('global.delete', 'can delete from any CRM field'),
 ('status.approve', 'can update field from draft to approved');