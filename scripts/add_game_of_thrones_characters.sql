-- ============================================
-- Ajouter les personnages de Game of Thrones
-- ============================================
-- Ce script ajoute les principales familles de Game of Thrones avec leurs relations
-- 
-- Familles incluses :
-- - Les Stark (Winterfell)
-- - Les Lannister (Casterly Rock)
-- - Les Targaryen (Dragonstone)
-- - Les Baratheon (Storm's End)
-- - Les Tully (Riverrun)
-- - Les Arryn (The Vale)
--
-- Pour exécuter ce script :
-- mysql -u root -p gegeDot < scripts/add_game_of_thrones_characters.sql
-- ou depuis MySQL :
-- source scripts/add_game_of_thrones_characters.sql;
-- ============================================

USE gegeDot;

-- ============================================
-- FAMILLE STARK (Winterfell)
-- ============================================

-- Rickard Stark (père de Ned)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Rickard', 'Stark', NULL, '250-01-15', '282-01-01', 'Winterfell, The North', 'King\'s Landing', 'Male', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @rickard_stark_id = LAST_INSERT_ID();
SELECT @rickard_stark_id := Id FROM Persons WHERE FirstName = 'Rickard' AND LastName = 'Stark' LIMIT 1;

-- Lyarra Stark (mère de Ned)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Lyarra', 'Stark', NULL, '255-03-20', '280-01-01', 'Winterfell, The North', 'Winterfell, The North', 'Female', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @lyarra_stark_id = LAST_INSERT_ID();
SELECT @lyarra_stark_id := Id FROM Persons WHERE FirstName = 'Lyarra' AND LastName = 'Stark' LIMIT 1;

-- Eddard "Ned" Stark
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Eddard', 'Stark', 'Ned', '263-01-01', '298-01-01', 'Winterfell, The North', 'King\'s Landing', 'Male', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @ned_stark_id = LAST_INSERT_ID();
SELECT @ned_stark_id := Id FROM Persons WHERE FirstName = 'Eddard' AND LastName = 'Stark' LIMIT 1;

-- Brandon Stark (frère aîné de Ned)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Brandon', 'Stark', NULL, '262-01-01', '282-01-01', 'Winterfell, The North', 'King\'s Landing', 'Male', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @brandon_stark_id = LAST_INSERT_ID();
SELECT @brandon_stark_id := Id FROM Persons WHERE FirstName = 'Brandon' AND LastName = 'Stark' LIMIT 1;

-- Benjen Stark (frère cadet de Ned)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Benjen', 'Stark', NULL, '267-01-01', 'Winterfell, The North', 'Male', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @benjen_stark_id = LAST_INSERT_ID();
SELECT @benjen_stark_id := Id FROM Persons WHERE FirstName = 'Benjen' AND LastName = 'Stark' LIMIT 1;

-- Lyanna Stark (sœur de Ned)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Lyanna', 'Stark', NULL, '266-01-01', '283-01-01', 'Winterfell, The North', 'Tower of Joy, Dorne', 'Female', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @lyanna_stark_id = LAST_INSERT_ID();
SELECT @lyanna_stark_id := Id FROM Persons WHERE FirstName = 'Lyanna' AND LastName = 'Stark' LIMIT 1;

-- Relations parent-enfant (Rickard et Lyarra sont parents de Ned, Brandon, Benjen, Lyanna)
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @rickard_stark_id, @ned_stark_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @rickard_stark_id AND Person2Id = @ned_stark_id AND RelationshipType = 1
) AND @rickard_stark_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @lyarra_stark_id, @ned_stark_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @lyarra_stark_id AND Person2Id = @ned_stark_id AND RelationshipType = 1
) AND @lyarra_stark_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @rickard_stark_id, @brandon_stark_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @rickard_stark_id AND Person2Id = @brandon_stark_id AND RelationshipType = 1
) AND @rickard_stark_id IS NOT NULL AND @brandon_stark_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @lyarra_stark_id, @brandon_stark_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @lyarra_stark_id AND Person2Id = @brandon_stark_id AND RelationshipType = 1
) AND @lyarra_stark_id IS NOT NULL AND @brandon_stark_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @rickard_stark_id, @benjen_stark_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @rickard_stark_id AND Person2Id = @benjen_stark_id AND RelationshipType = 1
) AND @rickard_stark_id IS NOT NULL AND @benjen_stark_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @lyarra_stark_id, @benjen_stark_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @lyarra_stark_id AND Person2Id = @benjen_stark_id AND RelationshipType = 1
) AND @lyarra_stark_id IS NOT NULL AND @benjen_stark_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @rickard_stark_id, @lyanna_stark_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @rickard_stark_id AND Person2Id = @lyanna_stark_id AND RelationshipType = 1
) AND @rickard_stark_id IS NOT NULL AND @lyanna_stark_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @lyarra_stark_id, @lyanna_stark_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @lyarra_stark_id AND Person2Id = @lyanna_stark_id AND RelationshipType = 1
) AND @lyarra_stark_id IS NOT NULL AND @lyanna_stark_id IS NOT NULL;

