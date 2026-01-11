-- ============================================
-- Ajouter la Princesse Diana et son ascendance
-- ============================================
-- Ce script ajoute :
-- - Diana, Princess of Wales
-- - Ses parents : John Spencer (8th Earl Spencer) et Frances Shand Kydd
-- - Ses grands-parents : Albert Spencer (7th Earl Spencer) et Cynthia Hamilton
-- - Relie Diana à ses enfants (William et Harry)
-- ============================================

USE gegeDot;

-- ============================================
-- TROUVER CHARLES, WILLIAM ET HARRY
-- ============================================

SELECT @charles_id := Id FROM Persons WHERE FirstName = 'Charles' AND LastName = 'Windsor' LIMIT 1;
SELECT @william_id := Id FROM Persons WHERE FirstName = 'William' AND LastName = 'Windsor' AND MiddleName = 'Prince of Wales' LIMIT 1;
SELECT @harry_id := Id FROM Persons WHERE FirstName = 'Harry' AND LastName = 'Windsor' AND MiddleName = 'Duke of Sussex' LIMIT 1;

-- ============================================
-- DIANA, PRINCESSE DE GALLES
-- ============================================

INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Diana', 'Spencer', 'Princess of Wales', '1961-07-01', '1997-08-31', 'Park House, Sandringham, Norfolk, England', 'Pitié-Salpêtrière Hospital, Paris, France', 'Female', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SELECT @diana_id := Id FROM Persons WHERE FirstName = 'Diana' AND LastName = 'Spencer' AND MiddleName = 'Princess of Wales' LIMIT 1;

-- Relation mariage avec Charles (divorcé en 1996)
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, StartDate, EndDate, CreatedAt)
SELECT @charles_id, @diana_id, 3, '1981-07-29', '1996-08-28', NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @charles_id AND Person2Id = @diana_id) OR (Person1Id = @diana_id AND Person2Id = @charles_id)) AND RelationshipType = 3
) AND @charles_id IS NOT NULL AND @diana_id IS NOT NULL;

-- Relations parent-enfant : Diana est mère de William et Harry
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @diana_id, @william_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @diana_id AND Person2Id = @william_id AND RelationshipType = 1
) AND @diana_id IS NOT NULL AND @william_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @diana_id, @harry_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @diana_id AND Person2Id = @harry_id AND RelationshipType = 1
) AND @diana_id IS NOT NULL AND @harry_id IS NOT NULL;

-- ============================================
-- PARENTS DE DIANA
-- ============================================

-- John Spencer, 8th Earl Spencer (père de Diana)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('John', 'Spencer', '8th Earl Spencer', '1924-01-24', '1992-03-29', 'London, England', 'London, England', 'Male', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SELECT @john_spencer_id := Id FROM Persons WHERE FirstName = 'John' AND LastName = 'Spencer' AND MiddleName = '8th Earl Spencer' LIMIT 1;

-- Frances Shand Kydd (mère de Diana, née Frances Burke Roche)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Frances', 'Shand Kydd', 'Ruth Burke Roche', '1936-01-20', '2004-06-03', 'Sandringham, Norfolk, England', 'Seil Island, Scotland', 'Female', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SELECT @frances_id := Id FROM Persons WHERE FirstName = 'Frances' AND LastName = 'Shand Kydd' AND MiddleName = 'Ruth Burke Roche' LIMIT 1;

-- Relations parent-enfant : John et Frances sont parents de Diana
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @john_spencer_id, @diana_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @john_spencer_id AND Person2Id = @diana_id AND RelationshipType = 1
) AND @john_spencer_id IS NOT NULL AND @diana_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @frances_id, @diana_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @frances_id AND Person2Id = @diana_id AND RelationshipType = 1
) AND @frances_id IS NOT NULL AND @diana_id IS NOT NULL;

-- Relation mariage entre John Spencer et Frances (divorcé en 1969)
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, StartDate, EndDate, CreatedAt)
SELECT @john_spencer_id, @frances_id, 3, '1954-06-01', '1969-04-15', NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @john_spencer_id AND Person2Id = @frances_id) OR (Person1Id = @frances_id AND Person2Id = @john_spencer_id)) AND RelationshipType = 3
) AND @john_spencer_id IS NOT NULL AND @frances_id IS NOT NULL;

-- ============================================
-- GRANDS-PARENTS DE DIANA (côté Spencer)
-- ============================================

-- Albert Spencer, 7th Earl Spencer (grand-père paternel de Diana)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Albert', 'Spencer', '7th Earl Spencer', '1892-05-23', '1975-06-09', 'London, England', 'Northamptonshire, England', 'Male', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SELECT @albert_spencer_id := Id FROM Persons WHERE FirstName = 'Albert' AND LastName = 'Spencer' AND MiddleName = '7th Earl Spencer' LIMIT 1;

