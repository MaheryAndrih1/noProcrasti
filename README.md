# noProcrasti

Application Flutter de gestion de tâches conçue pour aider l'utilisateur à rester concentré et à réduire la procrastination.

## Répertoire GitHub

Ce projet est lié à GitHub :
https://github.com/MaheryAndrih1/noProcrasti

## Présentation du projet

- Création, modification et réordonnancement des tâches
- Flux de travail démarrer / mettre en pause / terminer
- Détection des tâches en retard et logique de suggestions
- Persistance locale avec une base Hive pour les tâches
- Authentification locale par email et mot de passe

## Dossier qualité

Les livrables qualité sont regroupés dans [docs/README.md](docs/README.md).

## Pré-requis

- SDK Flutter installé (ou utilisation du Docker fourni)
- SDK Dart inclus avec Flutter
- Git pour le contrôle de version

## Exécution locale

### Avec le SDK Flutter local

1. Ajoutez Flutter au `PATH` si nécessaire :

```bash
export PATH="$PATH:/Users/user/code/flutter/bin"
```

2. Récupérez les dépendances :

```bash
flutter pub get
```

3. Lancez l'application sur votre plateforme Flutter disponible :

```bash
flutter devices
flutter run -d <device_id>
```

Exemples de cibles possibles selon votre environnement :

- `flutter run -d macos`
- `flutter run -d windows`
- `flutter run -d linux`
- `flutter run -d chrome`

4. Exécutez les tests unitaires :

```bash
flutter test
```

## Docker

Ce dépôt inclut une configuration Docker pour l'installation des dépendances et l'exécution de tests.

### Construire l'image Docker :

```bash
docker build -t noprocrasti-flutter .
```

### Exécuter les tests dans Docker :

```bash
docker run --rm -v "$PWD":/workspace -w /workspace noprocrasti-flutter flutter test
```

### Docker Compose :

```bash
docker compose up --build flutter
docker compose up --build app
```

> Remarque : `flutter` lance les tests dans le conteneur, et `app` expose l'application web sur http://localhost:3000.

## Configuration Git

Le dépôt est déjà connecté à GitHub à l'adresse :
https://github.com/MaheryAndrih1/noprocrasti.git

Pour collaborer et pousser des changements :

```bash
git status
git add .
git commit -m "Ajout d'une fonctionnalité"
git push origin main
```

### Intégration Git dans l'application

L'application permet actuellement :
- la gestion locale des tâches,
- la création de compte et la connexion via email/mot de passe,
- la persistance des données sur le poste de l'utilisateur.

Pour une prochaine étape, un vrai workflow Git intégré (ouvrir un dépôt, consulter l'historique, créer des commits depuis l'app) pourra être ajouté.

## Remarques

- Le projet est documenté pour les plateformes Flutter disponibles dans votre environnement, avec une validation pratique sur le flux desktop et Docker/web du dépôt
