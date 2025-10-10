#!/bin/bash

# Script de lancement de l'application GegeDot
# Usage: ./scripts/start_application.sh

set -e

# Configuration
BACKEND_PORT=5001
FRONTEND_PORT=3004
BACKEND_DIR="backend/src/GegeDot.API"
FRONTEND_DIR="frontend"

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Lancement de l'Application GegeDot${NC}"
echo "=============================================="

# Fonction pour vérifier si un port est utilisé
check_port() {
    local port=$1
    if lsof -i :$port >/dev/null 2>&1; then
        return 0  # Port utilisé
    else
        return 1  # Port libre
    fi
}

# Fonction pour tuer un processus sur un port
kill_port() {
    local port=$1
    local pid=$(lsof -ti :$port)
    if [ ! -z "$pid" ]; then
        echo -e "${YELLOW}Arrêt du processus sur le port $port (PID: $pid)${NC}"
        kill $pid
        sleep 2
    fi
}

# Vérifier et arrêter les processus existants
echo -e "${YELLOW}🔍 Vérification des ports...${NC}"

if check_port $BACKEND_PORT; then
    echo -e "${YELLOW}Port $BACKEND_PORT déjà utilisé${NC}"
    kill_port $BACKEND_PORT
fi

if check_port $FRONTEND_PORT; then
    echo -e "${YELLOW}Port $FRONTEND_PORT déjà utilisé${NC}"
    kill_port $FRONTEND_PORT
fi

# Démarrer le backend
echo -e "${BLUE}🏗️ Démarrage du Backend (.NET)${NC}"
echo "Port: $BACKEND_PORT"
echo "Répertoire: $BACKEND_DIR"

cd $BACKEND_DIR
echo -e "${YELLOW}Compilation et démarrage du backend...${NC}"
dotnet run --urls=http://localhost:$BACKEND_PORT &
BACKEND_PID=$!

# Attendre que le backend démarre
echo -e "${YELLOW}Attente du démarrage du backend...${NC}"
sleep 10

# Vérifier que le backend fonctionne
if curl -s http://localhost:$BACKEND_PORT/api/persons >/dev/null 2>&1; then
    echo -e "${GREEN}✅ Backend démarré avec succès${NC}"
else
    echo -e "${RED}❌ Erreur lors du démarrage du backend${NC}"
    exit 1
fi

# Retourner au répertoire racine
cd - >/dev/null

# Démarrer le frontend
echo -e "${BLUE}🎨 Démarrage du Frontend (Python)${NC}"
echo "Port: $FRONTEND_PORT"
echo "Répertoire: $FRONTEND_DIR"

cd $FRONTEND_DIR
echo -e "${YELLOW}Démarrage du serveur frontend...${NC}"
python3 -m http.server $FRONTEND_PORT &
FRONTEND_PID=$!

# Attendre que le frontend démarre
echo -e "${YELLOW}Attente du démarrage du frontend...${NC}"
sleep 3

# Vérifier que le frontend fonctionne
if curl -s http://localhost:$FRONTEND_PORT/hierarchical-tree-visualization.html >/dev/null 2>&1; then
    echo -e "${GREEN}✅ Frontend démarré avec succès${NC}"
else
    echo -e "${RED}❌ Erreur lors du démarrage du frontend${NC}"
    exit 1
fi

# Retourner au répertoire racine
cd - >/dev/null

# Afficher les informations de l'application
echo -e "\n${GREEN}🎉 Application GegeDot lancée avec succès !${NC}"
echo "=============================================="
echo -e "${BLUE}📊 Statut des services:${NC}"
echo -e "  Backend (.NET):  ${GREEN}✅ Actif${NC} - http://localhost:$BACKEND_PORT"
echo -e "  Frontend:        ${GREEN}✅ Actif${NC} - http://localhost:$FRONTEND_PORT"
echo -e "  API:             ${GREEN}✅ Actif${NC} - http://localhost:$BACKEND_PORT/api/persons"
echo -e "  Swagger:         ${GREEN}✅ Actif${NC} - http://localhost:$BACKEND_PORT/swagger"

echo -e "\n${BLUE}🌐 URLs d'accès:${NC}"
echo -e "  ${YELLOW}Visualisation Hiérarchique:${NC} http://localhost:$FRONTEND_PORT/hierarchical-tree-visualization.html"
echo -e "  ${YELLOW}Gestion des Personnes:${NC}      http://localhost:$FRONTEND_PORT/person-management.html"
echo -e "  ${YELLOW}Visualisation par Cartes:${NC}   http://localhost:$FRONTEND_PORT/family.html"

echo -e "\n${BLUE}🧪 Tests rapides:${NC}"
echo -e "  ${YELLOW}Test Backend:${NC} curl http://localhost:$BACKEND_PORT/api/persons"
echo -e "  ${YELLOW}Test Frontend:${NC} curl http://localhost:$FRONTEND_PORT/hierarchical-tree-visualization.html"

echo -e "\n${BLUE}📋 Données disponibles:${NC}"
echo -e "  ${YELLOW}Famille Royale Britannique:${NC} Elizabeth II, Charles III, Philip, etc."
echo -e "  ${YELLOW}Famille Impériale Russe:${NC} Nicholas II, Alexander III"
echo -e "  ${YELLOW}Familles Françaises:${NC} Jean Dupont, Sophie Bernard, etc."
echo -e "  ${YELLOW}Relations:${NC} 17 relations familiales actives"

echo -e "\n${BLUE}🎯 Comment utiliser:${NC}"
echo -e "  1. ${YELLOW}Ouvrir${NC} http://localhost:$FRONTEND_PORT/hierarchical-tree-visualization.html"
echo -e "  2. ${YELLOW}Sélectionner${NC} une personne dans le dropdown (ex: 'Charles Windsor')"
echo -e "  3. ${YELLOW}Observer${NC} l'arbre hiérarchique qui se génère"
echo -e "  4. ${YELLOW}Survoler${NC} les nœuds pour voir les relations"
echo -e "  5. ${YELLOW}Naviguer${NC} vers les autres pages"

echo -e "\n${BLUE}🛑 Pour arrêter l'application:${NC}"
echo -e "  ${YELLOW}Ctrl+C${NC} ou exécuter: ./scripts/stop_application.sh"

echo -e "\n${GREEN}🚀 Application prête à être utilisée !${NC}"

# Garder le script en vie pour maintenir les processus
echo -e "\n${YELLOW}Appuyez sur Ctrl+C pour arrêter l'application...${NC}"
trap 'echo -e "\n${YELLOW}Arrêt de l\'application...${NC}"; kill $BACKEND_PID $FRONTEND_PID 2>/dev/null; exit 0' INT

# Attendre indéfiniment
while true; do
    sleep 1
done
