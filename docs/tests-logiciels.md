# Tests logiciels

## 1. Stratégie de test

- Tester les services métier en priorité.
- Vérifier les cas limites de données.
- Contrôler la persistance et la séparation des comptes.
- Valider le comportement en cas d'erreur utilisateur.
- Vérifier le démarrage et l'arrêt d'une tâche active.

## 2. Scénarios de test

### Fonctionnels

| ID | Scénario | Résultat attendu |
|---|---|---|
| FT-01 | Créer une tâche | La tâche apparaît dans la liste |
| FT-02 | Démarrer une tâche | Le statut devient active |
| FT-03 | Mettre en pause | Le statut devient paused |
| FT-04 | Terminer une tâche | Le statut devient done |
| FT-05 | Se déconnecter avec tâche active | La tâche est mise en pause avant logout |

### Validation

| ID | Scénario | Résultat attendu |
|---|---|---|
| VT-01 | Email vide | Message d'erreur |
| VT-02 | Mot de passe trop court | Message d'erreur |
| VT-03 | Titre vide | Formulaire rejeté |
| VT-04 | Date invalide | Formulaire rejeté |

### Sécurité

| ID | Scénario | Résultat attendu |
|---|---|---|
| ST-01 | Mauvais mot de passe | Connexion refusée |
| ST-02 | Compte A puis compte B | Les tâches restent séparées |
| ST-03 | Session terminée | Accès au dashboard retiré |

### Performance

| ID | Scénario | Résultat attendu |
|---|---|---|
| PT-01 | Charger une liste locale | Réponse rapide |
| PT-02 | Sauvegarder après action | Mise à jour immédiate |
| PT-03 | Calcul de suggestions | Réponse rapide |

## 3. Cas de test exécutés

- `test/auth_service_test.dart`
- `test/task_service_test.dart`
- `test/suggestion_service_test.dart`
- `test/storage_service_test.dart`
- `test/widget_test.dart`

## 4. Statut

- Les tests automatisés du cœur applicatif sont en place.
- Les scénarios sécurité/performance outillés par ZAP et JMeter doivent être exécutés dans l'environnement de soutenance.
