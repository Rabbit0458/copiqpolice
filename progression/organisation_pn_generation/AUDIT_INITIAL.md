# Audit initial — banque « Organisation de la Police nationale »

Date de l'audit : 2026-08-28 (Europe/Paris)  
État : audit local, aucune écriture distante et aucun déploiement Supabase.

## Périmètre contrôlé

- règles permanentes `AGENTS.md` ;
- cartographie complète GPX/PA et inventaire des 1 409 sources ;
- pages Organisation GPX et PA, leurs routes et leurs pages de cours partagées ;
- huit pages PA fournies, ainsi que leur résolution par `ScolariteText` et l'inventaire ;
- schéma de scolarité, questions, modules, historique détaillé, signalements, cycle éditorial et audit ;
- migrations Organisation datées du 28 août 2026 ;
- centre de correction de `copiq-web` et résolveur de cibles ;
- répertoire `assets/grades` et déclaration Flutter ;
- pages Exam GPX et Exam PA, limitées au contrôle de non-régression et d'absence de raccordement à cette banque.

## Conclusions bloquantes

1. Les migrations `20260828120000`, `121000`, `122000` et `123000` sont des travaux locaux non suivis par Git. Elles ont été auditées comme état préexistant et ne doivent pas être appliquées aveuglément.
2. `20260828120000_organisation_police_quiz_bank.sql` ne crée pas une table canonique et une table d'affectations : il conserve une copie textuelle par track dans `quiz_scolarite_questions`.
3. La même migration publie immédiatement des données (`publication_status='published'`) sans version active, staging, revue, rapport qualité ni bascule transactionnelle.
4. Elle fabrique un quatrième distracteur à partir d'une réponse voisine et peut insérer « Aucune de ces propositions », formulation explicitement interdite.
5. La RPC `public.organisation_quiz_session(p_module, ...)` fait confiance à un module passé par le client. Le prompt exige une liste blanche interne dérivée du track et du mode.
6. Cette RPC est `security definer`, située dans le schéma exposé `public`, avec `search_path=public`. La documentation Supabase actuelle recommande `security invoker` par défaut ; lorsqu'un definer est indispensable, elle impose un `search_path` vide, des noms qualifiés et une surface d'exécution strictement révoquée.
7. Les migrations de couverture dupliquent chaque question via un produit cartésien GPX/PA et les publient directement. Elles ne prouvent ni source officielle, ni unicité sémantique, ni justification individuelle de chaque distracteur.
8. Les pages Flutter Organisation contiennent chacune environ 4 300 lignes de banque locale identique. Seuls le nom de widget, la route et la table historique héritée diffèrent. Il n'existe donc pas encore de dépôt central commun.
9. Les difficultés locales emploient à la fois `Moyen` et `Moyenne`. Le contrat cible n'autorise que `Facile`, `Moyenne`, `Difficile`.
10. Le résolveur admin traite encore le type `question` comme cible non résolue pour cette banque ; les RPC de correction existantes ciblent d'autres tables et la suppression de cible reste physique pour leur liste blanche historique.

## Éléments réutilisables

- `quiz_answer_history` et `record_learning_answer(...)` fournissent déjà l'historique question par question, les snapshots, la version, le temps de réponse et l'idempotence client.
- `report_question` dispose déjà du flux de signalement ; la migration `121000` ajoute utilement `question_id`, `question_version` et `question_snapshot`, mais doit être complétée par les contraintes de portée canonique.
- les gardes admin, permissions, journaux `admin_audit_logs` et fonctions de cycle éditorial existantes peuvent être étendues sans créer un second panel.
- les 25 fichiers PNG de grades existent, sont tous distinctement nommés et `pubspec.yaml` déclare `assets/grades/`.
- les pages de contenu partagé sous `lib/content/pa_scolarite/organisation_pn/` desservent déjà des routes GPX et PA homologues.

## État du corpus local

Les huit coquilles PA affichent un fragment `ScolariteText` et ne prouvent pas l'absence de contenu. La cartographie et `sources.jsonl` renvoient notamment vers les vraies pages Organisation, DGSI, Préfecture de police, organigrammes, hiérarchie, formation initiale, droits/obligations, déontologie et horaires. Ces contenus sont des sources pédagogiques internes à confronter aux autorités officielles ; ils ne sont pas une autorité factuelle suffisante pour publication.

## Documentation Supabase vérifiée

Le changelog filtré « breaking changes » a été consulté le 2026-08-28. Aucun changement recensé ne modifie le modèle SQL prévu ; les changements récents pertinents imposent surtout de ne pas épingler explicitement une version d'extension. La documentation actuelle confirme : RLS sur tout objet exposé, séparation grants/policies, révocation explicite des mutations, `security_invoker` par défaut, fonctions privilégiées hors schéma exposé, `search_path=''` et noms pleinement qualifiés.

## Décision d'audit

Les quatre migrations préexistantes sont classées **non déployables**. Elles seront conservées comme preuve de travail antérieur, puis neutralisées par une migration additive correcte seulement après validation locale. Aucune donnée de ces fichiers ne peut être réputée officielle ou publiable avant constitution du corpus et passage des validateurs.
