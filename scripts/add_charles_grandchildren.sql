-- ============================================
-- Ajouter les enfants de William et Harry (petits-enfants de Charles Windsor)
-- ============================================
-- Ce script ajoute :
-- - Les enfants de William (Prince of Wales) : George, Charlotte, Louis
-- - Les enfants de Harry (Duke of Sussex) : Archie, Lilibet
-- - Les épouses : Catherine (Kate Middleton) et Meghan Markle
-- ============================================

USE gegeDot;

-- ============================================
-- TROUVER CHARLES, WILLIAM ET HARRY
-- ============================================

SELECT @charles_id := Id FROM Persons WHERE FirstName = 'Charles' AND LastName = 'Windsor' LIMIT 1;

-- Créer William s'il n'existe pas
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('William', 'Windsor', 'Prince of Wales', '1982-06-21', 'St Mary\'s Hospital, London', 'Male', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SELECT @william_id := Id FROM Persons WHERE FirstName = 'William' AND LastName = 'Windsor' AND MiddleName = 'Prince of Wales' LIMIT 1;

-- Créer la relation parent-enfant avec Charles
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @charles_id, @william_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @charles_id AND Person2Id = @william_id AND RelationshipType = 1
) AND @charles_id IS NOT NULL AND @william_id IS NOT NULL;

-- Créer Harry s'il n'existe pas
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Harry', 'Windsor', 'Duke of Sussex', '1984-09-15', 'St Mary\'s Hospital, London', 'Male', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SELECT @harry_id := Id FROM Persons WHERE FirstName = 'Harry' AND LastName = 'Windsor' AND MiddleName = 'Duke of Sussex' LIMIT 1;

-- Créer la relation parent-enfant avec Charles
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @charles_id, @harry_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @charles_id AND Person2Id = @harry_id AND RelationshipType = 1
) AND @charles_id IS NOT NULL AND @harry_id IS NOT NULL;

-- ============================================
-- ÉPOUSES DE WILLIAM ET HARRY
-- ============================================

-- Catherine, Princess of Wales (épouse de William)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Catherine', 'Windsor', 'Princess of Wales', '1982-01-09', 'Reading, Berkshire, England', 'Female', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SELECT @catherine_id := Id FROM Persons WHERE FirstName = 'Catherine' AND LastName = 'Windsor' AND MiddleName = 'Princess of Wales' LIMIT 1;

-- Meghan, Duchess of Sussex (épouse de Harry)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Meghan', 'Windsor', 'Duchess of Sussex', '1981-08-04', 'Los Angeles, California, USA', 'Female', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SELECT @meghan_id := Id FROM Persons WHERE FirstName = 'Meghan' AND LastName = 'Windsor' AND MiddleName = 'Duchess of Sussex' LIMIT 1;

-- Relations mariage
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, StartDate, CreatedAt)
SELECT @william_id, @catherine_id, 3, '2011-04-29', NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @william_id AND Person2Id = @catherine_id) OR (Person1Id = @catherine_id AND Person2Id = @william_id)) AND RelationshipType = 3
) AND @william_id IS NOT NULL AND @catherine_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, StartDate, CreatedAt)
SELECT @harry_id, @meghan_id, 3, '2018-05-19', NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @harry_id AND Person2Id = @meghan_id) OR (Person1Id = @meghan_id AND Person2Id = @harry_id)) AND RelationshipType = 3
) AND @harry_id IS NOT NULL AND @meghan_id IS NOT NULL;

-- ============================================
-- ENFANTS DE WILLIAM (Prince of Wales)
-- ============================================

