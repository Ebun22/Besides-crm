CREATE TABLE IF NOT EXISTS "crm"."payment__iban" (
  "id"        uuid NOT NULL DEFAULT gen_random_uuid (),
  "payment"   uuid     NULL,
  "customer"  uuid     NULL,
  "bank_name" text     NULL,
  "bic"       bigint   NULL,
  "country"   text     NULL,
  CONSTRAINT payment__iban_pkey          PRIMARY KEY ("id"),
  CONSTRAINT payment__iban_customer_fkey FOREIGN KEY ("customer")
    REFERENCES "crm"."people__details" ("id")
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT payment__iban_payment_fkey  FOREIGN KEY ("payment")
    REFERENCES "crm"."payment__details" ("id")
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

ALTER TABLE "crm"."payment__iban" OWNER TO "postgres";

ALTER TABLE "crm"."payment__iban" ENABLE ROW LEVEL SECURITY;