-- Relations siblings entre les enfants Stark
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @brandon_stark_id, @ned_stark_id, 4, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @brandon_stark_id AND Person2Id = @ned_stark_id) OR (Person1Id = @ned_stark_id AND Person2Id = @brandon_stark_id)) AND RelationshipType = 4
) AND @brandon_stark_id IS NOT NULL AND @ned_stark_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @ned_stark_id, @benjen_stark_id, 4, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @ned_stark_id AND Person2Id = @benjen_stark_id) OR (Person1Id = @benjen_stark_id AND Person2Id = @ned_stark_id)) AND RelationshipType = 4
) AND @ned_stark_id IS NOT NULL AND @benjen_stark_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @ned_stark_id, @lyanna_stark_id, 4, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @ned_stark_id AND Person2Id = @lyanna_stark_id) OR (Person1Id = @lyanna_stark_id AND Person2Id = @ned_stark_id)) AND RelationshipType = 4
) AND @ned_stark_id IS NOT NULL AND @lyanna_stark_id IS NOT NULL;

-- Mariage Rickard et Lyarra
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, StartDate, CreatedAt)
SELECT @rickard_stark_id, @lyarra_stark_id, 3, '270-01-01', NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @rickard_stark_id AND Person2Id = @lyarra_stark_id) OR (Person1Id = @lyarra_stark_id AND Person2Id = @rickard_stark_id)) AND RelationshipType = 3
) AND @rickard_stark_id IS NOT NULL AND @lyarra_stark_id IS NOT NULL;

-- ============================================
-- FAMILLE TULLY (Riverrun)
-- ============================================

-- Hoster Tully
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Hoster', 'Tully', NULL, '250-01-01', '300-01-01', 'Riverrun, The Riverlands', 'Riverrun, The Riverlands', 'Male', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @hoster_tully_id = LAST_INSERT_ID();
SELECT @hoster_tully_id := Id FROM Persons WHERE FirstName = 'Hoster' AND LastName = 'Tully' LIMIT 1;

-- Minisa Whent (épouse de Hoster)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Minisa', 'Whent', NULL, '255-01-01', '280-01-01', 'Harrenhal, The Riverlands', 'Riverrun, The Riverlands', 'Female', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @minisa_whent_id = LAST_INSERT_ID();
SELECT @minisa_whent_id := Id FROM Persons WHERE FirstName = 'Minisa' AND LastName = 'Whent' LIMIT 1;

-- Catelyn Stark (née Tully, épouse de Ned)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Catelyn', 'Stark', 'née Tully', '265-01-01', '299-01-01', 'Riverrun, The Riverlands', 'The Twins, The Riverlands', 'Female', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @catelyn_stark_id = LAST_INSERT_ID();
SELECT @catelyn_stark_id := Id FROM Persons WHERE FirstName = 'Catelyn' AND LastName = 'Stark' LIMIT 1;

-- Lysa Arryn (née Tully, sœur de Catelyn)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Lysa', 'Arryn', 'née Tully', '268-01-01', '300-01-01', 'Riverrun, The Riverlands', 'The Eyrie, The Vale', 'Female', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @lysa_arryn_id = LAST_INSERT_ID();
SELECT @lysa_arryn_id := Id FROM Persons WHERE FirstName = 'Lysa' AND LastName = 'Arryn' LIMIT 1;

-- Edmure Tully (frère de Catelyn)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Edmure', 'Tully', NULL, '273-01-01', 'Riverrun, The Riverlands', 'Male', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @edmure_tully_id = LAST_INSERT_ID();
SELECT @edmure_tully_id := Id FROM Persons WHERE FirstName = 'Edmure' AND LastName = 'Tully' LIMIT 1;

-- Relations parent-enfant (Hoster et Minisa sont parents de Catelyn, Lysa, Edmure)
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @hoster_tully_id, @catelyn_stark_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @hoster_tully_id AND Person2Id = @catelyn_stark_id AND RelationshipType = 1
) AND @hoster_tully_id IS NOT NULL AND @catelyn_stark_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @minisa_whent_id, @catelyn_stark_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @minisa_whent_id AND Person2Id = @catelyn_stark_id AND RelationshipType = 1
) AND @minisa_whent_id IS NOT NULL AND @catelyn_stark_id IS NOT NULL;

-- Relations siblings Tully
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @catelyn_stark_id, @lysa_arryn_id, 4, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @catelyn_stark_id AND Person2Id = @lysa_arryn_id) OR (Person1Id = @lysa_arryn_id AND Person2Id = @catelyn_stark_id)) AND RelationshipType = 4
) AND @catelyn_stark_id IS NOT NULL AND @lysa_arryn_id IS NOT NULL;

-- Mariage Ned et Catelyn
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, StartDate, CreatedAt)
SELECT @ned_stark_id, @catelyn_stark_id, 3, '284-01-01', NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @ned_stark_id AND Person2Id = @catelyn_stark_id) OR (Person1Id = @catelyn_stark_id AND Person2Id = @ned_stark_id)) AND RelationshipType = 3
) AND @ned_stark_id IS NOT NULL AND @catelyn_stark_id IS NOT NULL;

-- ============================================
-- ENFANTS DE NED ET CATELYN STARK
-- ============================================

-- Robb Stark
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Robb', 'Stark', 'The Young Wolf', '283-01-01', '299-01-01', 'Winterfell, The North', 'The Twins, The Riverlands', 'Male', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @robb_stark_id = LAST_INSERT_ID();
SELECT @robb_stark_id := Id FROM Persons WHERE FirstName = 'Robb' AND LastName = 'Stark' LIMIT 1;

