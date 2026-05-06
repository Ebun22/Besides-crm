CREATE TABLE IF NOT EXISTS "bms"."negotiation__details__details" (
  "id"                     uuid         NOT NULL DEFAULT gen_random_uuid (),
  "opened_by"              uuid             NULL,
  "settore"                uuid             NULL,
  "tipo_lavorazione"       uuid             NULL,
  "tipo_cliente"           uuid             NULL,
  "canale"                 text             NULL,
  "operazione"             uuid             NULL,
  "operazione_subcategory" uuid             NULL,
  "state"                  uuid         NOT NULL,
  "status"                 uuid         NOT NULL,
  "cons_note"              varchar(256)     NULL,
  "created_at"             bigint       NOT NULL DEFAULT (EXTRACT(EPOCH FROM now()) * 1000)::BIGINT,
  CONSTRAINT negotiation__details_pkey           PRIMARY KEY ("id")
  CONSTRAINT negotiation__details_opened_by_fkey FOREIGN KEY ("opened_by")
    REFERENCES "auth"."users" ("id")
    ON UPDATE CASCADE
    ON DELETE CASCADE
  CONSTRAINT negotiation__details_settore_fkey   FOREIGN KEY ("settore")
    REFERENCES "bms"."negotiation__operation" ("id")
    ON UPDATE CASCADE
    ON DELETE CASCADE
  CONSTRAINT negotiation__details_type_key FOREIGN KEY ("product_type")
    REFERENCES "bms"."negotiation__operation" ("id")
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

ALTER TABLE "bms"."negotiation__details__details" OWNER TO "postgres";

-- CLS
REVOKE
  ALL
ON TABLE
  "bms"."negotiation__details__details"
FROM
  "anon",
  "authenticated";

GRANT
  SELECT,
  INSERT,
  UPDATE,
  DELETE
ON TABLE
  "bms"."negotiation__details__details"
TO
  "authenticated";

-- RLS
ALTER TABLE "bms"."negotiation__details__details" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Enable read access for all users"
ON
  "bms"."negotiation__details__details"
FOR SELECT
TO
  "authenticated"
USING (
  true
);

CREATE POLICY "Enable insert for authenticated users only"
ON
  "bms"."negotiation__details__details"
FOR INSERT
TO
  "authenticated"
WITH CHECK (
  true
);
