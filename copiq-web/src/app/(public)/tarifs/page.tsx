import type { Metadata } from "next"
import Link from "next/link"
import { Check, Crown, Zap } from "lucide-react"

export const metadata: Metadata = {
  title: "Tarifs — COP'IQ",
  description: "Découvrez nos offres gratuite et premium pour préparer le concours Policier Adjoint et Gardien de la Paix.",
}

const PLANS = [
  {
    id: "free", name: "Gratuit", price: "0 €", period: "", popular: false,
    description: "Pour découvrir COP'IQ",
    features: ["Quiz de base (droit pénal, institutions)", "10 cas pratiques / semaine", "Forum communautaire", "Progression de base", "Publicités présentes"],
    cta: "Créer un compte gratuit", href: "/signup", variant: "outline",
  },
  {
    id: "month", name: "Mensuel", price: "8,99 €", period: "/mois", popular: true,
    description: "Accès complet — 1 semaine offerte",
    features: ["Tous les modules quiz (PA + GPX)", "Cas pratiques illimités", "Cours premium protégés", "Psychotechniques + Langues", "Concours blancs illimités", "Stats & progression avancées", "Sans publicité", "Synchronisation mobile ↔ web"],
    cta: "Commencer l'essai gratuit", href: "/signup", variant: "brand",
  },
  {
    id: "year", name: "Annuel", price: "86,99 €", period: "/an", popular: false,
    description: "Économisez 20% — soit 7,25 €/mois",
    features: ["Tout le plan mensuel", "20% d'économie", "Support prioritaire", "Accès anticipé aux nouveautés", "Export PDF watermarkés"],
    cta: "S'abonner pour un an", href: "/signup", variant: "outline",
  },
]

const FAQ = [
  { q: "Puis-je annuler à tout moment ?", a: "Oui. Aucun engagement. Vous annulez depuis votre espace Stripe en 2 clics et conservez l'accès jusqu'à la fin de la période payée." },
  { q: "Mon compte est-il synchronisé avec l'application mobile ?", a: "Absolument. COP'IQ utilise Supabase pour une synchronisation temps réel. Un quiz commencé sur mobile se retrouve dans votre historique web." },
  { q: "Y a-t-il un essai gratuit ?", a: "Oui, 7 jours d'essai offerts sur le plan mensuel et annuel. Aucune carte bancaire n'est débitée pendant cette période." },
  { q: "Quels moyens de paiement acceptez-vous ?", a: "Carte bancaire (Visa, Mastercard, American Express) via Stripe. Paiement 100% sécurisé." },
  { q: "La version web remplace-t-elle l'application mobile ?", a: "Non, elles se complètent. L'application mobile est idéale pour réviser en déplacement, le site web offre une expérience plus riche sur grand écran." },
]

