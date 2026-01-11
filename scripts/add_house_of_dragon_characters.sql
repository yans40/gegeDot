-- ============================================
-- Ajouter les personnages de House of the Dragon
-- ============================================
-- Ce script ajoute les personnages principaux de House of the Dragon
-- qui se déroule environ 200 ans avant Game of Thrones
-- 
-- Pour exécuter ce script :
-- mysql -u root -p gegeDot < scripts/add_house_of_dragon_characters.sql
-- ou depuis MySQL :
-- source scripts/add_house_of_dragon_characters.sql;
-- ============================================

USE gegeDot;

-- ============================================
-- GÉNÉRATION TARGARYEN (House of the Dragon)
-- ============================================

-- Jaehaerys I Targaryen "The Old King" (grand-père de Viserys I)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Jaehaerys', 'Targaryen', 'I The Old King', '1034-01-01', '1103-01-01', 'King\'s Landing', 'King\'s Landing', 'Male', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @jaehaerys_i_id = LAST_INSERT_ID();
SELECT @jaehaerys_i_id := Id FROM Persons WHERE FirstName = 'Jaehaerys' AND LastName = 'Targaryen' AND MiddleName = 'I The Old King' LIMIT 1;

-- Alysanne Targaryen (épouse de Jaehaerys I)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Alysanne', 'Targaryen', NULL, '1036-01-01', '1100-01-01', 'King\'s Landing', 'King\'s Landing', 'Female', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @alysanne_targaryen_id = LAST_INSERT_ID();
SELECT @alysanne_targaryen_id := Id FROM Persons WHERE FirstName = 'Alysanne' AND LastName = 'Targaryen' LIMIT 1;

-- Baelon Targaryen "The Spring Prince" (fils de Jaehaerys, père de Viserys I)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Baelon', 'Targaryen', 'The Spring Prince', '1061-01-01', '1101-01-01', 'King\'s Landing', 'King\'s Landing', 'Male', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @baelon_targaryen_id = LAST_INSERT_ID();
SELECT @baelon_targaryen_id := Id FROM Persons WHERE FirstName = 'Baelon' AND LastName = 'Targaryen' LIMIT 1;

-- Alyssa Targaryen (épouse de Baelon)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Alyssa', 'Targaryen', NULL, '1060-01-01', '1084-01-01', 'King\'s Landing', 'Dragonstone', 'Female', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @alyssa_targaryen_id = LAST_INSERT_ID();
SELECT @alyssa_targaryen_id := Id FROM Persons WHERE FirstName = 'Alyssa' AND LastName = 'Targaryen' LIMIT 1;

-- Relations parent-enfant (Jaehaerys et Alysanne sont parents de Baelon)
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @jaehaerys_i_id, @baelon_targaryen_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @jaehaerys_i_id AND Person2Id = @baelon_targaryen_id AND RelationshipType = 1
) AND @jaehaerys_i_id IS NOT NULL AND @baelon_targaryen_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @alysanne_targaryen_id, @baelon_targaryen_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @alysanne_targaryen_id AND Person2Id = @baelon_targaryen_id AND RelationshipType = 1
) AND @alysanne_targaryen_id IS NOT NULL AND @baelon_targaryen_id IS NOT NULL;

-- Mariage Jaehaerys et Alysanne
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, StartDate, CreatedAt)
SELECT @jaehaerys_i_id, @alysanne_targaryen_id, 3, '1050-01-01', NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @jaehaerys_i_id AND Person2Id = @alysanne_targaryen_id) OR (Person1Id = @alysanne_targaryen_id AND Person2Id = @jaehaerys_i_id)) AND RelationshipType = 3
) AND @jaehaerys_i_id IS NOT NULL AND @alysanne_targaryen_id IS NOT NULL;

-- Mariage Baelon et Alyssa
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, StartDate, CreatedAt)
SELECT @baelon_targaryen_id, @alyssa_targaryen_id, 3, '1075-01-01', NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @baelon_targaryen_id AND Person2Id = @alyssa_targaryen_id) OR (Person1Id = @alyssa_targaryen_id AND Person2Id = @baelon_targaryen_id)) AND RelationshipType = 3
) AND @baelon_targaryen_id IS NOT NULL AND @alyssa_targaryen_id IS NOT NULL;

