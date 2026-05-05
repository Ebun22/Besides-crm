CREATE TABLE IF NOT EXISTS "bms"."negotiation__sector" (
  "id"          uuid NOT NULL DEFAULT gen_random_uuid (),
  "name"        text NOT NULL,
  CONSTRAINT product__type_pkey PRIMARY KEY ("id")
);

ALTER TABLE "bms"."negotiation__sector" ENABLE ROW LEVEL SECURITY;

-- CLS
REVOKE
  ALL
ON TABLE
  "bms"."negotiation__sector"
FROM
  "anon",
  "authenticated";

GRANT
  SELECT
ON TABLE
  "bms"."negotiation__sector"
TO
  "authenticated";

-- RLS
ALTER TABLE "bms"."negotiation__sector" ENABLE ROW LEVEL SECURITY;

CREATE POLICY
  "Enable read access for auth users"
ON
  "bms"."negotiation__sector"
FOR SELECT
TO
  "authenticated"
USING (
  true
);

-- SEED
INSERT INTO "bms"."negotiation__sector" (
  "name",
  "description"
)
VALUES
  ('Energy',            NULL),
  ('Telecommunication', NULL);
  ('Others',            NULL);
