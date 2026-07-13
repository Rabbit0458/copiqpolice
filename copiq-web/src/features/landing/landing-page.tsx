"use client"

import Link from "next/link"
import Image from "next/image"
import { motion, AnimatePresence } from "framer-motion"
import { useState, useEffect } from "react"
import { Button } from "@/components/ui/button"
import { Badge } from "@/components/ui/badge"
import {
  Crown, Target, BookOpen, Brain, FileText,
  Globe, Zap, Check, ArrowRight, Star, Shield, RotateCcw
} from "lucide-react"
import { cn } from "@/lib/utils"

/* ─── Assets ──────────────────────────────────────────────── */
const LOGO = "https://nuoonagnkhbeeymtvrcn.supabase.co/storage/v1/object/public/assets/logo_appstore.png"

const HERO_IMAGES = [
  "https://nuoonagnkhbeeymtvrcn.supabase.co/storage/v1/object/public/assets/website_assets/pv_intro.jpg",
  "https://nuoonagnkhbeeymtvrcn.supabase.co/storage/v1/object/public/assets/website_assets/gpx.jpg",
  "https://nuoonagnkhbeeymtvrcn.supabase.co/storage/v1/object/public/assets/website_assets/police.webp",
  "https://nuoonagnkhbeeymtvrcn.supabase.co/storage/v1/object/public/assets/website_assets/pv_circulation_routiere.jpeg",
  "https://nuoonagnkhbeeymtvrcn.supabase.co/storage/v1/object/public/assets/policier_intervention.jpg",
]

/* ─── Features (flip cards) ────────────────────────────────── */
const FEATURES = [
  {
    icon: <BookOpen size={28} />,
    title: "Cours Juridiques",
    shortDesc: "Programme complet PA & GPX",
    backContent: "Procédure pénale, droit pénal, cadres d'enquête, armes, mineurs, voie publique… Tout le programme scolarité PA et GPX rédigé par des professionnels.",
    color: "#1147D9",
    bg: "from-blue-600 to-blue-800",
  },
  {
    icon: <Target size={28} />,
    title: "Quiz par Thème",
    shortDesc: "5 000+ questions classées",
    backContent: "Révisez par module, filtrez par difficulté, suivez votre taux de réussite. Historique complet et statistiques détaillées.",
    color: "#22C55E",
    bg: "from-green-600 to-green-800",
  },
  {
    icon: <FileText size={28} />,
    title: "Cas Pratiques IA",
    shortDesc: "Correction instantanée par IA",
    backContent: "Rédigez vos cas pratiques et obtenez une correction détaillée en secondes. L'IA identifie vos erreurs et vous guide vers la bonne méthode.",
    color: "#EF4444",
    bg: "from-red-600 to-red-800",
    isPremium: true,
  },
  {
    icon: <Brain size={28} />,
    title: "Psychotechniques",
    shortDesc: "Calcul, logique, raisonnement",
    backContent: "Calcul mental chronométré, suites logiques, syllogismes, concentration. Tous les types d'épreuves psy des concours police.",
    color: "#A855F7",
    bg: "from-purple-600 to-purple-800",
  },
  {
    icon: <Globe size={28} />,
    title: "Culture Générale",
    shortDesc: "14 thèmes couverts",
    backContent: "Histoire, géographie, actualité, droit, police nationale, sport, cinéma, science et plus encore. Quiz adaptatifs par niveau.",
    color: "#F59E0B",
    bg: "from-amber-500 to-amber-700",
  },
  {
    icon: <Zap size={28} />,
    title: "Concours Blancs",
    shortDesc: "Conditions réelles d'examen",
    backContent: "Passez un concours complet en 30 minutes avec timer, 10 questions officielles, correction détaillée et explication de chaque réponse.",
    color: "#06B6D4",
    bg: "from-cyan-600 to-cyan-800",
    isPremium: true,
  },
]

