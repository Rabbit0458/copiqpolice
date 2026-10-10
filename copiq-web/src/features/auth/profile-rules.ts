/**
 * Règles du profil COP'IQ — copie fidèle de l'application
 * (lib/features/home/profil_page.dart) et des contraintes de `user_profiles`.
 *
 * Un profil est « complet » pour l'app (pas de fenêtre bloquante à la
 * première connexion) quand prénom, nom, ville et pseudo sont renseignés et
 * que le mobile est un 06/07 valide. La date de naissance reste facultative.
 */

export const AVATAR_COUNT = 20
export const avatarSrc = (index: number) => `/avatars/${index}.webp`

/** Identifiant neutre pour `is_username_taken` avant la création du compte. */
export const NO_USER_ID = "00000000-0000-0000-0000-000000000000"

/** 3 à 20 caractères, lettres / chiffres / tiret bas, commence par une lettre. */
export const USERNAME_RE = /^[A-Za-z][A-Za-z0-9_]{2,19}$/

/** Lettres (accents compris), espaces, tirets et apostrophes. */
const NAME_RE = /^[\p{L}][\p{L}\p{M}' -]*$/u

export const digitsOnly = (raw: string) => raw.replace(/\D/g, "")

export function isValidFrMobile(raw: string) {
  return /^(06|07)\d{8}$/.test(digitsOnly(raw))
}

/** « 0612345678 » → « 06 12 34 56 78 » pendant la saisie. */
export function formatPhone(raw: string) {
  const d = digitsOnly(raw).slice(0, 10)
  return d.replace(/(\d{2})(?=\d)/g, "$1 ")
}

export const cleanText = (raw: string) => raw.replace(/\s+/g, " ").trim()

export function nameError(raw: string, label: string) {
  const v = cleanText(raw)
  if (!v) return `Renseigne ton ${label}.`
  if (v.length > 60) return `Ton ${label} est trop long.`
  if (!NAME_RE.test(v)) return `Ton ${label} ne peut contenir que des lettres, espaces, tirets ou apostrophes.`
  return null
}

export function usernameFormatError(raw: string) {
  const v = raw.trim()
  if (!v) return "Choisis un pseudo."
  if (v.length < 3) return "3 caractères minimum."
  if (v.length > 20) return "20 caractères maximum."
  if (!/^[A-Za-z]/.test(v)) return "Le pseudo doit commencer par une lettre."
  if (!USERNAME_RE.test(v)) return "Lettres, chiffres et tiret bas (_) uniquement, sans accent."
  return null
}

/** Propose un pseudo valide à partir du prénom et du nom. */
export function suggestUsername(first: string, last: string) {
  const strip = (s: string) =>
    s.normalize("NFD").replace(/[̀-ͯ]/g, "").replace(/[^A-Za-z0-9]/g, "")
  const f = strip(first)
  const l = strip(last)
  if (!f && !l) return ""
  const base = (f ? f.charAt(0).toUpperCase() + f.slice(1).toLowerCase() : "") + (l ? l.charAt(0).toUpperCase() : "")
  const start = /^[A-Za-z]/.test(base) ? base : `Cop${base}`
  return start.slice(0, 15)
}

/** Bornes de la date de naissance (facultative). */
export function birthdayBounds() {
  const now = new Date()
  const iso = (d: Date) => d.toISOString().slice(0, 10)
  const max = new Date(Date.UTC(now.getUTCFullYear() - 15, now.getUTCMonth(), now.getUTCDate()))
  return { min: "1940-01-01", max: iso(max) }
}

export function birthdayError(value: string) {
  if (!value) return null
  const { min, max } = birthdayBounds()
  if (!/^\d{4}-\d{2}-\d{2}$/.test(value) || Number.isNaN(Date.parse(value))) return "Date invalide."
  if (value < min || value > max) return "Vérifie ta date de naissance."
  return null
}

export function formatBirthday(value: string) {
  if (!value) return ""
  const [y, m, d] = value.split("-")
  return `${d}/${m}/${y}`
}
