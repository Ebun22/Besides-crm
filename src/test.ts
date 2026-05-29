import { auth_client } from './services/clients/public.ts';

const client = await auth_client(
    'Rodolfo@besides.com',
    'Besides@2026',
);

const { data, error } = await client
    .schema('bms')
    .from('product__origin_market')
    .select('*');

if (error) {
    throw error;
};

console.log(data);