/* ─── Témoignages ──────────────────────────────────────────── */
const TESTIMONIALS = [
  {
    name: "Mathieu D.",
    role: "Reçu GPX — Promo 2025",
    text: "Reçu au concours Gardien de la Paix après 3 mois sur COP'IQ. Les cas pratiques corrigés par IA m'ont fait gagner 3 points.",
    score: "16/20",
    avatar: "https://api.dicebear.com/7.x/avataaars/svg?seed=Mathieu&backgroundColor=b6e3f4",
  },
  {
    name: "Sarah L.",
    role: "Reçue PA — Promo 2024",
    text: "L'appli mobile + le site web : je révise partout. Ma progression est synchronisée automatiquement entre les deux.",
    score: "14/20",
    avatar: "https://api.dicebear.com/7.x/avataaars/svg?seed=Sarah&backgroundColor=ffdfbf",
  },
  {
    name: "Kevin R.",
    role: "Reçu GPX — Promo 2025",
    text: "Les cours sont clairs et complets. Bien mieux que les livres classiques pour la scolarité. J'ai révisé uniquement avec COP'IQ.",
    score: "18/20",
    avatar: "https://api.dicebear.com/7.x/avataaars/svg?seed=Kevin&backgroundColor=d1d4f9",
  },
]

/* ─── Plans tarifaires ─────────────────────────────────────── */
const PLANS = [
  {
    id: "free",
    name: "Gratuit",
    emoji: "🎓",
    price: "0 €",
    period: "",
    description: "Pour démarrer",
    features: [
      "Quiz de base (50 questions)",
      "10 cas pratiques / semaine",
      "Cours d'introduction",
      "Forum communautaire",
    ],
    cta: "Commencer gratuitement",
    href: "/signup",
    style: "border-[var(--outline)] bg-[var(--surface)]",
    btnVariant: "secondary" as const,
    badge: null,
    badgeStyle: "",
  },
  {
    id: "month",
    name: "Mensuel",
    emoji: "🚀",
    price: "8,99 €",
    period: "/ mois",
    description: "1 semaine offerte",
    features: [
      "Tout ce qui est gratuit",
      "Cours premium illimités",
      "Cas pratiques illimités",
      "Concours blancs complets",
      "Statistiques avancées",
      "Sans publicité",
    ],
    cta: "Commencer — 1 semaine offerte",
    href: "/signup",
    style: "border-2 border-violet-500 bg-gradient-to-b from-violet-50 to-violet-100 dark:from-violet-950/30 dark:to-violet-900/20",
    btnVariant: "default" as const,
    badge: "⭐ BEST SELLER",
    badgeStyle: "bg-violet-600 text-white",
    highlighted: true,
  },
  {
    id: "year",
    name: "Annuel",
    emoji: "👑",
    price: "71,99 €",
    period: "/ an",
    description: "Économisez 33 % — 5,99 €/mois",
    features: [
      "Tout l'abonnement mensuel",
      "2 mois offerts vs mensuel",
      "Priorité support 24/7",
      "Accès anticipé nouveautés",
    ],
    cta: "Meilleur investissement",
    href: "/signup",
    style: "border-2 border-amber-400 bg-gradient-to-b from-amber-50 to-amber-100 dark:from-amber-950/30 dark:to-amber-900/20",
    btnVariant: "default" as const,
    badge: "👑 MEILLEURE VALEUR",
    badgeStyle: "bg-amber-500 text-white",
  },
]

