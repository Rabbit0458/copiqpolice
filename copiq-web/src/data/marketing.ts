/**
 * Données de la vitrine COP'IQ.
 *
 * RÈGLE DE CE FICHIER : chaque affirmation chiffrée porte sa source.
 * Aucune preuve sociale inventée (§53) : pas de nombre d'utilisateurs, pas de
 * nombre de téléchargements, pas de taux de réussite, pas de classement.
 * Si une donnée n'est pas vérifiable dans le dépôt, elle n'apparaît pas.
 */

import { PATHWAYS, type PathwayId } from "@/config/pathways"

/* ─────────────────────────────────────────────────────────────────────────────
   Assets officiels fournis (bucket public Supabase `assets`).
   Servis directement : le bucket est public, la CSP et next.config.ts
   l'autorisent déjà, et `output: "export"` interdit toute optimisation
   serveur. Aucune copie locale, aucun original modifié.
   ───────────────────────────────────────────────────────────────────────── */

const BUCKET =
  "https://nuoonagnkhbeeymtvrcn.supabase.co/storage/v1/object/public/assets"

export const ASSETS = {
  /** Policier de dos, brassard POLICE, véhicule sérigraphié. 1280×853. */
  terrain: {
    src: `${BUCKET}/website_assets/pv_intro.jpg`,
    width: 1280,
    height: 853,
    alt: "Policier de dos portant un brassard POLICE devant un véhicule sérigraphié",
  },
  /** Moto de police sous la pluie, gyrophares. 1500×1100, bandes mortes à droite/en bas. */
  intervention: {
    src: `${BUCKET}/website_assets/pv_circulation_routiere.jpeg`,
    width: 1500,
    height: 1100,
    alt: "Motocycliste de la police nationale en intervention sous la pluie",
  },
  /** Écusson Police nationale / Sécurité publique, faible profondeur de champ. 1000×625. */
  gpx: {
    src: `${BUCKET}/website_assets/gpx.jpg`,
    width: 1000,
    height: 625,
    alt: "Écusson Police nationale — Sécurité publique sur un uniforme",
  },
  /** Brassards POLICE. 657×431 — basse résolution, ne pas agrandir. */
  pa: {
    src: `${BUCKET}/website_assets/police.webp`,
    width: 657,
    height: 431,
    alt: "Policiers de dos portant un brassard POLICE",
  },
} as const

/**
 * Photolangage — contenu PÉDAGOGIQUE (§72).
 * Ces images viennent de `photolangage_pa/` et portent le filigrane officiel
 * « POLICE NATIONALE ». Elles ne servent JAMAIS de visuel institutionnel ni de
 * décor : uniquement à illustrer l'épreuve de photolangage, légende à l'appui.
 */
export const PHOTOLANGAGE = [
  {
    src: `${BUCKET}/photolangage_pa/cas4.jpg`,
    width: 2048,
    height: 1448,
    alt: "Support de photolangage : contrôle routier effectué par des motocyclistes de la police nationale",
  },
  {
    src: `${BUCKET}/photolangage_pa/cas8.jpg`,
    width: 1254,
    height: 836,
    alt: "Support de photolangage : scène de voie publique",
  },
  {
    src: `${BUCKET}/photolangage_pa/cas2.jpg`,
    width: 885,
    height: 500,
    alt: "Support de photolangage : situation à analyser",
  },
  {
    src: `${BUCKET}/photolangage_pa/cas7.jpg`,
    width: 739,
    height: 415,
    alt: "Support de photolangage : situation à analyser",
  },
] as const

/* ─────────────────────────────────────────────────────────────────────────────
   Faits produit — chacun vérifiable dans le dépôt
   ───────────────────────────────────────────────────────────────────────── */

export interface ProductFact {
  value: string
  label: string
  /** Comment ce chiffre a été obtenu. Sert aussi de garde-fou éditorial. */
  source: string
}

