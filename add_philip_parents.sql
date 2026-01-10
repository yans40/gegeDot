-- Script pour ajouter les parents de Philip Mountbatten
-- Andrew Greece (ID: 29) est le père de Philip (ID: 9)
-- Alice Battenberg (ID: 30) est la mère de Philip (ID: 9)

-- Ajouter la relation père-enfant (Andrew -> Philip)
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt, UpdatedAt)
VALUES (29, 9, 1, NOW(), NOW());

-- Ajouter la relation mère-enfant (Alice -> Philip)
INSERT INTO Relationships (Person1Id, Person2Id, RelationshipType, CreatedAt, UpdatedAt)
VALUES (30, 9, 1, NOW(), NOW());

-- Vérifier les relations créées
SELECT 
    r.Person1Id as ParentId,
    p1.FirstName as ParentFirstName,
    p1.LastName as ParentLastName,
    r.Person2Id as ChildId,
    p2.FirstName as ChildFirstName,
    p2.LastName as ChildLastName,
    r.RelationshipType
FROM Relationships r
JOIN Persons p1 ON r.Person1Id = p1.Id
JOIN Persons p2 ON r.Person2Id = p2.Id
WHERE r.Person2Id = 9; -- Relations où Philip est l'enfant





