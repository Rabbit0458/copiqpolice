# Panel administrateur COP'IQ — `copiq.fr/admin`

Reconstruit le 26 juillet 2026. L'ancien dossier `admin/` avait disparu du projet ;
seul le **backend** (60+ fonctions RPC PostgreSQL) avait survécu. C'est ce backend
qui est réutilisé ici — aucune donnée n'a été perdue.

---

## Comment y accéder

1. Double-cliquer sur `PUBLIER_SITE.command` à la racine du projet.
2. Attendre le message confirmant que les routes critiques sont validées.
3. Glisser le dossier `fae16dc1/` chez l'hébergeur.
4. Ouvrir `https://copiq.fr/admin/`.

En local : `npm run dev` puis `http://localhost:3000/admin`

---

## Les trois barrières de sécurité

| # | Barrière | Où c'est vérifié |
|---|---|---|
| 1 | Mot de passe Supabase, compte présent dans `admin_users` | Supabase Auth + `current_admin()` |
| 2 | Code à 6 chiffres **Google Authenticator** (TOTP) | Supabase MFA → jeton `aal2` |
| 3 | Code staff personnel (PIN) | `verify_admin_panel_code_simple()` — hash bcrypt |

### Point crucial

Le site est un **export statique** : aucun code serveur ne tourne chez l'hébergeur.
La sécurité **ne peut donc pas** reposer sur le JavaScript. Elle repose entièrement
sur PostgreSQL :

- toutes les fonctions `cp_admin_*` sont `SECURITY DEFINER` et appellent
  `cp_admin_guard()` ;
- `cp_admin_guard()` vérifie `has_admin_permission('cas_pratiques')` **et**
  `admin_require_aal2()` ;
- `admin_require_aal2()` lit `auth.jwt() ->> 'aal'` : si l'administrateur a un
  facteur TOTP vérifié, un jeton `aal1` (mot de passe seul) est **refusé par la base**.

Autrement dit : quelqu'un qui modifierait le JavaScript dans son navigateur
n'obtiendrait **aucune donnée**. C'est le comportement attendu.

> **Enrôlement progressif** — tant qu'aucun facteur TOTP n'est enrôlé, `aal1` est
> accepté (sinon impossible de configurer la 2FA la première fois). Dès le premier
> enrôlement, la 2FA devient obligatoire et définitive.

---

## Première connexion (à faire une fois)

1. Aller sur `/admin/`
2. Se connecter avec `kaisouartani@gmail.com`
3. L'écran « Activer la double authentification » s'affiche → **Générer mon QR code**
4. Scanner le QR dans Google Authenticator
5. Saisir le code à 6 chiffres → 2FA activée
6. Saisir le code staff → accès au panel

À partir de là, chaque connexion demande : mot de passe → code Authenticator → code staff.

---

## Modules

| Page | Rôle |
|---|---|
| `/admin/` | Vue d'ensemble : compteurs, alertes contenu |
| `/admin/cas-pratiques/` | Liste, création, édition des cas. Publication/dépublication |
| `/admin/cas-pratiques/?slug=…` | Éditeur : Informations · Énoncé · Questions & grille |
| `/admin/appels/` | Contestations des élèves. **Valider = enrichir la grille** |
| `/admin/sante/` | Détection auto des cas inutilisables ou incomplets |
| `/admin/signalements/` | Fautes signalées, bugs, messages de contact |
| `/admin/utilisateurs/` | Comptes, abonnements, activité (lecture seule) |
| `/admin/journal/` | Journal d'audit immuable de toutes les actions admin |

---

## Comprendre la grille de correction

Une **question** vaut N points. Elle contient des **points de correction**
(les éléments attendus dans la copie). Chaque point porte un **poids**.

Un point contient des **groupes de mots-clés** :

```
Point « Cite l'article 78-2 CPP »  (poids 2)
  └─ Groupe 1 : ["78-2", "78 2", "article 78", "art 78"]   ← OU
```

```
Point « Réquisitions écrites du procureur »  (poids 2)
  ├─ Groupe 1 : ["requisition", "requisitions"]                    ← OU
  └─ Groupe 2 : ["ecrit", "ecrite", "signee", "procureur"]         ← OU
      ↑ ET entre les deux groupes : les deux doivent matcher
```

**Règle** : ET entre groupes, OU à l'intérieur d'un groupe.

Résultat du point :
- 100 % des groupes obligatoires matchent → `covered` (poids entier)
- ≥ 50 % → `partial` (moitié du poids)
- sinon → `missing` (0)

Le score de la question est ensuite **normalisé** sur son barème :
`score = (somme obtenue / somme des poids) × max_points`.

### Écriture des mots-clés

- Les accents et la casse sont **ignorés** : écris `requisition`, pas `réquisition`
- Un mot-clé contenant un espace est traité comme une **expression exacte**
- Les fautes de frappe sont tolérées (distance 1) au-delà de 8 caractères
- La négation est détectée : « ne peut pas contrôler » n'active pas le mot-clé
  `controler`

### Format JSON de l'éditeur

```json
{
  "case": "gav-droits-notification",
  "q": 1,
  "perfect": "**Réponse modèle en Markdown…**",
  "refs": ["art. 63-1 CPP"],
  "points": [
    {
      "label": "Droit à l'assistance d'un avocat",
      "weight": 2,
      "kind": "core",
      "expl": "Explication affichée à l'élève après correction.",
      "groups": [["avocat", "conseil", "batonnier"]]
    }
  ]
}
```

`kind` vaut `core` (essentiel) ou `bonus` (secondaire).
⚠️ Enregistrer **remplace intégralement** la grille de la question.

---

## Traiter un appel d'élève

Un élève conteste un point non validé. Dans `/admin/appels/` tu vois sa réponse
complète, le point contesté et son argument.

- **Rejeter** → l'élève reçoit ta réponse, la grille ne bouge pas.
- **Valider** → tu peux saisir des mots-clés à ajouter. Ils sont insérés dans la
  grille, marqués `auto_added`, et **le moteur les reconnaîtra pour toutes les
  corrections suivantes**. C'est le mécanisme d'amélioration continue du moteur.

Les mots-clés ajoutés ainsi apparaissent en vert dans l'éditeur de grille.

---

## Garde-fou à la publication

Publier un cas sans aucun point de correction est **refusé par la base**
(`cp_admin_set_case_status`). Les élèves obtiendraient sinon 0/0 —
c'est exactement le bug qui rendait le module inutilisable avant le 26 juillet 2026.

---

## Ajouter un module au panel

1. Écrire les RPC PostgreSQL (`SECURITY DEFINER` + garde de permission + audit)
2. Les exposer dans `src/lib/admin/api.ts`
3. Créer `src/app/admin/<module>/page.tsx`
4. Ajouter l'entrée dans `NAV` de `src/components/admin/admin-ui.tsx`
   (avec la clé de permission correspondante)

Ne jamais faire de `.from('table')` direct depuis le panel : toujours passer par
une RPC qui vérifie les droits.

---

## Reste à faire

Voir `ADMIN_PANEL_PROGRESSION.md` à la racine du projet : les modules
facturation, forum, notes de patch et gestion des admins ne sont pas encore
construits côté interface (le backend existe déjà en grande partie).
