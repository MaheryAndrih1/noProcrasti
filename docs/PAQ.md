# Plan d'Assurance Qualité - noProcrasti

## 1. Présentation du projet

noProcrasti est une application Flutter de gestion de tâches destinée à aider l'utilisateur à planifier son travail, démarrer une tâche, la mettre en pause, la terminer et retrouver ses tâches en retard ou suggérées.

## 2. Objectifs du système

- Centraliser la gestion des tâches.
- Permettre un suivi simple du statut de chaque tâche.
- Conserver les données localement de façon persistante.
- Fournir une interface claire et simple à utiliser.
- Démontrer une démarche qualité complète sur un mini projet logiciel.

## 3. Fonctionnalités prévues

- Création, consultation, modification logique et suppression de tâches.
- Démarrage, pause et clôture d'une tâche.
- Réordonnancement des tâches.
- Surlignage des tâches actives et en retard.
- Suggestions de prochaines tâches.
- Connexion et déconnexion locales.

## 4. Normes utilisées

- ISO/IEC 25010.
- Bonnes pratiques de développement Flutter.
- Principes ITIL pour la gestion d'incident, de problème et de changement.
- Approche CMMI pour la structuration et l'amélioration du processus.

## 5. Critères de qualité ISO/IEC 25010

- Sécurité : accès utilisateur limité à sa session et à ses données.
- Performance : chargement rapide des listes locales.
- Maintenabilité : découpage en modèles, services et état applicatif.
- Fiabilité : persistance locale et reprise de session.
- Utilisabilité : écrans simples et actions visibles.
- Compatibilité : exécution sur les plateformes Flutter disponibles et via Docker.
- Portabilité : code Dart portable et stockage local abstrait.

## 6. Procédure de développement

1. Identifier le besoin.
2. Concevoir le flux et les données.
3. Implémenter par couche.
4. Créer les tests unitaires.
5. Vérifier les erreurs d'analyse.
6. Documenter les changements.
7. Valider avant chaque livraison.

## 7. Stratégie de tests

- Tests fonctionnels sur les services métier.
- Tests de validation sur les formulaires et les règles de statut.
- Tests de sécurité simples sur l'authentification locale.
- Tests de persistance sur le stockage Hive.
- Tests de régression sur les corrections de bugs.

## 8. Procédure de validation

- Exécuter les tests automatisés.
- Vérifier l'analyse statique Flutter/Dart.
- Confirmer le comportement UI attendu.
- Vérifier le fonctionnement en Docker.
- Faire valider les corrections par relecture.

## 9. Gestion des anomalies

- Chaque anomalie est identifiée, reproduite, corrigée et retestée.
- Les anomalies critiques bloquent la validation.
- Les anomalies mineures sont suivies jusqu'à correction ou justification.

## 10. Outils utilisés

- Flutter
- Dart
- Git / GitHub
- Docker / Docker Compose
- Hive
- SharedPreferences
- Tests Flutter
