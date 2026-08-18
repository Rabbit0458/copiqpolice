# Audit Supabase avant migration des contenus

Date de l'audit : **14 août 2026**  
Projet : **COP'IQ Production**  
Référence Supabase : `nuoonagnkhbeeymtvrcn`  
Région : `eu-west-3` (Paris)  
État observé : `ACTIVE_HEALTHY`  
Offre : **Pro**  
PostgreSQL : **17.4.1.074**

## Résultat de l'étape 1

L'audit distant en lecture seule est réalisé. Aucune table, ligne, politique, fonction ou ressource Storage n'a été modifiée ou supprimée.

La sauvegarde locale complète du projet Flutter est disponible :

- archive : `/private/tmp/copiqpolice-before-content-migration-20260814-161850.tar.gz` ;
- taille : **2,8 Go** ;
- SHA-256 : `cdae106a848bb0f894c76fcdb0981c9a2f0244a89c63b1787896fa1ce9d19e15`.

La sauvegarde physique distante est certifiée depuis le tableau de bord Supabase :

- date : **14 août 2026 à 03:25:44 UTC** ;
- type : **Physical** ;
- restauration proposée par Supabase : **oui** ;
- rétention visible : sept sauvegardes quotidiennes, du 8 au 14 août 2026.

Comme les backups Supabase n'incluent pas les objets Storage, une copie locale complémentaire a été créée :

- archive : `/private/tmp/copiq-supabase-storage-20260814.tar.gz` ;
- taille : **4 645 529 octets** ;
- SHA-256 : `7e58a609348aa6151ff63c2ff84b5f4a51b0f7b1f417acfe383dc1d399dcd173` ;
- **22 objets médias** contrôlés individuellement par taille et SHA-256.

À la demande du propriétaire, `quiz_cinema/quiz_cinema_merged.jsonl` est exclu de cette archive. Sa copie locale a été supprimée ; l'objet distant n'a pas été supprimé. Son contenu sera traité ultérieurement dans une table dédiée.

## Structure générale observée

- **202 tables** dans le schéma `public` ;
- **202/202 tables avec RLS activée** ;
- **676 politiques RLS** dans `public` ;
- **6 vues** dans `public` ;
- **184 fonctions `SECURITY DEFINER`** dans `public` ;
- **101 fichiers de migration SQL locaux** ;
- aucune table existante n'a été supprimée ou altérée pendant l'audit.

## Tables pédagogiques existantes

### `public.cours_scolarite`

- **14 cours** actuellement présents ;
- RLS : **activée** ;
- lecture applicative : utilisateurs authentifiés, uniquement lorsque `is_published = true` ;
- administration : utilisateurs authentifiés disposant de `has_admin_permission('quiz.write')` ;
- champs existants : route, filière, module, section, code, titre, sous-titre, Markdown, points clés, références légales, quiz associé, couleur, ordre et cycle de publication ;
- cycle éditorial existant : brouillon, programmation, publication et archivage.

Conclusion : cette table constitue une bonne fondation, mais elle ne modélise pas encore tous les blocs visuels, chapitres, versions et médias nécessaires à la migration complète.

### `public.quiz_scolarite_questions`

- **228 questions** actuellement présentes ;
- RLS : **activée** ;
- lecture applicative : utilisateurs authentifiés, uniquement lorsque `is_active = true` ;
- administration : utilisateurs authentifiés disposant de `has_admin_permission('quiz.write')` ;
- champs existants : module, filière, catégorie, difficulté, question, choix, réponse, explication, référence légale, ordre et cycle de publication.

Conclusion : la base des quiz de scolarité existe, mais l'audit des 1 409 fichiers devra déterminer les modèles complémentaires requis pour tous les quiz School et Exam.

## Supabase Storage

Buckets observés :

| Bucket | Public | Objets observés | Limite de taille | Types MIME autorisés |
|---|---:|---:|---|---|
| `assets` | oui | 22 | non définie | non définis |
| `forum-posts` | oui | 0 | non définie | non définis |
| `quiz_cinema` | oui | 2 | non définie | non définis |

Aucune politique personnalisée n'est actuellement déclarée sur `storage.objects` ou `storage.buckets`. Les buckets étant publics, la lecture publique est possible, tandis que les opérations d'écriture restent refusées par défaut sans politique ou accès serveur privilégié.

Pour les futurs médias pédagogiques, il faudra créer un bucket dédié avec limites de taille, liste MIME, lecture adaptée aux cours publiés et écriture réservée aux administrateurs. Les modifications devront passer par l'API Storage et non par des écritures directes dans le schéma `storage`.

## Alertes de sécurité Supabase

Le conseiller Supabase signale **694 avis de sécurité** :

| Famille | Nombre | Priorité pour ce chantier |
|---|---:|---|
| Objets visibles dans GraphQL pour `anon` | 195 | élevée, revue des droits nécessaire |
| Objets visibles dans GraphQL pour `authenticated` | 218 | élevée, appliquer le moindre privilège |
| Fonctions privilégiées exécutables par `anon` | 98 | critique, revue fonction par fonction |
| Fonctions privilégiées exécutables par `authenticated` | 175 | critique, vérifier garde interne et droits `EXECUTE` |
| Tables RLS sans politique | 3 | informative, peut être volontairement inaccessible |
| Extensions dans `public` | 2 | moyenne |
| Durée OTP trop longue | 1 | moyenne |
| Protection contre mots de passe compromis désactivée | 1 | élevée |
| Version PostgreSQL signalée vulnérable | 1 | critique, planifier la mise à niveau via Supabase |

Points notables :

- aucun tableau `public` sans RLS n'a été détecté ;
- plusieurs tables sensibles, dont des tables administratives et d'archives, restent découvrables via les droits GraphQL ;
- plusieurs fonctions `SECURITY DEFINER` sont encore exécutables par des rôles larges ;
- ces alertes sont antérieures au chantier des cours et ne seront pas corrigées à l'aveugle pendant la migration ;
- toute nouvelle fonction administrative devra vérifier l'utilisateur et ses permissions, fixer son `search_path`, puis retirer `EXECUTE` à `PUBLIC` et `anon`.

Références Supabase :

- [Sécurisation de la Data API](https://supabase.com/docs/guides/api/securing-your-api)
- [Row Level Security](https://supabase.com/docs/guides/database/postgres/row-level-security)
- [Contrôle d'accès Storage](https://supabase.com/docs/guides/storage/security/access-control)
- [Conseiller de base de données](https://supabase.com/docs/guides/database/database-linter)

## Alertes de performance

Le conseiller Supabase signale **276 avis de performance** :

- 25 clés étrangères sans index couvrant ;
- 1 table sans clé primaire ;
- 116 index actuellement inutilisés ;
- 133 groupes de politiques permissives multiples ;
- 1 configuration Auth utilisant un nombre absolu de connexions.

Ces avis doivent être traités séparément et avec mesure. Un index déclaré inutilisé ne doit pas être supprimé automatiquement, surtout avant une migration massive.

## Décision de passage à l'étape suivante

Statut : **audit et protection avant migration terminés**.

Avant toute première migration Supabase :

1. conserver la sauvegarde physique Supabase du 14 août 2026 comme point de restauration de la base ;
2. conserver l'archive Storage et son SHA-256 ;
3. ne supprimer l'objet cinéma distant qu'après import et vérification de la future table dédiée ;
4. préparer ensuite le schéma définitif de migration.
