CREATE TABLE IF NOT EXISTS "bms"."supply__point" (
  "id"             uuid    NOT NULL DEFAULT gen_random_uuid (),
  "supp_address_1" text        NULL,
  "supp_address_2" text        NULL,
  "supp_zip"       bigint      NULL,
  "supp_town"      text        NULL,
  "supp_pr"        varchar     NULL,
  CONSTRAINT supply__address_pkey PRIMARY KEY ("id")
);

ALTER TABLE "bms"."supply__address" OWNER TO "postgres";

-- CLS
REVOKE
  ALL
ON TABLE
  "bms"."supply__address"
FROM
  "anon";

GRANT
  ALL
ON TABLE
  "bms"."supply__address"
TO
  "authenticated",
  "service_role";

-- RLS
ALTER TABLE "bms"."supply__address" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Enable read access for all users"
ON
  "bms"."supply__address"
FOR SELECT
TO
  "authenticated"
USING (
  true
);

CREATE POLICY "Enable insert for authenticated users only"
ON
  "bms"."supply__address"
FOR INSERT
TO
  "authenticated"
WITH CHECK (
  true
);

-- TODO: add update policy