-- Sansa Stark
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Sansa', 'Stark', NULL, '286-01-01', 'Winterfell, The North', 'Female', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @sansa_stark_id = LAST_INSERT_ID();
SELECT @sansa_stark_id := Id FROM Persons WHERE FirstName = 'Sansa' AND LastName = 'Stark' LIMIT 1;

-- Arya Stark
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Arya', 'Stark', NULL, '289-01-01', 'Winterfell, The North', 'Female', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @arya_stark_id = LAST_INSERT_ID();
SELECT @arya_stark_id := Id FROM Persons WHERE FirstName = 'Arya' AND LastName = 'Stark' LIMIT 1;

-- Bran Stark
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Brandon', 'Stark', 'Bran', '290-01-01', 'Winterfell, The North', 'Male', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @bran_stark_id = LAST_INSERT_ID();
SELECT @bran_stark_id := Id FROM Persons WHERE FirstName = 'Brandon' AND LastName = 'Stark' AND MiddleName = 'Bran' LIMIT 1;

-- Rickon Stark
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Rickon', 'Stark', NULL, '295-01-01', '305-01-01', 'Winterfell, The North', 'Winterfell, The North', 'Male', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @rickon_stark_id = LAST_INSERT_ID();
SELECT @rickon_stark_id := Id FROM Persons WHERE FirstName = 'Rickon' AND LastName = 'Stark' LIMIT 1;

-- Relations parent-enfant (Ned et Catelyn sont parents de tous les enfants Stark)
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @ned_stark_id, @robb_stark_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @ned_stark_id AND Person2Id = @robb_stark_id AND RelationshipType = 1
) AND @ned_stark_id IS NOT NULL AND @robb_stark_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @catelyn_stark_id, @robb_stark_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @catelyn_stark_id AND Person2Id = @robb_stark_id AND RelationshipType = 1
) AND @catelyn_stark_id IS NOT NULL AND @robb_stark_id IS NOT NULL;

-- Répéter pour tous les autres enfants...
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @ned_stark_id, @sansa_stark_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @ned_stark_id AND Person2Id = @sansa_stark_id AND RelationshipType = 1
) AND @ned_stark_id IS NOT NULL AND @sansa_stark_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @catelyn_stark_id, @sansa_stark_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @catelyn_stark_id AND Person2Id = @sansa_stark_id AND RelationshipType = 1
) AND @catelyn_stark_id IS NOT NULL AND @sansa_stark_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @ned_stark_id, @arya_stark_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @ned_stark_id AND Person2Id = @arya_stark_id AND RelationshipType = 1
) AND @ned_stark_id IS NOT NULL AND @arya_stark_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @catelyn_stark_id, @arya_stark_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @catelyn_stark_id AND Person2Id = @arya_stark_id AND RelationshipType = 1
) AND @catelyn_stark_id IS NOT NULL AND @arya_stark_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @ned_stark_id, @bran_stark_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @ned_stark_id AND Person2Id = @bran_stark_id AND RelationshipType = 1
) AND @ned_stark_id IS NOT NULL AND @bran_stark_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @catelyn_stark_id, @bran_stark_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @catelyn_stark_id AND Person2Id = @bran_stark_id AND RelationshipType = 1
) AND @catelyn_stark_id IS NOT NULL AND @bran_stark_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @ned_stark_id, @rickon_stark_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @ned_stark_id AND Person2Id = @rickon_stark_id AND RelationshipType = 1
) AND @ned_stark_id IS NOT NULL AND @rickon_stark_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @catelyn_stark_id, @rickon_stark_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @catelyn_stark_id AND Person2Id = @rickon_stark_id AND RelationshipType = 1
) AND @catelyn_stark_id IS NOT NULL AND @rickon_stark_id IS NOT NULL;

