import type { customer_data, electric_data, gas_data } from "./types/OCR_results";

export interface DataConfidence<T> {
  confidence: number;
}

function count_present_fields<T extends object>(data: T): { ok: number; total: number } {
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
  customer: customer_data,
  electric: electric_data,
  gas: gas_data
): number {
  const c = count_present_fields(customer);
  const e = count_present_fields(electric);
  const g = count_present_fields(gas);
  const ok = c.ok + e.ok + g.ok;
  const total = c.total + e.total + g.total;

  return Math.round((ok / total) * 100);
};
