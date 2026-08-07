# PROMPT D’EXÉCUTION — CENTRALISATION DES CONTENUS ET DE LA NAVIGATION DES QUATRE PARCOURS WEB COP’IQ

## 1. Mission

Tu travailles sur **COP’IQ**, une plateforme de préparation aux concours et à la scolarité de la Police nationale. L’application Flutter est la référence fonctionnelle historique. Le projet web doit devenir son équivalent cohérent, responsive, sécurisé et déployable sur un hébergement statique.

Ta mission est de **centraliser entièrement les contenus, les libellés, les couleurs, les capacités et la navigation des quatre parcours COP’IQ**, puis de faire consommer cette source de vérité par toutes les pages web concernées.

Les quatre parcours sont :

1. `pa_exam` — préparation au concours de Policier adjoint ;
2. `gpx_exam` — préparation au concours de Gardien de la paix ;
3. `pa_school` — scolarité de Policier adjoint ;
4. `gpx_school` — scolarité de Gardien de la paix.

Le résultat ne doit pas être une simple liste de liens. Il faut une architecture durable où toute page sait :

- quel parcours est actif ;
- quelles fonctionnalités sont autorisées ;
- quelles routes utiliser ;
- quels contenus afficher ;
- quels libellés, couleurs et icônes employer ;
- dans quel espace du forum lire ou publier ;
- comment basculer proprement vers un autre parcours ;
- comment rester cohérente avec le profil Supabase et l’application Flutter.

## 2. Emplacements à respecter

Le dépôt principal est :

`/Users/kaiso/Desktop/copiqpolice`

Le projet source du site est :

`/Users/kaiso/Desktop/copiqpolice/copiq-web`

Le dossier final destiné à l’hébergeur est :

`/Users/kaiso/Desktop/copiqpolice/fae16dc1`

Règles impératives :

- modifier uniquement le projet source `copiq-web`, les migrations `supabase/migrations` et la documentation `progression` ;
- ne jamais coder directement dans `fae16dc1` ;
- reconstruire `fae16dc1` avec `PUBLIER_SITE.command` uniquement après validation ;
- conserver le déploiement statique Next.js ;
- ne jamais placer de clé `service_role`, de secret Stripe ou de secret administrateur dans le navigateur ou dans `fae16dc1` ;
- préserver les changements Flutter et les autres modifications déjà présentes dans le dépôt.

## 3. Technologies obligatoires

Utiliser la stack déjà retenue :

- HTML sémantique ;
- CSS moderne et Tailwind CSS ;
- JavaScript uniquement lorsque nécessaire ;
- TypeScript par défaut pour toute nouvelle logique ;
- React 19 ;
- Next.js 16 avec App Router ;
- Supabase Auth, PostgreSQL, RLS et RPC ;
- Lucide React pour les icônes ;
- `next-themes` pour les thèmes ;
- animations CSS/React sobres, respectant `prefers-reduced-motion` ;
- Zod si une validation de structure complexe devient nécessaire.

Ne pas ajouter une dépendance lourde si React, TypeScript ou les composants existants suffisent.

## 4. État réel du projet avant intervention

L’audit a relevé les problèmes suivants :

