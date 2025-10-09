// Types pour les personnes
export interface Person {
  id: number;
  firstName: string;
  lastName: string;
  middleName?: string;
  birthDate?: string;
  deathDate?: string;
  birthPlace?: string;
  deathPlace?: string;
  photoUrl?: string;
  biography?: string;
  gender: 'M' | 'F' | 'O';
  isAlive: boolean;
  fullName: string;
  age?: number;
  createdAt: string;
  updatedAt: string;
}

export interface CreatePersonDto {
  firstName: string;
  lastName: string;
  middleName?: string;
  birthDate?: string;
  deathDate?: string;
  birthPlace?: string;
  deathPlace?: string;
  photoUrl?: string;
  biography?: string;
  gender: 'M' | 'F' | 'O';
  isAlive: boolean;
}

export interface UpdatePersonDto {
  firstName: string;
  lastName: string;
  middleName?: string;
  birthDate?: string;
  deathDate?: string;
  birthPlace?: string;
  deathPlace?: string;
  photoUrl?: string;
  biography?: string;
  gender: 'M' | 'F' | 'O';
  isAlive: boolean;
}

// Types pour les relations
export interface Relationship {
  id: number;
  person1Id: number;
  person2Id: number;
  person1Name: string;
  person2Name: string;
  relationshipType: number;
  relationshipTypeName: string;
  startDate?: string;
  endDate?: string;
  notes?: string;
  isActive: boolean;
  createdAt: string;
}

export interface CreateRelationshipDto {
  person1Id: number;
  person2Id: number;
  relationshipType: number;
  startDate?: string;
  endDate?: string;
  notes?: string;
  isActive: boolean;
}

// Types pour les arbres
export interface Tree {
  id: number;
  name: string;
  description?: string;
  rootPersonId?: number;
  rootPersonName?: string;
  isPublic: boolean;
  createdAt: string;
  updatedAt: string;
}

export interface CreateTreeDto {
  name: string;
  description?: string;
  rootPersonId?: number;
  isPublic: boolean;
}

// Types pour les réponses API
export interface ApiResponse<T> {
  data: T;
  message?: string;
  success: boolean;
}

export interface ApiError {
  message: string;
  status: number;
  details?: any;
}

// Types pour les nœuds de l'arbre généalogique
export interface TreeNode {
  id: number;
  name: string;
  firstName: string;
  lastName: string;
  birthDate?: string;
  deathDate?: string;
  gender: 'M' | 'F' | 'O';
  photoUrl?: string;
  children: TreeNode[];
  parents: TreeNode[];
  siblings: TreeNode[];
  x?: number;
  y?: number;
  level?: number;
}

// Types pour les formulaires
export interface PersonFormData {
  firstName: string;
  lastName: string;
  middleName: string;
  birthDate: string;
  deathDate: string;
  birthPlace: string;
  deathPlace: string;
  photoUrl: string;
  biography: string;
  gender: 'M' | 'F' | 'O';
  isAlive: boolean;
}

// Types pour les filtres et recherche
export interface PersonFilters {
  searchTerm: string;
  gender?: 'M' | 'F' | 'O';
  isAlive?: boolean;
  birthYearFrom?: number;
  birthYearTo?: number;
}

// Types pour les statistiques
export interface TreeStatistics {
  totalPersons: number;
  totalRelationships: number;
  generations: number;
  oldestPerson?: Person;
  youngestPerson?: Person;
  mostCommonSurname?: string;
}
