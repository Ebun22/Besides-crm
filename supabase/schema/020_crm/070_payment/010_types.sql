CREATE TABLE IF NOT EXISTS "crm"."payment__types" (
  "id" uuid not null default gen_random_uuid (),
  "name" text not null,
  "description" text not null,
  constraint payment__types_pkey primary key (id)
) TABLESPACE pg_default;

ALTER TABLE "crm"."payment__types" OWNER TO "postgres";

-- CLS
REVOKE
  ALL
ON TABLE
  "crm"."payment__types"
FROM
  "anon";

GRANT
  SELECT,
  INSERT,
  REFERENCES,
  TRIGGER,
  TRUNCATE,
  MAINTAIN
ON TABLE
  "crm"."payment__types"
TO
  "authenticated";

GRANT
  ALL
ON TABLE
  "crm"."payment__types"
TO
  "service_role";

-- RLS
ALTER TABLE "crm"."payment__types" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Enable read access for all users"
ON
  "crm"."payment__types"
FOR SELECT
TO
  "authenticated"
USING (
  true
);
