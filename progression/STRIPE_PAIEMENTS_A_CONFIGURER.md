# COP'IQ — Stripe et abonnements à configurer

> Document de reprise pour terminer plus tard la configuration des paiements.
>
> Dernier état des lieux : 4 août 2026.

## Objectif

Permettre à un utilisateur de souscrire à COP'IQ Premium, de conserver son accès sur le web et le mobile, puis de gérer ou annuler son abonnement sans intervention manuelle.

## État actuel

- [x] Une page d'abonnement existe sur le site.
- [x] Une fonction Supabase de création de Checkout existe : `cas_pratique_create_checkout`.
- [x] Un webhook Stripe existe : `cas_pratique_stripe_webhook`.
- [x] Une table d'abonnements existe : `cas_pratique_subscriptions`.
- [x] Le webhook vérifie la signature Stripe.
- [x] Le code du parcours complet est raccordé entre le site, Flutter et Supabase.
- [x] Stripe est entièrement raccordé en environnement de test.
- [ ] Les achats de contrôle avec les cartes de test Stripe restent à exécuter depuis un compte utilisateur COP'IQ.

## 1. Décisions à prendre avant de configurer Stripe

- [x] Unifier les prix de test affichés et configurés.
  - Hebdomadaire actuellement affiché : `4,99 €`.
  - Mensuel : `8,99 €`.
  - Annuel actuellement affiché : `86,99 €`.
- [ ] Décider quels abonnements bénéficient d'un essai gratuit de 7 jours.
- [ ] Décider si les codes promotionnels Stripe sont autorisés.
- [ ] Définir la liste exacte des avantages Premium.
- [x] Choisir une seule source de vérité pour les abonnements.

### Source de vérité recommandée

Utiliser uniquement `public.cas_pratique_subscriptions`.

Les anciennes tables ou lectures à supprimer/migrer sont :

- `subscription_payement`
- `billing_subscriptions`

Le site, Flutter, le webhook et le panel abonnements utilisent désormais `cas_pratique_subscriptions`.

## 2. Travaux à terminer dans le code

### Site web

- [x] Remplacer les appels `/api/stripe/checkout` et `/api/stripe/portal` par des appels aux fonctions Supabase.
- [x] Ne pas dépendre des routes API Next.js tant que le site utilise `output: "export"` et reste hébergé en statique.
- [x] Envoyer le JWT Supabase de l'utilisateur à la fonction de Checkout.
- [ ] Afficher un message d'attente après le retour de Stripe jusqu'à confirmation du webhook.
- [x] Rafraîchir le statut d'abonnement après un achat ou un retour du portail.

### Fonctions Supabase

- [x] Conserver et finaliser `cas_pratique_create_checkout`.
- [x] Conserver et finaliser `cas_pratique_stripe_webhook`.
- [x] Créer `cas_pratique_customer_portal`.
- [ ] Créer une fonction d'annulation si l'annulation doit être proposée directement dans l'application.
- [x] Faire accepter à la fonction Checkout uniquement un plan contrôlé : `week`, `month` ou `year`.
- [x] Résoudre le Price ID côté serveur plutôt que d'accepter librement un `price_id` fourni par le client.
- [x] Ajouter l'idempotence des webhooks en enregistrant chaque `event.id` Stripe dans une table avec contrainte unique.
- [x] Vérifier et journaliser les erreurs Supabase au lieu de confirmer silencieusement un événement mal traité.
- [ ] Vérifier que le webhook conserve l'accès jusqu'à `current_period_end` lors d'une annulation en fin de période.

### Application Flutter

- [ ] Supprimer ou fusionner les deux services de paiement concurrents :
  - `lib/core/services/stripe_payment_service.dart`
  - `lib/core/payments/payments_service.dart`
- [x] Aligner les appels actifs sur le préfixe `cas_pratique_*`.
- [x] Faire lire le statut Premium depuis la source de vérité choisie.
- [ ] Vérifier les liens profonds de retour après paiement.

