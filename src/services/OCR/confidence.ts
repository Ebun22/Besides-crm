import type { electric_data } from './electricPatterns';
import type { gas_data } from './gasPatterns';

export type FieldStatus = 'ok' | 'missing';

export interface DataConfidence<T> {
  confidence: number;
  fields: { [K in keyof T]-?: FieldStatus };
}

const ELECTRIC_FIELDS: (keyof electric_data)[] = [
  'pod',
  'invoicePeriod',
  'supplier',
  'localDistributor',
  'annualConsumption',
  'contractedPower',
  'voltageLevel',
  'intendedUse',
  'electricityExpenseFromConsumption',
  'electricityChargeFromFixedAndPower',
  'offerType',
  'tariffType',
  'totalActiveEnergyConsumption',
  'bandF1Consumption',
  'bandF2Consumption',
  'bandF3Consumption',
  'invoiceDate',
  'totalAmount',
];

const GAS_FIELDS: (keyof gas_data)[] = [
  'pdr',
  'invoicePeriod',
  'supplier',
  'localDistributor',
  'annualConsumption',
  'usageCategories',
  'meterSerialNumber',
  'remi',
  'industrialExciseDuties',
  'offerType',
  'tariffType',
  'atecoCode',
  'atecoCategoryDescription',
  'gasChargeFromConsumption',
  'gasChargeFromFixedFee',
  'gasConsumption',
  'invoiceDate',
  'totalAmount',
];

function score<T extends object>(data: T, keys: (keyof T)[]): DataConfidence<T> {
  const fields = {} as { [K in keyof T]-?: FieldStatus };
  let ok = 0;
  for (const k of keys) {
    const v = data[k];
    const present = v !== undefined && v !== null;
    fields[k] = present ? 'ok' : 'missing';
    if (present) ok++;
  }
  return {
    confidence: Math.round((ok / keys.length) * 100),
    fields,
  };
}

export function computeElectricConfidence(data: electric_data): DataConfidence<electric_data> {
  return score(data, ELECTRIC_FIELDS);
}

export function computeGasConfidence(data: gas_data): DataConfidence<gas_data> {
  return score(data, GAS_FIELDS);
}
