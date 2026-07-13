"use client"

import { useState, useEffect, useCallback } from "react"
import { useRouter } from "next/navigation"
import { createClient } from "@/lib/supabase/client"
import { Button } from "@/components/ui/button"
import { Progress } from "@/components/ui/progress"
import { Badge } from "@/components/ui/badge"
import { Card } from "@/components/ui/card"
import { cn } from "@/lib/utils"
import {
  Check, X, ChevronRight, RotateCcw,
  Trophy, Clock, Crown
} from "lucide-react"
import Link from "next/link"
import type { QuizQuestion, CpTier } from "@/types"
import toast from "react-hot-toast"

// Questions de démonstration (en production : depuis Supabase)
const DEMO_QUESTIONS: Record<string, QuizQuestion[]> = {
  "droit-penal": [
    {
      id: "1",
      text: "Quelle est la définition de l'infraction en droit pénal français ?",
      options: [
        "Tout acte contraire aux bonnes mœurs",
        "Tout fait qui trouble l'ordre public",
        "Tout comportement que la loi interdit et punit d'une sanction pénale",
        "Tout acte commis intentionnellement",
      ],
      correctIndex: 2,
      explanation: "L'infraction est un comportement défini par la loi qui est sanctionné par une peine. Elle comprend 3 éléments : légal, matériel et moral.",
    },
    {
      id: "2",
      text: "Parmi les catégories suivantes, laquelle correspond à un délit ?",
      options: [
        "Un homicide volontaire sans circonstances aggravantes",
        "Une contravention de 5e classe",
        "Un vol simple",
        "Le trafic de stupéfiants à grande échelle",
      ],
      correctIndex: 2,
      explanation: "Le vol simple est un délit puni de 3 ans d'emprisonnement et 45 000 € d'amende (art. 311-3 CP). L'homicide volontaire est un crime, les contraventions sont de 5e classe au maximum.",
    },
    {
      id: "3",
      text: "Quel est le délai de prescription de l'action publique pour un délit ?",
      options: ["1 an", "3 ans", "6 ans", "10 ans"],
      correctIndex: 2,
      explanation: "Depuis la loi du 27 février 2017, le délai de prescription des délits est de 6 ans à compter du jour où l'infraction a été commise.",
    },
    {
      id: "4",
      text: "L'élément moral de l'infraction correspond à :",
      options: [
        "La matérialité du fait punissable",
        "L'intention ou la négligence de l'auteur",
        "Le texte légal qui réprime l'acte",
        "Le résultat dommageable de l'acte",
      ],
      correctIndex: 1,
      explanation: "L'élément moral (ou psychologique) est constitué par l'intention coupable (dol général) ou la négligence/imprudence selon l'infraction.",
    },
    {
      id: "5",
      text: "La tentative de délit est punissable :",
      options: [
        "Dans tous les cas",
        "Uniquement si la loi le prévoit expressément",
        "Uniquement pour les crimes",
        "Jamais",
      ],
      correctIndex: 1,
      explanation: "Art. 121-4 CP : la tentative de délit n'est punissable que lorsqu'un texte le prévoit expressément, contrairement aux crimes toujours punissables en cas de tentative.",
    },
  ],
  "procedure-penale": [
    {
      id: "1",
      text: "Quelle est la durée maximale de la garde à vue de droit commun ?",
      options: ["12 heures", "24 heures", "48 heures", "72 heures"],
      correctIndex: 2,
      explanation: "La GAV de droit commun dure 24h renouvelable une fois par l'OPJ ou le procureur, soit 48h maximum (art. 63 CPP).",
    },
    {
      id: "2",
      text: "Qui peut renouveler une garde à vue de droit commun ?",
      options: ["L'OPJ seul", "Le procureur de la République", "Le juge d'instruction", "Le préfet"],
      correctIndex: 1,
      explanation: "Le renouvellement de la GAV de droit commun est autorisé par le procureur de la République (art. 63 al. 3 CPP), sauf dispositions spéciales.",
    },
    {
      id: "3",
      text: "Dans quel délai la personne gardée à vue doit-elle être informée de ses droits ?",
      options: [
        "Immédiatement lors du placement",
        "Dans l'heure suivant le placement",
        "Dans les 3 heures",
        "Avant la première audition uniquement",
      ],
      correctIndex: 0,
      explanation: "La notification des droits doit être immédiate lors du placement en GAV (art. 63-1 CPP) : droit à un avocat, à informer un proche, à être examiné par un médecin.",
    },
  ],
  "culture-generale": [
    {
      id: "1",
      text: "Quel article de la Constitution française proclame que « La France est une République indivisible, laïque, démocratique et sociale » ?",
      options: ["Article 1", "Article 2", "Article 3", "Article 5"],
      correctIndex: 0,
      explanation: "L'article 1er de la Constitution du 4 octobre 1958 définit les caractères fondamentaux de la République française.",
    },
    {
      id: "2",
      text: "Combien de départements comporte la France métropolitaine ?",
      options: ["96", "97", "95", "101"],
      correctIndex: 0,
      explanation: "La France métropolitaine compte 96 départements (numérotés de 01 à 95 plus le 2A et 2B pour la Corse). Les DOM/COM s'y ajoutent.",
    },
    {
      id: "3",
      text: "Quel est le nombre de membres du Conseil constitutionnel ?",
      options: ["7", "9", "11", "13"],
      correctIndex: 1,
      explanation: "Le Conseil constitutionnel est composé de 9 membres nommés pour 9 ans (3 par le Président de la République, 3 par le Président de l'Assemblée nationale, 3 par le Président du Sénat).",
    },
  ],
}

