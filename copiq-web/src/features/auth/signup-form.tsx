"use client"

import { useState } from "react"
import Link from "next/link"
import Image from "next/image"
import { useRouter } from "next/navigation"
import { createClient } from "@/lib/supabase/client"
import { cn } from "@/lib/utils"
import { Eye, EyeOff, UserPlus, Check, X } from "lucide-react"
import toast from "react-hot-toast"

const LOGO = "https://nuoonagnkhbeeymtvrcn.supabase.co/storage/v1/object/public/assets/logo_appstore.png"

interface Criterion {
  label: string
  test: (pwd: string) => boolean
}

const CRITERIA: Criterion[] = [
  { label: "8 caractères minimum", test: (p) => p.length >= 8 },
  { label: "Une majuscule (A-Z)", test: (p) => /[A-Z]/.test(p) },
  { label: "Un chiffre (0-9)", test: (p) => /[0-9]/.test(p) },
  { label: "Un caractère spécial (!@#…)", test: (p) => /[^A-Za-z0-9]/.test(p) },
]

function StrengthBar({ password }: { password: string }) {
  const score = CRITERIA.filter(c => c.test(password)).length
  const colors = ["bg-red-500", "bg-orange-500", "bg-yellow-500", "bg-emerald-500"]
  const labels = ["Très faible", "Faible", "Moyen", "Fort"]
  if (!password) return null
  return (
    <div className="mt-2">
      <div className="flex gap-1 mb-1">
        {[0, 1, 2, 3].map(i => (
          <div
            key={i}
            className={cn(
              "h-1.5 flex-1 rounded-full transition-all duration-300",
              i < score ? colors[score - 1] : "bg-[var(--outline)]"
            )}
          />
        ))}
      </div>
      {score > 0 && (
        <p className={cn("text-xs font-medium", colors[score - 1].replace("bg-", "text-"))}>
          {labels[score - 1]}
        </p>
      )}
    </div>
  )
}