-- Relations siblings entre les enfants Stark
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @robb_stark_id, @sansa_stark_id, 4, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @robb_stark_id AND Person2Id = @sansa_stark_id) OR (Person1Id = @sansa_stark_id AND Person2Id = @robb_stark_id)) AND RelationshipType = 4
) AND @robb_stark_id IS NOT NULL AND @sansa_stark_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @robb_stark_id, @arya_stark_id, 4, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @robb_stark_id AND Person2Id = @arya_stark_id) OR (Person1Id = @arya_stark_id AND Person2Id = @robb_stark_id)) AND RelationshipType = 4
) AND @robb_stark_id IS NOT NULL AND @arya_stark_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @robb_stark_id, @bran_stark_id, 4, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @robb_stark_id AND Person2Id = @bran_stark_id) OR (Person1Id = @bran_stark_id AND Person2Id = @robb_stark_id)) AND RelationshipType = 4
) AND @robb_stark_id IS NOT NULL AND @bran_stark_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @robb_stark_id, @rickon_stark_id, 4, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @robb_stark_id AND Person2Id = @rickon_stark_id) OR (Person1Id = @rickon_stark_id AND Person2Id = @robb_stark_id)) AND RelationshipType = 4
) AND @robb_stark_id IS NOT NULL AND @rickon_stark_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @sansa_stark_id, @arya_stark_id, 4, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @sansa_stark_id AND Person2Id = @arya_stark_id) OR (Person1Id = @arya_stark_id AND Person2Id = @sansa_stark_id)) AND RelationshipType = 4
) AND @sansa_stark_id IS NOT NULL AND @arya_stark_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @sansa_stark_id, @bran_stark_id, 4, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @sansa_stark_id AND Person2Id = @bran_stark_id) OR (Person1Id = @bran_stark_id AND Person2Id = @sansa_stark_id)) AND RelationshipType = 4
) AND @sansa_stark_id IS NOT NULL AND @bran_stark_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @sansa_stark_id, @rickon_stark_id, 4, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @sansa_stark_id AND Person2Id = @rickon_stark_id) OR (Person1Id = @rickon_stark_id AND Person2Id = @sansa_stark_id)) AND RelationshipType = 4
) AND @sansa_stark_id IS NOT NULL AND @rickon_stark_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @arya_stark_id, @bran_stark_id, 4, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @arya_stark_id AND Person2Id = @bran_stark_id) OR (Person1Id = @bran_stark_id AND Person2Id = @arya_stark_id)) AND RelationshipType = 4
) AND @arya_stark_id IS NOT NULL AND @bran_stark_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @arya_stark_id, @rickon_stark_id, 4, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @arya_stark_id AND Person2Id = @rickon_stark_id) OR (Person1Id = @rickon_stark_id AND Person2Id = @arya_stark_id)) AND RelationshipType = 4
) AND @arya_stark_id IS NOT NULL AND @rickon_stark_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @bran_stark_id, @rickon_stark_id, 4, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @bran_stark_id AND Person2Id = @rickon_stark_id) OR (Person1Id = @rickon_stark_id AND Person2Id = @bran_stark_id)) AND RelationshipType = 4
) AND @bran_stark_id IS NOT NULL AND @rickon_stark_id IS NOT NULL;

-- ============================================
-- FAMILLE LANNISTER (Casterly Rock)
-- ============================================

-- Tytos Lannister (père de Tywin)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Tytos', 'Lannister', NULL, '220-01-01', '267-01-01', 'Casterly Rock, The Westerlands', 'Casterly Rock, The Westerlands', 'Male', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @tytos_lannister_id = LAST_INSERT_ID();
SELECT @tytos_lannister_id := Id FROM Persons WHERE FirstName = 'Tytos' AND LastName = 'Lannister' LIMIT 1;

-- Jeyne Marbrand (mère de Tywin)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Jeyne', 'Marbrand', NULL, '225-01-01', '260-01-01', 'Ashemark, The Westerlands', 'Casterly Rock, The Westerlands', 'Female', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @jeyne_marbrand_id = LAST_INSERT_ID();
SELECT @jeyne_marbrand_id := Id FROM Persons WHERE FirstName = 'Jeyne' AND LastName = 'Marbrand' LIMIT 1;

-- Tywin Lannister
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Tywin', 'Lannister', NULL, '242-01-01', '300-01-01', 'Casterly Rock, The Westerlands', 'King\'s Landing', 'Male', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @tywin_lannister_id = LAST_INSERT_ID();
SELECT @tywin_lannister_id := Id FROM Persons WHERE FirstName = 'Tywin' AND LastName = 'Lannister' LIMIT 1;

-- Joanna Lannister (née Lannister, épouse de Tywin, cousine)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Joanna', 'Lannister', NULL, '245-01-01', '273-01-01', 'Casterly Rock, The Westerlands', 'Casterly Rock, The Westerlands', 'Female', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @joanna_lannister_id = LAST_INSERT_ID();
SELECT @joanna_lannister_id := Id FROM Persons WHERE FirstName = 'Joanna' AND LastName = 'Lannister' LIMIT 1;

-- Relations parent-enfant (Tytos et Jeyne sont parents de Tywin)
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @tytos_lannister_id, @tywin_lannister_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @tytos_lannister_id AND Person2Id = @tywin_lannister_id AND RelationshipType = 1
) AND @tytos_lannister_id IS NOT NULL AND @tywin_lannister_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @jeyne_marbrand_id, @tywin_lannister_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @jeyne_marbrand_id AND Person2Id = @tywin_lannister_id AND RelationshipType = 1
) AND @jeyne_marbrand_id IS NOT NULL AND @tywin_lannister_id IS NOT NULL;

-- Mariage Tywin et Joanna
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, StartDate, CreatedAt)
SELECT @tywin_lannister_id, @joanna_lannister_id, 3, '262-01-01', NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @tywin_lannister_id AND Person2Id = @joanna_lannister_id) OR (Person1Id = @joanna_lannister_id AND Person2Id = @tywin_lannister_id)) AND RelationshipType = 3
) AND @tywin_lannister_id IS NOT NULL AND @joanna_lannister_id IS NOT NULL;

-- Cersei Lannister
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Cersei', 'Lannister', NULL, '266-01-01', '305-01-01', 'Casterly Rock, The Westerlands', 'King\'s Landing', 'Female', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @cersei_lannister_id = LAST_INSERT_ID();
SELECT @cersei_lannister_id := Id FROM Persons WHERE FirstName = 'Cersei' AND LastName = 'Lannister' LIMIT 1;

