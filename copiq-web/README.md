# COP'IQ — Plateforme Web

Plateforme web Next.js 15 de préparation aux concours de la Police Nationale (PA & GPX).

## Stack technique

- **Framework** : Next.js 15 (App Router, Server Components)
- **Langage** : TypeScript strict
- **Style** : Tailwind CSS + design tokens COP'IQ
- **Auth & BDD** : Supabase (partagé avec l'app mobile)
- **Paiement** : Stripe (abonnements semaine / mois / an)
- **Animations** : Framer Motion + Lenis smooth scroll
- **Icons** : Lucide React

## Démarrage local

```bash
# 1. Copier les variables d'environnement
cp .env.local.example .env.local
# Remplir les valeurs dans .env.local

# 2. Installer les dépendances
npm install

# 3. Démarrer le serveur de développement
npm run dev
# → http://localhost:3000
```

## Variables d'environnement requises

```env
NEXT_PUBLIC_SUPABASE_URL=https://xxxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJ...
SUPABASE_SERVICE_ROLE_KEY=eyJ...

STRIPE_SECRET_KEY=sk_live_...
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_live_...
STRIPE_WEBHOOK_SECRET=whsec_...
STRIPE_PRICE_WEEK=price_xxx
STRIPE_PRICE_MONTH=price_xxx
STRIPE_PRICE_YEAR=price_xxx

NEXT_PUBLIC_SITE_URL=https://copiqpolice.app
NEXT_PUBLIC_GOOGLE_ADS_CLIENT_ID=ca-pub-xxxxxxxx
```

## Migration Supabase (Forum)

```bash
# Appliquer la migration forum
npx supabase db push
# ou via le dashboard Supabase > SQL Editor > coller le contenu de :
# supabase/migrations/20260601_forum.sql
```

## Déploiement Vercel

1. Pousser le code sur GitHub
2. Créer un projet Vercel lié au repo
3. Ajouter toutes les variables d'env dans Vercel Dashboard
4. Configurer le webhook Stripe : `https://votre-domaine.vercel.app/api/stripe/webhook`
5. Deploy !

## Structure du projet

```
src/
├── app/
│   ├── (auth)/          # Login, Signup, Forgot password
│   ├── (dashboard)/     # Pages protégées (authentification requise)
│   │   ├── dashboard/   # Accueil dashboard
│   │   ├── pa/          # Policier Adjoint (scolarité, cours, quiz)
│   │   ├── gpx/         # Gardien de la Paix (scolarité, cours, quiz, cas pratiques)
│   │   ├── forum/       # Forum communautaire
│   │   ├── culture-generale/
│   │   ├── psychotechniques/
│   │   ├── langues/
│   │   ├── concours-blanc/
│   │   ├── profil/
│   │   ├── parametres/
│   │   ├── progression/
│   │   ├── historique/
│   │   ├── favoris/
│   │   ├── notifications/
│   │   └── abonnement/
│   ├── (public)/        # Pages publiques (landing, blog, tarifs, CGU...)
│   └── api/             # Routes API (Stripe, user)
├── components/
│   ├── layout/          # Sidebar, Header, ThemeToggle
│   └── ui/              # Button, Card, Badge, Progress, Skeleton
├── data/                # Données statiques (modules, blog)
├── features/            # Composants métier par feature
├── lib/                 # Supabase, Stripe, utils
└── types/               # Types TypeScript
```

## Pages

### Publiques (indexables)
- `/` — Landing page avec hero, features, pricing, CTA
- `/tarifs` — Page tarification détaillée
- `/blog` — Blog SEO (4 articles)
- `/blog/[slug]` — Article de blog
- `/contact` — Formulaire de contact
- `/beta` — À propos / version bêta
- `/cgu` — Conditions Générales d'Utilisation
- `/privacy` — Politique de confidentialité

### Auth (non indexées)
- `/login` — Connexion
- `/signup` — Inscription
- `/forgot-password` — Mot de passe oublié
- `/reset-password` — Réinitialisation (via email)

### Dashboard (authentification requise, non indexées)
- `/dashboard` — Vue d'ensemble, statistiques, accès rapides
- `/pa/scolarite` — Modules de cours PA
- `/pa/cours/[moduleId]` — Lecteur de cours (protégé, watermark)
- `/pa/quiz` — Sélection quiz PA
- `/pa/quiz/[moduleId]` — Moteur de quiz
- `/gpx/scolarite` — Modules de cours GPX
- `/gpx/cours/[moduleId]` — Lecteur de cours GPX
- `/gpx/quiz` — Sélection quiz GPX
- `/gpx/quiz/[moduleId]` — Quiz GPX
- `/gpx/cas-pratiques` — Interface rédaction + correction IA
- `/culture-generale` — 14 thèmes de culture générale
- `/psychotechniques` — 6 types d'exercices interactifs
- `/psychotechniques/[type]` — Exercices avec timer
- `/langues` — Anglais, Espagnol, Allemand
- `/concours-blanc` — Simulation complète (Premium)
- `/forum` — Liste des sujets
- `/forum/[postId]` — Sujet + réponses
- `/forum/nouveau` — Créer un sujet
- `/abonnement` — Gestion abonnement Stripe
- `/profil` — Profil utilisateur, XP, badges
- `/parametres` — Paramètres compte, mot de passe
- `/progression` — Progression par module
- `/historique` — Historique des tentatives
- `/favoris` — Contenus mis en favoris
- `/notifications` — Centre de notifications

## Protection du contenu

Les cours premium utilisent :
- `user-select: none` (CSS) — interdit la sélection de texte
- Désactivation du clic droit via JavaScript
- Désactivation Ctrl+C, Ctrl+A, Ctrl+S
- Watermark CSS `::after` avec l'email de l'utilisateur
- `@media print` avec watermark plein écran

## Freemium

- **Gratuit** : 10 cas pratiques/semaine glissante via `free_weekly_usage` + `consume_free_request()`
- **Premium** : accès illimité, sans publicité, concours blanc, langues, modules avancés
- Plans : semaine (€4.99), mois (€8.99), an (€86.99)
- Progression et compte synchronisés entre web et mobile

## Supabase Shared

Le projet web utilise **le même projet Supabase** que l'application mobile. Les tables, RLS, Edge Functions et RPCs sont identiques. La progression est synchronisée en temps réel.
