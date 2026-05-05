CREATE TABLE IF NOT EXISTS "bms"."product__usage_categories" (
  "id"          uuid NOT NULL DEFAULT gen_random_uuid (),
  "name"        text NOT NULL,
  "description" text     NULL,
  CONSTRAINT product__usage_cat_pkey PRIMARY KEY ("id")
);

ALTER TABLE "crm"."product__usage_categories" ENABLE ROW LEVEL SECURITY;

-- CLS
REVOKE
  ALL
ON TABLE
  "crm"."product__usage_categories"
FROM
  "anon",
  "authenticated";

GRANT
  SELECT
ON TABLE
  "crm"."product__usage_categories"
TO
  "authenticated";

-- RLS
ALTER TABLE "crm"."product__usage_categories" ENABLE ROW LEVEL SECURITY;

CREATE POLICY
  "Enable read access for all users"
ON
  "crm"."product__usage_categories"
FOR SELECT
TO
  "authenticated"
USING (
  true
);

-- SEED
INSERT INTO "crm"."product__usage_categories" (
  "name",
  "description"
)
VALUES
  ('Condominium Common Uses',                                NULL),
  ('Domestic Resident',                                      NULL),
  ('Domestic Non-resident',                                  NULL),
  ('Other Uses LV',                                          NULL),
  ('Other Uses MV',                                          NULL),
  ('Cooking and/or domestic hot water production',           NULL),
  ('Air conditioning',                                       NULL),
  ('Heating',                                                NULL),
  ('Air conditioning + heating',                             NULL),
  ('Heating + cooking and/or domestic hot water production', NULL),
  ('Technological (artisan–industrial)',                     NULL),
  ('Technological + heating',                                NULL);
