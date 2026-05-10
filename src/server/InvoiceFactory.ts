import { detectInvoiceType, type InvoiceType } from './detectType.js';
import { extractElectric, type ElectricData } from './electricPatterns.js';
import { extractTextFromPdf } from './extractText.js';
import { extractGas, type GasData } from './gasPatterns.js';

export type BuildResult =
  | {
      ok: true;
      type: 'electric' | 'gas' | 'dual';
      electric: ElectricData | null;
      gas: GasData | null;
    }
  | { ok: false; error: "can't read invoice" }
  | { ok: false; error: 'unknown invoice type' };

export class InvoiceFactory {
  private type?: InvoiceType;
  private electric: ElectricData | null = null;
  private gas: GasData | null = null;

  constructor(
    private readonly file: Buffer,
    private readonly mimeType: string,
  ) {}

  setType(v: InvoiceType) { this.type = v; }
  setElectric(v: ElectricData | null) { this.electric = v; }
  setGas(v: GasData | null) { this.gas = v; }

  getType() { return this.type; }
  getElectric() { return this.electric; }
  getGas() { return this.gas; }

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
    };
  }
}
