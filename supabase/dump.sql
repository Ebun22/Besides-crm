


SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


CREATE EXTENSION IF NOT EXISTS "pg_net" WITH SCHEMA "extensions";






COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE EXTENSION IF NOT EXISTS "pg_graphql" WITH SCHEMA "graphql";






CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";






CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";





SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."company__details" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "ragione_sociale" "text",
    "tipo_azienda" "uuid",
    "p_iva" character varying,
    "cf_azienda" character varying
);


ALTER TABLE "public"."company__details" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."company__leg_ref" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "legal_rep" "uuid" NOT NULL,
    "comp_ref" "uuid" NOT NULL
);





CREATE TABLE IF NOT EXISTS "public"."company__type" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "name" "text" NOT NULL,
    "description" "text"
);


ALTER TABLE "public"."company__type" OWNER TO "postgres";



    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "cust_ref" "uuid" NOT NULL,
    "comp_ref" "uuid" NOT NULL
);





CREATE TABLE IF NOT EXISTS "public"."customer__details" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "cognome" "text",
    "nome" "text",
    "cod_fis" character varying,
    "ref_cognome" "text",
    "ref_nome" "text",
    "cl_celnum" character varying,
    "cl_fixnum" character varying,
    "email" character varying,
    "pec" character varying,
    "id_type" "uuid",
    "id_number" character varying,
    "id_doc" "text",
    "doc_issuedate" bigint,
    "doc_expdate" bigint,
    "tit_birthplace" "text",
    "tit_birth_date" "text",
    "tit_gender" character varying,
    "cust_address_1" "text",
    "cust_address_2" "text",
    "cust_zip" bigint,
    "cust_town" "text",
    "cust_pr" character varying,
    "virtual_bill" "text",
    "prev_virtual_bill" "text",
    "gdpr" "text",
    "status" "uuid"
);


ALTER TABLE "public"."customer__details" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."customer__iban" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "cust_ref" "uuid" NOT NULL,
    "iban_ref" "uuid" NOT NULL
);


ALTER TABLE "public"."customer__iban" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."customer__payment" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "cust_ref" "uuid" DEFAULT "gen_random_uuid"(),
    "pay_type" "uuid",
    "cc_cognome" "text",
    "cc_nome" "text",
    "pag_codfisc" "text",
    "cc_tit_birth_place" "text",
    "cc_tit_birth_date" bigint,
    "cc_tit_sex" character varying
);


ALTER TABLE "public"."customer__payment" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."customer__status" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "name" "text" NOT NULL,
    "description" "text"
);


ALTER TABLE "public"."customer__status" OWNER TO "postgres";


"public"."customer__supply_details" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "supp_ref" "uuid" NOT NULL,
    "cust_ref" "uuid" NOT NULL
);


ALTER TABLE "public"."customer__supply_details" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."iban__logs" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "iban_api_status" "uuid",
    "iban_bank_name" "text",
    "iban_bic" bigint,
    "iban_country" "text"
);


ALTER TABLE "public"."iban__logs" OWNER TO "postgres";



    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "name" "text" NOT NULL
);





CREATE TABLE IF NOT EXISTS "public"."id_document__types" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "name" "text" NOT NULL,
    "description" "text"
);


ALTER TABLE "public"."id_document__types" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."legal_rep__details" (
    "lr_cognome" "text",
    "lr_nome" "text",
    "lr_codfis" "text",
    "id_type" "uuid",
    "id_lr" "text",
    "doc_issuedate" bigint,
    "doc_expdate" bigint,
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL
);


ALTER TABLE "public"."legal_rep__details" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."payment__types" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "name" "text" NOT NULL,
    "description" "text" NOT NULL
);





CREATE TABLE IF NOT EXISTS "public"."permission__actions" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "action" "text" NOT NULL
);


ALTER TABLE "public"."permission__actions" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."permission__role_actions" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "role_id" "uuid" NOT NULL,
    "action_id" "uuid" NOT NULL
);


ALTER TABLE "public"."permission__role_actions" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."permission__roles" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "role" "text" NOT NULL,
    "description" "text"
);


ALTER TABLE "public"."permission__roles" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."permission__user_roles" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "user" "uuid" NOT NULL,
    "role" "uuid" NOT NULL
);


