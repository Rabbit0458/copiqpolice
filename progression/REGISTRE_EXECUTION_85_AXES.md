# COP’IQ — Registre d’exécution des 85 axes PREMIUM

Date de clôture technique : 16 septembre 2026  
Périmètre : panel administrateur, Supabase, site public, contrôles de publication et continuité.

## Lecture du registre

- **Livré** : l’interface, la logique et les protections nécessaires sont présentes et vérifiées.
- **Livré — source externe attendue** : le connecteur, les états, la fraîcheur et l’absence de données sont gérés, mais aucune donnée n’est inventée avant la connexion du fournisseur.
- **Livré — exercice opérationnel requis** : le workflow et le journal existent ; une personne autorisée doit encore effectuer l’exercice réel, par exemple une restauration isolée.

Ces deux derniers statuts ne correspondent pas à du développement restant. Ils empêchent au contraire le panel de présenter une donnée externe ou un contrôle humain comme validé sans preuve réelle.

## Axes 1 à 20 — pilotage fondamental

| # | Axe | Statut | Preuve principale |
|---:|---|---|---|
| 1 | Centre de décisions | Livré | Dashboard, centre de décision, comparaison 7/30/90 jours et alertes contextualisées |
| 2 | Analyse pédagogique | Livré | Statistiques d’apprentissage, volumes, réussite, questions et filtres par parcours |
| 3 | Pilotage économique | Livré — source externe attendue | Abonnements réels, factures réelles, registre App Store/Google Play/Stripe/RevenueCat |
| 4 | Cohortes et rétention | Livré | Comparaisons temporelles, activité et segmentation disponible sans exposer les identités |
| 5 | Performance et fraîcheur | Livré | Fraîcheur des sources, index SQL, chargements indépendants et actualisation arrière-plan |
| 6 | Centre de contact | Livré | `/admin/messages`, campagnes, aperçu, confirmation et suivi des livraisons Brevo |
| 7 | Gestion éditoriale | Livré | `/admin/actif`, modèles, brouillon, aperçu, publication et organisation |
| 8 | Recherche globale | Livré | Recherche du panel et navigation directe par rubrique |
| 9 | Journal d’audit | Livré | `/admin/journal`, audit immuable et historique des actions sensibles |
| 10 | Qualité des contenus | Livré | Score qualité, contenus vides/orphelins, médias, validation des questions |
| 11 | Versions iOS/Android | Livré — source externe attendue | `/admin/versions`, registre des boutiques et fraîcheur des imports |
| 12 | Objectifs personnalisés | Livré | Objectifs et progression dans le centre d’exploitation |
| 13 | Comparaison des parcours | Livré | Scolarité GPX, Scolarité PA, Concours GPX et Concours PA uniformisés |
| 14 | Anomalies et alertes | Livré | Centre de décision, santé, incidents et niveaux de gravité |
| 15 | Sauvegarde/restauration | Livré — exercice opérationnel requis | Runbook, journal RTO/RPO et preuve d’exercice dans Pilotage premium |
| 16 | Rôles administrateur | Livré | Owner/AAL2, permissions par rubrique et journalisation |
| 17 | Santé globale | Livré | `/admin/sante` et centre d’exploitation |
| 18 | Acquisition | Livré — source externe attendue | Modèle de source/campagne prêt, données affichées uniquement après collecte consentie |
| 19 | Rapports automatiques | Livré — source externe attendue | Planification, destinataire, format et historique ; envoi conditionné au worker sécurisé |
| 20 | Expérience premium | Livré | Design system COP’IQ, responsive, états vides/erreur et micro-interactions sobres |

## Axes 21 à 50 — décision, exploitation et qualité

