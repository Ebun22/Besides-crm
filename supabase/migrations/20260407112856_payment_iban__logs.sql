CREATE TABLE IF NOT EXISTS "public"."iban__logs" (
  "id"              uuid NOT NULL DEFAULT gen_random_uuid (),
  "payment"         uuid NOT NULL,
  "iban_api_status" uuid     NULL,
  "iban_bank_name"  text     NULL,
  "iban_bic"        bigint   NULL,
  "iban_country"    text     NULL,
  CONSTRAINT iban_logs_pkey primary key ("id"),
  CONSTRAINT iban__logs_iban_api_status_fkey FOREIGN KEY ("iban_api_status")
    REFERENCES iban__status ("id")
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT iban__logs_payment_fkey         FOREIGN KEY ("payment")
    REFERENCES payment__details ("id")
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

ALTER TABLE "public"."iban__logs" OWNER TO "postgres";

ALTER TABLE "public"."iban__logs" ENABLE ROW LEVEL SECURITY;

-- CLS
REVOKE
  ALL
ON TABLE
  "public"."iban__logs"
FROM
  "anon";

GRANT
  ALL
ON TABLE
  "public"."iban__logs"
TO
  "authenticated";

GRANT
  ALL
ON TABLE
  "public"."iban__logs"
TO
  "service_role";

-- RLS
CREATE POLICY
  "Enable read access for all users"
ON
  "public"."iban__logs"
FOR SELECT
TO
  "authenticated"
USING (
  true
);

-- TODO: Add insert and update RLS