# Correctifs purge et panneau administrateur - 10 octobre 2026

## Deploiement effectue

Projet Supabase : `nuoonagnkhbeeymtvrcn`.
Migration appliquee en production et conservee localement :
`supabase/migrations/20261010152728_restrict_sensitive_purge_and_admin_code.sql`.

| Fonction | Visiteur | Utilisateur ordinaire | Fondateur | Serveur service_role |
| --- | --- | --- | --- | --- |
| `purge_user(uuid)` direct | Refuse | Refuse | Refuse | Autorise |
| `set_admin_panel_code(text,text)` | Refuse | Refuse | Autorise avec garde owner existante | Autorise |
| Suppression via RPC du panneau | Refuse | Refuse | Garde owner conservee | Parcours serveur inchange |

Les droits PUBLIC, anon et authenticated ont ete retires de `purge_user`.
Le code de purge lui-meme n'a pas ete modifie.

`set_admin_panel_code` verifie desormais `community_admin_owner_guard()` pour
les appels autres que service_role. La fonction reste accessible aux appels
authentifies du fondateur, mais pas aux simples utilisateurs ni aux autres
roles administratifs. Son search_path est vide et ses dependances qualifiees.

## Parcours preserves

- Suppression personnelle : `delete-user-cascade` ACTIVE v65, identite verifiee,
  appel de purge avec le client serveur service_role confirme apres correction.
- Panneau : `admin_delete_user_account` utilise sa RPC distincte
  `admin_delete_user_data_completely`, dont la garde owner et les controles
  existants n'ont pas ete modifies.
- Aucune modification des abonnements, quotas ou regles des quatre parcours.

## Tests executes en production

Tests de permissions et simulations de roles dans des transactions annulees
avec ROLLBACK ; aucune suppression reelle ni modification de code admin persistee.

- Visiteur : purge et setter admin refuses (SQLSTATE 42501).
- Compte ordinaire synthetique : purge, setter admin et suppression du panneau
  refuses (42501).
- Fondateur eligible : setter autorise sur une adresse sans ligne correspondante
  (absence verifiee avant appel) ; purge directe refusee ; RPC de suppression
  franchit la garde owner puis rejette la cible NULL (22023).
- Serveur : purge atteint sa validation initiale et rejette UID NULL avant toute
  suppression. Droits service_role confirmes.
- Catalogue des permissions relu apres deploiement ; resultats conformes.
- Conseiller securite relance : aucune alerte ERROR ; les autres avertissements
  de configuration restent presents.

Il s'agit de tests SQL des autorisations, pas d'un test complet de suppression
depuis un navigateur ou un telephone. Aucun compte reel supprime. Ces tests
ne permettent pas de conclure a l'absence d'exploitation historique.

## Reste a faire

SEC-01 et SEC-02 sont corriges. Les autres constats de
`AUDIT_SECURITE_ET_TESTS_2026_10_10.md` restent ouverts, notamment les droits
Premium cote serveur, les recompenses publicitaires, les fonctions historiques
exposees et les echecs de tests Flutter. Aucun lancement public effectue.

Ce correctif est deja actif sur Supabase : aucun transfert du dossier du site
ni nouvelle version mobile n'est necessaire pour activer ces permissions.