## 3. Configuration Stripe en mode test

- [x] Créer ou ouvrir le compte Stripe COP'IQ.
- [ ] Compléter les informations de l'entreprise et le compte bancaire.
- [x] Rester en mode test pour toute la première configuration.
- [x] Créer le produit `COP'IQ Premium`.
- [x] Créer les prix récurrents retenus : semaine, mois et année.
- [x] Copier les trois identifiants `price_...` de test dans Supabase.
- [x] Configurer le Customer Portal :
  - modification du moyen de paiement ;
  - consultation des factures ;
  - annulation de l'abonnement ;
  - réactivation si souhaitée ;
  - identité visuelle et URL des conditions.

## 4. Secrets Supabase

Ne jamais placer une clé Stripe secrète ou la clé `service_role` dans le code client ni dans une variable `NEXT_PUBLIC_*`.

- [x] Vérifier la présence de `STRIPE_SECRET_KEY` dans les secrets Supabase.
- [x] Vérifier la présence de `STRIPE_WEBHOOK_SECRET` dans les secrets Supabase.
- [x] Vérifier la présence des Price IDs côté serveur :
  - `STRIPE_PRICE_WEEK`
  - `STRIPE_PRICE_MONTH`
  - `STRIPE_PRICE_YEAR`
- [ ] Ajouter les URL de retour définitives si elles sont lues depuis les secrets.
- [ ] Vérifier que `SUPABASE_SERVICE_ROLE_KEY` n'est utilisée que dans les fonctions serveur.
- [x] Déployer les fonctions avec la vérification JWT appropriée.
- [x] Déployer le webhook sans vérification JWT Supabase ; son authenticité est vérifiée avec la signature Stripe.

## 5. Webhook Stripe

URL prévue :

```text
https://nuoonagnkhbeeymtvrcn.supabase.co/functions/v1/cas_pratique_stripe_webhook
```

Événements à sélectionner :

- [x] `checkout.session.completed`
- [x] `customer.subscription.created`
- [x] `customer.subscription.updated`
- [x] `customer.subscription.deleted`
- [x] `invoice.payment_succeeded`
- [x] `invoice.payment_failed`

Après création du webhook :

- [x] Copier son secret `whsec_...` dans les secrets Supabase.
- [ ] Envoyer un événement test depuis Stripe.
- [ ] Vérifier une réponse HTTP `200`.
- [ ] Vérifier les journaux de la fonction Supabase.
- [ ] Vérifier la mise à jour de `cas_pratique_subscriptions`.

## 6. Sécurité de la base

- [x] Activer RLS sur la table d'abonnements exposée.
- [x] Autoriser un utilisateur authentifié à lire uniquement sa propre ligne avec `auth.uid() = user_id`.
- [x] Ne permettre aucune écriture d'abonnement depuis le client.
- [x] Réserver les écritures au webhook avec le client serveur.
- [x] Vérifier qu'aucune clé Stripe réelle n'est présente dans le dépôt ou le site exporté.
- [ ] Vérifier les droits d'exécution des éventuelles fonctions SQL privilégiées.
- [ ] Lancer les outils de contrôle de sécurité Supabase avant la production.

## 7. Tests obligatoires en mode test

- [ ] Souscription hebdomadaire réussie.
- [ ] Souscription mensuelle réussie.
- [ ] Souscription annuelle réussie.
- [ ] Carte refusée.
- [ ] Paiement avec authentification 3D Secure.
- [ ] Démarrage et fin d'une période d'essai.
- [ ] Renouvellement réussi.
- [ ] Renouvellement échoué et statut `past_due`.
- [ ] Mise à jour du moyen de paiement dans le portail.
- [ ] Annulation en fin de période.
- [ ] Conservation de l'accès jusqu'à la fin de la période payée.
- [ ] Réactivation d'un abonnement.
- [ ] Réception deux fois du même webhook sans double traitement.
- [ ] Déblocage Premium sur le site.
- [ ] Déblocage Premium dans l'application mobile.
- [ ] Retour correct vers COP'IQ après Checkout et après le portail.

