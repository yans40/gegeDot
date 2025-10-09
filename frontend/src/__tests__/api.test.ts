import axios from 'axios';
// Mock axios avant d'importer le service
jest.mock('axios');
// Mock axios.create pour retourner un objet avec interceptors
const mockInterceptors = {
  request: { use: jest.fn() },
  response: { use: jest.fn() }
};
const mockAxiosInstance = {
  get: jest.fn(),
  interceptors: mockInterceptors
} as any;
(axios.create as jest.Mock) = jest.fn(() => mockAxiosInstance);

import { fetchPersons } from '../services/api';

describe('API Service', () => {
  it('doit retourner une liste de personnes (mock)', async () => {
    mockAxiosInstance.get.mockResolvedValue({ data: [{ id: 1, firstName: 'Jean', lastName: 'Dupont', gender: 'M', isAlive: true, fullName: 'Jean Dupont', createdAt: '', updatedAt: '' }] });
    const data = await fetchPersons();
    expect(Array.isArray(data)).toBe(true);
    expect(data[0].firstName).toBe('Jean');
  });
});