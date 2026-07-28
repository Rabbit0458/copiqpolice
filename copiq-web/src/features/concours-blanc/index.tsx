"use client"
import { useState, useEffect } from "react"
import { Timer, PlayCircle, CheckCircle, RotateCcw, ChevronLeft, ChevronRight, X, AlertCircle } from "lucide-react"

// ─── Questions PA ─────────────────────────────────────────────────────────────

const PA_QUESTIONS = [
  {
    id: 1,
    q: "Quelle est la peine maximale pour un délit ?",
    choices: ["5 ans", "10 ans", "20 ans", "Perpétuité"],
    answer: 1,
    explanation: "Les délits sont punis de peines d'emprisonnement allant jusqu'à 10 ans (art. 131-3 CP).",
  },
  {
    id: 2,
    q: "Devant quelle juridiction sont jugés les crimes ?",
    choices: ["Tribunal correctionnel", "Tribunal de police", "Cour d'assises", "Cour d'appel"],
    answer: 2,
    explanation: "Les crimes relèvent de la compétence de la Cour d'assises, composée de magistrats et d'un jury populaire.",
  },
  {
    id: 3,
    q: "Durée maximale GAV droit commun ?",
    choices: ["24h", "48h", "72h", "96h"],
    answer: 1,
    explanation: "En droit commun, la GAV dure 24h + 24h sur autorisation du parquet = 48h maximum.",
  },
  {
    id: 4,
    q: "L'article 122-5 CP traite de ?",
    choices: ["L'état de nécessité", "La légitime défense", "La tentative", "La complicité"],
    answer: 1,
    explanation: "L'article 122-5 CP définit la légitime défense : réponse nécessaire et proportionnée à une agression injuste et actuelle.",
  },
  {
    id: 5,
    q: "Combien de classes de contraventions ?",
    choices: ["3 classes", "4 classes", "5 classes", "6 classes"],
    answer: 2,
    explanation: "Les contraventions sont divisées en 5 classes (art. 131-13 CP), de la 1ère à la 5ème, selon la gravité.",
  },
  {
    id: 6,
    q: "La tentative est punissable pour ?",
    choices: ["Les contraventions", "Les délits seulement", "Crimes et délits", "Toutes les infractions"],
    answer: 2,
    explanation: "Art. 121-4 CP : la tentative de crime est toujours punissable, la tentative de délit l'est si la loi le prévoit expressément. La tentative de contravention n'est jamais punissable.",
  },
  {
    id: 7,
    q: "Le complice est puni ?",
    choices: ["Moins que l'auteur", "Comme l'auteur", "Plus que l'auteur", "Selon l'infraction"],
    answer: 1,
    explanation: "Art. 121-6 CP : le complice est puni comme auteur. Il encourt les mêmes peines que l'auteur principal.",
  },
  {
    id: 8,
    q: "Durée enquête flagrance ?",
    choices: ["24h", "48h", "8 jours (prorogeables)", "15 jours"],
    answer: 2,
    explanation: "L'enquête de flagrance dure 8 jours, prorogeables de 8 jours supplémentaires en cas d'enquête complexe sur autorisation du Parquet.",
  },
  {
    id: 9,
    q: "Principe de légalité en droit pénal ?",
    choices: ["Nul ne peut être jugé deux fois", "Pas d'infraction sans texte", "La présomption d'innocence", "L'égalité devant la loi"],
    answer: 1,
    explanation: "Nullum crimen sine lege : pas de crime, pas de délit sans loi. L'infraction doit être prévue et définie par un texte.",
  },
  {
    id: 10,
    q: "Durée du mandat du Président ?",
    choices: ["4 ans", "5 ans", "6 ans", "7 ans"],
    answer: 1,
    explanation: "Depuis la révision constitutionnelle de 2000 (quinquennat), le Président est élu pour 5 ans au suffrage universel direct.",
  },
  {
    id: 11,
    q: "Qu'est-ce que la récidive ?",
    choices: [
      "Première infraction grave",
      "Commettre une nouvelle infraction après condamnation définitive",
      "Participation à une infraction",
      "Infraction non intentionnelle",
    ],
    answer: 1,
    explanation: "La récidive se caractérise par la commission d'une nouvelle infraction après avoir subi une condamnation pénale définitive.",
  },
  {
    id: 12,
    q: "Qui autorise la prolongation de la GAV ?",
    choices: ["Le juge d'instruction", "Le procureur de la République", "Le préfet", "Le ministre de l'Intérieur"],
    answer: 1,
    explanation: "C'est le procureur de la République qui peut autoriser la prolongation de la GAV pour une durée supplémentaire de 24h.",
  },
  {
    id: 13,
    q: "Art. 40 CPP oblige qui ?",
    choices: [
      "Tout citoyen",
      "Tout fonctionnaire ayant connaissance d'un crime ou délit",
      "Les OPJ uniquement",
      "Les juges d'instruction",
    ],
    answer: 1,
    explanation: "L'article 40 CPP impose à tout fonctionnaire ou agent public ayant connaissance d'un crime ou délit d'en informer le procureur de la République.",
  },
  {
    id: 14,
    q: "Quelle est la définition d'un flagrant délit ?",
    choices: [
      "Infraction prémédités",
      "Infraction commise il y a plus de 24h",
      "Infraction en train de se commettre ou venant de se commettre",
      "Infraction planifiée",
    ],
    answer: 2,
    explanation: "Le flagrant délit (art. 53 CPP) est l'infraction qui se commet actuellement ou qui vient de se commettre, permettant des actes d'enquête immédiats.",
  },
  {
    id: 15,
    q: "L'OPJ peut-il perquisitionner sans mandat ?",
    choices: ["Non, jamais", "Oui, en flagrant délit", "Seulement la nuit", "Avec autorisation du préfet"],
    answer: 1,
    explanation: "En enquête de flagrance, l'OPJ peut procéder à des perquisitions et saisies sans mandat préalable du juge (art. 56 CPP).",
  },
  {
    id: 16,
    q: "Quel est le rôle du procureur ?",
    choices: [
      "Juger les affaires pénales",
      "Diriger l'enquête et exercer l'action publique",
      "Défendre les prévenus",
      "Ordonner les arrestations",
    ],
    answer: 1,
    explanation: "Le procureur de la République dirige l'enquête de police judiciaire et est le titulaire de l'action publique au nom de la société.",
  },
  {
    id: 17,
    q: "Art. 73 CPP concerne ?",
    choices: ["La garde à vue", "L'interpellation par tout citoyen en flagrance", "La perquisition", "Le contrôle d'identité"],
    answer: 1,
    explanation: "L'article 73 CPP permet à tout citoyen d'appréhender l'auteur d'un crime ou délit flagrant et de le conduire devant l'OPJ le plus proche.",
  },
  {
    id: 18,
    q: "Qu'est-ce qu'un crime contre l'humanité ?",
    choices: [
      "Crime économique grave",
      "Crime imprescriptible contre un groupe de personnes",
      "Crime commis en temps de guerre",
      "Atteinte à l'environnement",
    ],
    answer: 1,
    explanation: "Le crime contre l'humanité est un crime imprescriptible visant à l'extermination, à la réduction en esclavage ou à la persécution d'un groupe de population civile.",
  },
  {
    id: 19,
    q: "La peine minimale pour un crime est ?",
    choices: ["5 ans de réclusion", "10 ans de réclusion", "15 ans de réclusion criminelle", "20 ans de réclusion"],
    answer: 2,
    explanation: "Le Code pénal prévoit une peine minimale de réclusion criminelle de 15 ans pour les crimes, avec des peines pouvant aller jusqu'à la perpétuité.",
  },
  {
    id: 20,
    q: "Qu'est-ce que la mise en examen ?",
    choices: [
      "La condamnation définitive",
      "La mise en cause formelle par le juge d'instruction",
      "L'arrestation provisoire",
      "La comparution immédiate",
    ],
    answer: 1,
    explanation: "La mise en examen (anciennement inculpation) est la décision du juge d'instruction de mettre en cause formellement une personne, lui donnant ce statut procédural.",
  },
]

