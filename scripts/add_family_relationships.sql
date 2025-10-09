-- Script pour ajouter des relations familiales de test
-- Assurez-vous que les personnes existent déjà dans la base de données

-- Relations parent-enfant
-- Jean Dupont (ID: 1) est le père de Marie Dupont (ID: 2)
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, StartDate, Notes, IsActive, CreatedAt) 
VALUES (1, 2, 1, '1980-01-01', 'Relation père-fille', 1, NOW());

-- Marie Martin (ID: 3) est la mère de Marie Dupont (ID: 2)
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, StartDate, Notes, IsActive, CreatedAt) 
VALUES (3, 2, 1, '1980-01-01', 'Relation mère-fille', 1, NOW());

-- Jean Dupont (ID: 1) est le père de Pierre Dupont (ID: 4)
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, StartDate, Notes, IsActive, CreatedAt) 
VALUES (1, 4, 1, '1985-01-01', 'Relation père-fils', 1, NOW());

-- Marie Martin (ID: 3) est la mère de Pierre Dupont (ID: 4)
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, StartDate, Notes, IsActive, CreatedAt) 
VALUES (3, 4, 1, '1985-01-01', 'Relation mère-fils', 1, NOW());

-- Relations de conjoint
-- Jean Dupont (ID: 1) est marié à Marie Martin (ID: 3)
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, StartDate, Notes, IsActive, CreatedAt) 
VALUES (1, 3, 3, '1975-06-15', 'Mariage', 1, NOW());

-- Relations grand-parent
-- Paul Dupont (ID: 5) est le grand-père de Marie Dupont (ID: 2)
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, StartDate, Notes, IsActive, CreatedAt) 
VALUES (5, 2, 5, '1980-01-01', 'Relation grand-père-petite-fille', 1, NOW());

-- Jeanne Dupont (ID: 6) est la grand-mère de Marie Dupont (ID: 2)
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, StartDate, Notes, IsActive, CreatedAt) 
VALUES (6, 2, 5, '1980-01-01', 'Relation grand-mère-petite-fille', 1, NOW());

-- Relations parent pour les grands-parents
-- Paul Dupont (ID: 5) est le père de Jean Dupont (ID: 1)
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, StartDate, Notes, IsActive, CreatedAt) 
VALUES (5, 1, 1, '1950-01-01', 'Relation père-fils', 1, NOW());

-- Jeanne Dupont (ID: 6) est la mère de Jean Dupont (ID: 1)
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, StartDate, Notes, IsActive, CreatedAt) 
VALUES (6, 1, 1, '1950-01-01', 'Relation mère-fils', 1, NOW());

-- Relations grand-parent pour Pierre Dupont (ID: 4)
-- Paul Dupont (ID: 5) est le grand-père de Pierre Dupont (ID: 4)
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, StartDate, Notes, IsActive, CreatedAt) 
VALUES (5, 4, 5, '1985-01-01', 'Relation grand-père-petit-fils', 1, NOW());

-- Jeanne Dupont (ID: 6) est la grand-mère de Pierre Dupont (ID: 4)
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, StartDate, Notes, IsActive, CreatedAt) 
VALUES (6, 4, 5, '1985-01-01', 'Relation grand-mère-petit-fils', 1, NOW());

-- Relations de conjoint pour les grands-parents
-- Paul Dupont (ID: 5) est marié à Jeanne Dupont (ID: 6)
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, StartDate, Notes, IsActive, CreatedAt) 
VALUES (5, 6, 3, '1948-05-20', 'Mariage', 1, NOW());

-- Vérification des relations créées
SELECT 
    r.Id,
    p1.FirstName + ' ' + p1.LastName as Person1,
    p2.FirstName + ' ' + p2.LastName as Person2,
    CASE r.RelationshipType
        WHEN 1 THEN 'Parent'
        WHEN 2 THEN 'Child'
        WHEN 3 THEN 'Spouse'
        WHEN 4 THEN 'Sibling'
        WHEN 5 THEN 'Grandparent'
        WHEN 6 THEN 'Grandchild'
        ELSE 'Other'
    END as RelationshipType,
    r.StartDate,
    r.Notes
FROM Relationships r
JOIN Persons p1 ON r.Person1Id = p1.Id
JOIN Persons p2 ON r.Person2Id = p2.Id
ORDER BY r.RelationshipType, r.StartDate;

