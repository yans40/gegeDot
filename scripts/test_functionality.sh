#!/bin/bash

# Script de test des fonctionnalités GegeDot
# Usage: ./scripts/test_functionality.sh

set -e

# Configuration
BACKEND_URL="http://localhost:5001"
FRONTEND_URL="http://localhost:3003"

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🧪 Test des Fonctionnalités GegeDot${NC}"
echo "=================================================="

# Fonction pour tester un endpoint
test_endpoint() {
    local name="$1"
    local url="$2"
    local expected_status="$3"
    
    echo -n "Testing $name... "
    
    if response=$(curl -s -w "%{http_code}" -o /tmp/response.json "$url" 2>/dev/null); then
        status_code="${response: -3}"
        if [ "$status_code" = "$expected_status" ]; then
            echo -e "${GREEN}✅ PASS${NC} (Status: $status_code)"
            return 0
        else
            echo -e "${RED}❌ FAIL${NC} (Expected: $expected_status, Got: $status_code)"
            return 1
        fi
    else
        echo -e "${RED}❌ FAIL${NC} (Connection error)"
        return 1
    fi
}

# Fonction pour tester le contenu JSON
test_json_content() {
    local name="$1"
    local url="$2"
    local expected_field="$3"
    
    echo -n "Testing $name content... "
    
    if response=$(curl -s "$url" 2>/dev/null); then
        if echo "$response" | jq -e ".$expected_field" >/dev/null 2>&1; then
            echo -e "${GREEN}✅ PASS${NC} (Field '$expected_field' found)"
            return 0
        else
            echo -e "${RED}❌ FAIL${NC} (Field '$expected_field' not found)"
            return 1
        fi
    else
        echo -e "${RED}❌ FAIL${NC} (JSON parsing error)"
        return 1
    fi
}

# Compteurs
total_tests=0
passed_tests=0

# Test 1: Backend Health Check
echo -e "\n${YELLOW}🔍 Backend API Tests${NC}"
echo "-------------------"

test_endpoint "Backend Health" "$BACKEND_URL/api/persons" "200"
((total_tests++))
if [ $? -eq 0 ]; then ((passed_tests++)); fi

# Test 2: Persons Endpoint
test_endpoint "Persons List" "$BACKEND_URL/api/persons" "200"
((total_tests++))
if [ $? -eq 0 ]; then ((passed_tests++)); fi

test_json_content "Persons JSON" "$BACKEND_URL/api/persons" "0"
((total_tests++))
if [ $? -eq 0 ]; then ((passed_tests++)); fi

# Test 3: Specific Person
test_endpoint "Person by ID" "$BACKEND_URL/api/persons/10" "200"
((total_tests++))
if [ $? -eq 0 ]; then ((passed_tests++)); fi

test_json_content "Person JSON" "$BACKEND_URL/api/persons/10" "id"
((total_tests++))
if [ $? -eq 0 ]; then ((passed_tests++)); fi

# Test 4: Relationships
test_endpoint "Relationships List" "$BACKEND_URL/api/relationships" "200"
((total_tests++))
if [ $? -eq 0 ]; then ((passed_tests++)); fi

test_json_content "Relationships JSON" "$BACKEND_URL/api/relationships" "0"
((total_tests++))
if [ $? -eq 0 ]; then ((passed_tests++)); fi

# Test 5: Family Relationships
test_endpoint "Parents" "$BACKEND_URL/api/persons/10/parents" "200"
((total_tests++))
if [ $? -eq 0 ]; then ((passed_tests++)); fi

test_endpoint "Children" "$BACKEND_URL/api/persons/8/children" "200"
((total_tests++))
if [ $? -eq 0 ]; then ((passed_tests++)); fi

test_endpoint "Siblings" "$BACKEND_URL/api/persons/16/siblings" "200"
((total_tests++))
if [ $? -eq 0 ]; then ((passed_tests++)); fi

# Test 6: Frontend Pages
echo -e "\n${YELLOW}🎨 Frontend Tests${NC}"
echo "----------------"

test_endpoint "Hierarchical Visualization" "$FRONTEND_URL/hierarchical-tree-visualization.html" "200"
((total_tests++))
if [ $? -eq 0 ]; then ((passed_tests++)); fi

test_endpoint "Person Management" "$FRONTEND_URL/person-management.html" "200"
((total_tests++))
if [ $? -eq 0 ]; then ((passed_tests++)); fi

