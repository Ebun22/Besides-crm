CREATE TABLE IF NOT EXISTS "bms"."telecom__details" (
  "id"                    uuid        NOT NULL DEFAULT gen_random_uuid (),
  "fixed_line_supplier"   varchar(60)     NULL,
  "mobile_phone_supplier" varchar(60)     NULL,
  "fixed_msisdn"          bigint          NULL,
  "mobile_msisdn"         text            NULL,
  CONSTRAINT telecom__details_pkey PRIMARY KEY ("id")
);

ALTER TABLE "bms"."telecom__details" OWNER TO "postgres";

-- CLS
REVOKE
  ALL
ON TABLE
  "bms"."telecom__details"
FROM
  "anon",
  "authenticated";

GRANT
  SELECT,
  INSERT,
  UPDATE,
  DELETE
ON TABLE
  "bms"."telecom__details"
TO
  "authenticated",
  "service_role";

-- RLS
ALTER TABLE "bms"."telecom__details" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Enable read access for all users"
ON
  "bms"."telecom__details"
FOR SELECT
TO
  "authenticated"
USING (
  true
);

CREATE POLICY "Enable insert for authenticated users only"
ON
  "bms"."telecom__details"
FOR INSERT
TO
  "authenticated"
WITH CHECK (
  true
);

CREATE POLICY "Enable update for auth users"
ON
  "bms"."telecom__details"
FOR UPDATE
TO
  "authenticated"
USING (
  true
);
