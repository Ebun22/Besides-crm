CREATE TABLE IF NOT EXISTS "public"."supply__address" (
  "id"             uuid    NOT NULL DEFAULT gen_random_uuid (),
  "supp_address_1" text        NULL,
  "supp_address_2" text        NULL,
  "supp_zip"       bigint      NULL,
  "supp_town"      text        NULL,
  "supp_pr"        varchar     NULL,
  CONSTRAINT supply__address_pkey PRIMARY KEY ("id")
);

ALTER TABLE "public"."supply__address" OWNER TO "postgres";

-- CLS
REVOKE
  ALL
ON TABLE
  "public"."supply__address"
FROM
  "anon";

GRANT
  ALL
ON TABLE
  "public"."supply__address"
TO
  "authenticated",
  "service_role";

-- RLS
ALTER TABLE "public"."supply__address" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Enable read access for all users"
ON
  "public"."supply__address"
FOR SELECT
TO
  "authenticated"
USING (
  true
);

CREATE POLICY "Enable insert for authenticated users only"
ON
  "public"."supply__address"
FOR INSERT
TO
  "authenticated"
WITH CHECK (
  true
);

-- TODO: add update policy