test_endpoint "Family Cards" "$FRONTEND_URL/family.html" "200"
((total_tests++))
if [ $? -eq 0 ]; then ((passed_tests++)); fi

# Test 7: Data Quality
echo -e "\n${YELLOW}📊 Data Quality Tests${NC}"
echo "----------------------"

# Test des données de la famille royale
echo -n "Testing Royal Family data... "
if curl -s "$BACKEND_URL/api/persons" | jq -e '.[] | select(.lastName == "Windsor")' >/dev/null 2>&1; then
    echo -e "${GREEN}✅ PASS${NC} (Royal family found)"
    ((passed_tests++))
else
    echo -e "${RED}❌ FAIL${NC} (Royal family not found)"
fi
((total_tests++))

# Test des relations
echo -n "Testing Family relationships... "
if curl -s "$BACKEND_URL/api/relationships" | jq -e '.[] | select(.relationshipTypeName == "Parent")' >/dev/null 2>&1; then
    echo -e "${GREEN}✅ PASS${NC} (Parent relationships found)"
    ((passed_tests++))
else
    echo -e "${RED}❌ FAIL${NC} (Parent relationships not found)"
fi
((total_tests++))

# Test 8: CRUD Operations (Read-only pour la sécurité)
echo -e "\n${YELLOW}🔧 CRUD Tests (Read-only)${NC}"
echo "---------------------------"

# Test de recherche
test_endpoint "Search Persons" "$BACKEND_URL/api/persons/search?q=Charles" "200"
((total_tests++))
if [ $? -eq 0 ]; then ((passed_tests++)); fi

# Test des relations avec une personne spécifique
test_endpoint "Person with Relationships" "$BACKEND_URL/api/persons/10/relationships" "200"
((total_tests++))
if [ $? -eq 0 ]; then ((passed_tests++)); fi

# Résumé des tests
echo -e "\n${BLUE}📊 Résumé des Tests${NC}"
echo "=================="
echo -e "Tests exécutés: ${BLUE}$total_tests${NC}"
echo -e "Tests réussis: ${GREEN}$passed_tests${NC}"
echo -e "Tests échoués: ${RED}$((total_tests - passed_tests))${NC}"

# Calcul du pourcentage
if [ $total_tests -gt 0 ]; then
    percentage=$((passed_tests * 100 / total_tests))
    echo -e "Taux de réussite: ${BLUE}$percentage%${NC}"
    
    if [ $percentage -ge 90 ]; then
        echo -e "\n${GREEN}🎉 EXCELLENT! Application entièrement fonctionnelle!${NC}"
    elif [ $percentage -ge 80 ]; then
        echo -e "\n${YELLOW}✅ BON! Application largement fonctionnelle!${NC}"
    elif [ $percentage -ge 70 ]; then
        echo -e "\n${YELLOW}⚠️ MOYEN! Quelques problèmes à corriger!${NC}"
    else
        echo -e "\n${RED}❌ PROBLÈME! Application nécessite des corrections!${NC}"
    fi
else
    echo -e "\n${RED}❌ Aucun test exécuté!${NC}"
fi

# Informations sur les services
echo -e "\n${BLUE}🔗 Services Disponibles${NC}"
echo "======================"
echo -e "Backend API: ${GREEN}$BACKEND_URL${NC}"
echo -e "Frontend: ${GREEN}$FRONTEND_URL${NC}"
echo -e "Visualisation hiérarchique: ${GREEN}$FRONTEND_URL/hierarchical-tree-visualization.html${NC}"
echo -e "Gestion des personnes: ${GREEN}$FRONTEND_URL/person-management.html${NC}"
echo -e "Visualisation par cartes: ${GREEN}$FRONTEND_URL/family.html${NC}"

# Instructions d'utilisation
echo -e "\n${BLUE}🚀 Instructions d'Utilisation${NC}"
echo "=========================="
echo "1. Ouvrir http://localhost:3003/hierarchical-tree-visualization.html"
echo "2. Sélectionner une personne dans le dropdown"
echo "3. Explorer l'arbre généalogique"
echo "4. Survoler les nœuds pour voir les relations"
echo "5. Utiliser les autres pages pour gérer les données"

echo -e "\n${GREEN}✅ Test terminé!${NC}"
