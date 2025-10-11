#!/bin/bash

# Script pour créer les issues de la version beta sur GitHub
# Usage: ./scripts/create_beta_issues.sh

set -e

# Configuration
REPO_OWNER="yans40"
REPO_NAME="gegeDot"
GITHUB_TOKEN="${GITHUB_TOKEN:-}"

if [ -z "$GITHUB_TOKEN" ]; then
    echo "❌ Erreur: GITHUB_TOKEN n'est pas défini"
    echo "Définissez votre token GitHub: export GITHUB_TOKEN=your_token"
    exit 1
fi

# Fonction pour créer une issue
create_issue() {
    local title="$1"
    local body="$2"
    local labels="$3"
    
    echo "📝 Création de l'issue: $title"
    
    curl -X POST \
        -H "Authorization: token $GITHUB_TOKEN" \
        -H "Accept: application/vnd.github.v3+json" \
        "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/issues" \
        -d "{
            \"title\": \"$title\",
            \"body\": \"$body\",
            \"labels\": [$labels]
        }" | jq -r '.html_url'
}

echo "🚀 Création des issues pour la version beta..."

# Issue #1: Amélioration de la Récupération des Grands-Parents
create_issue \
"feat: Amélioration de la récupération des grands-parents" \
"## 📋 Description

Actuellement, seules 2 générations sont affichées. Implémenter la récupération automatique des grands-parents et petits-enfants pour avoir 3-4 générations.

## ✅ Acceptance Criteria

- [ ] Récupération automatique des parents des parents (grands-parents)
- [ ] Récupération automatique des enfants des enfants (petits-enfants)
- [ ] Affichage de 3-4 générations dans le layout hiérarchique
- [ ] Liens corrects entre toutes les générations
- [ ] Performance optimisée pour les familles étendues

## 🔧 Technical Notes

