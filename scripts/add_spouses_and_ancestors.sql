-- ============================================
-- Ajouter les conjoints (Camilla, Kate) et leurs ascendants
-- ============================================
-- Ce script ajoute :
-- - Camilla Parker Bowles (conjoint actuel de Charles)
-- - Catherine Middleton (conjoint actuel de William)
-- - Ascendants de Camilla (parents, grands-parents)
-- - Ascendants de Kate (parents, grands-parents)
-- ============================================

USE gegeDot;

-- ============================================
-- TROUVER CHARLES ET WILLIAM
-- ============================================

SELECT @charles_id := Id FROM Persons WHERE FirstName = 'Charles' AND LastName = 'Windsor' LIMIT 1;
SELECT @william_id := Id FROM Persons WHERE FirstName = 'William' AND LastName = 'Windsor' AND MiddleName = 'Prince of Wales' LIMIT 1;

-- ============================================
-- CAMILLA PARKER BOWLES (Conjoint actuel de Charles)
-- ============================================

-- Camilla Parker Bowles (Queen Consort)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Camilla', 'Parker Bowles', 'Queen Consort', '1947-07-17', 'London, England', 'Female', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SELECT @camilla_id := Id FROM Persons WHERE FirstName = 'Camilla' AND LastName = 'Parker Bowles' LIMIT 1;

-- Relation mariage actuel avec Charles (2005, sans EndDate)
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, StartDate, CreatedAt)
SELECT @charles_id, @camilla_id, 3, '2005-04-09', NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @charles_id AND Person2Id = @camilla_id) OR (Person1Id = @camilla_id AND Person2Id = @charles_id)) 
    AND RelationshipType = 3
    AND EndDate IS NULL
) AND @charles_id IS NOT NULL AND @camilla_id IS NOT NULL;

-- ============================================
-- PARENTS DE CAMILLA
-- ============================================

-- Bruce Shand (père de Camilla)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Bruce', 'Shand', 'Middleton', '1917-01-22', '2006-06-11', 'London, England', 'London, England', 'Male', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SELECT @bruce_shand_id := Id FROM Persons WHERE FirstName = 'Bruce' AND LastName = 'Shand' LIMIT 1;

-- Rosalind Cubitt (mère de Camilla)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Rosalind', 'Shand', 'Cubitt', '1921-08-11', '1994-01-14', 'London, England', 'London, England', 'Female', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SELECT @rosalind_shand_id := Id FROM Persons WHERE FirstName = 'Rosalind' AND LastName = 'Shand' AND MiddleName = 'Cubitt' LIMIT 1;

-- Relations parent-enfant
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @bruce_shand_id, @camilla_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @bruce_shand_id AND Person2Id = @camilla_id AND RelationshipType = 1
) AND @bruce_shand_id IS NOT NULL AND @camilla_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @rosalind_shand_id, @camilla_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @rosalind_shand_id AND Person2Id = @camilla_id AND RelationshipType = 1
) AND @rosalind_shand_id IS NOT NULL AND @camilla_id IS NOT NULL;

-- Relation mariage
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, StartDate, EndDate, CreatedAt)
SELECT @bruce_shand_id, @rosalind_shand_id, 3, '1946-01-02', '1994-01-14', NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @bruce_shand_id AND Person2Id = @rosalind_shand_id) OR (Person1Id = @rosalind_shand_id AND Person2Id = @bruce_shand_id)) AND RelationshipType = 3
) AND @bruce_shand_id IS NOT NULL AND @rosalind_shand_id IS NOT NULL;

-- ============================================
-- GRANDS-PARENTS DE CAMILLA (côté Shand)
-- ============================================

-- Philip Morton Shand (grand-père paternel)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Philip', 'Shand', 'Morton', '1888-01-01', '1960-01-01', 'London, England', 'London, England', 'Male', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SELECT @philip_shand_id := Id FROM Persons WHERE FirstName = 'Philip' AND LastName = 'Shand' AND MiddleName = 'Morton' LIMIT 1;

-- Edith Harrington (grand-mère paternelle)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Edith', 'Shand', 'Harrington', '1890-01-01', '1950-01-01', 'London, England', 'London, England', 'Female', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SELECT @edith_shand_id := Id FROM Persons WHERE FirstName = 'Edith' AND LastName = 'Shand' AND MiddleName = 'Harrington' LIMIT 1;

-- Relations parent-enfant
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @philip_shand_id, @bruce_shand_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @philip_shand_id AND Person2Id = @bruce_shand_id AND RelationshipType = 1
) AND @philip_shand_id IS NOT NULL AND @bruce_shand_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @edith_shand_id, @bruce_shand_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @edith_shand_id AND Person2Id = @bruce_shand_id AND RelationshipType = 1
) AND @edith_shand_id IS NOT NULL AND @bruce_shand_id IS NOT NULL;

