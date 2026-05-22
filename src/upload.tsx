import { useState } from 'react';
import type {
  customer_data,
  electric_data,
  gas_data,
  invoice_period,
} from './services/OCR/types/OCR_results';
import type { DataConfidence } from './services/OCR/confidence';

const OCR_ENDPOINT =
  import.meta.env.VITE_OCR_ENDPOINT ?? 'http://localhost:3001/api/invoices/extract';

interface ExtractedResult {
  type: 'electric' | 'gas' | 'dual';
  customer: customer_data | null;
  electric: electric_data | null;
  gas: gas_data | null;
  customerConfidence: DataConfidence<customer_data> | null;
  electricConfidence: DataConfidence<electric_data> | null;
  gasConfidence: DataConfidence<gas_data> | null;
}

const CUSTOMER_FIELDS: Array<{
  key: keyof customer_data;
  label: string;
}> = [
  { key: 'supply_holder', label: 'Intestatario fornitura' },
  { key: 'tax_code', label: 'Codice Fiscale' },
  { key: 'supply_address', label: 'Indirizzo di fornitura' },
  { key: 'mailing_address', label: 'Indirizzo di recapito' }
];

const CUSTOMER_LABELS: Partial<Record<keyof customer_data, string>> = {
  supply_holder: 'Intestatario fornitura',
  tax_code: 'Codice Fiscale',
  supply_address: 'Indirizzo di fornitura',
  mailing_address: 'Indirizzo di recapito'
};

const ELECTRIC_FIELDS: Array<{
  key: keyof electric_data;
  label: string;
  type?: 'number' | 'text' | 'period';
}> = [
  { key: 'invoice_type', label: 'invoice_type' },
  { key: 'pod', label: 'POD' },
  { key: 'billing_period', label: 'Periodo di competenza', type: 'period' },
  { key: 'supplier', label: 'Fornitore (corrente)' },
  { key: 'local_distributor', label: 'Distributore locale' },
  { key: 'annual_consumption', label: 'Consumo annuo (kWh)', type: 'number' },
  { key: 'contracted_power', label: 'Potenza impegnata (kW)', type: 'number' },
  { key: 'voltage_level', label: 'Livello di tensione' },
  { key: 'intended_use', label: 'Tipologia cliente / uso' },
  { key: 'offer_type', label: "Tipologia offerta" },
  { key: 'tariff_type', label: 'Tipologia prezzo (tariffa)' },
  {
    key: 'consumption_quote',
    label: 'Spesa per la vendita (quota consumo) €',
    type: 'number',
  },
  {
    key: 'fixed_power_quote',
    label: 'Quota fissa e potenza €',
    type: 'number',
  },
  { key: 'invoice_issue_date', label: 'Data emissione' },
  { key: 'total_amount', label: 'Totale da pagare €', type: 'number' },
];

const ELECTRIC_LABELS: Partial<Record<keyof electric_data, string>> = {
  pod: 'POD',
  billing_period: 'Periodo di competenza',
  supplier: 'Fornitore (corrente)',
  local_distributor: 'Distributore locale',
  annual_consumption: 'Consumo annuo (kWh)',
  contracted_power: 'Potenza impegnata (kW)',
  voltage_level: 'Livello di tensione',
  intended_use: 'Tipologia cliente / uso',
  offer_type: 'Tipologia offerta',
  tariff_type: 'Tipologia prezzo (tariffa)',
  consumption_quote: 'Spesa per la vendita (quota consumo) €',
  fixed_power_quote: 'Quota fissa e potenza €',
  invoice_issue_date: 'Data emissione',
  total_amount: 'Totale da pagare €',
  total_active_consumption: 'Totale consumi energia attiva',
  band_F1: 'Fascia F1',
  band_F2: 'Fascia F2',
  band_F3: 'Fascia F3',
};

const GAS_FIELDS: Array<{
  key: keyof gas_data;
  label: string;
  type?: 'number' | 'text';
}> = [
  { key: 'invoice_type', label: 'invoice_type' },
  { key: 'pdr', label: 'PDR' },
  { key: 'supplier', label: 'Fornitore gas (corrente)' },
  { key: 'local_distributor', label: 'Distributore locale' },
  { key: 'annual_consumption', label: 'Consumo annuo (Smc)', type: 'number' },
  { key: 'usage_categories', label: "Categorie d'uso" },
  { key: 'meter_serial_number', label: 'Matricola contatore' },
  { key: 'remi', label: 'Cabina REMI' },
  { key: 'industrial_excise_duties', label: 'Accise industriali €'},
  { key: 'offer_type', label: 'Tipologia offerta' },
  { key: 'tariff_type', label: 'Tipologia prezzo (tariffa)' },
  { key: 'ateco_code', label: 'Codice ATECO' },
  { key: 'ateco_category_description', label: 'Descrizione ATECO' },
  {
    key: 'consumption_quote',
    label: 'Spesa per la vendita gas (quota consumo) €',
    type: 'number',
  },
  { key: 'fixed_quote', label: 'Quota fissa €', type: 'number' },
  { key: 'gas_consumption', label: 'Consumo periodo (Smc)', type: 'number' },
  { key: 'invoice_issue_date', label: 'Data emissione' },
  { key: 'total_amount', label: 'Totale da pagare €', type: 'number' },
];

