import { customer_data } from "../types/OCR_results.ts";

const SUPPLY_HOLDER_RE   = /Intestatario\s+fornitura:?\s*([A-ZÀ-Ý]{2,}(?:\s+[A-ZÀ-Ý]{2,})*)/;
const TAX_CODE_RE        = /(?:C\.?F\.?|Codice\s+Fiscale)\.?:?\s*([A-Z0-9]{11,16})\b/i;
const SUPPLY_ADDRESS_RE  = /Indirizzo(?:\s+di\s+(?:r?ecapito|fornitura))?:?\s*([A-ZÀ-Ý][A-ZÀ-Ý0-9'.\-,\s]{2,}?\s+\d{5}\s+[A-ZÀ-Ý][A-ZÀ-Ý\s]{0,40}?\s+[A-Z]{2})\b/;
const MAILING_ADDRESS_RE = /((?:VIA|VIALE|PIAZZA|PIAZZALE|CORSO|LARGO|STRADA|VICOLO)\s+[A-ZÀ-Ý0-9'.\-,\s]+?\s+\d{5}\s+[A-ZÀ-Ý][A-ZÀ-Ý\s]{0,40}?\s+[A-Z]{2})\b/;

export function extractCustomer(text: string): customer_data {
  const data: customer_data = new customer_data();

  data.supply_holder  = text.match(SUPPLY_HOLDER_RE)?.[1]?.trim() ?? null;
  data.tax_code       = text.match(TAX_CODE_RE)?.[1]?.trim() ?? null;
  data.supply_address = text.match(SUPPLY_ADDRESS_RE)?.[1]?.replace(/\s+/g, ' ').trim() ?? null;

  const mailing = text.match(MAILING_ADDRESS_RE)?.[1]?.replace(/\s+/g, ' ').trim() ?? null;
  data.mailing_address = mailing && mailing !== data.supply_address ? mailing : null;

  return data;
}
