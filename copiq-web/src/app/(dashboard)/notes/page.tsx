"use client"
import { useState, useEffect, useMemo } from "react"
import { useRouter } from "next/navigation"
import { createClient } from "@/lib/supabase/client"
import {
  FileText, Plus, Search, Trash2, Edit2, X,
  ChevronDown, StickyNote, Calendar, BookOpen,
} from "lucide-react"

// ─── Types ────────────────────────────────────────────────────────────────────

interface UserNote {
  id: string
  user_id: string
  title: string
  content: string
  module_id: string | null
  created_at: string
  updated_at: string
}

// ─── Modules disponibles ──────────────────────────────────────────────────────

const MODULES = [
  { id: "", label: "Aucun module" },
  { id: "pa-droits-obligations",  label: "PA · Droits et obligations" },
  { id: "pa-procedure-penale",    label: "PA · Procédure pénale" },
  { id: "pa-maintien-ordre",      label: "PA · Maintien de l'ordre" },
  { id: "pa-deontologie",         label: "PA · Déontologie" },
  { id: "gpx-institutions",       label: "GPX · Institutions & valeurs" },
  { id: "gpx-droit-penal",        label: "GPX · Droit pénal" },
  { id: "gpx-securite-publique",  label: "GPX · Sécurité publique" },
  { id: "gpx-culture-generale",   label: "GPX · Culture générale" },
]

// ─── Helpers localStorage fallback ────────────────────────────────────────────

const LS_KEY = "copiq_user_notes"

function lsLoad(): UserNote[] {
  try { return JSON.parse(localStorage.getItem(LS_KEY) ?? "[]") } catch { return [] }
}
function lsSave(notes: UserNote[]) {
  localStorage.setItem(LS_KEY, JSON.stringify(notes))
}
function uid() {
  return Math.random().toString(36).slice(2) + Date.now().toString(36)
}

// ─── Page ─────────────────────────────────────────────────────────────────────

