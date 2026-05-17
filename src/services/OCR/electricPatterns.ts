import { parseItNumber }      from './numbers.js';
import { type electric_data } from './types/OCR_results.js';

const POD_RE                      = /Codice POD:?\s*(IT\d{3}E\d{8})/i;
const BILLING_PERIOD_RE           = /(?:Periodo di competenza|Periodo di Fatturazione):?\s*(\d{2}[./-]\d{2}[./-]\d{4})\s*[-–]\s*(\d{2}[./-]\d{2}[./-]\d{4})/i;
const INVOICE_ISSUE_DATE_RE       = /Emessa il:?\s*(\d{2}\.\d{2}\.\d{4})/i;
const CONTRACTED_POWER_RE         = /Potenza impegnata:?\s*([\d.,]+)\s*kW\b/i;
const VOLTAGE_LEVEL_RE            = /tensione nominale[^:]*:?\s*([A-Z\s]+TENSIONE)\b/i;
const INTENDED_USE_RE             = /Tipologia cliente:?\s*([^\n]+)/i;
const ANNUAL_CONSUMPTION_RE       = /Consumo annuo:?\s*([\d.,]+)\s*kWh/i;
const TOTAL_ACTIVE_CONSUMPTION_RE = /TOTALI CONSUMI ENERGIA ATTIVA[\s\n]+([\d.,]+)/i;
const OFFER_TYPE_RE               = /Tipologia offerta:?\s*([^\n]+)/i;
const TARIFF_TYPE_RE              = /Tipologia prezzo offerta:?\s*([^\n]+)/i;
const CONSUMPTION_QUOTE_RE        = /Quota per consumi:?\s*[\d.,]+\s*kWh\s*(\d+[,.]\d{2})/i;
const FIXED_POWER_RE              = /(?:Quota fissa e quota potenza|Quota fissa):?\s*[\d.,\s]+\s*PERC\s*(\d+[,.]\d{2})/i;
const TOTAL_AMOUNT_RE             = /TOTALE\s+DA\s+PAGARE\s*[\s\n]+([\d+[,.]\d{2})/i;
const DISTRIBUTOR_RE              = /gestito da\s+([A-Z][\w\-]+(?:\s+[\w\-]+){0,3})\s*(?:S\.r\.l\.|S\.p\.A\.|S\.n\.c|S\.a\.s)?/i;
const SUPPLIER_RE                 = /([A-Z][A-Za-z'.&\-]+(?:\s+[A-Z]?[A-Za-z'.&\-]+){0,3})\s+(?:S\.r\.l\.|S\.p\.A\.|S\.n\.c|S\.a\.s)/;
const BAND_F1                     = /F0F1F2F3\s*([\d,]+)/i;
const BAND_F2                     = /FATTURATI[\s\n]+([\d,]+)/i;
const BAND_F3                     = /FATTURATI[\s\n]+([\d,]+)/i;



export function extractElectric(text: string): electric_data {
  const data: electric_data = {};

  data.pod = text.match(POD_RE)?.[1];

  const period = text.match(BILLING_PERIOD_RE);
  if (period) data.invoicePeriod = { from: period[1], to: period[2] };

  data.supplier = text.match(SUPPLIER_RE)?.[1]?.trim();
  data.localDistributor = text.match(DISTRIBUTOR_RE)?.[1]?.trim();
  data.annualConsumption = parseItNumber(text.match(ANNUAL_CONSUMPTION_RE)?.[1]);
  data.contractedPower = parseItNumber(text.match(CONTRACTED_POWER_RE)?.[1]);
  data.voltageLevel = text.match(VOLTAGE_LEVEL_RE)?.[1]?.trim();
  data.intendedUse = text.match(INTENDED_USE_RE)?.[1]?.trim();
  data.offerType = text.match(OFFER_TYPE_RE)?.[1]?.trim();
  data.tariffType = text.match(TARIFF_TYPE_RE)?.[1]?.trim();
  data.electricityExpenseFromConsumption = parseItNumber(
    text.match(CONSUMPTION_QUOTE_RE)?.[1],
  );
  data.electricityChargeFromFixedAndPower = parseItNumber(text.match(FIXED_POWER_RE)?.[1]);
  data.totalAmount = parseItNumber(text.match(TOTAL_AMOUNT_RE)?.[1]);
  data.invoiceDate = text.match(INVOICE_ISSUE_DATE_RE)?.[1];

  const totalActive = parseItNumber(text.match(TOTAL_ACTIVE_CONSUMPTION_RE)?.[1]);
  if (totalActive !== undefined) {
    data.totalActiveEnergyConsumption = { value: totalActive, period: data.invoicePeriod };
  }

  const bands = findFatturatiBands(text);
  if (bands) {
    if (bands.f1 !== undefined)
      data.bandF1Consumption = { value: bands.f1, period: data.invoicePeriod };
    if (bands.f2 !== undefined)
      data.bandF2Consumption = { value: bands.f2, period: data.invoicePeriod };
    if (bands.f3 !== undefined)
      data.bandF3Consumption = { value: bands.f3, period: data.invoicePeriod };
  }

  return data;
}
