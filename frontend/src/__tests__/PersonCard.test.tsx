import React from 'react';
import { render, screen } from '@testing-library/react';
import PersonCard from '../components/PersonCard';
import '@testing-library/jest-dom';

describe('PersonCard', () => {
  it('affiche le nom et l’âge', () => {
    const person = {
      id: 1,
      firstName: 'Jean',
      lastName: 'Dupont',
      middleName: '',
      birthDate: '1995-01-01',
      deathDate: undefined,
      birthPlace: 'Paris',
      deathPlace: undefined,
      photoUrl: 'https://example.com/photo.jpg',
      biography: 'Bio',
      gender: 'M' as 'M',
      isAlive: true,
      fullName: 'Jean Dupont',
      age: 30,
      createdAt: '',
      updatedAt: ''
    };
    render(<PersonCard person={person} />);
    expect(screen.getByText(/Jean Dupont/)).toBeInTheDocument();
    expect(screen.getByText(/30/)).toBeInTheDocument();
  });
});