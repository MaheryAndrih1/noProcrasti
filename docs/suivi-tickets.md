# Suivi des tickets qualité

Ce document joue le rôle d'un petit journal GLPI/Zammad pour le projet noProcrasti.

## Incidents

| Ticket | Type | Résumé | Statut | Résolution |
|---|---|---|---|---|
| INC-001 | Incident | L'application ne démarre pas dans Docker | Clos | Correction du service app et vérification du port 3000 |
| INC-002 | Incident | Un compte voit les tâches d'un autre compte | Clos | Isolation des tâches par utilisateur dans Hive |

## Problèmes

| Ticket | Type | Résumé | Statut | Solution permanente |
|---|---|---|---|---|
| PRB-001 | Problème | Statut de tâche incohérent après déconnexion | Clos | Pause forcée de la tâche active avant logout |

## Changements

| Ticket | Type | Résumé | Statut | Validation |
|---|---|---|---|---|
| CHG-001 | Changement | Migration vers Hive pour les tâches | Validé | Tests de persistance passés |
| CHG-002 | Changement | Ajout de la confirmation avant déconnexion | Validé | Analyse et test manuels passés |
