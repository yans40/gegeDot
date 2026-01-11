-- ============================================
-- Nettoyer la base de données
-- ============================================
-- Ce script supprime :
-- 1. Les doublons de personnages
-- 2. Les personnages qui ne sont pas de la famille royale britannique
-- 3. Les personnages qui ne sont pas de Game of Thrones ou House of the Dragon
--
-- Pour exécuter ce script :
-- mysql -u root -p gegeDot < scripts/cleanup_database.sql
-- ============================================

USE gegeDot;

-- ============================================
-- ÉTAPE 1 : Identifier et supprimer les doublons
-- ============================================

-- Supprimer les doublons en gardant le plus ancien ID
-- (basé sur FirstName, LastName, MiddleName, BirthDate)
DELETE p1 FROM Persons p1
INNER JOIN Persons p2 
WHERE p1.Id > p2.Id 
  AND p1.FirstName = p2.FirstName 
  AND p1.LastName = p2.LastName 
  AND (p1.MiddleName = p2.MiddleName OR (p1.MiddleName IS NULL AND p2.MiddleName IS NULL))
  AND (p1.BirthDate = p2.BirthDate OR (p1.BirthDate IS NULL AND p2.BirthDate IS NULL));

-- ============================================
-- ÉTAPE 2 : Supprimer les personnages de test (Dupont, etc.)
-- ============================================

-- Supprimer les personnages de test
DELETE FROM Persons 
WHERE LastName NOT IN (
    'Windsor',           -- Famille royale britannique
    'Mountbatten',      -- Philip Mountbatten
    'Bowes-Lyon',       -- Elizabeth Bowes-Lyon
    'Cavendish-Bentinck', -- Parents d'Elizabeth Bowes-Lyon
    'Teck',             -- Mary of Teck
    'Greece',            -- Andrew Greece
    'Romanov',           -- Olga Romanov
    'Stark',             -- Game of Thrones
    'Lannister',         -- Game of Thrones
    'Baratheon',         -- Game of Thrones
    'Targaryen',         -- Game of Thrones / House of the Dragon
    'Tully',             -- Game of Thrones
    'Arryn',             -- Game of Thrones / House of the Dragon
    'Hightower',         -- House of the Dragon
    'Spencer',           -- Diana Spencer
    'Parker Bowles',     -- Camilla Parker Bowles
    'Middleton',         -- Kate Middleton
    'Markle',            -- Meghan Markle
    'Marbrand',          -- Jeyne Marbrand (Lannister)
    'Estermont',         -- Cassana Estermont (Baratheon)
    'Whent'              -- Minisa Whent (Tully)
)
AND FirstName NOT IN (
    'Charles', 'Elizabeth', 'Philip', 'George', 'Mary', 'Andrew', 'Alice',
    'Claude', 'Cecilia', 'Louis', 'Victoria', 'Anne', 'Edward', 'Diana',
    'Camilla', 'William', 'Harry', 'Catherine', 'Meghan', 'George', 'Charlotte',
    'Louis', 'Archie', 'Lilibet', 'Margaret'
);

-- ============================================
-- ÉTAPE 3 : Supprimer les relations orphelines
-- ============================================

-- Supprimer les relations où Person1Id n'existe plus
DELETE r FROM Relationships r
LEFT JOIN Persons p1 ON r.Person1Id = p1.Id
WHERE p1.Id IS NULL;

-- Supprimer les relations où Person2Id n'existe plus
DELETE r FROM Relationships r
LEFT JOIN Persons p2 ON r.Person2Id = p2.Id
WHERE p2.Id IS NULL;

-- ============================================
-- ÉTAPE 4 : Vérification et statistiques
-- ============================================

SELECT 'Nettoyage terminé!' AS result;
SELECT COUNT(*) AS total_personnes_restantes FROM Persons;
SELECT COUNT(*) AS total_relations_restantes FROM Relationships;

-- Afficher la répartition par famille
SELECT 
    LastName,
    COUNT(*) as nombre_personnes
FROM Persons 
GROUP BY LastName
ORDER BY nombre_personnes DESC;
