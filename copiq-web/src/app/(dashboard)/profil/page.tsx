"use client"
import { useState, useEffect } from "react"
import { useRouter } from "next/navigation"
import { createClient } from "@/lib/supabase/client"
import { User, Mail, Star, Award } from "lucide-react"
import { UserVerificationBadge, badgeTypeFromString, type UserBadgeType } from "@/components/ui/user-verification-badge"

export default function ProfilPage() {
  const router = useRouter()
  const [user, setUser] = useState<any>(null)
  const [profile, setProfile] = useState<any>(null)
  const [badgeType, setBadgeType] = useState<UserBadgeType>("none")
  const [loading, setLoading] = useState(true)
  const supabase = createClient()

  useEffect(() => {
    supabase.auth.getUser().then(async ({ data }) => {
      if (!data.user) { router.replace("/login"); return }
      setUser(data.user)
      // Table réelle : public.user_profiles (pas "profiles", qui n'existe pas)
      const { data: p } = await (supabase as any)
        .from("user_profiles")
        .select("first_name, last_name, username, role")
        .eq("user_id", data.user.id)
        .maybeSingle()
      setProfile(p)
      // Source de vérité serveur du badge : get_my_entitlement() (RLS-safe,
      // rôle protégé côté DB — jamais calculé/decidé côté client).
      const { data: ent } = await supabase.rpc("get_my_entitlement" as never)
      if (ent && typeof ent === "object" && "badge_type" in (ent as object)) {
        setBadgeType(badgeTypeFromString((ent as any).badge_type))
      }
      setLoading(false)
    })
  }, [])

  if (loading) return <div className="flex items-center justify-center h-64"><div className="animate-spin rounded-full h-8 w-8 border-b-2 border-[#1147D9]" /></div>

  const displayName = [profile?.first_name, profile?.last_name].filter(Boolean).join(" ").trim()
    || profile?.username
    || user?.email?.split("@")[0]

  return (
    <div className="max-w-2xl mx-auto px-4 py-8">
      <h1 className="text-2xl font-bold text-[var(--on-surface)] mb-6">Mon Profil</h1>
      <div className="rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-6">
        <div className="flex items-center gap-4 mb-6">
          <div className="w-16 h-16 rounded-full bg-[#1147D9]/10 flex items-center justify-center">
            <User size={28} className="text-[#1147D9]" />
          </div>
          <div>
            <p className="font-semibold text-[var(--on-surface)] text-lg flex items-center gap-1.5">
              {displayName}
              <UserVerificationBadge type={badgeType} size={16} />
            </p>
            <p className="text-[var(--on-surface-muted)] text-sm flex items-center gap-1"><Mail size={13} />{user?.email}</p>
          </div>
        </div>
        <div className="grid grid-cols-2 gap-4">
          <div className="rounded-xl bg-[var(--surface-variant)] p-4">
            <div className="flex items-center gap-2 mb-1"><Star size={15} className="text-amber-500" /><span className="text-xs font-semibold text-[var(--on-surface-muted)]">XP Total</span></div>
            <p className="text-2xl font-bold text-[var(--on-surface)]">{profile?.xp_total ?? 0}</p>
          </div>
          <div className="rounded-xl bg-[var(--surface-variant)] p-4">
            <div className="flex items-center gap-2 mb-1"><Award size={15} className="text-[#1147D9]" /><span className="text-xs font-semibold text-[var(--on-surface-muted)]">Niveau</span></div>
            <p className="text-2xl font-bold text-[var(--on-surface)]">{Math.floor((profile?.xp_total ?? 0) / 100) + 1}</p>
          </div>
        </div>
      </div>
    </div>
  )
}