export const PRODUCT_FACTS: readonly ProductFact[] = [
  {
    value: "60 000+",
    label: "questions d'entraînement",
    source:
      'grep -rho --include="*.dart" -F "QuizQuestion(" lib | wc -l → 53 838 ; ' +
      '"PaQuizQuestion(" → 13 509. Plancher retenu après déduction des ' +
      "déclarations de constructeur (≈1 par fichier de quiz).",
  },
  {
    value: "1 400+",
    label: "fiches de cours et de quiz",
    source:
      "lib/content : gpx_scolarite 760 + pa_scolarite 650 + gpx_exam 39 + pa_exam 35 = 1 484 fichiers.",
  },
  {
    value: "4",
    label: "parcours complets",
    source: "src/config/pathways.ts — pa_exam, gpx_exam, pa_school, gpx_school.",
  },
  {
    value: "1",
    label: "compte, mobile et web",
    source:
      "Même projet Supabase : copiq-web/scripts/publish-static.mjs reprend " +
      "kSupabaseUrl / kSupabaseAnonKey depuis lib/main.dart.",
  },
] as const

/* ─────────────────────────────────────────────────────────────────────────────
   Parcours — libellés reprises telles quelles de l'application (§38)
   ───────────────────────────────────────────────────────────────────────── */

export interface PathwayCard {
  id: PathwayId
  /** Titre exact de l'app. */
  title: string
  shortLabel: string
  description: string
  color: string
  /** Modules réels, relevés dans lib/content/. */
  modules: readonly string[]
  /** Source du décompte de modules. */
  contentSource: string
  image?: keyof typeof ASSETS
}

export const PATHWAY_CARDS: readonly PathwayCard[] = [
  {
    id: "gpx_exam",
    title: PATHWAYS.gpx_exam.title,
    shortLabel: PATHWAYS.gpx_exam.shortLabel,
    description: PATHWAYS.gpx_exam.description,
    color: PATHWAYS.gpx_exam.color,
    modules: ["Cas pratique", "Culture générale", "Langue étrangère", "Psychotechniques", "Concours blanc"],
    contentSource: "lib/content/gpx_exam/",
    image: "gpx",
  },
  {
    id: "pa_exam",
    title: PATHWAYS.pa_exam.title,
    shortLabel: PATHWAYS.pa_exam.shortLabel,
    description: PATHWAYS.pa_exam.description,
    color: PATHWAYS.pa_exam.color,
    modules: ["Culture générale", "Psychotechniques", "Photolangage", "Concours blanc"],
    contentSource: "lib/content/pa_exam/",
    image: "pa",
  },
  {
    id: "gpx_school",
    title: PATHWAYS.gpx_school.title,
    shortLabel: PATHWAYS.gpx_school.shortLabel,
    description: PATHWAYS.gpx_school.description,
    color: PATHWAYS.gpx_school.color,
    modules: [
      "Institutions et valeurs",
      "DPS / DPG",
      "Policier en intervention — initial",
      "Policier en intervention — avancé",
      "Mémento circulation",
      "PV APJ 20",
    ],
    contentSource: "lib/content/gpx_scolarite/ — 760 fichiers",
  },
  {
    id: "pa_school",
    title: PATHWAYS.pa_school.title,
    shortLabel: PATHWAYS.pa_school.shortLabel,
    description: PATHWAYS.pa_school.description,
    color: PATHWAYS.pa_school.color,
    modules: [
      "Procédure pénale",
      "Cadres juridiques",
      "Atteintes aux personnes",
      "Atteintes aux biens",
      "Armes et munitions",
      "Circulation",
      "Mineurs et famille",
      "Stupéfiants",
      "Libertés publiques",
      "Organisation judiciaire",
    ],
    contentSource: "lib/content/pa_scolarite/ — 650 fichiers",
  },
] as const

/* ─────────────────────────────────────────────────────────────────────────────
   Capacités — vocabulaire de l'app, pas d'invention
   ───────────────────────────────────────────────────────────────────────── */

export interface Capability {
  key: string
  title: string
  body: string
  premium?: boolean
  /** Où la fonctionnalité existe réellement. */
  source: string
}

