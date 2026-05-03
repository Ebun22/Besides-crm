-- Creaate CRM schema
CREATE SCHEMA IF NOT EXISTS crm;

GRANT
  USAGE
ON SCHEMA crm
TO
  "service_role",
  "authenticated";

-- Create BMS schema
CREATE SCHEMA IF NOT EXISTS bms;

GRANT
  USAGE
ON SCHEMA bms
TO
  "service_role",
  "authenticated";
