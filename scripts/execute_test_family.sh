#!/bin/bash
# Script pour exécuter le script SQL de la famille de test

echo "Exécution du script SQL pour créer la famille de test..."
docker exec -i gegeDot-mysql mysql -u root -ppassword gegeDot < scripts/add_test_family_large.sql

echo ""
echo "Vérification de la création..."
docker exec gegeDot-mysql mysql -u root -ppassword gegeDot -e "SELECT Id, FirstName, LastName, MiddleName FROM Persons WHERE FirstName = 'Jean' AND LastName = 'TestFamille';"

echo ""
echo "Nombre total de personnes TestFamille:"
docker exec gegeDot-mysql mysql -u root -ppassword gegeDot -e "SELECT COUNT(*) AS total FROM Persons WHERE LastName = 'TestFamille';"

echo ""
echo "Nombre d'enfants:"
docker exec gegeDot-mysql mysql -u root -ppassword gegeDot -e "SELECT COUNT(*) AS enfants FROM Persons WHERE LastName = 'TestFamille' AND (MiddleName LIKE 'Fils%' OR MiddleName LIKE 'Fille%');"

echo ""
echo "Nombre de petits-enfants:"
docker exec gegeDot-mysql mysql -u root -ppassword gegeDot -e "SELECT COUNT(*) AS petits_enfants FROM Persons WHERE LastName = 'TestFamille' AND MiddleName LIKE 'Petit-enfant%';"

echo ""
echo "Script terminé!"
