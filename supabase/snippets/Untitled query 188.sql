UPDATE "public"."people__details"
SET "status" = (
    SELECT "id"
    FROM   "public"."people__status"
    WHERE  "name" = 'APPROVED'
    LIMIT  1
)
WHERE  "id" = '1cadafc5-a483-4d49-a999-3bdff8de34a8'::uuid;