export function SignupForm() {
  const router = useRouter()
  const [email, setEmail] = useState("")
  const [password, setPassword] = useState("")
  const [confirmPwd, setConfirmPwd] = useState("")
  const [showPwd, setShowPwd] = useState(false)
  const [showConfirm, setShowConfirm] = useState(false)
  const [loading, setLoading] = useState(false)
  const [done, setDone] = useState(false)
  const supabase = createClient()

  const allCriteriaMet = CRITERIA.every(c => c.test(password))
  const passwordsMatch = password === confirmPwd && confirmPwd.length > 0
  const canSubmit = email && allCriteriaMet && passwordsMatch

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    if (!canSubmit) return
    setLoading(true)

    const { error } = await supabase.auth.signUp({
      email,
      password,
      options: {
        emailRedirectTo: `${typeof window !== "undefined" ? window.location.origin : ""}/auth/callback`,
      },
    })

    if (error) {
      toast.error(error.message)
      setLoading(false)
      return
    }
    setDone(true)
  }

  if (done) {
    return (
      <div className="text-center animate-slide-up">
        <div className="w-16 h-16 rounded-full bg-emerald-500/10 flex items-center justify-center mx-auto mb-6">
          <Check size={32} className="text-emerald-500" />
        </div>
        <h1 className="text-2xl font-bold text-[var(--on-surface)] mb-3">Vérifiez votre email</h1>
        <p className="text-[var(--on-surface-muted)] mb-6">
          Un lien de confirmation a été envoyé à{" "}
          <span className="font-medium text-[var(--on-surface)]">{email}</span>.
          Cliquez dessus pour activer votre compte.
        </p>
        <Link href="/login" className="text-[#1147D9] hover:text-[#1A55E6] font-medium transition-colors">
          Retour à la connexion →
        </Link>
      </div>
    )
  }

  return (
    <div className="animate-slide-up">
      {/* Logo mobile */}
      <div className="flex justify-center mb-6 lg:hidden">
        <Image src={LOGO} alt="COP'IQ" width={56} height={56} className="rounded-2xl shadow-lg" unoptimized />
      </div>

      <div className="mb-8">
        <h1 className="text-2xl font-bold text-[var(--on-surface)] mb-2">Créer votre compte</h1>
        <p className="text-[var(--on-surface-muted)]">Commencez gratuitement — sans carte bancaire</p>
      </div>

      <form onSubmit={handleSubmit} className="space-y-5">
        {/* Email */}
        <div>
          <label className="block text-sm font-medium text-[var(--on-surface)] mb-1.5">Adresse email</label>
          <input
            type="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            placeholder="vous@exemple.fr"
            required
            autoComplete="email"
            className={cn(
              "w-full px-4 py-3 rounded-xl border text-sm transition-all duration-200",
              "bg-[var(--surface)] text-[var(--on-surface)]",
              "border-[var(--outline)] placeholder:text-[var(--on-surface-faint)]",
              "focus:outline-none focus:ring-2 focus:ring-[#1147D9]/30 focus:border-[#1147D9]"
            )}
          />
        </div>

        {/* Mot de passe */}
        <div>
          <label className="block text-sm font-medium text-[var(--on-surface)] mb-1.5">Mot de passe</label>
          <div className="relative">
            <input
              type={showPwd ? "text" : "password"}
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              placeholder="Créez un mot de passe sécurisé"
              required
              autoComplete="new-password"
              className={cn(
                "w-full px-4 py-3 pr-12 rounded-xl border text-sm transition-all duration-200",
                "bg-[var(--surface)] text-[var(--on-surface)]",
                "placeholder:text-[var(--on-surface-faint)]",
                "focus:outline-none focus:ring-2 transition-all",
                password.length === 0
                  ? "border-[var(--outline)] focus:ring-[#1147D9]/30 focus:border-[#1147D9]"
                  : allCriteriaMet
                  ? "border-emerald-500 focus:ring-emerald-500/30 focus:border-emerald-500"
                  : "border-red-400 focus:ring-red-400/30 focus:border-red-400"
              )}
            />
            <button
              type="button"
              onClick={() => setShowPwd(!showPwd)}
              className="absolute right-3 top-1/2 -translate-y-1/2 text-[var(--on-surface-faint)] hover:text-[var(--on-surface-muted)] p-1 transition-colors"
            >
              {showPwd ? <EyeOff size={18} /> : <Eye size={18} />}
            </button>
          </div>

          {/* Strength bar */}
          <StrengthBar password={password} />

          {/* Criteria list — visible dès que l'utilisateur commence à taper */}
          {password.length > 0 && (
            <ul className="mt-3 space-y-1.5">
              {CRITERIA.map((c) => {
                const ok = c.test(password)
                return (
                  <li key={c.label} className="flex items-center gap-2">
                    <div className={cn(
                      "w-4 h-4 rounded-full flex items-center justify-center shrink-0 transition-all duration-300",
                      ok ? "bg-emerald-500" : "bg-red-400"
                    )}>
                      {ok
                        ? <Check size={9} className="text-white" strokeWidth={3} />
                        : <X size={9} className="text-white" strokeWidth={3} />
                      }
                    </div>
                    <span className={cn(
                      "text-xs transition-colors duration-300",
                      ok ? "text-emerald-600 dark:text-emerald-400 line-through" : "text-red-500 dark:text-red-400"
                    )}>
                      {c.label}
                    </span>
                  </li>
                )
              })}
            </ul>
          )}
        </div>

        {/* Confirmation */}
        <div>
          <label className="block text-sm font-medium text-[var(--on-surface)] mb-1.5">Confirmer le mot de passe</label>
          <div className="relative">
            <input
              type={showConfirm ? "text" : "password"}
              value={confirmPwd}
              onChange={(e) => setConfirmPwd(e.target.value)}
              placeholder="Répétez votre mot de passe"
              required
              autoComplete="new-password"
              disabled={!allCriteriaMet}
              className={cn(
                "w-full px-4 py-3 pr-12 rounded-xl border text-sm transition-all duration-200",
                "bg-[var(--surface)] text-[var(--on-surface)]",
                "placeholder:text-[var(--on-surface-faint)]",
                "focus:outline-none focus:ring-2",
                "disabled:opacity-40 disabled:cursor-not-allowed",
                confirmPwd.length === 0
                  ? "border-[var(--outline)] focus:ring-[#1147D9]/30 focus:border-[#1147D9]"
                  : passwordsMatch
                  ? "border-emerald-500 focus:ring-emerald-500/30 focus:border-emerald-500"
                  : "border-red-400 focus:ring-red-400/30 focus:border-red-400"
              )}
            />
            <button
              type="button"
              onClick={() => setShowConfirm(!showConfirm)}
              disabled={!allCriteriaMet}
              className="absolute right-3 top-1/2 -translate-y-1/2 text-[var(--on-surface-faint)] hover:text-[var(--on-surface-muted)] p-1 transition-colors disabled:opacity-40"
            >
              {showConfirm ? <EyeOff size={18} /> : <Eye size={18} />}
            </button>
          </div>
          {confirmPwd.length > 0 && (
            <div className={cn(
              "flex items-center gap-1.5 mt-1.5 text-xs font-medium transition-colors duration-300",
              passwordsMatch ? "text-emerald-600 dark:text-emerald-400" : "text-red-500 dark:text-red-400"
            )}>
              {passwordsMatch
                ? <><Check size={12} strokeWidth={3} />Mots de passe identiques ✓</>
                : <><X size={12} strokeWidth={3} />Les mots de passe ne correspondent pas</>
              }
            </div>
          )}
          {!allCriteriaMet && confirmPwd.length === 0 && (
            <p className="text-xs text-[var(--on-surface-faint)] mt-1.5">Remplissez d&apos;abord tous les critères ci-dessus</p>
          )}
        </div>

        {/* CGU */}
        <div className="text-xs text-[var(--on-surface-faint)] leading-relaxed">
          En créant un compte, vous acceptez nos{" "}
          <Link href="/cgu" className="text-[#1147D9] hover:underline">Conditions d&apos;utilisation</Link>{" "}
          et notre{" "}
          <Link href="/privacy" className="text-[#1147D9] hover:underline">Politique de confidentialité</Link>.
        </div>

        {/* Submit */}
        <button
          type="submit"
          disabled={loading || !canSubmit}
          className={cn(
            "w-full flex items-center justify-center gap-2.5 py-3.5 px-6 rounded-xl",
            "font-bold text-sm text-white transition-all duration-200",
            "active:scale-[0.98]",
            canSubmit && !loading
              ? "bg-[#1147D9] hover:bg-[#1A55E6] shadow-lg shadow-[#1147D9]/30 hover:shadow-xl hover:-translate-y-0.5"
              : "bg-[var(--outline)] cursor-not-allowed opacity-50"
          )}
        >
          {loading
            ? <span className="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin" />
            : <UserPlus size={16} />
          }
          {loading ? "Création du compte…" : "Créer mon compte gratuit"}
        </button>
      </form>

      <div className="relative my-6">
        <div className="absolute inset-0 flex items-center">
          <div className="w-full border-t border-[var(--outline)]" />
        </div>
        <div className="relative flex justify-center">
          <span className="px-3 text-xs text-[var(--on-surface-faint)] bg-[var(--surface)]">Déjà un compte ?</span>
        </div>
      </div>

      <Link
        href="/login"
        className={cn(
          "block w-full text-center py-3.5 px-6 rounded-xl border",
          "border-[var(--outline)] text-[var(--on-surface)] font-medium text-sm",
          "hover:bg-[var(--surface-container)] transition-colors duration-200"
        )}
      >
        Se connecter
      </Link>
    </div>
  )
}
