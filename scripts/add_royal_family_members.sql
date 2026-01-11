-- ============================================
-- Ajouter plus de membres de la famille royale britannique
-- ============================================
-- Ce script ajoute les frères/sœurs, enfants, petits-enfants et autres membres importants
-- 
-- IMPORTANT: Ce script suppose que les membres suivants existent déjà dans la base :
-- - Charles Windsor (Prince of Wales / King Charles III)
-- - Elizabeth II (Queen Elizabeth)
-- - Philip Mountbatten (Duke of Edinburgh)
-- - George VI (King George VI)
-- - Elizabeth Bowes-Lyon (Queen Mother)
--
-- Si ces membres n'existent pas, exécutez d'abord les scripts d'initialisation appropriés.
--
-- Pour exécuter ce script :
-- mysql -u root -p gegeDot < scripts/add_royal_family_members.sql
-- ou depuis MySQL :
-- source scripts/add_royal_family_members.sql;
-- ============================================

USE gegeDot;

-- ============================================
-- FRÈRES ET SŒURS DE CHARLES WINDSOR
-- ============================================

-- Anne, Princess Royal (sœur de Charles)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Anne', 'Windsor', 'Princess Royal', '1950-08-15', 'Clarence House, London', 'Female', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @anne_id = LAST_INSERT_ID();
SELECT @anne_id := Id FROM Persons WHERE FirstName = 'Anne' AND LastName = 'Windsor' AND MiddleName = 'Princess Royal' LIMIT 1;

-- Andrew, Duke of York (frère de Charles)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Andrew', 'Windsor', 'Duke of York', '1960-02-19', 'Buckingham Palace, London', 'Male', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @andrew_id = LAST_INSERT_ID();
SELECT @andrew_id := Id FROM Persons WHERE FirstName = 'Andrew' AND LastName = 'Windsor' AND MiddleName = 'Duke of York' LIMIT 1;

-- Edward, Earl of Wessex (frère de Charles)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Edward', 'Windsor', 'Earl of Wessex', '1964-03-10', 'Buckingham Palace, London', 'Male', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @edward_id = LAST_INSERT_ID();
SELECT @edward_id := Id FROM Persons WHERE FirstName = 'Edward' AND LastName = 'Windsor' AND MiddleName = 'Earl of Wessex' LIMIT 1;

-- Trouver Charles Windsor
SELECT @charles_id := Id FROM Persons WHERE FirstName = 'Charles' AND LastName = 'Windsor' LIMIT 1;

-- Relations siblings avec Charles
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @charles_id, @anne_id, 4, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @charles_id AND Person2Id = @anne_id) OR (Person1Id = @anne_id AND Person2Id = @charles_id)) AND RelationshipType = 4
) AND @charles_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @charles_id, @andrew_id, 4, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @charles_id AND Person2Id = @andrew_id) OR (Person1Id = @andrew_id AND Person2Id = @charles_id)) AND RelationshipType = 4
) AND @charles_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @charles_id, @edward_id, 4, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @charles_id AND Person2Id = @edward_id) OR (Person1Id = @edward_id AND Person2Id = @charles_id)) AND RelationshipType = 4
) AND @charles_id IS NOT NULL;

-- Relations parent-enfant (Elizabeth II et Philip sont parents de tous)
-- Trouver Elizabeth II (ID 12 supposé) et Philip (ID 13 supposé)
SELECT @elizabeth_id := Id FROM Persons WHERE FirstName = 'Elizabeth' AND LastName = 'Windsor' LIMIT 1;
SELECT @philip_id := Id FROM Persons WHERE FirstName = 'Philip' AND LastName = 'Mountbatten' LIMIT 1;

-- Anne est enfant de Elizabeth et Philip
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @elizabeth_id, @anne_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @elizabeth_id AND Person2Id = @anne_id AND RelationshipType = 1
) AND @elizabeth_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @philip_id, @anne_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @philip_id AND Person2Id = @anne_id AND RelationshipType = 1
) AND @philip_id IS NOT NULL;