-- Jaime Lannister (date modifiée pour tester - était '266-01-01' comme Cersei)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Jaime', 'Lannister', 'Kingslayer', '267-01-01', 'Casterly Rock, The Westerlands', 'Male', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE BirthDate = '267-01-01', UpdatedAt = NOW();

SET @jaime_lannister_id = LAST_INSERT_ID();
SELECT @jaime_lannister_id := Id FROM Persons WHERE FirstName = 'Jaime' AND LastName = 'Lannister' LIMIT 1;

-- Tyrion Lannister
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Tyrion', 'Lannister', 'The Imp', '273-01-01', 'Casterly Rock, The Westerlands', 'Male', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @tyrion_lannister_id = LAST_INSERT_ID();
SELECT @tyrion_lannister_id := Id FROM Persons WHERE FirstName = 'Tyrion' AND LastName = 'Lannister' LIMIT 1;

-- Relations parent-enfant (Tywin et Joanna sont parents de Cersei, Jaime, Tyrion)
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @tywin_lannister_id, @cersei_lannister_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @tywin_lannister_id AND Person2Id = @cersei_lannister_id AND RelationshipType = 1
) AND @tywin_lannister_id IS NOT NULL AND @cersei_lannister_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @joanna_lannister_id, @cersei_lannister_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @joanna_lannister_id AND Person2Id = @cersei_lannister_id AND RelationshipType = 1
) AND @joanna_lannister_id IS NOT NULL AND @cersei_lannister_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @tywin_lannister_id, @jaime_lannister_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @tywin_lannister_id AND Person2Id = @jaime_lannister_id AND RelationshipType = 1
) AND @tywin_lannister_id IS NOT NULL AND @jaime_lannister_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @joanna_lannister_id, @jaime_lannister_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @joanna_lannister_id AND Person2Id = @jaime_lannister_id AND RelationshipType = 1
) AND @joanna_lannister_id IS NOT NULL AND @jaime_lannister_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @tywin_lannister_id, @tyrion_lannister_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @tywin_lannister_id AND Person2Id = @tyrion_lannister_id AND RelationshipType = 1
) AND @tywin_lannister_id IS NOT NULL AND @tyrion_lannister_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @joanna_lannister_id, @tyrion_lannister_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @joanna_lannister_id AND Person2Id = @tyrion_lannister_id AND RelationshipType = 1
) AND @joanna_lannister_id IS NOT NULL AND @tyrion_lannister_id IS NOT NULL;

-- Relations siblings Lannister
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @cersei_lannister_id, @jaime_lannister_id, 4, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @cersei_lannister_id AND Person2Id = @jaime_lannister_id) OR (Person1Id = @jaime_lannister_id AND Person2Id = @cersei_lannister_id)) AND RelationshipType = 4
) AND @cersei_lannister_id IS NOT NULL AND @jaime_lannister_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @cersei_lannister_id, @tyrion_lannister_id, 4, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @cersei_lannister_id AND Person2Id = @tyrion_lannister_id) OR (Person1Id = @tyrion_lannister_id AND Person2Id = @cersei_lannister_id)) AND RelationshipType = 4
) AND @cersei_lannister_id IS NOT NULL AND @tyrion_lannister_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @jaime_lannister_id, @tyrion_lannister_id, 4, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @jaime_lannister_id AND Person2Id = @tyrion_lannister_id) OR (Person1Id = @tyrion_lannister_id AND Person2Id = @jaime_lannister_id)) AND RelationshipType = 4
) AND @jaime_lannister_id IS NOT NULL AND @tyrion_lannister_id IS NOT NULL;

-- ============================================
-- FAMILLE BARATHEON (Storm's End)
-- ============================================

-- Steffon Baratheon (père de Robert, Stannis, Renly)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Steffon', 'Baratheon', NULL, '246-01-01', '278-01-01', 'Storm\'s End, The Stormlands', 'Shipbreaker Bay', 'Male', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @steffon_baratheon_id = LAST_INSERT_ID();
SELECT @steffon_baratheon_id := Id FROM Persons WHERE FirstName = 'Steffon' AND LastName = 'Baratheon' LIMIT 1;

-- Cassana Estermont (mère de Robert, Stannis, Renly)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Cassana', 'Estermont', NULL, '250-01-01', '278-01-01', 'Greenstone, The Stormlands', 'Shipbreaker Bay', 'Female', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @cassana_estermont_id = LAST_INSERT_ID();
SELECT @cassana_estermont_id := Id FROM Persons WHERE FirstName = 'Cassana' AND LastName = 'Estermont' LIMIT 1;

-- Robert Baratheon
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Robert', 'Baratheon', NULL, '262-01-01', '298-01-01', 'Storm\'s End, The Stormlands', 'King\'s Landing', 'Male', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @robert_baratheon_id = LAST_INSERT_ID();
SELECT @robert_baratheon_id := Id FROM Persons WHERE FirstName = 'Robert' AND LastName = 'Baratheon' LIMIT 1;

-- Stannis Baratheon
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Stannis', 'Baratheon', NULL, '264-01-01', '302-01-01', 'Storm\'s End, The Stormlands', 'Winterfell, The North', 'Male', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @stannis_baratheon_id = LAST_INSERT_ID();
SELECT @stannis_baratheon_id := Id FROM Persons WHERE FirstName = 'Stannis' AND LastName = 'Baratheon' LIMIT 1;

-- Renly Baratheon
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Renly', 'Baratheon', NULL, '277-01-01', '299-01-01', 'Storm\'s End, The Stormlands', 'Storm\'s End, The Stormlands', 'Male', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @renly_baratheon_id = LAST_INSERT_ID();
SELECT @renly_baratheon_id := Id FROM Persons WHERE FirstName = 'Renly' AND LastName = 'Baratheon' LIMIT 1;

-- Relations parent-enfant (Steffon et Cassana sont parents de Robert, Stannis, Renly)
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @steffon_baratheon_id, @robert_baratheon_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @steffon_baratheon_id AND Person2Id = @robert_baratheon_id AND RelationshipType = 1
) AND @steffon_baratheon_id IS NOT NULL AND @robert_baratheon_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @cassana_estermont_id, @robert_baratheon_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @cassana_estermont_id AND Person2Id = @robert_baratheon_id AND RelationshipType = 1
) AND @cassana_estermont_id IS NOT NULL AND @robert_baratheon_id IS NOT NULL;

