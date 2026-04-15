INSERT INTO public.permissions__user_roles (
  user,
  role
)
SELECT 
  u.id,
  r.id
FROM auth.users u
CROSS JOIN public.permissions__roles r
WHERE u.email = 'test@example.com'
  AND r.name = 'Consultant';
