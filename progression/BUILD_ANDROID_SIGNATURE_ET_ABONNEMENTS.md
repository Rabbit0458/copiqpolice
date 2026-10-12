# Android — signature et abonnements

> État consolidé au 10 octobre : [PUBLICATION_STORES_ETAT_2026_10_10.md](./PUBLICATION_STORES_ETAT_2026_10_10.md). Le suivi final du 4 octobre confirme que le build 1.1.0+8 est diffusé en tests internes et que les deux produits Google sont actifs en France, reconnus Published dans RevenueCat et rattachés à premium/default. Ces étapes ne sont plus à recréer. Compte testeur et achats/restauration sur appareil restent à valider ; aucune publication publique confirmée.

## Copie de travail Windows

`C:\Users\kaiso\Desktop\COPIQPOLICEAPP\copiqpolice`

Ne pas confondre avec l'ancien dépôt `C:\Users\kaiso\Desktop\copiqpolice`.

## Fichiers privés

- `android/copiq-release-key.jks` : clé d'import existante, récupérée du Mac.
- `android/key.properties` : mots de passe et alias existants ; conserver hors de Git.
- `storeFile=../copiq-release-key.jks` : chemin relatif à `android/app`, utilisable sur Windows et Mac si le fichier est placé dans `android`.
- Conserver une sauvegarde privée de ces deux fichiers. Ils ne doivent pas être ajoutés au dépôt GitHub ni partagés dans une conversation.

Le 4 octobre 2026, le certificat de cette clé et celui du bundle produit ont été comparés au certificat d'importation Google Play : correspondance exacte. Aucune réinitialisation de signature n'est nécessaire.

## Compilation

Depuis la racine du projet :

```sh
flutter pub get
flutter build appbundle --release --dart-define-from-file=config/revenuecat.public.json
```

Sortie : `build/app/outputs/bundle/release/app-release.aab`.

Build vérifié le 4 octobre : **1.1.0+8**, signé avec la clé d'import et contenant la permission Google Play Billing. Le numéro 7 étant déjà utilisé sur Google Play, pubspec.yaml passe à 1.1.0+8. Gradle 8.14.4 et Android Gradle Plugin 8.11.1 sont nécessaires avec le Flutter actuellement installé. Des avertissements de futures versions minimales subsistent mais ne bloquent pas ce build.

`config/revenuecat.public.json` contient uniquement les clés SDK publiques natives. Les identifiants serveur et fichiers de signature ne doivent jamais entrer dans cet asset.

## Configuration commerciale attendue

| Plan | Produit Google Play | Package RevenueCat | Prix de référence France |
|---|---|---|---|
| Mensuel | copiq_premium_monthly | $rc_monthly | 8,99 € / mois |
| Annuel | copiq_premium_yearly | $rc_annual | 79,99 € / an |

Les deux produits doivent être associés au droit `premium` et à l'offre `default` du projet RevenueCat COP'IQ. Le prix final affiché et facturé vient du store.

Une compilation réussie ne prouve pas la disponibilité des abonnements. Vérifier l'acceptation du bundle, la création et l'activation des plans Google, leur rattachement RevenueCat, puis un achat et une restauration depuis Google Play avec un compte testeur. Contrôler aussi la synchronisation serveur des droits et la suppression des publicités Premium.

État détaillé et éléments encore bloquants : `CONTROLE_STORES_SECURITE_2026_10_04.md`.