-- ============================================
-- GRANDS-PARENTS DE CAMILLA (côté Cubitt)
-- ============================================

-- Roland Cubitt, 3rd Baron Ashcombe (grand-père maternel)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Roland', 'Cubitt', '3rd Baron Ashcombe', '1899-01-26', '1962-10-28', 'London, England', 'London, England', 'Male', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SELECT @roland_cubitt_id := Id FROM Persons WHERE FirstName = 'Roland' AND LastName = 'Cubitt' AND MiddleName = '3rd Baron Ashcombe' LIMIT 1;

-- Sonia Keppel (grand-mère maternelle)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Sonia', 'Cubitt', 'Keppel', '1900-05-24', '1986-08-16', 'London, England', 'London, England', 'Female', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SELECT @sonia_cubitt_id := Id FROM Persons WHERE FirstName = 'Sonia' AND LastName = 'Cubitt' AND MiddleName = 'Keppel' LIMIT 1;

-- Relations parent-enfant
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @roland_cubitt_id, @rosalind_shand_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @roland_cubitt_id AND Person2Id = @rosalind_shand_id AND RelationshipType = 1
) AND @roland_cubitt_id IS NOT NULL AND @rosalind_shand_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @sonia_cubitt_id, @rosalind_shand_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @sonia_cubitt_id AND Person2Id = @rosalind_shand_id AND RelationshipType = 1
) AND @sonia_cubitt_id IS NOT NULL AND @rosalind_shand_id IS NOT NULL;

-- ============================================
-- CATHERINE MIDDLETON (Conjoint actuel de William)
-- ============================================

-- Catherine Middleton (Princess of Wales)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Catherine', 'Middleton', 'Princess of Wales', '1982-01-09', 'Reading, Berkshire, England', 'Female', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SELECT @kate_id := Id FROM Persons WHERE FirstName = 'Catherine' AND LastName = 'Middleton' LIMIT 1;

-- Relation mariage actuel avec William (2011, sans EndDate)
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, StartDate, CreatedAt)
SELECT @william_id, @kate_id, 3, '2011-04-29', NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @william_id AND Person2Id = @kate_id) OR (Person1Id = @kate_id AND Person2Id = @william_id)) 
    AND RelationshipType = 3
    AND EndDate IS NULL
) AND @william_id IS NOT NULL AND @kate_id IS NOT NULL;

-- ============================================
-- PARENTS DE KATE
-- ============================================

-- Michael Middleton (père de Kate)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Michael', 'Middleton', 'Francis', '1949-06-23', 'Leeds, Yorkshire, England', 'Male', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SELECT @michael_middleton_id := Id FROM Persons WHERE FirstName = 'Michael' AND LastName = 'Middleton' LIMIT 1;

-- Carole Goldsmith (mère de Kate)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Carole', 'Middleton', 'Goldsmith', '1955-01-31', 'Perivale, Middlesex, England', 'Female', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SELECT @carole_middleton_id := Id FROM Persons WHERE FirstName = 'Carole' AND LastName = 'Middleton' AND MiddleName = 'Goldsmith' LIMIT 1;

-- Relations parent-enfant
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @michael_middleton_id, @kate_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @michael_middleton_id AND Person2Id = @kate_id AND RelationshipType = 1
) AND @michael_middleton_id IS NOT NULL AND @kate_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @carole_middleton_id, @kate_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @carole_middleton_id AND Person2Id = @kate_id AND RelationshipType = 1
) AND @carole_middleton_id IS NOT NULL AND @kate_id IS NOT NULL;

-- Relation mariage
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, StartDate, CreatedAt)
SELECT @michael_middleton_id, @carole_middleton_id, 3, '1980-06-21', NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @michael_middleton_id AND Person2Id = @carole_middleton_id) OR (Person1Id = @carole_middleton_id AND Person2Id = @michael_middleton_id)) AND RelationshipType = 3
) AND @michael_middleton_id IS NOT NULL AND @carole_middleton_id IS NOT NULL;

-- ============================================
-- GRANDS-PARENTS DE KATE (côté Middleton)
-- ============================================

-- Peter Middleton (grand-père paternel)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Peter', 'Middleton', 'Francis', '1920-01-01', '2010-01-01', 'Leeds, Yorkshire, England', 'Leeds, Yorkshire, England', 'Male', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SELECT @peter_middleton_id := Id FROM Persons WHERE FirstName = 'Peter' AND LastName = 'Middleton' AND MiddleName = 'Francis' LIMIT 1;

