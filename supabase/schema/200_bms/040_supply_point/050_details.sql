CREATE TABLE IF NOT EXISTS "bms"."supply_point__details" (
  "id"             uuid       NOT NULL DEFAULT gen_random_uuid (),
  "supp_address"   text           NULL,
  "product_type"   uuid       NOT NULL,
  "created_at"     bigint     NOT NULL DEFAULT (EXTRACT(EPOCH FROM now()) * 1000)::BIGINT,
  "active"         boolean    NOT NULL DEFAULT TRUE,
  CONSTRAINT supply_point_pkey                       PRIMARY KEY ("id"),
  CONSTRAINT supply_point__details_product_type_fkey FOREIGN KEY ("product_type")
    REFERENCES "bms"."product__settore___types" ("id")
    ON UPDATE CASCADE
    ON DELETE SET NULL
);

ALTER TABLE "bms"."supply_point__details" OWNER TO "postgres";

-- CLS
REVOKE
  ALL
ON TABLE
  "bms"."supply_point__details"
FROM
  "anon",
  "authenticated";

GRANT
  SELECT,
  INSERT,
  UPDATE,
  DELETE
ON TABLE
  "bms"."supply_point__details"
TO
  "authenticated",
  "service_role";

-- RLS
ALTER TABLE "bms"."supply_point__details" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Enable read access for all users"
ON
  "bms"."supply_point__details"
FOR SELECT
TO
  "authenticated"
USING (
  true
);

CREATE POLICY "Enable insert for authenticated users only"
ON
  "bms"."supply_point__details"
FOR INSERT
TO
  "authenticated"
WITH CHECK (
  true
);

CREATE POLICY "Enable auth user update"
ON
  "bms"."supply_point__details"
FOR UPDATE
TO
  "public"
USING (
  true
);
