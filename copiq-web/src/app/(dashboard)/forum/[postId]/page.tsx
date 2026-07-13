import { createServerClient } from "@/lib/supabase/server"
import { redirect, notFound } from "next/navigation"
import ForumPost from "@/features/forum/forum-post"
import Link from "next/link"
import { ChevronRight } from "lucide-react"
export default async function ForumPostPage({ params }: { params: Promise<{ postId: string }> }) {
  const { postId } = await params
  const supabase = await createServerClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) redirect("/login")
  const { data: post } = await (supabase as any).from("forum_posts").select("*").eq("id", postId).maybeSingle()
  if (!post) notFound()
  const { data: replies } = await (supabase as any).from("forum_replies").select("*").eq("post_id", postId).order("created_at")
  return (
    <div className="max-w-3xl mx-auto px-4 py-8">
      <div className="flex items-center gap-2 text-sm text-[var(--on-surface-muted)] mb-6">
        <Link href="/forum" className="hover:text-[var(--on-surface)]">Forum</Link>
        <ChevronRight size={14} />
        <span className="text-[var(--on-surface)] truncate max-w-[200px]">{post.title}</span>
      </div>
      <ForumPost post={post} replies={replies ?? []} currentUserId={user.id} />
    </div>
  )
}
