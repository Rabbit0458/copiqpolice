"use client"
import { useState, useRef, useEffect } from "react"
import { FileText, Send, Loader2, Crown, AlertTriangle, CheckCircle, XCircle, ChevronDown, ChevronUp, Clock, Star } from "lucide-react"
import Link from "next/link"
import toast from "react-hot-toast"

const CP_THEMES = [
  { id: "vol", label: "Vol & atteintes aux biens" },
  { id: "violences", label: "Violences & atteintes aux personnes" },
  { id: "stupéfiants", label: "Infractions aux stupéfiants" },
  { id: "routier", label: "Droit routier" },
  { id: "procedure", label: "Procédure pénale" },
  { id: "deontologie", label: "Déontologie" },
]

interface Props {
  userId: string
  tier: string
  freeUsed: number
  freeTotal: number
  recentAttempts: any[]
  userEmail: string
}

type Phase = "idle" | "writing" | "submitting" | "result"

export default function CasPratiquesInterface({ userId, tier, freeUsed, freeTotal, recentAttempts, userEmail }: Props) {
  const [phase, setPhase] = useState<Phase>("idle")
  const [theme, setTheme] = useState(CP_THEMES[0].id)
  const [scenario, setScenario] = useState("")
  const [answer, setAnswer] = useState("")
  const [result, setResult] = useState<any>(null)
  const [showHistory, setShowHistory] = useState(false)
  const textRef = useRef<HTMLTextAreaElement>(null)

  const isPremium = tier === "premium" || tier === "premium_trial"
  const quotaLeft = freeTotal - freeUsed
  const isQuotaExhausted = !isPremium && quotaLeft <= 0

  const SAMPLE_SCENARIOS = [
    "Le 12 mars 2025, à 22h, une patrouille de police aperçoit un individu forcer la vitre d'un véhicule stationné. L'individu tente de fuir mais est interpellé. Il est trouvé en possession d'outils de crochetage et d'une radio.",
    "Mme X appelle le 17 pour signaler que son voisin, M. Y, la menace verbalement depuis plusieurs semaines et vient de lui lancer une bouteille en verre sans l'atteindre. M. Y semble sous l'emprise de l'alcool.",
    "Lors d'un contrôle routier, un conducteur présente des pupilles dilatées et un comportement incohérent. Il refuse le test de dépistage de stupéfiants. La fouille du véhicule révèle 5g de cannabis dans la boîte à gants.",
  ]

  async function handleGenerate() {
    if (!scenario.trim()) {
      const s = SAMPLE_SCENARIOS[Math.floor(Math.random() * SAMPLE_SCENARIOS.length)]
      setScenario(s)
    }
    setPhase("writing")
    if (textRef.current) textRef.current.focus()
  }

  async function handleSubmit() {
    if (!answer.trim() || answer.length < 100) {
      toast.error("Votre réponse doit faire au moins 100 caractères")
      return
    }
    if (isQuotaExhausted) {
      toast.error("Quota hebdomadaire épuisé. Passez en Premium !")
      return
    }
    setPhase("submitting")
    try {
      const res = await fetch(`${process.env.NEXT_PUBLIC_SUPABASE_URL}/functions/v1/cas_pratique_correct_attempt`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "Authorization": `Bearer ${process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY}`,
        },
        body: JSON.stringify({ user_id: userId, scenario, answer, theme }),
      })
      if (!res.ok) {
        const errData = await res.json().catch(() => ({}))
        if (errData?.error === "quota_exceeded") {
          toast.error("Quota hebdomadaire épuisé. Passez en Premium !")
          setPhase("writing")
          return
        }
        throw new Error("Correction échouée")
      }
      const data = await res.json()
      setResult(data)
      setPhase("result")
    } catch (err) {
      toast.error("Erreur lors de la correction. Veuillez réessayer.")
      setPhase("writing")
    }
  }

  function handleReset() {
    setPhase("idle")
    setScenario("")
    setAnswer("")
    setResult(null)
  }

  return (
    <div className="max-w-4xl mx-auto px-4 py-8">
      <div className="flex items-start justify-between gap-4 mb-6">
        <div>
          <h1 className="text-2xl font-bold text-[var(--on-surface)] flex items-center gap-2"><FileText size={20} /> Cas Pratiques GPX</h1>
          <p className="text-[var(--on-surface-muted)] text-sm mt-1">Rédigez votre analyse juridique. L&apos;IA corrige et note votre réponse.</p>
        </div>
        {!isPremium && (
          <div className="text-right flex-shrink-0">
            <div className={`text-sm font-semibold ${quotaLeft <= 2 ? "text-[#F97316]" : "text-[var(--on-surface)]"}`}>
              {quotaLeft}/{freeTotal} restants
            </div>
            <div className="text-xs text-[var(--on-surface-faint)]">cette semaine</div>
            {quotaLeft <= 2 && (
              <Link href="/abonnement" className="inline-flex items-center gap-1 text-xs text-[#1147D9] mt-1 hover:underline"><Crown size={10} />Passer Premium</Link>
            )}
          </div>
        )}
      </div>
      {/* Quota exhausted banner */}
      {isQuotaExhausted && (
        <div className="rounded-xl bg-[#F97316]/10 border border-[#F97316]/30 p-4 flex items-center gap-3 mb-6">
          <AlertTriangle size={18} className="text-[#F97316] flex-shrink-0" />
          <div className="flex-1">
            <p className="text-sm font-semibold text-[var(--on-surface)]">Quota hebdomadaire épuisé</p>
            <p className="text-xs text-[var(--on-surface-muted)]">Vos 10 cas pratiques gratuits de la semaine ont été utilisés. Passez Premium pour un accès illimité.</p>
          </div>
          <Link href="/abonnement" className="flex items-center gap-1.5 px-4 py-2 rounded-lg bg-[#1147D9] text-white text-xs font-semibold hover:bg-[#1A55E6] transition-all flex-shrink-0">
            <Crown size={12} /> Premium
          </Link>
        </div>
      )}

      {/* IDLE PHASE */}
      {phase === "idle" && (
        <div className="space-y-4">
          <div className="rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-6">
            <h2 className="font-semibold text-[var(--on-surface)] mb-4">Nouveau cas pratique</h2>
            <div className="space-y-4">
              <div>
                <label className="block text-sm font-medium text-[var(--on-surface)] mb-1.5">Thème</label>
                <select value={theme} onChange={e => setTheme(e.target.value)} className="w-full px-4 py-3 rounded-xl border border-[var(--outline)] bg-[var(--surface-dark)] text-[var(--on-surface)] text-sm focus:outline-none focus:ring-2 focus:ring-[#1147D9]/30 focus:border-[#1147D9] transition-all">
                  {CP_THEMES.map(t => <option key={t.id} value={t.id}>{t.label}</option>)}
                </select>
              </div>
              <div>
                <label className="block text-sm font-medium text-[var(--on-surface)] mb-1.5">Scénario (optionnel — laissez vide pour un tirage aléatoire)</label>
                <textarea value={scenario} onChange={e => setScenario(e.target.value)} rows={4} placeholder="Décrivez la situation à analyser, ou laissez vide pour un scénario généré automatiquement..." className="w-full px-4 py-3 rounded-xl border border-[var(--outline)] bg-[var(--surface-dark)] text-[var(--on-surface)] text-sm placeholder:text-[var(--on-surface-faint)] focus:outline-none focus:ring-2 focus:ring-[#1147D9]/30 focus:border-[#1147D9] transition-all resize-none" />
              </div>
              <button onClick={handleGenerate} disabled={isQuotaExhausted} className="w-full flex items-center justify-center gap-2 py-3.5 rounded-xl bg-[#1147D9] hover:bg-[#1A55E6] text-white font-semibold text-sm transition-all disabled:opacity-50">
                <FileText size={16} /> Commencer le cas pratique
              </button>
            </div>
          </div>
        </div>
      )}

      {/* WRITING PHASE */}
      {phase === "writing" && (
        <div className="space-y-4">
          <div className="rounded-2xl border border-[#1147D9]/30 bg-[#1147D9]/[0.03] p-5">
            <div className="flex items-start gap-2 mb-2">
              <FileText size={16} className="text-[#1147D9] mt-0.5 flex-shrink-0" />
              <h3 className="text-sm font-semibold text-[var(--on-surface)]">Scénario</h3>
            </div>
            <p className="text-sm text-[var(--on-surface-muted)] leading-relaxed">{scenario}</p>
          </div>
          <div className="rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-6 watermark-container" data-watermark={userEmail}>
            <label className="block text-sm font-semibold text-[var(--on-surface)] mb-1">Votre analyse juridique</label>
            <p className="text-xs text-[var(--on-surface-muted)] mb-3">Qualifiez les faits, identifiez les infractions, analysez la procédure applicable.</p>
            <textarea
              ref={textRef}
              value={answer}
              onChange={e => setAnswer(e.target.value)}
              rows={14}
              placeholder={`Exemple de plan suggéré :\n\nI. Qualification juridique des faits\n   A. Identification des infractions\n   B. Éléments constitutifs\n\nII. Circonstances\n   A. Aggravantes\n   B. Atténuantes / Irresponsabilité\n\nIII. Procédure applicable\n   A. Type d'enquête\n   B. Mesures de contrainte`}
              className="w-full px-4 py-3 rounded-xl border border-[var(--outline)] bg-[var(--surface-dark)] text-[var(--on-surface)] text-sm placeholder:text-[var(--on-surface-faint)] focus:outline-none focus:ring-2 focus:ring-[#1147D9]/30 focus:border-[#1147D9] transition-all resize-none course-content"
            />
            <div className="flex items-center justify-between mt-3">
              <span className="text-xs text-[var(--on-surface-faint)]">{answer.length} caractères{answer.length < 100 && <span className="text-[#F97316] ml-1">(min. 100)</span>}</span>
              <div className="flex items-center gap-3">
                <button onClick={handleReset} className="text-sm text-[var(--on-surface-muted)] hover:text-[var(--on-surface)] transition-colors">Annuler</button>
                <button onClick={handleSubmit} disabled={answer.length < 100} className="flex items-center gap-2 px-5 py-2.5 rounded-xl bg-[#1147D9] hover:bg-[#1A55E6] text-white font-semibold text-sm transition-all disabled:opacity-50">
                  <Send size={14} /> Soumettre pour correction
                </button>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* SUBMITTING */}
      {phase === "submitting" && (
        <div className="rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-12 text-center">
          <Loader2 size={32} className="text-[#1147D9] animate-spin mx-auto mb-4" />
          <h2 className="text-lg font-bold text-[var(--on-surface)] mb-2">Correction en cours…</h2>
          <p className="text-sm text-[var(--on-surface-muted)]">L&apos;IA analyse votre réponse. Cela prend environ 10-15 secondes.</p>
        </div>
      )}

      {/* RESULT */}
      {phase === "result" && result && (
        <div className="space-y-4">
          {/* Score */}
          <div className="rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-6">
            <div className="flex items-center justify-between mb-4">
              <h2 className="font-bold text-[var(--on-surface)] text-lg">Résultat de correction</h2>
              <div className="flex items-center gap-2">
                <Star size={16} className="text-[#EAB308]" />
                <span className="text-2xl font-bold" style={{ color: result.score >= 70 ? "#22C55E" : result.score >= 50 ? "#F59E0B" : "#EF4444" }}>
                  {result.score ?? 0}/100
                </span>
              </div>
            </div>
            <div className="h-3 rounded-full bg-[var(--surface-dark)] overflow-hidden mb-4">
              <div className="h-full rounded-full transition-all" style={{ width: `${result.score ?? 0}%`, backgroundColor: result.score >= 70 ? "#22C55E" : result.score >= 50 ? "#F59E0B" : "#EF4444" }} />
            </div>
            <p className="text-sm text-[var(--on-surface-muted)] leading-relaxed">{result.feedback ?? "Bonne tentative ! Continuez à vous entraîner pour améliorer votre score."}</p>
          </div>
          {/* Points */}
          {result.points && (
            <div className="grid sm:grid-cols-2 gap-4">
              {result.points.correct?.length > 0 && (
                <div className="rounded-xl border border-[#22C55E]/30 bg-[#22C55E]/5 p-4">
                  <h3 className="text-sm font-semibold text-[#22C55E] flex items-center gap-2 mb-2"><CheckCircle size={14} />Points positifs</h3>
                  <ul className="space-y-1">{result.points.correct.map((p: string, i: number) => <li key={i} className="text-xs text-[var(--on-surface-muted)] leading-relaxed">• {p}</li>)}</ul>
                </div>
              )}
              {result.points.incorrect?.length > 0 && (
                <div className="rounded-xl border border-red-500/30 bg-red-500/5 p-4">
                  <h3 className="text-sm font-semibold text-red-500 flex items-center gap-2 mb-2"><XCircle size={14} />À améliorer</h3>
                  <ul className="space-y-1">{result.points.incorrect.map((p: string, i: number) => <li key={i} className="text-xs text-[var(--on-surface-muted)] leading-relaxed">• {p}</li>)}</ul>
                </div>
              )}
            </div>
          )}
          {/* Correction model */}
          {result.model_answer && (
            <div className="rounded-xl border border-[var(--outline)] bg-[var(--surface)] p-5">
              <h3 className="text-sm font-semibold text-[var(--on-surface)] mb-3">Corrigé type</h3>
              <div className="text-sm text-[var(--on-surface-muted)] leading-relaxed whitespace-pre-wrap">{result.model_answer}</div>
            </div>
          )}
          <div className="flex items-center gap-3">
            <button onClick={handleReset} className="flex-1 py-3 rounded-xl border border-[var(--outline)] text-sm font-semibold text-[var(--on-surface)] hover:bg-[var(--surface-dark)] transition-all">
              Nouveau cas pratique
            </button>
            <Link href="/gpx/quiz" className="flex-1 py-3 rounded-xl bg-[#1147D9] text-white text-center text-sm font-semibold hover:bg-[#1A55E6] transition-all">
              Aller aux quiz
            </Link>
          </div>
        </div>
      )}

      {/* Recent attempts */}
      {recentAttempts.length > 0 && phase === "idle" && (
        <div className="mt-6 rounded-2xl border border-[var(--outline)] bg-[var(--surface)] overflow-hidden">
          <button onClick={() => setShowHistory(!showHistory)} className="w-full flex items-center justify-between p-5 text-sm font-semibold text-[var(--on-surface)] hover:bg-[var(--surface-dark)] transition-colors">
            <span className="flex items-center gap-2"><Clock size={15} />Tentatives récentes</span>
            {showHistory ? <ChevronUp size={16} /> : <ChevronDown size={16} />}
          </button>
          {showHistory && (
            <div className="divide-y divide-[var(--outline)]">
              {recentAttempts.map((a: any) => (
                <div key={a.id} className="flex items-center gap-3 p-4">
                  <div className={`w-2 h-2 rounded-full flex-shrink-0 ${(a.score ?? 0) >= 70 ? "bg-[#22C55E]" : (a.score ?? 0) >= 50 ? "bg-[#F59E0B]" : "bg-red-500"}`} />
                  <div className="flex-1 min-w-0">
                    <p className="text-xs text-[var(--on-surface-muted)] truncate">{a.case_id ?? "Cas pratique"}</p>
                    <p className="text-xs text-[var(--on-surface-faint)]">{new Date(a.created_at).toLocaleDateString("fr-FR")}</p>
                  </div>
                  <span className="text-sm font-bold" style={{ color: (a.score ?? 0) >= 70 ? "#22C55E" : (a.score ?? 0) >= 50 ? "#F59E0B" : "#EF4444" }}>{Math.round(a.score ?? 0)}/100</span>
                </div>
              ))}
            </div>
          )}
        </div>
      )}
    </div>
  )
}