/* ─── Flip Card ────────────────────────────────────────────── */
function FlipCard({ feat }: { feat: typeof FEATURES[0] }) {
  const [flipped, setFlipped] = useState(false)
  return (
    <div
      className="relative h-56 cursor-pointer"
      style={{ perspective: "1000px" }}
      onClick={() => setFlipped(f => !f)}
    >
      <motion.div
        animate={{ rotateY: flipped ? 180 : 0 }}
        transition={{ duration: 0.55, ease: [0.4, 0, 0.2, 1] }}
        style={{ transformStyle: "preserve-3d" }}
        className="w-full h-full"
      >
        {/* Front */}
        <div
          className="absolute inset-0 rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-6 flex flex-col"
          style={{ backfaceVisibility: "hidden" }}
        >
          <div
            className="w-12 h-12 rounded-2xl flex items-center justify-center text-white mb-4 shadow-md"
            style={{ backgroundColor: feat.color }}
          >
            {feat.icon}
          </div>
          <div className="flex items-center gap-2 mb-2">
            <h3 className="font-bold text-[var(--on-surface)]">{feat.title}</h3>
            {feat.isPremium && (
              <span className="text-[10px] font-semibold px-1.5 py-0.5 rounded-full bg-amber-100 text-amber-700 dark:bg-amber-900/40 dark:text-amber-400">
                Premium
              </span>
            )}
          </div>
          <p className="text-sm text-[var(--on-surface-muted)]">{feat.shortDesc}</p>
          <div className="mt-auto flex items-center gap-1 text-xs text-[var(--on-surface-faint)]">
            <RotateCcw size={10} />Cliquer pour en savoir plus
          </div>
        </div>

        {/* Back */}
        <div
          className={cn(
            "absolute inset-0 rounded-2xl p-6 flex flex-col justify-center bg-gradient-to-br text-white",
            feat.bg
          )}
          style={{ backfaceVisibility: "hidden", transform: "rotateY(180deg)" }}
        >
          {feat.isPremium && (
            <div className="text-[10px] font-bold bg-white/20 rounded-full px-2 py-0.5 w-fit mb-3">⭐ PREMIUM</div>
          )}
          <h3 className="font-bold text-lg mb-3">{feat.title}</h3>
          <p className="text-sm text-white/90 leading-relaxed">{feat.backContent}</p>
          <div className="mt-4 text-xs text-white/60 flex items-center gap-1">
            <RotateCcw size={10} />Cliquer pour retourner
          </div>
        </div>
      </motion.div>
    </div>
  )
}

/* ─── Hero Slideshow ───────────────────────────────────────── */
function HeroSlideshow() {
  const [current, setCurrent] = useState(0)

  useEffect(() => {
    const t = setInterval(() => {
      setCurrent(c => (c + 1) % HERO_IMAGES.length)
    }, 4500)
    return () => clearInterval(t)
  }, [])

  return (
    <div className="absolute inset-0 overflow-hidden">
      <AnimatePresence mode="sync">
        <motion.div
          key={current}
          initial={{ opacity: 0, scale: 1.05 }}
          animate={{ opacity: 1, scale: 1 }}
          exit={{ opacity: 0 }}
          transition={{ duration: 1.2, ease: "easeInOut" }}
          className="absolute inset-0"
        >
          {/* eslint-disable-next-line @next/next/no-img-element */}
          <img
            src={HERO_IMAGES[current]}
            alt=""
            className="w-full h-full object-cover"
          />
        </motion.div>
      </AnimatePresence>
      {/* Gradient overlay */}
      <div className="absolute inset-0 bg-gradient-to-b from-[#000B36]/80 via-[#000B36]/60 to-[#000B36]/90 backdrop-blur-[2px]" />
    </div>
  )
}

