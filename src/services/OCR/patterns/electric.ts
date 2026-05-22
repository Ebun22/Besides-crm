import { parseItNumber }      from '../numbers.js';
import { electric_data } from '../types/OCR_results.js';

const INVOICE_TYPE_RE                = /Numero fattura elettronica:?\s*([^\n]+)/i;
const POD_RE                      = /Codice POD:?\s*(IT\d{3}E\d{8})/i;
const BILLING_PERIOD_RE           = /(?:Periodo di competenza|Periodo di Fatturazione):?\s*(\d{2}[./-]\d{2}[./-]\d{4})\s*[-–]\s*(\d{2}[./-]\d{2}[./-]\d{4})/i;
const INVOICE_ISSUE_DATE_RE       = /Emessa il:?\s*(\d{2}\.\d{2}\.\d{4})/i;
const CONTRACTED_POWER_RE         = /Potenza impegnata:?\s*([\d.,]+)\s*kW\b/i;
const VOLTAGE_LEVEL_RE            = /(?:Valore di tensione nominale per alimentazione|Tensione di fornitura|Livello di tensione|Livello di consegna)\s*:?\s*([^\n]+)/i;
const INTENDED_USE_RE             = /Tipologia cliente:?\s*([^\n]+)/i;
const ANNUAL_CONSUMPTION_RE       = /Consumo annuo:?\s*([\d.,]+)\s*kWh/i;
const TOTAL_ACTIVE_CONSUMPTION_RE = /TOTALI CONSUMI ENERGIA ATTIVA[\s\n]+([\d.,]+)/i;
const OFFER_TYPE_RE               = /Tipologia offerta:?\s*([^\n]+)/i;
const TARIFF_TYPE_RE              = /Tipologia prezzo offerta:?\s*([^\n]+)/i;
const CONSUMPTION_QUOTE_RE        = /Quota per consumi:?\s*[\d.,]+\s*kWh\s*(\d+[,.]\d{2})/i;
const FIXED_POWER_QUOTE_RE        = /(?:Quota fissa e quota potenza|Quota fissa):?\s*[\d.,\s]+\s*PERC\s*(\d+[,.]\d{2})/i;
const TOTAL_AMOUNT_RE             = /TOTALE\s+DA\s+PAGARE\s*[\s\n]+([\d+[,.]\d{2})/i;
const DISTRIBUTOR_RE              = /gestito da\s+([A-Z][\w\-]+(?:\s+[\w\-]+){0,3})\s*(?:S\.r\.l\.|S\.p\.A\.|S\.n\.c|S\.a\.s)?/i;
const SUPPLIER_RE                 = /([A-Z][A-Za-z'.&\-]+(?:\s+[A-Z]?[A-Za-z'.&\-]+){0,3})\s+(?:S\.r\.l\.|S\.p\.A\.|S\.n\.c|S\.a\.s)/;
const BAND_F1                     = /FATTURATI\s*(\d+[,.]\d{3})/i;
const BAND_F2                     = /FATTURATI\s*(?:\d+[,.]\d{3})\s*(\d+[,.]\d{3})/i;
const BAND_F3                     = /FATTURATI\s*(?:\d+[,.]\d{3})\s*(\d+[,.]\d{3})\s*(\d+[,.]\d{3})/i;

export function extract_electric(text : string) : electric_data {
  const data : electric_data = new electric_data();

  data.pod = text.match(POD_RE)?.[1] ?? null;

  const period = text.match(BILLING_PERIOD_RE);
  if (period) data.billing_period = { from: period[1], to: period[2] };

  data.supplier = text.match(SUPPLIER_RE)?.[1]?.trim() ?? null;
  data.local_distributor = text.match(DISTRIBUTOR_RE)?.[1]?.trim() ?? null;
  data.annual_consumption = parseItNumber(text.match(ANNUAL_CONSUMPTION_RE)?.[1]) ?? null;
  data.contracted_power = parseItNumber(text.match(CONTRACTED_POWER_RE)?.[1]) ?? null;
  data.voltage_level = text.match(VOLTAGE_LEVEL_RE)?.[1]?.trim() ?? null;
  data.intended_use = text.match(INTENDED_USE_RE)?.[1]?.trim() ?? null;
  data.offer_type = text.match(OFFER_TYPE_RE)?.[1]?.trim() ?? null;
  data.tariff_type = text.match(TARIFF_TYPE_RE)?.[1]?.trim() ?? null;
  data.consumption_quote = parseItNumber(text.match(CONSUMPTION_QUOTE_RE)?.[1]) ?? null;
  data.fixed_power_quote = parseItNumber(text.match(FIXED_POWER_QUOTE_RE)?.[1]) ?? null;
  data.total_amount = parseItNumber(text.match(TOTAL_AMOUNT_RE)?.[1]) ?? null;
  data.invoice_issue_date = text.match(INVOICE_ISSUE_DATE_RE)?.[1] ?? null;
  data.band_F1 = parseItNumber(text.match(BAND_F1)?.[1]) ?? null;
  data.band_F2 = parseItNumber(text.match(BAND_F2)?.[1]) ?? null;
  data.band_F3 = parseItNumber(text.match(BAND_F3)?.[1]) ?? null;
  data.invoice_type = text.match(INVOICE_TYPE_RE)?.[1].trim() ? 'Electronic' : 'Paper';

  const totalActive = parseItNumber(text.match(TOTAL_ACTIVE_CONSUMPTION_RE)?.[1]);
  if (totalActive !== undefined) {
    data.total_active_consumption = totalActive ?? (Number(data.band_F1) + Number(data.band_F2) + Number(data.band_F3))
  }

  return data;
}
