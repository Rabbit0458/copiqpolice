"use client"
import { useState, useEffect, useMemo } from "react"
import { useRouter } from "next/navigation"
import { createClient } from "@/lib/supabase/client"
import {
  Brain, Plus, Trash2, X, ChevronDown,
  RotateCcw, Check, ArrowLeft, ArrowRight,
  Trophy, Eye, Filter,
} from "lucide-react"

// ─── Types ────────────────────────────────────────────────────────────────────

interface UserMemo {
  id: string
  user_id: string
  front: string
  back: string
  color: MemoColor
  theme: string
  created_at: string
}

type MemoColor = "blue" | "purple" | "green" | "orange" | "red"

// ─── Constantes couleurs ──────────────────────────────────────────────────────

const COLORS: { id: MemoColor; label: string; bg: string; border: string; text: string; dot: string }[] = [
  { id: "blue",   label: "Bleu",   bg: "rgba(17,71,217,0.12)",  border: "#1147D9", text: "#1147D9", dot: "bg-[#1147D9]" },
  { id: "purple", label: "Violet", bg: "rgba(139,92,246,0.12)", border: "#8B5CF6", text: "#8B5CF6", dot: "bg-[#8B5CF6]" },
  { id: "green",  label: "Vert",   bg: "rgba(34,197,94,0.12)",  border: "#22C55E", text: "#22C55E", dot: "bg-[#22C55E]" },
  { id: "orange", label: "Orange", bg: "rgba(234,179,8,0.12)",  border: "#EAB308", text: "#CA8A04", dot: "bg-[#EAB308]" },
  { id: "red",    label: "Rouge",  bg: "rgba(239,68,68,0.12)",  border: "#EF4444", text: "#EF4444", dot: "bg-[#EF4444]" },
]

const THEMES = [
  "Général",
  "PA · Droits et obligations",
  "PA · Procédure pénale",
  "PA · Maintien de l'ordre",
  "PA · Déontologie",
  "GPX · Institutions",
  "GPX · Droit pénal",
  "GPX · Sécurité publique",
  "GPX · Culture générale",
]

// ─── Helpers localStorage ─────────────────────────────────────────────────────

const LS_KEY = "copiq_user_memos"

function lsLoad(): UserMemo[] {
  try { return JSON.parse(localStorage.getItem(LS_KEY) ?? "[]") } catch { return [] }
}
function lsSave(memos: UserMemo[]) {
  localStorage.setItem(LS_KEY, JSON.stringify(memos))
}
function uid() {
  return Math.random().toString(36).slice(2) + Date.now().toString(36)
}

function colorOf(id: MemoColor) {
  return COLORS.find((c) => c.id === id) ?? COLORS[0]
}

// ─── Page ─────────────────────────────────────────────────────────────────────

