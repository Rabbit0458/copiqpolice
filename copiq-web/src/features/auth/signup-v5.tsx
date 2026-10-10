"use client"

import Link from "next/link"
import { useEffect, useMemo, useRef, useState, type CSSProperties, type FormEvent, type ReactNode } from "react"
import { useRouter, useSearchParams } from "next/navigation"
import {
  ArrowLeft,
  ArrowRight,
  AtSign,
  Cake,
  Check,
  Eye,
  EyeOff,
  Loader2,
  Mail,
  MapPin,
  Pencil,
  Phone,
  RotateCcw,
  Sparkles,
  X,
} from "lucide-react"
import { createClient } from "@/lib/supabase/client"
import { cn } from "@/lib/utils"
import { PATHWAY_LIST, PATHWAYS, isPathwayId, type PathwayDefinition, type PathwayId } from "@/config/pathways"
import { INDEPENDENCE_NOTICE_SHORT } from "@/data/marketing"
import { BrandWordmark, Tricolore } from "@/components/home/brand"
import { SplitText } from "@/components/home/motion"
import { CityField } from "@/features/auth/city-field"
import {
  AVATAR_COUNT,
  NO_USER_ID,
  avatarSrc,
  birthdayBounds,
  birthdayError,
  cleanText,
  digitsOnly,
  formatBirthday,
  formatPhone,
  isValidFrMobile,
  nameError,
  suggestUsername,
  usernameFormatError,
} from "@/features/auth/profile-rules"

/**
 * Inscription COP'IQ — version 5.1 (octobre 2026), en quatre étapes.
 *
 *   1. Parcours     → user_track / user_mode
 *   2. Compte       → e-mail (vérifié par `is_email_available`) + mot de passe
 *   3. Profil       → avatar 1–20, prénom, nom, pseudo (vérifié par
 *                     `is_username_taken`), mobile 06/07, ville, naissance
 *   4. Validation   → récapitulatif + CGU (`cgv_*`, même version que l'app)
 *
 * Tout part dans les métadonnées de `auth.signUp`. Le trigger
 * `handle_new_user_minimal` les revalide et remplit `user_profiles` : le compte
 * s'ouvre dans l'application directement sur la bonne home, profil complet,
 * sans la fenêtre « Bienvenue » ni les écrans de choix de mode et de grade.
 * Règles identiques à l'app : voir `profile-rules.ts`.
 */

