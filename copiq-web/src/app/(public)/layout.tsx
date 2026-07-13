import Link from "next/link"
import { ThemeToggle } from "@/components/ui/theme-toggle"

export default function PublicLayout({ children }: { children: React.ReactNode }) {
  return (
    <div className="min-h-screen bg-[var(--surface)] text-[var(--on-surface)]">
      <header className="sticky top-0 z-50 border-b border-[var(--outline)] bg-[var(--surface)]/90 backdrop-blur-xl">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 h-16 flex items-center justify-between">
          <Link href="/" className="flex items-center gap-3">
            <div className="w-9 h-9 rounded-xl bg-gradient-to-br from-[#1147D9] to-[#1A55E6] flex items-center justify-center shadow-[0_4px_24px_rgba(17,71,217,0.25)]">
              <span className="text-white font-bold text-base">C</span>
            </div>
            <span className="font-bold text-lg tracking-tight">COP&apos;IQ</span>
          </Link>
          <nav className="hidden md:flex items-center gap-6 text-sm text-[var(--on-surface-muted)]">
            <Link href="/tarifs" className="hover:text-[var(--on-surface)] transition-colors">Tarifs</Link>
            <Link href="/blog" className="hover:text-[var(--on-surface)] transition-colors">Blog</Link>
            <Link href="/forum" className="hover:text-[var(--on-surface)] transition-colors">Forum</Link>
            <Link href="/contact" className="hover:text-[var(--on-surface)] transition-colors">Contact</Link>
          </nav>
          <div className="flex items-center gap-3">
            <ThemeToggle />
            <Link href="/login" className="text-sm text-[var(--on-surface-muted)] hover:text-[var(--on-surface)] transition-colors hidden sm:block">
              Connexion
            </Link>
            <Link href="/signup" className="px-4 py-2 rounded-xl bg-[#1147D9] hover:bg-[#1A55E6] text-white text-sm font-semibold transition-colors shadow-[0_4px_24px_rgba(17,71,217,0.25)]">
              Commencer
            </Link>
          </div>
        </div>
      </header>
      <main>{children}</main>
      <footer className="border-t border-[var(--outline)] py-10 mt-20">
        <div className="max-w-7xl mx-auto px-4 sm:px-6">
          <div className="grid grid-cols-2 sm:grid-cols-4 gap-8 mb-8">
            {[
              { title: "COP'IQ", links: [["À propos", "/beta"], ["Blog", "/blog"], ["Forum", "/forum"], ["Contact", "/contact"]] },
              { title: "Préparation", links: [["Policier Adjoint", "/pa/scolarite"], ["Gardien de la Paix", "/gpx/scolarite"], ["Tarifs", "/tarifs"], ["Quiz gratuits", "/signup"]] },
              { title: "Compte", links: [["Se connecter", "/login"], ["S'inscrire", "/signup"], ["Mot de passe oublié", "/forgot-password"]] },
              { title: "Légal", links: [["Confidentialité", "/privacy"], ["CGU", "/cgu"]] },
            ].map((col) => (
              <div key={col.title}>
                <div className="font-semibold text-sm text-[var(--on-surface)] mb-3">{col.title}</div>
                <ul className="space-y-2">
                  {col.links.map(([label, href]) => (
                    <li key={label}>
                      <Link href={href} className="text-sm text-[var(--on-surface-muted)] hover:text-[var(--on-surface)] transition-colors">
                        {label}
                      </Link>
                    </li>
                  ))}
                </ul>
              </div>
            ))}
          </div>
          <div className="border-t border-[var(--outline)] pt-6 flex items-center justify-between flex-wrap gap-4">
            <span className="text-sm text-[var(--on-surface-faint)]">© 2026 COP&apos;IQ — Tous droits réservés</span>
            <span className="text-sm text-[var(--on-surface-faint)]">🚔 Synchronisé avec l&apos;application mobile</span>
          </div>
        </div>
      </footer>
    </div>
  )
}
