# 🌳 Guide de Test - Visualisation Hiérarchique

## 🎯 Objectif
Tester la nouvelle visualisation hiérarchique qui organise les membres de la famille par niveaux générationnels, avec les frères et sœurs alignés horizontalement au même niveau.

## 🚀 Démarrage des Services

### 1. Base de données MySQL
```bash
docker compose up -d mysql
```

### 2. Backend API (.NET)
```bash
export DOTNET_ROOT="/usr/local/opt/dotnet/libexec"
cd backend/src/GegeDot.API
dotnet run --urls="http://localhost:5000"
```

### 3. Frontend (HTML Standalone)
```bash
cd frontend
python3 -m http.server 3003
```

## 🌐 URLs de Test

### Visualisations Disponibles
- **Layout Hiérarchique** : `http://localhost:3003/hierarchical-tree-visualization.html`
- **Layout Force-Directed** : `http://localhost:3002/tree-visualization.html`
- **Visualisation par Cartes** : `http://localhost:3002/family.html`
- **API Swagger** : `http://localhost:5000/swagger`

## 🧪 Tests à Effectuer

### 1. Test de Base - Charles Windsor
1. Ouvrir `http://localhost:3003/hierarchical-tree-visualization.html`
2. Sélectionner "Charles Windsor (Male)" dans la liste déroulante
3. Cliquer sur "Charger l'arbre hiérarchique"
4. **Vérifier** :
   - Charles est au centre (niveau 0)
   - Ses parents (Elizabeth II, Philip) sont au niveau 1 (au-dessus)
   - Ses frères/sœurs (Anne, Andrew, Edward) sont au niveau 0 (même ligne que Charles)
   - Ses enfants sont au niveau -1 (en-dessous)
   - Ses grands-parents sont au niveau 2 (tout en haut)

### 2. Test de Layout Hiérarchique
**Vérifier l'organisation par niveaux** :
- **Niveau 2** : Grands-parents (George VI, Elizabeth Bowes-Lyon)
- **Niveau 1** : Parents (Elizabeth II, Philip)
- **Niveau 0** : Charles + Frères/Sœurs (Anne, Andrew, Edward)
- **Niveau -1** : Enfants (William, Harry)
- **Niveau -2** : Petits-enfants (George, Charlotte, Louis, Archie)

### 3. Test des Relations
**Vérifier les types de liens** :
- **Ligne continue grise** : Relations parent-enfant
- **Ligne pointillée rose** : Relations de mariage
- **Ligne continue bleue** : Relations frères/sœurs

### 4. Test des Contrôles
- **Zoom avant/arrière** : Boutons + et -
- **Réinitialiser** : Bouton ⌂
- **Centrer** : Bouton ◎ (centre sur Charles)
- **Légende** : Vérifier les couleurs et types de relations

### 5. Test d'Interaction
- **Clic sur un nœud** : Sélectionne la personne dans la liste déroulante
- **Tooltip** : Survol d'un nœud affiche les détails
- **Zoom et pan** : Glisser-déposer pour naviguer

## 🎨 Améliorations du Layout Hiérarchique

### Avantages par rapport au Layout Force-Directed
1. **Organisation claire** : Chaque génération est sur un niveau distinct
2. **Frères/Sœurs alignés** : Plus de placement aléatoire
3. **Lisibilité** : Structure familiale immédiatement compréhensible
4. **Navigation** : Plus facile de suivre les lignées

### Caractéristiques Techniques
- **Positionnement calculé** : Chaque niveau a une position Y fixe
- **Espacement horizontal** : Les frères/sœurs sont espacés de 150px
- **Espacement vertical** : Les générations sont espacées de 200px
- **Centrage automatique** : La personne principale est centrée

## 🔧 Dépannage

### Problèmes Courants
1. **"Erreur lors du chargement"** : Vérifier que le backend est démarré sur le port 5000
2. **"Personnes non chargées"** : Vérifier la connexion à la base de données MySQL
3. **"Arbre ne s'affiche pas"** : Vérifier la console du navigateur pour les erreurs JavaScript

### Logs à Vérifier
- **Backend** : Logs dans le terminal où `dotnet run` est exécuté
- **Frontend** : Console du navigateur (F12)
- **Base de données** : `docker compose logs mysql`

## 📊 Comparaison des Layouts

| Aspect | Force-Directed | Hiérarchique |
|--------|----------------|--------------|
| **Organisation** | Aléatoire | Par niveaux |
| **Frères/Sœurs** | Dispersés | Alignés |
| **Lisibilité** | Moyenne | Excellente |
| **Performance** | Variable | Constante |
| **Navigation** | Difficile | Facile |

## 🎯 Prochaines Étapes

1. **Tester avec d'autres familles** : Essayer avec d'autres personnes
2. **Optimiser l'espacement** : Ajuster les distances entre niveaux
3. **Ajouter des animations** : Transitions fluides entre les layouts
4. **Personnalisation** : Permettre de modifier l'espacement

## 📝 Notes de Test

- **Données de test** : Famille royale britannique (8 membres)
- **Relations testées** : Parents, enfants, frères/sœurs, grands-parents, petits-enfants
- **Performance** : Rendu instantané pour les familles de taille normale
- **Responsive** : S'adapte à la taille de l'écran

---

**Status** : ✅ Implémenté et prêt pour les tests
**Branche** : `feature/hierarchical-layout`
**Issue GitHub** : #8 - Layout hiérarchique pour les frères et sœurs
