/**
 * Reconstruction d'un cours de l'app à partir de `scolarite_content_fragments`.
 *
 * Chaque fragment est une ligne de texte d'une page Flutter (les phrases y sont
 * coupées comme dans le code Dart). On recolle les lignes en paragraphes, on
 * repère les titres de cartes (sections colorées de l'app), les sous-titres
 * numérotés, les listes introduites par « : » et les encadrés d'exemple.
 * Pas de dépendance React : testable seul.
 */

export type Fragment = {
  panel: string | null
  position: number
  component: string
  text_value: string | null
  style_payload: Record<string, unknown> | null
}

export type Inline = { text: string; strong?: boolean }
export type Block =
  | { t: "sub"; text: string }
  | { t: "p"; parts: Inline[] }
  | { t: "list"; items: Inline[][] }
  | { t: "nota"; parts: Inline[]; label?: string }
  | { t: "table"; rows: string[][] }
  | { t: "hr" }
export type Tint = { accent: string; bg: string }
export type Section = { id: string; title: string; level: 1 | 2; tint: Tint; blocks: Block[] }

const SKIP = new Set(["retour", "commencer", "suivant", "précédent", "precedent", "quiz", "c'est parti", "c’est parti"])

/** Couleurs des cartes de l'app (repli quand le fragment n'en porte pas). */
const PALETTE: Tint[] = [
  { accent: "#1565C0", bg: "#E3F2FD" },
  { accent: "#00897B", bg: "#E0F2F1" },
  { accent: "#7B1FA2", bg: "#F3E5F5" },
  { accent: "#EF6C00", bg: "#FFF3E0" },
  { accent: "#C62828", bg: "#FFEBEE" },
  { accent: "#2E7D32", bg: "#E8F5E9" },
  { accent: "#3F51B5", bg: "#E8EAF6" },
  { accent: "#00838F", bg: "#E0F7FA" },
]

type Style = { color_hints?: string[]; font_weight_hints?: string[]; font_size_hints?: string[] }

function hexes(f: Fragment | undefined): string[] {
  const sp = (f?.style_payload ?? {}) as Style
  return (sp.color_hints ?? [])
    .map((c) => c.match(/0x[Ff]{2}([0-9A-Fa-f]{6})/)?.[1])
    .filter((x): x is string => !!x)
    .map((x) => `#${x.toUpperCase()}`)
}

function hsl(hex: string) {
  const n = parseInt(hex.slice(1), 16)
  const r = ((n >> 16) & 255) / 255
  const g = ((n >> 8) & 255) / 255
  const b = (n & 255) / 255
  const max = Math.max(r, g, b)
  const min = Math.min(r, g, b)
  const l = (max + min) / 2
  const s = max === min ? 0 : l > 0.5 ? (max - min) / (2 - max - min) : (max - min) / (max + min)
  return { s, l }
}

function tintFrom(frags: Fragment[], index: number): Tint {
  const all = frags.flatMap(hexes)
  const bg = all.find((h) => {
    const { s, l } = hsl(h)
    return l > 0.86 && l < 0.99 && s > 0.2
  })
  const accent = all.find((h) => {
    const { s, l } = hsl(h)
    return s > 0.45 && l > 0.22 && l < 0.6
  })
  const fallback = PALETTE[index % PALETTE.length]
  return { accent: accent ?? fallback.accent, bg: bg ?? fallback.bg }
}

const clean = (s: string) => s.replace(/\s+/g, " ")
const endsSentence = (s: string) => /[.!?…»)]\s*$/.test(s.trim()) && !/\b(art|al|ex|cf|n°|M|Mme|etc)\.$/i.test(s.trim())
const startsUpper = (s: string) => /^[«"“(]?\s*[A-ZÀÂÉÈÊËÎÏÔÙÛÜÇ0-9]/.test(s.trim())
const NUMBERED = /^((Chapitre|Titre|Partie|Section)\s+[IVX\d]+|\d+(\.\d+)*\s*[—–-]|[A-Z]\)\s|[IVX]+\.\s|\d+\)\s|\d+\.\s+[A-ZÀ-Ý])/

function weight(f: Fragment) {
  const sp = (f.style_payload ?? {}) as Style
  return (sp.font_weight_hints ?? []).some((w) => /w(7|8|9)00|bold/i.test(w))
}

function fontSize(f: Fragment) {
  const sp = (f.style_payload ?? {}) as Style
  return Math.max(0, ...(sp.font_size_hints ?? []).map((n) => Number(n) || 0))
}

