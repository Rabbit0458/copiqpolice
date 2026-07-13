"use client"

import { useState } from "react"
import Link from "next/link"
import { createClient } from "@/lib/supabase/client"
import { cn } from "@/lib/utils"
import { Mail, ArrowLeft, Check } from "lucide-react"
import toast from "react-hot-toast"

export function ForgotPasswordForm() {
  const [email, setEmail] = useState("")
  const [loading, setLoading] = useState(false)
  const [sent, setSent] = useState(false)
  const supabase = createClient()

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    setLoading(true)

    const { error } = await supabase.auth.resetPasswordForEmail(email, {
      redirectTo: `${process.env.NEXT_PUBLIC_SITE_URL}/reset-password`,
    })

    if (error) {
      toast.error(error.message)
      setLoading(false)
      return
    }

    setSent(true)
  }

  if (sent) {
    return (
      <div className="text-center animate-slide-up">
        <div className="w-16 h-16 rounded-full bg-success/10 flex items-center justify-center mx-auto mb-6">
          <Check size={32} className="text-success" />
        </div>
        <h1 className="text-2xl font-bold text-[var(--on-surface)] mb-3">Email envoyé</h1>
        <p className="text-[var(--on-surface-muted)] mb-6">
          Si un compte existe pour <span className="font-medium text-[var(--on-surface)]">{email}</span>,
          vous recevrez un lien pour réinitialiser votre mot de passe.
        </p>
        <Link href="/login" className="text-brand hover:text-brand-mid font-medium transition-colors">
          ← Retour à la connexion
        </Link>
      </div>
    )
  }

  return (
    <div className="animate-slide-up">
      <Link href="/login" className="flex items-center gap-2 text-sm text-[var(--on-surface-muted)] hover:text-[var(--on-surface)] transition-colors mb-8">
        <ArrowLeft size={16} />
        Retour à la connexion
      </Link>

      <div className="mb-8">
        <h1 className="text-2xl font-bold text-[var(--on-surface)] mb-2">Mot de passe oublié</h1>
        <p className="text-[var(--on-surface-muted)]">
          Entrez votre email pour recevoir un lien de réinitialisation.
        </p>
      </div>

      <form onSubmit={handleSubmit} className="space-y-4">
        <div>
          <label className="block text-sm font-medium text-[var(--on-surface)] mb-1.5">Email</label>
          <div className="relative">
            <input
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              placeholder="vous@exemple.fr"
              required
              className={cn(
                "w-full pl-10 pr-4 py-3 rounded-xl border text-sm",
                "bg-[var(--surface)] text-[var(--on-surface)]",
                "border-[var(--outline)] placeholder:text-[var(--on-surface-faint)]",
                "focus:outline-none focus:ring-2 focus:ring-brand/30 focus:border-brand transition-all"
              )}
            />
            <Mail size={16} className="absolute left-3.5 top-1/2 -translate-y-1/2 text-[var(--on-surface-faint)]" />
          </div>
        </div>

        <button
          type="submit"
          disabled={loading || !email}
          className={cn(
            "w-full py-3.5 px-6 rounded-xl bg-brand hover:bg-brand-mid",
            "text-white font-semibold text-sm shadow-brand hover:shadow-brand-lg",
            "transition-all duration-200 disabled:opacity-50 disabled:cursor-not-allowed active:scale-[0.98]"
          )}
        >
          {loading ? "Envoi…" : "Envoyer le lien"}
        </button>
      </form>
    </div>
  )
}