-- ============================================
-- VISERYS I TARGARYEN ET SA FAMILLE
-- ============================================

-- Viserys I Targaryen
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Viserys', 'Targaryen', 'I', '1077-01-01', '1129-01-01', 'King\'s Landing', 'King\'s Landing', 'Male', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @viserys_i_id = LAST_INSERT_ID();
SELECT @viserys_i_id := Id FROM Persons WHERE FirstName = 'Viserys' AND LastName = 'Targaryen' AND MiddleName = 'I' LIMIT 1;

-- Daemon Targaryen (frère de Viserys I)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Daemon', 'Targaryen', 'The Rogue Prince', '1081-01-01', '1130-01-01', 'King\'s Landing', 'Gods Eye, The Riverlands', 'Male', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @daemon_targaryen_id = LAST_INSERT_ID();
SELECT @daemon_targaryen_id := Id FROM Persons WHERE FirstName = 'Daemon' AND LastName = 'Targaryen' AND MiddleName = 'The Rogue Prince' LIMIT 1;

-- Relations parent-enfant (Baelon et Alyssa sont parents de Viserys I et Daemon)
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @baelon_targaryen_id, @viserys_i_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @baelon_targaryen_id AND Person2Id = @viserys_i_id AND RelationshipType = 1
) AND @baelon_targaryen_id IS NOT NULL AND @viserys_i_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @alyssa_targaryen_id, @viserys_i_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @alyssa_targaryen_id AND Person2Id = @viserys_i_id AND RelationshipType = 1
) AND @alyssa_targaryen_id IS NOT NULL AND @viserys_i_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @baelon_targaryen_id, @daemon_targaryen_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @baelon_targaryen_id AND Person2Id = @daemon_targaryen_id AND RelationshipType = 1
) AND @baelon_targaryen_id IS NOT NULL AND @daemon_targaryen_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @alyssa_targaryen_id, @daemon_targaryen_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @alyssa_targaryen_id AND Person2Id = @daemon_targaryen_id AND RelationshipType = 1
) AND @alyssa_targaryen_id IS NOT NULL AND @daemon_targaryen_id IS NOT NULL;

-- Relation sibling entre Viserys I et Daemon
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @viserys_i_id, @daemon_targaryen_id, 4, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @viserys_i_id AND Person2Id = @daemon_targaryen_id) OR (Person1Id = @daemon_targaryen_id AND Person2Id = @viserys_i_id)) AND RelationshipType = 4
) AND @viserys_i_id IS NOT NULL AND @daemon_targaryen_id IS NOT NULL;

-- ============================================
-- ÉPOUSES DE VISERYS I
-- ============================================

-- Aemma Arryn (première épouse de Viserys I)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Aemma', 'Arryn', NULL, '1082-01-01', '1105-01-01', 'The Eyrie, The Vale', 'King\'s Landing', 'Female', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @aemma_arryn_id = LAST_INSERT_ID();
SELECT @aemma_arryn_id := Id FROM Persons WHERE FirstName = 'Aemma' AND LastName = 'Arryn' LIMIT 1;

-- Alicent Hightower (seconde épouse de Viserys I)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Alicent', 'Hightower', NULL, '1088-01-01', '1135-01-01', 'Oldtown, The Reach', 'King\'s Landing', 'Female', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @alicent_hightower_id = LAST_INSERT_ID();
SELECT @alicent_hightower_id := Id FROM Persons WHERE FirstName = 'Alicent' AND LastName = 'Hightower' LIMIT 1;

-- Mariages de Viserys I
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, StartDate, EndDate, CreatedAt)
SELECT @viserys_i_id, @aemma_arryn_id, 3, '1093-01-01', '1105-01-01', NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @viserys_i_id AND Person2Id = @aemma_arryn_id) OR (Person1Id = @aemma_arryn_id AND Person2Id = @viserys_i_id)) AND RelationshipType = 3
) AND @viserys_i_id IS NOT NULL AND @aemma_arryn_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, StartDate, CreatedAt)
SELECT @viserys_i_id, @alicent_hightower_id, 3, '106-01-01', NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @viserys_i_id AND Person2Id = @alicent_hightower_id) OR (Person1Id = @alicent_hightower_id AND Person2Id = @viserys_i_id)) AND RelationshipType = 3
) AND @viserys_i_id IS NOT NULL AND @alicent_hightower_id IS NOT NULL;

