-- ============================================
-- Suppression agressive des doublons
-- ============================================
-- Ce script supprime les doublons en se basant sur :
-- - FirstName + LastName + MiddleName
-- - Garde l'enregistrement avec le plus d'informations
-- ============================================

USE gegeDot;

-- ============================================
-- ÉTAPE 1 : Corriger les dates mal formatées (années à 2 chiffres)
-- ============================================

-- Corriger les dates qui commencent par '02' ou '01' (devrait être '10')
UPDATE Persons 
SET BirthDate = CONCAT('10', SUBSTRING(BirthDate, 3))
WHERE BirthDate LIKE '02%' OR BirthDate LIKE '01%'
  AND BirthDate NOT LIKE '10%'
  AND BirthDate NOT LIKE '11%'
  AND BirthDate NOT LIKE '12%'
  AND BirthDate NOT LIKE '18%'
  AND BirthDate NOT LIKE '19%'
  AND BirthDate NOT LIKE '20%';

UPDATE Persons 
SET DeathDate = CONCAT('10', SUBSTRING(DeathDate, 3))
WHERE DeathDate LIKE '02%' OR DeathDate LIKE '01%'
  AND DeathDate NOT LIKE '10%'
  AND DeathDate NOT LIKE '11%'
  AND DeathDate NOT LIKE '12%'
  AND DeathDate NOT LIKE '18%'
  AND DeathDate NOT LIKE '19%'
  AND DeathDate NOT LIKE '20%';

-- Corriger les dates qui commencent par '20' pour House of the Dragon (devrait être '10')
UPDATE Persons 
SET BirthDate = CONCAT('10', SUBSTRING(BirthDate, 3))
WHERE BirthDate LIKE '20%'
  AND LastName = 'Targaryen'
  AND (FirstName IN ('Jaehaerys', 'Alysanne', 'Baelon', 'Alyssa', 'Viserys', 'Daemon', 'Rhaenyra', 'Aegon', 'Helaena', 'Aemond', 'Daeron', 'Aemma', 'Alicent', 'Jaehaera', 'Maelor')
       OR MiddleName LIKE '%I%' OR MiddleName LIKE '%II%' OR MiddleName LIKE '%III%');

UPDATE Persons 
SET DeathDate = CONCAT('10', SUBSTRING(DeathDate, 3))
WHERE DeathDate LIKE '20%'
  AND LastName = 'Targaryen'
  AND (FirstName IN ('Jaehaerys', 'Alysanne', 'Baelon', 'Alyssa', 'Viserys', 'Daemon', 'Rhaenyra', 'Aegon', 'Helaena', 'Aemond', 'Daeron', 'Aemma', 'Alicent', 'Jaehaera', 'Maelor')
       OR MiddleName LIKE '%I%' OR MiddleName LIKE '%II%' OR MiddleName LIKE '%III%');

-- ============================================
-- ÉTAPE 2 : Supprimer les doublons en gardant le meilleur enregistrement
-- ============================================

-- Supprimer les doublons en gardant le plus petit ID pour chaque combinaison FirstName+LastName+MiddleName
DELETE p1 FROM Persons p1
INNER JOIN (
    SELECT MIN(Id) as min_id, FirstName, LastName, COALESCE(MiddleName, '') as MiddleName
    FROM Persons
    GROUP BY FirstName, LastName, COALESCE(MiddleName, '')
) p2
ON p1.FirstName = p2.FirstName 
   AND p1.LastName = p2.LastName 
   AND COALESCE(p1.MiddleName, '') = p2.MiddleName
   AND p1.Id > p2.min_id;

-- Supprimer les relations orphelines
DELETE r FROM Relationships r
LEFT JOIN Persons p1 ON r.Person1Id = p1.Id
WHERE p1.Id IS NULL;

DELETE r FROM Relationships r
LEFT JOIN Persons p2 ON r.Person2Id = p2.Id
WHERE p2.Id IS NULL;

-- ============================================
-- ÉTAPE 3 : Vérification finale
-- ============================================

SELECT 'Suppression agressive des doublons terminée!' AS result;

-- Vérifier s'il reste des doublons
SELECT 
    FirstName,
    LastName,
    COALESCE(MiddleName, '') as MiddleName,
    COUNT(*) as count
FROM Persons
GROUP BY FirstName, LastName, COALESCE(MiddleName, '')
HAVING COUNT(*) > 1;

-- Statistiques finales
SELECT COUNT(*) AS total_personnes FROM Persons;
SELECT COUNT(*) AS total_relations FROM Relationships;

-- Afficher la répartition par famille
SELECT 
    LastName,
    COUNT(*) as nombre_personnes
FROM Persons 
GROUP BY LastName
ORDER BY nombre_personnes DESC;
