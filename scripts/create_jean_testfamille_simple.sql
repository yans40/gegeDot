-- Script simple pour créer juste Jean TestFamille (pour test rapide)
USE gegeDot;

INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Jean', 'TestFamille', 'Le Patriarche', '1950-01-15', 'Paris, France', 'Male', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SELECT Id, FirstName, LastName, MiddleName FROM Persons WHERE FirstName = 'Jean' AND LastName = 'TestFamille';
