# Audit comptes, publicites et communaute - 18 octobre 2026

## Suivi des corrections du 18 octobre

Les deux P1 ci-dessous sont corriges et deployes cote serveur. Voir
BUILD_10_SECURITE_PANEL_2026_10_18.md pour les migrations, tests et limites.
Les constats suivants decrivent l'etat observe avant ces corrections.
Le P2 concernant les publications du mode actif reste ouvert.

## Perimetre et limites

Lecture du code Flutter local et des fonctions, droits et politiques du projet
Supabase nuoonagnkhbeeymtvrcn. Aucune modification des donnees de production,
aucun achat et aucune publication visible de test. Ce controle ne certifie pas
le fonctionnement natif complet sur iPhone ou Android.

Les parcours Exam GPX/PA et Scolarite GPX/PA utilisent les memes politiques
community_posts/community_comments. Le mode actif a aussi ete inspecte.

## A corriger avant validation publique

### P1 - Contournement de moderation par l'auteur

Les politiques UPDATE community_posts_owner_update et community_comments_update
autorisent l'auteur a modifier sa ligne, sans limiter les transitions de statut
ni verifier les sanctions sur UPDATE. Le role authenticated a le droit UPDATE
sur status. Les triggers inspectes ne protegent pas les champs de moderation.
Un auteur peut donc demander directement de repasser son contenu masque au
statut published. Ne pas confondre l'absence de bouton Flutter avec une protection.

References locales : supabase/migrations/20260904003000_active_community_space.sql,
lignes 109 et 127. Confirme par introspection des politiques actuellement deployees.
Correction attendue : proteger les champs et transitions reserves au staff tout
en preservant l'edition/suppression autorisee de l'auteur et les RPC du panel.
Ajouter des tests utilisateur normal, sanctionne, moderateur, admin et owner.

### P1 - Retrait du role fondateur par un admin

La fonction deployee public.set_user_role interdit a un admin de promouvoir un
compte owner, mais ne verifie pas le role actuel du compte cible avant UPDATE.
Un admin peut donc retrograder un owner. La fonction est executable par les
utilisateurs authentifies (controle du role appelant dans la fonction).
Correction attendue : proteger les comptes owner contre les changements par
un admin et proteger le dernier owner, avec tests sans affecter les vrais comptes.

### P2 - Publications du mode actif refusees

public.community_can_publish ne traduit que exam/school + pa/gpx en espace.
user_mode=active donne NULL : les insertions de publications/commentaires pour
l'espace active sont refusees, bien que cinq categories actives existent.
CommunityRepository.activeScope connait bien ce mode. Aligner le controle
serveur avec active_community_access et conserver le controle des sanctions.

## Publicites : configuration et controles verifies

- app_runtime_config : ads_enabled=true, intervalle 8 minutes, sans dates limites.
- rewarded_ssv_config : enabled=true (recontrole le 18 octobre).
- Interstitielles demandees a la fermeture du resultat de quiz et a la sortie
  du parcours saving_screen, pas comme un minuteur permanent sur tous les ecrans.
- AdService exclut les Premium et ne demande pas de pub si les droits utilisateur
  ou la configuration sont indisponibles.
- Consentement UMP et demandes non personnalisees presentes.
- Rewarded : challenge serveur, verification signee Google, attente de granted_at;
  le callback du telephone ne credite pas directement le quota.
- begin_rewarded_request refuse les Premium, les blocs inconnus et un quota non
  epuise. Attention : les blocs Google de debug sont aussi refuses par cette RPC;
  un test debug seul ne valide donc pas le parcours de recompense de production.

Non verifies : disponibilite reelle des annonces AdMob, affichage sur appareil,
fermeture, retour au quiz, reception effective du callback SSV et credit unique.
Ne pas cliquer sur des annonces reelles pour tester.

## Protections deja presentes

- purge_user non executable par anon/authenticated.
- set_admin_panel_code refuse anon et appelle une garde owner pour les sessions
  authentifiees ; chemin service_role preserve.
- Changement direct de user_profiles.role bloque par trigger.
- Insertion communautaire impose auteur=session, categorie autorisee et sanctions.
- Anti-doublon et limitation des commentaires presents.

## Verification automatique

- Suite Flutter complete executee pendant cet audit : 229 tests reussis.
- Analyse Flutter complete relancee le 18 octobre : aucune anomalie signalee.
- Ces tests ne constituent pas une preuve de transactions Apple, d'affichage
  AdMob ou d'un parcours de publication/moderation de bout en bout.

## Recette encore necessaire

- Deux comptes gratuits distincts : publier, lire, commenter, aimer, signaler,
  bloquer et supprimer son propre contenu dans les quatre parcours.
- Compte sanctionne : verifier aussi les modifications et appels directs.
- Moderateur/admin/owner : verifier les actions permises et les refus hors droits.
- Gratuit : voir une interstitielle apres une rupture de quiz, respecter le delai.
- Rewarded : quota epuise, video terminee, credit serveur unique, refus d'un rejeu.
- Premium : aucune pub ; achat et restauration conferent les droits du bon compte.
- Deconnexion/reconnexion entre compte gratuit et Premium, erreur reseau et reprise.

Les trois constats serveur ci-dessus sont documentes, pas corriges dans cet audit.
