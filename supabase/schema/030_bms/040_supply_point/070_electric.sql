CREATE TABLE IF NOT EXISTS "bms"."supply_point__electric" (
  "id"                           uuid        NOT NULL DEFAULT gen_random_uuid (),
  "negotiation"                  uuid        NOT NULL,
  "supply_point"                 uuid            NULL,
  "pod"                          text            NULL,
  "offer_type"                   uuid            NULL,
  "uso_forn"                     uuid            NULL,
  "supplier"                     varchar(60)     NULL,
  "DL"                           varchar(60)     NULL,
  "pricing_type"                 uuid            NULL,
  "vendita_ee_quota_consumi_eur" numeric(8,2)    NULL,
  "vendita_ee_quota_fissa_eur"   numeric(8,2)    NULL,
  "per_tot"                      numeric(8,2)    NULL DEFAULT FALSE,
  "per_F1"                       numeric(8,2)    NULL,
  "per_F2"                       numeric(8,2)    NULL,
  "per_F23"                      numeric(8,2)    NULL,
  "per_F3"                       numeric(8,2)    NULL,
  "volume"                       numeric(8,2)    NULL,
  "potenza"                      numeric(8,2)    NULL,
  "tensione"                     numeric(8,2)    NULL,
  CONSTRAINT supply_point_pkey              PRIMARY KEY ("id"),
  CONSTRAINT supply_point__neg_details_fkey FOREIGN KEY ("negotiation")
    REFERENCES "bms"."negotiation__details" ("id")
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT supply_point_details_fkey      FOREIGN KEY ("supply_point")
    REFERENCES "bms"."supply_point__details" ("id")
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT supply_point_uso_forn_fkey     FOREIGN KEY ("uso_forn")
    REFERENCES "bms"."product__usage" ("id")
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT supply_point_off_type_fkey     FOREIGN KEY ("offer_type")
    REFERENCES "bms"."product__offer_type" ("id")
    ON UPDATE CASCADE
    ON DELETE CASCADE
  CONSTRAINT supply_point_pricing_type_fkey     FOREIGN KEY ("pricing_type")
    REFERENCES "bms"."product__pricing_type" ("id")
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

ALTER TABLE "bms"."supply_point__electric" OWNER TO "postgres";

-- CLS
REVOKE
  ALL
ON TABLE
  "bms"."supply_point__electric"
FROM
  "anon",
  "authenticated";

GRANT
  SELECT,
  INSERT,
  UPDATE,
  DELETE
ON TABLE
  "bms"."supply_point__electric"
TO
  "authenticated",
  "service_role";

-- RLS
ALTER TABLE "bms"."supply_point__electric" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Enable read access for all users"
ON
  "bms"."supply_point__electric"
FOR SELECT
TO
  "authenticated"
USING (
  true
);

CREATE POLICY "Enable insert for authenticated users only"
ON
  "bms"."supply_point__electric"
FOR INSERT
TO
  "authenticated"
WITH CHECK (
  true
);
