# Phase 2 - Conception

## 1. Architecture du système

Le système suit une architecture simple en couches :

- Présentation : widgets Flutter.
- État applicatif : `AppState`.
- Services : `AuthService`, `TaskService`, `StorageService`, `SuggestionService`, `NotificationService`, `SettingsService`.
- Données : Hive pour les tâches, SharedPreferences pour la session et les réglages.

## 2. Diagramme de cas d'utilisation

```mermaid
flowchart TD
    User[Utilisateur] --> Login[Se connecter]
    User --> Logout[Se déconnecter]
    User --> Create[Créer une tâche]
    User --> Start[Démarrer une tâche]
    User --> Pause[Mettre en pause]
    User --> Done[Terminer une tâche]
    User --> Delete[Supprimer une tâche]
    User --> Reorder[Réordonner]
    User --> View[Consulter les suggestions]
```

## 3. Diagramme de classes simplifié

```mermaid
classDiagram
    class AppUser {
      +String id
      +String name
      +String email
      +String? avatarUrl
    }

    class Task {
      +String id
      +String title
      +String description
      +DateTime dueDate
      +DateTime createdAt
      +Duration estimatedDuration
      +Duration remainingDuration
      +DateTime? lastStartedAt
      +int orderIndex
      +TaskStatus status
      +TaskPriority priority
    }

    class AppState {
      +AppUser? currentUser
      +List~Task~ tasks
      +List~Task~ suggestions
      +signInWithEmail()
      +registerUser()
      +signOut()
      +addTask()
      +startTask()
      +pauseTask()
      +completeTask()
    }

    class AuthService
    class TaskService
    class StorageService
    class SuggestionService

    AppState --> AuthService
    AppState --> TaskService
    AppState --> SuggestionService
    TaskService --> StorageService
```

## 4. Diagramme de séquence - création de tâche

```mermaid
sequenceDiagram
    actor U as Utilisateur
    participant UI as Interface Flutter
    participant S as AppState
    participant T as TaskService
    participant DB as Hive

    U->>UI: Saisie du formulaire
    UI->>S: addTask()
    S->>T: saveTasks()
    T->>DB: write box user-specific
    DB-->>T: ok
    T-->>S: ok
    S-->>UI: rafraîchit l'état
```

## 5. Modèle de base de données

### Entité Task

| Champ | Type | Description |
|---|---|---|
| id | String | Identifiant unique |
| title | String | Titre |
| description | String | Description |
| dueDate | DateTime | Date d'échéance |
| createdAt | DateTime | Date de création |
| estimatedDuration | Duration | Durée estimée |
| remainingDuration | Duration | Temps restant |
| lastStartedAt | DateTime? | Dernier démarrage |
| orderIndex | int | Position dans la liste |
| status | TaskStatus | pending, active, paused, done |
| priority | TaskPriority | low, medium, high |

### Stockage

- Box Hive par utilisateur : `noprocrasti_tasks_<userId>`.
- Session utilisateur : SharedPreferences.
- Réglages : SharedPreferences.

## 6. Maquettes fonctionnelles

### Écran de connexion

- Champ email
- Champ mot de passe
- Bouton Login
- Lien vers création de compte

### Tableau de bord

- Bouton de déconnexion
- Bouton ajout de tâche
- Tâche active visible en premier
- Liste triée des tâches restantes
- Section tâches terminées
- Section suggestions

### Détail de tâche

- Titre
- Description
- Échéance
- Priorité
- Statut
- Actions Start / Pause / Done / Delete
