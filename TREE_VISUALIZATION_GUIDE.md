# 🌳 Guide de Visualisation des Arbres Généalogiques

## 📋 **Vue d'ensemble**

Ce guide présente la nouvelle fonctionnalité de visualisation avancée des arbres généalogiques avec D3.js et React.

## 🎯 **Fonctionnalités Implémentées**

### ✅ **Visualisation Interactive**
- **D3.js Integration** : Visualisation des arbres avec D3.js v7
- **Layouts multiples** : Vertical, Horizontal, Radial
- **Navigation interactive** : Zoom, Pan, Sélection de nœuds
- **Tooltips informatifs** : Détails des personnes au survol

### ✅ **Interface Utilisateur**
- **Material-UI** : Interface moderne et responsive
- **Contrôles intuitifs** : Sélection de personne, layout, profondeur
- **Statistiques familiales** : Compteurs et métriques
- **Export d'images** : SVG et PNG

### ✅ **Types de Relations**
- **Parent-Enfant** : Lien bleu solide
- **Mariage** : Lien rose en pointillés
- **Frères/Sœurs** : Lien violet
- **Couleurs par genre** : Bleu (Homme), Rose (Femme), Violet (Autre)

## 🚀 **Installation et Démarrage**

### **Option 1 : Interface HTML Simple (Recommandée pour test rapide)**

```bash
# Démarrer le backend
export DOTNET_ROOT="/usr/local/opt/dotnet/libexec"
cd backend/src/GegeDot.API
dotnet run --urls="http://localhost:5000"

# Dans un autre terminal, démarrer le serveur frontend
cd frontend
python3 -m http.server 3001

# Accéder à l'interface
# http://localhost:3001/tree-visualization.html
```

### **Option 2 : Application React Complète**

```bash
# Installer les dépendances Node.js
cd frontend
npm install

# Démarrer l'application React
npm start

# L'application sera disponible sur http://localhost:3000
```

## 🎨 **Interface de Visualisation**

### **Contrôles Principaux**
- **Personne racine** : Sélection de la personne centrale de l'arbre
- **Layout** : Choix entre Vertical, Horizontal, Radial
- **Profondeur** : Nombre de générations à afficher (2-5)
- **Zoom** : Boutons +, -, Reset pour la navigation

### **Fonctionnalités Interactives**
- **Clic sur nœud** : Centre l'arbre sur la personne sélectionnée
- **Survol** : Affiche les détails de la personne
- **Zoom/Pan** : Navigation fluide dans l'arbre
- **Export** : Sauvegarde en SVG ou PNG

## 📊 **Types de Layouts**

### **Layout Vertical (Défaut)**
```
    Grand-parent
        |
    Parent
        |
    Personne
        |
    Enfant
```

### **Layout Horizontal**
```
Grand-parent → Parent → Personne → Enfant
```

### **Layout Radial**
```
        Grand-parent
           |
    Parent - Personne - Enfant
           |
        Conjoint
```

## 🎯 **Exemples d'Utilisation**

### **1. Visualiser la Famille Royale Britannique**
```javascript
// Sélectionner Elizabeth Windsor (ID: 8)
// Layout: Vertical
// Profondeur: 3 générations
// Résultat: Arbre avec parents, enfants, conjoint
```

### **2. Explorer les Connexions Historiques**
```javascript
// Sélectionner Queen Victoria (ID: 15)
// Layout: Radial
// Profondeur: 4 générations
// Résultat: Connexions avec familles royales européennes
```

### **3. Analyser les Relations Familiales**
```javascript
// Sélectionner Nicholas II (ID: 13)
// Layout: Horizontal
// Profondeur: 2 générations
// Résultat: Lignée impériale russe
```

## 🔧 **API Endpoints Utilisés**

### **Chargement des Personnes**
```http
GET /api/persons
```

### **Données Familiales**
```http
GET /api/relationships/person/{id}/family
```

### **Exemple de Réponse**
```json
{
  "person": {
    "id": 8,
    "fullName": "Elizabeth Windsor",
    "gender": "Female",
    "isAlive": false
  },
  "parents": [...],
  "children": [...],
  "spouse": {...},
  "totalFamilyMembers": 5
}
```

## 🎨 **Personnalisation**

### **Couleurs des Nœuds**
```css
.node.male circle { fill: #4A90E2; }    /* Bleu pour hommes */
.node.female circle { fill: #E24A90; }  /* Rose pour femmes */
.node.other circle { fill: #9B59B6; }   /* Violet pour autre */
.node.deceased circle { opacity: 0.7; } /* Transparence pour décédés */
```

### **Styles des Liens**
```css
.link.marriage { stroke: #E24A90; stroke-dasharray: 5,5; }
.link.parent-child { stroke: #4A90E2; }
.link.sibling { stroke: #9B59B6; }
```

## 📱 **Responsive Design**

- **Desktop** : Interface complète avec tous les contrôles
- **Tablet** : Layout adaptatif avec contrôles simplifiés
- **Mobile** : Interface optimisée pour navigation tactile

## 🚀 **Fonctionnalités Avancées**

### **Export d'Images**
- **SVG** : Format vectoriel pour impression haute qualité
- **PNG** : Format raster pour partage et intégration

### **Navigation Temporelle**
- **Filtrage par dates** : Afficher seulement certaines périodes
- **Événements marquants** : Mise en évidence des dates importantes

### **Statistiques Familiales**
- **Compteurs** : Nombre de membres par catégorie
- **Métriques** : Âge moyen, longévité, etc.
- **Graphiques** : Visualisation des données familiales

## 🔍 **Dépannage**

### **Problèmes Courants**

#### **Backend non accessible**
```bash
# Vérifier que le backend est démarré
curl http://localhost:5000/api/persons

# Redémarrer si nécessaire
cd backend/src/GegeDot.API
dotnet run --urls="http://localhost:5000"
```

#### **Erreurs CORS**
```javascript
// Vérifier la configuration CORS dans Program.cs
builder.Services.AddCors(options => {
    options.AddPolicy("AllowReactApp", policy => {
        policy.WithOrigins("http://localhost:3000", "http://localhost:3001")
              .AllowAnyHeader()
              .AllowAnyMethod();
    });
});
```

#### **D3.js non chargé**
```html
<!-- Vérifier que D3.js est inclus -->
<script src="https://d3js.org/d3.v7.min.js"></script>
```

## 📈 **Prochaines Améliorations**

### **Phase 2 : Fonctionnalités Avancées**
- **Recherche dans l'arbre** : Filtrage par nom, date, lieu
- **Édition interactive** : Ajout/modification de relations
- **Import GEDCOM** : Chargement de fichiers généalogiques
- **Partage d'arbres** : URLs partageables

### **Phase 3 : Visualisations Avancées**
- **Timeline** : Chronologie des événements familiaux
- **Heatmap** : Densité géographique des naissances
- **Graphiques** : Statistiques et analyses familiales

## 🎉 **Conclusion**

La visualisation des arbres généalogiques est maintenant pleinement fonctionnelle avec :

- ✅ **Interface moderne** avec Material-UI
- ✅ **Visualisation interactive** avec D3.js
- ✅ **Navigation fluide** avec zoom/pan
- ✅ **Export d'images** en SVG/PNG
- ✅ **Layouts multiples** (vertical, horizontal, radial)
- ✅ **Données royales** intégrées pour démonstration

**L'application est prête pour la démonstration et les tests utilisateurs !** 🌳
