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

let token_client_instance : SupabaseClient | undefined = undefined;

export async function Token_Client(
    access_token  : string,
    refresh_token : string,
) : Promise<SupabaseClient> {
    if (!access_token || !refresh_token) {
        throw new Error("Empty tokens for client!");
    };

    // if client with this access token already exist, return that
    if (token_client_instance &&
        access_token === (await token_client_instance.auth.getSession()).data.session?.access_token
    ) {
        return token_client_instance;
    };

    // Else create new client
    const client = Publishable_Client();
    
    // Set the session - Supabase will handle refresh automatically
    const { error } = await client.auth.setSession({
        access_token,
        refresh_token
    });

    if (error) {
        throw error;
    };

    return client;
};