| # | Axe | Statut | Preuve principale |
|---:|---|---|---|
| 21 | Alertes intelligentes | Livré | Comparaison de périodes, seuils et échantillons minimums |
| 22 | Parcours utilisateur | Livré | Entonnoirs disponibles à partir des événements réellement collectés |
| 23 | Impact des contenus | Livré | Aperçu utilisateurs/vues/dépendances avant action |
| 24 | Analyse par version | Livré — source externe attendue | Segmentation version/plateforme et registre d’import |
| 25 | OKR | Livré | Tâches/objectifs avec cible, progression, échéance et statut |
| 26 | Notifications admin | Livré | Signalements, messages, incidents et compteurs centralisés |
| 27 | Opérations groupées | Livré | Simulation, liste exacte, phrase de confirmation et journal immuable |
| 28 | Historique/restauration contenus | Livré | Versions, audit et protections avant modification groupée |
| 29 | Cohérence des données | Livré | Sources, contrôles de fraîcheur, qualité et détection d’incohérences |
| 30 | Pilotage quotidien | Livré | Priorités, changements, alertes et actions depuis le dashboard |
| 31 | Vues personnalisées | Livré | Vues enregistrées avec filtres et vue par défaut |
| 32 | Aperçu owner | Livré | Visibilité privée owner séparée de la visibilité utilisateurs |
| 33 | Dictionnaire statistique | Livré | 14 définitions versionnées avec formule, source, cadence et limites |
| 34 | Traçabilité | Livré | Source, fraîcheur, dernière exécution et absence de données explicitée |
| 35 | Expérimentation | Livré | Centre d’exploitation et registre d’expériences |
| 36 | Feature flags | Livré | Flags owner+AAL2, audience, pourcentage, confirmation et retour arrière |
| 37 | Performances réelles | Livré — source externe attendue | Journaux applicatifs raccordés ; métriques non collectées masquées |
| 38 | Incidents | Livré | Cycle détecté → vérifié → clôturé, gravité et historique |
| 39 | Checklist production | Livré | Audit de release et contrôles bloquants automatisés |
| 40 | Non-régression | Livré | Tests contenus, signalements, modèles et compilation de production |
| 41 | RGPD | Livré | Confidentialité, consentement, suppression/export et accès administratifs protégés |
| 42 | Accessibilité | Livré | Focus visible, clavier, mouvement réduit, contrastes et alternatives tabulaires |
| 43 | Feedback utilisateurs | Livré | Messages, signalements, avis, statut et historique |
| 44 | Priorisation | Livré | Gravité, impact, effort, priorité et progression opérationnelle |
| 45 | Prévisions | Livré | Régression seulement après 14 jours observés, fourchette indicative, sinon masquée |
| 46 | Exports professionnels | Livré | CSV/JSON, impression PDF, filtres et date de génération |
| 47 | Mode démonstration | Livré | `/admin/demo`, données fictives, marquage permanent et aucune écriture production |
| 48 | Multilingue | Livré | Tableau de complétude, langue, validation et traductions manquantes |
| 49 | Recommandations éditoriales | Livré | Recommandations motivées sans correction automatique |
| 50 | Historique de santé | Livré | Chronologie événements, incidents, publications et exploitation |

## Axes 51 à 75 — site public, sécurité et conformité

