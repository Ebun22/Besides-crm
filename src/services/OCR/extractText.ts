import pdfParse from 'pdf-parse/lib/pdf-parse.js';

export async function extractTextFromPdf(buffer: Buffer): Promise<string> {
  const result = await pdfParse(buffer);
  return result.text ?? '';
}
