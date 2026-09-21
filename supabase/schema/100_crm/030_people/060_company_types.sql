CREATE TABLE IF NOT EXISTS "crm"."people_company__types" (
  "id"          uuid NOT NULL DEFAULT gen_random_uuid (),
  "name"        text NOT NULL,
  "description" text     NULL,
  CONSTRAINT people_company__types_pkey PRIMARY KEY ("id")
);

ALTER TABLE "crm"."people_company__types" ENABLE ROW LEVEL SECURITY;

-- CLS
REVOKE
  ALL
ON TABLE
  "crm"."people_company__types"
FROM
  "anon";

GRANT
  SELECT,
  REFERENCES,
  TRIGGER,
  TRUNCATE,
  MAINTAIN
ON TABLE
  "crm"."people_company__types"
TO
  "authenticated";

GRANT
  ALL
ON TABLE
  "crm"."people_company__types"
TO
  "service_role";

-- RLS
ALTER TABLE "crm"."people_company__types" ENABLE ROW LEVEL SECURITY;

CREATE POLICY
  "Enable read access for all users"
ON
  "crm"."people_company__types"
FOR SELECT
TO
  "authenticated"
USING (
  true
);

-- SEED
INSERT INTO "crm"."people_company__types" (
  "name",
  "description"
)
VALUES
  ('Sole proprietorship',                             NULL),
  ('Freelance professional',                          NULL),
  ('Professional partnership',                        NULL),
  ('Partnerships',                                    NULL),
  ('Simple partnership (S.s.)',                       NULL),
  ('General partnership (S.n.c.)',                    NULL),
  ('Limited partnership (S.a.s.)',                    NULL),
  ('Corporations',                                    NULL),
  ('Limited liability company (S.r.l.)',              NULL),
  ('Simplified limited liability company (S.r.l.s.)', NULL),
  ('Single-member limited liability company',         NULL),
  ('Limited liability company with reduced capital',  NULL),
  ('Joint-stock company (S.p.A.)',                    NULL),
  ('Joint-stock company with a sole shareholder',     NULL),
  ('Partnership limited by shares (S.a.p.a.)',        NULL),
  ('Collective and non-commercial entities',          NULL),
  ('Cooperative',                                     NULL),
  ('Social cooperative',                              NULL),
  ('Consortium',                                      NULL),
  ('Association',                                     NULL),
  ('Amateur Sports Association (A.S.D.)',             NULL),
  ('Limited Liability Sports Association (A.S.R.L.)', NULL),
  ('Foundation',                                      NULL),
  ('Public economic entity',                          NULL),
  ('Condominium',                                     NULL),
  ('Other',                                           NULL);