| # | Axe | Statut | Preuve principale |
|---:|---|---|---|
| 51 | Politique de confidentialité | Livré | `/privacy` |
| 52 | CGU | Livré | `/cgu` |
| 53 | Secrets hors front-end | Livré | Audit automatique des exports et fonctions serveur pour les secrets |
| 54 | HTTPS/en-têtes | Livré | Redirection HTTPS, HSTS, CSP et protections navigateur |
| 55 | Consentement cookies | Livré | Choix explicite et révocable |
| 56 | SEO | Livré | Titres, descriptions et métadonnées |
| 57 | Prévisualisation sociale | Livré | Image Open Graph générée |
| 58 | Favicon | Livré | Identité navigateur intégrée |
| 59 | Sitemap/robots | Livré | `/sitemap.xml` et `/robots.txt` |
| 60 | Textes alternatifs | Livré | Contrôle bloquant des images sans `alt` dans l’export |
| 61 | Images optimisées | Livré | Pipeline Next.js et validation des médias |
| 62 | Vitesse/budgets | Livré | Budget par bundle, cache, compression et audit de release |
| 63 | Contrastes | Livré | Variables de design accessibles et états distincts |
| 64 | Responsive | Livré | Desktop, tablette et mobile pour les nouveaux centres |
| 65 | Page 404 | Livré | 404 personnalisée |
| 66 | Liens cassés | Livré | Contrôle de tous les liens internes exportés |
| 67 | Validation formulaires | Livré | Validation client/serveur et erreurs contextualisées |
| 68 | Anti-spam/abus | Livré | Limitations, validation serveur et contrôles d’accès |
| 69 | Analytics responsables | Livré | Données agrégées réelles, seuils et consentement |
| 70 | CTA principal | Livré | Hiérarchie claire sur les pages publiques |
| 71 | Accueil/orientation | Livré | Parcours d’accueil et choix enregistrés |
| 72 | Partage/aperçu | Livré | Métadonnées sociales et aperçu des contenus publics |
| 73 | Centre de confiance | Livré | Pages légales, sécurité et transparence des sources |
| 74 | Observabilité/statut | Livré — source externe attendue | Santé interne et sources ; fournisseur externe raccordable sans fausse donnée |
| 75 | Compatibilité web | Livré | Compilation, export statique et audit de 88 pages HTML |

## Axes 76 à 85 — exploitation avancée

| # | Axe | Statut | Preuve principale |
|---:|---|---|---|
| 76 | Tâches administratives | Livré | Assignation, échéance, priorité, statut, progression et historique |
| 77 | Impact avant publication | Livré | RPC et dialogue d’impact avant modification |
| 78 | Graphe de dépendances | Livré | Catégories/cours, parents, enfants, médias et contenus orphelins |
| 79 | Imports/synchronisations | Livré | Registre des sources, exécutions, durée, volume, erreur et fraîcheur |
| 80 | Coûts techniques | Livré — source externe attendue | Métriques externes normalisées, sans montant fictif |
| 81 | Avis boutiques | Livré — source externe attendue | Registre d’avis et interface, vide tant que les API boutiques ne sont pas raccordées |
| 82 | Récupération abonnements | Livré — source externe attendue | États actif/essai/impayé et webhooks Stripe/RevenueCat côté serveur |
| 83 | Changelog | Livré | Notes de mise à jour publiques et internes |
| 84 | Documentation admin | Livré | README, aides contextuelles et runbooks exploitables |
| 85 | Continuité | Livré — exercice opérationnel requis | Journal de restauration, RPO/RTO, intégrité et preuve |

## Validation de clôture

- Build de production : **95/95 pages statiques générées**.
- Audit export : **88 pages HTML et 89 bundles**, aucun contrôle bloquant en échec.
- Tests de validation des contenus : **6/6**.
- Tests de résolution des signalements : **7/7**.
- Tests des modèles de contenus : **3/3**.
- ESLint du périmètre livré : **0 erreur, 0 avertissement**.
- Export hébergeur : `fae16dc1` régénéré avec sauvegarde automatique.
- Base en production : migrations premium, sources, rapports, métriques et durcissement des privilèges appliqués.
- Uniformisation contrôlée : **Scolarité GPX, Scolarité PA, Concours GPX et Concours PA** ; **Je suis actif** reste volontairement isolé.

## Actions externes non simulables

Le code ne peut pas créer à la place du propriétaire des accès App Store Connect ou Google Play, valider un texte avec un juriste, publier des fichiers sur un hébergeur sans ses accès, ni prétendre avoir restauré une sauvegarde qui n’a pas réellement été testée. Ces opérations sont désormais visibles et traçables dans le panel ; leur absence ne crée ni chiffre fictif, ni statut trompeur.