- les quatre parcours ne disposent pas d’une source de vérité web unique ;
- les libellés et couleurs sont répétés dans plusieurs pages administrateur ;
- `dashboard-content.tsx` contient une constante locale `MODULES` qui mélange PA, GPX, concours et école ;
- `sidebar.tsx` affiche simultanément les contenus PA et GPX, indépendamment du profil actif ;
- plusieurs liens de la barre latérale n’existent pas réellement sous leur forme préfixée, notamment `/gpx/culture-generale`, `/gpx/psychotechniques`, `/gpx/langues` et `/gpx/concours-blanc` ;
- les pages globales réelles sont actuellement `/culture-generale`, `/psychotechniques`, `/langues` et `/concours-blanc` ;
- les routes de cours et quiz existantes sont principalement `/pa/...` et `/gpx/...`, sans séparation structurelle nette entre examen et école ;
- `user_profiles.user_track` contient `pa` ou `gpx` ;
- `user_profiles.user_mode` contient `exam` ou `school` ;
- l’identifiant communautaire correspondant est la combinaison `${track}_${mode}` ;
- l’inscription web ne demande pas encore le parcours ;
- le tableau de bord charge l’utilisateur, l’abonnement, les XP et le quota, mais pas systématiquement le parcours actif ;
- le layout charge séparément l’utilisateur et l’abonnement ;
- la navigation mobile possède un bouton de menu sans tiroir fonctionnel complet ;
- `src/data/modules.ts` contient des cours et métadonnées historiques avec des emojis utilisés comme icônes ;
- les pages PA/GPX existantes refont chacune leur propre vérification d’authentification ;
- l’application Flutter possède déjà une source logique pour `user_track` et `user_mode`, notamment dans `lib/core/services/user_context_service.dart` et `lib/features/home/home_bootstrap.dart`.

Tu dois partir de cet état réel, sans inventer que les quatre parcours sont déjà centralisés.

## 5. Source de vérité à créer

Créer un module central, par exemple :

`copiq-web/src/config/pathways.ts`

Il doit exposer des types stricts :

```ts
export type UserTrack = "pa" | "gpx"
export type UserMode = "exam" | "school"
export type PathwayId = "pa_exam" | "gpx_exam" | "pa_school" | "gpx_school"
```

Créer également :

```ts
export interface PathwayDefinition {
  id: PathwayId
  track: UserTrack
  mode: UserMode
  shortLabel: string
  label: string
  title: string
  description: string
  communitySpaceId: PathwayId
  color: string
  softColor: string
  iconKey: string
  homeHref: string
  capabilities: PathwayCapabilities
  navigation: PathwayNavigationItem[]
}
```

La configuration doit être déclarative, immuable et exploitable côté client comme côté génération statique.

Prévoir au minimum les helpers suivants :

- `isUserTrack(value)` ;
- `isUserMode(value)` ;
- `isPathwayId(value)` ;
- `toPathwayId(track, mode)` ;
- `getPathway(id)` ;
- `getPathwayFromProfile(profile)` ;
- `getDefaultPathway()` uniquement pour les écrans de démonstration, jamais pour écraser silencieusement le profil ;
- `getPathwayNavigation(id, entitlement)` ;
- `getCommunitySpaceId(track, mode)` ;
- `pathwayLabel(id)` ;
- `canUseFeature(pathway, feature)`.

Ces fonctions doivent avoir des tests unitaires.

## 6. Libellés officiels

Employer partout les libellés humains suivants :

| Identifiant | Libellé court | Libellé complet |
|---|---|---|
| `pa_exam` | PA · Concours | Préparation au concours de Policier adjoint |
| `gpx_exam` | GPX · Concours | Préparation au concours de Gardien de la paix |
| `pa_school` | PA · École | Scolarité de Policier adjoint |
| `gpx_school` | GPX · École | Scolarité de Gardien de la paix |

Éviter les formulations confuses telles que :

- « parcours actif policier adjoint » ;
- « PA Exam » visible par l’utilisateur ;
- « GPX School » visible par l’utilisateur ;
- « entreprise » ou tout libellé générique sans rapport avec la Police nationale.

Les identifiants techniques restent en anglais dans le code et en base. Les textes visibles sont en français naturel.

## 7. Couleurs et identité visuelle

Définir une couleur par parcours, cohérente avec les espaces communautaires existants :

- `pa_exam` : rouge framboise COP’IQ ;
- `gpx_exam` : bleu Police nationale ;
- `pa_school` : vert formation ;
- `gpx_school` : violet institutionnel.

Les couleurs doivent :

- respecter un contraste WCAG AA ;
- être disponibles en variante claire et sombre ;
- ne jamais être le seul moyen de comprendre un état ;
- être utilisées avec une icône et un libellé ;
- provenir de la configuration centrale, jamais de constantes dupliquées dans les pages.

