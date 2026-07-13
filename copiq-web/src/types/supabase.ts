// Types Supabase — générés manuellement à partir des migrations
// Régénérer avec : npx supabase gen types typescript --project-id [ID]

export type Json = string | number | boolean | null | { [key: string]: Json } | Json[]

export type CpTier = 'free' | 'premium' | 'premium_trial'
export type SubStatus = 'active' | 'past_due' | 'canceled' | 'incomplete' | 'unpaid' | 'trialing'
export type CopiqPlan = 'week' | 'month' | 'year'

export interface Database {
  public: {
    Tables: {
      cas_pratique_subscriptions: {
        Row: {
          user_id: string
          tier: CpTier
          status: SubStatus
          stripe_customer_id: string | null
          stripe_subscription_id: string | null
          stripe_price_id: string | null
          stripe_product_id: string | null
          current_period_start: string | null
          current_period_end: string | null
          cancel_at_period_end: boolean
          canceled_at: string | null
          trial_ends_at: string | null
          entitlements: string[]
          created_at: string
          updated_at: string
        }
        Insert: Omit<Database['public']['Tables']['cas_pratique_subscriptions']['Row'], 'created_at' | 'updated_at'>
        Update: Partial<Database['public']['Tables']['cas_pratique_subscriptions']['Insert']>
      }
      cas_pratique_attempts: {
        Row: {
          id: string
          user_id: string
          case_id: string
          status: string
          started_at: string
          submitted_at: string | null
          score: number | null
          created_at: string
        }
        Insert: Omit<Database['public']['Tables']['cas_pratique_attempts']['Row'], 'id' | 'created_at'>
        Update: Partial<Database['public']['Tables']['cas_pratique_attempts']['Insert']>
      }
      cas_pratique_cases: {
        Row: {
          id: string
          title: string
          theme_id: string | null
          difficulty: number | null
          is_free: boolean
          content: string
          created_at: string
          updated_at: string
        }
        Insert: Omit<Database['public']['Tables']['cas_pratique_cases']['Row'], 'id' | 'created_at' | 'updated_at'>
        Update: Partial<Database['public']['Tables']['cas_pratique_cases']['Insert']>
      }
      cas_pratique_themes: {
        Row: {
          id: string
          slug: string
          label: string
          color: string | null
          icon: string | null
        }
        Insert: Omit<Database['public']['Tables']['cas_pratique_themes']['Row'], 'id'>
        Update: Partial<Database['public']['Tables']['cas_pratique_themes']['Insert']>
      }
      cas_pratique_user_progress: {
        Row: {
          id: string
          user_id: string
          case_id: string
          best_score: number | null
          attempts_count: number
          last_attempt_at: string | null
        }
        Insert: Omit<Database['public']['Tables']['cas_pratique_user_progress']['Row'], 'id'>
        Update: Partial<Database['public']['Tables']['cas_pratique_user_progress']['Insert']>
      }
      cas_pratique_user_bookmarks: {
        Row: {
          id: string
          user_id: string
          case_id: string
          created_at: string
        }
        Insert: Omit<Database['public']['Tables']['cas_pratique_user_bookmarks']['Row'], 'id' | 'created_at'>
        Update: Partial<Database['public']['Tables']['cas_pratique_user_bookmarks']['Insert']>
      }
      cas_pratique_xp_ledger: {
        Row: {
          id: string
          user_id: string
          amount: number
          reason: string
          created_at: string
        }
        Insert: Omit<Database['public']['Tables']['cas_pratique_xp_ledger']['Row'], 'id' | 'created_at'>
        Update: Partial<Database['public']['Tables']['cas_pratique_xp_ledger']['Insert']>
      }
      cas_pratique_user_badges: {
        Row: {
          id: string
          user_id: string
          badge_id: string
          earned_at: string
        }
        Insert: Omit<Database['public']['Tables']['cas_pratique_user_badges']['Row'], 'id'>
        Update: Partial<Database['public']['Tables']['cas_pratique_user_badges']['Insert']>
      }
      free_weekly_usage: {
        Row: {
          user_id: string
          window_start: string
          used: number
          updated_at: string
        }
        Insert: Omit<Database['public']['Tables']['free_weekly_usage']['Row'], 'updated_at'>
        Update: Partial<Database['public']['Tables']['free_weekly_usage']['Insert']>
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      is_user_premium: {
        Args: { p_user_id: string }
        Returns: boolean
      }
      consume_free_request: {
        Args: Record<string, never>
        Returns: { allowed: boolean; remaining: number; resets_at: string; premium: boolean; reason: string }
      }
    }
    Enums: {
      [_ in never]: never
    }
  }
}

// ─── Forum tables (added via migration 20260601_forum.sql) ──────────────────
declare module "./supabase" {}

// Extend Database with forum tables via a helper type
export interface ForumPost {
  id: string
  user_id: string
  category_id: string | null
  category_slug: string | null
  title: string
  content: string
  pinned: boolean
  locked: boolean
  reply_count: number
  view_count: number
  created_at: string
  updated_at: string
}

export interface ForumReply {
  id: string
  post_id: string
  user_id: string
  content: string
  is_solution: boolean
  created_at: string
  updated_at: string
}

export interface ForumCategory {
  id: string
  name: string
  slug: string
  description: string | null
  position: number
  created_at: string
}
