import type { InvoicePeriod } from './electricPatterns.js';
import { parseItNumber } from './numbers.js';

export interface GasData {
  pdr?: string;
  invoicePeriod?: InvoicePeriod;
  supplier?: string;
  localDistributor?: string;
  annualConsumption?: number;
  usageCategories?: string;
  meterSerialNumber?: string;
  remi?: string;
  industrialExciseDuties?: number;
  offerType?: string;
  tariffType?: string;
  atecoCode?: string;
  atecoCategoryDescription?: string;
  gasChargeFromConsumption?: number;
  gasChargeFromFixedFee?: number;
  gasConsumption?: number;
  invoiceDate?: string;
  totalAmount?: number;
}

const PDR_RE = /Codice PDR:?\s*(\d{14})/i;
const PERIOD_RE =
  /Periodo di competenza:?\s*(\d{2}[./-]\d{2}[./-]\d{4})\s*[-–]\s*(\d{2}[./-]\d{2}[./-]\d{4})/i;
const ANNUAL_CONSUMPTION_RE = /Consumo annuo:?\s*([\d.,]+)\s*Smc/i;
const TIPOLOGIA_CLIENTE_RE = /Tipologia cliente:?\s*([^\n]+)/i;
const TIPOLOGIA_USO_RE = /Tipologia d['’]uso:?\s*([^\n]+)/i;
const MATRICOLA_RE = /Matricola contatore:?\s*(\S+)/i;
const REMI_RE = /(?:Cabina di Riduzione e Misura|REMI)[:\s]*([\w\-/]+)/i;
const OFFER_TYPE_RE = /Tipologia offerta:?\s*([^\n]+)/i;
const TARIFF_TYPE_RE = /Tipologia prezzo offerta:?\s*([^\n]+)/i;
const ATECO_CODE_RE = /(?:Codice\s+)?ATECO[^:\n]{0,30}:?\s*(\d{2}\.\d{2}(?:\.\d+)?)/i;
const ATECO_DESC_RE = /(?:Descrizione|Attività)\s+ATECO[:\s]*([^\n]+)/i;
const GAS_CHARGE_CONSUMPTION_RE =
  /Spesa per la vendita di gas naturale:?\s*(?:euro\s*)?([\d.,]+)/i;
const GAS_FIXED_FEE_RE =
  /Quota fissa dovuta in applicazione all['’]offerta:?\s*(?:euro\s*)?([\d.,]+)/i;
const GAS_CONSUMPTION_PERIOD_RE = /Consumo totale fatturato:?\s*([\d.,]+)\s*Smc/i;
const TOTAL_AMOUNT_RE = /TOTALE\s+DA\s+PAGARE\s*[\s\n]+([\d.,]+)/i;
const INVOICE_DATE_RE = /Emessa il:?\s*(\d{2}\.\d{2}\.\d{4})/i;
const SUPPLIER_RE =
  /([A-Z][A-Za-z'.&\-]+(?:\s+[A-Z]?[A-Za-z'.&\-]+){0,3})\s+(?:S\.r\.l\.|S\.p\.A\.)/;
const DISTRIBUTOR_RE =
  /(?:Distributore(?: locale)?|Impresa di distribuzione)[^:\n]{0,40}:\s*([^\n]+)/i;
// Imposta erariale at 22% IVA. The Smc volume (6 decimals) sits glued to the EUR amount
// (2 decimals) in pdf-parse output, so we require the 6-decimal prefix to anchor correctly.
const INDUSTRIAL_EXCISE_RE = /\d+,\d{6}(\d+,\d{2})\s*22%[\d.,]*\s*Imposta erariale/i;

export function extractGas(text: string): GasData {
  const data: GasData = {};

  data.pdr = text.match(PDR_RE)?.[1];

  const period = text.match(PERIOD_RE);
  if (period) data.invoicePeriod = { from: period[1], to: period[2] };

  data.supplier = text.match(SUPPLIER_RE)?.[1]?.trim();
  data.localDistributor = text.match(DISTRIBUTOR_RE)?.[1]?.trim();
  data.annualConsumption = parseItNumber(text.match(ANNUAL_CONSUMPTION_RE)?.[1]);

  const tCliente = text.match(TIPOLOGIA_CLIENTE_RE)?.[1]?.trim();
  const tUso = text.match(TIPOLOGIA_USO_RE)?.[1]?.trim();
  data.usageCategories = [tCliente, tUso].filter(Boolean).join(' / ') || undefined;

  data.meterSerialNumber = text.match(MATRICOLA_RE)?.[1]?.trim();
  data.remi = text.match(REMI_RE)?.[1]?.trim();
  data.offerType = text.match(OFFER_TYPE_RE)?.[1]?.trim();
  data.tariffType = text.match(TARIFF_TYPE_RE)?.[1]?.trim();
  data.atecoCode = text.match(ATECO_CODE_RE)?.[1];
  data.atecoCategoryDescription = text.match(ATECO_DESC_RE)?.[1]?.trim();
  data.gasChargeFromConsumption = parseItNumber(text.match(GAS_CHARGE_CONSUMPTION_RE)?.[1]);
  data.gasChargeFromFixedFee = parseItNumber(text.match(GAS_FIXED_FEE_RE)?.[1]);
  data.gasConsumption = parseItNumber(text.match(GAS_CONSUMPTION_PERIOD_RE)?.[1]);
  data.totalAmount = parseItNumber(text.match(TOTAL_AMOUNT_RE)?.[1]);
  data.invoiceDate = text.match(INVOICE_DATE_RE)?.[1];
  data.industrialExciseDuties = parseItNumber(text.match(INDUSTRIAL_EXCISE_RE)?.[1]);

  return data;
}