Utiliser Lucide React. Ne pas employer d’emojis comme icônes d’interface.

## 8. Capacités attendues par parcours

Construire une matrice fonctionnelle explicite. Elle doit pouvoir évoluer sans modifier toutes les pages.

### `pa_exam`

- culture générale ;
- psychotechniques ;
- préparation aux épreuves ;
- quiz de concours ;
- concours blancs ;
- progression ;
- historique ;
- favoris ;
- forum `pa_exam` ;
- lecture du forum global.

### `gpx_exam`

- culture générale ;
- psychotechniques ;
- langues si applicable ;
- cas pratiques ;
- quiz de concours ;
- concours blancs ;
- progression ;
- historique ;
- favoris ;
- forum `gpx_exam` ;
- lecture du forum global.

### `pa_school`

- tableau de bord de scolarité ;
- cours PA ;
- quiz PA ;
- mémos ;
- notes ;
- progression ;
- historique ;
- favoris ;
- forum `pa_school` ;
- lecture du forum global.

### `gpx_school`

- tableau de bord de scolarité ;
- cours GPX ;
- quiz GPX ;
- cas pratiques si réellement applicable ;
- mémos ;
- notes ;
- progression ;
- historique ;
- favoris ;
- forum `gpx_school` ;
- lecture du forum global.

Si une capacité n’est pas encore codée, ne pas créer un faux lien. Afficher éventuellement un état « bientôt disponible » uniquement s’il est explicitement prévu dans la configuration.

## 9. Stratégie de routes

Établir une table de correspondance officielle avant toute modification.

Deux options sont acceptables :

### Option recommandée : routes canoniques par parcours

Créer progressivement :

- `/parcours/pa-exam/` ;
- `/parcours/gpx-exam/` ;
- `/parcours/pa-school/` ;
- `/parcours/gpx-school/`.

Puis des sous-routes cohérentes :

- `/parcours/pa-school/cours/` ;
- `/parcours/pa-school/quiz/` ;
- `/parcours/gpx-exam/cas-pratiques/` ;
- etc.

Les anciennes routes doivent rester fonctionnelles via redirection ou pages passerelles tant que la migration n’est pas terminée.

### Option transitoire

Conserver les routes existantes mais centraliser leur résolution dans `pathways.ts`.

Dans les deux cas :

- aucun lien ne doit pointer vers une page inexistante ;
- les routes statiques doivent être présentes dans l’export ;
- la navigation ne doit jamais concaténer librement `/gpx/` devant une page globale ;
- créer un test vérifiant chaque `href` de la configuration ;
- conserver les paramètres nécessaires aux pages dynamiques de cours et quiz.

## 10. Sélection du parcours après création de compte

Créer une page premium, claire et non surchargée :

`/choisir-parcours/`

Cette page doit apparaître :

- après la première connexion si `user_track` ou `user_mode` est absent ou invalide ;
- sur demande depuis les paramètres pour changer volontairement de parcours ;
- jamais en boucle lorsqu’un profil valide existe.

Le choix doit présenter quatre cartes lisibles correspondant exactement aux quatre parcours.

Au clic :

1. demander une confirmation concise ;
2. mettre à jour `public.user_profiles.user_track` et `user_mode` ;
3. vérifier que la mise à jour a réellement été enregistrée ;
4. actualiser le contexte web ;
5. rediriger vers l’accueil du parcours ;
6. afficher un message de réussite discret ;
7. ne jamais modifier l’abonnement ;
8. ne jamais modifier les résultats ou la progression des autres parcours.

Une erreur réseau doit laisser le choix visible et réessayable.

## 11. Contexte React unique

Créer un provider, par exemple :

`copiq-web/src/features/pathway/pathway-provider.tsx`

Il doit exposer :

```ts
interface PathwayContextValue {
  profile: WebUserProfile | null
  pathway: PathwayDefinition | null
  loading: boolean
  error: Error | null
  refresh(): Promise<void>
  changePathway(id: PathwayId): Promise<void>
}
```

Objectifs :

