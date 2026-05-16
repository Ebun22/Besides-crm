import { useState } from 'react';
import type { band_consumption, electric_data, gas_data, invoice_period } from './services/OCR/types/OCR_results';

const OCR_ENDPOINT =
  import.meta.env.VITE_OCR_ENDPOINT ?? 'http://localhost:3001/api/invoices/extract';

interface ExtractedResult {
  type: 'electric' | 'gas' | 'dual';
  electric: electric_data | null;
  gas: gas_data | null;
}

const ELECTRIC_FIELDS: Array<{
  key: keyof electric_data;
  label: string;
  type?: 'number' | 'text' | 'period';
}> = [
  { key: 'pod', label: 'POD' },
  { key: 'invoicePeriod', label: 'Periodo di competenza', type: 'period' },
  { key: 'supplier', label: 'Fornitore (corrente)' },
  { key: 'localDistributor', label: 'Distributore locale' },
  { key: 'annualConsumption', label: 'Consumo annuo (kWh)', type: 'number' },
  { key: 'contractedPower', label: 'Potenza impegnata (kW)', type: 'number' },
  { key: 'voltageLevel', label: 'Livello di tensione' },
  { key: 'intendedUse', label: 'Tipologia cliente / uso' },
  { key: 'offerType', label: "Tipologia offerta" },
  { key: 'tariffType', label: 'Tipologia prezzo (tariffa)' },
  {
    key: 'electricityExpenseFromConsumption',
    label: 'Spesa per la vendita (quota consumo) €',
    type: 'number',
  },
  {
    key: 'electricityChargeFromFixedAndPower',
    label: 'Quota fissa e potenza €',
    type: 'number',
  },
  { key: 'invoiceDate', label: 'Data emissione' },
  { key: 'totalAmount', label: 'Totale da pagare €', type: 'number' },
];

const GAS_FIELDS: Array<{
  key: keyof gas_data;
  label: string;
  type?: 'number' | 'text';
}> = [
  { key: 'pdr', label: 'PDR' },
  { key: 'supplier', label: 'Fornitore gas (corrente)' },
  { key: 'localDistributor', label: 'Distributore locale' },
  { key: 'annualConsumption', label: 'Consumo annuo (Smc)', type: 'number' },
  { key: 'usageCategories', label: "Categorie d'uso" },
  { key: 'meterSerialNumber', label: 'Matricola contatore' },
  { key: 'remi', label: 'Cabina REMI' },
  { key: 'industrialExciseDuties', label: 'Accise industriali €'},
  { key: 'offerType', label: 'Tipologia offerta' },
  { key: 'tariffType', label: 'Tipologia prezzo (tariffa)' },
  { key: 'atecoCode', label: 'Codice ATECO' },
  { key: 'atecoCategoryDescription', label: 'Descrizione ATECO' },
  {
    key: 'gasChargeFromConsumption',
    label: 'Spesa per la vendita gas (quota consumo) €',
    type: 'number',
  },
  { key: 'gasChargeFromFixedFee', label: 'Quota fissa €', type: 'number' },
  { key: 'gasConsumption', label: 'Consumo periodo (Smc)', type: 'number' },
  { key: 'invoiceDate', label: 'Data emissione' },
  { key: 'totalAmount', label: 'Totale da pagare €', type: 'number' },
];

function fmt(value: unknown): string {
  if (value === undefined || value === null) return '';
  if (typeof value === 'object' && value !== null && 'from' in value && 'to' in value) {
    const p = value as invoice_period;
    return `${p.from} → ${p.to}`;
  }
  if (typeof value === 'object' && value !== null && 'value' in value) {
    const b = value as band_consumption;
    const range = b.period ? ` (${b.period.from} → ${b.period.to})` : '';
    return `${b.value}${range}`;
  }
  return String(value);
}

function Field({
  label,
  value,
  onChange,
  type = 'text',
}: {
  label: string;
  value: string;
  onChange: (value: string) => void;
  type?: 'text' | 'number';
}) {
  return (
    <label className="block">
      <span className="block text-xs font-medium text-gray-700 mb-1">{label}</span>
      <input
        type={type}
        value={value}
        onChange={(e) => onChange(e.target.value)}
        className="w-full px-3 py-2 text-sm border border-gray-300 rounded
          bg-white text-gray-900
          focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
      />
    </label>
  );
}

function SectionElectric({
  data,
  onChange,
}: {
  data: electric_data;
  onChange: (next: electric_data) => void;
}) {
  return (
    <div className="mt-4 p-4 bg-amber-50 border border-amber-200 rounded">
      <h4 className="font-medium text-amber-900 mb-3">Energia Elettrica</h4>
      <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
        {ELECTRIC_FIELDS.map((f) => (
          <Field
            key={f.key as string}
            label={f.label}
            type={f.type === 'number' ? 'number' : 'text'}
            value={fmt((data as Record<string, unknown>)[f.key as string])}
            onChange={(v) => onChange({ ...data, [f.key]: f.type === 'number' ? Number(v) : v })}
          />
        ))}
      </div>
      {(data.bandF1Consumption || data.bandF2Consumption || data.bandF3Consumption) && (
        <div className="mt-4">
          <h5 className="text-xs font-medium text-amber-900 mb-2">Consumi per fascia (kWh)</h5>
          <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
            <Field
              label="Fascia F1"
              value={fmt(data.bandF1Consumption)}
              onChange={() => undefined}
            />
            <Field
              label="Fascia F2"
              value={fmt(data.bandF2Consumption)}
              onChange={() => undefined}
            />
            <Field
              label="Fascia F3"
              value={fmt(data.bandF3Consumption)}
              onChange={() => undefined}
            />
          </div>
        </div>
      )}
      {data.totalActiveEnergyConsumption && (
        <div className="mt-3">
          <Field
            label="Totale consumi energia attiva"
            value={fmt(data.totalActiveEnergyConsumption)}
            onChange={() => undefined}
          />
        </div>
      )}
    </div>
  );
}

