export function parseItNumber(raw: string | undefined): number | undefined {
  if (raw === undefined || raw === null) return undefined;
  const cleaned = raw.replace(/\./g, '').replace(',', '.');
  const n = Number(cleaned);
  return Number.isFinite(n) ? n : undefined;
}
