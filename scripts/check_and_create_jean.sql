-- Vérifier et créer Jean TestFamille
USE gegeDot;

-- Vérifier si Jean existe déjà
SELECT 'Vérification avant insertion:' AS info;
SELECT Id, FirstName, LastName, MiddleName FROM Persons WHERE FirstName = 'Jean' AND LastName = 'TestFamille';

-- Créer Jean TestFamille
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Jean', 'TestFamille', 'Le Patriarche', '1950-01-15', 'Paris, France', 'Male', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

-- Vérifier après insertion
SELECT 'Vérification après insertion:' AS info;
SELECT Id, FirstName, LastName, MiddleName FROM Persons WHERE FirstName = 'Jean' AND LastName = 'TestFamille';

-- Compter toutes les personnes TestFamille
SELECT 'Total personnes TestFamille:' AS info;
SELECT COUNT(*) AS total FROM Persons WHERE LastName = 'TestFamille';