-- ============================================
-- ENFANTS DE VISERYS I ET AEMMA ARRYN
-- ============================================

-- Rhaenyra Targaryen "The Realm's Delight"
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Rhaenyra', 'Targaryen', 'The Realm\'s Delight', '1097-01-01', '130-01-01', 'King\'s Landing', 'Dragonstone', 'Female', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @rhaenyra_targaryen_id = LAST_INSERT_ID();
SELECT @rhaenyra_targaryen_id := Id FROM Persons WHERE FirstName = 'Rhaenyra' AND LastName = 'Targaryen' LIMIT 1;

-- Relations parent-enfant (Viserys I et Aemma sont parents de Rhaenyra)
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @viserys_i_id, @rhaenyra_targaryen_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @viserys_i_id AND Person2Id = @rhaenyra_targaryen_id AND RelationshipType = 1
) AND @viserys_i_id IS NOT NULL AND @rhaenyra_targaryen_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @aemma_arryn_id, @rhaenyra_targaryen_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @aemma_arryn_id AND Person2Id = @rhaenyra_targaryen_id AND RelationshipType = 1
) AND @aemma_arryn_id IS NOT NULL AND @rhaenyra_targaryen_id IS NOT NULL;

-- ============================================
-- ENFANTS DE VISERYS I ET ALICENT HIGHTOWER
-- ============================================

-- Aegon II Targaryen
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Aegon', 'Targaryen', 'II', '107-01-01', '131-01-01', 'King\'s Landing', 'King\'s Landing', 'Male', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @aegon_ii_id = LAST_INSERT_ID();
SELECT @aegon_ii_id := Id FROM Persons WHERE FirstName = 'Aegon' AND LastName = 'Targaryen' AND MiddleName = 'II' LIMIT 1;

-- Helaena Targaryen
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Helaena', 'Targaryen', NULL, '109-01-01', '130-01-01', 'King\'s Landing', 'King\'s Landing', 'Female', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @helaena_targaryen_id = LAST_INSERT_ID();
SELECT @helaena_targaryen_id := Id FROM Persons WHERE FirstName = 'Helaena' AND LastName = 'Targaryen' LIMIT 1;

-- Aemond Targaryen "One-Eye"
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Aemond', 'Targaryen', 'One-Eye', '110-01-01', '130-01-01', 'King\'s Landing', 'Gods Eye, The Riverlands', 'Male', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @aemond_targaryen_id = LAST_INSERT_ID();
SELECT @aemond_targaryen_id := Id FROM Persons WHERE FirstName = 'Aemond' AND LastName = 'Targaryen' LIMIT 1;

-- Daeron Targaryen
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Daeron', 'Targaryen', NULL, '114-01-01', '130-01-01', 'King\'s Landing', 'Tumbleton, The Reach', 'Male', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @daeron_targaryen_id = LAST_INSERT_ID();
SELECT @daeron_targaryen_id := Id FROM Persons WHERE FirstName = 'Daeron' AND LastName = 'Targaryen' AND BirthDate = '114-01-01' LIMIT 1;

-- Relations parent-enfant (Viserys I et Alicent sont parents de Aegon II, Helaena, Aemond, Daeron)
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @viserys_i_id, @aegon_ii_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @viserys_i_id AND Person2Id = @aegon_ii_id AND RelationshipType = 1
) AND @viserys_i_id IS NOT NULL AND @aegon_ii_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @alicent_hightower_id, @aegon_ii_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @alicent_hightower_id AND Person2Id = @aegon_ii_id AND RelationshipType = 1
) AND @alicent_hightower_id IS NOT NULL AND @aegon_ii_id IS NOT NULL;

