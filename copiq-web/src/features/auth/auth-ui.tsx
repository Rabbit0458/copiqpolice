"use client"

import type { CSSProperties, ReactNode } from "react"
import { Check, Loader2 } from "lucide-react"
import { cn } from "@/lib/utils"
import { INDEPENDENCE_NOTICE_SHORT } from "@/data/marketing"
import { BrandWordmark, Tricolore } from "@/components/home/brand"
import { SplitText } from "@/components/home/motion"

/**
 * Briques communes des pages de compte V5 (/login, /forgot-password) :
 * même coque que /signup — colonne de marque bleu nuit à gauche, formulaire
 * à droite — et mêmes champs, pour que tout le parcours se ressemble.
 */

export const d = (ms: number) => ({ "--d": `${ms}ms` }) as CSSProperties
export const labelClass = "text-[15px] font-semibold text-[var(--on-surface)]"

export function inputClass(invalid: boolean, valid = false) {
  return cn(
    "block h-[3.25rem] w-full rounded-2xl border bg-[var(--surface)] px-4 text-[16px] text-[var(--on-surface)] outline-none",
    "placeholder:text-[var(--on-surface-faint)]",
    "transition-[border-color,box-shadow] duration-300 ease-[cubic-bezier(0.22,1,0.36,1)]",
    "focus:border-[#1147D9] focus:shadow-[0_0_0_4px_rgba(17,71,217,0.14)]",
    invalid
      ? "border-[#DC2626] focus:border-[#DC2626] focus:shadow-[0_0_0_4px_rgba(220,38,38,0.14)]"
      : valid
        ? "border-[#16A34A]/60"
        : "border-[var(--outline)] hover:border-[var(--on-surface-faint)]",
  )
}

export function FieldError({ msg, id }: { msg: ReactNode; id?: string }) {
  if (!msg) return null
  return (
    <p id={id} role="alert" className="cq-quiz-in mt-2 text-[13.5px] text-[#DC2626] dark:text-[#F87171]">
      {msg}
    </p>
  )
}

export function Notice({ tone, children }: { tone: "error" | "info" | "success"; children: ReactNode }) {
  return (
    <div
      role={tone === "error" ? "alert" : "status"}
      className={cn(
        "cq-quiz-in rounded-2xl px-4 py-3.5 text-[14.5px] leading-relaxed",
        tone === "error" && "bg-[#DC2626]/8 text-[#B91C1C] dark:text-[#F87171]",
        tone === "info" && "bg-[#1147D9]/8 text-[#0B3BB8] dark:text-[#9CC1FF]",
        tone === "success" && "bg-[#16A34A]/10 text-[#15803D] dark:text-[#34D399]",
      )}
    >
      {children}
    </div>
  )
}

export function PrimaryButton({
  children,
  busy,
  tone = "navy",
  disabled,
}: {
  children: ReactNode
  busy?: boolean
  tone?: "navy" | "red"
  disabled?: boolean
}) {
  return (
    <button
      type="submit"
      disabled={busy || disabled}
      className={cn(
        "cq-tap cq-btn cq-btn-lift group inline-flex h-[3.4rem] w-full items-center justify-center gap-2 rounded-2xl px-6 text-[16px] font-semibold text-white disabled:cursor-wait disabled:opacity-80",
        tone === "red"
          ? "cq-btn-shine bg-[#E0162B] shadow-[0_14px_40px_-16px_rgba(224,22,43,0.9)] hover:bg-[#C8102A]"
          : "bg-[#000B36] shadow-[0_14px_36px_-18px_rgba(0,11,54,0.9)] hover:bg-[#0A1A55] dark:bg-[#1147D9] dark:hover:bg-[#1A55F0]",
      )}
    >
      {busy && <Loader2 className="h-4 w-4 animate-spin" aria-hidden="true" />}
      {children}
    </button>
  )
}

/** Pastille verte qui se dessine (succès). */
export function SuccessMark({ className }: { className?: string }) {
  return (
    <div className={cn("cq-success-pop relative grid h-20 w-20 place-items-center", className)} aria-hidden="true">
      <span className="cq-success-glow absolute inset-[-24px] rounded-full" />
      <svg width="80" height="80" viewBox="0 0 96 96" fill="none" className="relative">
        <circle cx="48" cy="48" r="44" fill="#16A34A" className="cq-success-disc" />
        <path d="M29 49.5l12.5 12.5L67 36" stroke="#fff" strokeWidth="6" strokeLinecap="round" strokeLinejoin="round" className="cq-success-check" />
      </svg>
    </div>
  )
}

/* ─────────────────────────────────────────────────────────────────────────────
   Coque : colonne de marque + zone formulaire
   ───────────────────────────────────────────────────────────────────────── */

