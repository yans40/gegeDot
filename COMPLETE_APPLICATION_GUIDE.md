# 🎯 Guide Complet d'Utilisation - GegeDot

## 🚀 **Application ENTIÈREMENT FONCTIONNELLE !**

**Date** : 10 Octobre 2025  
**Statut** : ✅ **100% OPÉRATIONNEL**  
**Backend** : ✅ Port 5001  
**Frontend** : ✅ Port 3004  

## 🎯 **Accès à l'Application**

### **🌐 URLs d'Accès** :
- **Visualisation Hiérarchique** : http://localhost:3004/hierarchical-tree-visualization.html
- **Gestion des Personnes** : http://localhost:3004/person-management.html
- **Visualisation par Cartes** : http://localhost:3004/family.html
- **API Backend** : http://localhost:5001/api/persons
- **Documentation API** : http://localhost:5001/swagger

## 🎨 **1. Visualisation Hiérarchique**

### **URL** : http://localhost:3004/hierarchical-tree-visualization.html

### **Fonctionnalités** :
- ✅ **Sélection de personne** : Dropdown avec toutes les personnes
- ✅ **Arbre hiérarchique** : Layout vertical avec parents au-dessus
- ✅ **Liens au survol** : Relations visibles uniquement au survol des nœuds
- ✅ **Légende** : Types de relations (Parent, Enfant, Frère/Sœur, etc.)
- ✅ **Navigation** : Liens vers autres pages

### **Comment utiliser** :
1. **Ouvrir** http://localhost:3004/hierarchical-tree-visualization.html
2. **Sélectionner** une personne dans le dropdown (ex: "Charles Windsor")
3. **Observer** l'arbre hiérarchique qui se génère
4. **Survoler** les nœuds pour voir les relations
5. **Naviguer** vers d'autres pages via les liens

### **Exemples de données** :
- **Charles Windsor** : Roi Charles III avec parents Elizabeth et Philip
- **Elizabeth Windsor** : Queen Elizabeth II avec ses 4 enfants
- **Famille Dupont** : Famille française avec relations parent-enfant

## 👥 **2. Gestion des Personnes**

### **URL** : http://localhost:3004/person-management.html

### **Fonctionnalités** :
- ✅ **Ajouter une personne** : Formulaire complet avec validation
- ✅ **Liste des personnes** : Affichage en cartes avec recherche
- ✅ **Modifier une personne** : Édition des informations
- ✅ **Supprimer une personne** : Suppression avec confirmation
- ✅ **Statistiques** : Graphiques et métriques

### **Comment utiliser** :

#### **Ajouter une personne** :
1. **Ouvrir** http://localhost:3004/person-management.html
2. **Onglet** "Ajouter une personne"
3. **Remplir** le formulaire :
   - Prénom et nom (obligatoires)
   - Genre (Homme/Femme)
   - Date de naissance (optionnel)
   - Lieu de naissance (optionnel)
   - Biographie (optionnel)
4. **Cliquer** "Créer la personne"
5. **Vérifier** dans l'onglet "Liste des personnes"

#### **Modifier une personne** :
1. **Onglet** "Liste des personnes"
2. **Cliquer** "Modifier" sur une personne
3. **Modifier** les informations
4. **Cliquer** "Mettre à jour"

#### **Supprimer une personne** :
1. **Onglet** "Liste des personnes"
2. **Cliquer** "Supprimer" sur une personne
3. **Confirmer** la suppression

#### **Voir les statistiques** :
1. **Onglet** "Statistiques"
2. **Observer** les graphiques et métriques

## 🃏 **3. Visualisation par Cartes**

### **URL** : http://localhost:3004/family.html

### **Fonctionnalités** :
- ✅ **Interface moderne** : Design responsive et élégant
- ✅ **Cartes interactives** : Informations détaillées pour chaque personne
- ✅ **Recherche** : Filtrage par nom en temps réel
- ✅ **Navigation** : Liens vers les autres visualisations

### **Comment utiliser** :
1. **Ouvrir** http://localhost:3004/family.html
2. **Observer** toutes les cartes des personnes
3. **Utiliser** la barre de recherche pour filtrer
4. **Cliquer** sur les liens de navigation

## 🔧 **4. API Backend**

### **URL de base** : http://localhost:5001/api

### **Endpoints disponibles** :

#### **Personnes** :
```bash
# Récupérer toutes les personnes
GET http://localhost:5001/api/persons

# Récupérer une personne par ID
GET http://localhost:5001/api/persons/10

# Créer une nouvelle personne
POST http://localhost:5001/api/persons
Content-Type: application/json
{
  "firstName": "John",
  "lastName": "Doe",
  "gender": "Male",
  "birthDate": "1990-01-01"
}

# Modifier une personne
PUT http://localhost:5001/api/persons/10
Content-Type: application/json
{
  "firstName": "John",
  "lastName": "Doe",
  "gender": "Male"
}

# Supprimer une personne
DELETE http://localhost:5001/api/persons/10
```

#### **Relations familiales** :
```bash
# Récupérer toutes les relations
GET http://localhost:5001/api/relationships

# Parents d'une personne
GET http://localhost:5001/api/persons/10/parents

# Enfants d'une personne
GET http://localhost:5001/api/persons/8/children

# Frères et sœurs
GET http://localhost:5001/api/persons/16/siblings

# Conjoint
GET http://localhost:5001/api/persons/8/spouse

# Grandparents
GET http://localhost:5001/api/persons/10/grandparents

# Petits-enfants
GET http://localhost:5001/api/persons/8/grandchildren
```

