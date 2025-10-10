#!/bin/bash

# Script pour créer les issues GitHub pour GegeDot
# Usage: ./scripts/create_issues.sh

set -e

# Configuration
REPO_OWNER="yans40"  # À adapter selon votre organisation
REPO_NAME="gegeDot"
GITHUB_TOKEN=""  # À définir

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Création des issues GitHub pour GegeDot${NC}"
echo "=================================================="

# Vérifier que le token GitHub est défini
if [ -z "$GITHUB_TOKEN" ]; then
    echo -e "${RED}❌ Erreur: GITHUB_TOKEN n'est pas défini${NC}"
    echo "Définissez votre token GitHub :"
    echo "export GITHUB_TOKEN=your_token_here"
    exit 1
fi

# Fonction pour créer une issue
create_issue() {
    local title="$1"
    local body="$2"
    local labels="$3"
    local assignee="$4"
    
    echo -e "${YELLOW}📝 Création de l'issue: $title${NC}"
    
    # Créer l'issue via l'API GitHub
    response=$(curl -s -X POST \
        -H "Authorization: token $GITHUB_TOKEN" \
        -H "Accept: application/vnd.github.v3+json" \
        "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/issues" \
        -d "{
            \"title\": \"$title\",
            \"body\": \"$body\",
            \"labels\": [$labels],
            \"assignee\": \"$assignee\"
        }")
    
    # Vérifier la réponse
    if echo "$response" | grep -q '"number"'; then
        issue_number=$(echo "$response" | grep '"number"' | head -1 | sed 's/.*"number": \([0-9]*\).*/\1/')
        echo -e "${GREEN}✅ Issue créée: #$issue_number${NC}"
    else
        echo -e "${RED}❌ Erreur lors de la création de l'issue${NC}"
        echo "$response"
    fi
}

# Issue 1: Code Review Request
create_issue \
    "🔍 Demande de revue de code complète" \
    "## Description
Le projet GegeDot a atteint un stade de maturité suffisant pour une revue de code complète. Cette revue doit couvrir :

- Architecture backend (.NET 9)
- Code frontend (HTML/JS) 
- Base de données (MySQL)
- Infrastructure (Docker)
- Tests et documentation

## Critères d'acceptation
- [ ] Revue backend complète
- [ ] Revue frontend complète  
- [ ] Rapport de revue détaillé
- [ ] Plan d'action pour les améliorations
- [ ] Score de qualité attribué