ALTER TABLE "public"."permission__user_roles" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."supply__details" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "supp_address_1" "text",
    "supp_address_2" "text",
    "supp_zip" bigint,
    "supp_town" "text",
    "supp_pr" character varying
);


ALTER TABLE "public"."supply__details" OWNER TO "postgres";


ALTER TABLE ONLY "public"."company__details"
    ADD CONSTRAINT "company__details_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."company__leg_ref"
    ADD CONSTRAINT "company__leg_ref_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."company__type"
    ADD CONSTRAINT "company__type_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."customer__details"
    ADD CONSTRAINT "contact__details_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."customer__status"
    ADD CONSTRAINT "contact__status_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."customer__company"
    ADD CONSTRAINT "customer__company_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."customer__iban"
    ADD CONSTRAINT "customer__iban_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."customer__supply_details"
    ADD CONSTRAINT "customer__supply_details_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."iban__status"
    ADD CONSTRAINT "iban__status_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."iban__logs"
    ADD CONSTRAINT "iban_logs_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."id_document__types"
    ADD CONSTRAINT "id_document__types_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."legal_rep__details"
    ADD CONSTRAINT "legal_rep__details_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."payment__types"
    ADD CONSTRAINT "payment__types_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."customer__payment"
    ADD CONSTRAINT "payment_details_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."permission__roles"
    ADD CONSTRAINT "pemission_roles_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."permission__actions"
    ADD CONSTRAINT "permission__actions_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."permission__role_actions"
    ADD CONSTRAINT "permission__role_actions_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."permission__user_roles"
    ADD CONSTRAINT "permission__user_roles_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."supply__details"
    ADD CONSTRAINT "supply__details_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."company__details"
    ADD CONSTRAINT "company__details_tipo_azienda_fkey" FOREIGN KEY ("tipo_azienda") REFERENCES "public"."company__type"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."company__leg_ref"
    ADD CONSTRAINT "company__leg_ref_comp_ref_fkey" FOREIGN KEY ("comp_ref") REFERENCES "public"."company__details"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."company__leg_ref"
    ADD CONSTRAINT "company__leg_ref_legal_rep_fkey" FOREIGN KEY ("legal_rep") REFERENCES "public"."legal_rep__details"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."customer__company"
    ADD CONSTRAINT "customer__company_comp_ref_fkey" FOREIGN KEY ("comp_ref") REFERENCES "public"."company__details"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."customer__company"
    ADD CONSTRAINT "customer__company_cust_ref_fkey" FOREIGN KEY ("cust_ref") REFERENCES "public"."customer__details"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."customer__details"
    ADD CONSTRAINT "customer__details_id_type_fkey" FOREIGN KEY ("id_type") REFERENCES "public"."id_document__types"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."customer__details"
    ADD CONSTRAINT "customer__details_status_fkey" FOREIGN KEY ("status") REFERENCES "public"."customer__status"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."customer__iban"
    ADD CONSTRAINT "customer__iban_cust_ref_fkey" FOREIGN KEY ("cust_ref") REFERENCES "public"."customer__details"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."customer__iban"
    ADD CONSTRAINT "customer__iban_iban_ref_fkey" FOREIGN KEY ("iban_ref") REFERENCES "public"."iban__logs"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."customer__payment"
    ADD CONSTRAINT "customer__payment_pay_type_fkey" FOREIGN KEY ("pay_type") REFERENCES "public"."payment__types"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."customer__supply_details"
    ADD CONSTRAINT "customer__supply_details_cust_ref_fkey" FOREIGN KEY ("cust_ref") REFERENCES "public"."customer__details"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."customer__supply_details"
    ADD CONSTRAINT "customer__supply_details_supp_ref_fkey" FOREIGN KEY ("supp_ref") REFERENCES "public"."customer__supply_details"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."iban__logs"
    ADD CONSTRAINT "iban__logs_iban_api_status_fkey" FOREIGN KEY ("iban_api_status") REFERENCES "public"."iban__status"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."legal_rep__details"
    ADD CONSTRAINT "legal_rep__details_id_type_fkey" FOREIGN KEY ("id_type") REFERENCES "public"."id_document__types"("id") ON UPDATE CASCADE ON DELETE CASCADE;