-- Andrew est enfant de Elizabeth et Philip
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @elizabeth_id, @andrew_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @elizabeth_id AND Person2Id = @andrew_id AND RelationshipType = 1
) AND @elizabeth_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @philip_id, @andrew_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @philip_id AND Person2Id = @andrew_id AND RelationshipType = 1
) AND @philip_id IS NOT NULL;

-- Edward est enfant de Elizabeth et Philip
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @elizabeth_id, @edward_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @elizabeth_id AND Person2Id = @edward_id AND RelationshipType = 1
) AND @elizabeth_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @philip_id, @edward_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @philip_id AND Person2Id = @edward_id AND RelationshipType = 1
) AND @philip_id IS NOT NULL;

-- ============================================
-- ÉPOUSES DE CHARLES
-- ============================================

-- Diana, Princess of Wales (première épouse de Charles)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Diana', 'Spencer', 'Princess of Wales', '1961-07-01', '1997-08-31', 'Sandringham, England', 'Paris, France', 'Female', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @diana_id = LAST_INSERT_ID();
SELECT @diana_id := Id FROM Persons WHERE FirstName = 'Diana' AND LastName = 'Spencer' LIMIT 1;

-- Camilla, Queen Consort (seconde épouse de Charles)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Camilla', 'Parker Bowles', 'Queen Consort', '1947-07-17', 'London, England', 'Female', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @camilla_id = LAST_INSERT_ID();
SELECT @camilla_id := Id FROM Persons WHERE FirstName = 'Camilla' AND LastName = 'Parker Bowles' LIMIT 1;

-- Relations mariage avec Charles (trouver Charles si pas déjà fait)
SELECT @charles_id := Id FROM Persons WHERE FirstName = 'Charles' AND LastName = 'Windsor' LIMIT 1;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, StartDate, EndDate, CreatedAt)
SELECT @charles_id, @diana_id, 3, '1981-07-29', '1996-08-28', NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @charles_id AND Person2Id = @diana_id) OR (Person1Id = @diana_id AND Person2Id = @charles_id)) AND RelationshipType = 3
) AND @charles_id IS NOT NULL AND @diana_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, StartDate, CreatedAt)
SELECT @charles_id, @camilla_id, 3, '2005-04-09', NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @charles_id AND Person2Id = @camilla_id) OR (Person1Id = @camilla_id AND Person2Id = @charles_id)) AND RelationshipType = 3
) AND @charles_id IS NOT NULL AND @camilla_id IS NOT NULL;

-- ============================================
-- ENFANTS DE CHARLES
-- ============================================

-- William, Prince of Wales (fils de Charles et Diana)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('William', 'Windsor', 'Prince of Wales', '1982-06-21', 'St Mary\'s Hospital, London', 'Male', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @william_id = LAST_INSERT_ID();
SELECT @william_id := Id FROM Persons WHERE FirstName = 'William' AND LastName = 'Windsor' AND MiddleName = 'Prince of Wales' LIMIT 1;

-- Harry, Duke of Sussex (fils de Charles et Diana)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Harry', 'Windsor', 'Duke of Sussex', '1984-09-15', 'St Mary\'s Hospital, London', 'Male', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @harry_id = LAST_INSERT_ID();
SELECT @harry_id := Id FROM Persons WHERE FirstName = 'Harry' AND LastName = 'Windsor' AND MiddleName = 'Duke of Sussex' LIMIT 1;

-- Relations parent-enfant (Charles et Diana sont parents de William et Harry)
-- Trouver Charles si pas déjà fait
SELECT @charles_id := Id FROM Persons WHERE FirstName = 'Charles' AND LastName = 'Windsor' LIMIT 1;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @charles_id, @william_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @charles_id AND Person2Id = @william_id AND RelationshipType = 1
) AND @charles_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @diana_id, @william_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @diana_id AND Person2Id = @william_id AND RelationshipType = 1
) AND @diana_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @charles_id, @harry_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @charles_id AND Person2Id = @harry_id AND RelationshipType = 1
) AND @charles_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @diana_id, @harry_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @diana_id AND Person2Id = @harry_id AND RelationshipType = 1
) AND @diana_id IS NOT NULL;

