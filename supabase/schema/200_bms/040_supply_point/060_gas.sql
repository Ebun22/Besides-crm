CREATE TABLE IF NOT EXISTS "bms"."supply_point__gas" (
  "id"                       uuid        NOT NULL DEFAULT gen_random_uuid (),
  "negotiation"              uuid            NULL,
  "supply_point"             uuid            NULL,
  "pdr"                      text            NULL,
  "offer_type"               uuid            NULL,
  "uso_forn"                 uuid            NULL,
  "supplier"                 varchar(60)     NULL,
  "DL"                       varchar(60)     NULL,
  "volume"                   bigint          NULL,
  "gas_matr"                 varchar(40)     NULL,
  "gas_remi"                 varchar(40)     NULL,
  "accise"                   boolean         NULL DEFAULT FALSE,
  "ateco_cod"                varchar(8)      NULL,
  "ateco_descr"              text            NULL,
  "consumption_quota_charge" numeric(8,2)    NULL,
  "fixed_fee_charge"         numeric(8,2)    NULL,
  "per_tot"                  numeric(8,2)    NULL,
  CONSTRAINT supply_point__gas_pkey             PRIMARY KEY ("id"),
  CONSTRAINT supply_point__gas_pdr_key          UNIQUE ("pdr"),
  CONSTRAINT supply_point__gas_negotiation_fkey FOREIGN KEY ("negotiation")
    REFERENCES "bms"."negotiation__details" ("id")
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT supply_point__gas_supply_point_fkey FOREIGN KEY ("supply_point")
    REFERENCES "bms"."supply_point__details" ("id")
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT supply_point__gas_uso_forn_fkey    FOREIGN KEY ("uso_forn")
    REFERENCES "bms"."product__usage_categories" ("id")
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT supply_point__gas_offer_type_fkey  FOREIGN KEY ("offer_type")
    REFERENCES "bms"."product__offer_types" ("id")
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

ALTER TABLE "bms"."supply_point__gas" OWNER TO "postgres";

-- CLS
REVOKE
  ALL
ON TABLE
  "bms"."supply_point__gas"
FROM
  "anon",
  "authenticated";

GRANT
  SELECT,
  INSERT,
  UPDATE,
  DELETE
ON TABLE
  "bms"."supply_point__gas"
TO
  "authenticated",
  "service_role";

-- RLS
ALTER TABLE "bms"."supply_point__gas" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Enable read access for all users"
ON
  "bms"."supply_point__gas"
FOR SELECT
TO
  "authenticated"
USING (
  true
);

CREATE POLICY "Enable insert for authenticated users only"
ON
  "bms"."supply_point__gas"
FOR INSERT
TO
  "authenticated"
WITH CHECK (
  true
);

CREATE POLICY "Enable auth users update"
ON
  "bms"."supply_point__gas"
FOR UPDATE
TO
  "authenticated"
USING (
  true
);
