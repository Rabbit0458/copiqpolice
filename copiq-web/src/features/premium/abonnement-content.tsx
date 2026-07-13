"use client"

import { useState } from "react"
import type { User } from "@supabase/supabase-js"
import { Button } from "@/components/ui/button"
import { Badge } from "@/components/ui/badge"
import { Card } from "@/components/ui/card"
import {
  Crown, Check, Zap, ExternalLink, AlertCircle,
  Calendar, CreditCard, XCircle
} from "lucide-react"
import { cn, formatDate, PLAN_LABELS, PLAN_PRICES } from "@/lib/utils"
import toast from "react-hot-toast"

interface Sub {
  tier: string
  status: string
  current_period_end: string | null
  cancel_at_period_end: boolean
  stripe_customer_id: string | null
}

interface AbonnementContentProps {
  user: User
  sub: Sub | null
  success: boolean
  canceled: boolean
}

const PLANS = [
  {
    id: "week",
    popular: false,
    features: ["Accès complet illimité", "Cas pratiques illimités", "Sans publicité", "Annulable à tout moment"],
  },
  {
    id: "month",
    popular: true,
    features: ["Accès complet illimité", "Cas pratiques illimités", "Concours blancs", "Stats avancées", "Sans publicité", "1 semaine d'essai offerte"],
  },
  {
    id: "year",
    popular: false,
    features: ["Tout l'abonnement mensuel", "Économie de 20%", "Support prioritaire", "Accès anticipé nouveautés"],
  },
]

