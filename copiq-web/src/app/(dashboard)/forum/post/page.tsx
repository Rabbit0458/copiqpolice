"use client"
import { useRouter, useSearchParams } from "next/navigation"
import { useState, useEffect, Suspense } from "react"
import { createClient } from "@/lib/supabase/client"
import Link from "next/link"
import { ArrowLeft, MessageCircle, Send, Pin } from "lucide-react"

function ForumPostContent() {
  const router = useRouter()
  const searchParams = useSearchParams()
  const postId = searchParams.get("id")
  const [user, setUser] = useState<any>(null)
  const [post, setPost] = useState<any>(null)
  const [replies, setReplies] = useState<any[]>([])
  const [replyContent, setReplyContent] = useState("")
  const [loading, setLoading] = useState(true)
  const [submitting, setSubmitting] = useState(false)
  const supabase = createClient()

  useEffect(() => {
    if (!postId) { router.replace("/forum"); return }
    supabase.auth.getUser().then(async ({ data }) => {
      if (!data.user) { router.replace("/login"); return }
      setUser(data.user)
      const [postRes, repliesRes] = await Promise.all([
        (supabase as any).from("forum_posts").select("*, profiles(full_name)").eq("id", postId).single(),
        (supabase as any).from("forum_replies").select("*, profiles(full_name)").eq("post_id", postId).order("created_at"),
      ])
      setPost(postRes.data)
      setReplies(repliesRes.data ?? [])
      setLoading(false)
    })
  }, [postId])

  const handleReply = async (e: React.FormEvent) => {
    e.preventDefault()
    if (!replyContent.trim() || !postId) return
    setSubmitting(true)
    const { data: reply } = await (supabase as any).from("forum_replies").insert({
      post_id: postId, user_id: user.id, content: replyContent.trim()
    }).select("*, profiles(full_name)").single()
    if (reply) { setReplies(r => [...r, reply]); setReplyContent("") }
    setSubmitting(false)
  }

  if (loading) return <div className="flex items-center justify-center h-64"><div className="animate-spin rounded-full h-8 w-8 border-b-2 border-[#1147D9]" /></div>
  if (!post) return <div className="flex items-center justify-center h-64"><p className="text-[var(--on-surface-muted)]">Sujet introuvable</p></div>

  return (
    <div className="max-w-3xl mx-auto px-4 py-8">
      <Link href="/forum" className="flex items-center gap-2 text-sm text-[var(--on-surface-muted)] hover:text-[var(--on-surface)] mb-6 transition-colors"><ArrowLeft size={15} />Forum</Link>
      <div className="rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-6 mb-4">
        {post.is_pinned && <div className="flex items-center gap-1 text-xs text-[#1147D9] mb-3 font-semibold"><Pin size={12} />Épinglé</div>}
        <h1 className="text-xl font-bold text-[var(--on-surface)] mb-3">{post.title}</h1>
        <p className="text-sm text-[var(--on-surface)] leading-relaxed whitespace-pre-wrap">{post.content}</p>
        <div className="flex items-center gap-3 mt-4 pt-4 border-t border-[var(--outline)]">
          <span className="text-xs text-[var(--on-surface-muted)]">{post.profiles?.full_name ?? "Utilisateur"}</span>
          <span className="text-xs text-[var(--on-surface-faint)]">·</span>
          <span className="text-xs text-[var(--on-surface-faint)]">{new Date(post.created_at).toLocaleDateString("fr-FR")}</span>
        </div>
      </div>
      <div className="mb-4">
        <p className="text-sm font-semibold text-[var(--on-surface)] mb-3 flex items-center gap-2"><MessageCircle size={15} />{replies.length} réponse{replies.length > 1 ? "s" : ""}</p>
        <div className="space-y-3">
          {replies.map((reply) => (
            <div key={reply.id} className="rounded-xl border border-[var(--outline)] bg-[var(--surface)] p-4">
              <p className="text-sm text-[var(--on-surface)] leading-relaxed whitespace-pre-wrap">{reply.content}</p>
              <div className="flex items-center gap-3 mt-3">
                <span className="text-xs text-[var(--on-surface-muted)]">{reply.profiles?.full_name ?? "Utilisateur"}</span>
                <span className="text-xs text-[var(--on-surface-faint)]">{new Date(reply.created_at).toLocaleDateString("fr-FR")}</span>
              </div>
            </div>
          ))}
        </div>
      </div>
      <form onSubmit={handleReply} className="rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-4">
        <textarea value={replyContent} onChange={e => setReplyContent(e.target.value)} rows={3} placeholder="Votre réponse..." required
          className="w-full bg-transparent text-sm text-[var(--on-surface)] placeholder:text-[var(--on-surface-faint)] focus:outline-none resize-none mb-3" />
        <div className="flex justify-end">
          <button type="submit" disabled={submitting} className="flex items-center gap-2 px-4 py-2 rounded-xl bg-[#1147D9] text-white text-sm font-semibold hover:bg-[#1A55E6] transition-all disabled:opacity-60">
            {submitting ? <span className="animate-spin rounded-full h-3 w-3 border-b-2 border-white" /> : <Send size={13} />}Répondre
          </button>
        </div>
      </form>
    </div>
  )
}

export default function ForumPostPage() {
  return (
    <Suspense fallback={<div className="flex items-center justify-center h-64"><div className="animate-spin rounded-full h-8 w-8 border-b-2 border-[#1147D9]" /></div>}>
      <ForumPostContent />
    </Suspense>
  )
}
