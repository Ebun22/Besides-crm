CREATE TABLE IF NOT EXISTS "public"."people__invoices" (
  "id"       uuid   NOT NULL DEFAULT gen_random_uuid (),
  "cust_ref" uuid   NOT NULL,
  "invoice"  text   NOT NULL,
  "date"     bigint NOT NULL,
  CONSTRAINT people__invoices_pkey PRIMARY KEY ("id")
);

ALTER TABLE "public"."people__invoices" OWNER TO "postgres";

-- CLS
REVOKE
  ALL
ON TABLE
  "public"."people__invoices"
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
  "public"."people__invoices"
TO
  "service_role";

-- RLS
ALTER TABLE "public"."people__invoices" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Enable read access for all users"
ON
  "public"."people__invoices"
FOR SELECT
TO
  "authenticated"
USING (
  true
);
