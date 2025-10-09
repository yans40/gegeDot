# 👥 Guide de Gestion des Personnes

## Vue d'ensemble

La page de gestion des personnes vous permet de créer, modifier, supprimer et consulter toutes les personnes de votre arbre généalogique. C'est l'interface principale pour enrichir votre base de données.

## 🌐 Accès

### URL
```
http://localhost:3003/person-management.html
```

### Navigation
- **Depuis la visualisation hiérarchique** : Cliquez sur "👥 Gérer les personnes"
- **Depuis la visualisation par cartes** : Lien direct dans la page
- **URL directe** : Tapez l'URL dans votre navigateur

## 📋 Fonctionnalités

### 1. ➕ Ajouter une personne

#### Champs obligatoires
- **Prénom** : Le prénom de la personne
- **Nom de famille** : Le nom de famille
- **Genre** : Homme, Femme, ou Autre

#### Champs optionnels
- **Date de naissance** : Format YYYY-MM-DD
- **Date de décès** : Format YYYY-MM-DD (si renseignée, la personne sera marquée comme décédée)
- **Lieu de naissance** : Ville, région, pays
- **Lieu de décès** : Ville, région, pays
- **Profession** : Métier ou occupation
- **Biographie** : Histoire de vie, anecdotes, etc.

#### Processus de création
1. Remplissez le formulaire
2. Cliquez sur "💾 Créer la personne"
3. Un message de confirmation apparaît
4. La personne est ajoutée à la base de données
5. Elle apparaît automatiquement dans la liste

### 2. 📋 Liste des personnes

#### Affichage
- **Vue en cartes** : Chaque personne dans une carte individuelle
- **Informations affichées** :
  - Nom complet et genre
  - Statut (Vivant/Décédé)
  - Date de naissance/décès
  - Lieu de naissance
  - Profession
  - Extrait de biographie (100 caractères)

#### Recherche
- **Barre de recherche** : Recherche en temps réel
- **Critères de recherche** :
  - Nom complet
  - Prénom
  - Nom de famille
  - Profession
  - Lieu de naissance

#### Actions disponibles
- **✏️ Modifier** : Édite la personne (remplit le formulaire)
- **🗑️ Supprimer** : Supprime définitivement la personne

### 3. 📊 Statistiques

#### Métriques affichées
- **Total des personnes** : Nombre total dans la base
- **Hommes** : Nombre d'hommes
- **Femmes** : Nombre de femmes
- **Personnes vivantes** : Nombre de personnes encore en vie

#### Graphique
- **Répartition par genre** : Pourcentages visuels
- **Cercle bleu** : Pourcentage d'hommes
- **Cercle rose** : Pourcentage de femmes

## 🔧 Fonctionnalités techniques

### Édition de personne
1. Cliquez sur "✏️ Modifier" dans la liste
2. Le formulaire se remplit automatiquement
3. Le bouton devient "💾 Mettre à jour"
4. Modifiez les champs souhaités
5. Cliquez sur "Mettre à jour"

### Suppression de personne
1. Cliquez sur "🗑️ Supprimer"
2. Confirmez la suppression
3. La personne est supprimée définitivement
4. La liste se met à jour automatiquement

### Messages de statut
- **✅ Succès** : Opération réussie (vert)
- **❌ Erreur** : Problème technique (rouge)
- **ℹ️ Information** : Message informatif (bleu)

## 🎨 Interface utilisateur

### Design
- **Style moderne** : Interface épurée et professionnelle
- **Responsive** : S'adapte à tous les écrans
- **Navigation par onglets** : Accès facile aux différentes sections
- **Couleurs cohérentes** : Palette harmonieuse avec le reste de l'application

### Interactions
- **Hover effects** : Animations au survol
- **Transitions fluides** : Changements d'état animés
- **Feedback visuel** : Messages de confirmation/erreur
- **Loading states** : Indicateurs de chargement

## 🔗 Intégration

### Avec la visualisation hiérarchique
- Les nouvelles personnes apparaissent dans la liste déroulante
- Mise à jour automatique après création/modification
- Navigation bidirectionnelle

### Avec la visualisation par cartes
- Les personnes créées sont visibles dans les cartes
- Synchronisation en temps réel
- Navigation fluide entre les vues

## 🚀 Utilisation recommandée

### Workflow typique
1. **Créer les personnes** : Ajoutez d'abord toutes les personnes
2. **Établir les relations** : Utilisez l'API pour créer les liens familiaux
3. **Visualiser** : Consultez l'arbre dans les différentes vues
4. **Enrichir** : Ajoutez des détails (biographies, photos, etc.)

### Bonnes pratiques
- **Nommage cohérent** : Utilisez des conventions de nommage
- **Dates précises** : Renseignez les dates quand possible
- **Biographies** : Ajoutez des détails personnels
- **Vérification** : Relisez avant de valider

## 🐛 Dépannage

### Problèmes courants

#### "Erreur lors de la création"
- Vérifiez que tous les champs obligatoires sont remplis
- Assurez-vous que le backend est démarré
- Vérifiez la connexion à la base de données

#### "Personne non trouvée"
- Actualisez la liste (bouton "🔄 Actualiser")
- Vérifiez l'orthographe dans la recherche
- Assurez-vous que la personne existe dans la base

#### "Erreur de suppression"
- Vérifiez que la personne n'a pas de relations
- Assurez-vous d'avoir les permissions nécessaires
- Vérifiez la connexion au backend

### Logs de débogage
- Ouvrez la console du navigateur (F12)
- Consultez les messages d'erreur détaillés
- Vérifiez les requêtes réseau dans l'onglet Network

## 📈 Évolutions futures

### Fonctionnalités prévues
- **Import/Export** : CSV, GEDCOM
- **Photos** : Upload et gestion d'images
- **Validation** : Vérification des données
- **Historique** : Suivi des modifications
- **Permissions** : Gestion des accès
- **Recherche avancée** : Filtres multiples
- **Groupes** : Organisation par familles
- **Tags** : Étiquetage des personnes

### Améliorations techniques
- **Pagination** : Pour de grandes listes
- **Cache** : Optimisation des performances
- **Offline** : Mode hors ligne
- **Sync** : Synchronisation multi-appareils
- **API** : Endpoints REST complets
- **Tests** : Couverture de tests complète

## 🎯 Conclusion

La gestion des personnes est le cœur de votre application généalogique. Cette interface vous permet de construire progressivement votre arbre en ajoutant des informations détaillées sur chaque membre de votre famille.

Utilisez cette page régulièrement pour enrichir votre base de données et créer un arbre généalogique complet et détaillé.
