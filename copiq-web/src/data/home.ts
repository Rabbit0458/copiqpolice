/**
 * Contenus de la page d'accueil (version 5).
 *
 * Tout ce qui est affiché sur l'accueil et qui n'est pas déjà dans
 * `marketing.ts` vit ici, pour pouvoir être modifié sans toucher aux
 * composants.
 */

/* ─────────────────────────────────────────────────────────────────────────────
   Quiz de l'accueil — trois vraies questions, jouables sans compte
   RÈGLE : chaque question de droit cite son article ET son code.
   ───────────────────────────────────────────────────────────────────────── */

export interface HomeQuizQuestion {
  id: string
  /** Matière, affichée au-dessus de la question. */
  subject: string
  prompt: string
  options: readonly string[]
  /** Index de la bonne réponse dans `options`. */
  answer: number
  explanation: string
  /** Référence affichée sous la correction. */
  source: string
}

export const HOME_QUIZ: readonly HomeQuizQuestion[] = [
  {
    id: "gav",
    subject: "Procédure pénale",
    prompt:
      "En droit commun, combien de temps peut durer une garde à vue avant toute prolongation ?",
    options: ["12 heures", "24 heures", "48 heures"],
    answer: 1,
    explanation:
      "La garde à vue ne peut excéder 24 heures. Elle peut être prolongée de 24 heures au plus, sur autorisation écrite et motivée du procureur de la République.",
    source: "Article 63 du Code de procédure pénale",
  },
  {
    id: "vol",
    subject: "Droit pénal",
    prompt: "Quelle peine encourt l'auteur d'un vol simple ?",
    options: [
      "1 an d'emprisonnement et 15 000 € d'amende",
      "3 ans d'emprisonnement et 45 000 € d'amende",
      "5 ans d'emprisonnement et 75 000 € d'amende",
    ],
    answer: 1,
    explanation:
      "Le vol est puni de trois ans d'emprisonnement et de 45 000 € d'amende. Les circonstances aggravantes alourdissent cette peine.",
    source: "Article 311-3 du Code pénal",
  },
  {
    id: "suite",
    subject: "Psychotechnique",
    prompt: "Quel nombre complète la suite : 2, 6, 12, 20, 30, … ?",
    options: ["40", "42", "44"],
    answer: 1,
    explanation:
      "L'écart grandit de 2 à chaque étape : +4, +6, +8, +10, puis +12. Donc 30 + 12 = 42.",
    source: "Suites numériques, épreuve psychotechnique",
  },
] as const

/* ─────────────────────────────────────────────────────────────────────────────
   Phrases de motivation COP'IQ
   Ajouter une phrase = ajouter une ligne. Elles défilent dans l'appel final.
   ───────────────────────────────────────────────────────────────────────── */

export const MOTIVATION_QUOTES: readonly string[] = [
  "L’avenir ne récompense pas ceux qui attendent d’être prêts, mais ceux qui ont eu le courage de se préparer.",
  "La réussite n’est jamais un hasard du destin, mais la conséquence silencieuse de nos efforts.",
  "Ce n’est pas le jour de l’épreuve qui révèle notre valeur, mais tous les jours qui nous y ont préparés.",
] as const
