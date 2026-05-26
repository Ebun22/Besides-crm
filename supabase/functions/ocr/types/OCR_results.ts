import type { invoice_type } from "./invoiceTypes.ts";

export interface invoice_period {
  from : string;
  to   : string;
};

export class customer_data {
  supply_holder   : string | null;
  tax_code        : string | null;
  mailing_address : string | null;
  payment_type    : string | null;
  supply_address  : string | null;

  constructor() {
    this.supply_holder   = null,
    this.tax_code        = null,
    this.mailing_address = null,
    this.payment_type    = null,
    this.supply_address  = null
  }
};

export class electric_data {
  invoice_type             : string | null;
  pod                      : string | null;
  billing_period           : invoice_period | null;
  invoice_issue_date       : string | null;
  supplier                 : string | null;
  local_distributor        : string | null;
  annual_consumption       : number | null;
  contracted_power         : number | null;
  voltage_level            : string | null;
  intended_use             : string | null;
  consumption_quote        : number | null;
  fixed_power_quote        : number | null;
  offer_type               : string | null;
  tariff_type              : string | null;
  total_active_consumption : number | null;
  band_F1                  : number | null;
  band_F2                  : number | null;
  band_F3                  : number | null;
  total_amount             : number | null;

  constructor () {
    this.invoice_type             = null,
    this.pod                      = null,
    this.billing_period           = null,
    this.invoice_issue_date       = null,
    this.supplier                 = null,
    this.local_distributor        = null,
    this.annual_consumption       = null,
    this.contracted_power         = null,
    this.voltage_level            = null,
    this.intended_use             = null,
    this.consumption_quote        = null,
    this.fixed_power_quote        = null,
    this.offer_type               = null,
    this.tariff_type              = null,
    this.total_active_consumption = null,
    this.band_F1                  = null,
    this.band_F2                  = null,
    this.band_F3                  = null,
    this.total_amount             = null
  }
};

export class gas_data {
  invoice_type               : string | null;
  pdr                        : string | null;
  billing_period             : invoice_period | null;
  invoice_issue_date         : string | null;
  supplier                   : string | null;
  local_distributor          : string | null;
  annual_consumption         : number | null;
  usage_categories           : string | null;
  meter_serial_number        : string | null;
  remi                       : string | null;
  offer_type                 : string | null;
  tariff_type                : string | null;
  ateco_code                 : string | null;
  ateco_category_description : string | null;
  consumption_quote          : number | null;
  fixed_gas_quote            : number | null;
  gas_consumption            : number | null;
  total_amount               : number | null;
  industrial_excise_duties   : boolean | null;

  constructor () {
    this.invoice_type                = null,
    this.pdr                         = null,
    this.billing_period              = null,
    this.invoice_issue_date          = null,
    this.supplier                    = null,
    this.local_distributor           = null,
    this.annual_consumption          = null,
    this.usage_categories            = null,
    this.meter_serial_number         = null,
    this.remi                        = null,
    this.offer_type                  = null,
    this.tariff_type                 = null,
    this.ateco_code                  = null,
    this.ateco_category_description  = null,
    this.consumption_quote           = null,
    this.fixed_gas_quote             = null,
    this.gas_consumption             = null,
    this.total_amount                = null,
    this.industrial_excise_duties    = null
  }
};

export interface OCR_result {
  type       : invoice_type;
  result     : {
    customer : customer_data | null;
    electric : electric_data | null;
    gas      : gas_data | null;
  };
  confidence : number;
};

export type build_result = {
  success : boolean;
  data    : OCR_result | null;
  error   : string | null;
};
