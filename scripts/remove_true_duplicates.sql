-- ============================================
-- Supprimer uniquement les VRAIS doublons
-- ============================================
-- Ce script supprime uniquement les personnes avec :
-- - Même FirstName + LastName + MiddleName (exact)
-- - Garde le plus petit ID
-- ============================================

USE gegeDot;

-- ============================================
-- ÉTAPE 1 : Afficher les vrais doublons (même nom complet)
-- ============================================

SELECT 
    FirstName,
    LastName,
    COALESCE(MiddleName, '') as MiddleName,
    COUNT(*) as count,
    GROUP_CONCAT(Id ORDER BY Id) as ids
FROM Persons
GROUP BY FirstName, LastName, COALESCE(MiddleName, '')
HAVING COUNT(*) > 1
ORDER BY count DESC;

-- ============================================
-- ÉTAPE 2 : Supprimer les vrais doublons
-- ============================================

-- Supprimer les doublons exacts (même FirstName + LastName + MiddleName)
DELETE p1 FROM Persons p1
INNER JOIN Persons p2 
WHERE p1.Id > p2.Id 
  AND p1.FirstName = p2.FirstName 
  AND p1.LastName = p2.LastName 
  AND COALESCE(p1.MiddleName, '') = COALESCE(p2.MiddleName, '');

-- ============================================
-- ÉTAPE 3 : Nettoyer les relations orphelines
-- ============================================

DELETE r FROM Relationships r
LEFT JOIN Persons p1 ON r.Person1Id = p1.Id
WHERE p1.Id IS NULL;

DELETE r FROM Relationships r
LEFT JOIN Persons p2 ON r.Person2Id = p2.Id
WHERE p2.Id IS NULL;

-- ============================================
-- ÉTAPE 4 : Vérification
-- ============================================

SELECT 'Suppression des vrais doublons terminée!' AS result;

-- Vérifier s'il reste des vrais doublons
SELECT 
    FirstName,
    LastName,
    COALESCE(MiddleName, '') as MiddleName,
    COUNT(*) as count
FROM Persons
GROUP BY FirstName, LastName, COALESCE(MiddleName, '')
HAVING COUNT(*) > 1;

-- Statistiques
SELECT COUNT(*) AS total_personnes FROM Persons;
SELECT COUNT(*) AS total_relations FROM Relationships;