-- George, Prince of Wales (fils aîné de William)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('George', 'Windsor', 'Prince of Wales', '2013-07-22', 'St Mary\'s Hospital, London', 'Male', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SELECT @george_id := Id FROM Persons WHERE FirstName = 'George' AND LastName = 'Windsor' AND MiddleName = 'Prince of Wales' LIMIT 1;

-- Charlotte, Princess of Wales (fille de William)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Charlotte', 'Windsor', 'Princess of Wales', '2015-05-02', 'St Mary\'s Hospital, London', 'Female', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SELECT @charlotte_id := Id FROM Persons WHERE FirstName = 'Charlotte' AND LastName = 'Windsor' AND MiddleName = 'Princess of Wales' LIMIT 1;

-- Louis, Prince of Wales (fils cadet de William)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Louis', 'Windsor', 'Prince of Wales', '2018-04-23', 'St Mary\'s Hospital, London', 'Male', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SELECT @louis_id := Id FROM Persons WHERE FirstName = 'Louis' AND LastName = 'Windsor' AND MiddleName = 'Prince of Wales' LIMIT 1;

-- Relations parent-enfant (William et Catherine sont parents de George, Charlotte, Louis)
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @william_id, @george_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @william_id AND Person2Id = @george_id AND RelationshipType = 1
) AND @william_id IS NOT NULL AND @george_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @catherine_id, @george_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @catherine_id AND Person2Id = @george_id AND RelationshipType = 1
) AND @catherine_id IS NOT NULL AND @george_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @william_id, @charlotte_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @william_id AND Person2Id = @charlotte_id AND RelationshipType = 1
) AND @william_id IS NOT NULL AND @charlotte_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @catherine_id, @charlotte_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @catherine_id AND Person2Id = @charlotte_id AND RelationshipType = 1
) AND @catherine_id IS NOT NULL AND @charlotte_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @william_id, @louis_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @william_id AND Person2Id = @louis_id AND RelationshipType = 1
) AND @william_id IS NOT NULL AND @louis_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @catherine_id, @louis_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @catherine_id AND Person2Id = @louis_id AND RelationshipType = 1
) AND @catherine_id IS NOT NULL AND @louis_id IS NOT NULL;

-- ============================================
-- ENFANTS DE HARRY (Duke of Sussex)
-- ============================================

-- Archie, Duke of Sussex (fils aîné de Harry)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Archie', 'Windsor', 'Duke of Sussex', '2019-05-06', 'Portland Hospital, London', 'Male', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SELECT @archie_id := Id FROM Persons WHERE FirstName = 'Archie' AND LastName = 'Windsor' AND MiddleName = 'Duke of Sussex' LIMIT 1;

-- Lilibet, Duchess of Sussex (fille de Harry)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Lilibet', 'Windsor', 'Duchess of Sussex', '2021-06-04', 'Santa Barbara Cottage Hospital, California, USA', 'Female', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SELECT @lilibet_id := Id FROM Persons WHERE FirstName = 'Lilibet' AND LastName = 'Windsor' AND MiddleName = 'Duchess of Sussex' LIMIT 1;

-- Relations parent-enfant (Harry et Meghan sont parents de Archie et Lilibet)
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @harry_id, @archie_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @harry_id AND Person2Id = @archie_id AND RelationshipType = 1
) AND @harry_id IS NOT NULL AND @archie_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @meghan_id, @archie_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @meghan_id AND Person2Id = @archie_id AND RelationshipType = 1
) AND @meghan_id IS NOT NULL AND @archie_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @harry_id, @lilibet_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @harry_id AND Person2Id = @lilibet_id AND RelationshipType = 1
) AND @harry_id IS NOT NULL AND @lilibet_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @meghan_id, @lilibet_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @meghan_id AND Person2Id = @lilibet_id AND RelationshipType = 1
) AND @meghan_id IS NOT NULL AND @lilibet_id IS NOT NULL;

-- ============================================
-- VÉRIFICATION
-- ============================================

SELECT 'Petits-enfants de Charles Windsor ajoutés avec succès!' AS result;

-- Afficher les enfants de Charles
SELECT 
    p.Id,
    p.FirstName,
    p.LastName,
    p.MiddleName,
    p.BirthDate
FROM Persons p
INNER JOIN Relationships r ON p.Id = r.Person2Id
WHERE r.Person1Id = @charles_id AND r.RelationshipType = 1
ORDER BY p.BirthDate;

-- Afficher les petits-enfants de Charles (enfants de William et Harry)
SELECT 
    p.Id,
    p.FirstName,
    p.LastName,
    p.MiddleName,
    p.BirthDate,
    parent.FirstName AS ParentFirstName,
    parent.LastName AS ParentLastName
FROM Persons p
INNER JOIN Relationships r ON p.Id = r.Person2Id
INNER JOIN Persons parent ON r.Person1Id = parent.Id
WHERE parent.Id IN (@william_id, @harry_id) AND r.RelationshipType = 1
ORDER BY parent.FirstName, p.BirthDate;
