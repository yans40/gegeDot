-- ============================================
-- Ajouter une famille fictive très nombreuse pour tester la vue éventail
-- ============================================
-- Ce script crée :
-- - Un individu fictif (père) avec 30 enfants
-- - 3 conjointes différentes
-- - Environ 5 ou 3 enfants par enfant (certains sans enfants)
-- ============================================

USE gegeDot;

-- ============================================
-- CRÉER LE PÈRE (individu central)
-- ============================================

INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Jean', 'TestFamille', 'Le Patriarche', '1950-01-15', 'Paris, France', 'Male', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SELECT @papa_id := Id FROM Persons WHERE FirstName = 'Jean' AND LastName = 'TestFamille' LIMIT 1;

-- ============================================
-- CRÉER LES 3 CONJOINTES
-- ============================================

-- Première conjointe
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Marie', 'TestFamille', 'Première Épouse', '1952-03-20', 'Lyon, France', 'Female', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SELECT @marie_id := Id FROM Persons WHERE FirstName = 'Marie' AND LastName = 'TestFamille' AND MiddleName = 'Première Épouse' LIMIT 1;

-- Deuxième conjointe
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Sophie', 'TestFamille', 'Deuxième Épouse', '1955-06-10', 'Marseille, France', 'Female', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SELECT @sophie_id := Id FROM Persons WHERE FirstName = 'Sophie' AND LastName = 'TestFamille' AND MiddleName = 'Deuxième Épouse' LIMIT 1;

-- Troisième conjointe
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Claire', 'TestFamille', 'Troisième Épouse', '1958-09-25', 'Toulouse, France', 'Female', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SELECT @claire_id := Id FROM Persons WHERE FirstName = 'Claire' AND LastName = 'TestFamille' AND MiddleName = 'Troisième Épouse' LIMIT 1;

-- ============================================
-- RELATIONS DE MARIAGE
-- ============================================

-- Mariage avec Marie (1970-1990)
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, StartDate, EndDate, CreatedAt)
SELECT @papa_id, @marie_id, 3, '1970-05-15', '1990-12-31', NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @papa_id AND Person2Id = @marie_id) OR (Person1Id = @marie_id AND Person2Id = @papa_id)) 
    AND RelationshipType = 3
) AND @papa_id IS NOT NULL AND @marie_id IS NOT NULL;

-- Mariage avec Sophie (1991-2010)
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, StartDate, EndDate, CreatedAt)
SELECT @papa_id, @sophie_id, 3, '1991-02-14', '2010-06-30', NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @papa_id AND Person2Id = @sophie_id) OR (Person1Id = @sophie_id AND Person2Id = @papa_id)) 
    AND RelationshipType = 3
) AND @papa_id IS NOT NULL AND @sophie_id IS NOT NULL;

-- Mariage actuel avec Claire (2011, sans EndDate)
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, StartDate, CreatedAt)
SELECT @papa_id, @claire_id, 3, '2011-07-01', NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE ((Person1Id = @papa_id AND Person2Id = @claire_id) OR (Person1Id = @claire_id AND Person2Id = @papa_id)) 
    AND RelationshipType = 3
    AND EndDate IS NULL
) AND @papa_id IS NOT NULL AND @claire_id IS NOT NULL;

-- ============================================
-- CRÉER LES 30 ENFANTS (10 par conjointe)
-- ============================================

