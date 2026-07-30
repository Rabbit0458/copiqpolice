// COP'IQ — Badge de vérification (équivalent web de
// lib/core/widgets/user_verification_badge.dart côté Flutter).
// Même pictogramme (sceau à 12 pointes + coche) pour les 4 statuts, seule
// la couleur change. La source de vérité du calcul reste la fonction SQL
// `compute_badge_type()` — ce fichier ne fait que restituer la valeur
// `badge_type` renvoyée par Supabase (RPC get_public_profile_badges /
// get_public_profile_badge). `badgeTypeFromRoleAndQuizCount` n'est qu'un
// calcul local de secours pour l'affichage, jamais pour décider un droit.

export type UserBadgeType = "none" | "active" | "legend" | "moderator" | "admin"

const COLORS: Record<Exclude<UserBadgeType, "none">, string> = {
  admin: "#E53935",
  moderator: "#FBC02D",
  legend: "#8B5CF6",
  active: "#42A5F5",
}

const LABELS: Record<Exclude<UserBadgeType, "none">, string> = {
  admin: "Administrateur COP'IQ",
  moderator: "Modérateur COP'IQ",
  legend: "Membre légende — 2000+ quiz lancés",
  active: "Membre très actif — 100+ quiz lancés",
}

export function badgeTypeFromString(value: string | null | undefined): UserBadgeType {
  if (value === "admin" || value === "moderator" || value === "legend" || value === "active") {
    return value
  }
  return "none"
}

/** Calcul de secours côté client — le calcul faisant foi reste compute_badge_type() en base. */
export function badgeTypeFromRoleAndQuizCount(
  role: string | null | undefined,
  quizAttemptsCount: number
): UserBadgeType {
  if (role === "owner" || role === "admin") return "admin"
  if (role === "moderator") return "moderator"
  if (quizAttemptsCount >= 2000) return "legend"
  if (quizAttemptsCount >= 100) return "active"
  return "none"
}

function sealPoints(cx: number, cy: number, outerR: number, innerR: number, points = 12): string {
  const coords: string[] = []
  for (let i = 0; i < points * 2; i++) {
    const r = i % 2 === 0 ? outerR : innerR
    const angle = (i * Math.PI) / points - Math.PI / 2
    coords.push(`${(cx + r * Math.cos(angle)).toFixed(2)},${(cy + r * Math.sin(angle)).toFixed(2)}`)
  }
  return coords.join(" ")
}

interface UserVerificationBadgeProps {
  type: UserBadgeType
  size?: number
  className?: string
}

/** Retourne null pour "none" — jamais d'espace vide ni de badge gris. */
export function UserVerificationBadge({ type, size = 16, className }: UserVerificationBadgeProps) {
  if (type === "none") return null

  const color = COLORS[type]
  const label = LABELS[type]
  const cx = size / 2
  const cy = size / 2
  const outerR = size / 2
  const innerR = outerR * 0.8

  return (
    <svg
      width={size}
      height={size}
      viewBox={`0 0 ${size} ${size}`}
      role="img"
      aria-label={label}
      className={className}
    >
      <title>{label}</title>
      <polygon points={sealPoints(cx, cy, outerR, innerR)} fill={color} />
      <path
        d={`M ${size * 0.28} ${size * 0.52} L ${size * 0.44} ${size * 0.68} L ${size * 0.74} ${size * 0.34}`}
        stroke="#EAF3FF"
        strokeWidth={size * 0.14}
        strokeLinecap="round"
        strokeLinejoin="round"
        fill="none"
      />
    </svg>
  )
}