// ─── Questions GPX ────────────────────────────────────────────────────────────

const GPX_QUESTIONS = [
  {
    id: 1,
    q: "Qu'est-ce que la déontologie policière ?",
    choices: [
      "Code vestimentaire de la police",
      "Ensemble des règles morales et professionnelles de la police",
      "Droit pénal applicable aux policiers",
      "Formation initiale des gardiens",
    ],
    answer: 1,
    explanation: "La déontologie policière regroupe l'ensemble des règles morales, éthiques et professionnelles que doivent respecter les membres de la police nationale.",
  },
  {
    id: 2,
    q: "Art. 122-5 CP définit ?",
    choices: ["L'état de nécessité", "La légitime défense", "La tentative", "La récidive"],
    answer: 1,
    explanation: "L'article 122-5 CP définit la légitime défense, qui exonère de responsabilité pénale l'auteur d'un acte commandé par la nécessité de se défendre ou de défendre autrui.",
  },
  {
    id: 3,
    q: "L'usage d'arme à feu est encadré par ?",
    choices: ["Art. L.431-1 CSI", "Art. L.435-1 CSI", "Art. L.440-2 CSI", "Art. L.412-3 CSI"],
    answer: 1,
    explanation: "L'article L.435-1 du Code de la Sécurité Intérieure encadre strictement les conditions dans lesquelles les agents de la police nationale peuvent faire usage de leur arme à feu.",
  },
  {
    id: 4,
    q: "Qu'est-ce qu'une circonstance aggravante ?",
    choices: ["Élément diminuant la peine", "Élément majorant la peine prévue", "Cause d'exonération pénale", "Circonstance atténuante"],
    answer: 1,
    explanation: "Une circonstance aggravante est un élément de fait ou de droit qui augmente la peine normalement applicable à une infraction donnée.",
  },
  {
    id: 5,
    q: "La complicité par instigation se caractérise par ?",
    choices: [
      "Aide matérielle à l'infraction",
      "Provocation ou instruction pour commettre l'infraction",
      "Présence sur les lieux",
      "Complicité après les faits",
    ],
    answer: 1,
    explanation: "La complicité par instigation (art. 121-7 CP) consiste à provoquer une personne à commettre une infraction par dons, menaces, abus d'autorité ou à lui en donner les instructions.",
  },
  {
    id: 6,
    q: "Qu'est-ce que le crime organisé ?",
    choices: [
      "Crime commis par deux personnes",
      "Infraction commise par un groupe structuré d'au moins 3 personnes",
      "Tout crime prémédité",
      "Crime commis avec violence",
    ],
    answer: 1,
    explanation: "Le crime organisé implique un groupe structuré d'au moins 3 personnes agissant de concert en vue de commettre des infractions graves pour en tirer profit.",
  },
  {
    id: 7,
    q: "Qu'est-ce qu'un PV de constatations ?",
    choices: [
      "Rapport d'enquête interne",
      "Document acte officiel des faits constatés sur les lieux",
      "Déclaration d'un témoin",
      "Rapport médical de blessure",
    ],
    answer: 1,
    explanation: "Le procès-verbal de constatations est un acte officiel de police judiciaire qui décrit de manière précise les faits, lieux et indices constatés lors d'une intervention.",
  },
  {
    id: 8,
    q: "L'audition libre ?",
    choices: ["Audition en garde à vue", "Entendre une personne sans la placer en GAV", "Interrogatoire sous contrainte", "Audition de mineurs"],
    answer: 1,
    explanation: "L'audition libre (art. 61-1 CPP) permet d'entendre toute personne suspectée d'avoir commis une infraction sans la placer en garde à vue, sous réserve d'un cadre légal précis.",
  },
  {
    id: 9,
    q: "Différence contravention / délit ?",
    choices: [
      "Aucune différence",
      "Contravention: max 3000€ amende. Délit: jusqu'à 10 ans",
      "Délit: max 1500€, Contravention: plus grave",
      "Identiques en terme de peine",
    ],
    answer: 1,
    explanation: "Les contraventions (5 classes, max 3000€) sont jugées au tribunal de police, tandis que les délits (peine max 10 ans) relèvent du tribunal correctionnel.",
  },
  {
    id: 10,
    q: "Art. 78-1 CPP concerne ?",
    choices: ["La GAV", "Le contrôle d'identité", "La perquisition", "L'arrestation"],
    answer: 1,
    explanation: "L'article 78-1 CPP fixe le droit pour tout officier ou agent de police judiciaire de procéder à des contrôles d'identité dans les conditions légalement prévues.",
  },
  {
    id: 11,
    q: "Qu'est-ce que la réquisition judiciaire ?",
    choices: [
      "Ordre du procureur d'arrêter",
      "Demande d'un OPJ à un tiers de prêter son concours",
      "Saisie d'un bien",
      "Convocation au tribunal",
    ],
    answer: 1,
    explanation: "La réquisition judiciaire est la demande adressée par un OPJ à un tiers (médecin, expert, etc.) de lui prêter son concours dans le cadre d'une enquête judiciaire.",
  },
  {
    id: 12,
    q: "La garde à vue peut être accordée à ?",
    choices: [
      "Toute personne",
      "Toute personne suspectée d'une infraction passible de prison",
      "Les majeurs seulement",
      "Les récidivistes uniquement",
    ],
    answer: 1,
    explanation: "La GAV peut être décidée par un OPJ à l'égard de toute personne soupçonnée d'avoir commis une infraction punissable d'emprisonnement.",
  },
  {
    id: 13,
    q: "Qu'est-ce que l'état de nécessité (art. 122-7) ?",
    choices: [
      "Légitime défense",
      "Acte nécessaire pour éviter un danger grave et imminent",
      "État d'urgence national",
      "Mesure d'exception",
    ],
    answer: 1,
    explanation: "L'état de nécessité exonère de responsabilité pénale lorsqu'une personne commet une infraction pour éviter un danger grave et imminent, à condition que les moyens employés soient proportionnés.",
  },
  {
    id: 14,
    q: "Le déni de justice est ?",
    choices: ["Refus d'un OPJ d'enquêter", "Le refus par un juge de rendre justice", "Classement sans suite", "Rejet d'une plainte"],
    answer: 1,
    explanation: "Le déni de justice est le refus par un juge de statuer sur une affaire qui lui est soumise, constitutif d'une faute professionnelle grave.",
  },
  {
    id: 15,
    q: "Qu'est-ce que la prévention situationnelle ?",
    choices: [
      "Formation des policiers à la prévention",
      "Ensemble de mesures pour réduire les opportunités d'infraction",
      "Surveillance intensive des suspects",
      "Programme de réinsertion",
    ],
    answer: 1,
    explanation: "La prévention situationnelle vise à réduire les occasions de commettre des infractions en agissant sur l'environnement (éclairage, vidéosurveillance, architecture, etc.).",
  },
  {
    id: 16,
    q: "Qui peut ordonner une perquisition ?",
    choices: [
      "Tout officier de police",
      "Le juge d'instruction ou, en flagrance, l'OPJ",
      "Le procureur seul",
      "Le préfet",
    ],
    answer: 1,
    explanation: "En enquête préliminaire, la perquisition nécessite une autorisation judiciaire. En flagrance, l'OPJ peut procéder sans mandat. Le juge d'instruction l'ordonne dans le cadre d'une information judiciaire.",
  },
  {
    id: 17,
    q: "L'IGPN est ?",
    choices: [
      "Institut de Gestion de la Police Nationale",
      "Inspection Générale de la Police Nationale",
      "Instance de Gouvernance de la Police Nationale",
      "Institut de Gestion des Procédures Nationales",
    ],
    answer: 1,
    explanation: "L'IGPN (Inspection Générale de la Police Nationale) est l'organe de contrôle interne chargé d'enquêter sur les comportements des policiers et de formuler des recommandations.",
  },
  {
    id: 18,
    q: "Qu'est-ce que la médiation pénale ?",
    choices: [
      "Procès en chambre fermée",
      "Mode alternatif de règlement d'un conflit pénal",
      "Peine d'emprisonnement réduite",
      "Renvoi devant le jury",
    ],
    answer: 1,
    explanation: "La médiation pénale est une alternative aux poursuites judiciaires qui permet à la victime et à l'auteur d'un délit de trouver un accord, avec l'aide d'un médiateur.",
  },
  {
    id: 19,
    q: "L'excuse de minorité concerne les moins de ?",
    choices: ["15 ans", "16 ans", "18 ans", "21 ans"],
    answer: 2,
    explanation: "L'excuse de minorité atténue la responsabilité pénale des personnes âgées de moins de 18 ans, permettant une réduction des peines encourues.",
  },
  {
    id: 20,
    q: "Qu'est-ce que la peine complémentaire ?",
    choices: [
      "Peine à la place de la principale",
      "Peine s'ajoutant à la peine principale",
      "Peine suspendue",
      "Peine aménagée",
    ],
    answer: 1,
    explanation: "La peine complémentaire (art. 131-10 CP) s'ajoute à la peine principale et peut consister en une suspension de permis, une interdiction d'exercer une profession, etc.",
  },
]

