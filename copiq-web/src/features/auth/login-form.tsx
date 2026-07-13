"use client"

import { useState } from "react"
import Link from "next/link"
import { useRouter, useSearchParams } from "next/navigation"
import { createClient } from "@/lib/supabase/client"
import { cn } from "@/lib/utils"
import { Eye, EyeOff, LogIn } from "lucide-react"
import toast from "react-hot-toast"

export function LoginForm() {
  const router = useRouter()
  const searchParams = useSearchParams()
  const redirect = searchParams.get("redirect") ?? "/dashboard"

  const [email, setEmail] = useState("")
  const [password, setPassword] = useState("")
  const [showPwd, setShowPwd] = useState(false)
  const [loading, setLoading] = useState(false)

  const supabase = createClient()

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    if (!email || !password) return
    setLoading(true)

    const { error } = await supabase.auth.signInWithPassword({ email, password })

    if (error) {
      toast.error(
        error.message === "Invalid login credentials"
          ? "Email ou mot de passe incorrect"
          : error.message
      )
      setLoading(false)
      return
    }

    toast.success("Connexion réussie !")
    router.push(redirect)
    router.refresh()
  }

  return (
    <div className="animate-slide-up">
      <div className="mb-8">
        <h1 className="text-2xl font-bold text-[var(--on-surface)] mb-2">
          Content de vous revoir
        </h1>
        <p className="text-[var(--on-surface-muted)]">
          Connectez-vous pour reprendre votre progression
        </p>
      </div>

      <form onSubmit={handleSubmit} className="space-y-4">
        {/* Email */}
        <div>
          <label className="block text-sm font-medium text-[var(--on-surface)] mb-1.5">
            Adresse email
          </label>
          <input
            type="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            placeholder="vous@exemple.fr"
            required
            autoComplete="email"
            className={cn(
              "w-full px-4 py-3 rounded-xl border text-sm",
              "bg-[var(--surface)] text-[var(--on-surface)]",
              "border-[var(--outline)] placeholder:text-[var(--on-surface-faint)]",
              "focus:outline-none focus:ring-2 focus:ring-brand/30 focus:border-brand",
              "transition-all duration-200"
            )}
          />
        </div>

        {/* Mot de passe */}
        <div>
          <div className="flex items-center justify-between mb-1.5">
            <label className="text-sm font-medium text-[var(--on-surface)]">
              Mot de passe
            </label>
            <Link
              href="/forgot-password"
              className="text-sm text-brand hover:text-brand-mid transition-colors"
            >
              Mot de passe oublié ?
            </Link>
          </div>
          <div className="relative">
            <input
              type={showPwd ? "text" : "password"}
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              placeholder="••••••••"
              required
              autoComplete="current-password"
              className={cn(
                "w-full px-4 py-3 pr-12 rounded-xl border text-sm",
                "bg-[var(--surface)] text-[var(--on-surface)]",
                "border-[var(--outline)] placeholder:text-[var(--on-surface-faint)]",
                "focus:outline-none focus:ring-2 focus:ring-brand/30 focus:border-brand",
                "transition-all duration-200"
              )}
            />
            <button
              type="button"
              onClick={() => setShowPwd(!showPwd)}
              className="absolute right-3 top-1/2 -translate-y-1/2 text-[var(--on-surface-faint)] hover:text-[var(--on-surface-muted)] transition-colors p-1"
            >
              {showPwd ? <EyeOff size={18} /> : <Eye size={18} />}
            </button>
          </div>
        </div>

        {/* Submit */}
        <button
          type="submit"
          disabled={loading || !email || !password}
          className={cn(
            "w-full flex items-center justify-center gap-2.5 py-3.5 px-6 rounded-xl",
            "bg-brand hover:bg-brand-mid text-white font-semibold text-sm",
            "shadow-brand hover:shadow-brand-lg",
            "transition-all duration-200",
            "disabled:opacity-50 disabled:cursor-not-allowed disabled:shadow-none",
            "active:scale-[0.98]"
          )}
        >
          {loading ? (
            <span className="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin" />
          ) : (
            <LogIn size={16} />
          )}
          {loading ? "Connexion…" : "Se connecter"}
        </button>
      </form>

      {/* Divider */}
      <div className="relative my-6">
        <div className="absolute inset-0 flex items-center">
          <div className="w-full border-t border-[var(--outline)]" />
        </div>
        <div className="relative flex justify-center">
          <span className="px-3 text-xs text-[var(--on-surface-faint)] bg-[var(--surface)]">
            Pas encore de compte ?
          </span>
        </div>
      </div>

      <Link
        href="/signup"
        className={cn(
          "block w-full text-center py-3.5 px-6 rounded-xl border",
          "border-[var(--outline)] text-[var(--on-surface)] font-medium text-sm",
          "hover:bg-[var(--surface-container)] transition-colors duration-200"
        )}
      >
        Créer un compte gratuitement
      </Link>
    </div>
  )
}