-- Répéter pour Stannis et Renly...
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @steffon_baratheon_id, @stannis_baratheon_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @steffon_baratheon_id AND Person2Id = @stannis_baratheon_id AND RelationshipType = 1
) AND @steffon_baratheon_id IS NOT NULL AND @stannis_baratheon_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @cassana_estermont_id, @stannis_baratheon_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @cassana_estermont_id AND Person2Id = @stannis_baratheon_id AND RelationshipType = 1
) AND @cassana_estermont_id IS NOT NULL AND @stannis_baratheon_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @steffon_baratheon_id, @renly_baratheon_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @steffon_baratheon_id AND Person2Id = @renly_baratheon_id AND RelationshipType = 1
) AND @steffon_baratheon_id IS NOT NULL AND @renly_baratheon_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @cassana_estermont_id, @renly_baratheon_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @cassana_estermont_id AND Person2Id = @renly_baratheon_id AND RelationshipType = 1
) AND @cassana_estermont_id IS NOT NULL AND @renly_baratheon_id IS NOT NULL;

-- Relations siblings Baratheon
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @robert_baratheon_id, @stannis_baratheon_id, 4, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @robert_baratheon_id AND Person2Id = @stannis_baratheon_id) OR (Person1Id = @stannis_baratheon_id AND Person2Id = @robert_baratheon_id)) AND RelationshipType = 4
) AND @robert_baratheon_id IS NOT NULL AND @stannis_baratheon_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @robert_baratheon_id, @renly_baratheon_id, 4, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @robert_baratheon_id AND Person2Id = @renly_baratheon_id) OR (Person1Id = @renly_baratheon_id AND Person2Id = @robert_baratheon_id)) AND RelationshipType = 4
) AND @robert_baratheon_id IS NOT NULL AND @renly_baratheon_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @stannis_baratheon_id, @renly_baratheon_id, 4, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @stannis_baratheon_id AND Person2Id = @renly_baratheon_id) OR (Person1Id = @renly_baratheon_id AND Person2Id = @stannis_baratheon_id)) AND RelationshipType = 4
) AND @stannis_baratheon_id IS NOT NULL AND @renly_baratheon_id IS NOT NULL;

-- Mariage Robert et Cersei
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, StartDate, CreatedAt)
SELECT @robert_baratheon_id, @cersei_lannister_id, 3, '284-01-01', NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @robert_baratheon_id AND Person2Id = @cersei_lannister_id) OR (Person1Id = @cersei_lannister_id AND Person2Id = @robert_baratheon_id)) AND RelationshipType = 3
) AND @robert_baratheon_id IS NOT NULL AND @cersei_lannister_id IS NOT NULL;

-- ============================================
-- ENFANTS DE ROBERT ET CERSEI (Baratheon)
-- ============================================

-- Joffrey Baratheon
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Joffrey', 'Baratheon', NULL, '286-01-01', '300-01-01', 'King\'s Landing', 'King\'s Landing', 'Male', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @joffrey_baratheon_id = LAST_INSERT_ID();
SELECT @joffrey_baratheon_id := Id FROM Persons WHERE FirstName = 'Joffrey' AND LastName = 'Baratheon' LIMIT 1;

-- Myrcella Baratheon
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Myrcella', 'Baratheon', NULL, '290-01-01', '302-01-01', 'King\'s Landing', 'Dorne', 'Female', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @myrcella_baratheon_id = LAST_INSERT_ID();
SELECT @myrcella_baratheon_id := Id FROM Persons WHERE FirstName = 'Myrcella' AND LastName = 'Baratheon' LIMIT 1;

-- Tommen Baratheon
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Tommen', 'Baratheon', NULL, '291-01-01', '303-01-01', 'King\'s Landing', 'King\'s Landing', 'Male', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @tommen_baratheon_id = LAST_INSERT_ID();
SELECT @tommen_baratheon_id := Id FROM Persons WHERE FirstName = 'Tommen' AND LastName = 'Baratheon' LIMIT 1;

