# 🔍 Guide des GitHub Actions pour la Revue de Code

## 🎯 Vue d'ensemble

Nous avons maintenant **3 workflows GitHub Actions** pour la revue de code :

1. **`code-review.yml`** - Revue automatique sur les Pull Requests
2. **`manual-review.yml`** - Revue manuelle déclenchée à la demande
3. **`ci.yml`** - Pipeline CI/CD mis à jour

## 🚀 Workflow 1 : Code Review Automatique

### 📋 Déclenchement
- **Pull Requests** vers `main` ou `develop`
- **Types d'événements** : `opened`, `synchronize`, `reopened`
- **Déclenchement manuel** : Via `workflow_dispatch`

### 🔧 Jobs inclus

#### 1. **Backend Code Review**
- ✅ **Tests** : Exécution avec couverture
- ✅ **Build** : Compilation .NET 9
- ✅ **Security** : Scan Snyk
- ✅ **Quality** : Analyse SonarQube
- ✅ **Coverage** : Rapport de couverture

#### 2. **Frontend Code Review**
- ✅ **Build** : Compilation React
- ✅ **Linting** : ESLint
- ✅ **Formatting** : Prettier
- ✅ **Tests** : Tests avec couverture
- ✅ **Security** : Scan Snyk
- ✅ **Performance** : Lighthouse CI

#### 3. **Security Review**
- ✅ **Vulnerabilities** : Scan Trivy
- ✅ **Static Analysis** : CodeQL
- ✅ **Dependencies** : Analyse des dépendances

#### 4. **Auto-assignment**
- ✅ **Reviewers** : Attribution automatique
- ✅ **Logic** : Basée sur les fichiers modifiés

### 📊 Rapports générés
- **Commentaires PR** : Résultats détaillés
- **Coverage** : Rapports de couverture
- **Security** : Vulnérabilités identifiées
- **Performance** : Métriques Lighthouse

## 🎯 Workflow 2 : Revue Manuelle

### 📋 Déclenchement
- **Workflow Dispatch** : Déclenchement manuel
- **Options** : Scope, priorité, assigné

### 🔧 Paramètres
- **Scope** : `full`, `backend`, `frontend`, `security`, `performance`
- **Priority** : `low`, `medium`, `high`, `critical`
- **Assignee** : Username GitHub (optionnel)

### 📝 Issue créée
- **Titre** : Basé sur le scope
- **Labels** : Automatiques
- **Checklist** : Complète selon le scope
- **Scoring** : Système 1-5
- **Action Items** : À remplir

## 🔄 Workflow 3 : CI/CD Pipeline

### 📋 Déclenchement
- **Push** : Vers `main` ou `develop`
- **Pull Request** : Vers `main` ou `develop` (mis à jour)

### 🔧 Jobs inclus
- **Backend Tests** : Tests .NET avec MySQL
- **Frontend Tests** : Tests React avec couverture
- **Build & Push** : Images Docker
- **Deploy** : Railway (backend) + Netlify (frontend)
- **Release** : Création automatique

## 🛠️ Configuration requise

### 🔑 Secrets GitHub
```bash
# Sécurité
SNYK_TOKEN=your_snyk_token
SONAR_TOKEN=your_sonarcloud_token

# Déploiement
DOCKER_USERNAME=your_docker_username
DOCKER_PASSWORD=your_docker_password
RAILWAY_TOKEN=your_railway_token
NETLIFY_AUTH_TOKEN=your_netlify_token
NETLIFY_SITE_ID=your_netlify_site_id
```

### 📊 Services externes
- **SonarCloud** : Analyse de qualité
- **Snyk** : Scan de sécurité
- **Codecov** : Couverture de code
- **Lighthouse CI** : Performance

## 🎯 Utilisation

### 1. **Revue automatique**
```bash
# Créer une Pull Request
git checkout -b feature/new-feature
git push origin feature/new-feature
# Créer PR sur GitHub → Workflow se déclenche automatiquement
```

### 2. **Revue manuelle**
```bash
# Sur GitHub → Actions → Manual Code Review
# Sélectionner les paramètres :
# - Scope: full
# - Priority: high
# - Assignee: username
```

### 3. **Vérifier les résultats**
- **Actions tab** : Voir l'exécution des workflows
- **Pull Request** : Commentaires automatiques
- **Issues** : Issues créées pour revue manuelle
- **Security tab** : Vulnérabilités identifiées

## 📊 Métriques et rapports

### 🔍 Backend Review
- **Coverage** : Pourcentage de couverture
- **Quality Gate** : SonarQube quality gate
- **Security** : Vulnérabilités Snyk
- **Performance** : Temps de build/test

### 🎨 Frontend Review
- **Performance** : Score Lighthouse
- **Accessibility** : Score d'accessibilité
- **Best Practices** : Bonnes pratiques
- **SEO** : Optimisation SEO

### 🔒 Security Review
- **Vulnerabilities** : Vulnérabilités identifiées
- **Dependencies** : Dépendances obsolètes
- **Static Analysis** : Analyse statique CodeQL

## 🎯 Exemples d'utilisation

### Exemple 1 : PR avec modifications backend
```bash
# Fichiers modifiés : backend/src/GegeDot.API/Controllers/
# Workflow déclenché : code-review.yml
# Reviewers assignés : backend-reviewer, security-reviewer
# Jobs exécutés : backend-code-review, security-review
```

### Exemple 2 : PR avec modifications frontend
```bash
# Fichiers modifiés : frontend/hierarchical-tree-visualization.html
# Workflow déclenché : code-review.yml
# Reviewers assignés : frontend-reviewer, security-reviewer
# Jobs exécutés : frontend-code-review, security-review
```

### Exemple 3 : Revue manuelle complète
```bash
# Déclenchement : workflow_dispatch
# Scope : full
# Priority : high
# Résultat : Issue créée avec checklist complète
```

## 🔧 Dépannage

### Erreur : "Secret not found"
```bash
# Vérifier que les secrets sont configurés dans GitHub
# Settings → Secrets and variables → Actions
```

### Erreur : "Workflow not triggered"
```bash
# Vérifier les branches dans on: pull_request: branches
# Vérifier que la PR est vers main ou develop
```

### Erreur : "Reviewer assignment failed"
```bash
# Vérifier que les usernames GitHub sont corrects
# Vérifier que les utilisateurs ont accès au repository
```

## 📈 Améliorations futures

### 🔄 Automatisation
- [ ] **Auto-merge** : Merge automatique si review approuvée
- [ ] **Slack notifications** : Notifications Slack
- [ ] **Email alerts** : Alertes email

### 📊 Métriques
- [ ] **Dashboard** : Tableau de bord des métriques
- [ ] **Trends** : Tendances de qualité
- [ ] **Reports** : Rapports hebdomadaires

### 🔧 Intégrations
- [ ] **Jira** : Intégration Jira
- [ ] **Teams** : Notifications Teams
- [ ] **Custom tools** : Outils personnalisés

---

**🎉 Les GitHub Actions pour la revue de code sont maintenant configurées !**

**Prochaines étapes :**
1. Configurer les secrets GitHub
2. Tester avec une Pull Request
3. Assigner les reviewers
4. Commencer la revue de code
