"use client"
import { useState } from "react"
import { createBrowserClient } from "@/lib/supabase/client"
import { MessageCircle, Clock, Send, Loader2, Pin, Trash2 } from "lucide-react"
import toast from "react-hot-toast"
import { useRouter } from "next/navigation"

export default function ForumPost({ post, replies, currentUserId }: { post: any; replies: any[]; currentUserId: string }) {
  const supabase = createBrowserClient()
  const router = useRouter()
  const [reply, setReply] = useState("")
  const [loading, setLoading] = useState(false)
  async function handleReply(e: React.FormEvent) {
    e.preventDefault()
    if (!reply.trim()) return
    setLoading(true)
    const { error } = await (supabase as any).from("forum_replies").insert({ post_id: post.id, user_id: currentUserId, content: reply.trim() })
    if (error) toast.error("Erreur lors de l'envoi de la réponse")
    else { toast.success("Réponse publiée !"); setReply(""); router.refresh() }
    setLoading(false)
  }
  async function handleDelete(replyId: string) {
    const { error } = await (supabase as any).from("forum_replies").delete().eq("id", replyId).eq("user_id", currentUserId)
    if (error) toast.error("Impossible de supprimer")
    else { toast.success("Réponse supprimée"); router.refresh() }
  }
  return (
    <div className="space-y-4">
      {/* Original post */}
      <div className="rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-6">
        <div className="flex items-start justify-between gap-3 mb-4">
          <div>
            <h1 className="text-xl font-bold text-[var(--on-surface)]">{post.title}</h1>
            {post.pinned && <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded-full bg-[#1147D9]/10 text-[#1147D9] text-[10px] font-semibold mt-1"><Pin size={10} /> Épinglé</span>}
          </div>
        </div>
        <p className="text-[var(--on-surface-muted)] text-sm leading-relaxed whitespace-pre-wrap">{post.content}</p>
        <div className="flex items-center gap-3 mt-4 pt-4 border-t border-[var(--outline)]">
          <span className="flex items-center gap-1 text-xs text-[var(--on-surface-faint)]"><Clock size={11} />{new Date(post.created_at).toLocaleDateString("fr-FR", { day: "numeric", month: "long", year: "numeric" })}</span>
          <span className="flex items-center gap-1 text-xs text-[var(--on-surface-faint)]"><MessageCircle size={11} />{replies.length} réponse{replies.length !== 1 ? "s" : ""}</span>
        </div>
      </div>
      {/* Replies */}
      {replies.map((r: any, i: number) => (
        <div key={r.id} className={`rounded-xl border border-[var(--outline)] bg-[var(--surface)] p-4 ${r.user_id === post.user_id ? "border-[#1147D9]/30 bg-[#1147D9]/[0.02]" : ""}`}>
          <div className="flex items-start justify-between gap-2">
            <div className="flex items-center gap-2">
              <div className="w-7 h-7 rounded-full bg-[#1147D9]/10 flex items-center justify-center text-[10px] font-bold text-[#1147D9]">#{i + 1}</div>
              {r.user_id === post.user_id && <span className="text-[10px] px-1.5 py-0.5 rounded bg-[#1147D9]/10 text-[#1147D9] font-semibold">Auteur</span>}
            </div>
            <div className="flex items-center gap-2">
              <span className="text-xs text-[var(--on-surface-faint)]">{new Date(r.created_at).toLocaleDateString("fr-FR", { day: "numeric", month: "short", hour: "2-digit", minute: "2-digit" })}</span>
              {r.user_id === currentUserId && (
                <button onClick={() => handleDelete(r.id)} className="p-1 rounded hover:bg-red-500/10 text-[var(--on-surface-faint)] hover:text-red-500 transition-colors">
                  <Trash2 size={12} />
                </button>
              )}
            </div>
          </div>
          <p className="text-sm text-[var(--on-surface-muted)] mt-2 leading-relaxed whitespace-pre-wrap">{r.content}</p>
        </div>
      ))}
      {/* Reply form */}
      <form onSubmit={handleReply} className="rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-5">
        <h3 className="text-sm font-semibold text-[var(--on-surface)] mb-3">Votre réponse</h3>
        <textarea value={reply} onChange={e => setReply(e.target.value)} rows={4} placeholder="Écrivez votre réponse..." required className="w-full px-4 py-3 rounded-xl border border-[var(--outline)] bg-[var(--surface-dark)] text-[var(--on-surface)] text-sm placeholder:text-[var(--on-surface-faint)] focus:outline-none focus:ring-2 focus:ring-[#1147D9]/30 focus:border-[#1147D9] transition-all resize-none" />
        <div className="flex justify-end mt-3">
          <button type="submit" disabled={loading || !reply.trim()} className="flex items-center gap-2 px-4 py-2.5 rounded-xl bg-[#1147D9] hover:bg-[#1A55E6] text-white text-sm font-semibold transition-all disabled:opacity-60">
            {loading ? <Loader2 size={14} className="animate-spin" /> : <Send size={14} />} Publier
          </button>
        </div>
      </form>
    </div>
  )
}
