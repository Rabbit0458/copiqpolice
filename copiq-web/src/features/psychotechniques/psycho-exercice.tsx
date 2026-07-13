"use client"
import { useState, useEffect, useCallback } from "react"
import { Timer, CheckCircle, XCircle, RotateCcw, ChevronRight } from "lucide-react"

// Exercise generators
function genCalcul() {
  const ops = ["+", "-", "×", "÷"]
  const op = ops[Math.floor(Math.random() * ops.length)]
  let a: number, b: number, answer: number
  switch (op) {
    case "+": a = Math.floor(Math.random() * 99) + 1; b = Math.floor(Math.random() * 99) + 1; answer = a + b; break
    case "-": a = Math.floor(Math.random() * 99) + 20; b = Math.floor(Math.random() * (a - 1)) + 1; answer = a - b; break
    case "×": a = Math.floor(Math.random() * 12) + 2; b = Math.floor(Math.random() * 12) + 2; answer = a * b; break
    case "÷": b = Math.floor(Math.random() * 11) + 2; answer = Math.floor(Math.random() * 10) + 2; a = b * answer; break
    default: a = 1; b = 1; answer = 2
  }
  const wrong = [answer + Math.floor(Math.random() * 5) + 1, answer - Math.floor(Math.random() * 5) - 1, answer + Math.floor(Math.random() * 10) + 5]
  const choices = [...new Set([answer, ...wrong.filter(w => w > 0)])].slice(0, 4).sort(() => Math.random() - 0.5)
  return { question: `${a} ${op} ${b} = ?`, answer, choices }
}

function genSuiteLogique() {
  const start = Math.floor(Math.random() * 5) + 1
  const step = Math.floor(Math.random() * 4) + 2
  const sequence = [start, start + step, start + step * 2, start + step * 3, start + step * 4]
  const answer = start + step * 5
  const choices = [answer, answer + step, answer - step, answer + Math.floor(step / 2)].sort(() => Math.random() - 0.5)
  return { question: `${sequence.join(" — ")} — ?`, answer, choices }
}

function genRaisonnement() {
  const syllogismes = [
    { question: "Tous les policiers portent un uniforme. Pierre est policier.", answer: "Pierre porte un uniforme", choices: ["Pierre porte un uniforme", "Pierre est en civil", "On ne peut pas savoir", "Pierre ne porte pas d'uniforme"] },
    { question: "Aucun suspect n'est libre. Marc est suspect.", answer: "Marc n'est pas libre", choices: ["Marc est libre", "Marc n'est pas libre", "Marc peut être libre", "On ne sait pas"] },
    { question: "Certains agents sont en mission. Tous les agents sont formés.", answer: "Certains agents formés sont en mission", choices: ["Tous les agents sont en mission", "Certains agents formés sont en mission", "Aucun agent n'est en mission", "On ne peut pas conclure"] },
  ]
  return syllogismes[Math.floor(Math.random() * syllogismes.length)]
}

type GenFn = () => { question: string; answer: string | number; choices: (string | number)[] }

const GENERATORS: Partial<Record<string, GenFn>> = {
  calcul: genCalcul as GenFn,
  "suites-logiques": genSuiteLogique as GenFn,
  raisonnement: genRaisonnement as GenFn,
}