- éviter que chaque page refasse la même lecture Supabase ;
- éviter les divergences entre sidebar, header, dashboard et forum ;
- centraliser la validation de `user_track` et `user_mode` ;
- rediriger vers `/choisir-parcours/` seulement lorsque nécessaire ;
- conserver l’authentification dans le layout ;
- gérer proprement le chargement et les erreurs ;
- ne pas utiliser `any`.

Le provider ne doit pas remplacer les contrôles RLS. Il fournit uniquement le contexte d’interface.

## 12. Tableau de bord personnalisé

Supprimer la constante locale `MODULES` de :

`copiq-web/src/features/dashboard/dashboard-content.tsx`

Le tableau de bord doit consommer la définition du parcours actif.

Il doit afficher :

- une salutation utilisant le prénom du profil si disponible ;
- le libellé humain du parcours ;
- une action discrète « Changer de parcours » ;
- les statistiques existantes réellement disponibles ;
- uniquement les modules autorisés pour le parcours actif ;
- la reprise de la dernière activité si disponible ;
- la progression ;
- les contenus recommandés ;
- les états gratuit/premium sans promettre un contenu inexistant.

Ne pas afficher simultanément PA et GPX comme si l’utilisateur suivait les deux.

## 13. Navigation ordinateur et mobile

Refactoriser :

- `copiq-web/src/components/layout/sidebar.tsx` ;
- `copiq-web/src/components/layout/header.tsx` ;
- `copiq-web/src/app/(dashboard)/layout.tsx`.

La navigation doit :

- être dérivée de la configuration centrale ;
- afficher uniquement le parcours actif ;
- conserver les pages transverses : accueil, progression, historique, favoris, forum, notifications, profil, paramètres ;
- signaler le premium sans bloquer visuellement toute la navigation ;
- fonctionner au clavier ;
- avoir des cibles tactiles d’au moins 44 × 44 px ;
- disposer d’un vrai tiroir mobile ouvrable et refermable ;
- fermer le tiroir après navigation ;
- conserver un focus visible ;
- avoir un titre et un `aria-label` adaptés ;
- ne pas utiliser d’emoji ;
- supporter clair et sombre ;
- ne provoquer aucun défilement horizontal.

## 14. Forum et droits de publication

Le forum utilise cinq espaces :

- `global` ;
- `pa_exam` ;
- `gpx_exam` ;
- `pa_school` ;
- `gpx_school`.

Règles obligatoires :

- l’utilisateur peut lire le fil global ;
- l’utilisateur peut lire les quatre espaces spécialisés ;
- l’utilisateur ne peut publier, répondre ou réagir que dans l’espace correspondant à son parcours actif, plus `global` si la politique actuelle l’autorise ;
- un espace extérieur doit afficher clairement « Lecture seule » ;
- changer le filtre du forum ne doit pas changer le profil ;
- changer réellement de parcours passe par la page dédiée et une confirmation ;
- les contrôles d’écriture doivent rester appliqués côté PostgreSQL/RPC, pas uniquement dans React ;
- la source de vérité `communitySpaceId` doit provenir de `pathways.ts`.

## 15. Contenus : inventaire et registre

Créer un registre de contenu typé, séparé de la définition visuelle du parcours, par exemple :

- `src/content/registry.ts` ;
- `src/content/pa-exam.ts` ;
- `src/content/gpx-exam.ts` ;
- `src/content/pa-school.ts` ;
- `src/content/gpx-school.ts`.

Chaque entrée doit préciser :

- identifiant stable ;
- parcours compatibles ;
- type : cours, quiz, exercice, cas pratique, concours blanc, fiche, mémo ;
- titre ;
- description ;
- route ;
- statut : brouillon, publié, archivé, bientôt disponible ;
- accès : gratuit ou premium ;
- ordre ;
- durée estimée ;
- récompense éventuelle ;
- source de données ;
- éventuel identifiant Supabase ;
- date de mise à jour si disponible.

