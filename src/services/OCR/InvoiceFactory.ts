import {
  compute_customer_confidence,
  compute_electric_confidence,
  compute_gas_confidence,
  type DataConfidence,
} from './confidence';
import { detectInvoiceType } from './detectType';
import { extractCustomer } from './patterns/customer';
import { extract_electric} from './patterns/electric';
import { extractTextFromPdf } from './extractText';
import { extractGas} from './patterns/gas';
import { type InvoiceType } from './types/invoiceTypes';
import {
  type customer_data,
  type electric_data,
  type gas_data,
  type OCR_result,
} from './types/OCR_results';

export type BuildResult =
  | {
      ok    : true;
      type  : InvoiceType;
      data  : OCR_result
      error : string | null;
      customer: customer_data | null;
      electric: electric_data | null;
      gas: gas_data | null;
      customerConfidence: DataConfidence<customer_data> | null;
      electricConfidence: DataConfidence<electric_data> | null;
      gasConfidence: DataConfidence<gas_data> | null;
    }
  | { ok: false; error: "can't read invoice" }
  | { ok: false; error: 'unknown invoice type' };

export class InvoiceFactory {
  private type: InvoiceType              = 'unknown';
  private customer: customer_data | null = null;
  private electric: electric_data | null = null;
  private gas: gas_data | null           = null;

  constructor(
    private readonly file: Buffer,
    private readonly mimeType: string,
  ) {}

  setType(v : InvoiceType) {
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

  async build(): Promise<BuildResult> {
    if (this.mimeType !== 'application/pdf') {
      throw new Error('Unknown type');
    }

    let text: string;
    try {
      text = await extractTextFromPdf(this.file);
    } catch {
      return { ok: false, error: "can't read invoice" };
    }
    if (!text.trim()) {
      return { ok: false, error: "can't read invoice" };
    }

    this.setType(detectInvoiceType(text));

    if (this.type === 'unknown') {
      return { ok: false, error: 'unknown invoice type' };
    }

    this.setCustomer(extractCustomer(text));

    if (this.type === 'electric' || this.type === 'dual') {
      this.setElectric(extract_electric(text));
    }
    if (this.type === 'gas' || this.type === 'dual') {
      this.setGas(extractGas(text));
    }

    return {
      ok: true,
      type: this.type,
      customer: this.customer,
      electric: this.electric,
      gas: this.gas,
      customerConfidence: this.customer ? compute_customer_confidence(this.customer) : null,
      electricConfidence: this.electric ? compute_electric_confidence(this.electric) : null,
      gasConfidence: this.gas ? compute_gas_confidence(this.gas) : null,
    };
  }
}
