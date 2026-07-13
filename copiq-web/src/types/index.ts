
// ─── User ───────────────────────────────────────────────────────────────────
export interface UserProfile {
  id: string
  email: string
  full_name: string | null
  avatar_url: string | null
  tier: CpTier
  xp: number
  created_at: string
}

// ─── Quiz ────────────────────────────────────────────────────────────────────
export interface QuizQuestion {
  id: string
  text: string
  options: string[]
  correctIndex: number
  explanation?: string
  category?: string
}

export interface QuizAttempt {
  id: number
  uid: string
  moduleName: string
  quizName: string
  score: number
  totalQuestions: number
  correctCount: number
  startedAt: string | null
  finishedAt: string | null
}

export type QuizStatus = 'idle' | 'running' | 'paused' | 'completed'

// ─── Cours ──────────────────────────────────────────────────────────────────
export interface CourseModule {
  id: string
  slug: string
  title: string
  description: string
  category: 'pa' | 'gpx' | 'shared'
  isPremium: boolean
  sections: CourseSection[]
  color?: string
}

export interface CourseSection {
  id: string
  title: string
  content: string  // MDX / HTML
  order: number
}

// ─── Abonnement ─────────────────────────────────────────────────────────────
export interface Subscription {
  userId: string
  tier: CpTier
  status: SubStatus
  currentPeriodEnd: string | null
  cancelAtPeriodEnd: boolean
  stripeCustomerId: string | null
}

// ─── Forum ──────────────────────────────────────────────────────────────────
export type ForumRole = 'user' | 'moderator' | 'admin'

export interface ForumCategory {
  id: string
  slug: string
  name: string
  description: string
  color: string
  postsCount: number
}

export interface ForumPost {
  id: string
  categoryId: string
  authorId: string
  authorName: string
  title: string
  content: string
  likesCount: number
  repliesCount: number
  isPinned: boolean
  isLocked: boolean
  createdAt: string
  updatedAt: string
}

export interface ForumReply {
  id: string
  postId: string
  authorId: string
  authorName: string
  content: string
  likesCount: number
  isHidden: boolean
  createdAt: string
}

// ─── Navigation ─────────────────────────────────────────────────────────────
export interface NavItem {
  label: string
  href: string
  icon?: string
  isPremium?: boolean
  badge?: string
}

export type CpTier = 'free' | 'premium' | 'premium_trial'
export type SubStatus = 'active' | 'past_due' | 'canceled' | 'incomplete' | 'unpaid' | 'trialing'
export type CopiqPlan = 'week' | 'month' | 'year'
