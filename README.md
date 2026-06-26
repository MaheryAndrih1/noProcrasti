# noProcrasti

Application Flutter de gestion de tâches conçue pour aider l'utilisateur à rester concentré et à réduire la procrastination.

## Répertoire GitHub

Ce projet est lié à GitHub :
https://github.com/MaheryAndrih1/noProcrasti

## Présentation du projet

- Création, modification et réordonnancement des tâches
- Flux de travail démarrer / mettre en pause / terminer
- Détection des tâches en retard et logique de suggestions
- Persistance locale avec `SharedPreferences`
- Support macOS avec fallback sur bureau pour l'authentification Google

## Pré-requis

- SDK Flutter installé (ou utilisation du Docker fourni)
- SDK Dart inclus avec Flutter
- Git pour le contrôle de version

## Exécution locale

### Avec le SDK Flutter local

1. Ajoutez Flutter au `PATH` si nécessaire :

```bash
export PATH="$PATH:/Users/maheriniainaandrianaivo/code/flutter/bin"
```

2. Récupérez les dépendances :

```bash
flutter pub get
```

3. Lancez l'application sur macOS :

```bash
flutter run -d macos
```

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
docker compose up --build
```

> Remarque : le conteneur Docker est prévu pour l'automatisation de la compilation et des tests, pas pour lancer l'interface graphique macOS.

## Configuration Git

Si le dépôt n'est pas encore initialisé localement, exécutez :

```bash
git init
git add .
git commit -m "Initialisation de noProcrasti avec Docker et README"
git remote add origin https://github.com/MaheryAndrih1/noProcrasti.git
git branch -M main
git push -u origin main
```

## Remarques

- La version macOS est le runtime supporté actuellement dans ce dépôt.
- L'authentification Google utilise un fallback local sur les plateformes de bureau.
- L'assistant flottant apparaît uniquement lorsque l'application est en arrière-plan.
