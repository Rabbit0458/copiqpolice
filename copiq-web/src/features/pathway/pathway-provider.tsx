"use client"

import { createContext, useCallback, useContext, useEffect, useMemo, useState } from "react"
import type { User } from "@supabase/supabase-js"
import { createClient } from "@/lib/supabase/client"
import {
  getPathway,
  getPathwayFromProfile,
  type PathwayDefinition,
  type PathwayId,
  type UserMode,
  type UserTrack,
} from "@/config/pathways"

export interface WebUserProfile {
  user_id: string
  user_track: string | null
  user_mode: string | null
  first_name: string | null
  last_name: string | null
  username: string | null
}

interface PathwayContextValue {
  profile: WebUserProfile | null
  pathway: PathwayDefinition | null
  loading: boolean
  error: Error | null
  refresh(): Promise<void>
  changePathway(id: PathwayId): Promise<void>
}

const PathwayContext = createContext<PathwayContextValue | null>(null)
const profileColumns = "user_id,user_track,user_mode,first_name,last_name,username" as const

function toError(cause: unknown, fallback: string): Error {
  if (cause instanceof Error) return cause
  return new Error(fallback)
}

export function PathwayProvider({ user, children }: { user: User; children: React.ReactNode }) {
  const supabase = useMemo(() => createClient(), [])
  const [profile, setProfile] = useState<WebUserProfile | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<Error | null>(null)

  const refresh = useCallback(async () => {
    setLoading(true)
    setError(null)
    try {
      const result = await supabase
        .from("user_profiles")
        .select(profileColumns)
        .eq("user_id", user.id)
        .maybeSingle()

      if (result.error) throw result.error
      setProfile(result.data)
    } catch (cause) {
      setError(toError(cause, "Impossible de charger votre parcours."))
    } finally {
      setLoading(false)
    }
  }, [supabase, user.id])

  useEffect(() => {
    // Chargement initial depuis la source externe Supabase.
    // eslint-disable-next-line react-hooks/set-state-in-effect
    void refresh()
  }, [refresh])

  const changePathway = useCallback(async (id: PathwayId) => {
    const target = getPathway(id)
    setError(null)
    const update = {
      user_id: user.id,
      user_track: target.track as UserTrack,
      user_mode: target.mode as UserMode,
    }

    try {
      const result = await supabase
        .from("user_profiles")
        .upsert([update] as never[], { onConflict: "user_id" })
        .select(profileColumns)
        .single()

      if (result.error) throw result.error
      const persisted = getPathwayFromProfile(result.data)
      if (persisted?.id !== id) throw new Error("Le parcours enregistré ne correspond pas au choix effectué.")
      setProfile(result.data)
    } catch (cause) {
      const nextError = toError(cause, "Le changement de parcours a échoué.")
      setError(nextError)
      throw nextError
    }
  }, [supabase, user.id])

  const value = useMemo<PathwayContextValue>(() => ({
    profile,
    pathway: getPathwayFromProfile(profile),
    loading,
    error,
    refresh,
    changePathway,
  }), [profile, loading, error, refresh, changePathway])

  return <PathwayContext.Provider value={value}>{children}</PathwayContext.Provider>
}

export function usePathway(): PathwayContextValue {
  const context = useContext(PathwayContext)
  if (!context) throw new Error("usePathway doit être utilisé dans PathwayProvider.")
  return context
}