const DEFAULT_QUESTIONS: QuizQuestion[] = [
  {
    id: "default-1",
    text: "Ce module est en cours de chargement depuis Supabase.",
    options: ["Option A", "Option B", "Option C", "Option D"],
    correctIndex: 0,
    explanation: "Les questions seront chargées depuis la base de données Supabase.",
  },
]

interface QuizEngineProps {
  track: string
  moduleId: string
  userId: string
  tier: CpTier
}

type Phase = "idle" | "running" | "review" | "summary"

export function QuizEngine({ track, moduleId, userId, tier }: QuizEngineProps) {
  const router = useRouter()
  const supabase = createClient()

  const questions = DEMO_QUESTIONS[moduleId] ?? DEFAULT_QUESTIONS
  const [phase, setPhase] = useState<Phase>("idle")
  const [current, setCurrent] = useState(0)
  const [selected, setSelected] = useState<number | null>(null)
  const [answers, setAnswers] = useState<(number | null)[]>([])
  const [startTime, setStartTime] = useState<Date | null>(null)

  const question = questions[current]
  const totalQ = questions.length

  function startQuiz() {
    setAnswers(new Array(totalQ).fill(null))
    setCurrent(0)
    setSelected(null)
    setPhase("running")
    setStartTime(new Date())
  }

  function selectAnswer(idx: number) {
    if (phase !== "running" || selected !== null) return
    const newAnswers = [...answers]
    newAnswers[current] = idx
    setAnswers(newAnswers)
    setSelected(idx)
    setTimeout(() => setPhase("review"), 300)
  }

  const nextQuestion = useCallback(async () => {
    if (current + 1 < totalQ) {
      setCurrent((c) => c + 1)
      setSelected(null)
      setPhase("running")
    } else {
      // Sauvegarder en base
      const correctCount = answers.filter((a, i) => a === questions[i].correctIndex).length
      const score = Math.round((correctCount / totalQ) * 100)

      try {
        await (supabase as ReturnType<typeof createClient>).from("quiz_history" as never).insert({
          uid: userId,
          module_name: track.toUpperCase(),
          quiz_name: moduleId,
          score,
          total_questions: totalQ,
          correct_count: correctCount,
          started_at: startTime?.toISOString(),
          finished_at: new Date().toISOString(),
        } as never)
      } catch {
        // Quiz history may not exist — non bloquant
      }

      setPhase("summary")
    }
  }, [current, totalQ, answers, questions, supabase, userId, track, moduleId, startTime])

  const correctCount = answers.filter((a, i) => a === questions[i]?.correctIndex).length
  const score = totalQ > 0 ? Math.round((correctCount / totalQ) * 100) : 0

  // Phase d'accueil
  if (phase === "idle") {
    return (
      <div className="max-w-2xl mx-auto space-y-6 animate-fade-in">
        <div>
          <Link href={`/${track}/quiz`} className="text-sm text-[var(--on-surface-muted)] hover:text-[var(--on-surface)] transition-colors">
            ← Retour aux modules
          </Link>
        </div>
        <Card>
          <div className="text-center py-6">
            <div className="w-16 h-16 rounded-2xl bg-brand/10 flex items-center justify-center mx-auto mb-4">
              <Trophy size={28} className="text-brand" />
            </div>
            <h1 className="text-xl font-bold text-[var(--on-surface)] mb-2 capitalize">
              {moduleId.replace(/-/g, " ")}
            </h1>
            <p className="text-[var(--on-surface-muted)] text-sm mb-6">
              {totalQ} questions · Score de réussite : 70%
            </p>
            <div className="grid grid-cols-3 gap-4 mb-8 text-center">
              <div>
                <div className="text-2xl font-bold text-[var(--on-surface)]">{totalQ}</div>
                <div className="text-xs text-[var(--on-surface-faint)] mt-1">Questions</div>
              </div>
              <div>
                <div className="text-2xl font-bold text-[var(--on-surface)]">70%</div>
                <div className="text-xs text-[var(--on-surface-faint)] mt-1">Seuil réussite</div>
              </div>
              <div>
                <div className="text-2xl font-bold text-[var(--on-surface)]">~{Math.ceil(totalQ * 0.5)} min</div>
                <div className="text-xs text-[var(--on-surface-faint)] mt-1">Estimé</div>
              </div>
            </div>
            <Button size="lg" onClick={startQuiz}>
              Commencer le quiz
              <ChevronRight size={16} />
            </Button>
          </div>
        </Card>
      </div>
    )
  }

  // Phase résumé final
  if (phase === "summary") {
    const passed = score >= 70
    return (
      <div className="max-w-2xl mx-auto space-y-6 animate-slide-up">
        <Card>
          <div className="text-center py-6">
            <div className={cn(
              "w-20 h-20 rounded-full flex items-center justify-center mx-auto mb-4 text-white text-3xl font-bold",
              passed ? "bg-gradient-to-br from-success to-emerald-600" : "bg-gradient-to-br from-danger to-red-600"
            )}>
              {score}%
            </div>
            <h2 className="text-xl font-bold text-[var(--on-surface)] mb-1">
              {passed ? "Bravo ! Quiz réussi 🎉" : "Continuez vos révisions 💪"}
            </h2>
            <p className="text-[var(--on-surface-muted)] text-sm mb-6">
              {correctCount}/{totalQ} bonnes réponses · Seuil : 70%
            </p>

            <div className="grid grid-cols-3 gap-4 mb-8">
              {[
                { label: "Score", value: `${score}%`, color: passed ? "text-success" : "text-danger" },
                { label: "Correctes", value: correctCount, color: "text-success" },
                { label: "Erreurs", value: totalQ - correctCount, color: "text-danger" },
              ].map((s) => (
                <div key={s.label} className="p-3 rounded-xl bg-[var(--surface-container)]">
                  <div className={cn("text-2xl font-bold", s.color)}>{s.value}</div>
                  <div className="text-xs text-[var(--on-surface-faint)] mt-0.5">{s.label}</div>
                </div>
              ))}
            </div>

            <div className="flex gap-3 justify-center flex-wrap">
              <Button variant="secondary" onClick={startQuiz}>
                <RotateCcw size={14} />
                Recommencer
              </Button>
              <Button onClick={() => router.push(`/${track}/quiz`)}>
                Choisir un autre module
                <ChevronRight size={14} />
              </Button>
            </div>
          </div>
        </Card>

        {/* Révision rapide des erreurs */}
        <div className="space-y-3">
          <h3 className="text-sm font-semibold text-[var(--on-surface)]">Correction détaillée</h3>
          {questions.map((q, i) => {
            const isCorrect = answers[i] === q.correctIndex
            return (
              <Card key={q.id} className={cn(
                "border-l-4",
                isCorrect ? "border-l-success" : "border-l-danger"
              )}>
                <div className="flex items-start gap-3">
                  <div className={cn(
                    "w-6 h-6 rounded-full flex items-center justify-center shrink-0 mt-0.5",
                    isCorrect ? "bg-success/10" : "bg-danger/10"
                  )}>
                    {isCorrect
                      ? <Check size={12} className="text-success" />
                      : <X size={12} className="text-danger" />
                    }
                  </div>
                  <div className="flex-1">
                    <p className="text-sm font-medium text-[var(--on-surface)] mb-2">{q.text}</p>
                    {!isCorrect && (
                      <div className="space-y-1 mb-2">
                        <div className="text-xs text-danger">
                          Votre réponse : {answers[i] !== null ? q.options[answers[i]!] : "—"}
                        </div>
                        <div className="text-xs text-success">
                          Bonne réponse : {q.options[q.correctIndex]}
                        </div>
                      </div>
                    )}
                    {q.explanation && (
                      <p className="text-xs text-[var(--on-surface-muted)] leading-relaxed bg-[var(--surface-container)] p-2.5 rounded-lg">
                        {q.explanation}
                      </p>
                    )}
                  </div>
                </div>
              </Card>
            )
          })}
        </div>
      </div>
    )
  }

  // Phase quiz (running + review)
  return (
    <div className="max-w-2xl mx-auto space-y-5 animate-fade-in">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-2">
          <span className="text-sm text-[var(--on-surface-muted)]">
            {current + 1}/{totalQ}
          </span>
          <Progress value={current + 1} max={totalQ} size="sm" className="w-32" />
        </div>
        <div className="flex items-center gap-1.5 text-xs text-[var(--on-surface-faint)]">
          <Clock size={12} />
          En cours
        </div>
      </div>

      {/* Question */}
      <Card>
        <h2 className="text-base font-semibold text-[var(--on-surface)] leading-relaxed mb-5">
          {question?.text}
        </h2>

        <div className="space-y-2.5">
          {question?.options.map((option, idx) => {
            let state: "default" | "correct" | "wrong" = "default"
            if (phase === "review") {
              if (idx === question.correctIndex) state = "correct"
              else if (idx === selected) state = "wrong"
            }

            return (
              <button
                key={idx}
                onClick={() => selectAnswer(idx)}
                disabled={phase === "review"}
                className={cn(
                  "w-full text-left px-4 py-3 rounded-xl border text-sm font-medium transition-all duration-200",
                  state === "default" && "border-[var(--outline)] text-[var(--on-surface)] hover:border-brand hover:bg-brand/5 active:scale-[0.99]",
                  state === "correct" && "border-success bg-success/10 text-success",
                  state === "wrong" && "border-danger bg-danger/10 text-danger",
                  
                )}
              >
                <div className="flex items-center gap-3">
                  <span className={cn(
                    "w-6 h-6 rounded-full border flex items-center justify-center text-xs font-bold shrink-0",
                    state === "default" && "border-[var(--outline)] text-[var(--on-surface-faint)]",
                    state === "correct" && "border-success bg-success text-white",
                    state === "wrong" && "border-danger bg-danger text-white",
                  )}>
                    {state === "correct" ? <Check size={12} /> : state === "wrong" ? <X size={12} /> : String.fromCharCode(65 + idx)}
                  </span>
                  {option}
                </div>
              </button>
            )
          })}
        </div>
      </Card>

      {/* Explication + bouton suivant */}
      {phase === "review" && (
        <div className="space-y-3 animate-slide-up">
          {question?.explanation && (
            <div className="p-4 rounded-xl bg-[var(--surface-container)] border border-[var(--outline)]">
              <div className="text-xs font-semibold text-[var(--on-surface-muted)] mb-1.5 uppercase tracking-wide">Explication</div>
              <p className="text-sm text-[var(--on-surface)] leading-relaxed">{question.explanation}</p>
            </div>
          )}
          <Button className="w-full" onClick={nextQuestion}>
            {current + 1 < totalQ ? "Question suivante" : "Voir les résultats"}
            <ChevronRight size={16} />
          </Button>
        </div>
      )}
    </div>
  )
}
