// src/services/crm/types.ts

export interface PersonDetails {
  cognome: string;
  nome: string;
  cod_fis: string;
  ref_cognome?: string;
  ref_nome?: string;
  cl_celnum?: string;
  cl_fixnum?: string;
  email?: string;
  pec?: string;
  id_type?: string;
  id_number?: string;
  tit_birthplace?: string;
  tit_birth_date?: string;
  tit_gender?: string;
  cust_address_1?: string;
  cust_address_2?: string;
  cust_zip?: number;
  cust_town?: string;
  cust_pr?: string;
  type?: string;
  status?: string;
}

export interface PersonResponse extends PersonDetails {
  id: string;
  created_at: string;
  created_by?: string;
}

export interface CompanyDetails {
  ragione_sociale: string;
  tipo_azienda?: string;
  p_iva?: string;
  cf_azienda?: string;
  owner_id?: string;
  legal_rep_id?: string;
}

export interface CompanyResponse extends CompanyDetails {
  id: string;
  created_at: string;
  created_by?: string;
}

export interface LegalRepresentative {
  cognome: string;
  nome: string;
  cod_fis: string;
  id_type?: string;
  id_number?: string;
}

export interface CustomerCreationRequest {
  customer_type: 'person' | 'company';
  person?: PersonDetails;
  company?: CompanyDetails;
  legal_representative?: LegalRepresentative;
  owner?: PersonDetails;
}

export interface CustomerCreationResponse {
  customer_id: string;
  customer_type: 'person' | 'company';
  legal_rep_id?: string;
  owner_id?: string;
  message: string;
}