CREATE TABLE IF NOT EXISTS "public"."people__negotiations" (
  "id"              uuid NOT NULL DEFAULT gen_random_uuid (),
  "cust_ref"        uuid NOT NULL,
  "negotiation_ref" text NOT NULL,
  CONSTRAINT people__negotiations_pkey PRIMARY KEY ("id"),
  CONSTRAINT people__negotiations_customer_fkey  FOREIGN KEY ("cust_ref")
    REFERENCES people__details ("id")
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

ALTER TABLE "public"."people__negotiations" OWNER TO "postgres";

-- CLS
REVOKE
  ALL
ON TABLE
  "public"."people__negotiations"
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
  "public"."people__negotiations"
TO
  "service_role";

-- RLS
ALTER TABLE "public"."people__negotiations" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Enable read access for all users"
ON
  "public"."people__negotiations"
FOR SELECT
TO
  "authenticated"
USING (
  true
);