-- Répéter pour Helaena, Aemond, Daeron...
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @viserys_i_id, @helaena_targaryen_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @viserys_i_id AND Person2Id = @helaena_targaryen_id AND RelationshipType = 1
) AND @viserys_i_id IS NOT NULL AND @helaena_targaryen_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @alicent_hightower_id, @helaena_targaryen_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @alicent_hightower_id AND Person2Id = @helaena_targaryen_id AND RelationshipType = 1
) AND @alicent_hightower_id IS NOT NULL AND @helaena_targaryen_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @viserys_i_id, @aemond_targaryen_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @viserys_i_id AND Person2Id = @aemond_targaryen_id AND RelationshipType = 1
) AND @viserys_i_id IS NOT NULL AND @aemond_targaryen_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @alicent_hightower_id, @aemond_targaryen_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @alicent_hightower_id AND Person2Id = @aemond_targaryen_id AND RelationshipType = 1
) AND @alicent_hightower_id IS NOT NULL AND @aemond_targaryen_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @viserys_i_id, @daeron_targaryen_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @viserys_i_id AND Person2Id = @daeron_targaryen_id AND RelationshipType = 1
) AND @viserys_i_id IS NOT NULL AND @daeron_targaryen_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @alicent_hightower_id, @daeron_targaryen_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @alicent_hightower_id AND Person2Id = @daeron_targaryen_id AND RelationshipType = 1
) AND @alicent_hightower_id IS NOT NULL AND @daeron_targaryen_id IS NOT NULL;

-- Relations siblings entre les enfants de Viserys I et Alicent
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @aegon_ii_id, @helaena_targaryen_id, 4, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @aegon_ii_id AND Person2Id = @helaena_targaryen_id) OR (Person1Id = @helaena_targaryen_id AND Person2Id = @aegon_ii_id)) AND RelationshipType = 4
) AND @aegon_ii_id IS NOT NULL AND @helaena_targaryen_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @aegon_ii_id, @aemond_targaryen_id, 4, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @aegon_ii_id AND Person2Id = @aemond_targaryen_id) OR (Person1Id = @aemond_targaryen_id AND Person2Id = @aegon_ii_id)) AND RelationshipType = 4
) AND @aegon_ii_id IS NOT NULL AND @aemond_targaryen_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @aegon_ii_id, @daeron_targaryen_id, 4, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @aegon_ii_id AND Person2Id = @daeron_targaryen_id) OR (Person1Id = @daeron_targaryen_id AND Person2Id = @aegon_ii_id)) AND RelationshipType = 4
) AND @aegon_ii_id IS NOT NULL AND @daeron_targaryen_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @helaena_targaryen_id, @aemond_targaryen_id, 4, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @helaena_targaryen_id AND Person2Id = @aemond_targaryen_id) OR (Person1Id = @aemond_targaryen_id AND Person2Id = @helaena_targaryen_id)) AND RelationshipType = 4
) AND @helaena_targaryen_id IS NOT NULL AND @aemond_targaryen_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @helaena_targaryen_id, @daeron_targaryen_id, 4, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @helaena_targaryen_id AND Person2Id = @daeron_targaryen_id) OR (Person1Id = @daeron_targaryen_id AND Person2Id = @helaena_targaryen_id)) AND RelationshipType = 4
) AND @helaena_targaryen_id IS NOT NULL AND @daeron_targaryen_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @aemond_targaryen_id, @daeron_targaryen_id, 4, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @aemond_targaryen_id AND Person2Id = @daeron_targaryen_id) OR (Person1Id = @daeron_targaryen_id AND Person2Id = @aemond_targaryen_id)) AND RelationshipType = 4
) AND @aemond_targaryen_id IS NOT NULL AND @daeron_targaryen_id IS NOT NULL;

-- Relation sibling entre Rhaenyra et les enfants d'Alicent (demi-frères/sœurs)
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @rhaenyra_targaryen_id, @aegon_ii_id, 4, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @rhaenyra_targaryen_id AND Person2Id = @aegon_ii_id) OR (Person1Id = @aegon_ii_id AND Person2Id = @rhaenyra_targaryen_id)) AND RelationshipType = 4
) AND @rhaenyra_targaryen_id IS NOT NULL AND @aegon_ii_id IS NOT NULL;

-- ============================================
-- MARIAGE DE RHAENYRA ET DAEMON
-- ============================================

-- Mariage Rhaenyra et Daemon (oncle et nièce)
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, StartDate, CreatedAt)
SELECT @rhaenyra_targaryen_id, @daemon_targaryen_id, 3, '120-01-01', NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @rhaenyra_targaryen_id AND Person2Id = @daemon_targaryen_id) OR (Person1Id = @daemon_targaryen_id AND Person2Id = @rhaenyra_targaryen_id)) AND RelationshipType = 3
) AND @rhaenyra_targaryen_id IS NOT NULL AND @daemon_targaryen_id IS NOT NULL;

