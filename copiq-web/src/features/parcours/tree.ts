import raw from "@/data/app-tree.json"
import type { PathwayId } from "@/config/pathways"

/**
 * Arborescence de l'application Flutter, portée telle quelle sur le site.
 *
 * Générée depuis les configurations Dart (categoriesConfigPA / GPX,
 * paSchoolCategoriesConfig, gpxSchoolCategoriesConfig) par
 * tools/tree/gen_web_tree.py — voir progression/CHANTIER_WEB.md.
 *
 * Pyramide : parcours → programme (scolarité) → carte du deck (domaine)
 * → module (feuille) → cours, quiz ou contenu à venir.
 */

type BaseLeaf = { id: string; label: string; image: string | null; route?: string; subtitle?: string | null }

/** Cours : `srcs` liste les pages Flutter enchaînées (intro → contenu → suite). */
export type CourseLeaf = BaseLeaf & { kind: "course"; db?: string | null; src: string | null; srcs?: string[] }
export type QuizLeaf = BaseLeaf & { kind: "quiz"; module: string; moduleName: string; quizName: string }
export type CgLeaf = BaseLeaf & { kind: "cg"; category: string; moduleName: string; quizName: string; quizKey: string }
export type AppLeaf = BaseLeaf & { kind: "app"; reason: string }
/** Sommaire de l'app (cartes vers plusieurs sous-cours + quiz). */
export type GroupLeaf = BaseLeaf & { kind: "group"; children: Leaf[] }
export type Leaf = CourseLeaf | QuizLeaf | CgLeaf | AppLeaf | GroupLeaf

export type DeckCard = { id: string; label: string; badge: string; image: string | null; route: string; leaves: Leaf[] }
export type Program = { key: string; label: string; image: string | null; cards: DeckCard[] }

const TREE = raw as unknown as Record<PathwayId, Program[]>

export const imgUrl = (name: string | null | undefined) => (name ? `/app/img/${name}` : null)

export function programsFor(pathwayId: PathwayId): Program[] {
  return TREE[pathwayId] ?? []
}

export function findProgram(pathwayId: PathwayId, key: string | null | undefined): Program | null {
  const list = programsFor(pathwayId)
  return list.find((p) => p.key === key) ?? list[0] ?? null
}

export function findCard(pathwayId: PathwayId, programKey: string | null, cardId: string | null) {
  const program = findProgram(pathwayId, programKey)
  const card = program?.cards.find((c) => c.id === cardId) ?? null
  return { program, card }
}

/** Cherche un module à n'importe quelle profondeur ; `parents` = sommaires traversés. */
function findDeep(leaves: Leaf[], id: string | null, parents: GroupLeaf[] = []): { leaf: Leaf; parents: GroupLeaf[] } | null {
  for (const l of leaves) {
    if (l.id === id) return { leaf: l, parents }
    if (l.kind === "group") {
      const r = findDeep(l.children, id, [...parents, l])
      if (r) return r
    }
  }
  return null
}

export function findLeaf(pathwayId: PathwayId, programKey: string | null, cardId: string | null, leafId: string | null) {
  const { program, card } = findCard(pathwayId, programKey, cardId)
  const hit = card ? findDeep(card.leaves, leafId) : null
  return { program, card, leaf: hit?.leaf ?? null, parents: hit?.parents ?? [] }
}

/** Tous les modules (sous-cours compris) d'une liste, à plat. */
export function flatLeaves(leaves: Leaf[]): Leaf[] {
  return leaves.flatMap((l) => (l.kind === "group" ? flatLeaves(l.children) : [l]))
}

/** Nombre de cours et de quiz réellement contenus (sommaires dépliés). */
export function countKinds(leaves: Leaf[]) {
  const all = flatLeaves(leaves)
  return {
    courses: all.filter((l) => l.kind === "course").length,
    quizzes: all.filter((l) => l.kind === "quiz" || l.kind === "cg").length,
  }
}

export const categoryHref = (programKey: string, cardId: string) => `/parcours/categorie/?p=${encodeURIComponent(programKey)}&c=${encodeURIComponent(cardId)}`
export const leafHref = (programKey: string, cardId: string, leafId: string) =>
  `/parcours/module/?p=${encodeURIComponent(programKey)}&c=${encodeURIComponent(cardId)}&l=${encodeURIComponent(leafId)}`

/** Une carte sans sous-module (ex. Cas pratique GPX) s'ouvre directement sur son contenu. */
export function cardHref(programKey: string, card: DeckCard) {
  return card.leaves.length === 1 && card.leaves[0].id === card.id ? leafHref(programKey, card.id, card.id) : categoryHref(programKey, card.id)
}

/* ─── Programme de scolarité choisi (mémorisé sur l'appareil, comme l'app) ── */

const programKeyStorage = (pathwayId: PathwayId) => `cq-program:${pathwayId}`

export function readProgram(pathwayId: PathwayId): string | null {
  try {
    return window.localStorage.getItem(programKeyStorage(pathwayId))
  } catch {
    return null
  }
}

export function saveProgram(pathwayId: PathwayId, key: string) {
  try {
    window.localStorage.setItem(programKeyStorage(pathwayId), key)
  } catch {
    /* stockage indisponible : on reste sur le programme par défaut */
  }
}

/* ─── Dernier module ouvert (« Reprendre ») ───────────────────────────────── */

export type LastOpened = { pathwayId: PathwayId; programKey: string; cardId: string; leafId: string; label: string; at: number }

export function readLastOpened(pathwayId: PathwayId): LastOpened | null {
  try {
    const v = JSON.parse(window.localStorage.getItem(`cq-last:${pathwayId}`) ?? "null") as LastOpened | null
    return v && v.pathwayId === pathwayId ? v : null
  } catch {
    return null
  }
}

export function saveLastOpened(v: LastOpened) {
  try {
    window.localStorage.setItem(`cq-last:${v.pathwayId}`, JSON.stringify(v))
  } catch {
    /* rien */
  }
}

/** Recherche (comme l'app) : sans accents, ≥ 3 caractères, début de mot. */
export function normalize(s: string) {
  return s.toLowerCase().normalize("NFD").replace(/\p{Diacritic}/gu, "")
}

export function searchTree(pathwayId: PathwayId, query: string, limit = 8) {
  const q = normalize(query.trim())
  if (q.length < 2) return []
  const out: { program: Program; card: DeckCard; leaf: Leaf | null; score: number }[] = []
  for (const program of programsFor(pathwayId)) {
    for (const card of program.cards) {
      const cl = normalize(card.label)
      if (cl.split(/[^a-z0-9]+/).some((w) => w.startsWith(q)) || cl.includes(q)) out.push({ program, card, leaf: null, score: cl.startsWith(q) ? 0 : 1 })
      for (const leaf of flatLeaves(card.leaves)) {
        if (leaf.id === card.id) continue
        const ll = normalize(leaf.label)
        if (ll.split(/[^a-z0-9]+/).some((w) => w.startsWith(q))) out.push({ program, card, leaf, score: ll.startsWith(q) ? 2 : 3 })
      }
    }
  }
  return out.sort((a, b) => a.score - b.score).slice(0, limit)
}

export const KIND_LABEL: Record<Leaf["kind"], string> = {
  course: "Cours",
  quiz: "Quiz",
  cg: "Quiz",
  app: "Bientôt",
  group: "Sommaire",
}