export default function TarifsPage() {
  return (
    <div className="py-16 px-4 sm:px-6">
      <div className="max-w-5xl mx-auto">
        <div className="text-center mb-14">
          <span className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-[#1147D9]/10 text-[#1147D9] text-xs font-semibold mb-4">
            <Crown size={12} /> Tarifs simples et transparents
          </span>
          <h1 className="text-4xl font-bold text-[var(--on-surface)] mb-4">
            Investissez dans votre réussite
          </h1>
          <p className="text-[var(--on-surface-muted)] max-w-xl mx-auto">
            Sans engagement. Annulez à tout moment. Synchronisé avec votre application mobile.
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-20">
          {PLANS.map((plan) => (
            <div
              key={plan.id}
              className={`rounded-2xl border p-6 flex flex-col relative ${plan.popular ? "border-[#1147D9] bg-[#1147D9]/5 shadow-[0_8px_40px_rgba(17,71,217,0.15)]" : "border-[var(--outline)] bg-[var(--surface)]"}`}
            >
              {plan.popular && (
                <div className="absolute -top-3.5 left-1/2 -translate-x-1/2 px-3 py-1 rounded-full bg-[#1147D9] text-white text-xs font-bold shadow">
                  Le plus populaire
                </div>
              )}
              <div className="mb-5">
                <div className="text-xs font-semibold text-[var(--on-surface-muted)] uppercase tracking-widest mb-1">{plan.name}</div>
                <div className="flex items-baseline gap-1 mb-1">
                  <span className="text-3xl font-bold text-[var(--on-surface)]">{plan.price}</span>
                  {plan.period && <span className="text-[var(--on-surface-muted)]">{plan.period}</span>}
                </div>
                <div className="text-xs text-[var(--on-surface-muted)]">{plan.description}</div>
              </div>
              <ul className="space-y-2.5 mb-6 flex-1">
                {plan.features.map((f) => (
                  <li key={f} className="flex items-start gap-2 text-sm text-[var(--on-surface-muted)]">
                    <Check size={13} className="text-[#22C55E] shrink-0 mt-0.5" />
                    {f}
                  </li>
                ))}
              </ul>
              <Link
                href={plan.href}
                className={`block w-full text-center py-3 rounded-xl font-semibold text-sm transition-all ${plan.variant === "brand" ? "bg-[#1147D9] hover:bg-[#1A55E6] text-white shadow-[0_4px_24px_rgba(17,71,217,0.3)]" : "border border-[var(--outline)] text-[var(--on-surface)] hover:bg-[var(--surface-container)]"}`}
              >
                {plan.cta}
              </Link>
            </div>
          ))}
        </div>

        {/* Feature comparison */}
        <div className="mb-20">
          <h2 className="text-2xl font-bold text-[var(--on-surface)] text-center mb-8">Comparaison détaillée</h2>
          <div className="overflow-x-auto">
            <table className="w-full text-sm">
              <thead>
                <tr className="border-b border-[var(--outline)]">
                  <th className="text-left py-3 pr-4 text-[var(--on-surface-muted)] font-medium">Fonctionnalité</th>
                  {["Gratuit", "Mensuel", "Annuel"].map((p) => (
                    <th key={p} className="text-center py-3 px-4 text-[var(--on-surface)] font-semibold">{p}</th>
                  ))}
                </tr>
              </thead>
              <tbody className="divide-y divide-[var(--outline)]">
                {[
                  ["Quiz droit pénal & institutions", true, true, true],
                  ["Quiz tous modules (PA + GPX)", false, true, true],
                  ["Cas pratiques", "10/semaine", "Illimité", "Illimité"],
                  ["Cours premium protégés", false, true, true],
                  ["Psychotechniques", false, true, true],
                  ["Langues étrangères", false, true, true],
                  ["Concours blancs", false, true, true],
                  ["Statistiques avancées", false, true, true],
                  ["Sans publicité", false, true, true],
                  ["Synchronisation mobile ↔ web", true, true, true],
                  ["Export PDF watermarkés", false, true, true],
                  ["Support prioritaire", false, false, true],
                ].map(([feature, free, month, year]) => (
                  <tr key={String(feature)} className="hover:bg-[var(--surface-container)] transition-colors">
                    <td className="py-3 pr-4 text-[var(--on-surface-muted)]">{feature}</td>
                    {[free, month, year].map((val, i) => (
                      <td key={i} className="text-center py-3 px-4">
                        {val === true ? <Check size={16} className="text-[#22C55E] mx-auto" /> :
                         val === false ? <span className="text-[var(--on-surface-faint)]">—</span> :
                         <span className="text-xs font-medium text-[var(--on-surface)]">{val}</span>}
                      </td>
                    ))}
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>

        {/* FAQ */}
        <div className="max-w-2xl mx-auto">
          <h2 className="text-2xl font-bold text-[var(--on-surface)] text-center mb-8">Questions fréquentes</h2>
          <div className="space-y-4">
            {FAQ.map((item) => (
              <div key={item.q} className="rounded-xl border border-[var(--outline)] p-5">
                <div className="font-semibold text-[var(--on-surface)] mb-2 flex items-start gap-2">
                  <Zap size={14} className="text-[#1147D9] shrink-0 mt-0.5" />
                  {item.q}
                </div>
                <p className="text-sm text-[var(--on-surface-muted)] leading-relaxed">{item.a}</p>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  )
}
