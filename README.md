# 🌳 GegeDot - Arbre Généalogique Moderne

Un projet d'arbre généalogique moderne avec architecture microservices, backend .NET Core et frontend React/TypeScript.

## 🎯 Objectif du Projet

Ce projet pédagogique vise à apprendre les différentes strates de prise de décision dans un projet moderne :
- Architecture microservices
- Séparation frontend/backend
- Déploiement cloud
- CI/CD
- Gestion de base de données

## 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Frontend      │    │   API Gateway   │    │   Backend       │
│   (React/TS)    │◄──►│   (.NET Core)   │◄──►│   Services      │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                │
                       ┌─────────────────┐
                       │   Database      │
                       │   (MySQL)       │
                       └─────────────────┘
```

### Services Backend (.NET Core)
- **PersonService** : Gestion des personnes
- **FamilyService** : Gestion des relations familiales
- **TreeService** : Construction et visualisation des arbres
- **AuthService** : Authentification (Phase 2)

### Frontend
- **React + TypeScript** : Interface utilisateur moderne
- **Material-UI** : Composants UI
- **D3.js** : Visualisation des arbres généalogiques

## 🚀 Technologies

### Backend
- .NET 8 Core
- Entity Framework Core
- MySQL
- Swagger/OpenAPI
- Docker

### Frontend
- React 18
- TypeScript
- Material-UI
- D3.js
- Axios

### DevOps
- Docker & Docker Compose
- GitHub Actions
- Railway.app (Backend)
- Netlify (Frontend)

## 📋 Roadmap

### Phase 1 - MVP (2-3 semaines)
- [x] Architecture et documentation
- [ ] API basique (CRUD Personnes)
- [ ] Frontend simple avec arbre basique
- [ ] Base de données locale
- [ ] Tests unitaires

### Phase 2 - Amélioration (1-2 mois)
- [ ] Authentification JWT
- [ ] Upload de photos
- [ ] Export PDF
- [ ] Interface plus riche
- [ ] Recherche avancée

### Phase 3 - Production (2-3 mois)
- [ ] Déploiement cloud
- [ ] Performance optimisée
- [ ] Tests automatisés
- [ ] Monitoring
- [ ] Documentation API

## 🛠️ Installation et Développement

### Prérequis
- .NET 8 SDK
- Node.js 18+
- MySQL 8.0+
- Docker (optionnel)

### Démarrage Rapide

1. **Cloner le projet**
```bash
git clone https://github.com/votre-username/gegeDot.git
cd gegeDot
```

2. **Backend**
```bash
cd backend
dotnet restore
dotnet run
```

3. **Frontend**
```bash
cd frontend
npm install
npm start
```

4. **Avec Docker**
```bash
docker-compose up
```

## 📊 Base de Données

### Schéma Principal
- **Persons** : Informations des personnes
- **Relationships** : Relations familiales
- **Trees** : Arbres généalogiques
- **Users** : Utilisateurs (Phase 2)

## 🔧 Configuration

### Variables d'environnement
```env
# Backend
DATABASE_CONNECTION_STRING=Server=localhost;Database=gegeDot;Uid=root;Pwd=password;
JWT_SECRET=your-secret-key

# Frontend
REACT_APP_API_URL=http://localhost:5000
```

## 📚 Documentation API

L'API est documentée avec Swagger disponible à : `http://localhost:5000/swagger`

### Endpoints Principaux
- `GET /api/persons` - Liste des personnes
- `POST /api/persons` - Créer une personne
- `GET /api/trees/{id}` - Obtenir un arbre généalogique
- `POST /api/relationships` - Créer une relation

## 🚀 Déploiement

### Options Gratuites
- **Backend** : Railway.app, Render.com
- **Frontend** : Netlify, Vercel
- **Base de données** : PlanetScale, Railway MySQL

### Déploiement Automatique
Le projet utilise GitHub Actions pour le CI/CD automatique.

## 🤝 Contribution

1. Fork le projet
2. Créer une branche feature (`git checkout -b feature/AmazingFeature`)
3. Commit les changements (`git commit -m 'Add some AmazingFeature'`)
4. Push vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrir une Pull Request

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus de détails.

## 👨‍💻 Auteur

Créé dans le cadre d'un projet pédagogique pour apprendre l'architecture moderne.

## 🙏 Remerciements

Inspiré du projet [gege](https://github.com/yans40/gege) pour la structure de base.