-- Relation sibling entre William et Harry
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @william_id, @harry_id, 4, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @william_id AND Person2Id = @harry_id) OR (Person1Id = @harry_id AND Person2Id = @william_id)) AND RelationshipType = 4
);

-- ============================================
-- ÉPOUSES DES ENFANTS DE CHARLES
-- ============================================

-- Catherine, Princess of Wales (épouse de William)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Catherine', 'Middleton', 'Princess of Wales', '1982-01-09', 'Reading, England', 'Female', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @kate_id = LAST_INSERT_ID();
SELECT @kate_id := Id FROM Persons WHERE FirstName = 'Catherine' AND LastName = 'Middleton' LIMIT 1;

-- Meghan, Duchess of Sussex (épouse de Harry)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Meghan', 'Markle', 'Duchess of Sussex', '1981-08-04', 'Los Angeles, California, USA', 'Female', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @meghan_id = LAST_INSERT_ID();
SELECT @meghan_id := Id FROM Persons WHERE FirstName = 'Meghan' AND LastName = 'Markle' LIMIT 1;

-- Relations mariage
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, StartDate, CreatedAt)
SELECT @william_id, @kate_id, 3, '2011-04-29', NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @william_id AND Person2Id = @kate_id) OR (Person1Id = @kate_id AND Person2Id = @william_id)) AND RelationshipType = 3
);

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, StartDate, CreatedAt)
SELECT @harry_id, @meghan_id, 3, '2018-05-19', NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @harry_id AND Person2Id = @meghan_id) OR (Person1Id = @meghan_id AND Person2Id = @harry_id)) AND RelationshipType = 3
);

-- ============================================
-- ENFANTS DE WILLIAM (PETITS-ENFANTS DE CHARLES)
-- ============================================

-- George, Prince of Wales (fils de William et Kate)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('George', 'Windsor', 'Prince of Wales', '2013-07-22', 'St Mary\'s Hospital, London', 'Male', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @george_william_id = LAST_INSERT_ID();
SELECT @george_william_id := Id FROM Persons WHERE FirstName = 'George' AND LastName = 'Windsor' AND BirthDate = '2013-07-22' LIMIT 1;

-- Charlotte, Princess of Wales (fille de William et Kate)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Charlotte', 'Windsor', 'Princess of Wales', '2015-05-02', 'St Mary\'s Hospital, London', 'Female', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @charlotte_id = LAST_INSERT_ID();
SELECT @charlotte_id := Id FROM Persons WHERE FirstName = 'Charlotte' AND LastName = 'Windsor' AND BirthDate = '2015-05-02' LIMIT 1;

-- Louis, Prince of Wales (fils de William et Kate)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Louis', 'Windsor', 'Prince of Wales', '2018-04-23', 'St Mary\'s Hospital, London', 'Male', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @louis_id = LAST_INSERT_ID();
SELECT @louis_id := Id FROM Persons WHERE FirstName = 'Louis' AND LastName = 'Windsor' AND BirthDate = '2018-04-23' LIMIT 1;

-- Relations parent-enfant (William et Kate sont parents)
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @william_id, @george_william_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @william_id AND Person2Id = @george_william_id AND RelationshipType = 1
);

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @kate_id, @george_william_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @kate_id AND Person2Id = @george_william_id AND RelationshipType = 1
) AND @kate_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @william_id, @charlotte_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @william_id AND Person2Id = @charlotte_id AND RelationshipType = 1
);

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @kate_id, @charlotte_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @kate_id AND Person2Id = @charlotte_id AND RelationshipType = 1
) AND @kate_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @william_id, @louis_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @william_id AND Person2Id = @louis_id AND RelationshipType = 1
);

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @kate_id, @louis_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @kate_id AND Person2Id = @louis_id AND RelationshipType = 1
) AND @kate_id IS NOT NULL;