CREATE POLICY "Enable insert for authenticated users only" ON "public"."customer__details" FOR INSERT TO "authenticated" WITH CHECK (true);



CREATE POLICY "Enable insert for authenticated users only" ON "public"."customer__iban" FOR INSERT TO "authenticated" WITH CHECK (true);



CREATE POLICY "Enable insert for authenticated users only" ON "public"."customer__payment" FOR INSERT TO "authenticated" WITH CHECK (true);







CREATE POLICY "Enable insert for authenticated users only" ON "public"."iban__logs" FOR INSERT TO "authenticated" WITH CHECK (true);



CREATE POLICY "Enable insert for authenticated users only" ON "public"."legal_rep__details" FOR INSERT TO "authenticated" WITH CHECK (true);
















CREATE POLICY "Enable read access for all users" ON "public"."customer__details" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Enable read access for all users" ON "public"."customer__iban" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Enable read access for all users" ON "public"."customer__payment" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Enable read access for all users" ON "public"."customer__status" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Enable read access for all users" ON "public"."customer__supply_details" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Enable read access for all users" ON "public"."iban__logs" FOR SELECT TO "authenticated" USING (true);







CREATE POLICY "Enable read access for all users" ON "public"."id_document__types" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Enable read access for all users" ON "public"."legal_rep__details" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Enable read access for all users" ON "public"."payment__types" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Enable read access for all users" ON "public"."permission__actions" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Enable read access for all users" ON "public"."permission__role_actions" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Enable read access for all users" ON "public"."permission__roles" FOR SELECT TO "authenticated" USING (true);























ALTER TABLE "public"."customer__details" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."customer__iban" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."customer__payment" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."customer__status" ENABLE ROW LEVEL SECURITY;





ALTER TABLE "public"."iban__logs" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."iban__status" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."id_document__types" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."legal_rep__details" ENABLE ROW LEVEL SECURITY;





ALTER TABLE "public"."permission__roles" ENABLE ROW LEVEL SECURITY;











ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";


ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."company__details";







ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."customer__details";






GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";























































































































































































GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."customer__details" TO "anon";
GRANT ALL ON TABLE "public"."customer__details" TO "authenticated";
GRANT ALL ON TABLE "public"."customer__details" TO "service_role";



GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."customer__iban" TO "anon";
GRANT ALL ON TABLE "public"."customer__iban" TO "authenticated";
GRANT ALL ON TABLE "public"."customer__iban" TO "service_role";



GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."customer__payment" TO "anon";
GRANT ALL ON TABLE "public"."customer__payment" TO "authenticated";
GRANT ALL ON TABLE "public"."customer__payment" TO "service_role";



GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."customer__status" TO "anon";
GRANT SELECT,REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."customer__status" TO "authenticated";
GRANT ALL ON TABLE "public"."customer__status" TO "service_role";







GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."iban__logs" TO "anon";
GRANT ALL ON TABLE "public"."iban__logs" TO "authenticated";
GRANT ALL ON TABLE "public"."iban__logs" TO "service_role";



GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."id_document__types" TO "anon";
GRANT ALL ON TABLE "public"."id_document__types" TO "authenticated";
GRANT ALL ON TABLE "public"."id_document__types" TO "service_role";



GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."legal_rep__details" TO "anon";
GRANT ALL ON TABLE "public"."legal_rep__details" TO "authenticated";
GRANT ALL ON TABLE "public"."legal_rep__details" TO "service_role";






GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."permission__actions" TO "anon";
GRANT SELECT,REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."permission__actions" TO "authenticated";
GRANT ALL ON TABLE "public"."permission__actions" TO "service_role";



GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."permission__role_actions" TO "anon";
GRANT SELECT,REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."permission__role_actions" TO "authenticated";
GRANT ALL ON TABLE "public"."permission__role_actions" TO "service_role";



GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."permission__roles" TO "anon";
GRANT SELECT,REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."permission__roles" TO "authenticated";
GRANT ALL ON TABLE "public"."permission__roles" TO "service_role";



GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."permission__user_roles" TO "anon";
GRANT SELECT,REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."permission__user_roles" TO "authenticated";
GRANT ALL ON TABLE "public"."permission__user_roles" TO "service_role";











ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "service_role";