export function AbonnementContent({ user, sub, success, canceled }: AbonnementContentProps) {
  const [loadingPlan, setLoadingPlan] = useState<string | null>(null)
  const [loadingPortal, setLoadingPortal] = useState(false)

  const tier = sub?.tier ?? "free"
  const isPremium = tier === "premium" || tier === "premium_trial"
  const isActive = sub?.status === "active" || sub?.status === "trialing"

  async function handleSubscribe(plan: string) {
    setLoadingPlan(plan)
    try {
      const res = await fetch("/api/stripe/checkout", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ plan }),
      })
      const data = await res.json()
      if (data.url) {
        window.location.href = data.url
      } else {
        toast.error(data.error ?? "Erreur lors de la création du paiement")
      }
    } catch {
      toast.error("Erreur réseau")
    } finally {
      setLoadingPlan(null)
    }
  }

  async function handlePortal() {
    setLoadingPortal(true)
    try {
      const res = await fetch("/api/stripe/portal", { method: "POST" })
      const data = await res.json()
      if (data.url) window.location.href = data.url
      else toast.error(data.error ?? "Erreur portail Stripe")
    } catch {
      toast.error("Erreur réseau")
    } finally {
      setLoadingPortal(false)
    }
  }

  return (
    <div className="max-w-4xl space-y-8 animate-fade-in">
      {/* En-tête */}
      <div>
        <h1 className="text-2xl font-bold text-[var(--on-surface)] mb-1">Mon abonnement</h1>
        <p className="text-[var(--on-surface-muted)]">Gérez votre accès Premium COP&apos;IQ</p>
      </div>

      {/* Notification succès/annulation */}
      {success && (
        <div className="flex items-start gap-3 p-4 rounded-xl bg-success/10 border border-success/20 text-success">
          <Check size={18} className="shrink-0 mt-0.5" />
          <div>
            <div className="font-semibold">Abonnement activé avec succès !</div>
            <div className="text-sm opacity-80 mt-0.5">Vous avez maintenant accès à toutes les fonctionnalités Premium.</div>
          </div>
        </div>
      )}
      {canceled && (
        <div className="flex items-start gap-3 p-4 rounded-xl bg-warning/10 border border-warning/20 text-warning">
          <AlertCircle size={18} className="shrink-0 mt-0.5" />
          <div className="text-sm">Paiement annulé. Vous pouvez réessayer à tout moment.</div>
        </div>
      )}

      {/* Statut actuel */}
      <Card>
        <div className="flex items-start justify-between gap-4 flex-wrap">
          <div className="flex items-center gap-3">
            <div className={cn(
              "w-12 h-12 rounded-2xl flex items-center justify-center",
              isPremium && isActive ? "bg-brand/10" : "bg-[var(--surface-container)]"
            )}>
              <Crown size={22} className={isPremium && isActive ? "text-brand" : "text-[var(--on-surface-faint)]"} />
            </div>
            <div>
              <div className="font-semibold text-[var(--on-surface)]">
                {isPremium && isActive ? "Premium actif" : "Compte gratuit"}
              </div>
              <div className="text-sm text-[var(--on-surface-muted)]">
                {isPremium && isActive
                  ? sub?.cancel_at_period_end
                    ? `Se termine le ${sub.current_period_end ? formatDate(sub.current_period_end) : "—"}`
                    : `Renouvellement le ${sub?.current_period_end ? formatDate(sub.current_period_end) : "—"}`
                  : "Accès limité à 10 cas pratiques / semaine"
                }
              </div>
            </div>
          </div>

          <div className="flex items-center gap-2">
            <Badge variant={isPremium && isActive ? "premium" : "muted"}>
              {tier === "free" ? "Gratuit" : tier === "premium_trial" ? "Essai" : "Premium"}
            </Badge>
            {isPremium && sub?.stripe_customer_id && (
              <Button
                variant="secondary"
                size="sm"
                loading={loadingPortal}
                onClick={handlePortal}
              >
                <CreditCard size={14} />
                Gérer
                <ExternalLink size={12} />
              </Button>
            )}
          </div>
        </div>

        {isPremium && isActive && (
          <div className="mt-4 pt-4 border-t border-[var(--outline)] grid grid-cols-2 sm:grid-cols-4 gap-4">
            {[
              { icon: <Zap size={14} />, label: "Cas pratiques", value: "Illimité" },
              { icon: <Calendar size={14} />, label: "Statut", value: sub?.status === "trialing" ? "Essai" : "Actif" },
              { icon: <CreditCard size={14} />, label: "Renouvellement", value: sub?.cancel_at_period_end ? "Non" : "Auto" },
              { icon: <Crown size={14} />, label: "Publicités", value: "Aucune" },
            ].map((item) => (
              <div key={item.label}>
                <div className="flex items-center gap-1.5 text-xs text-[var(--on-surface-faint)] mb-1">
                  {item.icon}
                  {item.label}
                </div>
                <div className="text-sm font-semibold text-[var(--on-surface)]">{item.value}</div>
              </div>
            ))}
          </div>
        )}

        {sub?.cancel_at_period_end && (
          <div className="mt-4 pt-4 border-t border-[var(--outline)] flex items-center gap-2 text-sm text-warning">
            <XCircle size={14} />
            Votre abonnement ne sera pas renouvelé. Accès Premium jusqu&apos;au {sub.current_period_end ? formatDate(sub.current_period_end) : "—"}.
          </div>
        )}
      </Card>

      {/* Plans (si pas premium) */}
      {!isPremium && (
        <div>
          <h2 className="text-lg font-semibold text-[var(--on-surface)] mb-4">Choisissez votre plan</h2>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            {PLANS.map((plan) => {
              const price = PLAN_PRICES[plan.id]
              const label = PLAN_LABELS[plan.id]
              return (
                <div
                  key={plan.id}
                  className={cn(
                    "rounded-2xl border p-5 flex flex-col relative",
                    plan.popular
                      ? "border-brand bg-brand/5"
                      : "border-[var(--outline)] bg-[var(--surface)]"
                  )}
                >
                  {plan.popular && (
                    <div className="absolute -top-3 left-1/2 -translate-x-1/2">
                      <Badge variant="default">Plus populaire</Badge>
                    </div>
                  )}

                  <div className="mb-4">
                    <div className="text-xs font-semibold text-[var(--on-surface-muted)] mb-1">{label}</div>
                    <div className="flex items-baseline gap-1">
                      <span className="text-2xl font-bold text-[var(--on-surface)]">{price.amount}</span>
                      <span className="text-sm text-[var(--on-surface-muted)]">{price.period}</span>
                    </div>
                  </div>

                  <ul className="space-y-2 mb-5 flex-1">
                    {plan.features.map((f) => (
                      <li key={f} className="flex items-start gap-2 text-sm text-[var(--on-surface-muted)]">
                        <Check size={13} className="text-success shrink-0 mt-0.5" />
                        {f}
                      </li>
                    ))}
                  </ul>

                  <Button
                    variant={plan.popular ? "premium" : "secondary"}
                    loading={loadingPlan === plan.id}
                    onClick={() => handleSubscribe(plan.id)}
                    className="w-full"
                  >
                    <Crown size={14} />
                    Choisir ce plan
                  </Button>
                </div>
              )
            })}
          </div>

          <p className="text-xs text-center text-[var(--on-surface-faint)] mt-4">
            Paiement sécurisé par Stripe · Annulation à tout moment · Sans engagement
          </p>
        </div>
      )}
    </div>
  )
}
