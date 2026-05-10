import { parseItNumber } from './numbers.js';

export interface InvoicePeriod {
  from: string;
  to: string;
}

export interface BandConsumption {
  value: number;
  period?: InvoicePeriod;
}

export interface ElectricData {
  pod?: string;
  invoicePeriod?: InvoicePeriod;
  supplier?: string;
  localDistributor?: string;
  annualConsumption?: number;
  contractedPower?: number;
  voltageLevel?: string;
  intendedUse?: string;
  electricityExpenseFromConsumption?: number;
  electricityChargeFromFixedAndPower?: number;
  offerType?: string;
  tariffType?: string;
  totalActiveEnergyConsumption?: BandConsumption;
  bandF1Consumption?: BandConsumption;
  bandF2Consumption?: BandConsumption;
  bandF3Consumption?: BandConsumption;
  invoiceDate?: string;
  totalAmount?: number;
}

const POD_RE = /Codice POD:?\s*(IT\d{3}E\d{8})/i;
const POWER_RE = /Potenza impegnata:?\s*([\d.,]+)\s*kW\b/i;
const VOLTAGE_RE = /tensione nominale[^:]*:?\s*([A-Z\s]+TENSIONE)\b/i;
const INTENDED_USE_RE = /Tipologia cliente:?\s*([^\n]+)/i;
const ANNUAL_CONSUMPTION_RE = /Consumo annuo:?\s*([\d.,]+)\s*kWh/i;
const OFFER_TYPE_RE = /Tipologia offerta:?\s*([^\n]+)/i;
const TARIFF_TYPE_RE = /Tipologia prezzo offerta:?\s*([^\n]+)/i;
const PERIOD_RE =
  /Periodo di competenza:?\s*(\d{2}[./-]\d{2}[./-]\d{4})\s*[-–]\s*(\d{2}[./-]\d{2}[./-]\d{4})/i;
const ELECTRICITY_EXPENSE_RE =
  /Spesa per la vendita di energia elettrica:?\s*(?:euro\s*)?([\d.,]+)/i;
const FIXED_POWER_RE =
  /Quota fissa dovuta in applicazione all['’]offerta:?\s*(?:euro\s*)?([\d.,]+)/i;
const TOTAL_ACTIVE_RE = /TOTALI CONSUMI ENERGIA ATTIVA[\s\n]+([\d.,]+)/i;
const TOTAL_AMOUNT_RE = /TOTALE\s+DA\s+PAGARE\s*[\s\n]+([\d.,]+)/i;
const INVOICE_DATE_RE = /Emessa il:?\s*(\d{2}\.\d{2}\.\d{4})/i;
const DISTRIBUTOR_RE = /gestito da\s+([A-Z][\w\-]+(?:\s+[\w\-]+){0,3})\s*S\.P\.A\.?/i;
const SUPPLIER_RE =
  /([A-Z][A-Za-z'.&\-]+(?:\s+[A-Z]?[A-Za-z'.&\-]+){0,3})\s+(?:S\.r\.l\.|S\.p\.A\.)/;
const FATTURATI_BANDS_RE = /FATTURATI[\s\n]+([\d,]+)/i;

function findFatturatiBands(
  text: string,
): { f0?: number; f1?: number; f2?: number; f3?: number } | undefined {
  const m = text.match(FATTURATI_BANDS_RE);
  if (!m) return undefined;
  const nums = m[1].match(/\d+,\d{3}/g);
  if (!nums || nums.length < 4) return undefined;
  // Observed column-extraction order in Estra layout: F1 F2 F3 F0
  const [f1, f2, f3, f0] = nums.slice(0, 4).map(parseItNumber);
  return { f0, f1, f2, f3 };
}

export function extractElectric(text: string): ElectricData {
  const data: ElectricData = {};

  data.pod = text.match(POD_RE)?.[1];

  const period = text.match(PERIOD_RE);
  if (period) data.invoicePeriod = { from: period[1], to: period[2] };

  data.supplier = text.match(SUPPLIER_RE)?.[1]?.trim();
  data.localDistributor = text.match(DISTRIBUTOR_RE)?.[1]?.trim();
  data.annualConsumption = parseItNumber(text.match(ANNUAL_CONSUMPTION_RE)?.[1]);
  data.contractedPower = parseItNumber(text.match(POWER_RE)?.[1]);
  data.voltageLevel = text.match(VOLTAGE_RE)?.[1]?.trim();
  data.intendedUse = text.match(INTENDED_USE_RE)?.[1]?.trim();
  data.offerType = text.match(OFFER_TYPE_RE)?.[1]?.trim();
  data.tariffType = text.match(TARIFF_TYPE_RE)?.[1]?.trim();
  data.electricityExpenseFromConsumption = parseItNumber(
    text.match(ELECTRICITY_EXPENSE_RE)?.[1],
  );
  data.electricityChargeFromFixedAndPower = parseItNumber(text.match(FIXED_POWER_RE)?.[1]);
  data.totalAmount = parseItNumber(text.match(TOTAL_AMOUNT_RE)?.[1]);
  data.invoiceDate = text.match(INVOICE_DATE_RE)?.[1];

  const totalActive = parseItNumber(text.match(TOTAL_ACTIVE_RE)?.[1]);
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