## Fichiers de référence
- \`PROJECT_STATUS_REVIEW.md\`
- \`CODE_REVIEW_CHECKLIST.md\`
- \`ISSUES_ACTION_PLAN.md\`

## Assigné à
À définir

## Deadline
À définir" \
    "\"review\", \"code-quality\", \"architecture\", \"high-priority\"" \
    ""

# Issue 2: Zoom Controls Fix
create_issue \
    "🔧 Correction des contrôles de zoom" \
    "## Description
Les boutons de zoom dans la visualisation hiérarchique ne fonctionnent pas correctement. Les fonctions zoomIn(), zoomOut(), resetZoom() et centerOnMain() sont implémentées mais les event listeners ne se déclenchent pas.

## Fichiers concernés
- \`frontend/hierarchical-tree-visualization.html\`

## Steps to Reproduce
1. Ouvrir la visualisation hiérarchique
2. Cliquer sur les boutons de zoom
3. Observer que rien ne se passe

## Expected Behavior
- Bouton \"Zoom In\" : Augmente le zoom
- Bouton \"Zoom Out\" : Diminue le zoom  
- Bouton \"Reset Zoom\" : Remet le zoom à 1x
- Bouton \"Center Main\" : Centre sur la personne principale

## Actual Behavior
Les boutons ne répondent pas aux clics.

## Critères d'acceptation
- [ ] Bouton \"Zoom In\" fonctionnel
- [ ] Bouton \"Zoom Out\" fonctionnel
- [ ] Bouton \"Reset Zoom\" fonctionnel
- [ ] Bouton \"Center Main\" fonctionnel
- [ ] Tests manuels validés

## Assigné à
À définir

## Deadline
À définir" \
    "\"bug\", \"frontend\", \"visualization\", \"medium-priority\"" \
    ""

# Issue 3: Test Coverage Improvement
create_issue \
    "🧪 Amélioration de la couverture de tests" \
    "## Description
La couverture de tests du backend est insuffisante. Il faut ajouter :

- Tests unitaires pour tous les services
- Tests d'intégration pour les endpoints
- Tests de validation des DTOs
- Tests de performance

## User Story
En tant que développeur, je veux une couverture de tests complète afin d'assurer la qualité et la fiabilité du code.

## Critères d'acceptation
- [ ] Couverture de tests > 80%
- [ ] Tests unitaires pour PersonService
- [ ] Tests unitaires pour RelationshipService
- [ ] Tests d'intégration pour les controllers
- [ ] Tests de validation des DTOs
- [ ] Tests de performance

## Fichiers concernés
- \`backend/tests/GegeDot.Tests/\`
- \`backend/src/GegeDot.Services/\`
- \`backend/src/GegeDot.API/Controllers/\`

## Assigné à
À définir

## Deadline
À définir" \
    "\"testing\", \"quality\", \"backend\", \"medium-priority\"" \
    ""

# Issue 4: Mobile Responsiveness
create_issue \
    "📱 Optimisation mobile et responsive design" \
    "## Description
L'interface actuelle nécessite des améliorations pour une meilleure expérience mobile :

- Optimisation des visualisations pour petits écrans
- Amélioration de la navigation tactile
- Adaptation des contrôles de zoom
- Optimisation des formulaires

## User Story
En tant qu'utilisateur mobile, je veux une interface adaptée à mon écran afin d'utiliser l'application confortablement.

## Critères d'acceptation
- [ ] Interface responsive sur mobile
- [ ] Visualisations adaptées aux petits écrans
- [ ] Navigation tactile optimisée
- [ ] Tests sur différents appareils
- [ ] Performance mobile acceptable

## Fichiers concernés
- \`frontend/hierarchical-tree-visualization.html\`
- \`frontend/family.html\`
- \`frontend/person-management.html\`

## Assigné à
À définir

## Deadline
À définir" \
    "\"frontend\", \"mobile\", \"ux\", \"medium-priority\"" \
    ""

# Issue 5: Authentication System
create_issue \
    "🔐 Implémentation du système d'authentification" \
    "## Description
Ajouter un système d'authentification pour sécuriser l'application :

- Authentification JWT
- Gestion des utilisateurs
- Protection des endpoints
- Interface de connexion

## User Story
En tant qu'administrateur, je veux un système d'authentification afin de sécuriser l'accès à l'application.

## Critères d'acceptation
- [ ] Authentification JWT implémentée
- [ ] Endpoints protégés
- [ ] Interface de connexion
- [ ] Gestion des rôles utilisateur
- [ ] Tests de sécurité

## Fichiers concernés
- \`backend/src/GegeDot.API/\`
- \`backend/src/GegeDot.Core/Entities/\`
- \`frontend/\`

## Assigné à
À définir

## Deadline
À définir" \
    "\"security\", \"backend\", \"feature\", \"low-priority\"" \
    ""

echo -e "${GREEN}🎉 Toutes les issues ont été créées avec succès !${NC}"
echo ""
echo -e "${BLUE}📋 Prochaines étapes :${NC}"
echo "1. Assigner les issues aux développeurs appropriés"
echo "2. Définir les deadlines"
echo "3. Commencer la revue de code"
echo "4. Suivre le plan d'action dans ISSUES_ACTION_PLAN.md"
echo ""
echo -e "${YELLOW}💡 Conseil : Utilisez les templates dans ISSUES_ACTION_PLAN.md pour créer d'autres issues si nécessaire.${NC}"