export type ShellPoint = { title: string; text: string; icon?: ReactNode }

export function AuthShell({
  title,
  text,
  points,
  quote = "« Ce n’est pas le jour de l’épreuve qui révèle notre valeur, mais tous les jours qui nous y ont préparés. »",
  children,
}: {
  title: string
  text: string
  points?: ShellPoint[]
  quote?: string
  children: ReactNode
}) {
  return (
    <div className="flex min-h-[100svh] flex-col bg-[var(--surface)] lg:flex-row">
      <aside className="cq-home-hero relative isolate overflow-hidden text-white lg:sticky lg:top-0 lg:flex lg:h-[100svh] lg:w-[44%] lg:max-w-[40rem] lg:flex-col">
        <div className="flex items-center justify-between px-4 pb-5 pt-5 sm:px-8 lg:px-12 lg:pt-10">
          {/* Liens classiques : retour à l'accueil par rechargement complet. */}
          {/* eslint-disable-next-line @next/next/no-html-link-for-pages */}
          <a href="/" aria-label="COP'IQ, accueil" className="cq-enter-header">
            <BrandWordmark size={42} tone="light" />
          </a>
          {/* eslint-disable-next-line @next/next/no-html-link-for-pages */}
          <a href="/" className="cq-enter-header rounded-xl px-2 py-2 text-[14px] font-medium text-white/70 transition-colors hover:text-white lg:hidden">
            Retour
          </a>
        </div>

        <div className="px-4 pb-6 sm:px-8 lg:flex lg:flex-1 lg:flex-col lg:justify-center lg:px-12 lg:pb-0">
          <Tricolore className="cq-enter-draw mb-5 h-1 w-14 lg:mb-8" />
          <SplitText
            as="h2"
            mode="load"
            delay={140}
            stagger={50}
            text={title}
            className="block max-w-[28rem] text-[clamp(1.5rem,3.4vw,2.9rem)] font-bold leading-[1.04] tracking-[-0.04em] [text-wrap:balance]"
          />
          <p className="cq-enter mt-4 max-w-[28rem] text-[16px] leading-relaxed text-white/70 max-lg:hidden" style={d(320)}>
            {text}
          </p>
          {points && (
            <ul className="mt-9 hidden max-w-[28rem] gap-4 lg:grid [@media(max-height:760px)]:gap-2.5">
              {points.map((p, i) => (
                <li key={p.title} className="cq-enter flex items-start gap-3.5" style={d(420 + i * 80)}>
                  <span className="grid h-9 w-9 shrink-0 place-items-center rounded-xl bg-white/[0.08] text-white ring-1 ring-white/10" aria-hidden="true">
                    {p.icon ?? <Check className="h-4 w-4" strokeWidth={2.5} />}
                  </span>
                  <span>
                    <span className="block text-[15.5px] font-semibold text-white">{p.title}</span>
                    <span className="block text-[14px] leading-snug text-white/60">{p.text}</span>
                  </span>
                </li>
              ))}
            </ul>
          )}
        </div>

        <div className="hidden px-12 pb-10 pt-6 lg:block">
          <p className="cq-enter-fade max-w-[30rem] text-[15px] italic leading-relaxed text-white/60 [@media(max-height:820px)]:hidden" style={d(900)}>
            {quote}
          </p>
          <p className="mt-6 text-[12.5px] text-white/45">{INDEPENDENCE_NOTICE_SHORT}</p>
        </div>
      </aside>

      <main className="flex flex-1 items-start justify-center px-4 py-9 sm:px-8 lg:items-center lg:py-14">
        <div className="w-full max-w-[29rem]">
          {children}
          <p className="mt-12 text-center text-[12.5px] leading-relaxed text-[var(--on-surface-faint)] lg:hidden">
            {INDEPENDENCE_NOTICE_SHORT}
          </p>
        </div>
      </main>
    </div>
  )
}

/* ─────────────────────────────────────────────────────────────────────────────
   Liens envoyés par e-mail : mêmes pages que l'application
   ───────────────────────────────────────────────────────────────────────── */

function onCopiq(hostname: string) {
  return hostname === "copiq.fr" || hostname.endsWith(".copiq.fr")
}

/** Confirmation d'inscription → /confirm (page officielle, tous appareils). */
export function confirmRedirectUrl() {
  const { origin, hostname } = window.location
  return onCopiq(hostname) ? "https://copiq.fr/confirm/" : `${origin}/confirm/`
}

/** Réinitialisation → /reset-password/ (page officielle, la même que l'app). */
export function resetRedirectUrl() {
  const { origin, hostname } = window.location
  return onCopiq(hostname) ? "https://copiq.fr/reset-password/" : `${origin}/reset-password/`
}

export const EMAIL_RE = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
