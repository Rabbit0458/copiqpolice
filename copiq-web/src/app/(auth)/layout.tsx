import Link from "next/link"
import Image from "next/image"

export default function AuthLayout({ children }: { children: React.ReactNode }) {
  return (
    <div className="min-h-screen flex">
      {/* Colonne gauche — visuel brand */}
      <div className="hidden lg:flex lg:w-[480px] xl:w-[560px] flex-col relative overflow-hidden bg-gradient-to-br from-[#000B36] via-[#000A33] to-[#00082D]">
        {/* Glow brand */}
        <div className="absolute inset-0 pointer-events-none">
          <div className="absolute top-1/3 left-1/2 -translate-x-1/2 -translate-y-1/2 w-96 h-96 bg-brand/20 rounded-full blur-3xl" />
          <div className="absolute bottom-1/4 left-1/4 w-64 h-64 bg-brand-mid/10 rounded-full blur-2xl" />
        </div>

        {/* Logo */}
        <div className="relative z-10 p-8">
          <Link href="/" className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-brand to-brand-mid flex items-center justify-center shadow-brand">
              <span className="text-white font-bold text-lg">C</span>
            </div>
            <span className="text-white font-semibold text-xl tracking-tight">COP&apos;IQ</span>
          </Link>
        </div>

        {/* Contenu central */}
        <div className="relative z-10 flex-1 flex flex-col items-center justify-center px-12 text-center">
          <div className="mb-8 text-6xl">🚔</div>
          <h2 className="text-white text-3xl font-bold leading-tight mb-4">
            Préparez votre concours avec confiance
          </h2>
          <p className="text-white/60 text-lg leading-relaxed">
            Quiz, cours juridiques, cas pratiques et statistiques de progression.
            La plateforme complète pour réussir Policier Adjoint et Gardien de la Paix.
          </p>

          {/* Stats */}
          <div className="mt-12 grid grid-cols-3 gap-6 w-full">
            {[
              { value: "5 000+", label: "Questions" },
              { value: "200+", label: "Cours" },
              { value: "95%", label: "Satisfaction" },
            ].map((stat) => (
              <div key={stat.label} className="text-center">
                <div className="text-white text-2xl font-bold">{stat.value}</div>
                <div className="text-white/40 text-sm mt-1">{stat.label}</div>
              </div>
            ))}
          </div>
        </div>

        {/* Footer */}
        <div className="relative z-10 p-8 text-center text-white/30 text-sm">
          © 2026 COP&apos;IQ — Tous droits réservés
        </div>
      </div>

      {/* Colonne droite — formulaire */}
      <div className="flex-1 flex flex-col items-center justify-center p-6 bg-[var(--surface)]">
        {/* Logo mobile */}
        <div className="lg:hidden mb-8">
          <Link href="/" className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-brand to-brand-mid flex items-center justify-center shadow-brand">
              <span className="text-white font-bold text-lg">C</span>
            </div>
            <span className="font-semibold text-xl tracking-tight text-[var(--on-surface)]">COP&apos;IQ</span>
          </Link>
        </div>

        <div className="w-full max-w-[420px]">
          {children}
        </div>
      </div>
    </div>
  )
}