export default function PsychoExercice({ type, label, tier }: { type: string; label: string; tier: string }) {
  const [score, setScore] = useState(0)
  const [total, setTotal] = useState(0)
  const [timeLeft, setTimeLeft] = useState(60)
  const [running, setRunning] = useState(false)
  const [finished, setFinished] = useState(false)
  const [current, setCurrent] = useState<ReturnType<GenFn> | null>(null)
  const [selected, setSelected] = useState<string | number | null>(null)
  const [feedback, setFeedback] = useState<"correct" | "wrong" | null>(null)

  const gen = GENERATORS[type]

  const nextQuestion = useCallback(() => {
    if (!gen) return
    setSelected(null)
    setFeedback(null)
    setCurrent(gen())
  }, [gen])

  useEffect(() => {
    if (!running || finished) return
    const interval = setInterval(() => {
      setTimeLeft(t => {
        if (t <= 1) { setFinished(true); setRunning(false); return 0 }
        return t - 1
      })
    }, 1000)
    return () => clearInterval(interval)
  }, [running, finished])

  function start() {
    setScore(0); setTotal(0); setTimeLeft(60); setFinished(false); setSelected(null); setFeedback(null)
    setRunning(true)
    nextQuestion()
  }

  function handleSelect(choice: string | number) {
    if (selected !== null || !current) return
    setSelected(choice)
    const correct = choice === current.answer || String(choice) === String(current.answer)
    setFeedback(correct ? "correct" : "wrong")
    setTotal(t => t + 1)
    if (correct) setScore(s => s + 1)
    setTimeout(nextQuestion, 900)
  }

  if (!gen) {
    return (
      <div className="rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-8 text-center">
        <p className="text-[var(--on-surface-muted)] text-sm">Ce type d&apos;exercice arrive bientôt !</p>
      </div>
    )
  }

  if (!running && !finished) {
    return (
      <div className="rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-8 text-center">
        <div className="text-5xl mb-4">🧠</div>
        <h1 className="text-2xl font-bold text-[var(--on-surface)] mb-2">{label}</h1>
        <p className="text-[var(--on-surface-muted)] text-sm mb-6">Répondez à un maximum de questions en 60 secondes. Score calculé en temps réel.</p>
        <button onClick={start} className="px-8 py-3.5 rounded-xl bg-[#1147D9] text-white font-bold hover:bg-[#1A55E6] transition-all">
          Commencer l&apos;exercice
        </button>
      </div>
    )
  }

  if (finished) {
    const pct = total > 0 ? Math.round((score / total) * 100) : 0
    return (
      <div className="rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-8 text-center">
        <div className="text-5xl mb-4">{pct >= 80 ? "🎉" : pct >= 60 ? "👍" : "💪"}</div>
        <h2 className="text-2xl font-bold text-[var(--on-surface)] mb-1">Temps écoulé !</h2>
        <div className="text-5xl font-black mb-2" style={{ color: pct >= 80 ? "#22C55E" : pct >= 60 ? "#F59E0B" : "#EF4444" }}>{pct}%</div>
        <p className="text-[var(--on-surface-muted)] mb-1">{score} bonnes réponses sur {total} questions</p>
        <p className="text-xs text-[var(--on-surface-faint)] mb-6">{pct >= 80 ? "Excellent ! Passez aux exercices suivants." : pct >= 60 ? "Bon résultat. Continuez à vous entraîner." : "Encouragez-vous ! La régularité paye."}</p>
        <button onClick={start} className="flex items-center gap-2 px-6 py-3 rounded-xl bg-[#1147D9] text-white font-bold hover:bg-[#1A55E6] transition-all mx-auto">
          <RotateCcw size={16} /> Recommencer
        </button>
      </div>
    )
  }

  return (
    <div className="space-y-4">
      {/* Timer bar */}
      <div className="rounded-xl border border-[var(--outline)] bg-[var(--surface)] p-4 flex items-center gap-4">
        <Timer size={16} className={timeLeft <= 10 ? "text-red-500" : "text-[#1147D9]"} />
        <div className="flex-1 h-2 rounded-full bg-[var(--surface-dark)] overflow-hidden">
          <div className="h-full rounded-full transition-all" style={{ width: `${(timeLeft / 60) * 100}%`, backgroundColor: timeLeft <= 10 ? "#EF4444" : "#1147D9" }} />
        </div>
        <span className={`text-sm font-bold tabular-nums ${timeLeft <= 10 ? "text-red-500" : "text-[var(--on-surface)]"}`}>{timeLeft}s</span>
        <span className="text-sm text-[var(--on-surface-muted)]">{score}/{total}</span>
      </div>
      {/* Question */}
      {current && (
        <div className="rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-6">
          <p className="text-xl font-bold text-[var(--on-surface)] text-center mb-6 leading-relaxed">{current.question}</p>
          <div className="grid grid-cols-2 gap-3">
            {current.choices.map((choice, i) => {
              const isSelected = selected === choice || String(selected) === String(choice)
              const isCorrect = choice === current.answer || String(choice) === String(current.answer)
              let cls = "w-full py-4 px-4 rounded-xl border text-sm font-semibold transition-all text-center "
              if (selected !== null) {
                if (isCorrect) cls += "border-[#22C55E] bg-[#22C55E]/10 text-[#22C55E]"
                else if (isSelected) cls += "border-red-500 bg-red-500/10 text-red-500"
                else cls += "border-[var(--outline)] text-[var(--on-surface-faint)] opacity-50"
              } else {
                cls += "border-[var(--outline)] text-[var(--on-surface)] hover:border-[#1147D9]/40 hover:bg-[#1147D9]/5 cursor-pointer"
              }
              return (
                <button key={i} onClick={() => handleSelect(choice)} disabled={selected !== null} className={cls}>
                  {String(choice)}
                </button>
              )
            })}
          </div>
          {feedback && (
            <div className={`flex items-center justify-center gap-2 mt-4 text-sm font-semibold ${feedback === "correct" ? "text-[#22C55E]" : "text-red-500"}`}>
              {feedback === "correct" ? <CheckCircle size={16} /> : <XCircle size={16} />}
              {feedback === "correct" ? "Correct !" : `Réponse : ${current.answer}`}
            </div>
          )}
        </div>
      )}
    </div>
  )
}
