SELECT schema_name 
FROM information_schema.schemata 
WHERE schema_name IN ('crm', 'bms', 'public', 'auth')
ORDER BY schema_name;