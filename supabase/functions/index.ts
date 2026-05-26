import { Buffer } from 'node:buffer';
import { InvoiceFactory } from '../../src/services/OCR/InvoiceFactory.ts';

const MAX_BYTES = 10 * 1024 * 1024;

const cors_headers = {
  'Access-Control-Allow-Origin'  : '*',
  'Access-Control-Allow-Methods' : 'POST, OPTIONS',
  'Access-Control-Allow-Headers' : 'authorization, x-client-info, apikey, content-type',
};

function sendJson(status: number, body: unknown): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...cors_headers, 'Content-Type': 'application/json' },
  });
}

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: cors_headers });
  }

  const url = new URL(req.url);
  if (req.method !== 'POST' || url.pathname !== '/api/invoices/extract') {
    return sendJson(404, { error: 'Not found' });
  }

  const contentLength = Number(req.headers.get('content-length') ?? 0);
  if (contentLength > MAX_BYTES) {
    return sendJson(413, { error: 'File too large' });
  }

  let buf: Buffer;
  try {
    const ab = await req.arrayBuffer();
    if (ab.byteLength > MAX_BYTES) {
      return sendJson(413, { error: 'File too large' });
    }
    buf = Buffer.from(ab);
  } catch {
    return sendJson(400, { error: 'Failed to read body' });
  }

  if (buf.length === 0) {
    return sendJson(400, { error: 'Empty body' });
  }

  const mimeType = (req.headers.get('content-type') ?? '').split(';')[0].trim();
  const factory = new InvoiceFactory(buf, mimeType);

  try {
    const result = await factory.build();
    return sendJson(result.success ? 200 : 422, result);
  } catch (err) {
    if (err instanceof Error && err.message === 'Unknown type') {
      return sendJson(415, { error: 'Unknown type' });
    }
    console.error('build() failed:', err);
    return sendJson(500, { error: 'Internal error' });
  }
});
