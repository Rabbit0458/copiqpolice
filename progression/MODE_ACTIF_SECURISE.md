# Module professionnel « Je suis actif »

## État

Le code Flutter, le panel administrateur et la migration Supabase sont prêts.
La migration n'est pas déployée automatiquement en production : elle doit être
appliquée après validation explicite, puis contrôlée avec le test SQL fourni.

## Parcours utilisateur

1. L'utilisateur sélectionne « Je suis actif » dans le choix du mode.
2. Le serveur renvoie les quatre questions, jamais leurs réponses attendues.
3. Les quatre réponses libres sont normalisées et contrôlées uniquement dans
   une fonction Supabase protégée.
4. Un résultat de 4/4 ouvre durablement le module professionnel sur le compte.
5. Deux échecs déclenchent dix minutes de temporisation côté serveur.
6. Chaque tentative et chaque réponse soumise est conservée pour l'audit.

Le module affiche déjà sa structure définitive. Les contenus opérationnels non
encore validés sont volontairement marqués « Bientôt disponible » afin de ne
jamais présenter une aide professionnelle fictive ou incomplète.

## Administration

La page `/admin/actif/` permet au propriétaire connecté en double
authentification de rechercher les utilisateurs, consulter leur historique,
attribuer, restaurer ou révoquer l'accès. Toute mutation repasse par une RPC
serveur qui contrôle à nouveau le rôle `owner` et écrit dans le journal d'audit.

Les réponses attendues ne sont présentes ni dans Flutter, ni dans le JavaScript
du panel, ni dans les données retournées aux utilisateurs.

## Fichiers de livraison

- Migration : `supabase/migrations/20260829110000_active_mode_secure_access.sql`
- Test : `supabase/tests/active_mode_secure_access.sql`
- Retour arrière : `supabase/rollbacks/20260829110000_active_mode_secure_access.rollback.sql`

## Déploiement contrôlé

1. Sauvegarder la base de production.
2. Appliquer la migration Supabase.
3. Exécuter le test SQL et vérifier qu'il termine sans exception.
4. Tester un échec, la temporisation, une réussite et une révocation admin.
5. Publier ensuite le nouveau build mobile et le dossier web FTP.

En cas d'incident avant la mise en service, exécuter le script de retour arrière.
Après collecte de validations réelles, préférer une migration corrective afin
de préserver l'historique d'audit.