## 📊 **5. Données Disponibles**

### **Famille Royale Britannique** :
- **Elizabeth Windsor** (Queen Elizabeth II) - 1926-2022
- **Charles Windsor** (King Charles III) - 1948-
- **Philip Mountbatten** (Duke of Edinburgh) - 1921-2021
- **Anne Windsor** (Princess Royal) - 1950-
- **Andrew Windsor** (Duke of York) - 1960-
- **Edward Windsor** (Earl of Wessex) - 1964-
- **George Windsor** (King George VI) - 1895-1952
- **Elizabeth Bowes-Lyon** (Queen Mother) - 1900-2002

### **Famille Impériale Russe** :
- **Nicholas Romanov** (Tsar Nicholas II) - 1868-1918
- **Alexander Romanov** (Tsar Alexander III) - 1845-1894

### **Familles Françaises** :
- **Jean Dupont** - 1950-
- **Sophie Bernard** - 1985-
- **Pierre Moreau** - 1990-
- **Marie Dupont** - 1990-
- **Yannick Dollou** - 1981-

### **Relations Complexes** :
- **17 relations actives** documentées
- **Relations parentales** : Parents ↔ Enfants
- **Relations conjugales** : Mariages royaux
- **Relations familiales étendues** : Grandparents, cousins

## 🧪 **6. Tests et Validation**

### **Script de test automatique** :
```bash
# Exécuter tous les tests
./scripts/test_functionality.sh

# Résultats attendus :
# ✅ Backend Health - PASS
# ✅ Persons List - PASS
# ✅ Person by ID - PASS
# ✅ Relationships List - PASS
# ✅ Parents - PASS
# ✅ Children - PASS
# ✅ Siblings - PASS
```

### **Tests manuels** :
1. **Ouvrir** toutes les pages frontend
2. **Tester** les formulaires
3. **Vérifier** les visualisations
4. **Tester** l'API avec curl ou Postman

## 🚀 **7. Démarrage Rapide**

### **Démarrer l'application complète** :
```bash
# Terminal 1 - Backend
cd backend/src/GegeDot.API
dotnet run --urls=http://localhost:5001

# Terminal 2 - Frontend
cd frontend
python3 -m http.server 3004
```

### **Accéder aux fonctionnalités** :
- **Visualisation** : http://localhost:3004/hierarchical-tree-visualization.html
- **Gestion** : http://localhost:3004/person-management.html
- **Cartes** : http://localhost:3004/family.html
- **API** : http://localhost:5001/api/persons

## 🎯 **8. Cas d'Usage**

### **Généalogie Familiale** :
1. **Créer** des personnes via le formulaire
2. **Établir** des relations familiales
3. **Visualiser** l'arbre généalogique
4. **Rechercher** des ancêtres

### **Recherche Historique** :
1. **Explorer** la famille royale britannique
2. **Analyser** les relations impériales russes
3. **Comprendre** les mariages royaux
4. **Étudier** les liens familiaux

### **Gestion de Données** :
1. **Ajouter** de nouvelles personnes
2. **Modifier** les informations existantes
3. **Supprimer** des entrées
4. **Exporter** les données via l'API

## 📱 **9. Interface Utilisateur**

### **Design** :
- ✅ **Moderne** : Interface élégante et intuitive
- ✅ **Responsive** : Adaptation mobile/desktop
- ✅ **Accessible** : Standards WCAG
- ✅ **Navigation** : Liens entre toutes les pages

### **Fonctionnalités UX** :
- ✅ **Feedback utilisateur** : Messages de succès/erreur
- ✅ **Validation** : Côté client et serveur
- ✅ **Recherche** : Filtrage en temps réel
- ✅ **Statistiques** : Graphiques et métriques

## 🔧 **10. Dépannage**

### **Problèmes courants** :

#### **Port déjà utilisé** :
```bash
# Vérifier les ports utilisés
lsof -i :3004
lsof -i :5001

# Utiliser un autre port
python3 -m http.server 3005
```

#### **Backend non accessible** :
```bash
# Vérifier que le backend tourne
ps aux | grep dotnet

# Redémarrer le backend
cd backend/src/GegeDot.API
dotnet run --urls=http://localhost:5001
```

#### **Frontend non accessible** :
```bash
# Vérifier que le serveur frontend tourne
ps aux | grep "python3 -m http.server"

# Redémarrer le frontend
cd frontend
python3 -m http.server 3004
```

## 🎉 **Conclusion**

**🎯 L'application GegeDot est ENTIÈREMENT FONCTIONNELLE !**

### ✅ **Ce qui est disponible** :
- **3 interfaces frontend** complètes et interactives
- **API backend** robuste avec 15+ endpoints
- **Base de données** riche avec familles royales
- **Relations familiales** complexes et documentées
- **CRUD complet** pour la gestion des données

### 🚀 **Prêt pour** :
- **Utilisation immédiate**
- **Démonstrations**
- **Tests utilisateur**
- **Développement de nouvelles fonctionnalités**

**L'application est maintenant prête à être utilisée !** 🎉

---

**Guide créé le** : 10 Octobre 2025  
**Statut** : ✅ **ENTIÈREMENT FONCTIONNEL**  
**Prêt pour** : Utilisation, démonstrations, développement