-- Relations parent-enfant (Robert et Cersei sont parents de Joffrey, Myrcella, Tommen)
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @robert_baratheon_id, @joffrey_baratheon_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @robert_baratheon_id AND Person2Id = @joffrey_baratheon_id AND RelationshipType = 1
) AND @robert_baratheon_id IS NOT NULL AND @joffrey_baratheon_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @cersei_lannister_id, @joffrey_baratheon_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @cersei_lannister_id AND Person2Id = @joffrey_baratheon_id AND RelationshipType = 1
) AND @cersei_lannister_id IS NOT NULL AND @joffrey_baratheon_id IS NOT NULL;

-- Répéter pour Myrcella et Tommen...
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @robert_baratheon_id, @myrcella_baratheon_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @robert_baratheon_id AND Person2Id = @myrcella_baratheon_id AND RelationshipType = 1
) AND @robert_baratheon_id IS NOT NULL AND @myrcella_baratheon_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @cersei_lannister_id, @myrcella_baratheon_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @cersei_lannister_id AND Person2Id = @myrcella_baratheon_id AND RelationshipType = 1
) AND @cersei_lannister_id IS NOT NULL AND @myrcella_baratheon_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @robert_baratheon_id, @tommen_baratheon_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @robert_baratheon_id AND Person2Id = @tommen_baratheon_id AND RelationshipType = 1
) AND @robert_baratheon_id IS NOT NULL AND @tommen_baratheon_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @cersei_lannister_id, @tommen_baratheon_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @cersei_lannister_id AND Person2Id = @tommen_baratheon_id AND RelationshipType = 1
) AND @cersei_lannister_id IS NOT NULL AND @tommen_baratheon_id IS NOT NULL;

-- Relations siblings Baratheon (enfants)
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @joffrey_baratheon_id, @myrcella_baratheon_id, 4, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @joffrey_baratheon_id AND Person2Id = @myrcella_baratheon_id) OR (Person1Id = @myrcella_baratheon_id AND Person2Id = @joffrey_baratheon_id)) AND RelationshipType = 4
) AND @joffrey_baratheon_id IS NOT NULL AND @myrcella_baratheon_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @joffrey_baratheon_id, @tommen_baratheon_id, 4, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @joffrey_baratheon_id AND Person2Id = @tommen_baratheon_id) OR (Person1Id = @tommen_baratheon_id AND Person2Id = @joffrey_baratheon_id)) AND RelationshipType = 4
) AND @joffrey_baratheon_id IS NOT NULL AND @tommen_baratheon_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @myrcella_baratheon_id, @tommen_baratheon_id, 4, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @myrcella_baratheon_id AND Person2Id = @tommen_baratheon_id) OR (Person1Id = @tommen_baratheon_id AND Person2Id = @myrcella_baratheon_id)) AND RelationshipType = 4
) AND @myrcella_baratheon_id IS NOT NULL AND @tommen_baratheon_id IS NOT NULL;

-- ============================================
-- FAMILLE TARGARYEN (Dragonstone)
-- ============================================

-- Aerys II Targaryen "The Mad King"
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Aerys', 'Targaryen', 'II The Mad King', '244-01-01', '283-01-01', 'King\'s Landing', 'King\'s Landing', 'Male', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @aerys_targaryen_id = LAST_INSERT_ID();
SELECT @aerys_targaryen_id := Id FROM Persons WHERE FirstName = 'Aerys' AND LastName = 'Targaryen' LIMIT 1;

-- Rhaella Targaryen (sœur et épouse d'Aerys)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Rhaella', 'Targaryen', NULL, '245-01-01', '284-01-01', 'King\'s Landing', 'Dragonstone', 'Female', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @rhaella_targaryen_id = LAST_INSERT_ID();
SELECT @rhaella_targaryen_id := Id FROM Persons WHERE FirstName = 'Rhaella' AND LastName = 'Targaryen' LIMIT 1;

-- Rhaegar Targaryen (fils aîné d'Aerys et Rhaella)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Rhaegar', 'Targaryen', NULL, '259-01-01', '283-01-01', 'King\'s Landing', 'Trident, The Riverlands', 'Male', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @rhaegar_targaryen_id = LAST_INSERT_ID();
SELECT @rhaegar_targaryen_id := Id FROM Persons WHERE FirstName = 'Rhaegar' AND LastName = 'Targaryen' LIMIT 1;

-- Viserys Targaryen
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Viserys', 'Targaryen', NULL, '276-01-01', '298-01-01', 'Dragonstone', 'Vaes Dothrak', 'Male', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @viserys_targaryen_id = LAST_INSERT_ID();
SELECT @viserys_targaryen_id := Id FROM Persons WHERE FirstName = 'Viserys' AND LastName = 'Targaryen' LIMIT 1;

-- Daenerys Targaryen
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Daenerys', 'Targaryen', 'Stormborn', '284-01-01', '305-01-01', 'Dragonstone', 'King\'s Landing', 'Female', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @daenerys_targaryen_id = LAST_INSERT_ID();
SELECT @daenerys_targaryen_id := Id FROM Persons WHERE FirstName = 'Daenerys' AND LastName = 'Targaryen' LIMIT 1;

-- Relations parent-enfant (Aerys et Rhaella sont parents de Rhaegar, Viserys, Daenerys)
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @aerys_targaryen_id, @rhaegar_targaryen_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @aerys_targaryen_id AND Person2Id = @rhaegar_targaryen_id AND RelationshipType = 1
) AND @aerys_targaryen_id IS NOT NULL AND @rhaegar_targaryen_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @rhaella_targaryen_id, @rhaegar_targaryen_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @rhaella_targaryen_id AND Person2Id = @rhaegar_targaryen_id AND RelationshipType = 1
) AND @rhaella_targaryen_id IS NOT NULL AND @rhaegar_targaryen_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @aerys_targaryen_id, @viserys_targaryen_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @aerys_targaryen_id AND Person2Id = @viserys_targaryen_id AND RelationshipType = 1
) AND @aerys_targaryen_id IS NOT NULL AND @viserys_targaryen_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @rhaella_targaryen_id, @viserys_targaryen_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @rhaella_targaryen_id AND Person2Id = @viserys_targaryen_id AND RelationshipType = 1
) AND @rhaella_targaryen_id IS NOT NULL AND @viserys_targaryen_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @aerys_targaryen_id, @daenerys_targaryen_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @aerys_targaryen_id AND Person2Id = @daenerys_targaryen_id AND RelationshipType = 1
) AND @aerys_targaryen_id IS NOT NULL AND @daenerys_targaryen_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @rhaella_targaryen_id, @daenerys_targaryen_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @rhaella_targaryen_id AND Person2Id = @daenerys_targaryen_id AND RelationshipType = 1
) AND @rhaella_targaryen_id IS NOT NULL AND @daenerys_targaryen_id IS NOT NULL;