Ne pas dupliquer les textes volumineux uniquement pour satisfaire la nouvelle architecture. Migrer progressivement les contenus de `src/data/modules.ts` vers le registre ou créer des adaptateurs temporaires explicitement documentés.

## 16. Supabase et cohérence du profil

Utiliser :

- `public.user_profiles.user_track` ;
- `public.user_profiles.user_mode` ;
- les espaces `public.community_spaces` ;
- les politiques et RPC communautaires existantes.

Avant toute migration :

- inspecter les contraintes actuelles ;
- vérifier les valeurs historiques ;
- identifier les profils incomplets ou legacy ;
- ne pas convertir automatiquement une donnée inconnue en PA concours sans trace.

Prévoir si nécessaire une migration sûre qui :

- ajoute ou confirme les contraintes `pa|gpx` et `exam|school` sans casser les données existantes ;
- fournit une fonction RPC atomique de changement de parcours ;
- refuse les identifiants invalides ;
- journalise la date du changement si la politique produit le nécessite ;
- ne donne aucun droit à `anon` ;
- révoque `PUBLIC EXECUTE` si nécessaire ;
- conserve RLS ;
- ne renvoie aucune donnée sensible.

Après chaque DDL, exécuter les conseillers Supabase sécurité et performance.

## 17. Administration

Le panel `/admin` doit lui aussi consommer la taxonomie centrale pour les libellés et couleurs d’interface.

À centraliser :

- cartes des quatre parcours du tableau de bord admin ;
- filtres de la modération forum ;
- filtres utilisateurs ;
- éditeur de scopes des modérateurs ;
- tableaux de contenu ;
- statistiques par parcours.

Attention : les droits réels restent définis en base. La configuration React ne doit jamais devenir une autorisation de sécurité.

## 18. Migration progressive et compatibilité

Procéder par lots réversibles :

1. créer les types et la configuration centrale ;
2. ajouter les tests de configuration ;
3. créer le provider de parcours ;
4. créer la page de choix ;
5. connecter le layout ;
6. connecter la sidebar et le header ;
7. connecter le dashboard ;
8. connecter le forum ;
9. connecter les pages cours/quiz ;
10. connecter le panel admin ;
11. créer les redirections ou alias nécessaires ;
12. supprimer seulement ensuite les constantes dupliquées devenues inutiles.

À chaque étape :

- préserver les anciennes routes encore publiées ;
- ne pas supprimer une route avant d’avoir vérifié tous ses consommateurs ;
- ne pas modifier les données de quiz sans validation ;
- ne pas casser les deep links Flutter ;
- documenter les adaptations temporaires.

## 19. Performance

Objectifs :

- une seule lecture du profil par initialisation de session ;
- pas de requête Supabase répétée par carte ;
- configuration statique importable sans effet de bord ;
- composants lourds chargés uniquement lorsque nécessaires ;
- images optimisées ou statiques ;
- aucune boucle de redirection ;
- pas de recalcul coûteux à chaque rendu ;
- utilisation de `useMemo` uniquement lorsqu’elle apporte un bénéfice réel ;
- listes avec clés stables ;
- pagination côté serveur pour les données volumineuses.

## 20. Accessibilité et UI/UX

Le design doit rester premium, minimal et non surchargé.

Exigences :

- hiérarchie claire ;
- typographie cohérente ;
- espacements basés sur une échelle régulière ;
- cartes de parcours faciles à distinguer ;
- pas de gradients excessifs ;
- pas de gros blocs décoratifs inutiles ;
- aucune information uniquement transmise par la couleur ;
- navigation clavier complète ;
- labels de formulaire ;
- messages d’erreur associés ;
- focus visible ;
- contrastes AA ;
- animations entre 150 et 300 ms ;
- respect de `prefers-reduced-motion` ;
- responsive vérifié à 320, 375, 430, 768, 1024 et 1440 px.

## 21. Tests obligatoires

### Tests unitaires