-- ============================================
-- ENFANTS DE RHAENYRA ET DAEMON
-- ============================================

-- Aegon III Targaryen "The Younger"
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Aegon', 'Targaryen', 'III The Younger', '120-01-01', '157-01-01', 'Dragonstone', 'King\'s Landing', 'Male', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @aegon_iii_id = LAST_INSERT_ID();
SELECT @aegon_iii_id := Id FROM Persons WHERE FirstName = 'Aegon' AND LastName = 'Targaryen' AND MiddleName = 'III The Younger' LIMIT 1;

-- Viserys II Targaryen
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Viserys', 'Targaryen', 'II', '122-01-01', '172-01-01', 'Dragonstone', 'King\'s Landing', 'Male', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @viserys_ii_id = LAST_INSERT_ID();
SELECT @viserys_ii_id := Id FROM Persons WHERE FirstName = 'Viserys' AND LastName = 'Targaryen' AND MiddleName = 'II' LIMIT 1;

-- Relations parent-enfant (Rhaenyra et Daemon sont parents de Aegon III et Viserys II)
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @rhaenyra_targaryen_id, @aegon_iii_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @rhaenyra_targaryen_id AND Person2Id = @aegon_iii_id AND RelationshipType = 1
) AND @rhaenyra_targaryen_id IS NOT NULL AND @aegon_iii_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @daemon_targaryen_id, @aegon_iii_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @daemon_targaryen_id AND Person2Id = @aegon_iii_id AND RelationshipType = 1
) AND @daemon_targaryen_id IS NOT NULL AND @aegon_iii_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @rhaenyra_targaryen_id, @viserys_ii_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @rhaenyra_targaryen_id AND Person2Id = @viserys_ii_id AND RelationshipType = 1
) AND @rhaenyra_targaryen_id IS NOT NULL AND @viserys_ii_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @daemon_targaryen_id, @viserys_ii_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @daemon_targaryen_id AND Person2Id = @viserys_ii_id AND RelationshipType = 1
) AND @daemon_targaryen_id IS NOT NULL AND @viserys_ii_id IS NOT NULL;

-- Relation sibling entre Aegon III et Viserys II
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @aegon_iii_id, @viserys_ii_id, 4, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @aegon_iii_id AND Person2Id = @viserys_ii_id) OR (Person1Id = @viserys_ii_id AND Person2Id = @aegon_iii_id)) AND RelationshipType = 4
) AND @aegon_iii_id IS NOT NULL AND @viserys_ii_id IS NOT NULL;

-- ============================================
-- MARIAGE DE AEGON II ET HELAENA
-- ============================================

-- Mariage Aegon II et Helaena (frère et sœur)
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, StartDate, CreatedAt)
SELECT @aegon_ii_id, @helaena_targaryen_id, 3, '120-01-01', NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @aegon_ii_id AND Person2Id = @helaena_targaryen_id) OR (Person1Id = @helaena_targaryen_id AND Person2Id = @aegon_ii_id)) AND RelationshipType = 3
) AND @aegon_ii_id IS NOT NULL AND @helaena_targaryen_id IS NOT NULL;

-- ============================================
-- ENFANTS DE AEGON II ET HELAENA
-- ============================================

-- Jaehaerys Targaryen (fils de Aegon II et Helaena)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Jaehaerys', 'Targaryen', NULL, '123-01-01', '130-01-01', 'King\'s Landing', 'King\'s Landing', 'Male', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @jaehaerys_son_id = LAST_INSERT_ID();
SELECT @jaehaerys_son_id := Id FROM Persons WHERE FirstName = 'Jaehaerys' AND LastName = 'Targaryen' AND BirthDate = '123-01-01' LIMIT 1;

-- Jaehaera Targaryen (fille de Aegon II et Helaena)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Jaehaera', 'Targaryen', NULL, '123-01-01', '133-01-01', 'King\'s Landing', 'King\'s Landing', 'Female', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @jaehaera_targaryen_id = LAST_INSERT_ID();
SELECT @jaehaera_targaryen_id := Id FROM Persons WHERE FirstName = 'Jaehaera' AND LastName = 'Targaryen' LIMIT 1;

