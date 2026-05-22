import type { invoice_type } from "./types/invoiceTypes";

export function detectInvoiceType(text: string): invoice_type {
  const electric =
    /Servizio:\s*Energia Elettrica/i.test(text) ||
    /Codice POD\s*:/i.test(text) ||
    /\bIT\d{3}E\d{8}\b/.test(text);

  const gas =
    /Servizio:\s*Gas naturale/i.test(text) ||
    /Codice PDR\s*:/i.test(text) ||
    /\bConsumo annuo:?\s*[\d.,]+\s*Smc\b/i.test(text);

  if (electric && gas) return 'dual';
  if (electric) return 'electric';
  if (gas) return 'gas';
  return 'unknown';
}