-- Relations siblings Targaryen
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @rhaegar_targaryen_id, @viserys_targaryen_id, 4, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @rhaegar_targaryen_id AND Person2Id = @viserys_targaryen_id) OR (Person1Id = @viserys_targaryen_id AND Person2Id = @rhaegar_targaryen_id)) AND RelationshipType = 4
) AND @rhaegar_targaryen_id IS NOT NULL AND @viserys_targaryen_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @rhaegar_targaryen_id, @daenerys_targaryen_id, 4, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @rhaegar_targaryen_id AND Person2Id = @daenerys_targaryen_id) OR (Person1Id = @daenerys_targaryen_id AND Person2Id = @rhaegar_targaryen_id)) AND RelationshipType = 4
) AND @rhaegar_targaryen_id IS NOT NULL AND @daenerys_targaryen_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @viserys_targaryen_id, @daenerys_targaryen_id, 4, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @viserys_targaryen_id AND Person2Id = @daenerys_targaryen_id) OR (Person1Id = @daenerys_targaryen_id AND Person2Id = @viserys_targaryen_id)) AND RelationshipType = 4
) AND @viserys_targaryen_id IS NOT NULL AND @daenerys_targaryen_id IS NOT NULL;

-- Mariage Aerys et Rhaella
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, StartDate, CreatedAt)
SELECT @aerys_targaryen_id, @rhaella_targaryen_id, 3, '260-01-01', NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @aerys_targaryen_id AND Person2Id = @rhaella_targaryen_id) OR (Person1Id = @rhaella_targaryen_id AND Person2Id = @aerys_targaryen_id)) AND RelationshipType = 3
) AND @aerys_targaryen_id IS NOT NULL AND @rhaella_targaryen_id IS NOT NULL;

-- ============================================
-- RELATION IMPORTANTE : Rhaegar et Lyanna
-- ============================================

-- Mariage Rhaegar et Lyanna (relation secrète)
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, StartDate, CreatedAt)
SELECT @rhaegar_targaryen_id, @lyanna_stark_id, 3, '282-01-01', NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @rhaegar_targaryen_id AND Person2Id = @lyanna_stark_id) OR (Person1Id = @lyanna_stark_id AND Person2Id = @rhaegar_targaryen_id)) AND RelationshipType = 3
) AND @rhaegar_targaryen_id IS NOT NULL AND @lyanna_stark_id IS NOT NULL;

-- Jon Snow (fils de Rhaegar et Lyanna)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Jon', 'Snow', 'Aegon Targaryen', '283-01-01', 'Tower of Joy, Dorne', 'Male', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @jon_snow_id = LAST_INSERT_ID();
SELECT @jon_snow_id := Id FROM Persons WHERE FirstName = 'Jon' AND LastName = 'Snow' LIMIT 1;

-- Relations parent-enfant (Rhaegar et Lyanna sont parents de Jon)
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @rhaegar_targaryen_id, @jon_snow_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @rhaegar_targaryen_id AND Person2Id = @jon_snow_id AND RelationshipType = 1
) AND @rhaegar_targaryen_id IS NOT NULL AND @jon_snow_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @lyanna_stark_id, @jon_snow_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @lyanna_stark_id AND Person2Id = @jon_snow_id AND RelationshipType = 1
) AND @lyanna_stark_id IS NOT NULL AND @jon_snow_id IS NOT NULL;

-- ============================================
-- MESSAGE DE CONFIRMATION
-- ============================================

SELECT 'Personnages de Game of Thrones ajoutés avec succès!' AS result;
SELECT COUNT(*) AS total_personnes FROM Persons WHERE LastName IN ('Stark', 'Lannister', 'Targaryen', 'Baratheon', 'Tully', 'Arryn');
SELECT COUNT(*) AS total_relations FROM Relationships;
