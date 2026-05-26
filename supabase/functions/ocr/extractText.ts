import { extractText } from 'npm:unpdf@0.12.1';

export async function extractTextFromPdf(buffer: Uint8Array): Promise<string> {
  const { text } = await extractText(buffer, { mergePages: true });
  console.log(Array.isArray(text) ? text.join('\n') : (text ?? ''))
  return Array.isArray(text) ? text.join('\n') : (text ?? '');
}
