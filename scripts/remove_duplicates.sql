-- ============================================
-- Supprimer les doublons de personnages
-- ============================================
-- Script amélioré pour détecter et supprimer les doublons
-- basé sur FirstName, LastName et BirthDate (si disponible)
-- ============================================

USE gegeDot;

-- ============================================
-- ÉTAPE 1 : Identifier les doublons
-- ============================================

-- Afficher les doublons potentiels
SELECT 
    FirstName,
    LastName,
    COALESCE(MiddleName, '') as MiddleName,
    COALESCE(BirthDate, '1900-01-01') as BirthDate,
    COUNT(*) as count,
    GROUP_CONCAT(Id ORDER BY Id) as ids
FROM Persons
GROUP BY FirstName, LastName, COALESCE(MiddleName, ''), COALESCE(BirthDate, '1900-01-01')
HAVING COUNT(*) > 1
ORDER BY count DESC, LastName, FirstName;

-- ============================================
-- ÉTAPE 2 : Supprimer les doublons en gardant le plus petit ID
-- ============================================

-- Méthode 1 : Doublons exacts (même nom, prénom, middle name, date de naissance)
DELETE p1 FROM Persons p1
INNER JOIN Persons p2 
WHERE p1.Id > p2.Id 
  AND p1.FirstName = p2.FirstName 
  AND p1.LastName = p2.LastName 
  AND COALESCE(p1.MiddleName, '') = COALESCE(p2.MiddleName, '')
  AND COALESCE(p1.BirthDate, '1900-01-01') = COALESCE(p2.BirthDate, '1900-01-01');

-- Méthode 2 : Doublons avec MiddleName différent ou NULL (garder celui avec MiddleName)
DELETE p1 FROM Persons p1
INNER JOIN Persons p2 
WHERE p1.Id > p2.Id 
  AND p1.FirstName = p2.FirstName 
  AND p1.LastName = p2.LastName 
  AND COALESCE(p1.BirthDate, '1900-01-01') = COALESCE(p2.BirthDate, '1900-01-01')
  AND (p1.MiddleName IS NULL OR p1.MiddleName = '')
  AND p2.MiddleName IS NOT NULL 
  AND p2.MiddleName != '';

-- Méthode 3 : Doublons avec même nom/prénom mais dates différentes (garder celui avec date)
DELETE p1 FROM Persons p1
INNER JOIN Persons p2 
WHERE p1.Id > p2.Id 
  AND p1.FirstName = p2.FirstName 
  AND p1.LastName = p2.LastName 
  AND COALESCE(p1.MiddleName, '') = COALESCE(p2.MiddleName, '')
  AND p1.BirthDate IS NULL
  AND p2.BirthDate IS NOT NULL;

-- ============================================
-- ÉTAPE 3 : Supprimer les relations orphelines après suppression des doublons
-- ============================================

DELETE r FROM Relationships r
LEFT JOIN Persons p1 ON r.Person1Id = p1.Id
WHERE p1.Id IS NULL;

DELETE r FROM Relationships r
LEFT JOIN Persons p2 ON r.Person2Id = p2.Id
WHERE p2.Id IS NULL;

-- ============================================
-- ÉTAPE 4 : Vérification finale
-- ============================================

SELECT 'Suppression des doublons terminée!' AS result;

-- Afficher les doublons restants (s'il y en a)
SELECT 
    FirstName,
    LastName,
    COUNT(*) as count,
    GROUP_CONCAT(CONCAT(Id, ':', COALESCE(MiddleName, 'NULL'), ':', COALESCE(BirthDate, 'NULL')) ORDER BY Id) as details
FROM Persons
GROUP BY FirstName, LastName
HAVING COUNT(*) > 1
ORDER BY count DESC;

-- Statistiques finales
SELECT COUNT(*) AS total_personnes FROM Persons;
SELECT COUNT(*) AS total_relations FROM Relationships;
