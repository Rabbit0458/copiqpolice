import type { Metadata } from "next"
import Link from "next/link"
export const metadata: Metadata = { title: "À propos — COP'IQ Beta" }
export default function BetaPage() {
  return (
    <div className="max-w-3xl mx-auto px-4 py-16">
      <div className="text-center mb-12">
        <span className="inline-block px-3 py-1 rounded-full bg-[#1147D9]/10 text-[#1147D9] text-xs font-semibold mb-4">Version Bêta</span>
        <h1 className="text-4xl font-bold text-[var(--on-surface)] mb-4">À propos de COP&apos;IQ</h1>
        <p className="text-[var(--on-surface-muted)] text-lg leading-relaxed">La plateforme de préparation aux concours de la Police Nationale, née d&apos;une vraie demande terrain.</p>
      </div>
      <div className="space-y-8 text-[var(--on-surface-muted)] leading-relaxed">
        <div className="rounded-2xl border border-[var(--outline)] p-8">
          <h2 className="text-xl font-bold text-[var(--on-surface)] mb-4">Notre mission</h2>
          <p>COP&apos;IQ est né d&apos;une conviction simple : préparer le concours de Policier Adjoint ou Gardien de la Paix ne devrait pas nécessiter des dizaines de manuels coûteux. La plateforme regroupe tout ce dont un candidat a besoin : cours juridiques structurés, quiz par thème, cas pratiques corrigés par IA, psychotechniques et statistiques de progression.</p>
        </div>
        <div className="rounded-2xl border border-[var(--outline)] p-8">
          <h2 className="text-xl font-bold text-[var(--on-surface)] mb-4">Pourquoi une version web ?</h2>
          <p>Après 3 ans de développement de l&apos;application mobile, de nombreux utilisateurs nous ont demandé un accès web confortable depuis leur ordinateur — notamment pour étudier les cours et rédiger les cas pratiques. Le site web est une extension naturelle de l&apos;app, avec le même compte et la même progression.</p>
        </div>
        <div className="rounded-2xl border border-[var(--outline)] p-8">
          <h2 className="text-xl font-bold text-[var(--on-surface)] mb-4">Cette version est en bêta</h2>
          <p className="mb-4">Certaines fonctionnalités sont encore en cours de développement. Vos retours sont précieux pour améliorer la plateforme.</p>
          <Link href="/contact" className="inline-flex items-center gap-2 px-4 py-2 rounded-xl bg-[#1147D9] text-white text-sm font-semibold hover:bg-[#1A55E6] transition-colors">
            Donner un retour
          </Link>
        </div>
        <div className="grid grid-cols-3 gap-6 text-center">
          {[["3 ans", "de développement"], ["10 000+", "utilisateurs mobiles"], ["5 000+", "questions"]].map(([v, l]) => (
            <div key={l} className="rounded-xl border border-[var(--outline)] p-5">
              <div className="text-2xl font-bold text-[var(--on-surface)]">{v}</div>
              <div className="text-xs text-[var(--on-surface-faint)] mt-1">{l}</div>
            </div>
          ))}
        </div>
      </div>
    </div>
  )
}
