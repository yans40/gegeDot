# 🌐 Guide de Test Local - GegeDot

## 🚀 **Services Disponibles en Local**

### ✅ **Backend API (.NET Core)**
- **URL:** http://localhost:5000
- **API Endpoints:** http://localhost:5000/api/persons
- **Status:** ✅ Fonctionnel
- **Données:** 5 personnes dans la base de données

### ✅ **Frontend de Test (HTML/JavaScript)**
- **URL:** http://localhost:3001/test.html
- **Status:** ✅ Fonctionnel
- **Fonctionnalités:**
  - Charger et afficher les personnes
  - Créer de nouvelles personnes
  - Interface utilisateur simple et claire

### ✅ **Base de Données MySQL**
- **Port:** 3306
- **Status:** ✅ Fonctionnel
- **Données:** 5 personnes stockées

### ✅ **phpMyAdmin (Gestion BDD)**
- **URL:** http://localhost:8080
- **Status:** ✅ Fonctionnel
- **Login:** gegedot / password

## 🎯 **Comment Tester**

### 1. **Ouvrir le Frontend de Test**
```
http://localhost:3001/test.html
```

### 2. **Fonctionnalités Disponibles**
- **"Charger les personnes"** - Affiche toutes les personnes de la base
- **"Créer une personne test"** - Ajoute une nouvelle personne
- **"Effacer"** - Nettoie l'affichage

### 3. **Test de l'API Directement**
```bash
# Voir toutes les personnes
curl http://localhost:5000/api/persons

# Créer une personne
curl -X POST http://localhost:5000/api/persons \
  -H "Content-Type: application/json" \
  -d '{"firstName":"Test","lastName":"User","gender":"Male","birthDate":"1990-01-01"}'
```

## 📊 **Données Actuelles**

### Personnes dans la Base (5 total):
1. **Jean Dupont** (Male, 75 ans) - Paris, France
2. **Sophie Bernard** (Female, 40 ans) - Marseille, France  
3. **Pierre Moreau** (Male, 35 ans) - Toulouse, France
4. **Test Frontend** (Other, 35 ans) - Test City
5. **Personne vide** (Other) - Données de test

## 🎨 **Interface de Test**

L'interface de test inclut :
- **Design moderne** avec Material Design
- **Couleurs par genre** (Bleu=Male, Rose=Female, Violet=Other)
- **Affichage des détails** (âge, lieu de naissance, biographie)
- **Messages de statut** (succès, erreur, chargement)
- **Gestion d'erreurs** complète

## 🔧 **Dépannage**

### Si le frontend ne se charge pas :
```bash
# Vérifier que le serveur Python fonctionne
curl http://localhost:3001/test.html
```

### Si l'API ne répond pas :
```bash
# Vérifier que l'API backend fonctionne
curl http://localhost:5000/api/persons
```

### Si la base de données ne fonctionne pas :
```bash
# Vérifier les conteneurs Docker
docker ps
```

## 🎉 **Résultat Attendu**

Quand vous ouvrez http://localhost:3001/test.html, vous devriez voir :
1. Une page avec le titre "🌳 GegeDot - Test Frontend"
2. Trois boutons : "Charger les personnes", "Créer une personne test", "Effacer"
3. En cliquant sur "Charger les personnes", vous verrez les 5 personnes affichées avec leurs détails

## 🚀 **Prochaines Étapes**

1. ✅ **Issue #1** - Gender column - RÉSOLU
2. ✅ **Issue #2** - API testing - TERMINÉ  
3. ✅ **Issue #3** - Frontend setup - TERMINÉ
4. 🔄 **Issue #4** - Tree visualization - EN ATTENTE
5. 🔄 **Issue #5** - Production deployment - EN ATTENTE

---

**Le projet GegeDot fonctionne parfaitement en local ! 🎯**