/* ─── Main Component ───────────────────────────────────────── */
export function LandingPage() {
  return (
    <div className="min-h-screen bg-[var(--surface)] text-[var(--on-surface)]">

      {/* ── Header ── */}
      <header className="sticky top-0 z-50 border-b border-white/10 bg-[#000B36]/90 backdrop-blur-xl">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 h-16 flex items-center justify-between">
          <Link href="/" className="flex items-center gap-3">
            <Image src={LOGO} alt="COP'IQ" width={40} height={40} className="rounded-xl shadow-md" unoptimized />
            <span className="font-bold text-lg tracking-tight text-white">COP&apos;IQ</span>
          </Link>

          <nav className="hidden md:flex items-center gap-6 text-sm text-white/70">
            {[["Fonctionnalités", "#features"], ["Tarifs", "#pricing"], ["Blog", "/blog"], ["Forum", "/forum"]].map(([label, href]) => (
              <Link key={label} href={href} className="hover:text-white transition-colors">
                {label}
              </Link>
            ))}
          </nav>

          <div className="flex items-center gap-3">
            <Link href="/login" className="text-sm text-white/70 hover:text-white transition-colors hidden sm:block">
              Se connecter
            </Link>
            <Link href="/signup">
              <button className="px-4 py-2 rounded-xl bg-[#1147D9] hover:bg-[#1A55E6] text-white text-sm font-semibold transition-all shadow-lg flex items-center gap-2">
                Commencer gratuitement <ArrowRight size={14} />
              </button>
            </Link>
          </div>
        </div>
      </header>

      {/* ── Hero ── */}
      <section className="relative overflow-hidden min-h-[92vh] flex items-center">
        <HeroSlideshow />

        <div className="relative z-10 max-w-5xl mx-auto px-4 sm:px-6 text-center w-full py-24">
          {/* Logo centré */}
          <motion.div
            initial={{ opacity: 0, y: -10 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.5 }}
            className="flex justify-center mb-8"
          >
            <Image src={LOGO} alt="COP'IQ" width={96} height={96} className="rounded-3xl shadow-2xl" unoptimized />
          </motion.div>

          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6, delay: 0.1 }}
          >
            <div className="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-white/10 border border-white/20 text-white/90 text-sm mb-6 backdrop-blur-sm">
              <Crown size={13} className="text-amber-400" />
              Application mobile + Site web synchronisés
            </div>

            <h1 className="text-4xl sm:text-5xl lg:text-7xl font-black leading-tight mb-6 text-white">
              Réussissez votre concours{" "}
              <span className="text-transparent bg-clip-text bg-gradient-to-r from-[#4B8FFF] to-[#7FB3FF]">
                Police Nationale
              </span>
            </h1>

            <p className="text-lg sm:text-xl text-white/75 max-w-2xl mx-auto mb-10 leading-relaxed">
              Cours juridiques, quiz thématiques, cas pratiques corrigés par IA, psychotechniques et concours blancs.
              La plateforme complète pour Policier Adjoint et Gardien de la Paix.
            </p>

            <div className="flex flex-col sm:flex-row gap-4 justify-center mb-14">
              <Link href="/signup">
                <button className="px-8 py-4 rounded-2xl bg-[#1147D9] hover:bg-[#1A55E6] text-white font-bold text-base transition-all shadow-xl hover:shadow-2xl hover:-translate-y-0.5 flex items-center justify-center gap-2.5 w-full sm:w-auto">
                  Commencer gratuitement <ArrowRight size={18} />
                </button>
              </Link>
              <Link href="#features">
                <button className="px-8 py-4 rounded-2xl bg-white/10 hover:bg-white/20 border border-white/25 text-white font-semibold text-base transition-all backdrop-blur-sm w-full sm:w-auto">
                  Voir les fonctionnalités
                </button>
              </Link>
            </div>

            {/* Social proof */}
            <div className="flex flex-wrap items-center justify-center gap-6 text-sm text-white/70">
              <div className="flex items-center gap-1.5">
                <div className="flex">{[...Array(5)].map((_, i) => <Star key={i} size={13} className="text-amber-400 fill-amber-400" />)}</div>
                <span className="font-semibold text-white">4.9/5</span> App Store
              </div>
              <div className="w-px h-4 bg-white/20" />
              <span><strong className="text-white">10 000+</strong> candidats préparés</span>
              <div className="w-px h-4 bg-white/20" />
              <span><strong className="text-white">5 000+</strong> questions</span>
            </div>
          </motion.div>
        </div>

        {/* Slideshow dots */}
        <div className="absolute bottom-8 left-1/2 -translate-x-1/2 flex gap-2 z-10">
          {HERO_IMAGES.map((_, i) => (
            <div key={i} className={cn("h-1.5 rounded-full transition-all duration-300", i === 0 ? "w-6 bg-white" : "w-1.5 bg-white/40")} />
          ))}
        </div>
      </section>

      {/* ── Stats band ── */}
      <div className="bg-[#000B36] py-8 border-y border-white/10">
        <div className="max-w-5xl mx-auto px-4 grid grid-cols-2 sm:grid-cols-4 gap-6 text-center">
          {[
            { v: "10 000+", l: "Candidats préparés" },
            { v: "5 000+", l: "Questions au total" },
            { v: "95%", l: "Taux de satisfaction" },
            { v: "4.9/5", l: "Note App Store" },
          ].map(s => (
            <div key={s.l}>
              <div className="text-2xl font-black text-white">{s.v}</div>
              <div className="text-sm text-white/50 mt-0.5">{s.l}</div>
            </div>
          ))}
        </div>
      </div>

      {/* ── Features flip cards ── */}
      <section id="features" className="py-24 bg-[var(--surface-container)]">
        <div className="max-w-7xl mx-auto px-4 sm:px-6">
          <div className="text-center mb-14">
            <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-[#1147D9]/10 text-[#1147D9] text-xs font-semibold mb-4">
              FONCTIONNALITÉS
            </div>
            <h2 className="text-3xl sm:text-4xl font-bold text-[var(--on-surface)] mb-4">
              Tout ce dont vous avez besoin pour réussir
            </h2>
            <p className="text-[var(--on-surface-muted)] max-w-xl mx-auto">
              Cliquez sur chaque carte pour découvrir les détails. Conçu par des professionnels, validé par des milliers de candidats reçus.
            </p>
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
            {FEATURES.map((feat) => (
              <FlipCard key={feat.title} feat={feat} />
            ))}
          </div>
        </div>
      </section>

      {/* ── Image bande ── */}
      <div className="relative h-72 overflow-hidden">
        {/* eslint-disable-next-line @next/next/no-img-element */}
        <img
          src="https://nuoonagnkhbeeymtvrcn.supabase.co/storage/v1/object/public/assets/website_assets/gpx.jpg"
          alt="Gardien de la Paix"
          className="w-full h-full object-cover"
        />
        <div className="absolute inset-0 bg-gradient-to-r from-[#000B36]/90 via-[#000B36]/50 to-transparent" />
        <div className="absolute inset-0 flex items-center px-12 max-w-5xl">
          <div>
            <h3 className="text-3xl font-black text-white mb-3">Application mobile incluse</h3>
            <p className="text-white/70 text-lg mb-6 max-w-md">Révisez sur votre téléphone, retrouvez votre progression sur le web. Tout est synchronisé en temps réel.</p>
            <Link href="/signup">
              <button className="px-6 py-3 rounded-xl bg-white text-[#000B36] font-bold text-sm hover:bg-white/90 transition-all flex items-center gap-2">
                Télécharger l&apos;app <ArrowRight size={15} />
              </button>
            </Link>
          </div>
        </div>
      </div>

      {/* ── Tarifs ── */}
      <section id="pricing" className="py-24">
        <div className="max-w-5xl mx-auto px-4 sm:px-6">
          <div className="text-center mb-14">
            <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-[#1147D9]/10 text-[#1147D9] text-xs font-semibold mb-4">
              TARIFS
            </div>
            <h2 className="text-3xl sm:text-4xl font-bold text-[var(--on-surface)] mb-4">
              Tarifs simples et transparents
            </h2>
            <p className="text-[var(--on-surface-muted)]">Sans engagement. Annulez à tout moment. 1 semaine offerte sur le mensuel.</p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-8 items-start">
            {PLANS.map((plan) => (
              <div
                key={plan.id}
                className={cn(
                  "relative rounded-2xl p-7 flex flex-col",
                  plan.style,
                  plan.highlighted ? "md:-mt-4 md:mb-4" : ""
                )}
              >
                {plan.badge && (
                  <div className={cn(
                    "absolute -top-4 left-1/2 -translate-x-1/2 px-4 py-1.5 rounded-full text-xs font-black tracking-wide whitespace-nowrap shadow-lg",
                    plan.badgeStyle
                  )}>
                    {plan.badge}
                  </div>
                )}

                <div className="mb-5 mt-2">
                  <div className="text-2xl mb-2">{plan.emoji}</div>
                  <div className="text-sm font-bold text-[var(--on-surface-muted)] uppercase tracking-wide mb-1">{plan.name}</div>
                  <div className="flex items-baseline gap-1 mb-1">
                    <span className="text-4xl font-black text-[var(--on-surface)]">{plan.price}</span>
                    {plan.period && <span className="text-[var(--on-surface-muted)] text-sm">{plan.period}</span>}
                  </div>
                  <div className="text-xs text-[var(--on-surface-muted)]">{plan.description}</div>
                </div>

                <ul className="space-y-3 mb-7 flex-1">
                  {plan.features.map((f) => (
                    <li key={f} className="flex items-start gap-2.5 text-sm text-[var(--on-surface-muted)]">
                      <div className={cn(
                        "w-5 h-5 rounded-full flex items-center justify-center shrink-0 mt-0.5",
                        plan.id === "month" ? "bg-violet-600 text-white" : plan.id === "year" ? "bg-amber-500 text-white" : "bg-emerald-500 text-white"
                      )}>
                        <Check size={11} />
                      </div>
                      {f}
                    </li>
                  ))}
                </ul>

                <Link href={plan.href}>
                  <button className={cn(
                    "w-full py-3.5 rounded-xl font-bold text-sm transition-all",
                    plan.id === "month"
                      ? "bg-violet-600 hover:bg-violet-700 text-white shadow-lg shadow-violet-500/30"
                      : plan.id === "year"
                      ? "bg-amber-500 hover:bg-amber-600 text-white shadow-lg shadow-amber-500/30"
                      : "bg-[var(--surface-variant)] hover:bg-[var(--outline)] text-[var(--on-surface)]"
                  )}>
                    {plan.cta}
                  </button>
                </Link>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* ── Témoignages ── */}
      <section className="py-24 bg-[var(--surface-container)]">
        <div className="max-w-5xl mx-auto px-4 sm:px-6">
          <div className="text-center mb-14">
            <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-emerald-100 text-emerald-700 dark:bg-emerald-900/30 dark:text-emerald-400 text-xs font-semibold mb-4">
              ✅ ILS ONT RÉUSSI
            </div>
            <h2 className="text-3xl sm:text-4xl font-bold text-[var(--on-surface)]">
              Ils ont réussi leur concours avec COP&apos;IQ
            </h2>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            {TESTIMONIALS.map((t) => (
              <div key={t.name} className="rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-6 flex flex-col">
                <div className="flex items-center gap-1 mb-4">
                  {[...Array(5)].map((_, i) => (
                    <Star key={i} size={14} className="text-amber-400 fill-amber-400" />
                  ))}
                </div>
                <p className="text-sm text-[var(--on-surface-muted)] leading-relaxed mb-5 flex-1">
                  &ldquo;{t.text}&rdquo;
                </p>
                <div className="flex items-center gap-3 pt-4 border-t border-[var(--outline)]">
                  <img
                    src={t.avatar}
                    alt={t.name}
                    width={40}
                    height={40}
                    className="rounded-full bg-[var(--surface-variant)]"
                  />
                  <div>
                    <div className="text-sm font-semibold text-[var(--on-surface)]">{t.name}</div>
                    <div className="text-xs text-[var(--on-surface-muted)]">{t.role}</div>
                  </div>
                  <div className="ml-auto">
                    <span className="px-2.5 py-1 rounded-full bg-emerald-100 text-emerald-700 dark:bg-emerald-900/30 dark:text-emerald-400 text-xs font-bold">
                      {t.score}
                    </span>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* ── Image bande 2 ── */}
      <div className="relative h-64 overflow-hidden">
        {/* eslint-disable-next-line @next/next/no-img-element */}
        <img
          src="https://nuoonagnkhbeeymtvrcn.supabase.co/storage/v1/object/public/assets/website_assets/pv_intro.jpg"
          alt="Police nationale"
          className="w-full h-full object-cover"
        />
        <div className="absolute inset-0 bg-[#000B36]/70 backdrop-blur-[1px]" />
        <div className="absolute inset-0 flex items-center justify-center text-center px-6">
          <div>
            <div className="text-5xl font-black text-white mb-2">🚔</div>
            <p className="text-white/90 font-semibold text-xl">Rejoignez les 10 000+ candidats qui préparent leur concours avec COP&apos;IQ</p>
          </div>
        </div>
      </div>

      {/* ── CTA final ── */}
      <section className="py-24">
        <div className="max-w-2xl mx-auto px-4 sm:px-6 text-center">
          <Image src={LOGO} alt="COP'IQ" width={72} height={72} className="rounded-2xl shadow-xl mx-auto mb-6" unoptimized />
          <h2 className="text-3xl sm:text-4xl font-bold text-[var(--on-surface)] mb-4">
            Commencez votre préparation aujourd&apos;hui
          </h2>
          <p className="text-[var(--on-surface-muted)] mb-8 text-lg">
            Inscription gratuite, sans carte bancaire. Accès immédiat.
          </p>
          <Link href="/signup">
            <button className="px-10 py-4 rounded-2xl bg-[#1147D9] hover:bg-[#1A55E6] text-white font-black text-base transition-all shadow-xl hover:shadow-2xl hover:-translate-y-0.5 inline-flex items-center gap-3">
              Créer mon compte gratuit <ArrowRight size={18} />
            </button>
          </Link>
          <p className="text-xs text-[var(--on-surface-faint)] mt-4">Aucune carte bancaire requise · Annulation à tout moment</p>
        </div>
      </section>

      {/* ── Footer ── */}
      <footer className="border-t border-[var(--outline)] py-12 bg-[var(--surface-container)]">
        <div className="max-w-7xl mx-auto px-4 sm:px-6">
          <div className="flex items-center gap-3 mb-8">
            <Image src={LOGO} alt="COP'IQ" width={36} height={36} className="rounded-xl" unoptimized />
            <span className="font-bold text-[var(--on-surface)]">COP&apos;IQ</span>
          </div>
          <div className="grid grid-cols-2 sm:grid-cols-4 gap-8 mb-8">
            <div>
              <div className="font-semibold text-sm text-[var(--on-surface)] mb-3">COP&apos;IQ</div>
              <ul className="space-y-2">
                {[["À propos", "/beta"], ["Blog", "/blog"], ["Forum", "/forum"], ["Contact", "/contact"]].map(([l, h]) => (
                  <li key={l}><Link href={h} className="text-sm text-[var(--on-surface-muted)] hover:text-[var(--on-surface)] transition-colors">{l}</Link></li>
                ))}
              </ul>
            </div>
            <div>
              <div className="font-semibold text-sm text-[var(--on-surface)] mb-3">Préparation</div>
              <ul className="space-y-2">
                {[["Policier Adjoint", "/pa/scolarite"], ["Gardien de la Paix", "/gpx/scolarite"], ["Tarifs", "#pricing"], ["Quiz gratuits", "/gpx/quiz"]].map(([l, h]) => (
                  <li key={l}><Link href={h} className="text-sm text-[var(--on-surface-muted)] hover:text-[var(--on-surface)] transition-colors">{l}</Link></li>
                ))}
              </ul>
            </div>
            <div>
              <div className="font-semibold text-sm text-[var(--on-surface)] mb-3">Compte</div>
              <ul className="space-y-2">
                {[["Se connecter", "/login"], ["S'inscrire", "/signup"], ["Mot de passe oublié", "/forgot-password"]].map(([l, h]) => (
                  <li key={l}><Link href={h} className="text-sm text-[var(--on-surface-muted)] hover:text-[var(--on-surface)] transition-colors">{l}</Link></li>
                ))}
              </ul>
            </div>
            <div>
              <div className="font-semibold text-sm text-[var(--on-surface)] mb-3">Légal</div>
              <ul className="space-y-2">
                {[["Confidentialité", "/privacy"], ["CGU", "/cgu"]].map(([l, h]) => (
                  <li key={l}><Link href={h} className="text-sm text-[var(--on-surface-muted)] hover:text-[var(--on-surface)] transition-colors">{l}</Link></li>
                ))}
              </ul>
            </div>
          </div>
          <div className="border-t border-[var(--outline)] pt-6 flex items-center justify-between flex-wrap gap-4">
            <span className="text-sm text-[var(--on-surface-faint)]">© 2026 COP&apos;IQ — Tous droits réservés</span>
            <span className="text-sm text-[var(--on-surface-faint)]">🚔 Application mobile + Web synchronisés</span>
          </div>
        </div>
      </footer>
    </div>
  )
}