function SectionGas({
  data,
  onChange,
}: {
  data: gas_data;
  onChange: (next: gas_data) => void;
}) {
  return (
    <div className="mt-4 p-4 bg-sky-50 border border-sky-200 rounded">
      <h4 className="font-medium text-sky-900 mb-3">Gas naturale</h4>
      <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
        {data.invoicePeriod && (
          <Field
            label="Periodo di competenza"
            value={fmt(data.invoicePeriod)}
            onChange={() => undefined}
          />
        )}
        {GAS_FIELDS.map((f) => (
          <Field
            key={f.key as string}
            label={f.label}
            type={f.type === 'number' ? 'number' : 'text'}
            value={fmt((data as Record<string, unknown>)[f.key as string])}
            onChange={(v) => onChange({ ...data, [f.key]: f.type === 'number' ? Number(v) : v })}
          />
        ))}
      </div>
    </div>
  );
}

export default function InvoiceUpload() {
  const [file, setFile] = useState<File | null>(null);
  const [uploading, setUploading] = useState(false);
  const [ocrStatus, setOcrStatus] = useState<string>('');
  const [extracted, setExtracted] = useState<ExtractedResult | null>(null);
  const [error, setError] = useState<string>('');

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const selectedFile = e.target.files?.[0];
    if (!selectedFile) return;

    if (selectedFile.type !== 'application/pdf') {
      setError('Please upload a PDF file');
      return;
    }
    if (selectedFile.size > 10 * 1024 * 1024) {
      setError('File size must be less than 10MB');
      return;
    }

    setFile(selectedFile);
    setError('');
    setExtracted(null);
  };

  const uploadInvoice = async () => {
    if (!file) return;

    setUploading(true);
    setError('');
    setExtracted(null);
    setOcrStatus('Processing invoice...');

    try {
      const res = await fetch(OCR_ENDPOINT, {
        method: 'POST',
        headers: { 'Content-Type': file.type || 'application/octet-stream' },
        body: file,
      });
      const body = await res.json();

      if (res.status === 415) {
        setError('Unknown type');
        setOcrStatus('');
        return;
      }
      if (res.status === 422) {
        setError(body.error ?? 'Could not process invoice');
        setOcrStatus('');
        return;
      }
      if (!res.ok) {
        setError(body.error ?? 'Upload failed');
        setOcrStatus('');
        return;
      }

      setExtracted({
        type: body.type,
        electric: body.electric,
        gas: body.gas,
      });
      setOcrStatus(`Invoice processed (${body.type})`);
      setFile(null);
    } catch (err) {
      console.error('Upload error:', err);
      setError(err instanceof Error ? err.message : 'Upload failed');
      setOcrStatus('');
    } finally {
      setUploading(false);
    }
  };

  return (
    <div className="border rounded-lg p-6 bg-white">
      <h3 className="text-lg font-medium mb-4">Upload Invoice</h3>

      <div className="mb-4">
        <label className="block text-sm font-medium text-gray-700 mb-2">Select PDF</label>
        <input
          type="file"
          accept="application/pdf"
          onChange={handleFileChange}
          disabled={uploading}
          className="block w-full text-sm text-gray-500
            file:mr-4 file:py-2 file:px-4
            file:rounded file:border-0
            file:text-sm file:font-medium
            file:bg-blue-50 file:text-blue-700
            hover:file:bg-blue-100
            disabled:opacity-50 disabled:cursor-not-allowed"
        />
        {file && (
          <p className="mt-2 text-sm text-gray-600">
            Selected: {file.name} ({(file.size / 1024).toFixed(0)} KB)
          </p>
        )}
      </div>

      {error && (
        <div className="mb-4 p-3 bg-red-50 border border-red-200 rounded text-red-700 text-sm">
          {error}
        </div>
      )}

      <button
        onClick={uploadInvoice}
        disabled={!file || uploading}
        className="w-full py-2 px-4 bg-blue-600 text-white rounded
          hover:bg-blue-700 disabled:bg-gray-300 disabled:cursor-not-allowed
          transition-colors font-medium"
      >
        {uploading ? 'Processing...' : 'Upload & Process Invoice'}
      </button>

      {ocrStatus && (
        <div className="mt-4 p-3 bg-blue-50 border border-blue-200 rounded">
          <p className="text-sm text-blue-800">{ocrStatus}</p>
        </div>
      )}

      {extracted?.electric && (
        <SectionElectric
          data={extracted.electric}
          onChange={(next) => setExtracted({ ...extracted, electric: next })}
        />
      )}
      {extracted?.gas && (
        <SectionGas
          data={extracted.gas}
          onChange={(next) => setExtracted({ ...extracted, gas: next })}
        />
      )}
    </div>
  );
}
