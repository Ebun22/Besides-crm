CREATE TABLE IF NOT EXISTS "bms"."event__details" (
  "id"              uuid NOT NULL DEFAULT gen_random_uuid (),
  "type"            uuid     NULL,
  "triggered_by"    uuid     NULL,
  "reason"          text     NULL,
  "affected-entity" uuid     NULL,
  "time_occured"    bigint   NULL DEFAULT (EXTRACT(EPOCH FROM clock_timestamp()) * 1000)::BIGINT,
  CONSTRAINT event__details_pkey      PRIMARY KEY ("id"),
  CONSTRAINT event__details_type_fkey FOREIGN KEY ("type")
    REFERENCES "bms"."event__types" ("id")
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT event__details_triggered_by_fkey FOREIGN KEY ("negotiation")
    REFERENCES "auth"."users" ("id")
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

ALTER TABLE "bms"."event__details" OWNER TO "postgres";

ALTER TABLE "bms"."event__details" ENABLE ROW LEVEL SECURITY;

-- CLS
REVOKE
  ALL
ON TABLE
  "bms"."event__details"
FROM
  "anon",
  "authenticated";

GRANT
  SELECT,
  INSERT
ON TABLE
  "bms"."event__details"
TO
  "authenticated";

GRANT
  ALL
ON TABLE
  "bms"."event__details"
TO
  "service_role";

-- RLS
CREATE POLICY
  "Enable read access for all users"
ON
  "bms"."event__details"
FOR SELECT
TO
  "authenticated"
USING (
  true
);

CREATE POLICY
  "Enable insert for authenticated users only"
ON
  "bms"."event__details"
FOR INSERT
TO
  "authenticated"
WITH CHECK (
  true
);

ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "bms"."event__details";
