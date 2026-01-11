-- Vérifier si les personnages de Game of Thrones sont dans la base de données

USE gegeDot;

-- Compter les personnages par famille
SELECT 
    LastName,
    COUNT(*) as nombre_personnes
FROM Persons 
WHERE LastName IN ('Stark', 'Lannister', 'Targaryen', 'Baratheon', 'Tully', 'Arryn')
GROUP BY LastName
ORDER BY nombre_personnes DESC;

-- Voir quelques personnages spécifiques
SELECT Id, FirstName, LastName, MiddleName, BirthDate, Gender
FROM Persons 
WHERE LastName IN ('Stark', 'Lannister', 'Targaryen', 'Baratheon')
ORDER BY LastName, FirstName
LIMIT 20;

-- Compter le total de relations
SELECT COUNT(*) as total_relations FROM Relationships;

-- Vérifier quelques relations spécifiques
SELECT 
    p1.FirstName as Person1_FirstName,
    p1.LastName as Person1_LastName,
    r.RelationshipType,
    p2.FirstName as Person2_FirstName,
    p2.LastName as Person2_LastName
FROM Relationships r
JOIN Persons p1 ON r.Person1Id = p1.Id
JOIN Persons p2 ON r.Person2Id = p2.Id
WHERE p1.LastName IN ('Stark', 'Lannister', 'Targaryen', 'Baratheon')
   OR p2.LastName IN ('Stark', 'Lannister', 'Targaryen', 'Baratheon')
LIMIT 10;