-- Relations siblings entre les enfants de William
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @george_william_id, @charlotte_id, 4, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @george_william_id AND Person2Id = @charlotte_id) OR (Person1Id = @charlotte_id AND Person2Id = @george_william_id)) AND RelationshipType = 4
);

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @george_william_id, @louis_id, 4, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @george_william_id AND Person2Id = @louis_id) OR (Person1Id = @louis_id AND Person2Id = @george_william_id)) AND RelationshipType = 4
);

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @charlotte_id, @louis_id, 4, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @charlotte_id AND Person2Id = @louis_id) OR (Person1Id = @louis_id AND Person2Id = @charlotte_id)) AND RelationshipType = 4
);

-- ============================================
-- ENFANTS DE HARRY (PETITS-ENFANTS DE CHARLES)
-- ============================================

-- Archie, Duke of Sussex (fils de Harry et Meghan)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Archie', 'Mountbatten-Windsor', 'Duke of Sussex', '2019-05-06', 'Portland Hospital, London', 'Male', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @archie_id = LAST_INSERT_ID();
SELECT @archie_id := Id FROM Persons WHERE FirstName = 'Archie' AND LastName = 'Mountbatten-Windsor' LIMIT 1;

-- Lilibet, Duchess of Sussex (fille de Harry et Meghan)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Lilibet', 'Mountbatten-Windsor', 'Duchess of Sussex', '2021-06-04', 'Santa Barbara, California, USA', 'Female', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @lilibet_id = LAST_INSERT_ID();
SELECT @lilibet_id := Id FROM Persons WHERE FirstName = 'Lilibet' AND LastName = 'Mountbatten-Windsor' LIMIT 1;

-- Relations parent-enfant (Harry et Meghan sont parents)
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @harry_id, @archie_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @harry_id AND Person2Id = @archie_id AND RelationshipType = 1
);

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @meghan_id, @archie_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @meghan_id AND Person2Id = @archie_id AND RelationshipType = 1
) AND @meghan_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @harry_id, @lilibet_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @harry_id AND Person2Id = @lilibet_id AND RelationshipType = 1
);

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @meghan_id, @lilibet_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @meghan_id AND Person2Id = @lilibet_id AND RelationshipType = 1
) AND @meghan_id IS NOT NULL;

-- Relation sibling entre Archie et Lilibet
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @archie_id, @lilibet_id, 4, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @archie_id AND Person2Id = @lilibet_id) OR (Person1Id = @lilibet_id AND Person2Id = @archie_id)) AND RelationshipType = 4
);

-- ============================================
-- SŒUR DE LA REINE ELIZABETH II
-- ============================================

-- Margaret, Countess of Snowdon (sœur d'Elizabeth II)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Margaret', 'Windsor', 'Countess of Snowdon', '1930-08-21', '2002-02-09', 'Glamis Castle, Scotland', 'King Edward VII Hospital, London', 'Female', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @margaret_id = LAST_INSERT_ID();
SELECT @margaret_id := Id FROM Persons WHERE FirstName = 'Margaret' AND LastName = 'Windsor' AND MiddleName = 'Countess of Snowdon' LIMIT 1;

-- Relation sibling avec Elizabeth II
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @elizabeth_id, @margaret_id, 4, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @elizabeth_id AND Person2Id = @margaret_id) OR (Person1Id = @margaret_id AND Person2Id = @elizabeth_id)) AND RelationshipType = 4
) AND @elizabeth_id IS NOT NULL;

-- Relations parent-enfant (George VI et Elizabeth Bowes-Lyon sont parents de Margaret)
SELECT @george_vi_id := Id FROM Persons WHERE FirstName = 'George' AND LastName = 'Windsor' AND MiddleName = 'VI' LIMIT 1;
SELECT @elizabeth_bowes_id := Id FROM Persons WHERE FirstName = 'Elizabeth' AND LastName = 'Bowes-Lyon' LIMIT 1;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @george_vi_id, @margaret_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @george_vi_id AND Person2Id = @margaret_id AND RelationshipType = 1
) AND @george_vi_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @elizabeth_bowes_id, @margaret_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @elizabeth_bowes_id AND Person2Id = @margaret_id AND RelationshipType = 1
) AND @elizabeth_bowes_id IS NOT NULL;

-- ============================================
-- MESSAGE DE CONFIRMATION
-- ============================================

SELECT 'Membres supplémentaires de la famille royale ajoutés avec succès!' AS result;
