export type EditorialIssue = {
  code: string
  label: string
  detail: string
  severity: "error" | "warning"
}

export type CourseValidationInput = {
  title: string
  subtitle?: string
  body: string
  keyPoints: string[]
  legalRefs: string[]
  color: string
}

export type CourseMediaReference = {
  alt: string
  source: string
  index: number
}

const supportedImageExtensions = new Set([
  "avif",
  "gif",
  "jpeg",
  "jpg",
  "png",
  "svg",
  "webp",
])

export type QuizValidationInput = {
  question: string
  options: string[]
  answer: string
  category?: string
  explanation?: string
  legalRef?: string
}

export function validateCourse(input: CourseValidationInput): EditorialIssue[] {
  const issues: EditorialIssue[] = []
  const meaningfulBody = input.body.replace(/[#>*_`|\-]/g, " ").replace(/\s+/g, " ").trim()

  if (input.title.trim().length < 3) {
    issues.push(error("course-title", "Titre incomplet", "Ajoute un titre d’au moins trois caractères."))
  }
  if (meaningfulBody.length < 120) {
    issues.push(error("course-body", "Contenu insuffisant", "La fiche doit contenir au moins 120 caractères pédagogiques avant publication."))
  }
  if (!/^#[0-9a-f]{6}$/i.test(input.color.trim())) {
    issues.push(error("course-color", "Couleur invalide", "Utilise une couleur hexadécimale complète, par exemple #1147D9."))
  }
  if (!input.subtitle?.trim()) {
    issues.push(warning("course-subtitle", "Sous-titre absent", "Un sous-titre court améliore le repérage dans le catalogue."))
  }
  if (input.keyPoints.length === 0) {
    issues.push(warning("course-key-points", "Aucun point à retenir", "Ajoute au moins un repère de mémorisation pour renforcer la fiche."))
  }
  if (input.legalRefs.length === 0) {
    issues.push(warning("course-legal-refs", "Sources non renseignées", "Ajoute les références juridiques ou institutionnelles applicables."))
  }
  return issues
}

export function validateQuiz(input: QuizValidationInput): EditorialIssue[] {
  const issues: EditorialIssue[] = []
  const normalizedOptions = input.options.map((option) => option.trim()).filter(Boolean)
  const uniqueOptions = new Set(normalizedOptions.map((option) => option.toLocaleLowerCase("fr-FR")))

  if (input.question.trim().length < 10) {
    issues.push(error("quiz-question", "Question trop courte", "Rédige une question explicite d’au moins dix caractères."))
  }
  if (normalizedOptions.length < 2) {
    issues.push(error("quiz-options", "Propositions insuffisantes", "Ajoute au moins deux choix de réponse."))
  }
  if (uniqueOptions.size !== normalizedOptions.length) {
    issues.push(error("quiz-duplicates", "Propositions en double", "Chaque choix doit être unique pour éviter une correction ambiguë."))
  }
  if (!normalizedOptions.includes(input.answer.trim())) {
    issues.push(error("quiz-answer", "Bonne réponse absente", "La bonne réponse doit correspondre exactement à une proposition."))
  }
  if (!input.explanation?.trim()) {
    issues.push(error("quiz-explanation", "Correction manquante", "Ajoute une explication pédagogique avant d’activer la question."))
  }
  if (!input.category?.trim()) {
    issues.push(warning("quiz-category", "Catégorie absente", "Une catégorie facilite la recherche et l’analyse des résultats."))
  }
  if (!input.legalRef?.trim()) {
    issues.push(warning("quiz-legal-ref", "Référence absente", "Ajoute une source lorsque la question repose sur un texte ou une règle."))
  }
  return issues
}

export function blockingIssues(issues: EditorialIssue[]): EditorialIssue[] {
  return issues.filter((issue) => issue.severity === "error")
}

/** Extrait uniquement la syntaxe image Markdown prise en charge par le lecteur. */
export function extractCourseMedia(markdown: string): CourseMediaReference[] {
  const references: CourseMediaReference[] = []
  const pattern = /!\[([^\]]*)\]\(\s*([^\s)]+)(?:\s+["'][^"']*["'])?\s*\)/g
  let match: RegExpExecArray | null

  while ((match = pattern.exec(markdown)) !== null) {
    references.push({
      alt: match[1].trim(),
      source: match[2].trim(),
      index: match.index,
    })
  }
  return references
}

/** Contrôles déterministes exécutables avant toute requête réseau. */
export function validateCourseMedia(markdown: string): EditorialIssue[] {
  const issues: EditorialIssue[] = []
  const references = extractCourseMedia(markdown)

  for (const [position, reference] of references.entries()) {
    const number = position + 1
    if (!reference.alt) {
      issues.push(error(
        `course-media-alt-${number}`,
        `Description manquante — média ${number}`,
        "Décris l’image entre les crochets pour les lecteurs d’écran, par exemple ![Schéma de la procédure](…).",
      ))
    }

    if (!isSafeMediaSource(reference.source)) {
      issues.push(error(
        `course-media-source-${number}`,
        `Adresse non autorisée — média ${number}`,
        "Utilise une adresse HTTPS ou un chemin local commençant par /. Les adresses data:, blob:, javascript: et HTTP sont refusées.",
      ))
      continue
    }

    const extension = mediaExtension(reference.source)
    if (extension && !supportedImageExtensions.has(extension)) {
      issues.push(error(
        `course-media-format-${number}`,
        `Format incompatible — média ${number}`,
        "Formats acceptés : AVIF, GIF, JPEG, PNG, SVG et WebP.",
      ))
    }
  }

  return issues
}

export function isSafeMediaSource(source: string): boolean {
  if (source.startsWith("/")) return !source.startsWith("//")
  try {
    return new URL(source).protocol === "https:"
  } catch {
    return false
  }
}

function mediaExtension(source: string): string | null {
  const path = source.split(/[?#]/, 1)[0]
  const filename = path.split("/").pop() ?? ""
  const match = filename.match(/\.([a-z0-9]+)$/i)
  return match?.[1].toLowerCase() ?? null
}

function error(code: string, label: string, detail: string): EditorialIssue {
  return { code, label, detail, severity: "error" }
}

function warning(code: string, label: string, detail: string): EditorialIssue {
  return { code, label, detail, severity: "warning" }
}
