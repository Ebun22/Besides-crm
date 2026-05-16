export interface CustomerData {
  supplyHolder?: string;
  taxCode?: string;
  mailingAddress?: string;
  paymentType?: string;
  supplyAddress?: string;
  postalCode?: string;
  supplyLocation?: string;
  supplyProvince?: string;
}

const SUPPLY_HOLDER_RE = /Intestatario\s+fornitura:?\s*([^\n]+)/i;
const TAX_CODE_RE = /(?:C\.?F\.?|Codice\s+Fiscale)\.?:?\s*([A-Z0-9]{11,16})\b/i;
const MAILING_ADDRESS_RE = /Indirizzo\s+di\s+[Rr]ecapito:?\s*([^\n]+)/i;
const PAYMENT_TYPE_RE = /Modalit[àa]\s+di\s+pagamento:?\s*([^\n]+)/i;
const SUPPLY_ADDRESS_RE = /Indirizzo\s+di\s+fornitura:?\s*([^\n]+)/i;
const POSTAL_CODE_RE = /\bCAP:?\s*(\d{5})\b/i;
// Stop at next labelled field (Prov./CAP) or a long run of whitespace separating columns.
const SUPPLY_LOCATION_RE = /Localit[àa]:?\s*([^\n]+?)(?=\s{2,}|\s+Prov\b|\s+CAP\b|$)/i;
const SUPPLY_PROVINCE_RE = /Prov(?:incia)?\.?:?\s*([A-Z]{2})\b/;

export function extractCustomer(text: string): CustomerData {
  const data: CustomerData = {};

  data.supplyHolder = text.match(SUPPLY_HOLDER_RE)?.[1]?.trim();
  data.taxCode = text.match(TAX_CODE_RE)?.[1]?.trim();
  data.mailingAddress = text.match(MAILING_ADDRESS_RE)?.[1]?.trim();
  data.paymentType = text.match(PAYMENT_TYPE_RE)?.[1]?.trim();
  data.supplyAddress = text.match(SUPPLY_ADDRESS_RE)?.[1]?.trim();
  data.postalCode = text.match(POSTAL_CODE_RE)?.[1];
  data.supplyLocation = text.match(SUPPLY_LOCATION_RE)?.[1]?.trim();
  data.supplyProvince = text.match(SUPPLY_PROVINCE_RE)?.[1];

  return data;
}
