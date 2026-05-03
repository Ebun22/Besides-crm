CREATE TABLE IF NOT EXISTS "crm"."company__type" (
  "id"          uuid NOT NULL DEFAULT gen_random_uuid (),
  "name"        text NOT NULL,
  "description" text     NULL,
  CONSTRAINT company__type_pkey PRIMARY KEY (id)
);

ALTER TABLE "crm"."company__type" OWNER TO "postgres";

-- CLS
REVOKE
  ALL
ON TABLE
  "crm"."company__type"
FROM
  "anon";

GRANT
  SELECT,
  REFERENCES,
  TRIGGER,
  TRUNCATE,
  MAINTAIN
ON TABLE
  "crm"."company__type"
TO
  "authenticated";

GRANT
  ALL
ON TABLE
  "crm"."company__type"
TO
  "service_role";

-- RLS
ALTER TABLE "crm"."company__type" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Enable read access for all users"
ON
  "crm"."company__type"
FOR SELECT
TO
  "authenticated"
USING (
  true
);
