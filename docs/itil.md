# ITIL - Simulation de gestion

## 1. Gestion d'incident

### Incident 1 : indisponibilité de l'application

- Symptôme : l'application ne se lance pas.
- Action : vérifier le build, les dépendances et le conteneur.
- Résolution : relancer Docker et les tests.

### Incident 2 : erreur système

- Symptôme : erreur de navigation ou de persistance.
- Action : reproduire, journaliser, corriger.
- Résolution : patch code et test de régression.

### Incident 3 : panne serveur simulée

- Symptôme : service de notification ou stockage indisponible.
- Action : désactiver la fonctionnalité défaillante et préserver les tâches locales.
- Résolution : reprise après vérification.

## 2. Gestion de problème

### Problème racine 1

- Cause : stockage partagé entre comptes.
- Solution permanente : base Hive isolée par utilisateur.

### Problème racine 2

- Cause : déconnexion sans pause explicite d'une tâche active.
- Solution permanente : confirmation de logout avec pause automatique.

## 3. Gestion de changement

### Changement 1 : nouvelle fonctionnalité

- Ajouter la séparation par compte.
- Valider par tests et revue.

### Changement 2 : modification de base de données

- Passer du stockage partagé à Hive par utilisateur.
- Exécuter les tests de régression.

### Changement 3 : mise à jour système

- Mettre à jour dépendances Flutter ou Docker.
- Revalider les services et l'interface.