export default function NotesPage() {
  const router = useRouter()
  const supabase = createClient()

  const [notes, setNotes]               = useState<UserNote[]>([])
  const [loading, setLoading]           = useState(true)
  const [userId, setUserId]             = useState<string | null>(null)
  const [useLocalStorage, setUseLS]     = useState(false)

  // UI
  const [search, setSearch]             = useState("")
  const [showModal, setShowModal]       = useState(false)
  const [editNote, setEditNote]         = useState<UserNote | null>(null)
  const [deleteId, setDeleteId]         = useState<string | null>(null)
  const [saving, setSaving]             = useState(false)

  // Form
  const [formTitle, setFormTitle]       = useState("")
  const [formContent, setFormContent]   = useState("")
  const [formModule, setFormModule]     = useState("")

  // ── Auth + chargement ───────────────────────────────────────────────────────

  useEffect(() => {
    supabase.auth.getUser().then(async ({ data }) => {
      if (!data.user) { router.replace("/login"); return }
      const uid_ = data.user.id
      setUserId(uid_)

      try {
        const { data: rows, error } = await (supabase as any)
          .from("user_notes")
          .select("*")
          .eq("user_id", uid_)
          .order("updated_at", { ascending: false })
        if (error) throw error
        setNotes(rows ?? [])
      } catch {
        setUseLS(true)
        setNotes(lsLoad().filter((n) => n.user_id === uid_))
      }

      setLoading(false)
    })
  }, [])

  // ── Filtrage ────────────────────────────────────────────────────────────────

  const filtered = useMemo(() => {
    if (!search.trim()) return notes
    const q = search.toLowerCase()
    return notes.filter(
      (n) => n.title.toLowerCase().includes(q) || n.content.toLowerCase().includes(q)
    )
  }, [notes, search])

  // ── CRUD ────────────────────────────────────────────────────────────────────

  function openCreate() {
    setEditNote(null); setFormTitle(""); setFormContent(""); setFormModule("")
    setShowModal(true)
  }

  function openEdit(note: UserNote) {
    setEditNote(note)
    setFormTitle(note.title)
    setFormContent(note.content)
    setFormModule(note.module_id ?? "")
    setShowModal(true)
  }

  async function handleSave() {
    if (!formTitle.trim() || !userId) return
    setSaving(true)
    const now = new Date().toISOString()

    if (editNote) {
      const updated: UserNote = {
        ...editNote,
        title: formTitle.trim(),
        content: formContent.trim(),
        module_id: formModule || null,
        updated_at: now,
      }
      if (useLocalStorage) {
        const all = lsLoad()
        const i = all.findIndex((n) => n.id === editNote.id)
        if (i !== -1) all[i] = updated
        lsSave(all)
      } else {
        await (supabase as any).from("user_notes").update({
          title: updated.title, content: updated.content,
          module_id: updated.module_id, updated_at: now,
        }).eq("id", editNote.id)
      }
      setNotes((prev) => prev.map((n) => (n.id === editNote.id ? updated : n)))
    } else {
      const newNote: UserNote = {
        id: uid(), user_id: userId,
        title: formTitle.trim(), content: formContent.trim(),
        module_id: formModule || null, created_at: now, updated_at: now,
      }
      if (useLocalStorage) {
        const all = lsLoad(); all.unshift(newNote); lsSave(all)
      } else {
        const { data: ins, error } = await (supabase as any)
          .from("user_notes")
          .insert({ user_id: userId, title: newNote.title, content: newNote.content, module_id: newNote.module_id })
          .select().single()
        if (!error && ins) newNote.id = ins.id
      }
      setNotes((prev) => [newNote, ...prev])
    }

    setSaving(false)
    setShowModal(false)
  }

  async function handleDelete(id: string) {
    if (useLocalStorage) {
      lsSave(lsLoad().filter((n) => n.id !== id))
    } else {
      await (supabase as any).from("user_notes").delete().eq("id", id)
    }
    setNotes((prev) => prev.filter((n) => n.id !== id))
    setDeleteId(null)
  }

  function fmtDate(iso: string) {
    return new Date(iso).toLocaleDateString("fr-FR", { day: "numeric", month: "short", year: "numeric" })
  }

  function moduleLabel(id: string | null) {
    if (!id) return null
    return MODULES.find((m) => m.id === id)?.label ?? id
  }

  // ─────────────────────────────────────────────────────────────────────────────

  if (loading) return (
    <div className="flex items-center justify-center h-64">
      <div className="w-8 h-8 border-2 border-[#1147D9] border-t-transparent rounded-full animate-spin" />
    </div>
  )

  return (
    <div className="max-w-4xl mx-auto px-4 py-8 space-y-6">

      {/* Header */}
      <div className="flex items-center justify-between gap-4 flex-wrap">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-xl bg-[#1147D9]/10 flex items-center justify-center">
            <FileText size={20} className="text-[#1147D9]" />
          </div>
          <div>
            <h1 className="text-2xl font-bold text-[var(--on-surface)]">Mes notes</h1>
            <p className="text-sm text-[var(--on-surface-muted)]">
              {notes.length} note{notes.length !== 1 ? "s" : ""} enregistrée{notes.length !== 1 ? "s" : ""}
            </p>
          </div>
        </div>
        <button
          onClick={openCreate}
          className="inline-flex items-center gap-2 px-4 py-2.5 rounded-xl bg-[#1147D9] text-white text-sm font-semibold hover:bg-[#0f3fbd] transition-all"
        >
          <Plus size={16} />
          Nouvelle note
        </button>
      </div>

      {/* Recherche */}
      <div className="relative">
        <Search size={16} className="absolute left-3 top-1/2 -translate-y-1/2 text-[var(--on-surface-muted)]" />
        <input
          type="text"
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          placeholder="Rechercher dans vos notes…"
          className="w-full pl-9 pr-4 py-2.5 rounded-xl border border-[var(--outline)] bg-[var(--surface)] text-[var(--on-surface)] text-sm placeholder:text-[var(--on-surface-muted)] focus:outline-none focus:border-[#1147D9] transition-colors"
        />
      </div>

      {/* Liste */}
      {filtered.length === 0 ? (
        <div className="rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-14 text-center">
          <StickyNote size={44} className="mx-auto mb-4 text-[var(--on-surface-muted)] opacity-30" />
          {search ? (
            <>
              <p className="font-semibold text-[var(--on-surface)]">Aucune note trouvée</p>
              <p className="text-sm text-[var(--on-surface-muted)] mt-1">
                Aucun résultat pour &laquo;&nbsp;{search}&nbsp;&raquo;
              </p>
            </>
          ) : (
            <>
              <p className="font-semibold text-[var(--on-surface)]">Aucune note pour l&apos;instant</p>
              <p className="text-sm text-[var(--on-surface-muted)] mt-1">
                Prenez des notes pendant vos révisions pour les retrouver ici
              </p>
              <button
                onClick={openCreate}
                className="mt-5 inline-flex items-center gap-2 px-4 py-2 rounded-xl border border-[#1147D9] text-[#1147D9] text-sm font-semibold hover:bg-[#1147D9]/5 transition-all"
              >
                <Plus size={14} />
                Créer ma première note
              </button>
            </>
          )}
        </div>
      ) : (
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
          {filtered.map((note) => (
            <div
              key={note.id}
              onClick={() => openEdit(note)}
              className="group relative rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-5 flex flex-col gap-3 hover:border-[#1147D9]/40 hover:shadow-sm transition-all cursor-pointer"
            >
              <div className="flex items-start justify-between gap-2">
                <h2 className="font-semibold text-[var(--on-surface)] text-sm leading-snug line-clamp-2 group-hover:text-[#1147D9] transition-colors">
                  {note.title}
                </h2>
                <button
                  onClick={(e) => { e.stopPropagation(); setDeleteId(note.id) }}
                  className="shrink-0 w-7 h-7 rounded-lg flex items-center justify-center text-[var(--on-surface-muted)] hover:bg-red-500/10 hover:text-red-500 transition-all opacity-0 group-hover:opacity-100"
                >
                  <Trash2 size={13} />
                </button>
              </div>

              {note.content && (
                <p className="text-xs text-[var(--on-surface-muted)] line-clamp-3 leading-relaxed">
                  {note.content}
                </p>
              )}

              <div className="flex items-center justify-between mt-auto pt-1">
                <div>
                  {moduleLabel(note.module_id) && (
                    <span className="inline-flex items-center gap-1 text-[10px] font-semibold px-2 py-0.5 rounded-full bg-[#1147D9]/10 text-[#1147D9]">
                      <BookOpen size={9} />
                      {moduleLabel(note.module_id)}
                    </span>
                  )}
                </div>
                <span className="flex items-center gap-1 text-[10px] text-[var(--on-surface-muted)]">
                  <Calendar size={9} />
                  {fmtDate(note.updated_at)}
                </span>
              </div>
            </div>
          ))}
        </div>
      )}

      {/* ── Modale création / édition ───────────────────────────────────────── */}
      {showModal && (
        <div
          className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/40 backdrop-blur-sm"
          onClick={(e) => { if (e.target === e.currentTarget) setShowModal(false) }}
        >
          <div className="w-full max-w-lg rounded-2xl border border-[var(--outline)] bg-[var(--surface)] shadow-2xl overflow-hidden">
            {/* En-tête */}
            <div className="flex items-center justify-between px-6 py-4 border-b border-[var(--outline)]">
              <div className="flex items-center gap-2">
                <Edit2 size={16} className="text-[#1147D9]" />
                <span className="font-semibold text-[var(--on-surface)]">
                  {editNote ? "Modifier la note" : "Nouvelle note"}
                </span>
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
              <div>
                <label className="text-xs font-semibold text-[var(--on-surface-muted)] uppercase tracking-wide mb-1.5 block">Titre</label>
                <input
                  type="text"
                  value={formTitle}
                  onChange={(e) => setFormTitle(e.target.value)}
                  placeholder="Titre de la note"
                  autoFocus
                  className="w-full px-3.5 py-2.5 rounded-xl border border-[var(--outline)] bg-[var(--surface)] text-[var(--on-surface)] text-sm placeholder:text-[var(--on-surface-muted)] focus:outline-none focus:border-[#1147D9] transition-colors"
                />
              </div>

              <div>
                <label className="text-xs font-semibold text-[var(--on-surface-muted)] uppercase tracking-wide mb-1.5 block">Contenu</label>
                <textarea
                  value={formContent}
                  onChange={(e) => setFormContent(e.target.value)}
                  placeholder="Écrivez votre note ici…"
                  rows={7}
                  className="w-full px-3.5 py-2.5 rounded-xl border border-[var(--outline)] bg-[var(--surface)] text-[var(--on-surface)] text-sm placeholder:text-[var(--on-surface-muted)] focus:outline-none focus:border-[#1147D9] transition-colors resize-none leading-relaxed"
                />
              </div>

              <div>
                <label className="text-xs font-semibold text-[var(--on-surface-muted)] uppercase tracking-wide mb-1.5 block">Module associé</label>
                <div className="relative">
                  <select
                    value={formModule}
                    onChange={(e) => setFormModule(e.target.value)}
                    className="w-full appearance-none px-3.5 py-2.5 pr-9 rounded-xl border border-[var(--outline)] bg-[var(--surface)] text-[var(--on-surface)] text-sm focus:outline-none focus:border-[#1147D9] transition-colors"
                  >
                    {MODULES.map((m) => (
                      <option key={m.id} value={m.id}>{m.label}</option>
                    ))}
                  </select>
                  <ChevronDown size={14} className="pointer-events-none absolute right-3 top-1/2 -translate-y-1/2 text-[var(--on-surface-muted)]" />
                </div>
              </div>
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
                onClick={handleSave}
                disabled={!formTitle.trim() || saving}
                className="px-5 py-2 rounded-xl bg-[#1147D9] text-white text-sm font-semibold hover:bg-[#0f3fbd] disabled:opacity-50 disabled:cursor-not-allowed transition-all"
              >
                {saving ? "Enregistrement…" : "Enregistrer"}
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
              <p className="font-semibold text-[var(--on-surface)]">Supprimer la note ?</p>
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