-- Cynthia Hamilton, Countess Spencer (grand-mère paternelle de Diana)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Cynthia', 'Spencer', 'Countess Spencer', '1897-08-16', '1972-12-04', 'London, England', 'Northamptonshire, England', 'Female', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SELECT @cynthia_spencer_id := Id FROM Persons WHERE FirstName = 'Cynthia' AND LastName = 'Spencer' AND MiddleName = 'Countess Spencer' LIMIT 1;

-- Relations parent-enfant : Albert et Cynthia sont parents de John Spencer
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @albert_spencer_id, @john_spencer_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @albert_spencer_id AND Person2Id = @john_spencer_id AND RelationshipType = 1
) AND @albert_spencer_id IS NOT NULL AND @john_spencer_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @cynthia_spencer_id, @john_spencer_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @cynthia_spencer_id AND Person2Id = @john_spencer_id AND RelationshipType = 1
) AND @cynthia_spencer_id IS NOT NULL AND @john_spencer_id IS NOT NULL;

-- Relation mariage entre Albert et Cynthia
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, StartDate, CreatedAt)
SELECT @albert_spencer_id, @cynthia_spencer_id, 3, '1919-02-26', NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @albert_spencer_id AND Person2Id = @cynthia_spencer_id) OR (Person1Id = @cynthia_spencer_id AND Person2Id = @albert_spencer_id)) AND RelationshipType = 3
) AND @albert_spencer_id IS NOT NULL AND @cynthia_spencer_id IS NOT NULL;

-- ============================================
-- GRANDS-PARENTS DE DIANA (côté maternel)
-- ============================================

-- Edmund Roche, 4th Baron Fermoy (grand-père maternel de Diana)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Edmund', 'Roche', '4th Baron Fermoy', '1885-05-15', '1955-07-13', 'London, England', 'London, England', 'Male', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SELECT @edmund_roche_id := Id FROM Persons WHERE FirstName = 'Edmund' AND LastName = 'Roche' AND MiddleName = '4th Baron Fermoy' LIMIT 1;

-- Ruth Gill, Baroness Fermoy (grand-mère maternelle de Diana)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Ruth', 'Roche', 'Baroness Fermoy', '1908-10-02', '1993-07-06', 'London, England', 'London, England', 'Female', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SELECT @ruth_roche_id := Id FROM Persons WHERE FirstName = 'Ruth' AND LastName = 'Roche' AND MiddleName = 'Baroness Fermoy' LIMIT 1;

-- Relations parent-enfant : Edmund et Ruth sont parents de Frances
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @edmund_roche_id, @frances_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @edmund_roche_id AND Person2Id = @frances_id AND RelationshipType = 1
) AND @edmund_roche_id IS NOT NULL AND @frances_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @ruth_roche_id, @frances_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @ruth_roche_id AND Person2Id = @frances_id AND RelationshipType = 1
) AND @ruth_roche_id IS NOT NULL AND @frances_id IS NOT NULL;

-- Relation mariage entre Edmund et Ruth
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, StartDate, CreatedAt)
SELECT @edmund_roche_id, @ruth_roche_id, 3, '1931-01-17', NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @edmund_roche_id AND Person2Id = @ruth_roche_id) OR (Person1Id = @ruth_roche_id AND Person2Id = @edmund_roche_id)) AND RelationshipType = 3
) AND @edmund_roche_id IS NOT NULL AND @ruth_roche_id IS NOT NULL;

-- ============================================
-- VÉRIFICATION
-- ============================================

SELECT 'Diana et son ascendance ajoutés avec succès!' AS result;

-- Afficher l'ascendance de Diana
SELECT 
    'Diana' AS Person,
    p.FirstName AS Parent,
    p.LastName,
    p.MiddleName,
    p.BirthDate
FROM Persons diana
INNER JOIN Relationships r ON diana.Id = r.Person2Id
INNER JOIN Persons p ON r.Person1Id = p.Id
WHERE diana.FirstName = 'Diana' AND diana.LastName = 'Spencer' AND r.RelationshipType = 1
ORDER BY p.BirthDate;

-- Afficher la descendance de Diana
SELECT 
    'Diana' AS Person,
    p.FirstName AS Child,
    p.LastName,
    p.MiddleName,
    p.BirthDate
FROM Persons diana
INNER JOIN Relationships r ON diana.Id = r.Person1Id
INNER JOIN Persons p ON r.Person2Id = p.Id
WHERE diana.FirstName = 'Diana' AND diana.LastName = 'Spencer' AND r.RelationshipType = 1
ORDER BY p.BirthDate;
