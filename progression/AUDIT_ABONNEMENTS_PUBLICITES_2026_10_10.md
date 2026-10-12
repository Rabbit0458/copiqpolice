# Audit abonnements, quotas et publicites - 10 octobre 2026

## Verdict

Integration presente, mais fonctionnement complet non valide pour publication.
Lecture de la copie recente Flutter et des fonctions/politiques Supabase en
production. Aucun achat, impression publicitaire, attribution de recompense,
changement de droits ou modification des regles commerciales effectue.

## Points confirmes

- RevenueCat utilise l'UID Supabase ; achat et restauration exigent une identite
  verifiee, serialisent les operations SDK et recontrolent le compte apres achat.
- Produits mensuel/annuel associes aux packages ; prix provenant de la boutique.
- Annulation de la fenetre d'achat distinguee d'un achat reussi. Restauration
  exige un droit premium actif. Lien de gestion natif present.
- SubscriptionService fusionne droits serveur et RevenueCat. Les pubs utilisent
  ce service commun et sont refusees quand isPremium est vrai.
- AdMob utilise UMP, ne demande pas de pub sans canRequestAds et desactive les
  pubs si la configuration distante est indisponible/invalide.
- Configuration Supabase relue : ads_enabled=true, intervalle=20 minutes,
  aucune borne de calendrier. Il s'agit d'un minimum entre deux interstitielles,
  pas d'une pub automatique toutes les 20 minutes.
- Interstitielles demandees apres fermeture d'un PopupRoute libelle Resultat
  (avec accent dans le code), jamais declenchees par une minuterie seule.
- Recompense demandee volontairement depuis le verrou quota ; callback local
  de recompense et identite recontroles avant appel serveur.

## Problemes et risques

### P1 - Protection serveur des contenus Premium insuffisante

Politiques distantes confirmees : cours_scolarite_read = is_published,
quiz_scolarite_read = is_active, scolarite_fragments_authenticated_read = true.
Ces regles n'exigent pas d'abonnement. Le verrou Flutter ne protege pas un appel
direct a l'API. Definir precisement les contenus gratuits avant toute correction
RLS, avec exceptions administratives preservees. Correspond a SEC-03.

### P1 - Droits attaches au compte insuffisamment controles apres attente

lib/core/services/subscription_service.dart:378 : refresh publie un resultat
asynchrone sans verifier que l'UID n'a pas change. Une ancienne requete peut
reecrire un statut apres deconnexion/changement de compte. RevenueCat protege
son propre statut par UID, mais pas cette copie de l'etat serveur.

lib/core/services/entitlement_service.dart:143 : force=true remplace _inflight
pendant un appel existant ; les deux appels utilisent ensuite ce champ mutable
pour complete et finally. Risques de completer nul/deja termine et de future
initiale jamais terminee. Le catch conserve aussi state.value sans controle UID.
Constats de code, scenario concurrent non reproduit sur appareil pendant l'audit.

### P1 - Quota consomme deux fois et refus non bloquant dans l'observateur

home_page_gpx_exam.dart:185 consomme avant pushNamed (ligne 225).
main.dart:1583 appelle ensuite onRoutePushed ; subscription_service.dart:302
considere toute route contenant /gpx_exam ou /pa_exam comme un quiz.
Le second appel consomme encore s'il reste du quota. L'anti-doublon ne couvre
que les appels de l'observateur, pas la consommation manuelle precedente.
Des menus d'examen peuvent aussi consommer une utilisation.
L'observateur ignore le resultat du consume et ne peut pas annuler la navigation
deja effectuee : ce n'est pas un verrou fiable a quota epuise.

### P2 - Echec de verification des droits pouvant autoriser des pubs

subscription_service.dart:333 : si is_user_premium echoue, _fetchIsPremium
retourne seulement le statut RevenueCat, sans propager l'incertitude.
Si ce statut est faux (ex. abonnement web), et que la lecture du quota reussit,
refresh efface lastError et publie isPremium=false. AdService considere alors
le compte eligible. Conserver un statut de verification incertain pour ne pas
servir de pubs a un abonne dont les droits n'ont pas pu etre verifies.

### P2 - Date de reset Flutter differente du serveur

subscription_service.dart:84 calcule updated_at + 7 jours. Le serveur
consume_free_request et get_my_entitlement utilisent window_start + 7 jours.
Chaque consommation et recompense modifie updated_at. L'interface peut donc
annoncer une date plus tardive, voire refuser un acces que le serveur reouvrirait.
Utiliser la fenetre serveur comme reference commune.

### P2 - Recompense publicitaire contournable cote serveur

ad_service.dart:329 cree son propre nonce. grant_rewarded_request verifie UID,
longueur, doublon et cadence de 30 secondes, mais pas de preuve AdMob signee.
Un client peut appeler directement la RPC sans visionnage. Validation SSV et
deduplication par transaction fournisseur necessaires. Correspond a SEC-04.
La limite de frequence ne remplace pas une preuve de visionnage.

### P2 - Test sandbox : statut client et autorisation serveur differents

RevenueCatService accepte le droit actif du SDK, y compris sandbox ;
is_user_premium cote serveur ne prend que store_entitlements PRODUCTION.
Le client peut donc afficher Premium apres achat test alors que la consommation
manuelle GPX appelle un serveur qui le voit gratuit et peut refuser le quiz.
Prevoir un parcours de test sandbox controle sans creer de droits production.

### P3 - Couverture publicitaire et regles d'acces non uniformes

L'observateur exige exactement le libelle singulier du resultat. Deux quiz PA
utilisent le pluriel : pa_attention_visuelle_page.dart:758 et
pa_quiz_tests_psycotechniques_suite_logiques.dart:917 ; ils ne declenchent pas
l'interstitielle via cet observateur.

Les homes de scolarite GPX et PA utilisent canAccessPremiumContent (Premium
strict), tandis que les homes examens utilisent aussi le quota gratuit.
Confirmer que cette difference est voulue ; ne pas ouvrir les cours payants
automatiquement sous pretexte d'uniformiser les controles techniques.

## Tests executes

- Flutter : ad_policy, subscription_plan, store_operation_queue et
  revenuecat_configuration : **17/17 reussis**.
- Node : revenuecat-normalize : **9/9 reussis**, dont annulation avec maintien
  jusqu'a expiration, remboursement, sandbox/production, delai de grace,
  produits Google et transferts/alias.
- Ces tests ne couvrent pas completement AdMob natif, les services singleton
  concurrents, ni un achat/recu reel. Aucun achat de bout en bout declare valide.

## Perimetre et suite

Services communs, homes et recherches de routes/resultats dans les quatre
parcours : Scolarite GPX, Scolarite PA, Exam GPX, Exam PA. Cartographie de
reference consultee ; aucune verification visuelle exhaustive de tous les quiz.
Audit sans correctif fonctionnel : prioriser droits serveur, isolation des
comptes, consommation unique et absence de pubs en cas de droits incertains.
Puis aligner le reset et securiser les recompenses. Tester sur Android via
Google Play interne, avec compte gratuit et achat de licence test.
