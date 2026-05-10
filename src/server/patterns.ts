const SUPPLIER_RE = /(?:Fornitore|Supplier|Venditore)\s*[:\-]?\s*([A-Za-z0-9 &.'\-]{3,60})/i;
const POD_RE = /\bIT\d{3}E\d{8}\b/;
const PDR_RE = /\b\d{14}\b/;
const CONSUMPTION_RE = /([\d.,]+)\s*(?:kWh|Smc)\b/i;
const AMOUNT_RE = /(?:Totale|Total|Importo)[^\d]{0,20}(?:€|EUR)?\s*([\d.,]+)/i;
const DATE_RE = /\b(\d{2}[/.-]\d{2}[/.-]\d{4})\b/;

function parseNumber(raw: string): number | undefined {
  const cleaned = raw.replace(/\./g, '').replace(',', '.');
  const n = Number(cleaned);
  return Number.isFinite(n) ? n : undefined;
}

export function findSupplier(text: string): string | undefined {
  return text.match(SUPPLIER_RE)?.[1]?.trim();
}

export function findPod(text: string): string | undefined {
  return text.match(POD_RE)?.[0];
}

export function findPdr(text: string): string | undefined {
  return text.match(PDR_RE)?.[0];
}

export function findConsumption(text: string): number | undefined {
  const m = text.match(CONSUMPTION_RE);
  return m ? parseNumber(m[1]) : undefined;
}

export function findAmount(text: string): number | undefined {
  const m = text.match(AMOUNT_RE);
  return m ? parseNumber(m[1]) : undefined;
}

export function findInvoiceDate(text: string): string | undefined {
  return text.match(DATE_RE)?.[1];
}
