import pdfParse from 'pdf-parse';

export async function extractTextFromPdf(buffer: Buffer): Promise<string> {
  const result = await pdfParse(buffer);
  console.log("this is invoice result: ", result)
  return result.text ?? '';
}
