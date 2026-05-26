CREATE TABLE IF NOT EXISTS "public"."company__details" (
  "id"              uuid    NOT NULL DEFAULT gen_random_uuid (),
  "ragione_sociale" text    NULL,
  "tipo_azienda"    uuid    NULL,
  "p_iva"           varchar NULL,
  "cf_azienda"      varchar NULL,
  CONSTRAINT company__details_pkey              PRIMARY KEY ("id"),
  CONSTRAINT company__details_tipo_azienda_fkey FOREIGN KEY ("tipo_azienda")
    REFERENCES company__type ("id")
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

ALTER TABLE "public"."company__details" OWNER TO "postgres";

-- CLS
REVOKE
  ALL
ON TABLE
  "public"."company__details"
FROM
  "anon";

GRANT
  ALL
ON TABLE
  "public"."company__details"
TO
  "authenticated",
  "service_role";

-- RLS
ALTER TABLE "public"."company__details" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Enable read access for all users"
ON
  "public"."company__details"
FOR SELECT
TO
  "authenticated"
USING (
  true
);

CREATE POLICY "Enable insert for authenticated users only"
ON
  "public"."company__details"
FOR INSERT
TO
  "authenticated"
WITH CHECK (
  true
);

-- TODO: ADD UPDATE RLS
ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."company__details";
