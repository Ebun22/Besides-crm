import {
  computeElectricConfidence,
  computeGasConfidence,
  type DataConfidence,
} from './confidence';
import { detectInvoiceType } from './detectType';
import { extractElectric} from './electricPatterns';
import { extractTextFromPdf } from './extractText';
import { extractGas} from './gasPatterns';
import { type InvoiceType } from './types/invoiceTypes';
import { type electric_data, type gas_data, type OCR_result } from './types/OCR_results';

export type BuildResult =
  | {
      ok    : true;
      type  : InvoiceType;
      data  : OCR_result
      error : string | null;
      electric: electric_data | null;
      gas: gas_data | null;
      electricConfidence: DataConfidence<electric_data> | null;
      gasConfidence: DataConfidence<gas_data> | null;
    }
  | { ok: false; error: "can't read invoice" }
  | { ok: false; error: 'unknown invoice type' };

export class InvoiceFactory {
  private type: InvoiceType              = 'unknown';
  private electric: electric_data | null = null;
  private gas: gas_data | null           = null;

  constructor(
    private readonly file: Buffer,
    private readonly mimeType: string,
  ) {}

  setType(v : InvoiceType) {
    this.type = v;
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

    if (this.type === 'electric' || this.type === 'dual') {
      this.setElectric(extractElectric(text));
    }
    if (this.type === 'gas' || this.type === 'dual') {
      this.setGas(extractGas(text));
    }

    return {
      ok: true,
      type: this.type,
      electric: this.electric,
      gas: this.gas,
      electricConfidence: this.electric ? computeElectricConfidence(this.electric) : null,
      gasConfidence: this.gas ? computeGasConfidence(this.gas) : null,
    };
  }
}
