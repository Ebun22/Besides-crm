const env = (import.meta as any).env ?? process.env;

export const public_env = {
    supabase_url             : env.PUBLIC_SUPABASE_URL,
    supabase_publishable_key : env.PUBLIC_SUPABASE_PUBLISHABLE_KEY,
    ocr_url                  : env.OCR_URL,
};
