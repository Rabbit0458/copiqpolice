export type UserTrack = "pa" | "gpx"
export type UserMode = "exam" | "school"
export type PathwayId = "pa_exam" | "gpx_exam" | "pa_school" | "gpx_school"

export type PathwayFeature =
  | "schoolDashboard"
  | "courses"
  | "quiz"
  | "generalKnowledge"
  | "psychotechnics"
  | "languages"
  | "caseStudies"
  | "mockExam"
  | "memos"
  | "notes"
  | "progress"
  | "history"
  | "bookmarks"
  | "community"

export type PathwayIconKey =
  | "dashboard"
  | "graduation"
  | "quiz"
  | "knowledge"
  | "brain"
  | "languages"
  | "caseStudies"
  | "mockExam"
  | "memos"
  | "notes"

export interface PathwayNavigationItem {
  feature: PathwayFeature
  label: string
  description: string
  href: string
  iconKey: PathwayIconKey
  premium?: boolean
}

export interface PathwayCapabilities {
  schoolDashboard: boolean
  courses: boolean
  quiz: boolean
  generalKnowledge: boolean
  psychotechnics: boolean
  languages: boolean
  caseStudies: boolean
  mockExam: boolean
  memos: boolean
  notes: boolean
  progress: boolean
  history: boolean
  bookmarks: boolean
  community: boolean
}

export interface PathwayDefinition {
  id: PathwayId
  track: UserTrack
  mode: UserMode
  slug: "pa-exam" | "gpx-exam" | "pa-school" | "gpx-school"
  shortLabel: string
  label: string
  title: string
  description: string
  communitySpaceId: PathwayId
  color: string
  softColor: string
  darkSoftColor: string
  iconKey: "shield" | "badge" | "graduation"
  homeHref: "/dashboard"
  capabilities: Readonly<PathwayCapabilities>
  navigation: readonly PathwayNavigationItem[]
}

export interface PathwayProfileLike {
  user_track?: string | null
  user_mode?: string | null
}

export type PathwayEntitlement = "free" | "premium" | "premium_trial"

const sharedCapabilities = {
  progress: true,
  history: true,
  bookmarks: true,
  community: true,
} as const

