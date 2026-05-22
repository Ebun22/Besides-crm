import { createServer, type IncomingMessage, type ServerResponse } from 'node:http';
import { InvoiceFactory } from './InvoiceFactory.js';

const PORT = Number(process.env.PORT) || 3001;
const MAX_BYTES = 10 * 1024 * 1024;

function setCors(res: ServerResponse) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
}

function sendJson(res: ServerResponse, status: number, body: unknown) {
  res.writeHead(status, { 'Content-Type': 'application/json' });
  res.end(JSON.stringify(body));
}

function readBody(req: IncomingMessage, maxBytes: number): Promise<Buffer> {
  return new Promise((resolve, reject) => {
    const chunks: Buffer[] = [];
    let total = 0;
    req.on('data', (c: Buffer) => {
      total += c.length;
      if (total > maxBytes) {
        req.destroy(new Error('PAYLOAD_TOO_LARGE'));
        return;
      }
      chunks.push(c);
    });
    req.on('end', () => resolve(Buffer.concat(chunks)));
    req.on('error', reject);
  });
}

const server = createServer(async (req, res) => {
  setCors(res);

  if (req.method === 'OPTIONS') {
    res.writeHead(204).end();
    return;
  }

  if (req.method !== 'POST' || req.url !== '/api/invoices/extract') {
    sendJson(res, 404, { error: 'Not found' });
    return;
  }

  let buf: Buffer;
  try {
    buf = await readBody(req, MAX_BYTES);
  } catch (err) {
    if (err instanceof Error && err.message === 'PAYLOAD_TOO_LARGE') {
      sendJson(res, 413, { error: 'File too large' });
    } else {
      sendJson(res, 400, { error: 'Failed to read body' });
    }
    return;
  }

  if (buf.length === 0) {
    sendJson(res, 400, { error: 'Empty body' });
    return;
  }

  const mimeType = (req.headers['content-type'] ?? '').split(';')[0].trim();
  const factory = new InvoiceFactory(buf, mimeType);

  try {
    const result = await factory.build();
    sendJson(res, result.success ? 200 : 422, result);
  } catch (err) {
    if (err instanceof Error && err.message === 'Unknown type') {
      sendJson(res, 415, { error: 'Unknown type' });
      return;
    }
    console.error('build() failed:', err);
    sendJson(res, 500, { error: 'Internal error' });
  }
});

server.listen(PORT, () => {
  console.log(`Invoice OCR server listening on http://localhost:${PORT}`);
});
