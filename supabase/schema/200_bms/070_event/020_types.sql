CREATE TABLE IF NOT EXISTS "bms"."event__types" (
  "id"          uuid NOT NULL DEFAULT gen_random_uuid (),
  "name"        text NOT NULL,
  "description" text     NULL,
  CONSTRAINT event__types_pkey PRIMARY KEY ("id")
);

ALTER TABLE "bms"."event__types" OWNER TO "postgres";

-- CLS
REVOKE
  ALL
ON TABLE
  "bms"."event__types"
FROM
  "anon";

GRANT
  SELECT
ON TABLE
  "bms"."event__types"
TO
  "authenticated";

GRANT
  ALL
ON TABLE
  "bms"."event__types"
TO
  "service_role";

-- RLS
ALTER TABLE "bms"."event__types" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Enable read access for all users"
ON
  "bms"."event__types"
FOR SELECT
TO
  "authenticated"
USING (
  true
);

-- SEED
INSERT INTO "bms"."event__types"
(
  "name",
  "description"
)
VALUES
  ('NEGOTATION_OPENED',           NULL),
  ('NEGOTIATION_IN_PROGRESS',     NULL),
  ('AWAITING_SIMULATION_RESULTS', NULL),
  ('NEGOTATION_ACCEPTED',         NULL),
  ('NEGOTATION_OPENED',           NULL),
  ('NEGOTIATION_TERMINATED',      NULL);
