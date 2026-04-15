// src/services/crm/personService.ts
import { auth_client } from '../../services/clients/public';
import type { PersonDetails, PersonResponse } from './types';

const client = await auth_client(
    "jsjbfwe",
    "jdujdncwe",
)

export class PersonService {
  async createPerson(personData: PersonDetails): Promise<PersonResponse> {
    const { data, error } = await client
      .from('people__details')
      .insert(personData)
      .select()
      .single();

    if (error) {
      console.error('Failed to create person:', error);
      throw new Error(error.message || 'Failed to create person');
    }

    return data;
  }

  async getPerson(id: string): Promise<PersonResponse | null> {
    const { data, error } = await client
      .from('people__details')
      .select('*')
      .eq('id', id)
      .single();

    if (error) {
      console.error('Failed to get person:', error);
      return null;
    }

    return data;
  }

  async updatePerson(id: string, updates: Partial<PersonDetails>): Promise<PersonResponse> {
    const { data, error } = await client
      .from('people__details')
      .update(updates)
      .eq('id', id)
      .select()
      .single();

    if (error) {
      console.error('Failed to update person:', error);
      throw new Error(error.message || 'Failed to update person');
    }

    return data;
  }

  async searchPeople(query: string): Promise<PersonResponse[]> {
    const { data, error } = await client
      .from('people__details')
      .select('*')
      .or(`cognome.ilike.%${query}%,nome.ilike.%${query}%,cod_fis.ilike.%${query}%`)
      .limit(20);

    if (error) {
      console.error('Search failed:', error);
      return [];
    }

    return data || [];
  }

  async deletePerson(id: string): Promise<void> {
    const { error } = await client
      .from('people__details')
      .delete()
      .eq('id', id);

    if (error) {
      console.error('Failed to delete person:', error);
      throw new Error(error.message || 'Failed to delete person');
    }
  }
}

export const personService = new PersonService();