const pathwayDefinitions = {
  pa_exam: {
    id: "pa_exam",
    track: "pa",
    mode: "exam",
    slug: "pa-exam",
    shortLabel: "PA · Concours",
    label: "Concours Policier adjoint",
    title: "Préparation au concours de Policier adjoint",
    description: "QCM, psychotechniques et concours blancs pour préparer chaque épreuve.",
    communitySpaceId: "pa_exam",
    color: "#D92D4B",
    softColor: "#FFF0F3",
    darkSoftColor: "#35131C",
    iconKey: "shield",
    homeHref: "/dashboard",
    capabilities: {
      ...sharedCapabilities,
      schoolDashboard: false,
      courses: false,
      quiz: true,
      generalKnowledge: true,
      psychotechnics: true,
      languages: false,
      caseStudies: false,
      mockExam: true,
      memos: false,
      notes: false,
    },
    navigation: [
      { feature: "quiz", label: "Quiz du concours", description: "Réviser les connaissances attendues", href: "/pa/quiz", iconKey: "quiz" },
      { feature: "generalKnowledge", label: "Culture générale", description: "Approfondir les thèmes essentiels", href: "/culture-generale", iconKey: "knowledge" },
      { feature: "psychotechnics", label: "Psychotechniques", description: "Logique, calcul et concentration", href: "/psychotechniques", iconKey: "brain" },
      { feature: "mockExam", label: "Concours blanc", description: "S’entraîner en conditions réelles", href: "/concours-blanc", iconKey: "mockExam", premium: true },
    ],
  },
  gpx_exam: {
    id: "gpx_exam",
    track: "gpx",
    mode: "exam",
    slug: "gpx-exam",
    shortLabel: "GPX · Concours",
    label: "Concours Gardien de la paix",
    title: "Préparation au concours de Gardien de la paix",
    description: "Cours, cas pratiques et entraînements ciblés pour réussir le concours GPX.",
    communitySpaceId: "gpx_exam",
    color: "#2459D3",
    softColor: "#EEF4FF",
    darkSoftColor: "#101F43",
    iconKey: "badge",
    homeHref: "/dashboard",
    capabilities: {
      ...sharedCapabilities,
      schoolDashboard: false,
      courses: false,
      quiz: true,
      generalKnowledge: true,
      psychotechnics: true,
      languages: true,
      caseStudies: true,
      mockExam: true,
      memos: false,
      notes: false,
    },
    navigation: [
      { feature: "quiz", label: "Quiz du concours", description: "Réviser les connaissances attendues", href: "/gpx/quiz", iconKey: "quiz" },
      { feature: "caseStudies", label: "Cas pratiques", description: "Structurer et corriger ses réponses", href: "/gpx/cas-pratiques", iconKey: "caseStudies", premium: true },
      { feature: "generalKnowledge", label: "Culture générale", description: "Approfondir les thèmes essentiels", href: "/culture-generale", iconKey: "knowledge" },
      { feature: "psychotechnics", label: "Psychotechniques", description: "Logique, calcul et concentration", href: "/psychotechniques", iconKey: "brain" },
      { feature: "languages", label: "Langues", description: "Préparer l’épreuve de langue", href: "/langues", iconKey: "languages" },
      { feature: "mockExam", label: "Concours blanc", description: "S’entraîner en conditions réelles", href: "/concours-blanc", iconKey: "mockExam", premium: true },
    ],
  },
  pa_school: {
    id: "pa_school",
    track: "pa",
    mode: "school",
    slug: "pa-school",
    shortLabel: "PA · École",
    label: "Scolarité Policier adjoint",
    title: "Scolarité de Policier adjoint",
    description: "Cours, quiz et outils personnels pour accompagner toute la formation en école.",
    communitySpaceId: "pa_school",
    color: "#087F5B",
    softColor: "#EAFBF4",
    darkSoftColor: "#0D2D25",
    iconKey: "graduation",
    homeHref: "/dashboard",
    capabilities: {
      ...sharedCapabilities,
      schoolDashboard: true,
      courses: false,
      quiz: true,
      generalKnowledge: false,
      psychotechnics: false,
      languages: false,
      caseStudies: false,
      mockExam: false,
      memos: true,
      notes: true,
    },
    navigation: [
      { feature: "schoolDashboard", label: "Ma scolarité", description: "Retrouver les modules de formation", href: "/pa/scolarite", iconKey: "graduation" },
      { feature: "quiz", label: "Quiz PA", description: "Vérifier les acquis de cours", href: "/pa/quiz", iconKey: "quiz" },
      { feature: "memos", label: "Mémos", description: "Créer des fiches de révision", href: "/memos", iconKey: "memos" },
      { feature: "notes", label: "Notes", description: "Conserver ses notes personnelles", href: "/notes", iconKey: "notes" },
    ],
  },
  gpx_school: {
    id: "gpx_school",
    track: "gpx",
    mode: "school",
    slug: "gpx-school",
    shortLabel: "GPX · École",
    label: "Scolarité Gardien de la paix",
    title: "Scolarité de Gardien de la paix",
    description: "Un espace structuré pour les cours, entraînements et outils de la scolarité GPX.",
    communitySpaceId: "gpx_school",
    color: "#7048C8",
    softColor: "#F5F0FF",
    darkSoftColor: "#261A43",
    iconKey: "graduation",
    homeHref: "/dashboard",
    capabilities: {
      ...sharedCapabilities,
      schoolDashboard: true,
      courses: false,
      quiz: true,
      generalKnowledge: false,
      psychotechnics: false,
      languages: false,
      caseStudies: true,
      mockExam: false,
      memos: true,
      notes: true,
    },
    navigation: [
      { feature: "schoolDashboard", label: "Ma scolarité", description: "Retrouver les modules de formation", href: "/gpx/scolarite", iconKey: "graduation" },
      { feature: "quiz", label: "Quiz GPX", description: "Vérifier les acquis de cours", href: "/gpx/quiz", iconKey: "quiz" },
      { feature: "caseStudies", label: "Cas pratiques", description: "S’entraîner à la rédaction professionnelle", href: "/gpx/cas-pratiques", iconKey: "caseStudies", premium: true },
      { feature: "memos", label: "Mémos", description: "Créer des fiches de révision", href: "/memos", iconKey: "memos" },
      { feature: "notes", label: "Notes", description: "Conserver ses notes personnelles", href: "/notes", iconKey: "notes" },
    ],
  },
} as const satisfies Record<PathwayId, PathwayDefinition>

export const PATHWAY_IDS = ["pa_exam", "gpx_exam", "pa_school", "gpx_school"] as const
export const PATHWAYS: Readonly<Record<PathwayId, PathwayDefinition>> = pathwayDefinitions
export const PATHWAY_LIST = PATHWAY_IDS.map((id) => PATHWAYS[id])

export function isUserTrack(value: unknown): value is UserTrack {
  return value === "pa" || value === "gpx"
}

export function isUserMode(value: unknown): value is UserMode {
  return value === "exam" || value === "school"
}

export function isPathwayId(value: unknown): value is PathwayId {
  return typeof value === "string" && PATHWAY_IDS.includes(value as PathwayId)
}

export function toPathwayId(track: UserTrack, mode: UserMode): PathwayId {
  return `${track}_${mode}` as PathwayId
}

export function getPathway(id: PathwayId): PathwayDefinition {
  return PATHWAYS[id]
}

export function getPathwayFromProfile(profile: PathwayProfileLike | null | undefined): PathwayDefinition | null {
  if (!profile || !isUserTrack(profile.user_track) || !isUserMode(profile.user_mode)) return null
  return getPathway(toPathwayId(profile.user_track, profile.user_mode))
}

export function getDefaultPathway(): PathwayDefinition {
  return PATHWAYS.pa_exam
}

export function getPathwayNavigation(id: PathwayId, entitlement: PathwayEntitlement): readonly PathwayNavigationItem[] {
  void entitlement
  return PATHWAYS[id].navigation
}

export function getCommunitySpaceId(track: UserTrack, mode: UserMode): PathwayId {
  return toPathwayId(track, mode)
}

export function pathwayLabel(id: PathwayId): string {
  return PATHWAYS[id].title
}

export function canUseFeature(pathway: PathwayDefinition | PathwayId, feature: PathwayFeature): boolean {
  const definition = typeof pathway === "string" ? PATHWAYS[pathway] : pathway
  return definition.capabilities[feature]
}