-- Maelor Targaryen (fils de Aegon II et Helaena)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Maelor', 'Targaryen', NULL, '125-01-01', '130-01-01', 'King\'s Landing', 'Bitterbridge, The Reach', 'Male', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @maelor_targaryen_id = LAST_INSERT_ID();
SELECT @maelor_targaryen_id := Id FROM Persons WHERE FirstName = 'Maelor' AND LastName = 'Targaryen' LIMIT 1;

-- Relations parent-enfant (Aegon II et Helaena sont parents)
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @aegon_ii_id, @jaehaerys_son_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @aegon_ii_id AND Person2Id = @jaehaerys_son_id AND RelationshipType = 1
) AND @aegon_ii_id IS NOT NULL AND @jaehaerys_son_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @helaena_targaryen_id, @jaehaerys_son_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @helaena_targaryen_id AND Person2Id = @jaehaerys_son_id AND RelationshipType = 1
) AND @helaena_targaryen_id IS NOT NULL AND @jaehaerys_son_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @aegon_ii_id, @jaehaera_targaryen_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @aegon_ii_id AND Person2Id = @jaehaera_targaryen_id AND RelationshipType = 1
) AND @aegon_ii_id IS NOT NULL AND @jaehaera_targaryen_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @helaena_targaryen_id, @jaehaera_targaryen_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @helaena_targaryen_id AND Person2Id = @jaehaera_targaryen_id AND RelationshipType = 1
) AND @helaena_targaryen_id IS NOT NULL AND @jaehaera_targaryen_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @aegon_ii_id, @maelor_targaryen_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @aegon_ii_id AND Person2Id = @maelor_targaryen_id AND RelationshipType = 1
) AND @aegon_ii_id IS NOT NULL AND @maelor_targaryen_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @helaena_targaryen_id, @maelor_targaryen_id, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @helaena_targaryen_id AND Person2Id = @maelor_targaryen_id AND RelationshipType = 1
) AND @helaena_targaryen_id IS NOT NULL AND @maelor_targaryen_id IS NOT NULL;

-- Relations siblings entre les enfants de Aegon II et Helaena
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @jaehaerys_son_id, @jaehaera_targaryen_id, 4, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @jaehaerys_son_id AND Person2Id = @jaehaera_targaryen_id) OR (Person1Id = @jaehaera_targaryen_id AND Person2Id = @jaehaerys_son_id)) AND RelationshipType = 4
) AND @jaehaerys_son_id IS NOT NULL AND @jaehaera_targaryen_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @jaehaerys_son_id, @maelor_targaryen_id, 4, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @jaehaerys_son_id AND Person2Id = @maelor_targaryen_id) OR (Person1Id = @maelor_targaryen_id AND Person2Id = @jaehaerys_son_id)) AND RelationshipType = 4
) AND @jaehaerys_son_id IS NOT NULL AND @maelor_targaryen_id IS NOT NULL;

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @jaehaera_targaryen_id, @maelor_targaryen_id, 4, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @jaehaera_targaryen_id AND Person2Id = @maelor_targaryen_id) OR (Person1Id = @maelor_targaryen_id AND Person2Id = @jaehaera_targaryen_id)) AND RelationshipType = 4
) AND @jaehaera_targaryen_id IS NOT NULL AND @maelor_targaryen_id IS NOT NULL;

-- ============================================
-- MESSAGE DE CONFIRMATION
-- ============================================

SELECT 'Personnages de House of the Dragon ajoutés avec succès!' AS result;
SELECT COUNT(*) AS total_personnes_hotd FROM Persons WHERE LastName = 'Targaryen' AND (FirstName IN ('Viserys', 'Daemon', 'Rhaenyra', 'Aegon', 'Helaena', 'Aemond', 'Daeron', 'Aemma', 'Alicent', 'Jaehaerys', 'Alysanne', 'Baelon', 'Alyssa', 'Jaehaera', 'Maelor') OR MiddleName LIKE '%II%' OR MiddleName LIKE '%III%');
SELECT COUNT(*) AS total_relations_hotd FROM Relationships;
