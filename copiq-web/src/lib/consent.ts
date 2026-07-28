/**
 * COP'IQ — Gestion du consentement aux cookies (RGPD / directive ePrivacy)
 *
 * Règles appliquées, conformes aux recommandations de la CNIL :
 *
 *  • Aucun traceur non essentiel n'est déposé avant un choix explicite.
 *  • Refuser doit être aussi simple qu'accepter — les deux boutons sont
 *    présentés au même niveau, avec le même poids visuel.
 *  • Le choix est conservé **13 mois maximum**, puis redemandé.
 *  • Le consentement est révocable à tout moment (lien en pied de page).
 *  • La version du texte est enregistrée : si la politique change, le
 *    consentement est redemandé automatiquement.
 *
 * Le choix est stocké dans un cookie first-party (et non en `localStorage`)
 * afin que le serveur puisse le lire si un rendu côté serveur est ajouté
 * un jour.
 */

export const CONSENT_COOKIE = "copiq_consent"

/**
 * Version de la politique de cookies. **À incrémenter** dès que les
 * finalités changent : les consentements antérieurs sont alors invalidés
 * et le bandeau réapparaît.
 */
export const CONSENT_VERSION = 1

/** Durée de conservation du choix : 13 mois (recommandation CNIL). */
const CONSENT_MAX_AGE_SECONDS = 13 * 30 * 24 * 60 * 60

export interface ConsentCategories {
  /** Toujours vrai : session, sécurité, équilibrage de charge. Non désactivable. */
  necessary: true
  /** Mesure d'audience. */
  analytics: boolean
  /** Publicité et reciblage. */
  marketing: boolean
}

export interface ConsentRecord {
  version: number
  /** Horodatage ISO du choix — preuve exigée en cas de contrôle. */
  date: string
  categories: ConsentCategories
}

export const DEFAULT_CONSENT: ConsentCategories = {
  necessary: true,
  analytics: false,
  marketing: false,
}

/* ────────────────────────────────────────────────────────────────────────── */

function readCookie(name: string): string | null {
  if (typeof document === "undefined") return null
  const match = document.cookie
    .split("; ")
    .find((row) => row.startsWith(`${name}=`))
  return match ? decodeURIComponent(match.slice(name.length + 1)) : null
}

function writeCookie(name: string, value: string, maxAgeSeconds: number) {
  if (typeof document === "undefined") return
  const secure = location.protocol === "https:" ? "; Secure" : ""
  document.cookie =
    `${name}=${encodeURIComponent(value)}; path=/; max-age=${maxAgeSeconds}` +
    `; SameSite=Lax${secure}`
}

/**
 * Lit le consentement enregistré.
 * Renvoie `null` si aucun choix n'a été fait, ou si la politique a changé
 * depuis — dans les deux cas le bandeau doit être affiché.
 */
export function getConsent(): ConsentRecord | null {
  const raw = readCookie(CONSENT_COOKIE)
  if (!raw) return null
  try {
    const parsed = JSON.parse(raw) as ConsentRecord
    if (parsed.version !== CONSENT_VERSION) return null
    if (!parsed.categories) return null
    return {
      ...parsed,
      categories: { ...parsed.categories, necessary: true },
    }
  } catch {
    return null
  }
}

/** Enregistre le choix de l'utilisateur et notifie l'application. */
export function setConsent(categories: Omit<ConsentCategories, "necessary">) {
  const record: ConsentRecord = {
    version: CONSENT_VERSION,
    date: new Date().toISOString(),
    categories: { necessary: true, ...categories },
  }
  writeCookie(CONSENT_COOKIE, JSON.stringify(record), CONSENT_MAX_AGE_SECONDS)

  // Permet aux scripts tiers de réagir sans rechargement de page.
  if (typeof window !== "undefined") {
    window.dispatchEvent(
      new CustomEvent("copiq:consent", { detail: record.categories }),
    )
  }
  return record
}

/** Efface le choix : le bandeau réapparaîtra au prochain rendu. */
export function resetConsent() {
  writeCookie(CONSENT_COOKIE, "", 0)
  if (typeof window !== "undefined") {
    window.dispatchEvent(new CustomEvent("copiq:consent-reset"))
  }
}

/** Raccourci : la catégorie est-elle autorisée ? */
export function hasConsent(category: keyof ConsentCategories): boolean {
  if (category === "necessary") return true
  return getConsent()?.categories[category] === true
}
