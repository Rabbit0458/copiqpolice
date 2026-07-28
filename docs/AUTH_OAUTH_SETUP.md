# Connexion Apple & Google — activation

> Le code est en place depuis le 26 juillet 2026. Les boutons sont **masqués
> tant que tu n'as pas fait les étapes ci-dessous** : l'écran de connexion
> actuel reste strictement identique. Aucun risque à déployer en l'état.

---

## Pourquoi c'est bloquant pour l'App Store

Apple impose « Sign in with Apple » dès qu'une application propose une
connexion par e-mail ou par un service tiers. Son absence est un **motif de
rejet systématique** (App Review Guidelines, règle 4.8).

COP'IQ propose la connexion par e-mail : Sign in with Apple est donc obligatoire.

---

## Ce qui a déjà été fait

| Élément | Fichier | État |
|---|---|---|
| Service de connexion externe | `lib/features/auth/oauth_service.dart` | ✅ |
| Boutons Apple / Google | `lib/features/auth/oauth_buttons.dart` | ✅ |
| Intégration écran de connexion | `lib/features/auth/signin.dart` | ✅ |
| Schéma `copiqpolice://` — Android | `android/app/src/main/AndroidManifest.xml` | ✅ |
| Schéma `copiqpolice://` — iOS | `ios/Runner/Info.plist` | ✅ |

> **Effet de bord bénéfique.** Le schéma `copiqpolice://` n'était déclaré
> **nulle part** dans les fichiers natifs, alors que `deep_links_service.dart`
> et `cp_deep_links_handler.dart` s'appuient dessus depuis des mois. Les deep
> links de l'application ne fonctionnaient donc pas non plus. C'est corrigé.

**Aucun paquet n'a été ajouté à `pubspec.yaml`** : on utilise
`signInWithOAuth` de `supabase_flutter`, déjà présent. Pas de `flutter pub get`
à relancer, pas de risque sur le build.

---

## Étape 1 — Apple Developer

Tu as besoin d'un compte **Apple Developer Program** (99 $/an).

1. **Identifiants → App IDs** — sélectionne l'App ID de COP'IQ,
   coche **Sign In with Apple**, enregistre.
2. **Identifiants → Services IDs** → « + »
   - Description : `COP'IQ Web Auth`
   - Identifier : `fr.copiq.police.signin` *(exemple — note-le)*
   - Coche **Sign In with Apple** → **Configure** :
     - Primary App ID : ton App ID
     - Domains : `nuoonagnkhbeeymtvrcn.supabase.co`
     - Return URLs : `https://nuoonagnkhbeeymtvrcn.supabase.co/auth/v1/callback`
3. **Identifiants → Keys** → « + »
   - Nom : `COPIQ Sign In Key`
   - Coche **Sign In with Apple**, Configure → ton App ID
   - **Télécharge le fichier `.p8`** — il n'est téléchargeable **qu'une seule
     fois**. Note aussi le **Key ID**.
4. Note ton **Team ID** (en haut à droite du portail).

Tu dois donc repartir avec quatre informations :

- Services ID (ex. `fr.copiq.police.signin`)
- Team ID
- Key ID
- Contenu du fichier `.p8`

---

## Étape 2 — Supabase

Tableau de bord → **Authentication → Providers → Apple** :

| Champ | Valeur |
|---|---|
| Enabled | ✅ |
| Client IDs | ton Services ID **et** le bundle ID de l'app, séparés par une virgule |
| Secret Key (for OAuth) | contenu du fichier `.p8` |
| Team ID | ton Team ID |
| Key ID | ton Key ID |

Puis **Authentication → URL Configuration → Redirect URLs**, ajoute :

```
copiqpolice://login-callback
https://copiq.fr/auth/callback
http://localhost:3000/auth/callback
```

**Pour Google** (facultatif mais recommandé) : créer un OAuth Client ID dans la
Google Cloud Console, puis renseigner Client ID et Client Secret dans
**Providers → Google**.

---

## Étape 3 — Activer les boutons

Les boutons sont pilotés par des `--dart-define`, ce qui évite d'afficher un
bouton qui échouerait :

```bash
flutter run \
  --dart-define=ENABLE_APPLE_SIGNIN=true \
  --dart-define=ENABLE_GOOGLE_SIGNIN=true
```

Pour la production, ajoute ces deux `--dart-define` à ta commande
`flutter build` (et dans `.github/workflows/flutter-release.yml`).

Le bouton Apple ne s'affiche que sur **iOS, macOS et web** — Apple n'exige pas
sa présence sur Android, et son affichage y serait contre-productif.

---

## Étape 4 — Vérifier

1. Lancer avec les `--dart-define` ci-dessus.
2. Écran de connexion → un séparateur « ou » et les boutons apparaissent.
3. Appuyer sur **Continuer avec Apple** → le navigateur s'ouvre.
4. Après authentification, retour automatique dans l'application.
5. Vérifier dans Supabase → **Authentication → Users** que le compte est créé
   avec le provider `apple`.

---

## Résolution des problèmes

| Symptôme | Cause probable |
|---|---|
| « Cette méthode n'est pas encore activée » | Provider désactivé dans Supabase |
| Le navigateur s'ouvre mais ne revient pas | `copiqpolice://login-callback` absent des Redirect URLs Supabase |
| `invalid_client` | Services ID, Team ID ou Key ID incorrect |
| Rien ne se passe au clic | `--dart-define` oublié au build |
| Retour sur le navigateur au lieu de l'app | Réinstaller l'app : les schémas natifs ne sont lus qu'à l'installation |

---

## Reste à faire

- **Écran d'inscription** — les boutons n'ont été posés que sur l'écran de
  connexion. L'inscription est un assistant multi-étapes de 2 518 lignes ;
  l'insertion demande de choisir la bonne étape et de la tester visuellement.
  Apple n'exige la présence du bouton que là où une connexion est proposée,
  donc ce n'est pas bloquant pour la soumission.
- **Masquage de l'e-mail Apple** — Apple permet à l'utilisateur de masquer son
  adresse (`@privaterelay.appleid.com`). Vérifier que la création de profil
  gère ce cas, notamment l'envoi d'e-mails transactionnels.
- **Suppression de compte** — Apple exige que la suppression soit possible
  in-app. C'est déjà le cas (`delete-user-cascade`), mais à retester avec un
  compte créé via Apple.
