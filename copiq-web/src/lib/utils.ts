import { clsx, type ClassValue } from "clsx"
import { twMerge } from "tailwind-merge"

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}

export function formatDate(date: string | Date, options?: Intl.DateTimeFormatOptions): string {
  return new Intl.DateTimeFormat("fr-FR", {
    day: "2-digit",
    month: "long",
    year: "numeric",
    ...options,
  }).format(new Date(date))
}

export function formatPercent(value: number): string {
  return `${Math.round(value)}%`
}

export function formatScore(correct: number, total: number): string {
  if (total === 0) return "0%"
  return `${Math.round((correct / total) * 100)}%`
}

export function getInitials(name: string): string {
  return name
    .split(" ")
    .map((n) => n[0])
    .join("")
    .toUpperCase()
    .slice(0, 2)
}

export function sleep(ms: number): Promise<void> {
  return new Promise((resolve) => setTimeout(resolve, ms))
}

export function truncate(str: string, maxLength: number): string {
  if (str.length <= maxLength) return str
  return str.slice(0, maxLength - 3) + "..."
}

export function pluralize(count: number, singular: string, plural: string): string {
  return count === 1 ? singular : plural
}

export const TIER_LABELS: Record<string, string> = {
  free: "Gratuit",
  premium: "Premium",
  premium_trial: "Essai Premium",
}

export const PLAN_LABELS: Record<string, string> = {
  week: "Hebdomadaire",
  month: "Mensuel",
  year: "Annuel",
}

export const PLAN_PRICES: Record<string, { amount: string; period: string }> = {
  week: { amount: "4,99 €", period: "/ semaine" },
  month: { amount: "8,99 €", period: "/ mois" },
  year: { amount: "86,99 €", period: "/ an" },
}
