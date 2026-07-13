"use client"
import { User } from "@supabase/supabase-js"
import { createBrowserClient } from "@/lib/supabase/client"
import { useState } from "react"
import { useRouter } from "next/navigation"
import { Settings, Lock, Bell, Trash2, AlertTriangle, Check, Loader2 } from "lucide-react"
import toast from "react-hot-toast"

export default function ParametresContent({ user }: { user: User }) {
  const supabase = createBrowserClient()
  const router = useRouter()
  const [pwLoading, setPwLoading] = useState(false)
  const [deleteLoading, setDeleteLoading] = useState(false)
  const [confirmDelete, setConfirmDelete] = useState("")
  const [newPw, setNewPw] = useState("")
  const [confirmPw, setConfirmPw] = useState("")

  async function handleUpdatePassword(e: React.FormEvent) {
    e.preventDefault()
    if (newPw !== confirmPw) { toast.error("Les mots de passe ne correspondent pas"); return }
    if (newPw.length < 8) { toast.error("Minimum 8 caractères"); return }
    setPwLoading(true)
    const { error } = await supabase.auth.updateUser({ password: newPw })
    setPwLoading(false)
    if (error) toast.error(error.message)
    else { toast.success("Mot de passe mis à jour !"); setNewPw(""); setConfirmPw("") }
  }

  async function handleDeleteAccount() {
    if (confirmDelete !== user.email) { toast.error("Email incorrect"); return }
    setDeleteLoading(true)
    try {
      const res = await fetch("/api/user/delete", { method: "DELETE" })
      if (!res.ok) throw new Error("Erreur serveur")
      await supabase.auth.signOut()
      router.replace("/")
      toast.success("Compte supprimé")
    } catch {
      toast.error("Erreur lors de la suppression")
      setDeleteLoading(false)
    }
  }

  return (
    <div className="max-w-2xl mx-auto px-4 py-8 space-y-6">
      <h1 className="text-2xl font-bold text-[var(--on-surface)] flex items-center gap-2"><Settings size={20} /> Paramètres</h1>
      
      {/* Email info */}
      <div className="rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-6">
        <h2 className="font-semibold text-[var(--on-surface)] mb-4">Informations du compte</h2>
        <div className="space-y-3">
          <div>
            <label className="block text-xs text-[var(--on-surface-muted)] mb-1">Email</label>
            <div className="px-4 py-3 rounded-xl border border-[var(--outline)] bg-[var(--surface-dark)] text-[var(--on-surface)] text-sm">{user.email}</div>
          </div>
          <div>
            <label className="block text-xs text-[var(--on-surface-muted)] mb-1">Compte créé le</label>
            <div className="px-4 py-3 rounded-xl border border-[var(--outline)] bg-[var(--surface-dark)] text-[var(--on-surface)] text-sm">
              {new Date(user.created_at).toLocaleDateString("fr-FR", { day: "numeric", month: "long", year: "numeric" })}
            </div>
          </div>
        </div>
      </div>

      {/* Change password */}
      <form onSubmit={handleUpdatePassword} className="rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-6">
        <h2 className="font-semibold text-[var(--on-surface)] mb-4 flex items-center gap-2"><Lock size={15} /> Changer le mot de passe</h2>
        <div className="space-y-3">
          {[
            { id: "new-pw", label: "Nouveau mot de passe", val: newPw, set: setNewPw },
            { id: "confirm-pw", label: "Confirmer le mot de passe", val: confirmPw, set: setConfirmPw },
          ].map(({ id, label, val, set }) => (
            <div key={id}>
              <label htmlFor={id} className="block text-xs text-[var(--on-surface-muted)] mb-1">{label}</label>
              <input id={id} type="password" value={val} onChange={e => set(e.target.value)} minLength={8} required className="w-full px-4 py-3 rounded-xl border border-[var(--outline)] bg-[var(--surface-dark)] text-[var(--on-surface)] text-sm focus:outline-none focus:ring-2 focus:ring-[#1147D9]/30 focus:border-[#1147D9] transition-all" />
            </div>
          ))}
          <button type="submit" disabled={pwLoading} className="flex items-center gap-2 px-4 py-2.5 rounded-xl bg-[#1147D9] hover:bg-[#1A55E6] text-white font-semibold text-sm transition-all disabled:opacity-60">
            {pwLoading ? <Loader2 size={14} className="animate-spin" /> : <Check size={14} />} Mettre à jour
          </button>
        </div>
      </form>

      {/* Notifications */}
      <div className="rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-6">
        <h2 className="font-semibold text-[var(--on-surface)] mb-4 flex items-center gap-2"><Bell size={15} /> Notifications</h2>
        {[
          { label: "Rappels de révision hebdomadaires", defaultChecked: true },
          { label: "Nouvelles fonctionnalités et mises à jour", defaultChecked: true },
          { label: "Promotions et offres spéciales", defaultChecked: false },
        ].map(({ label, defaultChecked }) => (
          <label key={label} className="flex items-center justify-between py-3 border-b border-[var(--outline)] last:border-0 cursor-pointer">
            <span className="text-sm text-[var(--on-surface)]">{label}</span>
            <input type="checkbox" defaultChecked={defaultChecked} className="w-4 h-4 accent-[#1147D9]" />
          </label>
        ))}
      </div>

      {/* Delete account */}
      <div className="rounded-2xl border border-red-500/30 bg-red-500/5 p-6">
        <h2 className="font-semibold text-red-500 mb-2 flex items-center gap-2"><AlertTriangle size={15} /> Supprimer le compte</h2>
        <p className="text-sm text-[var(--on-surface-muted)] mb-4">Cette action est irréversible. Toutes vos données seront supprimées.</p>
        <div className="space-y-3">
          <div>
            <label className="block text-xs text-[var(--on-surface-muted)] mb-1">Confirmez en saisissant votre email : <strong>{user.email}</strong></label>
            <input type="email" value={confirmDelete} onChange={e => setConfirmDelete(e.target.value)} placeholder={user.email ?? ""} className="w-full px-4 py-3 rounded-xl border border-red-500/30 bg-[var(--surface)] text-[var(--on-surface)] text-sm focus:outline-none focus:ring-2 focus:ring-red-500/30 transition-all" />
          </div>
          <button onClick={handleDeleteAccount} disabled={deleteLoading || confirmDelete !== user.email} className="flex items-center gap-2 px-4 py-2.5 rounded-xl bg-red-500 hover:bg-red-600 text-white font-semibold text-sm transition-all disabled:opacity-40">
            {deleteLoading ? <Loader2 size={14} className="animate-spin" /> : <Trash2 size={14} />} Supprimer mon compte
          </button>
        </div>
      </div>
    </div>
  )
}