export default function MemosPage() {
  const router = useRouter()
  const supabase = createClient()

  const [memos, setMemos]           = useState<UserMemo[]>([])
  const [loading, setLoading]       = useState(true)
  const [userId, setUserId]         = useState<string | null>(null)
  const [useLS, setUseLS]           = useState(false)

  // Filtres
  const [filterColor, setFilterColor] = useState<MemoColor | "all">("all")
  const [filterTheme, setFilterTheme] = useState<string>("all")

  // Modale création
  const [showModal, setShowModal]   = useState(false)
  const [saving, setSaving]         = useState(false)
  const [formFront, setFormFront]   = useState("")
  const [formBack, setFormBack]     = useState("")
  const [formColor, setFormColor]   = useState<MemoColor>("blue")
  const [formTheme, setFormTheme]   = useState("Général")

  // Confirmation suppression
  const [deleteId, setDeleteId]     = useState<string | null>(null)

  // Mode révision
  const [reviewMode, setReviewMode]     = useState(false)
  const [reviewCards, setReviewCards]   = useState<UserMemo[]>([])
  const [reviewIndex, setReviewIndex]   = useState(0)
  const [flipped, setFlipped]           = useState(false)
  const [mastered, setMastered]         = useState<Set<string>>(new Set())
  const [toReview, setToReview]         = useState<string[]>([])
  const [reviewDone, setReviewDone]     = useState(false)

  // ── Auth + chargement ───────────────────────────────────────────────────────

  useEffect(() => {
    supabase.auth.getUser().then(async ({ data }) => {
      if (!data.user) { router.replace("/login"); return }
      const uid_ = data.user.id
      setUserId(uid_)

      try {
        const { data: rows, error } = await (supabase as any)
          .from("user_memos")
          .select("*")
          .eq("user_id", uid_)
          .order("created_at", { ascending: false })
        if (error) throw error
        setMemos(rows ?? [])
      } catch {
        setUseLS(true)
        setMemos(lsLoad().filter((m) => m.user_id === uid_))
      }

      setLoading(false)
    })
  }, [])

  // ── Filtrage ────────────────────────────────────────────────────────────────

  const filtered = useMemo(() => {
    return memos.filter((m) => {
      if (filterColor !== "all" && m.color !== filterColor) return false
      if (filterTheme !== "all" && m.theme !== filterTheme) return false
      return true
    })
  }, [memos, filterColor, filterTheme])

  const themes = useMemo(
    () => Array.from(new Set(memos.map((m) => m.theme))),
    [memos]
  )

  // ── CRUD ────────────────────────────────────────────────────────────────────

  async function handleCreate() {
    if (!formFront.trim() || !userId) return
    setSaving(true)
    const now = new Date().toISOString()

    const newMemo: UserMemo = {
      id: uid(),
      user_id: userId,
      front: formFront.trim(),
      back: formBack.trim(),
      color: formColor,
      theme: formTheme,
      created_at: now,
    }

    if (useLS) {
      const all = lsLoad(); all.unshift(newMemo); lsSave(all)
    } else {
      const { data: ins, error } = await (supabase as any)
        .from("user_memos")
        .insert({ user_id: userId, front: newMemo.front, back: newMemo.back, color: newMemo.color, theme: newMemo.theme })
        .select().single()
      if (!error && ins) newMemo.id = ins.id
    }

    setMemos((prev) => [newMemo, ...prev])
    setSaving(false)
    setShowModal(false)
    setFormFront(""); setFormBack(""); setFormColor("blue"); setFormTheme("Général")
  }

  async function handleDelete(id: string) {
    if (useLS) {
      lsSave(lsLoad().filter((m) => m.id !== id))
    } else {
      await (supabase as any).from("user_memos").delete().eq("id", id)
    }
    setMemos((prev) => prev.filter((m) => m.id !== id))
    setDeleteId(null)
  }

  // ── Mode révision ────────────────────────────────────────────────────────────

  function startReview() {
    const deck = filtered.length > 0 ? filtered : memos
    if (deck.length === 0) return
    setReviewCards([...deck].sort(() => Math.random() - 0.5))
    setReviewIndex(0)
    setFlipped(false)
    setMastered(new Set())
    setToReview([])
    setReviewDone(false)
    setReviewMode(true)
  }

  function handleMastered() {
    const card = reviewCards[reviewIndex]
    setMastered((prev) => new Set([...prev, card.id]))
    next()
  }

  function handleToReview() {
    const card = reviewCards[reviewIndex]
    setToReview((prev) => [...prev, card.id])
    next()
  }

  function next() {
    if (reviewIndex + 1 >= reviewCards.length) {
      setReviewDone(true)
    } else {
      setReviewIndex((i) => i + 1)
      setFlipped(false)
    }
  }

  // ─────────────────────────────────────────────────────────────────────────────

  if (loading) return (
    <div className="flex items-center justify-center h-64">
      <div className="w-8 h-8 border-2 border-[#8B5CF6] border-t-transparent rounded-full animate-spin" />
    </div>
  )

  // ── Mode révision fullscreen ─────────────────────────────────────────────────

  if (reviewMode) {
    if (reviewDone) {
      const score = mastered.size
      const total = reviewCards.length
      const pct   = Math.round((score / total) * 100)

      return (
        <div className="fixed inset-0 z-50 flex flex-col items-center justify-center bg-[var(--surface)] p-6">
          <div className="w-full max-w-md text-center flex flex-col items-center gap-6">
            <div className="w-20 h-20 rounded-full bg-[#8B5CF6]/15 flex items-center justify-center">
              <Trophy size={36} className="text-[#8B5CF6]" />
            </div>
            <div>
              <h2 className="text-2xl font-bold text-[var(--on-surface)]">Session terminée !</h2>
              <p className="text-[var(--on-surface-muted)] mt-1 text-sm">
                Voici votre résultat sur {total} fiche{total > 1 ? "s" : ""}
              </p>
            </div>

            {/* Score */}
            <div className="w-full rounded-2xl border border-[var(--outline)] bg-[var(--surface-dark,var(--surface))] p-6 flex flex-col items-center gap-3">
              <div className="text-5xl font-black text-[#8B5CF6]">{pct}%</div>
              <div className="flex gap-6 text-sm">
                <div className="flex items-center gap-2">
                  <span className="w-3 h-3 rounded-full bg-emerald-500" />
                  <span className="text-[var(--on-surface-muted)]">{score} maîtrisée{score > 1 ? "s" : ""}</span>
                </div>
                <div className="flex items-center gap-2">
                  <span className="w-3 h-3 rounded-full bg-amber-500" />
                  <span className="text-[var(--on-surface-muted)]">{toReview.length} à revoir</span>
                </div>
              </div>
              {/* Barre */}
              <div className="w-full h-2 rounded-full bg-[var(--outline)] overflow-hidden">
                <div
                  className="h-2 rounded-full bg-[#8B5CF6] transition-all"
                  style={{ width: `${pct}%` }}
                />
              </div>
            </div>

            <div className="flex gap-3 w-full">
              <button
                onClick={() => setReviewMode(false)}
                className="flex-1 py-2.5 rounded-xl border border-[var(--outline)] text-[var(--on-surface-muted)] text-sm font-semibold hover:bg-[var(--outline)] transition-all"
              >
                Retour aux fiches
              </button>
              <button
                onClick={startReview}
                className="flex-1 py-2.5 rounded-xl bg-[#8B5CF6] text-white text-sm font-semibold hover:bg-[#7c3aed] transition-all flex items-center justify-center gap-2"
              >
                <RotateCcw size={14} />
                Recommencer
              </button>
            </div>
          </div>
        </div>
      )
    }

    const card = reviewCards[reviewIndex]
    const col  = colorOf(card.color)
    const prog = ((reviewIndex) / reviewCards.length) * 100

    return (
      <div className="fixed inset-0 z-50 flex flex-col items-center justify-center bg-[var(--surface)] p-6">
        {/* Barre de progression + fermer */}
        <div className="absolute top-0 left-0 right-0 p-4 flex items-center gap-3">
          <button
            onClick={() => setReviewMode(false)}
            className="w-8 h-8 rounded-lg flex items-center justify-center text-[var(--on-surface-muted)] hover:bg-[var(--outline)] transition-all"
          >
            <X size={16} />
          </button>
          <div className="flex-1 h-1.5 rounded-full bg-[var(--outline)] overflow-hidden">
            <div
              className="h-1.5 rounded-full bg-[#8B5CF6] transition-all duration-300"
              style={{ width: `${prog}%` }}
            />
          </div>
          <span className="text-xs font-semibold text-[var(--on-surface-muted)] min-w-[3rem] text-right">
            {reviewIndex + 1}/{reviewCards.length}
          </span>
        </div>

        {/* Carte flip */}
        <div className="w-full max-w-lg" style={{ perspective: "1200px" }}>
          <div
            onClick={() => setFlipped((f) => !f)}
            className="relative w-full cursor-pointer transition-transform duration-500"
            style={{
              transformStyle: "preserve-3d",
              transform: flipped ? "rotateY(180deg)" : "rotateY(0deg)",
              height: "260px",
            }}
          >
            {/* Recto */}
            <div
              className="absolute inset-0 rounded-2xl border-2 flex flex-col items-center justify-center p-8 gap-4 select-none"
              style={{
                backfaceVisibility: "hidden",
                WebkitBackfaceVisibility: "hidden",
                background: col.bg,
                borderColor: col.border,
              }}
            >
              <span
                className="text-[10px] font-bold uppercase tracking-widest"
                style={{ color: col.text }}
              >
                Recto — Question
              </span>
              <p className="text-xl font-bold text-[var(--on-surface)] text-center leading-snug">
                {card.front}
              </p>
              <span className="text-xs text-[var(--on-surface-muted)] flex items-center gap-1 mt-2">
                <Eye size={11} /> Cliquez pour révéler la réponse
              </span>
            </div>

            {/* Verso */}
            <div
              className="absolute inset-0 rounded-2xl border-2 flex flex-col items-center justify-center p-8 gap-4 select-none"
              style={{
                backfaceVisibility: "hidden",
                WebkitBackfaceVisibility: "hidden",
                transform: "rotateY(180deg)",
                background: col.bg,
                borderColor: col.border,
              }}
            >
              <span
                className="text-[10px] font-bold uppercase tracking-widest"
                style={{ color: col.text }}
              >
                Verso — Réponse
              </span>
              <p className="text-xl font-bold text-[var(--on-surface)] text-center leading-snug">
                {card.back || <span className="text-[var(--on-surface-muted)] italic font-normal text-base">Pas de verso défini</span>}
              </p>
            </div>
          </div>
        </div>

        {/* Boutons Je savais / À revoir */}
        {flipped && (
          <div className="flex gap-4 mt-8">
            <button
              onClick={handleToReview}
              className="flex items-center gap-2 px-6 py-3 rounded-xl border-2 border-amber-400 bg-amber-400/10 text-amber-600 font-semibold text-sm hover:bg-amber-400/20 transition-all"
            >
              <ArrowLeft size={16} />
              À revoir
            </button>
            <button
              onClick={handleMastered}
              className="flex items-center gap-2 px-6 py-3 rounded-xl border-2 border-emerald-500 bg-emerald-500/10 text-emerald-600 font-semibold text-sm hover:bg-emerald-500/20 transition-all"
            >
              Je savais
              <Check size={16} />
            </button>
          </div>
        )}

        {!flipped && (
          <p className="mt-8 text-xs text-[var(--on-surface-muted)]">
            Touchez la carte pour retourner
          </p>
        )}

        {/* Thème */}
        <span className="mt-4 text-[10px] text-[var(--on-surface-muted)] font-medium">
          {card.theme}
        </span>
      </div>
    )
  }

  // ── Vue principale ────────────────────────────────────────────────────────────

  const masteredCount = memos.length // placeholder — suivi réel possible via table séparée

  return (
    <div className="max-w-4xl mx-auto px-4 py-8 space-y-6">

      {/* Header */}
      <div className="flex items-center justify-between gap-4 flex-wrap">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-xl bg-[#8B5CF6]/10 flex items-center justify-center">
            <Brain size={20} className="text-[#8B5CF6]" />
          </div>
          <div>
            <h1 className="text-2xl font-bold text-[var(--on-surface)]">Mes mémos</h1>
            <p className="text-sm text-[var(--on-surface-muted)]">
              {memos.length} fiche{memos.length !== 1 ? "s" : ""}
            </p>
          </div>
        </div>

        <div className="flex items-center gap-2">
          {memos.length > 0 && (
            <button
              onClick={startReview}
              className="inline-flex items-center gap-2 px-4 py-2.5 rounded-xl border border-[#8B5CF6] text-[#8B5CF6] text-sm font-semibold hover:bg-[#8B5CF6]/5 transition-all"
            >
              <RotateCcw size={14} />
              Réviser
            </button>
          )}
          <button
            onClick={() => setShowModal(true)}
            className="inline-flex items-center gap-2 px-4 py-2.5 rounded-xl bg-[#8B5CF6] text-white text-sm font-semibold hover:bg-[#7c3aed] transition-all"
          >
            <Plus size={16} />
            Nouvelle fiche
          </button>
        </div>
      </div>

      {/* Filtres */}
      {memos.length > 0 && (
        <div className="flex items-center gap-3 flex-wrap">
          <div className="flex items-center gap-1.5 text-xs text-[var(--on-surface-muted)]">
            <Filter size={12} />
            Filtrer :
          </div>

          {/* Filtre couleur */}
          <div className="flex items-center gap-1.5">
            <button
              onClick={() => setFilterColor("all")}
              className={`px-2.5 py-1 rounded-lg text-xs font-semibold transition-all ${
                filterColor === "all"
                  ? "bg-[var(--outline)] text-[var(--on-surface)]"
                  : "text-[var(--on-surface-muted)] hover:bg-[var(--outline)]"
              }`}
            >
              Toutes
            </button>
            {COLORS.map((c) => (
              <button
                key={c.id}
                onClick={() => setFilterColor(filterColor === c.id ? "all" : c.id)}
                title={c.label}
                className={`w-5 h-5 rounded-full transition-all ${c.dot} ${
                  filterColor === c.id ? "ring-2 ring-offset-2 ring-current scale-110" : "opacity-60 hover:opacity-100"
                }`}
              />
            ))}
          </div>

          {/* Filtre thème */}
          {themes.length > 1 && (
            <div className="relative">
              <select
                value={filterTheme}
                onChange={(e) => setFilterTheme(e.target.value)}
                className="appearance-none pl-3 pr-7 py-1 rounded-lg border border-[var(--outline)] bg-[var(--surface)] text-[var(--on-surface)] text-xs focus:outline-none focus:border-[#8B5CF6] transition-colors"
              >
                <option value="all">Tous les thèmes</option>
                {themes.map((t) => <option key={t} value={t}>{t}</option>)}
              </select>
              <ChevronDown size={11} className="pointer-events-none absolute right-2 top-1/2 -translate-y-1/2 text-[var(--on-surface-muted)]" />
            </div>
          )}
        </div>
      )}

      {/* Grille des fiches */}
      {filtered.length === 0 ? (
        <div className="rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-14 text-center">
          <Brain size={44} className="mx-auto mb-4 text-[var(--on-surface-muted)] opacity-30" />
          {memos.length === 0 ? (
            <>
              <p className="font-semibold text-[var(--on-surface)]">Aucune fiche mémo</p>
              <p className="text-sm text-[var(--on-surface-muted)] mt-1">
                Créez vos premières fiches pour réviser en mode flashcard
              </p>
              <button
                onClick={() => setShowModal(true)}
                className="mt-5 inline-flex items-center gap-2 px-4 py-2 rounded-xl border border-[#8B5CF6] text-[#8B5CF6] text-sm font-semibold hover:bg-[#8B5CF6]/5 transition-all"
              >
                <Plus size={14} />
                Créer ma première fiche
              </button>
            </>
          ) : (
            <>
              <p className="font-semibold text-[var(--on-surface)]">Aucune fiche pour ces filtres</p>
              <button
                onClick={() => { setFilterColor("all"); setFilterTheme("all") }}
                className="mt-3 text-sm text-[#8B5CF6] hover:underline"
              >
                Effacer les filtres
              </button>
            </>
          )}
        </div>
      ) : (
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
          {filtered.map((memo) => {
            const col = colorOf(memo.color)
            return (
              <div
                key={memo.id}
                className="group relative rounded-2xl border-2 p-5 flex flex-col gap-3 transition-all hover:shadow-md"
                style={{ background: col.bg, borderColor: col.border + "60" }}
              >
                {/* Bouton supprimer */}
                <button
                  onClick={() => setDeleteId(memo.id)}
                  className="absolute top-3 right-3 w-6 h-6 rounded-md flex items-center justify-center text-[var(--on-surface-muted)] hover:bg-red-500/10 hover:text-red-500 transition-all opacity-0 group-hover:opacity-100"
                >
                  <Trash2 size={12} />
                </button>

                {/* Recto */}
                <div>
                  <span
                    className="text-[9px] font-bold uppercase tracking-widest"
                    style={{ color: col.text }}
                  >
                    Recto
                  </span>
                  <p className="font-semibold text-sm text-[var(--on-surface)] mt-0.5 line-clamp-2">
                    {memo.front}
                  </p>
                </div>

                {/* Séparateur */}
                <div className="border-t border-dashed" style={{ borderColor: col.border + "50" }} />

                {/* Verso */}
                <div>
                  <span
                    className="text-[9px] font-bold uppercase tracking-widest"
                    style={{ color: col.text }}
                  >
                    Verso
                  </span>
                  <p className="text-xs text-[var(--on-surface-muted)] mt-0.5 line-clamp-2">
                    {memo.back || <span className="italic">—</span>}
                  </p>
                </div>

                {/* Thème badge */}
                <div className="mt-auto pt-1">
                  <span
                    className="text-[9px] font-semibold px-2 py-0.5 rounded-full"
                    style={{ background: col.border + "20", color: col.text }}
                  >
                    {memo.theme}
                  </span>
                </div>
              </div>
            )
          })}
        </div>
      )}

      {/* ── Modale création fiche ───────────────────────────────────────────── */}
      {showModal && (
        <div
          className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/40 backdrop-blur-sm"
          onClick={(e) => { if (e.target === e.currentTarget) setShowModal(false) }}
        >
          <div className="w-full max-w-md rounded-2xl border border-[var(--outline)] bg-[var(--surface)] shadow-2xl overflow-hidden">
            {/* En-tête */}
            <div className="flex items-center justify-between px-6 py-4 border-b border-[var(--outline)]">
              <div className="flex items-center gap-2">
                <Brain size={16} className="text-[#8B5CF6]" />
                <span className="font-semibold text-[var(--on-surface)]">Nouvelle fiche mémo</span>
              </div>
              <button
                onClick={() => setShowModal(false)}
                className="w-7 h-7 rounded-lg flex items-center justify-center text-[var(--on-surface-muted)] hover:bg-[var(--outline)] transition-all"
              >
                <X size={16} />
              </button>
            </div>

            {/* Corps */}
            <div className="px-6 py-5 flex flex-col gap-4">
              {/* Recto */}
              <div>
                <label className="text-xs font-semibold text-[var(--on-surface-muted)] uppercase tracking-wide mb-1.5 block">
                  Recto — Question / Terme
                </label>
                <textarea
                  value={formFront}
                  onChange={(e) => setFormFront(e.target.value)}
                  placeholder="Ex : Qu'est-ce que la garde à vue ?"
                  rows={3}
                  autoFocus
                  className="w-full px-3.5 py-2.5 rounded-xl border border-[var(--outline)] bg-[var(--surface)] text-[var(--on-surface)] text-sm placeholder:text-[var(--on-surface-muted)] focus:outline-none focus:border-[#8B5CF6] transition-colors resize-none"
                />
              </div>

              {/* Verso */}
              <div>
                <label className="text-xs font-semibold text-[var(--on-surface-muted)] uppercase tracking-wide mb-1.5 block">
                  Verso — Réponse / Définition
                </label>
                <textarea
                  value={formBack}
                  onChange={(e) => setFormBack(e.target.value)}
                  placeholder="Ex : Mesure privative de liberté permettant de retenir un suspect…"
                  rows={3}
                  className="w-full px-3.5 py-2.5 rounded-xl border border-[var(--outline)] bg-[var(--surface)] text-[var(--on-surface)] text-sm placeholder:text-[var(--on-surface-muted)] focus:outline-none focus:border-[#8B5CF6] transition-colors resize-none"
                />
              </div>

              {/* Couleur */}
              <div>
                <label className="text-xs font-semibold text-[var(--on-surface-muted)] uppercase tracking-wide mb-2 block">
                  Couleur
                </label>
                <div className="flex items-center gap-2">
                  {COLORS.map((c) => (
                    <button
                      key={c.id}
                      onClick={() => setFormColor(c.id)}
                      title={c.label}
                      className={`w-8 h-8 rounded-full transition-all ${c.dot} ${
                        formColor === c.id
                          ? "ring-2 ring-offset-2 ring-[#8B5CF6] scale-110"
                          : "opacity-60 hover:opacity-100 hover:scale-105"
                      }`}
                    />
                  ))}
                </div>
              </div>

              {/* Thème */}
              <div>
                <label className="text-xs font-semibold text-[var(--on-surface-muted)] uppercase tracking-wide mb-1.5 block">
                  Thème associé
                </label>
                <div className="relative">
                  <select
                    value={formTheme}
                    onChange={(e) => setFormTheme(e.target.value)}
                    className="w-full appearance-none px-3.5 py-2.5 pr-9 rounded-xl border border-[var(--outline)] bg-[var(--surface)] text-[var(--on-surface)] text-sm focus:outline-none focus:border-[#8B5CF6] transition-colors"
                  >
                    {THEMES.map((t) => (
                      <option key={t} value={t}>{t}</option>
                    ))}
                  </select>
                  <ChevronDown size={14} className="pointer-events-none absolute right-3 top-1/2 -translate-y-1/2 text-[var(--on-surface-muted)]" />
                </div>
              </div>

              {/* Prévisualisation */}
              {(formFront || formBack) && (
                <div
                  className="rounded-xl border-2 p-4"
                  style={{ background: colorOf(formColor).bg, borderColor: colorOf(formColor).border + "80" }}
                >
                  <p className="text-[9px] font-bold uppercase tracking-widest mb-1" style={{ color: colorOf(formColor).text }}>Aperçu</p>
                  <p className="text-sm font-semibold text-[var(--on-surface)]">{formFront || "—"}</p>
                  {formBack && (
                    <>
                      <div className="border-t border-dashed my-2" style={{ borderColor: colorOf(formColor).border + "40" }} />
                      <p className="text-xs text-[var(--on-surface-muted)]">{formBack}</p>
                    </>
                  )}
                </div>
              )}
            </div>

            {/* Pied */}
            <div className="px-6 py-4 border-t border-[var(--outline)] flex items-center justify-end gap-3">
              <button
                onClick={() => setShowModal(false)}
                className="px-4 py-2 rounded-xl text-sm font-semibold text-[var(--on-surface-muted)] hover:bg-[var(--outline)] transition-all"
              >
                Annuler
              </button>
              <button
                onClick={handleCreate}
                disabled={!formFront.trim() || saving}
                className="px-5 py-2 rounded-xl bg-[#8B5CF6] text-white text-sm font-semibold hover:bg-[#7c3aed] disabled:opacity-50 disabled:cursor-not-allowed transition-all"
              >
                {saving ? "Enregistrement…" : "Créer la fiche"}
              </button>
            </div>
          </div>
        </div>
      )}

      {/* ── Modale confirmation suppression ────────────────────────────────── */}
      {deleteId && (
        <div
          className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/40 backdrop-blur-sm"
          onClick={(e) => { if (e.target === e.currentTarget) setDeleteId(null) }}
        >
          <div className="w-full max-w-sm rounded-2xl border border-[var(--outline)] bg-[var(--surface)] shadow-2xl p-6 flex flex-col gap-4">
            <div className="w-11 h-11 rounded-full bg-red-500/10 flex items-center justify-center mx-auto">
              <Trash2 size={20} className="text-red-500" />
            </div>
            <div className="text-center">
              <p className="font-semibold text-[var(--on-surface)]">Supprimer la fiche ?</p>
              <p className="text-sm text-[var(--on-surface-muted)] mt-1">Cette action est irréversible.</p>
            </div>
            <div className="flex gap-3">
              <button
                onClick={() => setDeleteId(null)}
                className="flex-1 py-2 rounded-xl text-sm font-semibold border border-[var(--outline)] text-[var(--on-surface-muted)] hover:bg-[var(--outline)] transition-all"
              >
                Annuler
              </button>
              <button
                onClick={() => handleDelete(deleteId)}
                className="flex-1 py-2 rounded-xl bg-red-500 text-white text-sm font-semibold hover:bg-red-600 transition-all"
              >
                Supprimer
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