-- Enfants de Marie (1-10)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt) VALUES
('Enfant1', 'TestFamille', 'Fils de Marie #1', '1971-03-15', 'Paris, France', 'Male', true, NOW(), NOW()),
('Enfant2', 'TestFamille', 'Fille de Marie #2', '1972-05-20', 'Paris, France', 'Female', true, NOW(), NOW()),
('Enfant3', 'TestFamille', 'Fils de Marie #3', '1973-07-10', 'Paris, France', 'Male', true, NOW(), NOW()),
('Enfant4', 'TestFamille', 'Fille de Marie #4', '1974-09-25', 'Paris, France', 'Female', true, NOW(), NOW()),
('Enfant5', 'TestFamille', 'Fils de Marie #5', '1975-11-12', 'Paris, France', 'Male', true, NOW(), NOW()),
('Enfant6', 'TestFamille', 'Fille de Marie #6', '1977-01-18', 'Paris, France', 'Female', true, NOW(), NOW()),
('Enfant7', 'TestFamille', 'Fils de Marie #7', '1978-03-22', 'Paris, France', 'Male', true, NOW(), NOW()),
('Enfant8', 'TestFamille', 'Fille de Marie #8', '1979-05-30', 'Paris, France', 'Female', true, NOW(), NOW()),
('Enfant9', 'TestFamille', 'Fils de Marie #9', '1980-08-05', 'Paris, France', 'Male', true, NOW(), NOW()),
('Enfant10', 'TestFamille', 'Fille de Marie #10', '1981-10-15', 'Paris, France', 'Female', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

-- Enfants de Sophie (11-20)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt) VALUES
('Enfant11', 'TestFamille', 'Fils de Sophie #11', '1992-04-10', 'Marseille, France', 'Male', true, NOW(), NOW()),
('Enfant12', 'TestFamille', 'Fille de Sophie #12', '1993-06-20', 'Marseille, France', 'Female', true, NOW(), NOW()),
('Enfant13', 'TestFamille', 'Fils de Sophie #13', '1994-08-15', 'Marseille, France', 'Male', true, NOW(), NOW()),
('Enfant14', 'TestFamille', 'Fille de Sophie #14', '1995-10-25', 'Marseille, France', 'Female', true, NOW(), NOW()),
('Enfant15', 'TestFamille', 'Fils de Sophie #15', '1996-12-30', 'Marseille, France', 'Male', true, NOW(), NOW()),
('Enfant16', 'TestFamille', 'Fille de Sophie #16', '1998-02-14', 'Marseille, France', 'Female', true, NOW(), NOW()),
('Enfant17', 'TestFamille', 'Fils de Sophie #17', '1999-04-18', 'Marseille, France', 'Male', true, NOW(), NOW()),
('Enfant18', 'TestFamille', 'Fille de Sophie #18', '2000-06-22', 'Marseille, France', 'Female', true, NOW(), NOW()),
('Enfant19', 'TestFamille', 'Fils de Sophie #19', '2001-08-28', 'Marseille, France', 'Male', true, NOW(), NOW()),
('Enfant20', 'TestFamille', 'Fille de Sophie #20', '2002-10-10', 'Marseille, France', 'Female', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

-- Enfants de Claire (21-30)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt) VALUES
('Enfant21', 'TestFamille', 'Fils de Claire #21', '2012-05-15', 'Toulouse, France', 'Male', true, NOW(), NOW()),
('Enfant22', 'TestFamille', 'Fille de Claire #22', '2013-07-20', 'Toulouse, France', 'Female', true, NOW(), NOW()),
('Enfant23', 'TestFamille', 'Fils de Claire #23', '2014-09-10', 'Toulouse, France', 'Male', true, NOW(), NOW()),
('Enfant24', 'TestFamille', 'Fille de Claire #24', '2015-11-25', 'Toulouse, France', 'Female', true, NOW(), NOW()),
('Enfant25', 'TestFamille', 'Fils de Claire #25', '2017-01-12', 'Toulouse, France', 'Male', true, NOW(), NOW()),
('Enfant26', 'TestFamille', 'Fille de Claire #26', '2018-03-18', 'Toulouse, France', 'Female', true, NOW(), NOW()),
('Enfant27', 'TestFamille', 'Fils de Claire #27', '2019-05-22', 'Toulouse, France', 'Male', true, NOW(), NOW()),
('Enfant28', 'TestFamille', 'Fille de Claire #28', '2020-07-30', 'Toulouse, France', 'Female', true, NOW(), NOW()),
('Enfant29', 'TestFamille', 'Fils de Claire #29', '2021-09-05', 'Toulouse, France', 'Male', true, NOW(), NOW()),
('Enfant30', 'TestFamille', 'Fille de Claire #30', '2022-11-15', 'Toulouse, France', 'Female', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

-- Relations parent-enfant pour les enfants de Marie (1-10)
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @papa_id, Id, 1, NOW() FROM Persons 
WHERE FirstName IN ('Enfant1', 'Enfant2', 'Enfant3', 'Enfant4', 'Enfant5', 'Enfant6', 'Enfant7', 'Enfant8', 'Enfant9', 'Enfant10')
AND LastName = 'TestFamille'
AND NOT EXISTS (SELECT 1 FROM Relationships WHERE Person1Id = @papa_id AND Person2Id = Persons.Id AND RelationshipType = 1);

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @marie_id, Id, 1, NOW() FROM Persons 
WHERE FirstName IN ('Enfant1', 'Enfant2', 'Enfant3', 'Enfant4', 'Enfant5', 'Enfant6', 'Enfant7', 'Enfant8', 'Enfant9', 'Enfant10')
AND LastName = 'TestFamille'
AND NOT EXISTS (SELECT 1 FROM Relationships WHERE Person1Id = @marie_id AND Person2Id = Persons.Id AND RelationshipType = 1);

-- Relations parent-enfant pour les enfants de Sophie (11-20)
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @papa_id, Id, 1, NOW() FROM Persons 
WHERE FirstName IN ('Enfant11', 'Enfant12', 'Enfant13', 'Enfant14', 'Enfant15', 'Enfant16', 'Enfant17', 'Enfant18', 'Enfant19', 'Enfant20')
AND LastName = 'TestFamille'
AND NOT EXISTS (SELECT 1 FROM Relationships WHERE Person1Id = @papa_id AND Person2Id = Persons.Id AND RelationshipType = 1);

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @sophie_id, Id, 1, NOW() FROM Persons 
WHERE FirstName IN ('Enfant11', 'Enfant12', 'Enfant13', 'Enfant14', 'Enfant15', 'Enfant16', 'Enfant17', 'Enfant18', 'Enfant19', 'Enfant20')
AND LastName = 'TestFamille'
AND NOT EXISTS (SELECT 1 FROM Relationships WHERE Person1Id = @sophie_id AND Person2Id = Persons.Id AND RelationshipType = 1);

-- Relations parent-enfant pour les enfants de Claire (21-30)
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @papa_id, Id, 1, NOW() FROM Persons 
WHERE FirstName IN ('Enfant21', 'Enfant22', 'Enfant23', 'Enfant24', 'Enfant25', 'Enfant26', 'Enfant27', 'Enfant28', 'Enfant29', 'Enfant30')
AND LastName = 'TestFamille'
AND NOT EXISTS (SELECT 1 FROM Relationships WHERE Person1Id = @papa_id AND Person2Id = Persons.Id AND RelationshipType = 1);

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @claire_id, Id, 1, NOW() FROM Persons 
WHERE FirstName IN ('Enfant21', 'Enfant22', 'Enfant23', 'Enfant24', 'Enfant25', 'Enfant26', 'Enfant27', 'Enfant28', 'Enfant29', 'Enfant30')
AND LastName = 'TestFamille'
AND NOT EXISTS (SELECT 1 FROM Relationships WHERE Person1Id = @claire_id AND Person2Id = Persons.Id AND RelationshipType = 1);

-- ============================================
-- CRÉER LES PETITS-ENFANTS
-- ============================================
-- Environ 30% n'ont pas d'enfants (3, 7, 11, 15, 19, 23, 27)
-- Les autres ont 3 ou 5 enfants (alternance)

-- Source SQL pour générer les petits-enfants (script séparé ou procédure stockée)
-- Pour simplifier, créons les petits-enfants manuellement pour quelques enfants

-- Enfant1 a 5 enfants
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt) VALUES
('PetitEnfant1_1', 'TestFamille', 'Petit-enfant de Enfant1 #1', '2000-03-15', 'France', 'Male', true, NOW(), NOW()),
('PetitEnfant1_2', 'TestFamille', 'Petit-enfant de Enfant1 #2', '2001-05-20', 'France', 'Female', true, NOW(), NOW()),
('PetitEnfant1_3', 'TestFamille', 'Petit-enfant de Enfant1 #3', '2002-07-10', 'France', 'Male', true, NOW(), NOW()),
('PetitEnfant1_4', 'TestFamille', 'Petit-enfant de Enfant1 #4', '2003-09-25', 'France', 'Female', true, NOW(), NOW()),
('PetitEnfant1_5', 'TestFamille', 'Petit-enfant de Enfant1 #5', '2004-11-12', 'France', 'Male', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT (SELECT Id FROM Persons WHERE FirstName = 'Enfant1' AND LastName = 'TestFamille' LIMIT 1), Id, 1, NOW() 
FROM Persons WHERE FirstName LIKE 'PetitEnfant1_%' AND LastName = 'TestFamille'
AND NOT EXISTS (SELECT 1 FROM Relationships r INNER JOIN Persons p ON r.Person2Id = Persons.Id WHERE r.Person1Id = (SELECT Id FROM Persons WHERE FirstName = 'Enfant1' AND LastName = 'TestFamille' LIMIT 1) AND r.RelationshipType = 1);

-- Enfant2 a 3 enfants
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt) VALUES
('PetitEnfant2_1', 'TestFamille', 'Petit-enfant de Enfant2 #1', '2001-04-10', 'France', 'Female', true, NOW(), NOW()),
('PetitEnfant2_2', 'TestFamille', 'Petit-enfant de Enfant2 #2', '2002-06-20', 'France', 'Male', true, NOW(), NOW()),
('PetitEnfant2_3', 'TestFamille', 'Petit-enfant de Enfant2 #3', '2003-08-15', 'France', 'Female', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT (SELECT Id FROM Persons WHERE FirstName = 'Enfant2' AND LastName = 'TestFamille' LIMIT 1), Id, 1, NOW() 
FROM Persons WHERE FirstName LIKE 'PetitEnfant2_%' AND LastName = 'TestFamille'
AND NOT EXISTS (SELECT 1 FROM Relationships r WHERE r.Person1Id = (SELECT Id FROM Persons WHERE FirstName = 'Enfant2' AND LastName = 'TestFamille' LIMIT 1) AND r.Person2Id = Persons.Id AND r.RelationshipType = 1);

-- Enfant4 a 5 enfants
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt) VALUES
('PetitEnfant4_1', 'TestFamille', 'Petit-enfant de Enfant4 #1', '2002-05-15', 'France', 'Female', true, NOW(), NOW()),
('PetitEnfant4_2', 'TestFamille', 'Petit-enfant de Enfant4 #2', '2003-07-20', 'France', 'Male', true, NOW(), NOW()),
('PetitEnfant4_3', 'TestFamille', 'Petit-enfant de Enfant4 #3', '2004-09-10', 'France', 'Female', true, NOW(), NOW()),
('PetitEnfant4_4', 'TestFamille', 'Petit-enfant de Enfant4 #4', '2005-11-25', 'France', 'Male', true, NOW(), NOW()),
('PetitEnfant4_5', 'TestFamille', 'Petit-enfant de Enfant4 #5', '2006-01-12', 'France', 'Female', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT (SELECT Id FROM Persons WHERE FirstName = 'Enfant4' AND LastName = 'TestFamille' LIMIT 1), Id, 1, NOW() 
FROM Persons WHERE FirstName LIKE 'PetitEnfant4_%' AND LastName = 'TestFamille'
AND NOT EXISTS (SELECT 1 FROM Relationships r WHERE r.Person1Id = (SELECT Id FROM Persons WHERE FirstName = 'Enfant4' AND LastName = 'TestFamille' LIMIT 1) AND r.Person2Id = Persons.Id AND r.RelationshipType = 1);

-- Enfant5 a 3 enfants
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt) VALUES
('PetitEnfant5_1', 'TestFamille', 'Petit-enfant de Enfant5 #1', '2003-06-10', 'France', 'Male', true, NOW(), NOW()),
('PetitEnfant5_2', 'TestFamille', 'Petit-enfant de Enfant5 #2', '2004-08-20', 'France', 'Female', true, NOW(), NOW()),
('PetitEnfant5_3', 'TestFamille', 'Petit-enfant de Enfant5 #3', '2005-10-15', 'France', 'Male', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT (SELECT Id FROM Persons WHERE FirstName = 'Enfant5' AND LastName = 'TestFamille' LIMIT 1), Id, 1, NOW() 
FROM Persons WHERE FirstName LIKE 'PetitEnfant5_%' AND LastName = 'TestFamille'
AND NOT EXISTS (SELECT 1 FROM Relationships r WHERE r.Person1Id = (SELECT Id FROM Persons WHERE FirstName = 'Enfant5' AND LastName = 'TestFamille' LIMIT 1) AND r.Person2Id = Persons.Id AND r.RelationshipType = 1);

-- Enfant6 a 5 enfants
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt) VALUES
('PetitEnfant6_1', 'TestFamille', 'Petit-enfant de Enfant6 #1', '2004-07-15', 'France', 'Female', true, NOW(), NOW()),
('PetitEnfant6_2', 'TestFamille', 'Petit-enfant de Enfant6 #2', '2005-09-20', 'France', 'Male', true, NOW(), NOW()),
('PetitEnfant6_3', 'TestFamille', 'Petit-enfant de Enfant6 #3', '2006-11-10', 'France', 'Female', true, NOW(), NOW()),
('PetitEnfant6_4', 'TestFamille', 'Petit-enfant de Enfant6 #4', '2007-01-25', 'France', 'Male', true, NOW(), NOW()),
('PetitEnfant6_5', 'TestFamille', 'Petit-enfant de Enfant6 #5', '2008-03-12', 'France', 'Female', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT (SELECT Id FROM Persons WHERE FirstName = 'Enfant6' AND LastName = 'TestFamille' LIMIT 1), Id, 1, NOW() 
FROM Persons WHERE FirstName LIKE 'PetitEnfant6_%' AND LastName = 'TestFamille'
AND NOT EXISTS (SELECT 1 FROM Relationships r WHERE r.Person1Id = (SELECT Id FROM Persons WHERE FirstName = 'Enfant6' AND LastName = 'TestFamille' LIMIT 1) AND r.Person2Id = Persons.Id AND r.RelationshipType = 1);

-- Enfant8 a 3 enfants
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt) VALUES
('PetitEnfant8_1', 'TestFamille', 'Petit-enfant de Enfant8 #1', '2005-08-10', 'France', 'Female', true, NOW(), NOW()),
('PetitEnfant8_2', 'TestFamille', 'Petit-enfant de Enfant8 #2', '2006-10-20', 'France', 'Male', true, NOW(), NOW()),
('PetitEnfant8_3', 'TestFamille', 'Petit-enfant de Enfant8 #3', '2007-12-15', 'France', 'Female', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT (SELECT Id FROM Persons WHERE FirstName = 'Enfant8' AND LastName = 'TestFamille' LIMIT 1), Id, 1, NOW() 
FROM Persons WHERE FirstName LIKE 'PetitEnfant8_%' AND LastName = 'TestFamille'
AND NOT EXISTS (SELECT 1 FROM Relationships r WHERE r.Person1Id = (SELECT Id FROM Persons WHERE FirstName = 'Enfant8' AND LastName = 'TestFamille' LIMIT 1) AND r.Person2Id = Persons.Id AND r.RelationshipType = 1);

-- Enfant9 a 5 enfants
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt) VALUES
('PetitEnfant9_1', 'TestFamille', 'Petit-enfant de Enfant9 #1', '2006-09-15', 'France', 'Male', true, NOW(), NOW()),
('PetitEnfant9_2', 'TestFamille', 'Petit-enfant de Enfant9 #2', '2007-11-20', 'France', 'Female', true, NOW(), NOW()),
('PetitEnfant9_3', 'TestFamille', 'Petit-enfant de Enfant9 #3', '2008-01-10', 'France', 'Male', true, NOW(), NOW()),
('PetitEnfant9_4', 'TestFamille', 'Petit-enfant de Enfant9 #4', '2009-03-25', 'France', 'Female', true, NOW(), NOW()),
('PetitEnfant9_5', 'TestFamille', 'Petit-enfant de Enfant9 #5', '2010-05-12', 'France', 'Male', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT (SELECT Id FROM Persons WHERE FirstName = 'Enfant9' AND LastName = 'TestFamille' LIMIT 1), Id, 1, NOW() 
FROM Persons WHERE FirstName LIKE 'PetitEnfant9_%' AND LastName = 'TestFamille'
AND NOT EXISTS (SELECT 1 FROM Relationships r WHERE r.Person1Id = (SELECT Id FROM Persons WHERE FirstName = 'Enfant9' AND LastName = 'TestFamille' LIMIT 1) AND r.Person2Id = Persons.Id AND r.RelationshipType = 1);

-- Enfant10 a 3 enfants
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt) VALUES
('PetitEnfant10_1', 'TestFamille', 'Petit-enfant de Enfant10 #1', '2007-10-10', 'France', 'Female', true, NOW(), NOW()),
('PetitEnfant10_2', 'TestFamille', 'Petit-enfant de Enfant10 #2', '2008-12-20', 'France', 'Male', true, NOW(), NOW()),
('PetitEnfant10_3', 'TestFamille', 'Petit-enfant de Enfant10 #3', '2010-02-15', 'France', 'Female', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT (SELECT Id FROM Persons WHERE FirstName = 'Enfant10' AND LastName = 'TestFamille' LIMIT 1), Id, 1, NOW() 
FROM Persons WHERE FirstName LIKE 'PetitEnfant10_%' AND LastName = 'TestFamille'
AND NOT EXISTS (SELECT 1 FROM Relationships r WHERE r.Person1Id = (SELECT Id FROM Persons WHERE FirstName = 'Enfant10' AND LastName = 'TestFamille' LIMIT 1) AND r.Person2Id = Persons.Id AND r.RelationshipType = 1);

-- Continuer pour les autres enfants (12, 13, 14, 16, 17, 18, 20, 21, 22, 24, 25, 26, 28, 29, 30)
-- Pour simplifier, créons quelques autres exemples

-- Enfant12 a 5 enfants
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt) VALUES
('PetitEnfant12_1', 'TestFamille', 'Petit-enfant de Enfant12 #1', '2011-11-15', 'France', 'Female', true, NOW(), NOW()),
('PetitEnfant12_2', 'TestFamille', 'Petit-enfant de Enfant12 #2', '2012-01-20', 'France', 'Male', true, NOW(), NOW()),
('PetitEnfant12_3', 'TestFamille', 'Petit-enfant de Enfant12 #3', '2013-03-10', 'France', 'Female', true, NOW(), NOW()),
('PetitEnfant12_4', 'TestFamille', 'Petit-enfant de Enfant12 #4', '2014-05-25', 'France', 'Male', true, NOW(), NOW()),
('PetitEnfant12_5', 'TestFamille', 'Petit-enfant de Enfant12 #5', '2015-07-12', 'France', 'Female', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT (SELECT Id FROM Persons WHERE FirstName = 'Enfant12' AND LastName = 'TestFamille' LIMIT 1), Id, 1, NOW() 
FROM Persons WHERE FirstName LIKE 'PetitEnfant12_%' AND LastName = 'TestFamille'
AND NOT EXISTS (SELECT 1 FROM Relationships r WHERE r.Person1Id = (SELECT Id FROM Persons WHERE FirstName = 'Enfant12' AND LastName = 'TestFamille' LIMIT 1) AND r.Person2Id = Persons.Id AND r.RelationshipType = 1);

-- Enfant13 a 3 enfants
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt) VALUES
('PetitEnfant13_1', 'TestFamille', 'Petit-enfant de Enfant13 #1', '2012-12-10', 'France', 'Male', true, NOW(), NOW()),
('PetitEnfant13_2', 'TestFamille', 'Petit-enfant de Enfant13 #2', '2014-02-20', 'France', 'Female', true, NOW(), NOW()),
('PetitEnfant13_3', 'TestFamille', 'Petit-enfant de Enfant13 #3', '2015-04-15', 'France', 'Male', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT (SELECT Id FROM Persons WHERE FirstName = 'Enfant13' AND LastName = 'TestFamille' LIMIT 1), Id, 1, NOW() 
FROM Persons WHERE FirstName LIKE 'PetitEnfant13_%' AND LastName = 'TestFamille'
AND NOT EXISTS (SELECT 1 FROM Relationships r WHERE r.Person1Id = (SELECT Id FROM Persons WHERE FirstName = 'Enfant13' AND LastName = 'TestFamille' LIMIT 1) AND r.Person2Id = Persons.Id AND r.RelationshipType = 1);

-- Enfant14 a 5 enfants
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt) VALUES
('PetitEnfant14_1', 'TestFamille', 'Petit-enfant de Enfant14 #1', '2013-01-15', 'France', 'Female', true, NOW(), NOW()),
('PetitEnfant14_2', 'TestFamille', 'Petit-enfant de Enfant14 #2', '2014-03-20', 'France', 'Male', true, NOW(), NOW()),
('PetitEnfant14_3', 'TestFamille', 'Petit-enfant de Enfant14 #3', '2015-05-10', 'France', 'Female', true, NOW(), NOW()),
('PetitEnfant14_4', 'TestFamille', 'Petit-enfant de Enfant14 #4', '2016-07-25', 'France', 'Male', true, NOW(), NOW()),
('PetitEnfant14_5', 'TestFamille', 'Petit-enfant de Enfant14 #5', '2017-09-12', 'France', 'Female', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT (SELECT Id FROM Persons WHERE FirstName = 'Enfant14' AND LastName = 'TestFamille' LIMIT 1), Id, 1, NOW() 
FROM Persons WHERE FirstName LIKE 'PetitEnfant14_%' AND LastName = 'TestFamille'
AND NOT EXISTS (SELECT 1 FROM Relationships r WHERE r.Person1Id = (SELECT Id FROM Persons WHERE FirstName = 'Enfant14' AND LastName = 'TestFamille' LIMIT 1) AND r.Person2Id = Persons.Id AND r.RelationshipType = 1);

-- Enfant16 a 3 enfants
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt) VALUES
('PetitEnfant16_1', 'TestFamille', 'Petit-enfant de Enfant16 #1', '2016-02-10', 'France', 'Female', true, NOW(), NOW()),
('PetitEnfant16_2', 'TestFamille', 'Petit-enfant de Enfant16 #2', '2017-04-20', 'France', 'Male', true, NOW(), NOW()),
('PetitEnfant16_3', 'TestFamille', 'Petit-enfant de Enfant16 #3', '2018-06-15', 'France', 'Female', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT (SELECT Id FROM Persons WHERE FirstName = 'Enfant16' AND LastName = 'TestFamille' LIMIT 1), Id, 1, NOW() 
FROM Persons WHERE FirstName LIKE 'PetitEnfant16_%' AND LastName = 'TestFamille'
AND NOT EXISTS (SELECT 1 FROM Relationships r WHERE r.Person1Id = (SELECT Id FROM Persons WHERE FirstName = 'Enfant16' AND LastName = 'TestFamille' LIMIT 1) AND r.Person2Id = Persons.Id AND r.RelationshipType = 1);

-- Enfant17 a 5 enfants
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt) VALUES
('PetitEnfant17_1', 'TestFamille', 'Petit-enfant de Enfant17 #1', '2017-03-15', 'France', 'Male', true, NOW(), NOW()),
('PetitEnfant17_2', 'TestFamille', 'Petit-enfant de Enfant17 #2', '2018-05-20', 'France', 'Female', true, NOW(), NOW()),
('PetitEnfant17_3', 'TestFamille', 'Petit-enfant de Enfant17 #3', '2019-07-10', 'France', 'Male', true, NOW(), NOW()),
('PetitEnfant17_4', 'TestFamille', 'Petit-enfant de Enfant17 #4', '2020-09-25', 'France', 'Female', true, NOW(), NOW()),
('PetitEnfant17_5', 'TestFamille', 'Petit-enfant de Enfant17 #5', '2021-11-12', 'France', 'Male', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT (SELECT Id FROM Persons WHERE FirstName = 'Enfant17' AND LastName = 'TestFamille' LIMIT 1), Id, 1, NOW() 
FROM Persons WHERE FirstName LIKE 'PetitEnfant17_%' AND LastName = 'TestFamille'
AND NOT EXISTS (SELECT 1 FROM Relationships r WHERE r.Person1Id = (SELECT Id FROM Persons WHERE FirstName = 'Enfant17' AND LastName = 'TestFamille' LIMIT 1) AND r.Person2Id = Persons.Id AND r.RelationshipType = 1);

-- Enfant18 a 3 enfants
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt) VALUES
('PetitEnfant18_1', 'TestFamille', 'Petit-enfant de Enfant18 #1', '2018-04-10', 'France', 'Female', true, NOW(), NOW()),
('PetitEnfant18_2', 'TestFamille', 'Petit-enfant de Enfant18 #2', '2019-06-20', 'France', 'Male', true, NOW(), NOW()),
('PetitEnfant18_3', 'TestFamille', 'Petit-enfant de Enfant18 #3', '2020-08-15', 'France', 'Female', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT (SELECT Id FROM Persons WHERE FirstName = 'Enfant18' AND LastName = 'TestFamille' LIMIT 1), Id, 1, NOW() 
FROM Persons WHERE FirstName LIKE 'PetitEnfant18_%' AND LastName = 'TestFamille'
AND NOT EXISTS (SELECT 1 FROM Relationships r WHERE r.Person1Id = (SELECT Id FROM Persons WHERE FirstName = 'Enfant18' AND LastName = 'TestFamille' LIMIT 1) AND r.Person2Id = Persons.Id AND r.RelationshipType = 1);

-- Enfant20 a 5 enfants
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt) VALUES
('PetitEnfant20_1', 'TestFamille', 'Petit-enfant de Enfant20 #1', '2020-05-15', 'France', 'Female', true, NOW(), NOW()),
('PetitEnfant20_2', 'TestFamille', 'Petit-enfant de Enfant20 #2', '2021-07-20', 'France', 'Male', true, NOW(), NOW()),
('PetitEnfant20_3', 'TestFamille', 'Petit-enfant de Enfant20 #3', '2022-09-10', 'France', 'Female', true, NOW(), NOW()),
('PetitEnfant20_4', 'TestFamille', 'Petit-enfant de Enfant20 #4', '2023-11-25', 'France', 'Male', true, NOW(), NOW()),
('PetitEnfant20_5', 'TestFamille', 'Petit-enfant de Enfant20 #5', '2024-01-12', 'France', 'Female', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT (SELECT Id FROM Persons WHERE FirstName = 'Enfant20' AND LastName = 'TestFamille' LIMIT 1), Id, 1, NOW() 
FROM Persons WHERE FirstName LIKE 'PetitEnfant20_%' AND LastName = 'TestFamille'
AND NOT EXISTS (SELECT 1 FROM Relationships r WHERE r.Person1Id = (SELECT Id FROM Persons WHERE FirstName = 'Enfant20' AND LastName = 'TestFamille' LIMIT 1) AND r.Person2Id = Persons.Id AND r.RelationshipType = 1);

-- Enfant21 a 3 enfants
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt) VALUES
('PetitEnfant21_1', 'TestFamille', 'Petit-enfant de Enfant21 #1', '2020-06-10', 'France', 'Male', true, NOW(), NOW()),
('PetitEnfant21_2', 'TestFamille', 'Petit-enfant de Enfant21 #2', '2021-08-20', 'France', 'Female', true, NOW(), NOW()),
('PetitEnfant21_3', 'TestFamille', 'Petit-enfant de Enfant21 #3', '2022-10-15', 'France', 'Male', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT (SELECT Id FROM Persons WHERE FirstName = 'Enfant21' AND LastName = 'TestFamille' LIMIT 1), Id, 1, NOW() 
FROM Persons WHERE FirstName LIKE 'PetitEnfant21_%' AND LastName = 'TestFamille'
AND NOT EXISTS (SELECT 1 FROM Relationships r WHERE r.Person1Id = (SELECT Id FROM Persons WHERE FirstName = 'Enfant21' AND LastName = 'TestFamille' LIMIT 1) AND r.Person2Id = Persons.Id AND r.RelationshipType = 1);

-- Enfant22 a 5 enfants
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt) VALUES
('PetitEnfant22_1', 'TestFamille', 'Petit-enfant de Enfant22 #1', '2021-07-15', 'France', 'Female', true, NOW(), NOW()),
('PetitEnfant22_2', 'TestFamille', 'Petit-enfant de Enfant22 #2', '2022-09-20', 'France', 'Male', true, NOW(), NOW()),
('PetitEnfant22_3', 'TestFamille', 'Petit-enfant de Enfant22 #3', '2023-11-10', 'France', 'Female', true, NOW(), NOW()),
('PetitEnfant22_4', 'TestFamille', 'Petit-enfant de Enfant22 #4', '2024-01-25', 'France', 'Male', true, NOW(), NOW()),
('PetitEnfant22_5', 'TestFamille', 'Petit-enfant de Enfant22 #5', '2025-03-12', 'France', 'Female', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT (SELECT Id FROM Persons WHERE FirstName = 'Enfant22' AND LastName = 'TestFamille' LIMIT 1), Id, 1, NOW() 
FROM Persons WHERE FirstName LIKE 'PetitEnfant22_%' AND LastName = 'TestFamille'
AND NOT EXISTS (SELECT 1 FROM Relationships r WHERE r.Person1Id = (SELECT Id FROM Persons WHERE FirstName = 'Enfant22' AND LastName = 'TestFamille' LIMIT 1) AND r.Person2Id = Persons.Id AND r.RelationshipType = 1);

-- Enfant24 a 3 enfants
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt) VALUES
('PetitEnfant24_1', 'TestFamille', 'Petit-enfant de Enfant24 #1', '2023-08-10', 'France', 'Female', true, NOW(), NOW()),
('PetitEnfant24_2', 'TestFamille', 'Petit-enfant de Enfant24 #2', '2024-10-20', 'France', 'Male', true, NOW(), NOW()),
('PetitEnfant24_3', 'TestFamille', 'Petit-enfant de Enfant24 #3', '2025-12-15', 'France', 'Female', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT (SELECT Id FROM Persons WHERE FirstName = 'Enfant24' AND LastName = 'TestFamille' LIMIT 1), Id, 1, NOW() 
FROM Persons WHERE FirstName LIKE 'PetitEnfant24_%' AND LastName = 'TestFamille'
AND NOT EXISTS (SELECT 1 FROM Relationships r WHERE r.Person1Id = (SELECT Id FROM Persons WHERE FirstName = 'Enfant24' AND LastName = 'TestFamille' LIMIT 1) AND r.Person2Id = Persons.Id AND r.RelationshipType = 1);

-- Enfant25 a 5 enfants
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt) VALUES
('PetitEnfant25_1', 'TestFamille', 'Petit-enfant de Enfant25 #1', '2024-09-15', 'France', 'Male', true, NOW(), NOW()),
('PetitEnfant25_2', 'TestFamille', 'Petit-enfant de Enfant25 #2', '2025-11-20', 'France', 'Female', true, NOW(), NOW()),
('PetitEnfant25_3', 'TestFamille', 'Petit-enfant de Enfant25 #3', '2026-01-10', 'France', 'Male', true, NOW(), NOW()),
('PetitEnfant25_4', 'TestFamille', 'Petit-enfant de Enfant25 #4', '2027-03-25', 'France', 'Female', true, NOW(), NOW()),
('PetitEnfant25_5', 'TestFamille', 'Petit-enfant de Enfant25 #5', '2028-05-12', 'France', 'Male', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT (SELECT Id FROM Persons WHERE FirstName = 'Enfant25' AND LastName = 'TestFamille' LIMIT 1), Id, 1, NOW() 
FROM Persons WHERE FirstName LIKE 'PetitEnfant25_%' AND LastName = 'TestFamille'
AND NOT EXISTS (SELECT 1 FROM Relationships r WHERE r.Person1Id = (SELECT Id FROM Persons WHERE FirstName = 'Enfant25' AND LastName = 'TestFamille' LIMIT 1) AND r.Person2Id = Persons.Id AND r.RelationshipType = 1);

-- Enfant26 a 3 enfants
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt) VALUES
('PetitEnfant26_1', 'TestFamille', 'Petit-enfant de Enfant26 #1', '2025-10-10', 'France', 'Female', true, NOW(), NOW()),
('PetitEnfant26_2', 'TestFamille', 'Petit-enfant de Enfant26 #2', '2026-12-20', 'France', 'Male', true, NOW(), NOW()),
('PetitEnfant26_3', 'TestFamille', 'Petit-enfant de Enfant26 #3', '2028-02-15', 'France', 'Female', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT (SELECT Id FROM Persons WHERE FirstName = 'Enfant26' AND LastName = 'TestFamille' LIMIT 1), Id, 1, NOW() 
FROM Persons WHERE FirstName LIKE 'PetitEnfant26_%' AND LastName = 'TestFamille'
AND NOT EXISTS (SELECT 1 FROM Relationships r WHERE r.Person1Id = (SELECT Id FROM Persons WHERE FirstName = 'Enfant26' AND LastName = 'TestFamille' LIMIT 1) AND r.Person2Id = Persons.Id AND r.RelationshipType = 1);

-- Enfant28 a 5 enfants
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt) VALUES
('PetitEnfant28_1', 'TestFamille', 'Petit-enfant de Enfant28 #1', '2027-11-15', 'France', 'Female', true, NOW(), NOW()),
('PetitEnfant28_2', 'TestFamille', 'Petit-enfant de Enfant28 #2', '2029-01-20', 'France', 'Male', true, NOW(), NOW()),
('PetitEnfant28_3', 'TestFamille', 'Petit-enfant de Enfant28 #3', '2030-03-10', 'France', 'Female', true, NOW(), NOW()),
('PetitEnfant28_4', 'TestFamille', 'Petit-enfant de Enfant28 #4', '2031-05-25', 'France', 'Male', true, NOW(), NOW()),
('PetitEnfant28_5', 'TestFamille', 'Petit-enfant de Enfant28 #5', '2032-07-12', 'France', 'Female', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT (SELECT Id FROM Persons WHERE FirstName = 'Enfant28' AND LastName = 'TestFamille' LIMIT 1), Id, 1, NOW() 
FROM Persons WHERE FirstName LIKE 'PetitEnfant28_%' AND LastName = 'TestFamille'
AND NOT EXISTS (SELECT 1 FROM Relationships r WHERE r.Person1Id = (SELECT Id FROM Persons WHERE FirstName = 'Enfant28' AND LastName = 'TestFamille' LIMIT 1) AND r.Person2Id = Persons.Id AND r.RelationshipType = 1);

-- Enfant29 a 3 enfants
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt) VALUES
('PetitEnfant29_1', 'TestFamille', 'Petit-enfant de Enfant29 #1', '2028-12-10', 'France', 'Male', true, NOW(), NOW()),
('PetitEnfant29_2', 'TestFamille', 'Petit-enfant de Enfant29 #2', '2030-02-20', 'France', 'Female', true, NOW(), NOW()),
('PetitEnfant29_3', 'TestFamille', 'Petit-enfant de Enfant29 #3', '2031-04-15', 'France', 'Male', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT (SELECT Id FROM Persons WHERE FirstName = 'Enfant29' AND LastName = 'TestFamille' LIMIT 1), Id, 1, NOW() 
FROM Persons WHERE FirstName LIKE 'PetitEnfant29_%' AND LastName = 'TestFamille'
AND NOT EXISTS (SELECT 1 FROM Relationships r WHERE r.Person1Id = (SELECT Id FROM Persons WHERE FirstName = 'Enfant29' AND LastName = 'TestFamille' LIMIT 1) AND r.Person2Id = Persons.Id AND r.RelationshipType = 1);

-- Enfant30 a 5 enfants
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, BirthPlace, Gender, IsAlive, CreatedAt, UpdatedAt) VALUES
('PetitEnfant30_1', 'TestFamille', 'Petit-enfant de Enfant30 #1', '2029-01-15', 'France', 'Female', true, NOW(), NOW()),
('PetitEnfant30_2', 'TestFamille', 'Petit-enfant de Enfant30 #2', '2030-03-20', 'France', 'Male', true, NOW(), NOW()),
('PetitEnfant30_3', 'TestFamille', 'Petit-enfant de Enfant30 #3', '2031-05-10', 'France', 'Female', true, NOW(), NOW()),
('PetitEnfant30_4', 'TestFamille', 'Petit-enfant de Enfant30 #4', '2032-07-25', 'France', 'Male', true, NOW(), NOW()),
('PetitEnfant30_5', 'TestFamille', 'Petit-enfant de Enfant30 #5', '2033-09-12', 'France', 'Female', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT (SELECT Id FROM Persons WHERE FirstName = 'Enfant30' AND LastName = 'TestFamille' LIMIT 1), Id, 1, NOW() 
FROM Persons WHERE FirstName LIKE 'PetitEnfant30_%' AND LastName = 'TestFamille'
AND NOT EXISTS (SELECT 1 FROM Relationships r WHERE r.Person1Id = (SELECT Id FROM Persons WHERE FirstName = 'Enfant30' AND LastName = 'TestFamille' LIMIT 1) AND r.Person2Id = Persons.Id AND r.RelationshipType = 1);

-- ============================================
-- VÉRIFICATION
-- ============================================

SELECT 'Famille de test créée avec succès!' AS result;

-- Compter les enfants
SELECT COUNT(*) AS nombre_enfants FROM Persons 
WHERE LastName = 'TestFamille' 
AND (MiddleName LIKE 'Fils%' OR MiddleName LIKE 'Fille%');

-- Compter les petits-enfants
SELECT COUNT(*) AS nombre_petits_enfants FROM Persons 
WHERE LastName = 'TestFamille' 
AND MiddleName LIKE 'Petit-enfant%';

-- Afficher le patriarche
SELECT Id, FirstName, LastName, MiddleName FROM Persons 
WHERE FirstName = 'Jean' AND LastName = 'TestFamille';
