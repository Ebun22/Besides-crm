import type { customer_data, electric_data, gas_data } from "./types/OCR_results";

export interface DataConfidence<T> {
  confidence: number;
}

function count_present_fields<T extends object>(data: T): {
  ok    : number;
  total : number
} {
  const keys = Object.keys(data) as (keyof T)[];

  let present_field = 0;

  for (const k of keys) {
    const v = data[k];
    if (v !== undefined && v !== null) present_field++;
  };

  return {
    ok: present_field,
    total: keys.length
  };
};

export function compute_total_confidence_score(
  customer : customer_data | null,
  electric : electric_data | null,
  gas      : gas_data | null
): number {
  const parts = [customer, electric, gas].filter(
    (d): d is customer_data | electric_data | gas_data => d !== null
  );

  if (parts.length === 0) return 0;

  let ok    = 0;
  let total = 0;

  for (const p of parts) {
    const c = count_present_fields(p);
    ok    += c.ok;
    total += c.total;
  };

  return Math.round((ok / total) * 100);
};
