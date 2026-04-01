CREATE TABLE IF NOT EXISTS "public"."people__types" (
  "id"          uuid NOT NULL DEFAULT gen_random_uuid (),
  "name"        text NOT NULL,
  "description" text     NULL,
  CONSTRAINT people__types_pkey PRIMARY KEY ("id")
);

ALTER TABLE "public"."people__types" ENABLE ROW LEVEL SECURITY;

-- RLS
ALTER TABLE "public"."people__types" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Enable read access for all users" ON "public"."people__types" FOR SELECT TO "authenticated" USING (true);

-- CLS
GRANT
  REFERENCES,
  TRIGGER,
  TRUNCATE,
  MAINTAIN
ON TABLE
  "public"."people__types"
TO
  "anon";

GRANT
  SELECT,
  REFERENCES,
  TRIGGER,
  TRUNCATE,
  MAINTAIN
ON TABLE
  "public"."people__types"
TO
  "authenticated";

GRANT
  ALL
ON TABLE
  "public"."people__types"
TO
  "service_role";

-- SEED
INSERT INTO "public"."people__types" (
  "name",
  "description"
)
VALUES
  (CUSTOMER, NULL),
  (LEGAL_REP, NULL);