-- Valerie Glassborow (grand-mère paternelle)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Valerie', 'Middleton', 'Glassborow', '1924-01-01', '2006-01-01', 'Leeds, Yorkshire, England', 'Leeds, Yorkshire, England', 'Female', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SELECT @valerie_middleton_id := Id FROM Persons WHERE FirstName = 'Valerie' AND LastName = 'Middleton' AND MiddleName = 'Glassborow' LIMIT 1;

-- Relations parent-enfant
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @peter_middleton_id, @michael_middleton_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @peter_middleton_id AND Person2Id = @michael_middleton_id AND RelationshipType = 1
) AND @peter_middleton_id IS NOT NULL AND @michael_middleton_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @valerie_middleton_id, @michael_middleton_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @valerie_middleton_id AND Person2Id = @michael_middleton_id AND RelationshipType = 1
) AND @valerie_middleton_id IS NOT NULL AND @michael_middleton_id IS NOT NULL;

-- ============================================
-- GRANDS-PARENTS DE KATE (côté Goldsmith)
-- ============================================

-- Ronald Goldsmith (grand-père maternel)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Ronald', 'Goldsmith', 'James', '1931-01-01', '2003-01-01', 'Perivale, Middlesex, England', 'Perivale, Middlesex, England', 'Male', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SELECT @ronald_goldsmith_id := Id FROM Persons WHERE FirstName = 'Ronald' AND LastName = 'Goldsmith' LIMIT 1;

-- Dorothy Harrison (grand-mère maternelle)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Dorothy', 'Goldsmith', 'Harrison', '1935-01-01', '2006-01-01', 'Perivale, Middlesex, England', 'Perivale, Middlesex, England', 'Female', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SELECT @dorothy_goldsmith_id := Id FROM Persons WHERE FirstName = 'Dorothy' AND LastName = 'Goldsmith' AND MiddleName = 'Harrison' LIMIT 1;

-- Relations parent-enfant
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @ronald_goldsmith_id, @carole_middleton_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @ronald_goldsmith_id AND Person2Id = @carole_middleton_id AND RelationshipType = 1
) AND @ronald_goldsmith_id IS NOT NULL AND @carole_middleton_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @dorothy_goldsmith_id, @carole_middleton_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @dorothy_goldsmith_id AND Person2Id = @carole_middleton_id AND RelationshipType = 1
) AND @dorothy_goldsmith_id IS NOT NULL AND @carole_middleton_id IS NOT NULL;

-- ============================================
-- VÉRIFICATION
-- ============================================

SELECT 'Conjoints et ascendants ajoutés avec succès!' AS result;

-- Afficher les conjoints actuels
SELECT 
    p1.FirstName AS Person,
    p1.MiddleName AS PersonTitle,
    p2.FirstName AS Spouse,
    p2.MiddleName AS SpouseTitle,
    r.StartDate AS MarriageDate
FROM Relationships r
INNER JOIN Persons p1 ON r.Person1Id = p1.Id
INNER JOIN Persons p2 ON r.Person2Id = p2.Id
WHERE r.RelationshipType = 3 
  AND r.EndDate IS NULL
  AND p1.FirstName IN ('Charles', 'William')
ORDER BY p1.FirstName;

-- Afficher les ascendants de Camilla
SELECT 
    p.FirstName AS Person,
    p.MiddleName,
    parent.FirstName AS Parent,
    parent.MiddleName AS ParentTitle
FROM Persons p
INNER JOIN Relationships r ON p.Id = r.Person2Id
INNER JOIN Persons parent ON r.Person1Id = parent.Id
WHERE r.RelationshipType = 1
  AND (p.FirstName = 'Camilla' OR p.FirstName IN ('Bruce', 'Rosalind', 'Philip', 'Edith', 'Roland', 'Sonia'))
ORDER BY p.FirstName, parent.FirstName;

-- Afficher les ascendants de Kate
SELECT 
    p.FirstName AS Person,
    p.MiddleName,
    parent.FirstName AS Parent,
    parent.MiddleName AS ParentTitle
FROM Persons p
INNER JOIN Relationships r ON p.Id = r.Person2Id
INNER JOIN Persons parent ON r.Person1Id = parent.Id
WHERE r.RelationshipType = 1
  AND (p.FirstName = 'Catherine' OR p.FirstName IN ('Michael', 'Carole', 'Peter', 'Valerie', 'Ronald', 'Dorothy'))
ORDER BY p.FirstName, parent.FirstName;
