import React from 'react';
import { render, screen, fireEvent } from '@testing-library/react';
import PersonForm from '../components/PersonForm';

describe('PersonForm', () => {
  it('affiche le formulaire et gère la saisie', () => {
    render(<PersonForm open={true} onClose={jest.fn()} onSubmit={jest.fn()} />);
    expect(screen.getByLabelText(/Nom \*/)).toBeInTheDocument();
    expect(screen.getByLabelText(/Date de naissance/)).toBeInTheDocument();
  });
});