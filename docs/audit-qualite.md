# Audit qualité

## 1. Revue de code

- Vérifier la séparation des couches.
- Vérifier la validation des entrées.
- Vérifier la cohérence des statuts de tâches.
- Vérifier l'isolement des comptes.

## 2. Suivi des anomalies

| ID | Anomalie | Gravité | Statut | Correction |
|---|---|---|---|---|
| AN-01 | Un compte écrasait un autre | Critique | Corrigée | Liste locale par email |
| AN-02 | Tâches partagées entre comptes | Critique | Corrigée | Box Hive par utilisateur |
| AN-03 | Logout avec tâche active incohérent | Majeure | Corrigée | Confirmation + pause avant logout |

## 3. Tableau de suivi qualité

| Axe | Indicateur | Cible |
|---|---|---|
| Fonctionnel | Tâches CRUD | Conforme |
| Sécurité | Données séparées par compte | Conforme |
| Fiabilité | Reprise de session | Conforme |
| Maintenabilité | Services isolés | Conforme |
| Tests | Couverture des services | En cours d'amélioration |

## 4. Audit final

- L'architecture est lisible.
- Les correctifs critiques sont suivis par tests.
- Les outils externes doivent être exécutés pour produire les rapports officiels.