- Modifier \`buildTreeData()\` pour faire des appels API récursifs
- Ajuster \`calculateHierarchicalPositions()\` pour plus de niveaux
- Gérer les cas de familles très étendues

## 🏷️ Labels
- enhancement
- high-priority
- frontend
- api" \
'"enhancement","high-priority","frontend","api"'

# Issue #2: Amélioration du Design et de l'UX
create_issue \
"feat: Amélioration du design et de l'UX" \
"## 📋 Description

Améliorer l'apparence visuelle et l'expérience utilisateur de la visualisation.

## ✅ Acceptance Criteria

- [ ] Design moderne et professionnel
- [ ] Animations fluides pour les transitions
- [ ] Couleurs cohérentes et accessibles
- [ ] Tooltips enrichis avec plus d'informations
- [ ] Responsive design pour mobile/tablet
- [ ] Légende interactive et claire

## 🔧 Technical Notes

- Améliorer le CSS avec des gradients et ombres
- Ajouter des transitions CSS pour les animations
- Implémenter un design responsive
- Enrichir les tooltips avec photos, dates, etc.

## 🏷️ Labels
- enhancement
- medium-priority
- frontend
- ux" \
'"enhancement","medium-priority","frontend","ux"'

# Issue #3: Fonctionnalités d'Export et de Partage
create_issue \
"feat: Fonctionnalités d'export et de partage" \
"## 📋 Description

Permettre aux utilisateurs d'exporter et partager leurs arbres généalogiques.

## ✅ Acceptance Criteria

- [ ] Export en SVG haute qualité
- [ ] Export en PNG/JPEG
- [ ] Export en PDF avec mise en page
- [ ] Partage par URL unique
- [ ] Sauvegarde locale des arbres
- [ ] Import/Export de données GEDCOM

## 🔧 Technical Notes

- Utiliser \`html2canvas\` pour les exports image
- Implémenter \`jsPDF\` pour les exports PDF
- Créer un système de sauvegarde local avec localStorage
- Parser/encoder GEDCOM pour l'interopérabilité

## 🏷️ Labels
- feature
- medium-priority
- frontend
- export" \
'"feature","medium-priority","frontend","export"'

# Issue #4: Recherche et Filtrage Avancés
create_issue \
"feat: Recherche et filtrage avancés" \
"## 📋 Description

Ajouter des fonctionnalités de recherche et de filtrage pour naviguer dans les arbres complexes.

## ✅ Acceptance Criteria

- [ ] Recherche par nom, prénom, date de naissance
- [ ] Filtrage par génération, genre, statut (vivant/décédé)
- [ ] Navigation rapide vers une personne spécifique
- [ ] Historique de navigation
- [ ] Suggestions de recherche intelligentes

## 🔧 Technical Notes

- Implémenter une barre de recherche avec debouncing
- Créer des filtres dynamiques
- Ajouter un système de navigation breadcrumb
- Utiliser localStorage pour l'historique

## 🏷️ Labels
- feature
- medium-priority
- frontend
- search" \
'"feature","medium-priority","frontend","search"'

# Issue #5: Gestion des Relations Complexes
create_issue \
"feat: Gestion des relations complexes" \
"## 📋 Description

Étendre le support des relations familiales au-delà des relations de base.

## ✅ Acceptance Criteria

- [ ] Support des mariages et divorces
- [ ] Relations d'adoption
- [ ] Relations de parrainage/marrainage
- [ ] Relations professionnelles
- [ ] Gestion des familles recomposées
- [ ] Relations multiples (plusieurs parents, etc.)

## 🔧 Technical Notes

- Étendre le modèle de données backend
- Modifier l'API pour supporter les relations complexes
- Adapter le frontend pour afficher ces relations
- Créer une interface de gestion des relations

## 🏷️ Labels
- enhancement
- high-priority
- backend
- frontend
- database" \
'"enhancement","high-priority","backend","frontend","database"'

# Issue #6: Performance et Optimisation
create_issue \
"perf: Performance et optimisation" \
"## 📋 Description

Optimiser les performances pour gérer des arbres généalogiques très étendus.

## ✅ Acceptance Criteria

- [ ] Lazy loading des générations
- [ ] Virtualisation des nœuds pour les grandes familles
- [ ] Cache intelligent des données API
- [ ] Compression des données
- [ ] Optimisation du rendu D3.js
- [ ] Tests de performance automatisés

## 🔧 Technical Notes

- Implémenter un système de pagination virtuelle
- Utiliser \`d3-zoom\` pour la performance
- Mettre en place un cache Redis côté backend
- Créer des benchmarks de performance

## 🏷️ Labels
- performance
- high-priority
- frontend
- backend
- optimization" \
'"performance","high-priority","frontend","backend","optimization"'

# Issue #7: Tests Automatisés et CI/CD
create_issue \
"ci: Tests automatisés et CI/CD" \
"## 📋 Description

Mettre en place une suite de tests complète et un pipeline CI/CD.

## ✅ Acceptance Criteria

- [ ] Tests unitaires pour le frontend (Jest/React Testing Library)
- [ ] Tests d'intégration pour l'API
- [ ] Tests end-to-end (Playwright/Cypress)
- [ ] Tests de performance automatisés
- [ ] Pipeline CI/CD avec GitHub Actions
- [ ] Déploiement automatique
- [ ] Monitoring et alertes

## 🔧 Technical Notes

- Configurer Jest pour les tests frontend
- Implémenter des tests API avec Supertest
- Créer des tests E2E avec Playwright
- Mettre en place GitHub Actions
- Configurer le déploiement sur Railway/Netlify

## 🏷️ Labels
- ci/cd
- high-priority
- testing
- devops
- github-actions" \
'"ci/cd","high-priority","testing","devops","github-actions"'

# Issue #8: Documentation et Guides
create_issue \
"docs: Documentation et guides" \
"## 📋 Description

Créer une documentation complète pour les utilisateurs et développeurs.

## ✅ Acceptance Criteria

- [ ] Guide utilisateur complet
- [ ] Documentation API avec Swagger
- [ ] Guide de contribution pour les développeurs
- [ ] Tutoriels vidéo
- [ ] FAQ et dépannage
- [ ] Documentation de déploiement

## 🔧 Technical Notes

- Utiliser Docusaurus pour la documentation
- Configurer Swagger/OpenAPI
- Créer des guides markdown
- Enregistrer des tutoriels vidéo

## 🏷️ Labels
- documentation
- medium-priority
- docs
- guides" \
'"documentation","medium-priority","docs","guides"'

echo "✅ Toutes les issues ont été créées avec succès!"
echo "🔗 Vérifiez votre repository GitHub: https://github.com/$REPO_OWNER/$REPO_NAME/issues"