const GAS_LABELS: Partial<Record<keyof gas_data, string>> = {
  pdr: 'PDR',
  billing_period: 'Periodo di competenza',
  supplier: 'Fornitore gas (corrente)',
  local_distributor: 'Distributore locale',
  annual_consumption: 'Consumo annuo (Smc)',
  usage_categories: "Categorie d'uso",
  meter_serial_number: 'Matricola contatore',
  remi: 'Cabina REMI',
  industrial_excise_duties: 'Accise industriali',
  offer_type: 'Tipologia offerta',
  tariff_type: 'Tipologia prezzo (tariffa)',
  ateco_code: 'Codice ATECO',
  ateco_category_description: 'Descrizione ATECO',
  consumption_quote: 'Spesa per la vendita gas (quota consumo) €',
  fixed_quote: 'Quota fissa €',
  gas_consumption: 'Consumo periodo (Smc)',
  invoice_issue_date: 'Data emissione',
  total_amount: 'Totale da pagare €',
};

function MissingFields({
  confidence,
  labels,
}: {
  confidence: { confidence: number; fields: Record<string, 'ok' | 'missing'> };
  labels: Record<string, string>;
}) {
  const missing = Object.entries(confidence.fields)
    .filter(([, status]) => status === 'missing')
    .map(([key]) => labels[key] ?? key);
  const color =
    confidence.confidence >= 80
      ? 'text-green-700'
      : confidence.confidence >= 50
      ? 'text-amber-700'
      : 'text-red-700';
  return (
    <div className="mt-3 text-xs">
      <div className={`font-medium ${color}`}>
        Affidabilità estrazione: {confidence.confidence}%
      </div>
      {missing.length > 0 && (
        <div className="mt-1 text-gray-700">
          <div className="font-medium">Campi non trovati:</div>
          <ul className="list-disc pl-5">
            {missing.map((label) => (
              <li key={label}>{label}</li>
            ))}
          </ul>
        </div>
      )}
    </div>
  );
}

function fmt(value: unknown): string {
  if (value === undefined || value === null) return '';
  if (typeof value === 'object' && value !== null && 'from' in value && 'to' in value) {
    const p = value as invoice_period;
    return `${p.from} → ${p.to}`;
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

function SectionCustomer({
  data,
  confidence,
  onChange,
}: {
  data: customer_data;
  confidence: DataConfidence<customer_data> | null;
  onChange: (next: customer_data) => void;
}) {
  return (
    <div className="mt-4 p-4 bg-emerald-50 border border-emerald-200 rounded">
      <h4 className="font-medium text-emerald-900 mb-3">Dati cliente</h4>
      <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
        {CUSTOMER_FIELDS.map((f) => (
          <Field
            key={f.key as string}
            label={f.label}
            value={fmt((data as Record<string, unknown>)[f.key as string])}
            onChange={(v) => onChange({ ...data, [f.key]: v })}
          />
        ))}
      </div>
      {confidence && (
        <MissingFields
          confidence={confidence as { confidence: number; fields: Record<string, 'ok' | 'missing'> }}
          labels={CUSTOMER_LABELS as Record<string, string>}
        />
      )}
    </div>
  );
}

function SectionElectric({
  data,
  confidence,
  onChange,
}: {
  data: electric_data;
  confidence: DataConfidence<electric_data> | null;
  onChange: (next: electric_data) => void;
}) {
  const f2f3 =
    data.band_F2 == null && data.band_F3 == null
      ? ''
      : String((data.band_F2 ?? 0) + (data.band_F3 ?? 0));
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
      <div className="mt-4">
        <h5 className="text-xs font-medium text-amber-900 mb-2">Consumi per fascia (kWh)</h5>
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
          <Field
            label="Fascia F1"
            value={fmt(data.band_F1)}
            onChange={() => undefined}
          />
          <Field label="Fascia F2/F3" value={f2f3} onChange={() => undefined} />
        </div>
      </div>
      <div className="mt-3">
        <Field
          label="Totale consumi energia attiva"
          value={fmt(data.total_active_consumption)}
          onChange={() => undefined}
        />
      </div>
      {confidence && (
        <MissingFields
          confidence={confidence as { confidence: number; fields: Record<string, 'ok' | 'missing'> }}
          labels={ELECTRIC_LABELS as Record<string, string>}
        />
      )}
    </div>
  );
}

function SectionGas({
  data,
  confidence,
  onChange,
}: {
  data: gas_data;
  confidence: DataConfidence<gas_data> | null;
  onChange: (next: gas_data) => void;
}) {
  return (
    <div className="mt-4 p-4 bg-sky-50 border border-sky-200 rounded">
      <h4 className="font-medium text-sky-900 mb-3">Gas naturale</h4>
      <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
        <Field
          label="Periodo di competenza"
          value={fmt(data.billing_period)}
          onChange={() => undefined}
        />
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
      {confidence && (
        <MissingFields
          confidence={confidence as { confidence: number; fields: Record<string, 'ok' | 'missing'> }}
          labels={GAS_LABELS as Record<string, string>}
        />
      )}
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
        customer: body.customer ?? null,
        electric: body.electric,
        gas: body.gas,
        customerConfidence: body.customerConfidence ?? null,
        electricConfidence: body.electricConfidence ?? null,
        gasConfidence: body.gasConfidence ?? null,
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

      {extracted?.customer && (
        <SectionCustomer
          data={extracted.customer}
          confidence={extracted.customerConfidence}
          onChange={(next) => setExtracted({ ...extracted, customer: next })}
        />
      )}
      {extracted?.electric && (
        <SectionElectric
          data={extracted.electric}
          confidence={extracted.electricConfidence}
          onChange={(next) => setExtracted({ ...extracted, electric: next })}
        />
      )}
      {extracted?.gas && (
        <SectionGas
          data={extracted.gas}
          confidence={extracted.gasConfidence}
          onChange={(next) => setExtracted({ ...extracted, gas: next })}
        />
      )}
    </div>
  );
}
