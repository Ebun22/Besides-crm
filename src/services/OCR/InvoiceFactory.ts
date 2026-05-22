import {
  compute_total_confidence_score,
  type DataConfidence,
} from './confidence';
import { detectInvoiceType } from './detectType';
import { extractCustomer } from './patterns/customer';
import { extract_electric} from './patterns/electric';
import { extractTextFromPdf } from './extractText';
import { extractGas} from './patterns/gas';
import { type invoice_type } from './types/invoiceTypes';
import type {
  build_result,
  customer_data,
  electric_data,
  gas_data,
  OCR_result
} from './types/OCR_results';



export class InvoiceFactory {
  private type: invoice_type              = 'unknown';
  private customer: customer_data | null = null;
  private electric: electric_data | null = null;
  private gas: gas_data | null           = null;

  constructor(
    private readonly file: Buffer,
    private readonly mimeType: string,
  ) {}

  setType(v : invoice_type) {
    this.type = v;
  };

  setCustomer(v : customer_data | null) {
    this.customer = v;
  };

  setElectric(v : electric_data | null) {
    this.electric = v;
  };

  setGas(v : gas_data | null) {
    this.gas = v;
  }

  getType() {
    return this.type;
  };

  getCustomer() {
    return this.customer;
  };

  getElectric() {
    return this.electric;
  };

  getGas() {
    return this.gas;
  };

  async build(): Promise<build_result> {
    if (this.mimeType !== 'application/pdf') {
      throw new Error('Unknown type');
    }

    let error : string | null = null;
    let text  : string        = '';

    try {
      text = await extractTextFromPdf(this.file);
      if (!text.trim()) error = "can't read invoice";
    } catch {
      error = "can't read invoice";
    }

    if (!error) {
      this.setType(detectInvoiceType(text));
      if (this.type === 'unknown') {
        error = 'unknown invoice type';
      }
    }

    if (!error) {
      this.setCustomer(extractCustomer(text));
      if (this.type === 'electric' || this.type === 'dual') {
        this.setElectric(extract_electric(text));
      }
      if (this.type === 'gas' || this.type === 'dual') {
        this.setGas(extractGas(text));
      }
    }

    const success = error === null;

    if (error) {
      console.error(`InvoiceFactory.build failed: ${error}`);
    }

    return {
      success,
      data : success
        ? {
            type   : this.type,
            result : {
              customer : this.customer,
              electric : this.electric,
              gas      : this.gas,
            },
            confidence : compute_total_confidence_score(
              this.customer,
              this.electric,
              this.gas,
            ),
          }
        : null,
      error,
    };
  }
};
