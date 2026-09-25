# COP'IQ — Déploiement FTP

> Ce fichier est recopié automatiquement dans `fae16dc1/` à chaque publication.
> Sa source est `copiq-web/deploy/docs/DEPLOYMENT.md`. **Ne jamais le modifier
> directement dans `fae16dc1/`** : ce dossier est régénéré.

---

## 1. Ce qu'il faut envoyer

**Le contenu du dossier `fae16dc1/`, et rien d'autre.**

Vous envoyez ce qui est *à l'intérieur* de `fae16dc1/` à la racine web de
l'hébergement (souvent `public_html/` ou `www/`), pas le dossier lui-même.

À la racine du site, on doit donc trouver :

```
index.html
404.html
.htaccess
copiq-config.js
_next/
admin/
login/
signup/
tarifs/
preparation/
ressources/
…
```

## 2. Comment le régénérer

Le plus simple : double-cliquer sur `PUBLIER_SITE.command` à la racine du dépôt.

En ligne de commande :

```bash
cd copiq-web
npm install          # la première fois seulement
npm run build        # compile vers copiq-web/out
npm run publish:folder   # copie out/ → fae16dc1/ et vérifie les routes
```

ou, en une commande avec audit préalable :

```bash
cd copiq-web && npm run release:verified
```

Le script de publication :

1. vérifie que dix routes critiques existent et ne sont pas vides, dont
   `admin/index.html`, `login/`, `signup/` et `auth/callback/` ;
2. copie `deploy/.htaccess` ;
3. régénère `copiq-config.js` en reprenant la configuration publique Supabase
   depuis `lib/main.dart` (l'application Flutter est la source de vérité) ;
4. copie ces documents de livraison ;
5. renomme l'ancien `fae16dc1/` en `fae16dc1-backup-<horodatage>/` puis met le
   nouveau en place. **En cas d'échec, l'ancien est restauré.**

## 3. Réglages FTP

| Réglage | Valeur |
|---|---|
| Mode de transfert | **binaire** pour tout (les `.js`, `.css` et polices ne doivent pas être convertis) |
| Fichiers cachés | **à afficher** — `.htaccess` doit impérativement être envoyé |
| Écrasement | remplacer les fichiers existants |
| Dossier `_next/` | envoyer **en entier** ; les noms de fichiers changent à chaque build |

### Ordre recommandé

1. envoyer d'abord `_next/` (les nouveaux actifs) ;
2. puis les pages HTML et les dossiers de routes ;
3. puis `.htaccess`, `copiq-config.js`, `index.html`, `404.html`.

Dans cet ordre, aucun visiteur ne reçoit un HTML qui réclame un actif pas
encore présent.

### Ce qu'il ne faut pas supprimer sur le serveur

Si d'anciens fichiers restent dans `_next/` après l'envoi, ce n'est pas grave :
ils ne sont plus référencés. Les supprimer trop tôt casse en revanche les
pages encore ouvertes dans les navigateurs. Laissez passer quelques heures.

## 4. Vérifications après mise en ligne

À faire dans cet ordre, en navigation privée pour éviter le cache :

| # | À tester | Attendu |
|---|---|---|
| 1 | `https://copiq.fr/` | Vitrine, logo officiel visible, aucun carré noir |
| 2 | `https://copiq.fr/tarifs/` | 4 formules : 0 €, 4,99 €, 8,99 €, 86,99 € |
| 3 | `https://copiq.fr/preparation/gardien-de-la-paix/` | Page de préparation GPX |
| 4 | `https://copiq.fr/ressources/` | Guides + articles |
| 5 | `https://copiq.fr/blog/` et un article | Inchangé par rapport à avant |
| 6 | `https://copiq.fr/une-url-qui-nexiste-pas` | 404 COP'IQ (pas la 404 de l'hébergeur) |
| 7 | `https://copiq.fr/login/` puis connexion | Accès au tableau de bord |
| 8 | `https://copiq.fr/admin/` | **Le portail administrateur s'ouvre normalement** |
| 9 | `https://copiq.fr/robots.txt` | Contient `Sitemap: https://copiq.fr/sitemap.xml` |
| 10 | `https://copiq.fr/sitemap.xml` | Contient les URLs `/preparation/…` |
| 11 | Console du navigateur sur l'accueil | Aucune erreur |
| 12 | `https://copiq.fr/` sur téléphone | Aucun défilement horizontal |

Le point 8 est le plus important : `admin/` n'a pas été modifié, mais c'est la
zone dont une panne serait la plus gênante. Testez-la à chaque déploiement.

## 5. Revenir en arrière

Chaque publication laisse une sauvegarde complète :

```
fae16dc1-backup-<horodatage>/
```

Pour revenir à la version précédente, envoyez le contenu de cette sauvegarde
par FTP à la place. Aucune base de données n'est concernée : le site est
statique, seul Supabase détient les données, et il n'a pas été modifié.

Pour revenir seulement sur la nouvelle vitrine sans tout annuler, il suffit de
rétablir une ligne dans `copiq-web/src/app/page.tsx` :

```tsx
import { LandingPage } from "@/features/landing/landing-page"
// …
export default function HomePage() { return <LandingPage /> }
```

puis de recompiler. L'ancienne vitrine n'a pas été supprimée.

## 6. Ce que le déploiement FTP ne couvre pas

Le site est un export statique : il n'exécute aucun code serveur. Les
opérations sensibles passent par des **Supabase Edge Functions**, déployées
séparément avec la CLI Supabase et **non concernées par ce transfert FTP** :

- `cas_pratique_create_checkout` — création de la session Stripe ;
- `cas_pratique_customer_portal` — portail de facturation ;
- `cas_pratique_stripe_webhook` — attribution de Premium ;
- `cas_pratique_correct_attempt` — correction des cas pratiques ;
- les fonctions d'administration et d'export de données.

Si un paiement ne fonctionne pas après un déploiement FTP, le problème n'est
pas dans `fae16dc1/` : regardez les journaux de ces fonctions.

> Les routes `copiq-web/src/app/api/*` ne sont **pas** déployées (l'export
> statique les ignore). Elles sont conservées dans le dépôt mais ne sont
> appelées par aucune page.
