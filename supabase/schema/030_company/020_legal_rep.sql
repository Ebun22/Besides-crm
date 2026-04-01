CREATE TABLE IF NOT EXISTS "public"."company__legal_rep" (
  "id"        uuid NOT NULL DEFAULT gen_random_uuid (),
  "legal_rep" uuid NOT NULL,
  "comp_ref"  uuid NOT NULL,
  CONSTRAINT company__legal_rep_pkey           PRIMARY KEY ("id"),
  CONSTRAINT company__legal_rep_legal_rep_fkey FOREIGN KEY ("legal_rep")
    REFERENCES people__details ("id")
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT company__legal_rep_comp_ref_fkey  FOREIGN KEY ("comp_ref")
    REFERENCES company__details ("id")
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

ALTER TABLE "public"."company__legal_rep" OWNER TO "postgres";

-- CLS
REVOKE
  ALL
ON TABLE
  "public"."company__legal_rep"
TO
  "anon";

GRANT
  ALL
ON TABLE
  "public"."company__legal_rep"
TO
  "authenticated",
  "service_role";

-- RLS
ALTER TABLE "public"."company__legal_rep" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Enable read access for all users"
ON
  "public"."company__legal_rep"
FOR SELECT
TO
  "authenticated"
USING (
  true
);

CREATE POLICY "Enable insert for authenticated users only"
ON
  "public"."company__legal_rep"
FOR INSERT
TO
  "authenticated"
WITH CHECK (
  true
);

CREATE POLICY "update policy"
ON
  "public"."company__legal_rep"
FOR UPDATE
TO
  "authenticated"
USING (
  true
);