function isHeading(f: Fragment, text: string, next: string | null) {
  const t = text.trim()
  if (t.length > 110 || /[,;]\s*$/.test(t)) return false
  if (/^(l[’']|les\s)?(articles?|art\.)\s/i.test(t) || LAW_END.test(t)) return false
  if (NUMBERED.test(t) && t.length < 110 && !/[.:]$/.test(t)) return true
  if (/^(Exemples?|Idée clé|À retenir|Attention|Nota|Remarque)\s*:?$/i.test(t)) return false
  if (f.component === "_SubTitle" || f.component === "subtitle") {
    return t.length < 80 && !/[.:;,]$/.test(t) && !!next && startsUpper(next) && !/\b(par|de|du|des|la|le|les|à|aux|et|ou|en|sur|pour|que)$/i.test(t)
  }
  return false
}

const CALLOUT = /^(Idée clé|Idées clés|À retenir|A retenir|Exemples?|Attention|Remarque|Nota|Important|Astuce|Méthode)\s*:?\s*$/i
const LAW_END = /(Code\s+(pénal|de procédure pénale|de la route|de la santé publique|de la sécurité intérieure|civil|du travail|des douanes)|C\.\s?pén\.?|CPP)\s*$/i

const levelOf = (title: string): 1 | 2 => (/^\d+\.\d+\.\d+/.test(title.trim()) ? 2 : 1)

export function slugify(s: string) {
  return s
    .toLowerCase()
    .normalize("NFD")
    .replace(/\p{Diacritic}/gu, "")
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-|-$/g, "")
    .slice(0, 60)
}

export function fragmentsToSections(rows: Fragment[], courseTitle: string): { sections: Section[]; subtitle: string | null } {
  const list = [...rows]
    .sort((a, b) => a.position - b.position)
    .filter((f) => {
      const t = clean(f.text_value ?? "").trim()
      return t && f.component !== "tooltip" && !SKIP.has(t.toLowerCase())
    })

  // En-tête de la page Dart (titre + accroche) avant la première carte.
  const firstTitle = list.findIndex((f) => f.component === "title")
  const head = firstTitle > 0 ? list.slice(0, firstTitle) : []
  const headerOnly = head.length > 0 && head.every((f) => f.component === "Text" || fontSize(f) >= 13)
  let subtitle: string | null = null
  if (headerOnly) {
    subtitle =
      head
        .filter((f) => clean(f.text_value ?? "").trim().toLowerCase() !== courseTitle.toLowerCase())
        .map((f) => clean(f.text_value ?? "").trim())
        .join(" ")
        .trim() || null
  }
  const body = headerOnly ? list.slice(firstTitle) : list

  const sections: Section[] = []
  let cur: Section | null = null
  let curFrags: Fragment[] = []
  let para: { parts: Inline[]; nota: boolean } | null = null
  let listItems: Inline[][] | null = null
  let listMode: false | true | "auto" = false
  let pendingLabel: string | null = null

  const open = (title: string, f: Fragment | null) => {
    closePara()
    closeList()
    if (cur && curFrags.length) cur.tint = tintFrom(curFrags.slice(0, 3), sections.length - 1)
    cur = { id: "", title, level: levelOf(title), tint: PALETTE[sections.length % PALETTE.length], blocks: [] }
    cur.id = `s-${sections.length + 1}-${slugify(title)}`
    sections.push(cur)
    curFrags = f ? [f] : []
    listMode = false
  }
  const ensure = () => {
    if (!cur) {
      // Texte avant la première carte : section sans titre (le titre est dans le bandeau).
      cur = { id: `s-0-${slugify(courseTitle)}`, title: courseTitle, level: 1, tint: PALETTE[0], blocks: [] }
      sections.push(cur)
      curFrags = []
    }
    return cur as unknown as Section
  }
  const closeList = () => {
    if (listItems && listItems.length) ensure().blocks.push({ t: "list", items: listItems })
    listItems = null
  }
  const closePara = () => {
    if (!para || !para.parts.length) {
      para = null
      return
    }
    const parts = mergeParts(para.parts)
    const text = parts.map((p) => p.text).join("").trim()
    if (!text) {
      para = null
      return
    }
    // « Exemple : … » écrit dans le texte → encadré.
    const lead = text.match(/^(Exemples?|Idée clé|À retenir|Attention|Remarque|Nota)\s*:\s*/i)
    const label = pendingLabel ?? (lead ? lead[1] : null)
    if (lead && parts[0]) parts[0] = { ...parts[0], text: parts[0].text.replace(/^\s*(Exemples?|Idée clé|À retenir|Attention|Remarque|Nota)\s*:\s*/i, "") }
    const isNota = para.nota || !!label
    const finalLabel = label ?? (para.nota ? "Exemple" : null)
    const asItem = !isNota && (listMode === true || (listMode === "auto" && text.length < 170 && endsSentence(text) && !text.endsWith(":")))
    if (asItem) {
      listItems = listItems ?? []
      listItems.push(parts)
    } else {
      closeList()
      ensure().blocks.push(isNota ? { t: "nota", parts, label: finalLabel ?? undefined } : { t: "p", parts })
      if (text.endsWith(":")) listMode = true
    }
    pendingLabel = null
    para = null
  }

  for (let i = 0; i < body.length; i++) {
    const f = body[i]
    const raw = (f.text_value ?? "").replace(/\s+/g, " ")
    const text = raw.trim()
    const next = body[i + 1] ? clean(body[i + 1].text_value ?? "").trim() : null

    if (/\$\{?\w+/.test(text)) continue
    if (CALLOUT.test(text)) {
      closePara()
      pendingLabel = text.replace(/\s*:\s*$/, "")
      continue
    }
    if (f.component === "title") {
      // Encadré titré de l'app (« $title : … ») : le titre suit son contenu dans l'extraction.
      if (next && /^\$\{?title/.test(next) && cur) {
        closePara()
        closeList()
        const blocks = (cur as Section).blocks
        const last = blocks[blocks.length - 1]
        if (last && (last.t === "p" || last.t === "nota")) blocks[blocks.length - 1] = { t: "nota", parts: last.parts, label: text }
        continue
      }
      if (cur && (cur as Section).title === text && !(cur as Section).blocks.length) continue
      open(text, f)
      continue
    }
    if (cur) curFrags.push(f)
    // Titre de la page répété (en-tête Dart) : déjà dans le bandeau.
    if (fontSize(f) >= 18 && text.toLowerCase() === courseTitle.toLowerCase()) continue

    if (!para?.parts.length && isHeading(f, text, next)) {
      closePara()
      closeList()
      listMode = false
      ensure().blocks.push({ t: "sub", text })
      // « Cas où … », « A) … », « 1) … » : suivis d'énoncés courts présentés en liste (✓ dans l'app).
      if (/^([A-Z]|\d+)\)\s/.test(text) || (!NUMBERED.test(text) && /^(cas|conditions?|exceptions?|éléments?)\b/i.test(text))) listMode = "auto"
      continue
    }

    const startsNota: boolean = !para && !!cur && f.component === "TextSpan" && !weight(f) && text.length > 25 && fontSize(f) < 18
    if (!para) para = { parts: [], nota: startsNota }
    const strong = weight(f) && text.length < 70 && f.component !== "_Paragraph"
    para.parts.push({ text: raw, strong })

    let joined = para.parts.map((p) => p.text).join("")
    const nextFrag = body[i + 1]
    // Référence légale en fin de ligne suivie d'une majuscule : le point était une constante Dart.
    if (LAW_END.test(joined) && next !== null && startsUpper(next) && nextFrag?.component !== "title") {
      para.parts[para.parts.length - 1].text = para.parts[para.parts.length - 1].text.replace(/\s*$/, ".")
      joined = joined.replace(/\s*$/, ".")
    }
    const breakHere =
      !nextFrag ||
      nextFrag.component === "title" ||
      (endsSentence(joined) && next !== null && startsUpper(next)) ||
      (joined.trim().endsWith(":") && next !== null && startsUpper(next) && !/^(l[’']|les\s)?(articles?|art\.)\s/i.test(next)) ||
      (para.nota && nextFrag.component !== "TextSpan" && endsSentence(joined)) ||
      // Liste après « : » : chaque ligne Dart commençant par une majuscule est un élément.
      ((listMode as boolean | "auto") === true && !para.nota && next !== null && startsUpper(next) && !/[,;(]\s*$/.test(joined) && !/\b(de|du|des|la|le|les|à|aux|et|ou|en|par|pour)\s*$/i.test(joined)) ||
      (!!nextFrag && CALLOUT.test(clean(nextFrag.text_value ?? "").trim()))
    if (breakHere) closePara()
  }
  closePara()
  closeList()
  if (cur && curFrags.length) (cur as Section).tint = tintFrom(curFrags.slice(0, 3), sections.length - 1)

  return { sections: sections.filter((s) => s.blocks.length > 0 || s.level === 1), subtitle }
}

/** Recolle les morceaux d'un paragraphe (espaces manquants entre lignes Dart). */
function mergeParts(parts: Inline[]): Inline[] {
  const out: Inline[] = []
  for (const p of parts) {
    let text = p.text
    const prev = out[out.length - 1]
    if (prev) {
      const a = prev.text
      if (!/\s$/.test(a) && !/^\s/.test(text) && !/^[,.;:)\]»’'-]/.test(text) && !/[(«’'\[-]$/.test(a)) text = " " + text
      if (prev.strong === p.strong) {
        prev.text = a + text
        continue
      }
    }
    out.push({ text, strong: p.strong })
  }
  if (out.length) {
    out[0].text = out[0].text.replace(/^\s+/, "")
    out[out.length - 1].text = out[out.length - 1].text.replace(/\s+$/, "")
  }
  return out.filter((p) => p.text)
}

/** Références légales mises en avant (en rouge dans l'app). */
export const LAW_RE =
  /((?:l[’']|les\s|aux\s)?(?:articles?|art\.)\s+(?:[LRDA]\.?\s?)?\d+(?:[-–]\d+)*(?:\s*(?:,|à|et)\s*(?:[LRDA]\.?\s?)?\d+(?:[-–]\d+)*)*(?:,?\s*al(?:inéa|\.)\s*\d+)?(?:,?\s*(?:du|de la)\s+(?:Code|C\.)\s*(?:pénal|de procédure pénale|de la route|de la santé publique|de la sécurité intérieure|civil|du travail|de l[’']entrée et du séjour des étrangers(?: et du droit d[’']asile)?|des douanes|de la défense|général des collectivités territoriales|pén\.?|pr\. pén\.?))?)/gi
