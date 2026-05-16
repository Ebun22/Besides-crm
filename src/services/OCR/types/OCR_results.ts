export interface invoice_period {
  from: string;
  to: string;
};

export interface band_consumption {
  value: number;
  period?: invoice_period;
};

export interface electric_data {
  pod?: string;
  invoicePeriod?: invoice_period;
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
  totalActiveEnergyConsumption?: band_consumption;
  bandF1Consumption?: band_consumption;
  bandF2Consumption?: band_consumption;
  bandF3Consumption?: band_consumption;
  invoiceDate?: string;
  totalAmount?: number;
};

export interface gas_data {
  pdr?: string;
  invoicePeriod?: invoice_period;
  invoiceDate?: string;
  supplier?: string;
  localDistributor?: string;
  annualConsumption?: number;
  usageCategories?: string;
  meterSerialNumber?: string;
  remi?: string;
  offerType?: string;
  tariffType?: string;
  atecoCode?: string;
  atecoCategoryDescription?: string;
  gasChargeFromConsumption?: number;
  gasChargeFromFixedFee?: number;
  gasConsumption?: number;
  totalAmount?: number;
  industrialExciseDuties?: boolean;
};

export interface OCR_result {
    gas      : gas_data | null,
    electric : electric_data | null,
}