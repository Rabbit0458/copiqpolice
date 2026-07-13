"use client"
import { useState, useEffect } from "react"
import { Timer, PlayCircle, CheckCircle, RotateCcw, FileText } from "lucide-react"

const PA_CONCOURS_QUESTIONS = [
  { id: 1, q: "Quelle est la peine maximale pour un délit ?", choices: ["5 ans", "10 ans", "20 ans", "Perpétuité"], answer: 1, explanation: "Les délits sont punis de peines d'emprisonnement allant jusqu'à 10 ans (art. 131-3 CP)." },
  { id: 2, q: "Devant quelle juridiction sont jugés les crimes ?", choices: ["Tribunal correctionnel", "Tribunal de police", "Cour d'assises", "Cour d'appel"], answer: 2, explanation: "Les crimes relèvent de la compétence de la Cour d'assises, composée de magistrats et d'un jury populaire." },
  { id: 3, q: "Quelle est la durée maximale d'une garde à vue en droit commun ?", choices: ["24h", "48h", "72h", "96h"], answer: 1, explanation: "En droit commun, la GAV dure 24h + 24h sur autorisation du parquet = 48h maximum." },
  { id: 4, q: "L'article 122-5 du Code pénal traite de :", choices: ["L'état de nécessité", "La légitime défense", "L'irresponsabilité pénale", "La tentative"], answer: 1, explanation: "L'article 122-5 CP définit la légitime défense : réponse nécessaire et proportionnée à une agression injuste et actuelle." },
  { id: 5, q: "Combien de classes de contraventions existent-il ?", choices: ["3", "4", "5", "6"], answer: 2, explanation: "Les contraventions sont divisées en 5 classes (art. 131-13 CP), de la 1ère à la 5ème, selon la gravité." },
  { id: 6, q: "La tentative est punissable pour :", choices: ["Les contraventions seulement", "Les délits seulement", "Les crimes et délits", "Toutes les infractions"], answer: 2, explanation: "Art. 121-4 CP : la tentative de crime est toujours punissable, la tentative de délit l'est seulement si la loi le prévoit expressément. La tentative de contravention n'est jamais punissable." },
  { id: 7, q: "Le complice est puni :", choices: ["Moins que l'auteur", "Comme l'auteur", "Plus que l'auteur", "Selon les circonstances"], answer: 1, explanation: "Art. 121-6 CP : le complice est puni comme auteur. Il encourt les mêmes peines que l'auteur principal." },
  { id: 8, q: "L'enquête de flagrance peut durer :", choices: ["24h", "48h", "8 jours", "15 jours"], answer: 2, explanation: "L'enquête de flagrance dure 8 jours, prorogeables de 8 jours supplémentaires en cas d'enquête complexe sur autorisation du Parquet." },
  { id: 9, q: "Quel est le principe de légalité en droit pénal ?", choices: ["Nul ne peut être jugé deux fois", "Pas d'infraction sans texte", "La présomption d'innocence", "L'égalité devant la loi"], answer: 1, explanation: "Nullum crimen sine lege : pas de crime, pas de délit sans loi. L'infraction doit être prévue et définie par un texte." },
  { id: 10, q: "Le Président de la République est élu pour :", choices: ["4 ans", "5 ans", "6 ans", "7 ans"], answer: 1, explanation: "Depuis la révision constitutionnelle de 2000 (quinquennat), le Président est élu pour 5 ans au suffrage universel direct." },
]

type Phase = "setup" | "running" | "review" | "summary"

