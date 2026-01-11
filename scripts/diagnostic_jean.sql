-- Diagnostic complet pour Jean TestFamille
USE gegeDot;

-- 1. Vérifier si Jean existe
SELECT '=== VÉRIFICATION JEAN TESTFAMILLE ===' AS '';
SELECT Id, FirstName, LastName, MiddleName, BirthDate, Gender, IsAlive 
FROM Persons 
WHERE FirstName = 'Jean' AND LastName = 'TestFamille';

-- 2. Vérifier toutes les personnes TestFamille
SELECT '=== TOUTES LES PERSONNES TESTFAMILLE ===' AS '';
SELECT Id, FirstName, LastName, MiddleName 
FROM Persons 
WHERE LastName = 'TestFamille' 
ORDER BY FirstName 
LIMIT 20;

-- 3. Compter le total
SELECT '=== TOTAL ===' AS '';
SELECT COUNT(*) AS total_personnes_testfamille 
FROM Persons 
WHERE LastName = 'TestFamille';

-- 4. Vérifier les dernières personnes ajoutées
SELECT '=== DERNIÈRES PERSONNES AJOUTÉES (toutes) ===' AS '';
SELECT Id, FirstName, LastName, CreatedAt 
FROM Persons 
ORDER BY CreatedAt DESC 
LIMIT 10;

-- 5. Si Jean n'existe pas, le créer
SELECT '=== CRÉATION DE JEAN (si nécessaire) ===' AS '';
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
SELECT 'Jean', 'TestFamille', 'Le Patriarche', '1950-01-15', 'Paris, France', 'Male', true, NOW(), NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Persons WHERE FirstName = 'Jean' AND LastName = 'TestFamille'
);

-- 6. Vérification finale
SELECT '=== VÉRIFICATION FINALE ===' AS '';
SELECT Id, FirstName, LastName, MiddleName 
FROM Persons 
WHERE FirstName = 'Jean' AND LastName = 'TestFamille';