const CGV_VERSION = "2026-08"
const EMAIL_RE = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
const RULES = [
  { key: "len", label: "8 caractères", test: (p: string) => p.length >= 8 },
  { key: "up", label: "Une majuscule", test: (p: string) => /[A-Z]/.test(p) },
  { key: "low", label: "Une minuscule", test: (p: string) => /[a-z]/.test(p) },
  { key: "num", label: "Un chiffre", test: (p: string) => /[0-9]/.test(p) },
  { key: "spe", label: "Un caractère spécial", test: (p: string) => /[!@#$%^&*(),.?":{}|<>_\-[\]\\/+=~`;]/.test(p) },
] as const

const STEPS = [
  { key: "parcours", label: "Parcours" },
  { key: "compte", label: "Compte" },
  { key: "profil", label: "Profil" },
  { key: "validation", label: "Validation" },
] as const
type Step = 0 | 1 | 2 | 3

type Remote = "available" | "taken" | "error"
type CheckState = "idle" | "checking" | Remote | "invalid"

const d = (ms: number) => ({ "--d": `${ms}ms` }) as CSSProperties
const i = (n: number) => ({ "--i": n }) as CSSProperties

function pathwayFromParam(value: string | null): PathwayId | null {
  if (!value) return null
  const v = value.trim().toLowerCase()
  if (isPathwayId(v)) return v
  const bySlug = PATHWAY_LIST.find((p) => p.slug === v)
  return bySlug?.id ?? null
}

const STAGE_LABEL = { exam: "concours", school: "école" } as const
const GRADE_LABEL = { pa: "Policier adjoint", gpx: "Gardien de la paix" } as const
const shortName = (p: PathwayDefinition) => `${GRADE_LABEL[p.track]}, ${STAGE_LABEL[p.mode]}`

/**
 * Lien de l'e-mail de confirmation → page officielle /confirm (la même que
 * l'application). Elle affiche « Email confirmé » quel que soit l'appareil
 * qui ouvre le lien. L'ancien retour /auth/callback échouait sur un autre
 * appareil (téléphone) et renvoyait vers la page de connexion.
 */
function confirmRedirectUrl() {
  const { origin, hostname } = window.location
  return hostname === "copiq.fr" || hostname.endsWith(".copiq.fr") ? "https://copiq.fr/confirm/" : `${origin}/confirm/`
}

/* ─────────────────────────────────────────────────────────────────────────── */

export function SignupV5() {
  const router = useRouter()
  const params = useSearchParams()
  const supabase = useMemo(() => createClient(), [])

  const initialPathway = pathwayFromParam(params.get("parcours"))
  const planParam = params.get("plan")
  const planIntent = planParam === "month" || planParam === "year" ? planParam : null

  /* ── Navigation entre étapes ─────────────────────────────────────────── */
  const [step, setStep] = useState<Step>(initialPathway ? 1 : 0)
  const [dir, setDir] = useState<"next" | "prev">("next")
  const [reached, setReached] = useState<Step>(initialPathway ? 1 : 0)
  const [tried, setTried] = useState<Record<Step, boolean>>({ 0: false, 1: false, 2: false, 3: false })
  const headingRef = useRef<HTMLHeadingElement | null>(null)
  const firstRender = useRef(true)

  /* ── Données ─────────────────────────────────────────────────────────── */
  const [pathwayId, setPathwayId] = useState<PathwayId | null>(initialPathway)
  const [email, setEmail] = useState("")
  const [remoteEmail, setRemoteEmail] = useState<{ v: string; state: Remote } | null>(null)
  const [password, setPassword] = useState("")
  const [confirm, setConfirm] = useState("")
  const [showPwd, setShowPwd] = useState(false)

  const [avatar, setAvatar] = useState(1)
  const [firstName, setFirstName] = useState("")
  const [lastName, setLastName] = useState("")
  const [usernameInput, setUsernameInput] = useState<string | null>(null)
  const [remoteUser, setRemoteUser] = useState<{ v: string; state: Remote } | null>(null)
  const [phone, setPhone] = useState("")
  const [city, setCity] = useState("")
  const [birthday, setBirthday] = useState("")

  const [accepted, setAccepted] = useState(false)
  const [loading, setLoading] = useState(false)
  const [formError, setFormError] = useState<string | null>(null)
  const [done, setDone] = useState(false)

  const pathway = pathwayId ? PATHWAYS[pathwayId] : null

  /* ── E-mail : disponibilité (même RPC que l'app) ─────────────────────── */
  const normalizedEmail = email.trim().toLowerCase()
  const emailSyntaxOk = EMAIL_RE.test(normalizedEmail)
  const emailState: CheckState = !normalizedEmail
    ? "idle"
    : !emailSyntaxOk
      ? "invalid"
      : remoteEmail?.v === normalizedEmail
        ? remoteEmail.state
        : "checking"

  useEffect(() => {
    if (!emailSyntaxOk) return
    let cancelled = false
    const t = window.setTimeout(async () => {
      const { data, error } = await supabase.rpc("is_email_available" as never, { p_email: normalizedEmail } as never)
      if (!cancelled) setRemoteEmail({ v: normalizedEmail, state: error ? "error" : data === true ? "available" : "taken" })
    }, 450)
    return () => {
      cancelled = true
      window.clearTimeout(t)
    }
  }, [normalizedEmail, emailSyntaxOk, supabase])

  /* ── Pseudo : proposé à partir du nom tant qu'on ne l'a pas modifié ──── */
  const username = (usernameInput ?? suggestUsername(firstName, lastName)).trim()
  const usernameFmt = usernameFormatError(username)
  const usernameState: CheckState = !username
    ? "idle"
    : usernameFmt
      ? "invalid"
      : remoteUser?.v === username.toLowerCase()
        ? remoteUser.state
        : "checking"

  useEffect(() => {
    if (!username || usernameFmt) return
    const key = username.toLowerCase()
    let cancelled = false
    const t = window.setTimeout(async () => {
      const { data, error } = await supabase.rpc(
        "is_username_taken" as never,
        { p_username: username, p_except_user_id: NO_USER_ID } as never,
      )
      if (!cancelled) setRemoteUser({ v: key, state: error ? "error" : data === true ? "taken" : "available" })
    }, 380)
    return () => {
      cancelled = true
      window.clearTimeout(t)
    }
  }, [username, usernameFmt, supabase])

  /* ── Validation par étape ────────────────────────────────────────────── */
  const rulesOk = RULES.map((r) => r.test(password))
  const pwdOk = rulesOk.every(Boolean)
  const confirmOk = confirm.length > 0 && confirm === password

  const errors = {
    pathway: !pathwayId ? "Choisis ton parcours pour continuer." : null,
    email:
      emailState === "idle" ? "Renseigne ton adresse e-mail."
      : emailState === "invalid" ? "Cette adresse e-mail n’est pas valide."
      : emailState === "taken" ? "Un compte existe déjà avec cette adresse."
      : null,
    password: !pwdOk ? "Le mot de passe ne respecte pas encore toutes les règles." : null,
    confirm: !confirmOk ? "Les deux mots de passe doivent être identiques." : null,
    firstName: nameError(firstName, "prénom"),
    lastName: nameError(lastName, "nom"),
    username: usernameFmt ?? (usernameState === "taken" ? "Ce pseudo est déjà pris." : null),
    phone: !digitsOnly(phone) ? "Renseigne ton numéro de mobile." : !isValidFrMobile(phone) ? "Numéro de mobile français attendu : 06 ou 07, 10 chiffres." : null,
    city: !cleanText(city) ? "Renseigne ta ville." : null,
    birthday: birthdayError(birthday),
    accepted: !accepted ? "Tu dois accepter les conditions pour créer ton compte." : null,
  }
  const STEP_FIELDS: Record<Step, (keyof typeof errors)[]> = {
    0: ["pathway"],
    1: ["email", "password", "confirm"],
    2: ["firstName", "lastName", "username", "phone", "city", "birthday"],
    3: ["accepted"],
  }
  const stepValid = (s: Step) => STEP_FIELDS[s].every((k) => !errors[k])
  const pendingCheck = (s: Step) =>
    (s === 1 && emailState === "checking") || (s === 2 && usernameState === "checking")
  const show = (k: keyof typeof errors, s: Step) => (tried[s] ? errors[k] : null)

  /* ── Déplacements ────────────────────────────────────────────────────── */
  useEffect(() => {
    if (firstRender.current) {
      firstRender.current = false
      return
    }
    headingRef.current?.focus({ preventScroll: true })
    const top = document.getElementById("inscription")?.getBoundingClientRect().top ?? 0
    if (top < 0) window.scrollTo({ top: window.scrollY + top - 16, behavior: "smooth" })
  }, [step, done])

  function goTo(target: Step) {
    if (target === step) return
    setDir(target > step ? "next" : "prev")
    setStep(target)
    setReached((r) => (target > r ? target : r))
    setFormError(null)
  }

  function focusFirstInvalid() {
    window.requestAnimationFrame(() => {
      document.querySelector<HTMLElement>("#inscription [aria-invalid='true']")?.focus()
    })
  }

  function next(e?: FormEvent) {
    e?.preventDefault()
    setTried((t) => ({ ...t, [step]: true }))
    if (!stepValid(step) || pendingCheck(step)) {
      focusFirstInvalid()
      return
    }
    if (step < 3) goTo((step + 1) as Step)
  }

  /* ── Création du compte ──────────────────────────────────────────────── */
  async function submit(e: FormEvent) {
    e.preventDefault()
    setTried((t) => ({ ...t, 3: true }))
    setFormError(null)
    // Une étape précédente invalide (retour en arrière puis modification) ?
    for (const s of [0, 1, 2] as Step[]) {
      if (!stepValid(s)) {
        setTried((t) => ({ ...t, [s]: true }))
        goTo(s)
        focusFirstInvalid()
        return
      }
    }
    if (!stepValid(3)) {
      focusFirstInvalid()
      return
    }
    if (!pathway) return
    setLoading(true)
    try {
      // Revérifications juste avant la création, comme dans l'app.
      const [{ data: available, error: emailErr }, { data: taken, error: userErr }] = await Promise.all([
        supabase.rpc("is_email_available" as never, { p_email: normalizedEmail } as never),
        supabase.rpc("is_username_taken" as never, { p_username: username, p_except_user_id: NO_USER_ID } as never),
      ])
      if (!emailErr && available !== true) {
        setRemoteEmail({ v: normalizedEmail, state: "taken" })
        setTried((t) => ({ ...t, 1: true }))
        setLoading(false)
        goTo(1)
        return
      }
      if (!userErr && taken === true) {
        setRemoteUser({ v: username.toLowerCase(), state: "taken" })
        setTried((t) => ({ ...t, 2: true }))
        setLoading(false)
        goTo(2)
        return
      }

      const { data, error } = await supabase.auth.signUp({
        email: normalizedEmail,
        password,
        options: {
          emailRedirectTo: confirmRedirectUrl(),
          data: {
            app: "COPIQ",
            created_from: "web",
            platform: "web",
            cgv_accepted: true,
            cgv_version: CGV_VERSION,
            cgv_accepted_client_at: new Date().toISOString(),
            parcours: pathway.id,
            user_track: pathway.track,
            user_mode: pathway.mode,
            first_name: cleanText(firstName),
            last_name: cleanText(lastName),
            username,
            phone: digitsOnly(phone),
            city: cleanText(city),
            avatar_index: avatar,
            ...(birthday ? { birthday } : {}),
            ...(planIntent ? { plan_intent: planIntent } : {}),
          },
        },
      })

      if (error) {
        const msg = error.message.toLowerCase()
        if (msg.includes("already") || msg.includes("exists")) {
          setRemoteEmail({ v: normalizedEmail, state: "taken" })
          goTo(1)
        } else if (msg.includes("rate") || msg.includes("too many")) {
          setFormError("Trop de tentatives. Patiente une minute puis réessaie.")
        } else {
          setFormError("La création du compte n’a pas abouti. Vérifie ta connexion puis réessaie.")
        }
        setLoading(false)
        return
      }

      // Confirmation d'e-mail désactivée : la session est immédiate.
      if (data.session) {
        router.replace("/dashboard")
        return
      }
      setDone(true)
    } catch {
      setFormError("La création du compte n’a pas abouti. Vérifie ta connexion puis réessaie.")
    }
    setLoading(false)
  }

  const preview = step >= 2 || done
    ? {
        avatar,
        name: [cleanText(firstName), cleanText(lastName)].filter(Boolean).join(" "),
        username: usernameFmt ? "" : username,
        city: cleanText(city),
      }
    : null

  /* ── Rendu ───────────────────────────────────────────────────────────── */
  return (
    <div className="flex min-h-[100svh] flex-col bg-[var(--surface)] lg:flex-row">
      <BrandPanel pathway={pathway} step={step} preview={preview} />

      <main className="flex flex-1 items-start justify-center px-4 py-8 sm:px-8 lg:items-center lg:py-14">
        <div id="inscription" className="w-full max-w-[31rem] scroll-mt-4">
          {done ? (
            <SentState
              email={normalizedEmail}
              password={password}
              firstName={firstName}
              pathway={pathway}
              onEdit={() => {
                setDone(false)
                goTo(1)
              }}
            />
          ) : (
            <>
              <Stepper step={step} reached={reached} onGo={goTo} />

              {planIntent && step === 0 && (
                <p className="cq-enter mt-6 rounded-2xl bg-[var(--surface-container)] px-4 py-3 text-[14px] leading-relaxed text-[var(--on-surface)]" style={d(160)}>
                  Formule choisie : Premium {planIntent === "month" ? "mensuel (8,99 €)" : "annuel (79,99 €)"}. Tu pourras l’activer juste après avoir confirmé ton e-mail.
                </p>
              )}

              <div key={step} className="cq-step mt-7" data-dir={dir}>
                {/* ═══════════ 1. PARCOURS ═══════════ */}
                {step === 0 && (
                  <form noValidate onSubmit={next} className="grid gap-6">
                    <StepHeading ref={headingRef} n={0} title="Quel est ton objectif ?" sub="Ton espace, tes cours et tes entraînements s’adaptent à ce choix. Tu pourras le changer plus tard." />
                    <fieldset style={i(1)}>
                      <legend className="sr-only">Ton parcours</legend>
                      <div role="radiogroup" aria-invalid={show("pathway", 0) ? true : undefined} className="grid grid-cols-1 gap-2.5 sm:grid-cols-2">
                        {PATHWAY_LIST.map((p) => {
                          const selected = p.id === pathwayId
                          return (
                            <label
                              key={p.id}
                              className={cn(
                                "cq-btn relative flex cursor-pointer flex-col gap-1.5 rounded-2xl border p-4 text-left",
                                selected ? "border-transparent" : "border-[var(--outline)] hover:border-[var(--on-surface-faint)]",
                              )}
                              style={selected ? { boxShadow: `0 0 0 2px ${p.color}, 0 18px 40px -26px ${p.color}` } : undefined}
                            >
                              <input
                                type="radio"
                                name="parcours"
                                value={p.id}
                                checked={selected}
                                onChange={() => setPathwayId(p.id)}
                                className="peer sr-only"
                              />
                              <span className="flex items-center justify-between gap-2">
                                <span className="rounded-full px-2.5 py-0.5 text-[11.5px] font-semibold uppercase tracking-[0.08em]" style={{ color: p.color, background: `${p.color}14` }}>
                                  {p.mode === "exam" ? "Concours" : "École"}
                                </span>
                                <span
                                  aria-hidden="true"
                                  className={cn(
                                    "grid h-5 w-5 place-items-center rounded-full border transition-colors duration-300",
                                    selected ? "border-transparent text-white" : "border-[var(--outline)] text-transparent",
                                  )}
                                  style={selected ? { background: p.color } : undefined}
                                >
                                  <Check className="h-3 w-3" strokeWidth={3} />
                                </span>
                              </span>
                              <span className="mt-1 text-[16px] font-semibold leading-snug text-[var(--on-surface)]">{GRADE_LABEL[p.track]}</span>
                              <span className="text-[13.5px] leading-snug text-[var(--on-surface-muted)]">
                                {p.mode === "exam" ? "Je prépare le concours" : "Je suis en école de police"}
                              </span>
                              <span className="pointer-events-none absolute inset-0 rounded-2xl peer-focus-visible:outline peer-focus-visible:outline-2 peer-focus-visible:outline-offset-2 peer-focus-visible:outline-[#4D82FF]" />
                            </label>
                          )
                        })}
                      </div>
                      <FieldError msg={show("pathway", 0)} />
                    </fieldset>
                    <StepActions n={2} primary="Continuer" />
                  </form>
                )}

                {/* ═══════════ 2. COMPTE ═══════════ */}
                {step === 1 && (
                  <form noValidate onSubmit={next} className="grid gap-6">
                    <StepHeading ref={headingRef} n={0} title="Tes identifiants" sub="Ils serviront à te connecter sur copiq.fr et dans l’application." />

                    <div style={i(1)}>
                      <label htmlFor="email" className={labelClass}>Adresse e-mail</label>
                      <div className="relative mt-2">
                        <input
                          id="email"
                          type="email"
                          inputMode="email"
                          autoComplete="email"
                          autoCapitalize="none"
                          spellCheck={false}
                          value={email}
                          onChange={(e) => setEmail(e.target.value)}
                          placeholder="prenom.nom@exemple.fr"
                          aria-invalid={show("email", 1) || emailState === "taken" ? true : undefined}
                          aria-describedby="email-aide"
                          className={cn(inputClass(Boolean(show("email", 1) || emailState === "taken"), emailState === "available"), "pr-11")}
                        />
                        <StatusIcon state={emailState} />
                      </div>
                      <p id="email-aide" aria-live="polite" className="mt-2 min-h-[1.25rem] text-[13.5px]">
                        {emailState === "taken" ? (
                          <span className="text-[#DC2626] dark:text-[#F87171]">
                            Un compte existe déjà avec cette adresse.{" "}
                            <Link href="/login" className="font-semibold underline underline-offset-2">Se connecter</Link>
                            {" "}ou{" "}
                            <Link href="/forgot-password" className="font-semibold underline underline-offset-2">réinitialiser le mot de passe</Link>
                          </span>
                        ) : show("email", 1) ? (
                          <span className="text-[#DC2626] dark:text-[#F87171]">{errors.email}</span>
                        ) : emailState === "available" ? (
                          <span className="text-[#16A34A] dark:text-[#34D399]">Adresse disponible.</span>
                        ) : (
                          <span className="text-[var(--on-surface-faint)]">Tu recevras un lien pour activer ton compte.</span>
                        )}
                      </p>
                    </div>

                    <div style={i(2)}>
                      <label htmlFor="password" className={labelClass}>Mot de passe</label>
                      <div className="relative mt-2">
                        <input
                          id="password"
                          type={showPwd ? "text" : "password"}
                          autoComplete="new-password"
                          value={password}
                          onChange={(e) => setPassword(e.target.value)}
                          aria-invalid={show("password", 1) ? true : undefined}
                          aria-describedby="regles-mdp"
                          className={cn(inputClass(Boolean(show("password", 1)), pwdOk), "pr-12")}
                        />
                        <button
                          type="button"
                          onClick={() => setShowPwd((v) => !v)}
                          aria-label={showPwd ? "Masquer le mot de passe" : "Afficher le mot de passe"}
                          className="cq-tap absolute right-1 top-1/2 grid -translate-y-1/2 place-items-center rounded-xl text-[var(--on-surface-faint)] transition-colors hover:text-[var(--on-surface)]"
                        >
                          {showPwd ? <EyeOff className="h-[18px] w-[18px]" /> : <Eye className="h-[18px] w-[18px]" />}
                        </button>
                      </div>
                      <div className="mt-3 flex gap-1" aria-hidden="true">
                        {RULES.map((r, idx) => (
                          <span
                            key={r.key}
                            className="h-1 flex-1 rounded-full transition-[background-color] duration-500 ease-[cubic-bezier(0.22,1,0.36,1)]"
                            style={{ background: idx < rulesOk.filter(Boolean).length ? (pwdOk ? "#16A34A" : "#1147D9") : "var(--outline)" }}
                          />
                        ))}
                      </div>
                      <ul id="regles-mdp" className="mt-3 flex flex-wrap gap-1.5">
                        {RULES.map((r, idx) => (
                          <li
                            key={r.key}
                            className={cn(
                              "inline-flex items-center gap-1.5 rounded-full px-2.5 py-1 text-[12.5px] font-medium transition-colors duration-300",
                              rulesOk[idx]
                                ? "bg-[#16A34A]/10 text-[#15803D] dark:text-[#34D399]"
                                : tried[1]
                                  ? "bg-[#DC2626]/8 text-[#DC2626] dark:text-[#F87171]"
                                  : "bg-[var(--surface-container)] text-[var(--on-surface-muted)]",
                            )}
                          >
                            {rulesOk[idx] ? <Check className="h-3 w-3" strokeWidth={3} aria-hidden="true" /> : <span className="h-1 w-1 rounded-full bg-current" aria-hidden="true" />}
                            {r.label}
                            <span className="sr-only">{rulesOk[idx] ? " : respecté" : " : manquant"}</span>
                          </li>
                        ))}
                      </ul>
                    </div>

                    <div style={i(3)}>
                      <label htmlFor="confirm" className={labelClass}>Confirme le mot de passe</label>
                      <input
                        id="confirm"
                        type={showPwd ? "text" : "password"}
                        autoComplete="new-password"
                        value={confirm}
                        onChange={(e) => setConfirm(e.target.value)}
                        aria-invalid={show("confirm", 1) ? true : undefined}
                        className={cn(inputClass(Boolean(show("confirm", 1)), confirmOk), "mt-2")}
                      />
                      <FieldError msg={show("confirm", 1) || (confirm.length > 0 && !password.startsWith(confirm) ? errors.confirm : null)} />
                    </div>

                    <StepActions n={4} primary="Continuer" onBack={() => goTo(0)} busy={tried[1] && emailState === "checking"} />
                  </form>
                )}

                {/* ═══════════ 3. PROFIL ═══════════ */}
                {step === 2 && (
                  <form noValidate onSubmit={next} className="grid gap-6">
                    <StepHeading
                      ref={headingRef}
                      n={0}
                      title="Ton profil"
                      sub="Ce sont les informations de ton profil dans l’application : tu n’auras rien à ressaisir en te connectant."
                    />

                    <AvatarPicker value={avatar} onChange={setAvatar} style={i(1)} />

                    <div className="grid gap-4 sm:grid-cols-2" style={i(2)}>
                      <div>
                        <label htmlFor="first_name" className={labelClass}>Prénom</label>
                        <input
                          id="first_name"
                          autoComplete="given-name"
                          autoCapitalize="words"
                          maxLength={60}
                          value={firstName}
                          onChange={(e) => setFirstName(e.target.value)}
                          aria-invalid={show("firstName", 2) ? true : undefined}
                          className={cn(inputClass(Boolean(show("firstName", 2)), !errors.firstName), "mt-2")}
                        />
                        <FieldError msg={show("firstName", 2)} />
                      </div>
                      <div>
                        <label htmlFor="last_name" className={labelClass}>Nom</label>
                        <input
                          id="last_name"
                          autoComplete="family-name"
                          autoCapitalize="words"
                          maxLength={60}
                          value={lastName}
                          onChange={(e) => setLastName(e.target.value)}
                          aria-invalid={show("lastName", 2) ? true : undefined}
                          className={cn(inputClass(Boolean(show("lastName", 2)), !errors.lastName), "mt-2")}
                        />
                        <FieldError msg={show("lastName", 2)} />
                      </div>
                    </div>

                    <div style={i(3)}>
                      <label htmlFor="username" className={labelClass}>Pseudo</label>
                      <div className="relative mt-2">
                        <span className="pointer-events-none absolute left-4 top-1/2 -translate-y-1/2 text-[var(--on-surface-faint)]" aria-hidden="true">
                          <AtSign className="h-4 w-4" />
                        </span>
                        <input
                          id="username"
                          autoComplete="username"
                          autoCapitalize="none"
                          spellCheck={false}
                          maxLength={20}
                          value={usernameInput ?? suggestUsername(firstName, lastName)}
                          onChange={(e) => setUsernameInput(e.target.value.replace(/[^A-Za-z0-9_]/g, ""))}
                          aria-invalid={(show("username", 2) || usernameState === "taken") ? true : undefined}
                          aria-describedby="username-aide"
                          className={cn(inputClass(Boolean(show("username", 2) || usernameState === "taken"), usernameState === "available"), "pl-10 pr-11")}
                        />
                        <StatusIcon state={usernameState} />
                      </div>
                      <div id="username-aide" aria-live="polite" className="mt-2 min-h-[1.25rem] text-[13.5px]">
                        {usernameState === "taken" ? (
                          <UsernameTaken base={username} onPick={(v) => setUsernameInput(v)} />
                        ) : show("username", 2) ? (
                          <span className="text-[#DC2626] dark:text-[#F87171]">{errors.username}</span>
                        ) : usernameState === "available" ? (
                          <span className="text-[#16A34A] dark:text-[#34D399]">Pseudo disponible. C’est ton nom dans la communauté.</span>
                        ) : (
                          <span className="text-[var(--on-surface-faint)]">3 à 20 caractères : lettres, chiffres, tiret bas.</span>
                        )}
                      </div>
                    </div>

                    <div className="grid gap-4 sm:grid-cols-2" style={i(4)}>
                      <div>
                        <label htmlFor="phone" className={labelClass}>Mobile</label>
                        <div className="relative mt-2">
                          <span className="pointer-events-none absolute left-4 top-1/2 -translate-y-1/2 text-[var(--on-surface-faint)]" aria-hidden="true">
                            <Phone className="h-4 w-4" />
                          </span>
                          <input
                            id="phone"
                            type="tel"
                            inputMode="numeric"
                            autoComplete="tel-national"
                            placeholder="06 12 34 56 78"
                            value={phone}
                            onChange={(e) => setPhone(formatPhone(e.target.value))}
                            aria-invalid={show("phone", 2) ? true : undefined}
                            className={cn(inputClass(Boolean(show("phone", 2)), isValidFrMobile(phone)), "pl-11 tabular-nums")}
                          />
                        </div>
                        <FieldError msg={show("phone", 2)} />
                      </div>
                      <div>
                        <label htmlFor="city" className={labelClass}>Ville</label>
                        <div className="mt-2">
                          <CityField
                            id="city"
                            value={city}
                            onChange={setCity}
                            invalid={Boolean(show("city", 2))}
                            valid={!errors.city}
                            inputClassName={inputClass(Boolean(show("city", 2)), !errors.city)}
                          />
                        </div>
                        <FieldError msg={show("city", 2)} />
                      </div>
                    </div>

                    <div style={i(5)}>
                      <label htmlFor="birthday" className={labelClass}>
                        Date de naissance <span className="font-normal text-[var(--on-surface-faint)]">· facultatif</span>
                      </label>
                      <input
                        id="birthday"
                        type="date"
                        autoComplete="bday"
                        min={birthdayBounds().min}
                        max={birthdayBounds().max}
                        value={birthday}
                        onChange={(e) => setBirthday(e.target.value)}
                        aria-invalid={show("birthday", 2) ? true : undefined}
                        className={cn(inputClass(Boolean(show("birthday", 2)), Boolean(birthday) && !errors.birthday), "mt-2 [color-scheme:light_dark] sm:max-w-[15rem]", !birthday && "text-[var(--on-surface-faint)]")}
                      />
                      <FieldError msg={show("birthday", 2)} />
                    </div>

                    <StepActions n={6} primary="Continuer" onBack={() => goTo(1)} busy={tried[2] && usernameState === "checking"} />
                  </form>
                )}

                {/* ═══════════ 4. VALIDATION ═══════════ */}
                {step === 3 && (
                  <form noValidate onSubmit={submit} className="grid gap-6">
                    <StepHeading ref={headingRef} n={0} title="Tout est prêt" sub="Vérifie tes informations, puis crée ton compte." />

                    <div className="overflow-hidden rounded-3xl border border-[var(--outline)]" style={i(1)}>
                      <div className="relative flex items-center gap-4 p-5" style={pathway ? { background: `linear-gradient(120deg, ${pathway.color}14, transparent 70%)` } : undefined}>
                        {/* eslint-disable-next-line @next/next/no-img-element */}
                        <img src={avatarSrc(avatar)} alt="" width={64} height={64} className="h-16 w-16 shrink-0 rounded-full shadow-[0_10px_24px_-12px_rgba(0,11,54,0.6)]" />
                        <div className="min-w-0 flex-1">
                          <p className="truncate text-[18px] font-semibold tracking-[-0.01em] text-[var(--on-surface)]">
                            {cleanText(firstName)} {cleanText(lastName)}
                          </p>
                          <p className="truncate text-[14.5px] text-[var(--on-surface-muted)]">@{username}</p>
                          {pathway && (
                            <span className="mt-2 inline-flex max-w-full items-center gap-1.5 whitespace-nowrap rounded-full px-2.5 py-1 text-[12.5px] font-semibold" style={{ color: pathway.color, background: `${pathway.color}16` }}>
                              <span className="h-1.5 w-1.5 rounded-full" style={{ background: pathway.color }} aria-hidden="true" />
                              {shortName(pathway)}
                            </span>
                          )}
                        </div>
                        <EditButton label="Modifier le profil" onClick={() => goTo(2)} />
                      </div>
                      <dl className="grid grid-cols-[minmax(0,1fr)] divide-y divide-[var(--outline)] border-t border-[var(--outline)]">
                        <SummaryRow icon={<Mail className="h-4 w-4" />} label="E-mail" value={normalizedEmail} onEdit={() => goTo(1)} />
                        <SummaryRow icon={<Phone className="h-4 w-4" />} label="Mobile" value={formatPhone(phone)} onEdit={() => goTo(2)} />
                        <SummaryRow icon={<MapPin className="h-4 w-4" />} label="Ville" value={cleanText(city)} onEdit={() => goTo(2)} />
                        {birthday && <SummaryRow icon={<Cake className="h-4 w-4" />} label="Naissance" value={formatBirthday(birthday)} onEdit={() => goTo(2)} />}
                        <SummaryRow icon={<Sparkles className="h-4 w-4" />} label="Parcours" value={pathway ? shortName(pathway) : "—"} onEdit={() => goTo(0)} />
                      </dl>
                    </div>

                    <p className="flex items-start gap-3 rounded-2xl bg-[var(--surface-container)] px-4 py-3.5 text-[14px] leading-relaxed text-[var(--on-surface-muted)]" style={i(2)}>
                      <Check className="mt-0.5 h-4 w-4 shrink-0 text-[#16A34A] dark:text-[#34D399]" strokeWidth={3} aria-hidden="true" />
                      <span>
                        Un seul compte : connecte-toi dans l’application avec le même e-mail et le même mot de passe, ton profil et ton parcours y seront déjà.
                      </span>
                    </p>

                    <div style={i(3)}>
                      <label className="flex cursor-pointer items-start gap-3">
                        <input
                          type="checkbox"
                          checked={accepted}
                          onChange={(e) => setAccepted(e.target.checked)}
                          aria-invalid={show("accepted", 3) ? true : undefined}
                          className="peer sr-only"
                        />
                        <span
                          aria-hidden="true"
                          className={cn(
                            "mt-0.5 grid h-5 w-5 shrink-0 place-items-center rounded-md border transition-colors duration-200 peer-focus-visible:outline peer-focus-visible:outline-2 peer-focus-visible:outline-offset-2 peer-focus-visible:outline-[#4D82FF]",
                            accepted ? "border-[#1147D9] bg-[#1147D9] text-white" : show("accepted", 3) ? "border-[#DC2626]" : "border-[var(--on-surface-faint)]",
                          )}
                        >
                          {accepted && <Check className="cq-quiz-in h-3.5 w-3.5" strokeWidth={3} />}
                        </span>
                        <span className="text-[14px] leading-relaxed text-[var(--on-surface-muted)]">
                          J’accepte les{" "}
                          <Link href="/cgu" target="_blank" className="font-semibold text-[var(--on-surface)] underline underline-offset-2">conditions d’utilisation</Link>
                          {" "}et la{" "}
                          <Link href="/privacy" target="_blank" className="font-semibold text-[var(--on-surface)] underline underline-offset-2">politique de confidentialité</Link>
                          {" "}de COP’IQ.
                        </span>
                      </label>
                      <FieldError msg={show("accepted", 3)} />
                    </div>

                    {formError && (
                      <p role="alert" className="cq-quiz-in rounded-2xl bg-[#DC2626]/8 px-4 py-3 text-[14px] text-[#B91C1C] dark:text-[#F87171]">
                        {formError}
                      </p>
                    )}

                    <StepActions
                      n={4}
                      primary={loading ? "Création du compte…" : "Créer mon compte"}
                      onBack={() => goTo(2)}
                      busy={loading}
                      final
                    />
                  </form>
                )}
              </div>

              <p className="mt-8 text-center text-[15px] text-[var(--on-surface-muted)]">
                Déjà un compte ?{" "}
                <Link href="/login" className="font-semibold text-[#1147D9] underline-offset-4 hover:underline dark:text-[#7FB3FF]">
                  Se connecter
                </Link>
              </p>
            </>
          )}

          <p className="mt-10 text-center text-[12.5px] leading-relaxed text-[var(--on-surface-faint)] lg:hidden">
            {INDEPENDENCE_NOTICE_SHORT}
          </p>
        </div>
      </main>
    </div>
  )
}

/* ─────────────────────────────────────────────────────────────────────────────
   Barre d'étapes
   ───────────────────────────────────────────────────────────────────────── */

function Stepper({ step, reached, onGo }: { step: Step; reached: Step; onGo: (s: Step) => void }) {
  return (
    <nav aria-label="Étapes de l’inscription" className="cq-enter" style={d(80)}>
      <p className="text-[13px] font-semibold uppercase tracking-[0.14em] text-[var(--on-surface-faint)]">
        Étape {step + 1} sur {STEPS.length}
      </p>
      <ol className="mt-3 grid grid-cols-4 gap-2">
        {STEPS.map((s, idx) => {
          const state = idx < step ? "done" : idx === step ? "current" : "todo"
          const clickable = idx <= reached && idx !== step
          return (
            <li key={s.key}>
              <button
                type="button"
                disabled={!clickable}
                onClick={() => onGo(idx as Step)}
                aria-current={state === "current" ? "step" : undefined}
                className="group block w-full text-left disabled:cursor-default"
              >
                <span className="relative block h-1 overflow-hidden rounded-full bg-[var(--outline)]">
                  <span
                    className="cq-stepbar-fill absolute inset-0 rounded-full"
                    style={{
                      transform: `scaleX(${state === "todo" ? 0 : 1})`,
                      background: state === "done" ? "#16A34A" : "#1147D9",
                    }}
                  />
                </span>
                <span
                  className={cn(
                    "mt-2 flex items-center gap-1 truncate text-[12.5px] font-medium transition-colors duration-300 sm:text-[13px]",
                    state === "current" ? "text-[var(--on-surface)]" : state === "done" ? "text-[var(--on-surface-muted)] group-enabled:group-hover:text-[var(--on-surface)]" : "text-[var(--on-surface-faint)]",
                  )}
                >
                  {state === "done" && <Check className="h-3 w-3 shrink-0 text-[#16A34A]" strokeWidth={3} aria-hidden="true" />}
                  {s.label}
                </span>
              </button>
            </li>
          )
        })}
      </ol>
    </nav>
  )
}

function StepHeading({ ref, title, sub, n }: { ref: React.Ref<HTMLHeadingElement>; title: string; sub: string; n: number }) {
  return (
    <div style={i(n)}>
      <h1
        ref={ref}
        tabIndex={-1}
        className="text-[clamp(1.75rem,3vw,2.3rem)] font-bold leading-[1.06] tracking-[-0.035em] text-[var(--on-surface)] outline-none"
      >
        {title}
      </h1>
      <p className="mt-2.5 text-[15.5px] leading-relaxed text-[var(--on-surface-muted)]">{sub}</p>
    </div>
  )
}

function StepActions({
  n,
  primary,
  onBack,
  busy,
  final,
}: {
  n: number
  primary: string
  onBack?: () => void
  busy?: boolean
  final?: boolean
}) {
  return (
    <div className="flex items-center gap-3 pt-1" style={i(n)}>
      {onBack && (
        <button
          type="button"
          onClick={onBack}
          aria-label="Étape précédente"
          className="cq-tap cq-btn grid h-[3.4rem] w-[3.4rem] shrink-0 place-items-center rounded-2xl border border-[var(--outline)] text-[var(--on-surface)] hover:border-[var(--on-surface-faint)]"
        >
          <ArrowLeft className="h-[18px] w-[18px]" aria-hidden="true" />
        </button>
      )}
      <button
        type="submit"
        disabled={busy}
        className={cn(
          "cq-tap cq-btn cq-btn-lift group inline-flex h-[3.4rem] flex-1 items-center justify-center gap-2 rounded-2xl px-6 text-[16px] font-semibold text-white disabled:cursor-wait disabled:opacity-80",
          final
            ? "cq-btn-shine bg-[#E0162B] shadow-[0_14px_40px_-16px_rgba(224,22,43,0.9)] hover:bg-[#C8102A]"
            : "bg-[#000B36] shadow-[0_14px_36px_-18px_rgba(0,11,54,0.9)] hover:bg-[#0A1A55] dark:bg-[#1147D9] dark:hover:bg-[#1A55F0]",
        )}
      >
        {busy && <Loader2 className="h-4 w-4 animate-spin" aria-hidden="true" />}
        {primary}
        {!busy && !final && <ArrowRight className="h-4 w-4 transition-transform duration-300 group-hover:translate-x-0.5" aria-hidden="true" />}
      </button>
    </div>
  )
}

/* ─────────────────────────────────────────────────────────────────────────────
   Avatar : les 20 avatars de l'application
   ───────────────────────────────────────────────────────────────────────── */

function AvatarPicker({ value, onChange, style }: { value: number; onChange: (v: number) => void; style?: CSSProperties }) {
  const [open, setOpen] = useState(false)
  return (
    <div style={style}>
      <div className="flex items-center gap-4">
        {/* eslint-disable-next-line @next/next/no-img-element */}
        <img
          key={value}
          src={avatarSrc(value)}
          alt=""
          width={72}
          height={72}
          className="cq-avatar-pop h-[72px] w-[72px] shrink-0 rounded-full shadow-[0_14px_30px_-14px_rgba(0,11,54,0.55)]"
        />
        <div className="min-w-0">
          <p className={labelClass}>Ton avatar</p>
          <button
            type="button"
            onClick={() => setOpen((o) => !o)}
            aria-expanded={open}
            aria-controls="avatars"
            className="mt-1 inline-flex items-center gap-1.5 rounded-lg text-[14.5px] font-semibold text-[#1147D9] underline-offset-4 hover:underline dark:text-[#7FB3FF]"
          >
            {open ? "Fermer" : "Choisir un autre avatar"}
          </button>
        </div>
      </div>
      {open && (
        <div id="avatars" role="radiogroup" aria-label="Avatars" className="cq-pop-in mt-4 grid grid-cols-5 gap-2.5 rounded-3xl border border-[var(--outline)] p-3 sm:gap-3">
          {Array.from({ length: AVATAR_COUNT }, (_, k) => k + 1).map((n) => {
            const selected = n === value
            return (
              <label key={n} className="relative grid cursor-pointer place-items-center">
                <input
                  type="radio"
                  name="avatar"
                  value={n}
                  checked={selected}
                  onChange={() => {
                    onChange(n)
                    window.setTimeout(() => setOpen(false), 260)
                  }}
                  className="peer sr-only"
                  aria-label={`Avatar ${n}`}
                />
                {/* eslint-disable-next-line @next/next/no-img-element */}
                <img
                  src={avatarSrc(n)}
                  alt=""
                  width={56}
                  height={56}
                  loading="lazy"
                  className={cn(
                    "aspect-square w-full max-w-14 rounded-full transition-[transform,box-shadow,opacity] duration-300 ease-[cubic-bezier(0.22,1,0.36,1)] hover:scale-[1.06]",
                    selected ? "scale-[1.04] shadow-[0_0_0_3px_var(--surface),0_0_0_5px_#1147D9]" : "opacity-90 hover:opacity-100",
                  )}
                />
                <span className="pointer-events-none absolute inset-0 rounded-full peer-focus-visible:outline peer-focus-visible:outline-2 peer-focus-visible:outline-offset-2 peer-focus-visible:outline-[#4D82FF]" />
              </label>
            )
          })}
        </div>
      )}
    </div>
  )
}

/* ─────────────────────────────────────────────────────────────────────────── */

function UsernameTaken({ base, onPick }: { base: string; onPick: (v: string) => void }) {
  const ideas = useMemo(() => {
    const root = base.replace(/_+$/, "").slice(0, 16)
    // Suffixes stables (dérivés du pseudo) : pas de hasard pendant le rendu.
    let h = 7
    for (const ch of root) h = (h * 31 + ch.charCodeAt(0)) % 9973
    const year = new Date().getFullYear() % 100
    return [`${root}${year}`, `${root}_${10 + (h % 89)}`, `${root}${100 + ((h * 7) % 899)}`].map((s) => s.slice(0, 20))
  }, [base])
  return (
    <span className="flex flex-wrap items-center gap-1.5 text-[#DC2626] dark:text-[#F87171]">
      Ce pseudo est déjà pris. Essaie :
      {ideas.map((s) => (
        <button
          key={s}
          type="button"
          onClick={() => onPick(s)}
          className="rounded-full bg-[var(--surface-container)] px-2.5 py-0.5 font-semibold text-[var(--on-surface)] transition-colors hover:bg-[var(--outline)]"
        >
          {s}
        </button>
      ))}
    </span>
  )
}

function StatusIcon({ state }: { state: CheckState }) {
  return (
    <span className="pointer-events-none absolute right-3.5 top-1/2 -translate-y-1/2" aria-hidden="true">
      {state === "checking" && <Loader2 className="h-4 w-4 animate-spin text-[var(--on-surface-faint)]" />}
      {state === "available" && <Check className="cq-quiz-in h-4 w-4 text-[#16A34A] dark:text-[#34D399]" strokeWidth={3} />}
    </span>
  )
}

function EditButton({ label, onClick }: { label: string; onClick: () => void }) {
  return (
    <button
      type="button"
      onClick={onClick}
      aria-label={label}
      className="cq-tap grid h-10 w-10 shrink-0 place-items-center rounded-xl text-[var(--on-surface-muted)] transition-colors hover:bg-[var(--surface-container)] hover:text-[var(--on-surface)]"
    >
      <Pencil className="h-4 w-4" aria-hidden="true" />
    </button>
  )
}

function SummaryRow({ icon, label, value, onEdit }: { icon: ReactNode; label: string; value: string; onEdit: () => void }) {
  return (
    <div className="flex min-w-0 items-center gap-3 py-2.5 pl-4 pr-2 sm:py-3 sm:pl-5 sm:pr-3">
      <span className="text-[var(--on-surface-faint)]" aria-hidden="true">{icon}</span>
      <dt className="w-[5.5rem] shrink-0 text-[14px] text-[var(--on-surface-muted)] sm:w-24">{label}</dt>
      <dd className="min-w-0 flex-1 truncate text-[14.5px] font-medium text-[var(--on-surface)]">{value}</dd>
      <button
        type="button"
        onClick={onEdit}
        className="cq-tap grid shrink-0 place-items-center rounded-lg px-1.5 text-[13px] font-semibold text-[#1147D9] transition-colors hover:bg-[var(--surface-container)] dark:text-[#7FB3FF]"
      >
        <Pencil className="h-4 w-4 sm:hidden" aria-hidden="true" />
        <span className="max-sm:sr-only">Modifier</span>
        <span className="sr-only"> : {label}</span>
      </button>
    </div>
  )
}

/* ─────────────────────────────────────────────────────────────────────────────
   Colonne de marque : s'adapte au parcours, puis montre le profil en direct
   ───────────────────────────────────────────────────────────────────────── */

type Preview = { avatar: number; name: string; username: string; city: string } | null

function BrandPanel({ pathway, step, preview }: { pathway: PathwayDefinition | null; step: Step; preview: Preview }) {
  return (
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

      <div className={cn("px-4 pb-7 sm:px-8 lg:flex lg:flex-1 lg:flex-col lg:justify-center lg:px-12 lg:pb-0", step > 0 && "max-lg:pb-5")}>
        <Tricolore className="cq-enter-draw mb-5 h-1 w-14 lg:mb-8" />
        <div key={pathway?.id ?? "aucun"}>
          <SplitText
            as="h2"
            mode="load"
            delay={pathway ? 60 : 160}
            stagger={45}
            text={pathway ? pathway.title : "Ta préparation commence ici."}
            className={cn(
              "block max-w-[28rem] font-bold leading-[1.04] tracking-[-0.04em] [text-wrap:balance]",
              step > 0 ? "text-[clamp(1.35rem,3.4vw,2.9rem)]" : "text-[clamp(1.8rem,3.4vw,2.9rem)]",
            )}
          />
          <p className={cn("cq-enter mt-4 max-w-[28rem] text-[16px] leading-relaxed text-white/70", step > 0 && "max-lg:hidden")} style={d(260)}>
            {pathway ? pathway.description : "Choisis ton parcours : Policier adjoint ou Gardien de la paix, concours ou école."}
          </p>

          {preview ? (
            <ProfilePreview preview={preview} pathway={pathway} />
          ) : (
            pathway && (
              <ul className="mt-8 hidden max-w-[28rem] gap-3 lg:grid [@media(max-height:760px)]:gap-2">
                {pathway.navigation.map((n, idx) => (
                  <li key={n.href + n.label} className="cq-enter flex items-start gap-3" style={d(340 + idx * 70)}>
                    <span className="mt-[7px] h-2 w-2 shrink-0 rounded-full" style={{ background: pathway.color, boxShadow: `0 0 12px ${pathway.color}` }} aria-hidden="true" />
                    <span>
                      <span className="block text-[15.5px] font-semibold text-white">{n.label}</span>
                      <span className="block text-[14px] text-white/60">{n.description}</span>
                    </span>
                  </li>
                ))}
              </ul>
            )
          )}
        </div>
      </div>

      <div className="hidden px-12 pb-10 pt-6 lg:block">
        <p className="cq-enter-fade max-w-[30rem] text-[15px] italic leading-relaxed text-white/60 [@media(max-height:820px)]:hidden" style={d(900)}>
          « Ce n’est pas le jour de l’épreuve qui révèle notre valeur, mais tous les jours qui nous y ont préparés. »
        </p>
        <p className="mt-6 text-[12.5px] text-white/45">{INDEPENDENCE_NOTICE_SHORT}</p>
      </div>
    </aside>
  )
}

/** Aperçu du profil tel qu'il apparaîtra dans l'application (grand écran). */
function ProfilePreview({ preview, pathway }: { preview: NonNullable<Preview>; pathway: PathwayDefinition | null }) {
  return (
    <div className="cq-enter-panel mt-10 hidden max-w-[24rem] lg:block" style={d(120)} aria-hidden="true">
      <p className="mb-3 text-[12px] font-semibold uppercase tracking-[0.16em] text-white/45">Aperçu dans l’application</p>
      <div className="relative overflow-hidden rounded-[1.6rem] border border-white/12 bg-white/[0.06] p-5 backdrop-blur-md">
        <span className="absolute inset-x-0 top-0 h-[2px]" style={{ background: pathway?.color ?? "#3D7BFF" }} />
        <div className="flex items-center gap-4">
          {/* eslint-disable-next-line @next/next/no-img-element */}
          <img key={preview.avatar} src={avatarSrc(preview.avatar)} alt="" width={60} height={60} className="cq-avatar-pop h-[60px] w-[60px] rounded-full ring-2 ring-white/15" />
          <div className="min-w-0">
            <p className="truncate text-[18px] font-semibold tracking-[-0.01em]">{preview.name || "Ton prénom et ton nom"}</p>
            <p className="truncate text-[14px] text-white/60">{preview.username ? `@${preview.username}` : "@pseudo"}</p>
          </div>
        </div>
        <div className="mt-5 flex flex-wrap gap-2 text-[12.5px]">
          {pathway && (
            <span className="inline-flex items-center gap-1.5 rounded-full bg-white/10 px-2.5 py-1 font-medium">
              <span className="h-1.5 w-1.5 rounded-full" style={{ background: pathway.color, boxShadow: `0 0 8px ${pathway.color}` }} />
              {shortName(pathway)}
            </span>
          )}
          {preview.city && (
            <span className="inline-flex items-center gap-1.5 rounded-full bg-white/10 px-2.5 py-1 font-medium">
              <MapPin className="h-3 w-3" />
              {preview.city}
            </span>
          )}
        </div>
      </div>
    </div>
  )
}

/* ─────────────────────────────────────────────────────────────────────────────
   Après l'envoi : vérifier sa boîte mail
   ───────────────────────────────────────────────────────────────────────── */

function SentState({
  email,
  password,
  firstName,
  pathway,
  onEdit,
}: {
  email: string
  password: string
  firstName: string
  pathway: PathwayDefinition | null
  onEdit: () => void
}) {
  const supabase = useMemo(() => createClient(), [])
  const [cooldown, setCooldown] = useState(60)
  const [resent, setResent] = useState<"idle" | "sending" | "sent" | "error">("idle")
  const [confirmed, setConfirmed] = useState(false)

  useEffect(() => {
    if (cooldown <= 0) return
    const t = window.setTimeout(() => setCooldown((c) => c - 1), 1000)
    return () => window.clearTimeout(t)
  }, [cooldown])

  /*
   * Détection automatique de la confirmation, même si le lien est ouvert sur
   * un autre appareil (le téléphone, typiquement) : tant que l'e-mail n'est
   * pas confirmé, Supabase refuse la connexion (« Email not confirmed ») ;
   * dès qu'il l'est, la connexion réussit et cette page passe au vert.
   * Rythme prudent pour rester sous la limite de connexions de Supabase :
   * toutes les 15 s, immédiatement au retour sur l'onglet, arrêt après 30 min.
   */
  useEffect(() => {
    if (confirmed) return
    let stopped = false
    let busy = false
    let last = 0
    let delay = 15000
    const started = Date.now()

    async function check() {
      if (stopped || busy || document.visibilityState !== "visible") return
      if (Date.now() - last < 5000) return
      if (Date.now() - started > 30 * 60 * 1000) return
      busy = true
      last = Date.now()
      try {
        const { data, error } = await supabase.auth.signInWithPassword({ email, password })
        if (stopped) return
        if (data.session && !error) {
          stopped = true
          setConfirmed(true)
          return
        }
        delay = error && (error.status === 429 || /rate|too many/i.test(error.message)) ? 60000 : 15000
      } catch {
        delay = 30000
      } finally {
        busy = false
      }
    }

    let timer = 0
    const loop = () => {
      timer = window.setTimeout(async () => {
        await check()
        if (!stopped) loop()
      }, delay)
    }
    loop()
    const onVisible = () => void check()
    document.addEventListener("visibilitychange", onVisible)
    window.addEventListener("focus", onVisible)
    return () => {
      stopped = true
      window.clearTimeout(timer)
      document.removeEventListener("visibilitychange", onVisible)
      window.removeEventListener("focus", onVisible)
    }
  }, [confirmed, email, password, supabase])

  async function resend() {
    setResent("sending")
    const { error } = await supabase.auth.resend({
      type: "signup",
      email,
      options: { emailRedirectTo: confirmRedirectUrl() },
    })
    setResent(error ? "error" : "sent")
    setCooldown(60)
  }

  if (confirmed) return <ConfirmedState firstName={firstName} pathway={pathway} />

  const steps = [
    "Ouvre l’e-mail envoyé par COP’IQ (pense à regarder dans les indésirables).",
    "Clique sur le lien de confirmation, depuis ton téléphone ou depuis cet ordinateur.",
    "Cette page se met à jour toute seule dès que c’est fait.",
  ]

  return (
    <div role="status" aria-live="polite">
      <div className="cq-enter-panel relative mb-8 grid h-16 w-16 place-items-center rounded-2xl bg-[#000B36] text-white shadow-[0_20px_50px_-20px_rgba(17,71,217,0.9)]">
        <Mail className="h-7 w-7" aria-hidden="true" />
        <span className="absolute -right-1.5 -top-1.5 grid h-6 w-6 place-items-center rounded-full bg-[#16A34A] ring-4 ring-[var(--surface)]">
          <Check className="h-3.5 w-3.5" strokeWidth={3} aria-hidden="true" />
        </span>
      </div>
      <SplitText
        as="h1"
        mode="load"
        delay={120}
        text="Vérifie ta boîte mail."
        className="block text-[clamp(1.9rem,3.2vw,2.5rem)] font-bold leading-[1.05] tracking-[-0.035em] text-[var(--on-surface)]"
      />
      <p className="cq-enter mt-3 text-[16px] leading-relaxed text-[var(--on-surface-muted)]" style={d(300)}>
        Ton compte est créé. Un lien d’activation vient d’être envoyé à{" "}
        <span className="font-semibold text-[var(--on-surface)]">{email}</span>.
      </p>

      <ol className="mt-8 grid gap-4">
        {steps.map((s, idx) => (
          <li key={s} className="cq-enter flex gap-4" style={d(420 + idx * 90)}>
            <span className="grid h-8 w-8 shrink-0 place-items-center rounded-full border border-[var(--outline)] text-[14px] font-semibold text-[var(--on-surface)]">
              {idx + 1}
            </span>
            <span className="pt-1 text-[15px] leading-relaxed text-[var(--on-surface)]">{s}</span>
          </li>
        ))}
      </ol>

      <p className="cq-enter mt-7 inline-flex items-center gap-2.5 rounded-full bg-[var(--surface-container)] px-3.5 py-2 text-[13.5px] font-medium text-[var(--on-surface-muted)]" style={d(700)}>
        <span className="relative flex h-2 w-2" aria-hidden="true">
          <span className="absolute inline-flex h-full w-full animate-ping rounded-full bg-[#1147D9] opacity-60 motion-reduce:animate-none" />
          <span className="relative inline-flex h-2 w-2 rounded-full bg-[#1147D9]" />
        </span>
        En attente de ta confirmation…
      </p>

      <div className="cq-enter mt-8 grid gap-3 sm:grid-cols-2" style={d(780)}>
        <button
          type="button"
          onClick={resend}
          disabled={cooldown > 0 || resent === "sending"}
          className="cq-tap cq-btn inline-flex items-center justify-center gap-2 rounded-2xl border border-[var(--outline)] px-5 py-3 text-[15px] font-semibold text-[var(--on-surface)] hover:border-[var(--on-surface-faint)] disabled:cursor-not-allowed disabled:opacity-55"
        >
          <RotateCcw className="h-4 w-4" aria-hidden="true" />
          {cooldown > 0 ? `Renvoyer (${cooldown} s)` : "Renvoyer l’e-mail"}
        </button>
        <button
          type="button"
          onClick={onEdit}
          className="cq-tap cq-btn inline-flex items-center justify-center gap-2 rounded-2xl px-5 py-3 text-[15px] font-semibold text-[#1147D9] hover:bg-[var(--surface-container)] dark:text-[#7FB3FF]"
        >
          <X className="h-4 w-4" aria-hidden="true" />
          Pas la bonne adresse
        </button>
      </div>
      <p aria-live="polite" className="mt-3 min-h-[1.25rem] text-center text-[13.5px]">
        {resent === "sent" && <span className="text-[#16A34A] dark:text-[#34D399]">E-mail renvoyé.</span>}
        {resent === "error" && <span className="text-[#DC2626] dark:text-[#F87171]">L’envoi a échoué. Réessaie dans une minute.</span>}
      </p>
    </div>
  )
}

/* ─────────────────────────────────────────────────────────────────────────────
   Compte confirmé : félicitations, puis accès à l'espace
   ───────────────────────────────────────────────────────────────────────── */

function ConfirmedState({ firstName, pathway }: { firstName: string; pathway: PathwayDefinition | null }) {
  const name = cleanText(firstName)
  return (
    <div role="status" aria-live="assertive" className="text-center sm:text-left">
      <div className="cq-success-pop relative mx-auto mb-8 grid h-24 w-24 place-items-center sm:mx-0">
        <span className="cq-success-glow absolute inset-[-28px] rounded-full" aria-hidden="true" />
        <svg width="96" height="96" viewBox="0 0 96 96" fill="none" aria-hidden="true" className="relative">
          <circle cx="48" cy="48" r="44" fill="#16A34A" className="cq-success-disc" />
          <path d="M29 49.5l12.5 12.5L67 36" stroke="#fff" strokeWidth="6" strokeLinecap="round" strokeLinejoin="round" className="cq-success-check" />
        </svg>
      </div>
      <p className="cq-enter text-[13px] font-semibold uppercase tracking-[0.16em] text-[#16A34A] dark:text-[#34D399]" style={d(380)}>
        Adresse confirmée
      </p>
      <SplitText
        as="h1"
        mode="load"
        delay={460}
        text={name ? `Félicitations ${name}, ton compte est activé !` : "Félicitations, ton compte est activé !"}
        className="mt-3 block text-[clamp(1.9rem,3.2vw,2.5rem)] font-bold leading-[1.06] tracking-[-0.035em] text-[var(--on-surface)] [text-wrap:balance]"
      />
      <p className="cq-enter mt-4 text-[16px] leading-relaxed text-[var(--on-surface-muted)]" style={d(760)}>
        Bienvenue dans COP’IQ.{" "}
        {pathway ? `Ton espace «\u00a0${shortName(pathway)}\u00a0» est prêt` : "Ton espace est prêt"}, sur le site comme dans l’application, avec les mêmes identifiants.
      </p>

      <div className="cq-enter mt-9 grid gap-3" style={d(880)}>
        {/* Navigation complète : l'espace se charge avec la nouvelle session. */}
        <a
          href="/dashboard/"
          className="cq-tap cq-btn cq-btn-shine cq-btn-lift group inline-flex h-[3.4rem] items-center justify-center gap-2 rounded-2xl bg-[#16A34A] px-6 text-[16px] font-semibold text-white shadow-[0_16px_40px_-18px_rgba(22,163,74,0.95)] hover:bg-[#15803D]"
        >
          Accéder à mon espace
          <ArrowRight className="h-4 w-4 transition-transform duration-300 group-hover:translate-x-0.5" aria-hidden="true" />
        </a>
      </div>
    </div>
  )
}

/* ─────────────────────────────────────────────────────────────────────────── */

const labelClass = "text-[15px] font-semibold text-[var(--on-surface)]"

function FieldError({ msg }: { msg: string | null | false | undefined }) {
  if (!msg) return null
  return (
    <p role="alert" className="cq-quiz-in mt-2 text-[13.5px] text-[#DC2626] dark:text-[#F87171]">
      {msg}
    </p>
  )
}

function inputClass(invalid: boolean, valid: boolean) {
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