// ─── Types ────────────────────────────────────────────────────────────────────

type Phase = "setup" | "running" | "summary" | "review"

interface SessionConfig {
  type: "pa" | "gpx"
  duration: 20 | 30 | 45
  questionCount: 10 | 15 | 20
}

// ─── Component ────────────────────────────────────────────────────────────────

export default function ConcoursBlancInterface({ userId }: { userId: string }) {
  const [phase, setPhase] = useState<Phase>("setup")
  const [config, setConfig] = useState<SessionConfig>({ type: "pa", duration: 30, questionCount: 10 })
  const [currentQ, setCurrentQ] = useState(0)
  const [answers, setAnswers] = useState<(number | null)[]>([])
  const [timeLeft, setTimeLeft] = useState(0)
  const [showConfirmAbandon, setShowConfirmAbandon] = useState(false)

  const questions = (config.type === "pa" ? PA_QUESTIONS : GPX_QUESTIONS).slice(0, config.questionCount)

  // Timer — independent of question navigation
  useEffect(() => {
    if (phase !== "running") return
    if (timeLeft <= 0) { setPhase("summary"); return }
    const interval = setInterval(() => {
      setTimeLeft(t => {
        if (t <= 1) { setPhase("summary"); return 0 }
        return t - 1
      })
    }, 1000)
    return () => clearInterval(interval)
  }, [phase])

  function startExam() {
    setAnswers(new Array(questions.length).fill(null))
    setTimeLeft(config.duration * 60)
    setCurrentQ(0)
    setPhase("running")
  }

  function reset() {
    setPhase("setup")
    setAnswers([])
    setCurrentQ(0)
    setTimeLeft(0)
    setShowConfirmAbandon(false)
  }

  function handleAnswer(idx: number) {
    if (answers[currentQ] !== null) return
    const updated = [...answers]
    updated[currentQ] = idx
    setAnswers(updated)
  }

  function formatTime(s: number) {
    const m = Math.floor(s / 60)
    const sec = s % 60
    return `${m}:${sec.toString().padStart(2, "0")}`
  }

  const score = answers.filter((a, i) => a === questions[i]?.answer).length
  const scorePct = questions.length > 0 ? Math.round((score / questions.length) * 100) : 0

  // ── SETUP ──────────────────────────────────────────────────────────────────
  if (phase === "setup") return (
    <div className="max-w-xl mx-auto px-4 py-8">
      <div className="text-center mb-8">
        <div className="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-[#1147D9]/10 text-[#1147D9] text-xs font-semibold mb-4">
          ✨ Simulez les conditions réelles du concours
        </div>
        <h1 className="text-2xl font-bold text-[var(--on-surface)] mb-1">Concours Blanc</h1>
        <p className="text-[var(--on-surface-muted)] text-sm">Choisissez votre type d&apos;épreuve et commencez</p>
      </div>

      {/* Type selection */}
      <div className="mb-5">
        <p className="text-xs font-semibold text-[var(--on-surface-muted)] uppercase tracking-wide mb-2">
          Type d&apos;épreuve
        </p>
        <div className="grid grid-cols-2 gap-3">
          {(["pa", "gpx"] as const).map(t => (
            <button
              key={t}
              onClick={() => setConfig(c => ({ ...c, type: t }))}
              className={`p-4 rounded-xl border-2 text-left transition-all ${
                config.type === t
                  ? "border-[#1147D9] bg-[#1147D9]/10"
                  : "border-[var(--outline)] bg-[var(--surface)] hover:border-[#1147D9]/40"
              }`}
            >
              <div className="text-2xl mb-1">{t === "pa" ? "👮" : "🚔"}</div>
              <p className={`font-bold text-sm ${config.type === t ? "text-[#1147D9]" : "text-[var(--on-surface)]"}`}>
                {t.toUpperCase()}
              </p>
              <p className="text-xs text-[var(--on-surface-muted)]">
                {t === "pa" ? "Policier Adjoint" : "Gardien de la Paix"}
              </p>
            </button>
          ))}
        </div>
      </div>

      {/* Duration */}
      <div className="mb-5">
        <p className="text-xs font-semibold text-[var(--on-surface-muted)] uppercase tracking-wide mb-2">Durée</p>
        <div className="flex gap-2">
          {([20, 30, 45] as const).map(d => (
            <button
              key={d}
              onClick={() => setConfig(c => ({ ...c, duration: d }))}
              className={`flex-1 py-2.5 rounded-xl border text-sm font-semibold transition-all ${
                config.duration === d
                  ? "border-[#1147D9] bg-[#1147D9] text-white"
                  : "border-[var(--outline)] text-[var(--on-surface)] hover:border-[#1147D9]/40"
              }`}
            >
              {d} min
            </button>
          ))}
        </div>
      </div>

      {/* Question count */}
      <div className="mb-8">
        <p className="text-xs font-semibold text-[var(--on-surface-muted)] uppercase tracking-wide mb-2">
          Nombre de questions
        </p>
        <div className="flex gap-2">
          {([10, 15, 20] as const).map(n => (
            <button
              key={n}
              onClick={() => setConfig(c => ({ ...c, questionCount: n }))}
              className={`flex-1 py-2.5 rounded-xl border text-sm font-semibold transition-all ${
                config.questionCount === n
                  ? "border-[#8B5CF6] bg-[#8B5CF6] text-white"
                  : "border-[var(--outline)] text-[var(--on-surface)] hover:border-[#8B5CF6]/40"
              }`}
            >
              {n} questions
            </button>
          ))}
        </div>
      </div>

      <button
        onClick={startExam}
        className="w-full flex items-center justify-center gap-2 py-3.5 rounded-xl bg-[#1147D9] text-white font-bold hover:bg-[#1A55E6] transition-all"
      >
        <PlayCircle size={20} />Commencer l&apos;épreuve
      </button>
    </div>
  )

  // ── RUNNING ────────────────────────────────────────────────────────────────
  if (phase === "running") {
    const q = questions[currentQ]
    const answered = answers[currentQ] !== null
    const timeIsLow = timeLeft <= 5 * 60
    const answeredCount = answers.filter(a => a !== null).length

    return (
      <div className="max-w-2xl mx-auto px-4 pb-8">
        {/* Sticky header */}
        <div className="sticky top-0 z-10 bg-[var(--surface)] pt-4 pb-3 border-b border-[var(--outline)] mb-6">
          <div className="flex items-center justify-between">
            <span className="text-sm font-semibold text-[var(--on-surface)]">
              Question {currentQ + 1}/{questions.length}
            </span>
            <div
              className={`flex items-center gap-1.5 px-3 py-1.5 rounded-full text-sm font-bold transition-colors ${
                timeIsLow
                  ? "bg-red-500/10 text-red-500"
                  : "bg-[var(--surface-dark)] text-[var(--on-surface)]"
              }`}
            >
              <Timer size={13} />{formatTime(timeLeft)}
            </div>
            <button
              onClick={() => setShowConfirmAbandon(true)}
              className="flex items-center gap-1 text-xs text-[var(--on-surface-muted)] hover:text-red-500 transition-colors"
            >
              <X size={14} />Abandonner
            </button>
          </div>
          {/* Progress bar — réponses données */}
          <div className="h-1.5 rounded-full bg-[var(--surface-dark)] overflow-hidden mt-3">
            <div
              className="h-full rounded-full bg-[#1147D9] transition-all duration-500"
              style={{ width: `${(answeredCount / questions.length) * 100}%` }}
            />
          </div>
        </div>

        {/* Question card */}
        <div className="rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-6 mb-4">
          <p className="text-lg font-bold text-[var(--on-surface)] mb-6 leading-snug">{q.q}</p>
          <div className="space-y-3">
            {q.choices.map((choice, ci) => {
              const selected = answers[currentQ] === ci
              const correct = ci === q.answer
              let cls = "w-full text-left px-4 py-3.5 rounded-xl border text-sm font-medium transition-all "
              if (answered) {
                if (selected && correct) cls += "border-[#22C55E] bg-[#22C55E]/10 text-[#22C55E]"
                else if (selected && !correct) cls += "border-red-500 bg-red-500/10 text-red-500"
                else if (correct) cls += "border-[#22C55E]/40 bg-[#22C55E]/5 text-[var(--on-surface)]"
                else cls += "border-[var(--outline)] text-[var(--on-surface-muted)] opacity-50"
              } else {
                cls += "border-[var(--outline)] text-[var(--on-surface)] hover:border-[#1147D9]/40 hover:bg-[#1147D9]/5 cursor-pointer"
              }
              return (
                <button key={ci} onClick={() => handleAnswer(ci)} disabled={answered} className={cls}>
                  <span className="font-bold mr-2 text-[var(--on-surface-muted)]">
                    {String.fromCharCode(65 + ci)}.
                  </span>
                  {choice}
                </button>
              )
            })}
          </div>
          {answered && (
            <div className="mt-4 p-3 rounded-xl bg-[var(--surface-dark)] text-xs text-[var(--on-surface-muted)]">
              <strong className="text-[var(--on-surface)]">Explication :</strong> {q.explanation}
            </div>
          )}
        </div>

        {/* Navigation précédent / suivant */}
        <div className="flex items-center gap-3 mb-4">
          <button
            onClick={() => setCurrentQ(c => Math.max(0, c - 1))}
            disabled={currentQ === 0}
            className="flex items-center gap-1 px-4 py-2 rounded-xl border border-[var(--outline)] text-sm font-medium text-[var(--on-surface)] disabled:opacity-30 hover:border-[#1147D9]/40 transition-all"
          >
            <ChevronLeft size={16} />Précédent
          </button>
          <div className="flex-1" />
          {currentQ < questions.length - 1 ? (
            <button
              onClick={() => setCurrentQ(c => c + 1)}
              className="flex items-center gap-1 px-4 py-2 rounded-xl bg-[#1147D9] text-white text-sm font-semibold hover:bg-[#1A55E6] transition-all"
            >
              Suivant<ChevronRight size={16} />
            </button>
          ) : (
            <button
              onClick={() => setPhase("summary")}
              className="flex items-center gap-1 px-4 py-2 rounded-xl bg-[#22C55E] text-white text-sm font-semibold hover:bg-[#16A34A] transition-all"
            >
              Terminer ✓
            </button>
          )}
        </div>

        {/* Minimap — navigation rapide */}
        <div className="rounded-xl border border-[var(--outline)] bg-[var(--surface)] p-4">
          <p className="text-xs font-semibold text-[var(--on-surface-muted)] mb-3">Navigation rapide</p>
          <div className="flex flex-wrap gap-2">
            {questions.map((_, i) => {
              const ans = answers[i]
              const isAnswered = ans !== null
              const isCorrect = ans === questions[i].answer
              let cls = "w-8 h-8 rounded-lg text-xs font-bold transition-all border "
              if (i === currentQ) cls += "border-[#1147D9] bg-[#1147D9] text-white"
              else if (isAnswered && isCorrect) cls += "border-[#22C55E]/40 bg-[#22C55E]/10 text-[#22C55E]"
              else if (isAnswered && !isCorrect) cls += "border-red-400/40 bg-red-400/10 text-red-500"
              else cls += "border-[var(--outline)] text-[var(--on-surface-muted)] hover:border-[#1147D9]/40"
              return (
                <button key={i} onClick={() => setCurrentQ(i)} className={cls}>{i + 1}</button>
              )
            })}
          </div>
        </div>

        {/* Abandon confirmation modal */}
        {showConfirmAbandon && (
          <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 px-4">
            <div className="w-full max-w-sm rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-6 shadow-2xl">
              <AlertCircle size={32} className="text-red-500 mx-auto mb-3" />
              <p className="text-center font-bold text-[var(--on-surface)] mb-1">Abandonner l&apos;épreuve ?</p>
              <p className="text-center text-sm text-[var(--on-surface-muted)] mb-5">Votre progression sera perdue.</p>
              <div className="flex gap-3">
                <button
                  onClick={() => setShowConfirmAbandon(false)}
                  className="flex-1 py-2.5 rounded-xl border border-[var(--outline)] text-sm font-semibold text-[var(--on-surface)]"
                >
                  Continuer
                </button>
                <button
                  onClick={reset}
                  className="flex-1 py-2.5 rounded-xl bg-red-500 text-white text-sm font-semibold hover:bg-red-600 transition-all"
                >
                  Abandonner
                </button>
              </div>
            </div>
          </div>
        )}
      </div>
    )
  }

  // ── SUMMARY ────────────────────────────────────────────────────────────────
  if (phase === "summary") {
    const color = scorePct >= 80 ? "#22C55E" : scorePct >= 50 ? "#F59E0B" : "#EF4444"
    const msg =
      scorePct >= 80
        ? "Excellent ! Vous êtes prêt·e pour l'épreuve 🏆"
        : scorePct >= 50
        ? "Bien, continuez les révisions 👍"
        : "Des efforts supplémentaires sont nécessaires 💪"

    return (
      <div className="max-w-2xl mx-auto px-4 py-8 space-y-4">
        <div className="rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-8 text-center">
          <p className="text-6xl font-black mb-2" style={{ color }}>
            {score}
            <span className="text-3xl text-[var(--on-surface-muted)]">/{questions.length}</span>
          </p>
          <p className="text-sm text-[var(--on-surface-muted)] mb-4">{scorePct}% de bonnes réponses</p>

          {/* Color gauge */}
          <div className="h-3 rounded-full bg-[var(--surface-dark)] overflow-hidden mb-4 mx-auto max-w-xs">
            <div
              className="h-full rounded-full transition-all duration-1000"
              style={{ width: `${scorePct}%`, backgroundColor: color }}
            />
          </div>

          <p className="font-semibold text-[var(--on-surface)] mb-6">{msg}</p>

          {/* Review table */}
          <div className="text-left space-y-1 mb-6 max-h-64 overflow-y-auto">
            {questions.map((q, i) => {
              const correct = answers[i] === q.answer
              return (
                <div
                  key={i}
                  className={`flex items-center gap-2 px-3 py-2 rounded-lg text-sm ${
                    correct ? "bg-[#22C55E]/5" : "bg-red-500/5"
                  }`}
                >
                  {correct
                    ? <CheckCircle size={14} className="text-[#22C55E] shrink-0" />
                    : <X size={14} className="text-red-500 shrink-0" />
                  }
                  <span className="text-[var(--on-surface)] truncate">{i + 1}. {q.q}</span>
                </div>
              )
            })}
          </div>

          <div className="flex gap-3 justify-center flex-wrap">
            <button
              onClick={() => setPhase("review")}
              className="px-5 py-2.5 rounded-xl border border-[var(--outline)] text-sm font-semibold text-[var(--on-surface)] hover:border-[#1147D9]/40 transition-all"
            >
              Voir la correction détaillée
            </button>
            <button
              onClick={reset}
              className="flex items-center gap-2 px-5 py-2.5 rounded-xl bg-[#1147D9] text-white text-sm font-semibold hover:bg-[#1A55E6] transition-all"
            >
              <RotateCcw size={14} />Refaire
            </button>
          </div>
        </div>
      </div>
    )
  }

  // ── REVIEW ────────────────────────────────────────────────────────────────
  return (
    <div className="max-w-2xl mx-auto px-4 py-8 space-y-4">
      <div className="flex items-center justify-between mb-2">
        <h2 className="text-xl font-bold text-[var(--on-surface)]">Correction détaillée</h2>
        <button
          onClick={() => setPhase("summary")}
          className="text-sm text-[#1147D9] hover:underline"
        >
          ← Retour aux résultats
        </button>
      </div>

      {questions.map((q, qi) => {
        const userAnswer = answers[qi]
        const correct = userAnswer === q.answer
        return (
          <div
            key={q.id}
            className={`rounded-xl border p-5 ${
              correct ? "border-[#22C55E]/30 bg-[#22C55E]/5" : "border-red-500/30 bg-red-500/5"
            }`}
          >
            <div className="flex items-start gap-2 mb-3">
              {correct
                ? <CheckCircle size={16} className="text-[#22C55E] mt-0.5 flex-shrink-0" />
                : <X size={16} className="text-red-500 mt-0.5 flex-shrink-0" />
              }
              <p className="text-sm font-semibold text-[var(--on-surface)]">{qi + 1}. {q.q}</p>
            </div>
            {!correct && userAnswer !== null && (
              <p className="text-xs text-red-500 mb-1 ml-6">
                Votre réponse : {q.choices[userAnswer]}
              </p>
            )}
            {userAnswer === null && (
              <p className="text-xs text-[var(--on-surface-muted)] mb-1 ml-6 italic">Non répondue</p>
            )}
            <p className="text-xs text-[#22C55E] mb-2 ml-6">
              Bonne réponse : {q.choices[q.answer]}
            </p>
            <p className="text-xs text-[var(--on-surface-muted)] italic ml-6">{q.explanation}</p>
          </div>
        )
      })}

      <div className="flex gap-3 pt-2">
        <button
          onClick={() => setPhase("summary")}
          className="flex-1 py-2.5 rounded-xl border border-[var(--outline)] text-sm font-semibold text-[var(--on-surface)] hover:border-[#1147D9]/40 transition-all"
        >
          ← Retour aux résultats
        </button>
        <button
          onClick={reset}
          className="flex-1 flex items-center justify-center gap-2 py-2.5 rounded-xl bg-[#1147D9] text-white text-sm font-semibold hover:bg-[#1A55E6] transition-all"
        >
          <RotateCcw size={14} />Nouveau concours
        </button>
      </div>
    </div>
  )
}
