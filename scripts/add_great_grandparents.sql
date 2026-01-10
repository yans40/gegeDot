-- Ajouter les arrière-grands-parents de Charles Windsor
-- Parents de George Windsor (George VI)

-- George V (père de George VI)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('George', 'Windsor', 'V', '1865-06-03', '1936-01-20', 'Marlborough House, London', 'Sandringham House, England', 'Male', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @george_v_id = LAST_INSERT_ID();
SELECT @george_v_id := Id FROM Persons WHERE FirstName = 'George' AND LastName = 'Windsor' AND MiddleName = 'V' LIMIT 1;

-- Mary of Teck (mère de George VI)
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Mary', 'Teck', 'of Teck', '1867-05-26', '1953-03-24', 'Kensington Palace, London', 'Marlborough House, London', 'Female', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @mary_teck_id = LAST_INSERT_ID();
SELECT @mary_teck_id := Id FROM Persons WHERE FirstName = 'Mary' AND LastName = 'Teck' LIMIT 1;

-- Relation George V -> George VI
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @george_v_id, 11, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @george_v_id AND Person2Id = 11 AND RelationshipType = 1
);

-- Relation Mary of Teck -> George VI
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @mary_teck_id, 11, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @mary_teck_id AND Person2Id = 11 AND RelationshipType = 1
);

-- Parents de Elizabeth Bowes-Lyon

-- Claude Bowes-Lyon, 14th Earl of Strathmore
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Claude', 'Bowes-Lyon', '14th Earl of Strathmore', '1855-03-14', '1944-11-07', 'Glamis Castle, Scotland', 'Glamis Castle, Scotland', 'Male', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @claude_bowes_id = LAST_INSERT_ID();
SELECT @claude_bowes_id := Id FROM Persons WHERE FirstName = 'Claude' AND LastName = 'Bowes-Lyon' LIMIT 1;

-- Cecilia Cavendish-Bentinck
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Cecilia', 'Cavendish-Bentinck', NULL, '1862-09-11', '1938-06-23', 'London, England', 'Glamis Castle, Scotland', 'Female', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @cecilia_id = LAST_INSERT_ID();
SELECT @cecilia_id := Id FROM Persons WHERE FirstName = 'Cecilia' AND LastName = 'Cavendish-Bentinck' LIMIT 1;

-- Relation Claude -> Elizabeth Bowes-Lyon
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @claude_bowes_id, 12, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @claude_bowes_id AND Person2Id = 12 AND RelationshipType = 1
);

-- Relation Cecilia -> Elizabeth Bowes-Lyon
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @cecilia_id, 12, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @cecilia_id AND Person2Id = 12 AND RelationshipType = 1
);

-- Parents de Andrew Greece

-- George I of Greece
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('George', 'Greece', 'I of Greece', '1845-12-24', '1913-03-18', 'Copenhagen, Denmark', 'Thessaloniki, Greece', 'Male', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @george_greece_id = LAST_INSERT_ID();
SELECT @george_greece_id := Id FROM Persons WHERE FirstName = 'George' AND LastName = 'Greece' AND MiddleName = 'I of Greece' LIMIT 1;

-- Olga Konstantinovna of Russia
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Olga', 'Romanov', 'Konstantinovna of Russia', '1851-09-03', '1926-06-18', 'Pavlovsk Palace, Russia', 'Rome, Italy', 'Female', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @olga_id = LAST_INSERT_ID();
SELECT @olga_id := Id FROM Persons WHERE FirstName = 'Olga' AND LastName = 'Romanov' LIMIT 1;

-- Relation George I -> Andrew Greece
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @george_greece_id, 29, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @george_greece_id AND Person2Id = 29 AND RelationshipType = 1
);

-- Relation Olga -> Andrew Greece
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @olga_id, 29, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @olga_id AND Person2Id = 29 AND RelationshipType = 1
);

-- Parents de Alice Battenberg

-- Louis Mountbatten, 1st Marquess of Milford Haven
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Louis', 'Mountbatten', '1st Marquess of Milford Haven', '1854-05-24', '1921-09-11', 'Graz, Austria', 'London, England', 'Male', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @louis_mountbatten_id = LAST_INSERT_ID();
SELECT @louis_mountbatten_id := Id FROM Persons WHERE FirstName = 'Louis' AND LastName = 'Mountbatten' LIMIT 1;

-- Victoria of Hesse and by Rhine
INSERT INTO Persons (FirstName, LastName, MiddleName, BirthDate, DeathDate, BirthPlace, DeathPlace, Gender, IsAlive, CreatedAt, UpdatedAt)
VALUES ('Victoria', 'Hesse', 'of Hesse and by Rhine', '1863-04-05', '1950-09-24', 'Windsor Castle, England', 'Buckingham Palace, London', 'Female', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE UpdatedAt = NOW();

SET @victoria_hesse_id = LAST_INSERT_ID();
SELECT @victoria_hesse_id := Id FROM Persons WHERE FirstName = 'Victoria' AND LastName = 'Hesse' LIMIT 1;

-- Relation Louis -> Alice Battenberg
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @louis_mountbatten_id, 30, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @louis_mountbatten_id AND Person2Id = 30 AND RelationshipType = 1
);

-- Relation Victoria -> Alice Battenberg
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt)
SELECT @victoria_hesse_id, 30, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM Relationships 
    WHERE Person1Id = @victoria_hesse_id AND Person2Id = 30 AND RelationshipType = 1
);

SELECT 'Arrière-grands-parents de Charles Windsor ajoutés avec succès!' AS result;
