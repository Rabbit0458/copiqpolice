import type { SupabaseClient, User } from "@supabase/supabase-js"
import { USERNAME_RE, cleanText, digitsOnly, isValidFrMobile } from "@/features/auth/profile-rules"

/**
 * Filet de sécurité de l'inscription web.
 *
 * Normalement, le trigger `handle_new_user_minimal` remplit `user_profiles`
 * dès la création du compte à partir des métadonnées envoyées par /signup.
 * Si un champ est resté vide (pseudo pris entre-temps, trigger plus ancien…),
 * on le complète à la première ouverture de l'espace web, avec les droits de
 * l'utilisateur (RLS `update_own_profile`), sans jamais écraser une valeur
 * existante. Les comptes créés dans l'application ne sont pas concernés.
 */

const done = new Set<string>()

type Row = {
  first_name: string | null
  last_name: string | null
  city: string | null
  phone: string | null
  username: string | null
  birthday: string | null
  avatar_index: number | null
  user_track: string | null
  user_mode: string | null
}

const empty = (v: string | null | undefined) => !v || !v.trim()
const str = (v: unknown) => (typeof v === "string" ? v : "")

export async function completeProfileFromSignup(supabase: SupabaseClient, user: User): Promise<boolean> {
  const meta = (user.user_metadata ?? {}) as Record<string, unknown>
  if (meta.created_from !== "web" || done.has(user.id)) return false
  done.add(user.id)

  const { data, error } = await supabase
    .from("user_profiles")
    .select("first_name,last_name,city,phone,username,birthday,avatar_index,user_track,user_mode")
    .eq("user_id", user.id)
    .maybeSingle()
  if (error || !data) return false
  const row = data as Row

  const patch: Record<string, unknown> = {}
  const first = cleanText(str(meta.first_name)).slice(0, 60)
  const last = cleanText(str(meta.last_name)).slice(0, 60)
  const city = cleanText(str(meta.city)).slice(0, 80)
  const phone = digitsOnly(str(meta.phone))
  const username = str(meta.username).trim()
  const birthday = str(meta.birthday)
  const avatar = Number(meta.avatar_index)
  const track = str(meta.user_track)
  const mode = str(meta.user_mode)

  const untouched = empty(row.first_name) && empty(row.last_name)
  if (empty(row.first_name) && first) patch.first_name = first
  if (empty(row.last_name) && last) patch.last_name = last
  if (empty(row.city) && city) patch.city = city
  if (empty(row.phone) && isValidFrMobile(phone)) patch.phone = phone
  if (!row.birthday && /^\d{4}-\d{2}-\d{2}$/.test(birthday)) patch.birthday = birthday
  if (untouched && Number.isInteger(avatar) && avatar >= 1 && avatar <= 20) patch.avatar_index = avatar
  if (!row.user_track && (track === "pa" || track === "gpx")) {
    patch.user_track = track
    if (mode === "exam" || mode === "school") patch.user_mode = mode
  }
  if (empty(row.username) && USERNAME_RE.test(username)) {
    const { data: taken } = await supabase.rpc("is_username_taken" as never, {
      p_username: username,
      p_except_user_id: user.id,
    } as never)
    if (taken === false) patch.username = username
  }

  if (Object.keys(patch).length === 0) return false
  const { error: updateError } = await supabase
    .from("user_profiles")
    .update(patch as never)
    .eq("user_id", user.id)
  return !updateError
}