export default function ConcoursBlancInterface({ userId }: { userId: string }) {
  const [phase, setPhase] = useState<Phase>("setup")
  const [type, setType] = useState<"pa" | "gpx">("pa")
  const [answers, setAnswers] = useState<(number | null)[]>(new Array(PA_CONCOURS_QUESTIONS.length).fill(null))
  const [currentQ, setCurrentQ] = useState(0)
  const [timeLeft, setTimeLeft] = useState(30 * 60) // 30 min
  const [showExplanation, setShowExplanation] = useState(false)
  const questions = PA_CONCOURS_QUESTIONS

  useEffect(() => {
    if (phase !== "running") return
    const interval = setInterval(() => {
      setTimeLeft(t => {
        if (t <= 1) { setPhase("summary"); return 0 }
        return t - 1
      })
    }, 1000)
    return () => clearInterval(interval)
  }, [phase])

  function formatTime(s: number) {
    const m = Math.floor(s / 60)
    const sec = s % 60
    return `${m}:${sec.toString().padStart(2, "0")}`
  }

  function handleAnswer(idx: number) {
    const updated = [...answers]
    updated[currentQ] = idx
    setAnswers(updated)
    if (currentQ < questions.length - 1) {
      setTimeout(() => { setCurrentQ(c => c + 1); setShowExplanation(false) }, 400)
    }
  }

  function finish() { setPhase("summary") }
  function reset() { setPhase("setup"); setAnswers(new Array(questions.length).fill(null)); setCurrentQ(0); setTimeLeft(30 * 60); setShowExplanation(false) }

  const score = answers.filter((a, i) => a === questions[i]?.answer).length
  const scorePct = Math.round((score / questions.length) * 100)

  if (phase === "setup") return (
    <div className="max-w-2xl mx-auto px-4 py-8 text-center">
      <FileText size={40} className="text-[#1147D9] mx-auto mb-4" />
      <h1 className="text-2xl font-bold text-[var(--on-surface)] mb-2">Concours Blanc</h1>
      <p className="text-[var(--on-surface-muted)] text-sm mb-6">Simulez les conditions du concours : timer 30 minutes, {questions.length} questions, correction détaillée.</p>
      <div className="flex gap-3 justify-center mb-6">
        {(["pa", "gpx"] as const).map(t => (
          <button key={t} onClick={() => setType(t)} className={`px-5 py-2.5 rounded-xl border text-sm font-semibold transition-all ${type === t ? "bg-[#1147D9] border-[#1147D9] text-white" : "border-[var(--outline)] text-[var(--on-surface)] hover:border-[#1147D9]/40"}`}>
            {t.toUpperCase()}
          </button>
        ))}
      </div>
      <button onClick={() => setPhase("running")} className="flex items-center gap-2 px-8 py-3.5 rounded-xl bg-[#1147D9] text-white font-bold hover:bg-[#1A55E6] transition-all mx-auto">
        <PlayCircle size={20} />Lancer le concours blanc
      </button>
    </div>
  )

  if (phase === "summary") {
    return (
      <div className="max-w-2xl mx-auto px-4 py-8">
        <div className="rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-8 text-center mb-6">
          <div className="text-6xl mb-3">{scorePct >= 80 ? "🏆" : scorePct >= 60 ? "👍" : "💪"}</div>
          <h2 className="text-2xl font-bold text-[var(--on-surface)] mb-1">Résultat final</h2>
          <div className="text-5xl font-black my-3" style={{ color: scorePct >= 80 ? "#22C55E" : scorePct >= 60 ? "#F59E0B" : "#EF4444" }}>{scorePct}%</div>
          <p className="text-[var(--on-surface-muted)]">{score}/{questions.length} bonnes réponses</p>
          <div className="flex gap-3 justify-center mt-6">
            <button onClick={() => setPhase("review")} className="px-5 py-2.5 rounded-xl border border-[var(--outline)] text-sm font-semibold text-[var(--on-surface)] hover:bg-[var(--surface-dark)] transition-all">Voir la correction</button>
            <button onClick={reset} className="flex items-center gap-2 px-5 py-2.5 rounded-xl bg-[#1147D9] text-white text-sm font-semibold hover:bg-[#1A55E6] transition-all"><RotateCcw size={14} />Recommencer</button>
          </div>
        </div>
      </div>
    )
  }

  if (phase === "review") {
    return (
      <div className="max-w-2xl mx-auto px-4 py-8 space-y-4">
        <div className="flex items-center justify-between mb-2">
          <h2 className="text-xl font-bold text-[var(--on-surface)]">Correction détaillée</h2>
          <button onClick={reset} className="text-sm text-[#1147D9] hover:underline">Nouveau concours</button>
        </div>
        {questions.map((q, qi) => {
          const userAnswer = answers[qi]
          const correct = userAnswer === q.answer
          return (
            <div key={q.id} className={`rounded-xl border p-5 ${correct ? "border-[#22C55E]/30 bg-[#22C55E]/5" : "border-red-500/30 bg-red-500/5"}`}>
              <div className="flex items-start gap-2 mb-3">
                {correct ? <CheckCircle size={16} className="text-[#22C55E] mt-0.5 flex-shrink-0" /> : <span className="w-4 h-4 rounded-full bg-red-500 flex-shrink-0 mt-0.5" />}
                <p className="text-sm font-semibold text-[var(--on-surface)]">{qi + 1}. {q.q}</p>
              </div>
              {!correct && userAnswer !== null && (
                <p className="text-xs text-red-500 mb-1">Votre réponse : {q.choices[userAnswer]}</p>
              )}
              <p className="text-xs text-[#22C55E] mb-2">Bonne réponse : {q.choices[q.answer]}</p>
              <p className="text-xs text-[var(--on-surface-muted)] italic">{q.explanation}</p>
            </div>
          )
        })}
      </div>
    )
  }

  const q = questions[currentQ]
  return (
    <div className="max-w-2xl mx-auto px-4 py-8">
      {/* Timer */}
      <div className="flex items-center justify-between mb-4">
        <span className="text-sm text-[var(--on-surface-muted)]">Question {currentQ + 1}/{questions.length}</span>
        <div className={`flex items-center gap-1.5 px-3 py-1.5 rounded-full text-sm font-bold ${timeLeft <= 120 ? "bg-red-500/10 text-red-500" : "bg-[var(--surface-dark)] text-[var(--on-surface)]"}`}>
          <Timer size={13} />{formatTime(timeLeft)}
        </div>
        <button onClick={finish} className="text-xs text-[var(--on-surface-muted)] hover:text-[var(--on-surface)] transition-colors">Terminer</button>
      </div>
      {/* Progress */}
      <div className="h-1.5 rounded-full bg-[var(--surface-dark)] overflow-hidden mb-6">
        <div className="h-full rounded-full bg-[#1147D9] transition-all" style={{ width: `${((currentQ + 1) / questions.length) * 100}%` }} />
      </div>
      {/* Question */}
      <div className="rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-6">
        <p className="text-lg font-bold text-[var(--on-surface)] mb-6 leading-snug">{q.q}</p>
        <div className="space-y-3">
          {q.choices.map((choice, ci) => {
            const selected = answers[currentQ] === ci
            const correct = ci === q.answer
            let cls = "w-full text-left px-4 py-3.5 rounded-xl border text-sm font-medium transition-all "
            if (selected) cls += correct ? "border-[#22C55E] bg-[#22C55E]/10 text-[#22C55E]" : "border-red-500 bg-red-500/10 text-red-500"
            else cls += "border-[var(--outline)] text-[var(--on-surface)] hover:border-[#1147D9]/40 hover:bg-[#1147D9]/5"
            return (
              <button key={ci} onClick={() => handleAnswer(ci)} disabled={answers[currentQ] !== null} className={cls}>
                <span className="font-bold mr-2">{String.fromCharCode(65 + ci)}.</span>{choice}
              </button>
            )
          })}
        </div>
        {answers[currentQ] !== null && (
          <div className="mt-4 p-3 rounded-xl bg-[var(--surface-dark)] text-xs text-[var(--on-surface-muted)]">
            <strong className="text-[var(--on-surface)]">Explication :</strong> {q.explanation}
          </div>
        )}
        {currentQ < questions.length - 1 && answers[currentQ] !== null && (
          <button onClick={() => { setCurrentQ(c => c + 1); setShowExplanation(false) }} className="w-full mt-4 py-2.5 rounded-xl bg-[#1147D9] text-white font-semibold text-sm hover:bg-[#1A55E6] transition-all">
            Question suivante →
          </button>
        )}
        {currentQ === questions.length - 1 && answers[currentQ] !== null && (
          <button onClick={finish} className="w-full mt-4 py-2.5 rounded-xl bg-[#22C55E] text-white font-semibold text-sm hover:bg-[#16A34A] transition-all">
            Voir les résultats →
          </button>
        )}
      </div>
    </div>
  )
}
