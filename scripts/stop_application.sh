#!/bin/bash

# Script d'arrêt de l'application GegeDot
# Usage: ./scripts/stop_application.sh

set -e

# Configuration
BACKEND_PORT=5001
FRONTEND_PORT=3004

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🛑 Arrêt de l'Application GegeDot${NC}"
echo "====================================="

# Fonction pour arrêter un processus sur un port
stop_port() {
    local port=$1
    local service_name=$2
    
    echo -n "Arrêt de $service_name (port $port)... "
    
    local pid=$(lsof -ti :$port)
    if [ ! -z "$pid" ]; then
        kill $pid 2>/dev/null
        sleep 2
        
        # Vérifier si le processus est toujours en vie
        if kill -0 $pid 2>/dev/null; then
            echo -e "${YELLOW}Force kill...${NC}"
            kill -9 $pid 2>/dev/null
        fi
        
        echo -e "${GREEN}✅ Arrêté${NC}"
    else
        echo -e "${YELLOW}⚠️ Aucun processus trouvé${NC}"
    fi
}

# Arrêter le frontend
stop_port $FRONTEND_PORT "Frontend"

# Arrêter le backend
stop_port $BACKEND_PORT "Backend"

# Arrêter tous les processus dotnet liés à GegeDot
echo -n "Arrêt des processus .NET GegeDot... "
pkill -f "dotnet.*GegeDot" 2>/dev/null || true
echo -e "${GREEN}✅ Arrêté${NC}"

# Arrêter tous les serveurs Python sur les ports utilisés
echo -n "Arrêt des serveurs Python... "
pkill -f "python3.*http.server.*300[0-9]" 2>/dev/null || true
echo -e "${GREEN}✅ Arrêté${NC}"

echo -e "\n${GREEN}🎉 Application GegeDot arrêtée avec succès !${NC}"

# Vérifier que les ports sont libres
echo -e "\n${BLUE}🔍 Vérification des ports:${NC}"
if lsof -i :$BACKEND_PORT >/dev/null 2>&1; then
    echo -e "  Backend (port $BACKEND_PORT): ${RED}❌ Toujours utilisé${NC}"
else
    echo -e "  Backend (port $BACKEND_PORT): ${GREEN}✅ Libre${NC}"
fi

if lsof -i :$FRONTEND_PORT >/dev/null 2>&1; then
    echo -e "  Frontend (port $FRONTEND_PORT): ${RED}❌ Toujours utilisé${NC}"
else
    echo -e "  Frontend (port $FRONTEND_PORT): ${GREEN}✅ Libre${NC}"
fi

echo -e "\n${BLUE}🚀 Pour relancer l'application:${NC}"
echo -e "  ${YELLOW}./scripts/start_application.sh${NC}"