- les quatre identifiants sont reconnus ;
- les combinaisons track/mode produisent le bon identifiant ;
- toute valeur inconnue est rejetée ;
- chaque parcours possède un `homeHref` valide ;
- aucun `href` de navigation n’est vide ;
- les identifiants de forum correspondent exactement aux espaces Supabase ;
- les capacités attendues sont présentes ;
- aucune route dupliquée incohérente.

### Tests de composants

- le dashboard n’affiche que les modules du parcours actif ;
- la sidebar change selon le profil ;
- le tiroir mobile s’ouvre, se ferme et restaure le focus ;
- la page de choix met à jour le profil et redirige ;
- une erreur Supabase est affichée et réessayable ;
- le mode lecture seule du forum désactive réellement les contrôles d’écriture.

### Tests de routes

- chaque lien central déclaré produit un fichier ou une route Next.js ;
- les anciennes routes critiques restent utilisables ;
- `/admin/`, `/dashboard/`, `/choisir-parcours/` et les quatre accueils sont exportés ;
- aucune URL ne renvoie vers `/gpx/culture-generale` si cette route n’existe pas.

### Tests Supabase

- `anon` ne peut pas modifier le parcours ;
- un utilisateur ne modifie que son profil ;
- les valeurs invalides sont rejetées ;
- un utilisateur d’un autre parcours ne peut pas publier dans un espace spécialisé extérieur ;
- le propriétaire admin conserve son scope global ;
- les RPC administrateur gardent leurs contrôles de rôle.

### Vérifications finales

Exécuter au minimum :

```bash
eslint sur les fichiers modifiés
tsc --noEmit
tests unitaires ciblés
build Next.js complet
PUBLIER_SITE.command
```

Vérifier ensuite :

- les 80 routes historiques ou leur équivalent validé ;
- les nouvelles routes de parcours ;
- le manifeste de déploiement ;
- l’absence de secret dans `fae16dc1` ;
- le fonctionnement clair et sombre ;
- l’absence de défilement horizontal.

## 22. Critères d’acceptation

Le chantier est terminé uniquement si :

- il existe une seule taxonomie officielle des quatre parcours ;
- dashboard, sidebar, header, forum et admin utilisent cette taxonomie ;
- un nouvel utilisateur sans parcours est guidé vers un choix explicite ;
- un utilisateur avec profil valide arrive directement sur son accueil ;
- le changement de parcours est enregistré dans Supabase ;
- la navigation n’affiche que les contenus pertinents ;
- aucun lien déclaré ne pointe vers une route inexistante ;
- la lecture inter-parcours du forum reste possible ;
- l’écriture inter-parcours est interdite côté base ;
- l’interface mobile est pleinement fonctionnelle ;
- TypeScript ne contient pas de `any` ajouté pour contourner les types ;
- les tests passent ;
- le build statique passe ;
- `fae16dc1` est régénéré avec succès ;
- la documentation de progression est mise à jour avec les preuves de validation.

## 23. Livrables attendus

À la fin, fournir :

1. la configuration centrale des quatre parcours ;
2. les types et helpers ;
3. le provider React ;
4. la page de choix ;
5. la navigation responsive ;
6. le dashboard personnalisé ;
7. les adaptations du forum ;
8. les adaptations des pages pédagogiques ;
9. les adaptations du panel admin ;
10. les migrations Supabase nécessaires ;
11. les tests ;
12. la documentation de migration ;
13. le dossier `fae16dc1` reconstruit ;
14. un compte rendu précis distinguant ce qui est terminé, testé, transitoire et restant.

## 24. Consigne d’autonomie

Travaille de manière autonome et méthodique. Ne demande pas confirmation pour les choix techniques réversibles et conformes à cette spécification. Inspecte les fichiers réels avant modification. Préserve le travail existant. Applique les migrations importantes de façon sûre. Teste réellement les lectures, écritures et refus d’accès lorsque cela peut être fait sans laisser de données de test.

Ne prétends jamais que le chantier est terminé parce que le build passe seulement. La validation finale doit couvrir la taxonomie, les quatre parcours, les routes, le profil, le forum, la sécurité Supabase, la navigation responsive et l’export statique.
