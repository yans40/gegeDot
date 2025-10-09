-- Script d'initialisation de la base de données GegeDot
-- Ce script est exécuté automatiquement lors de la création du conteneur MySQL

USE gegeDot;

-- Créer les tables si elles n'existent pas déjà
CREATE TABLE IF NOT EXISTS Persons (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    MiddleName VARCHAR(100),
    BirthDate DATE,
    DeathDate DATE,
    BirthPlace VARCHAR(200),
    DeathPlace VARCHAR(200),
    PhotoUrl VARCHAR(500),
    Biography TEXT,
    Gender ENUM('Male', 'Female', 'Other') DEFAULT 'Other',
    IsAlive BOOLEAN DEFAULT TRUE,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS Relationships (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Person1Id INT NOT NULL,
    Person2Id INT NOT NULL,
    RelationshipType INT NOT NULL,
    StartDate DATE,
    EndDate DATE,
    Notes TEXT,
    IsActive BOOLEAN DEFAULT TRUE,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (Person1Id) REFERENCES Persons(Id) ON DELETE CASCADE,
    FOREIGN KEY (Person2Id) REFERENCES Persons(Id) ON DELETE CASCADE,
    
    CONSTRAINT CHK_DifferentPersons CHECK (Person1Id != Person2Id),
    CONSTRAINT CHK_ValidDateRange CHECK (EndDate IS NULL OR StartDate IS NULL OR EndDate >= StartDate)
);

CREATE TABLE IF NOT EXISTS Trees (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(200) NOT NULL,
    Description TEXT,
    RootPersonId INT,
    IsPublic BOOLEAN DEFAULT FALSE,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (RootPersonId) REFERENCES Persons(Id) ON DELETE SET NULL
);

-- Créer les index pour optimiser les performances
CREATE INDEX IF NOT EXISTS IX_Persons_LastName ON Persons(LastName);
CREATE INDEX IF NOT EXISTS IX_Persons_BirthDate ON Persons(BirthDate);
CREATE INDEX IF NOT EXISTS IX_Persons_FullName ON Persons(FirstName, LastName);

CREATE INDEX IF NOT EXISTS IX_Relationships_Person1 ON Relationships(Person1Id);
CREATE INDEX IF NOT EXISTS IX_Relationships_Person2 ON Relationships(Person2Id);
CREATE INDEX IF NOT EXISTS IX_Relationships_Type ON Relationships(RelationshipType);
CREATE INDEX IF NOT EXISTS IX_Relationships_Person1_Type ON Relationships(Person1Id, RelationshipType);
CREATE INDEX IF NOT EXISTS IX_Relationships_Person2_Type ON Relationships(Person2Id, RelationshipType);

CREATE INDEX IF NOT EXISTS IX_Trees_RootPerson ON Trees(RootPersonId);

-- Insérer des données de test
INSERT IGNORE INTO Persons (FirstName, LastName, BirthDate, Gender, BirthPlace) VALUES
('Jean', 'Dupont', '1950-05-15', 'M', 'Paris, France'),
('Marie', 'Martin', '1952-08-20', 'F', 'Lyon, France'),
('Pierre', 'Dupont', '1980-03-10', 'M', 'Paris, France'),
('Sophie', 'Dupont', '1982-07-25', 'F', 'Paris, France'),
('Paul', 'Dupont', '2010-12-01', 'M', 'Paris, France');

INSERT IGNORE INTO Relationships (Person1Id, Person2Id, RelationshipType) VALUES
(1, 3, 1), -- Jean est parent de Pierre
(2, 3, 1), -- Marie est parent de Pierre
(1, 4, 1), -- Jean est parent de Sophie
(2, 4, 1), -- Marie est parent de Sophie
(1, 2, 3), -- Jean et Marie sont mariés
(3, 4, 4), -- Pierre et Sophie sont frères/sœurs
(3, 5, 1), -- Pierre est parent de Paul
(4, 5, 1); -- Sophie est parent de Paul

INSERT IGNORE INTO Trees (Name, Description, RootPersonId, IsPublic) VALUES
('Famille Dupont', 'Arbre généalogique de la famille Dupont', 1, TRUE);

-- Message de confirmation
SELECT 'Base de données GegeDot initialisée avec succès!' as Message;