export const CAPABILITIES: readonly Capability[] = [
  {
    key: "quiz",
    title: "Quiz et QCM par module",
    body:
      "Des séries classées par module et par niveau, avec correction immédiate et reprise de l'historique de réponses.",
    source: "lib/content/*/quiz_* · src/features/quiz/",
  },
  {
    key: "cours",
    title: "Cours et fiches",
    body:
      "Le programme de scolarité rédigé module par module : procédure pénale, cadres juridiques, intervention, circulation, armes, mineurs.",
    source: "lib/content/gpx_scolarite/ · lib/content/pa_scolarite/",
  },
  {
    key: "cas-pratiques",
    title: "Cas pratiques corrigés",
    body:
      "Vous rédigez, le moteur de correction analyse la réponse (normalisation, lemmatisation, appariement) et détaille ce qui manque.",
    premium: true,
    source: "lib/core/cas_pratique/engine/ · supabase/functions/cas_pratique_correct_attempt",
  },
  {
    key: "psycho",
    title: "Psychotechniques",
    body: "Calcul, suites logiques, raisonnement : les familles d'épreuves des sélections, chronométrées.",
    source: "lib/content/pa_exam/psycotechniques/ · src/app/(dashboard)/psychotechniques/",
  },
  {
    key: "photolangage",
    title: "Photolangage",
    body:
      "L'épreuve d'analyse d'image du concours de Policier adjoint, à partir de supports réels à décrire et à interpréter.",
    source: "lib/content/pa_exam/photolangage/",
  },
  {
    key: "langues",
    title: "Langues",
    body: "L'épreuve de langue étrangère du concours de Gardien de la paix.",
    source: "lib/content/gpx_exam/langue_etrangere/ · src/app/(dashboard)/langues/",
  },
  {
    key: "concours-blanc",
    title: "Concours blanc",
    body: "Une épreuve complète en conditions réelles, chronométrée, corrigée question par question.",
    premium: true,
    source: "src/app/(dashboard)/concours-blanc/ · src/features/concours-blanc/",
  },
  {
    key: "progression",
    title: "Progression et statistiques",
    body:
      "Taux de réussite par module, historique complet, favoris, XP. Les mêmes données que sur mobile, sur le même compte.",
    source: "src/app/(dashboard)/{progression,historique,favoris}/ · cas_pratique_xp_ledger",
  },
  {
    key: "communaute",
    title: "Forum par parcours",
    body: "Un espace de discussion propre à chaque parcours, modéré.",
    source: "src/app/(dashboard)/forum/ · copiq-web/supabase/migrations/20260601_forum.sql",
  },
  {
    key: "outils",
    title: "Mémos et notes",
    body: "Vos fiches de révision et vos notes personnelles, synchronisées.",
    source: "src/app/(dashboard)/{memos,notes}/ · tables user_memos, user_notes",
  },
] as const

/* ─────────────────────────────────────────────────────────────────────────────
   Tarifs — source de vérité : Stripe, via cas_pratique_create_checkout
   ───────────────────────────────────────────────────────────────────────── */

export interface PricingPlan {
  id: "free" | "week" | "month" | "year"
  name: string
  price: string
  period: string
  pitch: string
  features: readonly string[]
  cta: string
  highlighted?: boolean
  note?: string
}

/**
 * Ces montants ne sont PAS décidés ici : ils reflètent les prix Stripe déjà en
 * production (`src/app/(dashboard)/abonnement/page.tsx`, et le repli
 * `unit_amount === 8699` de `cas_pratique_create_checkout`). Ils sont
 * identiques aux conditions publiées dans `lib/legal/legal_content.dart`.
 * Ne jamais les modifier sans décision du propriétaire.
 */
