import { public_env } from '@env/public.js';
import { type SupabaseClient, createClient } from '@supabase/supabase-js';

export function Publishable_Client() : SupabaseClient {
    const client = createClient(
        public_env.supabase_url,
        public_env.supabase_publishable_key,
        {
            auth : {
                autoRefreshToken   : true,
                persistSession     : true,
                detectSessionInUrl : true
            }
        }
    );

    return client;
};

export async function auth_client(
    email    : string,
    password : string,
) {
    const client = Publishable_Client();

    const { data: { session } } = await client.auth.getSession();

    if (session) return client;

    const { data, error } = await client.auth.signInWithPassword({
        email,
        password
    });

    if (error) {
        throw error;
    };

    if (!data.session) {
        throw new Error("No session returned");
    };

    return client;
};
