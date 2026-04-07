CREATE TABLE IF NOT EXISTS "public"."iban__status" (
  "id"   uuid NOT NULL DEFAULT gen_random_uuid (),
  "name" text NOT NULL,
  CONSTRAINT iban__status_pkey PRIMARY KEY (id)
);

ALTER TABLE "public"."iban__status" OWNER TO "postgres";

-- CLS
REVOKE
  ALL
ON TABLE
  "public"."iban__status"
FROM
  "anon";

GRANT
  SELECT,
  REFERENCES,
  TRIGGER,
  TRUNCATE,
  MAINTAIN
ON TABLE
  "public"."iban__status"
TO
  "authenticated";

GRANT
  ALL
ON TABLE
  "public"."iban__status"
TO
  "service_role";

-- RLS
ALTER TABLE "public"."iban__status" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Enable read access for all users"
ON
  "public"."iban__status"
FOR SELECT
TO
  "authenticated"
USING (
  true
);

-- SEED
INSERT INTO "public"."iban__status"(
  "name"
)
VALUES
  ('VALID'),
  ('INVALID'),
  ('UNKNOWN');
