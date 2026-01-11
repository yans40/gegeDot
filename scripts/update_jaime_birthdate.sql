-- Script pour mettre à jour la date de naissance de Jaime Lannister
-- Pour tester si le problème de centrage est lié à la date de naissance identique avec Cersei

USE gegeDot;

-- Mettre à jour la date de naissance de Jaime Lannister (était 266-01-01, maintenant 267-01-01)
UPDATE Persons 
SET BirthDate = '267-01-01', UpdatedAt = NOW()
WHERE FirstName = 'Jaime' AND LastName = 'Lannister';

SELECT 'Date de naissance de Jaime Lannister mise à jour de 266-01-01 à 267-01-01' AS result;
SELECT FirstName, LastName, BirthDate FROM Persons WHERE FirstName = 'Jaime' AND LastName = 'Lannister';