export const PRICING: readonly PricingPlan[] = [
  {
    id: "free",
    name: "Gratuit",
    price: "0 €",
    period: "",
    pitch: "Pour découvrir la plateforme et commencer à réviser.",
    features: [
      "Quiz et QCM d'entraînement",
      "10 cas pratiques par semaine",
      "Forum du parcours",
      "Progression et historique",
      "Compte synchronisé mobile et web",
    ],
    cta: "Créer mon compte",
    note: "Publicités affichées dans l'application mobile.",
  },
  {
    id: "week",
    name: "Hebdomadaire",
    price: "4,99 €",
    period: "/ semaine",
    pitch: "Pour les dernières semaines avant l'épreuve.",
    features: [
      "Accès Premium complet",
      "Sans engagement",
      "Idéal en fin de préparation",
    ],
    cta: "Choisir l'hebdomadaire",
  },
  {
    id: "month",
    name: "Mensuel",
    price: "8,99 €",
    period: "/ mois",
    pitch: "La formule de préparation continue.",
    features: [
      "Tous les modules des 4 parcours",
      "Cas pratiques illimités et corrigés",
      "Concours blancs complets",
      "Psychotechniques, langues, culture générale",
      "Statistiques détaillées",
      "Sans publicité",
    ],
    cta: "Commencer l'essai de 7 jours",
    highlighted: true,
    note: "7 jours d'essai, puis 8,99 €/mois. Résiliable à tout moment.",
  },
  {
    id: "year",
    name: "Annuel",
    price: "86,99 €",
    period: "/ an",
    pitch: "Le coût le plus bas sur une année de préparation.",
    features: [
      "Tout le mensuel, sur douze mois",
      "Soit 7,25 € par mois",
      "Couvre la préparation et l'entrée en école",
    ],
    cta: "Commencer l'essai de 7 jours",
    note: "7 jours d'essai, puis 86,99 €/an. Résiliable à tout moment.",
  },
] as const

/* ─────────────────────────────────────────────────────────────────────────────
   Lancement — §43 : basculer « Bêta » → « Disponible » sans refaire le site
   ───────────────────────────────────────────────────────────────────────── */

export interface StoreLinks {
  /** "beta" affiche l'invitation à la bêta ; "live" affiche les badges boutiques. */
  status: "beta" | "live"
  /** Renseigner le jour de la publication, puis passer `status` à "live". */
  appStore: string | null
  googlePlay: string | null
}

/**
 * Un seul objet à modifier le jour de la sortie : mettre les deux URLs puis
 * `status: "live"`. Toute la vitrine s'adapte, aucun composant à réécrire.
 * Tant qu'une URL est absente, aucun badge de boutique n'est affiché (§43).
 */
export const LAUNCH: StoreLinks = {
  status: "beta",
  appStore: null,
  googlePlay: null,
}

/* ─────────────────────────────────────────────────────────────────────────────
   Témoignages — §44
   ───────────────────────────────────────────────────────────────────────── */

export interface Testimonial {
  quote: string
  /** Prénom ou pseudonyme réellement communiqué. */
  author: string
  /** Contexte réel, ex. « GPX — concours 2026 ». */
  context: string
}

/**
 * VOLONTAIREMENT VIDE.
 *
 * Aucun témoignage utilisateur n'existe dans le dépôt. En inventer un prénom,
 * une note ou une citation est explicitement interdit (§44). La section est
 * construite et n'attend que ce tableau : dès qu'un retour réel est fourni,
 * il suffit de l'ajouter ici et la section apparaît. Tant qu'il est vide, la
 * vitrine n'affiche rien à cet endroit.
 */
export const TESTIMONIALS: readonly Testimonial[] = []

/* ─────────────────────────────────────────────────────────────────────────────
   Mention d'indépendance — §45
   ───────────────────────────────────────────────────────────────────────── */

export const INDEPENDENCE_NOTICE =
  "COP'IQ est une plateforme de préparation indépendante. Elle n'est ni éditée, " +
  "ni agréée, ni affiliée par la Police nationale ou le ministère de l'Intérieur."

export const INDEPENDENCE_NOTICE_SHORT =
  "Plateforme indépendante — non affiliée à la Police nationale."
