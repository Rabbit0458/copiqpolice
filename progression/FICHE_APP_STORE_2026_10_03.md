# Fiche App Store — 3 octobre 2026

Application : 6785313391, COP’IQ – Prépa Police, fr.copiq.app.

## Changements enregistrés et vérifiés dans App Store Connect

- Version de distribution passée de 1.0 à **1.1.0**, correspondant au build cible local 1.1.0+7.
- Texte promotionnel, description française et mots-clés réécrits. Suppression des promesses non étayées de millions de QCM et de position de référence.
- Présentation des quatre parcours Scolarité GPX, Scolarité PA, Exam GPX et Exam PA ; accès gratuit avec publicités, Premium mensuel/annuel, gestion et restauration Apple, indépendance vis-à-vis de l’administration.
- Assistance corrigée : `https://copiq.fr/support` renvoie 404 ; `https://copiq.fr/contact/` fonctionne.
- URL de confidentialité corrigée dans sa rubrique : `https://copiq.fr/privacy/` remplace `https://copiq.fr/legal/`.
- Description : lien vers le contrat standard Apple déjà sélectionné dans les informations générales, `https://www.apple.com/legal/internet-services/itunes/dev/stdeula/`.
- Notes pour la vérification enregistrées : fonctionnement des parcours, achats intégrés RevenueCat, identifiants des deux produits, restauration, publicités et contact d’assistance.
- Preuve : `preuves-stores/appstore-fiche-2026-10-03.png`.

## Éléments conservés / limites

- Nom, sous-titre, catégories Éducation / Références conservés.
- Six captures iPhone 6,5 pouces déjà présentes ; leur conformité visuelle au build 7 et les captures iPad restent à contrôler après compilation.
- Publication automatique après approbation déjà sélectionnée, inchangée. Aucune soumission ni publication effectuée.
- Aucun build sélectionné : le build 7 doit être chargé et testé.

## Informations demandées à l’utilisateur

- Téléphone du contact de vérification et compte de démonstration dédié. Apple refuse de sauvegarder un contact partiel sans téléphone ; les champs de contact ont donc été laissés vides, les textes et notes sont sauvegardés.
- Confirmation des droits sur les cours/photos/contenus et précision sur les images sensibles pour la classification par âge.

## Écarts découverts à résoudre avant soumission

- Classification actuelle 4+ ; questionnaire déclare absence de contenu utilisateur et de messagerie, alors que le projet contient une communauté et que la politique publiée décrit forum/messagerie. Nouvelles questions réseaux sociaux non renseignées. Questionnaire consulté puis annulé, aucune réponse inventée.
- Droits relatifs au contenu non configurés.
- Déclarations App Privacy existantes : seulement nom, e-mail, téléphone, autres coordonnées, emplacement approximatif. Audit complet requis pour les identifiants, achats, données pédagogiques, contenu utilisateur, diagnostics et AdMob ; ne pas publier cette déclaration comme validée par cette intervention.
- Politique de confidentialité publique du 19 août 2026 mentionne encore Stripe pour les achats mobiles, n’intègre pas RevenueCat et décrit le consentement publicitaire comme en cours d’intégration.
- CGU publiques du 1er juin 2026 mentionnent encore une formule hebdomadaire, 86,99 €/an et contact@copiqpolice.app. Elles exigent la majorité, tandis que la politique de confidentialité indique 15 ans. Mettre ces textes en cohérence avec les services et l’âge cible avant publication.
- Statut DSA/business non vérifié dans cette étape.

### Vérification Business après reconnexion

La rubrique Business a ensuite été consultée : contrat applications gratuites **Actif**, contrat applications payantes **Nouveau**. Apple affiche une obligation de mise à jour de l’entité juridique avant de signer ce dernier. La conformité DSA/statut de commerçant est également demandée pour la distribution UE. Aucun contrat accepté, aucune information juridique ou bancaire modifiée. Ces points sont des prérequis supplémentaires à traiter avec le titulaire du compte.

La fiche a été améliorée, elle n’est pas entièrement finalisée ni prête à être soumise.

## Reprise confidentialité — session Apple expirée

**Mise à jour après reconnexion :** identifiant utilisateur désormais entièrement enregistré et vérifié dans le récapitulatif : Fonctionnalité de l’app + Analyses, lié à l’identité, sans suivi publicitaire. La mention d’interruption ci-dessous est historique. Preuve : `preuves-stores/appstore-confidentialite-achats-2026-10-03.png`. Accès AdMob demandé pour vérifier la configuration des publicités avant de finaliser la déclaration globale. Aucun clic sur Publier.

- Catégories **Historique d’achats** et **Identifiant de l’utilisateur** ajoutées et sauvegardées : Apple affiche maintenant sept catégories.
- Historique d’achats entièrement paramétré et sauvegardé : Fonctionnalité de l’app + Analyses, lié à l’identité, sans suivi publicitaire. La page récapitulative a confirmé les finalités et le lien à l’identité.
- Identifiant utilisateur : finalités Fonctionnalité de l’app + Analyses et lien à l’identité sélectionnés, mais **pas encore sauvegardés**. Session expirée à l’étape d’explication du suivi. Reprendre cette catégorie après reconnexion et vérifier le récapitulatif.
- Aucun clic sur Publier : la déclaration globale demeure incomplète, notamment pour AdMob et les contenus communautaires.
- Source RevenueCat consultée : https://www.revenuecat.com/docs/platform-resources/apple-platform-resources/apple-app-privacy . Le code transmet le UUID Supabase comme AppUserID ; aucune transmission explicite d’e-mail, téléphone ou identifiant publicitaire à RevenueCat trouvée dans le service.
- Source AdMob consultée : https://developers.google.com/admob/ios/privacy/data-disclosure . Examiner identifiant d’appareil, données publicitaires, interactions, performances/pannes et localisation approximative dérivée de l’IP. Finalités, liaison et suivi doivent être alignés sur la configuration effective avant publication.
- Vérifications locales : pubspec ne contient pas Firebase, Sentry ou PostHog. `sentry_setup.dart` est une façade sans transmission ; les notifications utilisent `flutter_local_notifications`. Ne pas reprendre les mentions Firebase de la politique publique comme preuve du fonctionnement natif.
- `community_repository.dart` stocke publications, commentaires et messages ; la déclaration des contenus utilisateur est encore à compléter. `ad_service.dart` utilise UMP avant les requêtes publicitaires et permet les options de confidentialité ; le texte public décrivant ce consentement comme non intégré est périmé.

## Mise à jour du 4 octobre 2026
Contact de vérification Apple complété et enregistré avec les coordonnées professionnelles déjà affichées dans Google Play. Voir CONTROLE_STORES_SECURITE_2026_10_04.md pour le contrôle des fiches, les blocages de contrats/produits Android et les correctifs de sécurité appliqués. Les demandes de téléphone plus haut sont désormais résolues ; compte de démonstration et précisions sur les contenus restent à fournir.
