import { customer_data } from "../types/OCR_results";

const SUPPLY_HOLDER_RE        = /Intestatario\s+fornitura:?\s*([^\n]+)/i;
const TAX_CODE_RE             = /(?:C\.?F\.?|Codice\s+Fiscale)\.?:?\s*([A-Z0-9]{11,16})\b/i;
const SUPPLY_ADDRESS_RE       = /(?:Indirizzo\s+di\s+ecapito|Indirizzo):?\s*([^\n]+)/i;
const RESIDENTIAL_ADDRESS_RE  = /Periodo di competenza:?\s*[^\n]+\n[^\n]+\n\s*([^\n]+\n[^\n]+\n)/i;

export function extractCustomer(text: string): customer_data {
  const data: customer_data = new customer_data();

  data.supply_holder   = text.match(SUPPLY_HOLDER_RE)?.[1]?.trim() ?? null;
  data.tax_code        = text.match(TAX_CODE_RE)?.[1]?.trim() ?? null;
  data.mailing_address = text.match(RESIDENTIAL_ADDRESS_RE)?.[1]?.trim() ?? null;
  data.supply_address  = text.match(SUPPLY_ADDRESS_RE)?.[1]?.trim() ?? null;

  return data;
}
