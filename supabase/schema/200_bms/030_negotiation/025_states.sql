CREATE TABLE IF NOT EXISTS "bms"."negotiation__states" (
  "id"          uuid NOT NULL DEFAULT gen_random_uuid (),
  "name"        text NOT NULL,
  "description" text     NULL,
  CONSTRAINT negotiation__statess_pkey PRIMARY KEY ("id")
);

ALTER TABLE "bms"."negotiation__states" ENABLE ROW LEVEL SECURITY;

-- CLS
REVOKE
  ALL
ON TABLE
  "bms"."negotiation__states"
FROM
  "anon",
  "authenticated";

GRANT
  SELECT
ON TABLE
  "bms"."negotiation__states"
TO
  "authenticated";

-- RLS
ALTER TABLE "bms"."negotiation__states" ENABLE ROW LEVEL SECURITY;

CREATE POLICY
  "Enable read access for auth users"
ON
  "bms"."negotiation__states"
FOR SELECT
TO
  "authenticated"
USING (
  true
);

-- SEED
INSERT INTO "bms"."negotiation__states" (
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