## 8. Passage en production

- [ ] Terminer la vérification d'identité Stripe et activer les paiements réels.
- [ ] Recréer les produits et Price IDs en mode Live.
- [ ] Remplacer les secrets de test par les secrets Live dans Supabase.
- [ ] Créer un webhook Live et enregistrer son nouveau secret `whsec_...`.
- [ ] Vérifier le domaine public et toutes les URL de retour.
- [ ] Mettre à jour les CGU, CGV, mentions légales et politique de confidentialité.
- [ ] Harmoniser tous les prix affichés dans le site et l'application.
- [ ] Effectuer un vrai achat avec une carte réelle.
- [ ] Vérifier l'abonnement dans Stripe, Supabase, le web et le mobile.
- [ ] Effectuer ensuite un remboursement de contrôle.
- [ ] Activer les alertes sur les erreurs du webhook et les paiements échoués.

## 9. Abonnements iOS et Android

Cette partie est distincte de Stripe Checkout sur le web.

- [ ] Intégrer RevenueCat ou une autre couche d'achats intégrés.
- [ ] Ajouter le SDK Flutter nécessaire.
- [ ] Créer les abonnements dans App Store Connect.
- [ ] Créer les abonnements dans Google Play Console.
- [ ] Configurer l'entitlement Premium commun.
- [ ] Relier les identifiants des produits Apple et Google aux offres.
- [ ] Configurer un webhook RevenueCat vers Supabase.
- [ ] Faire écrire les achats mobiles dans la même source de vérité que Stripe.
- [ ] Tester l'achat, la restauration et l'annulation sur les environnements de test Apple et Google.

## 10. Définition de terminé

Les paiements pourront être considérés comme prêts uniquement lorsque :

- [ ] un utilisateur peut acheter chaque formule proposée ;
- [ ] Stripe confirme le paiement par webhook ;
- [ ] Supabase enregistre le bon statut sans écriture possible depuis le client ;
- [ ] le Premium est reconnu sur tous les supports concernés ;
- [ ] l'utilisateur peut gérer et annuler son abonnement ;
- [ ] un échec de paiement retire ou limite l'accès selon la règle choisie ;
- [ ] les événements répétés ne provoquent aucun doublon ;
- [ ] les prix, essais et conditions sont identiques partout ;
- [ ] les tests Live et le remboursement de contrôle ont réussi.

## Notes de reprise

À compléter lors de la prochaine session :

- Compte Stripe créé : `oui — Environnement de test COPIQ`
- Mode Live activé : `oui / non`
- Produit Stripe créé : `oui — COP'IQ Premium`
- Price ID semaine : `à renseigner dans Supabase, jamais ici si le dépôt devient public`
- Price ID mois : `à renseigner dans Supabase, jamais ici si le dépôt devient public`
- Price ID année : `à renseigner dans Supabase, jamais ici si le dépôt devient public`
- Webhook test configuré : `oui — six événements d'abonnement activés`
- Webhook Live configuré : `oui / non`
- Fonctions Supabase déployées : `oui — Checkout, portail client et webhook`
- Dernier test effectué : `configuration Stripe relue par API, secrets Supabase remplacés et portail client actif`
- Prochain blocage : `effectuer les achats avec les cartes de test Stripe depuis un compte utilisateur COP'IQ`

## Publicités du mode gratuit

- [x] Les publicités interstitielles et récompensées sont désactivées pour les abonnés Premium.
- [x] Elles sont actives uniquement pour les comptes gratuits sur Android et iOS.
- [x] Les identifiants de test Google sont utilisés en développement.
- [ ] Fournir les vrais identifiants AdMob et les passer lors de la compilation de production.
