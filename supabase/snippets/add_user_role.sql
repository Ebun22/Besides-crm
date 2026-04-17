INSERT INTO "public"."permission__user_roles" (
  "user",
  "role"
)
SELECT 
  u.id,
  r.id
FROM "auth"."users" u
CROSS JOIN "public"."permission__roles" r
WHERE u."email" = 'your-email@example.com'
  AND r."name" = 'Consultant';
