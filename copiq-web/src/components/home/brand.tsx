import { cn } from "@/lib/utils"

/**
 * Marque COP'IQ — version 5.
 *
 * Logo officiel : PNG transparent stocké dans le bucket Supabase `assets`
 * (`logo-png-copiq.png`, 1254 × 1254). Décision du propriétaire : le logo
 * est toujours affiché en PNG sans fond, depuis cette URL.
 *
 * Le fichier a environ 16 % de marge transparente autour de la tête : on
 * l'agrandit légèrement dans son cadre pour que le dessin occupe la place
 * annoncée, sans jamais le déformer (ratio 1:1 verrouillé).
 *
 * L'ancien composant `components/brand/copiq-logo.tsx` reste en place pour
 * `/confirm`, qui ne doit pas changer.
 */

/**
 * Copie locale du logo officiel (`logo-png-copiq.png` du bucket Supabase),
 * réencodée en 192 × 192 : servie par copiq.fr, elle s'affiche partout,
 * Safari compris (le fichier distant de 600 Ko ne s'y affichait pas).
 */
export const COPIQ_LOGO_PNG = "/brand/copiq-logo.png"
/** Source d'origine, conservée pour référence. */
export const COPIQ_LOGO_REMOTE =
  "https://nuoonagnkhbeeymtvrcn.supabase.co/storage/v1/object/public/assets/logo-png-copiq.png"

export function BrandMark({ size = 40, className }: { size?: number; className?: string }) {
  return (
    <span
      className={cn("relative inline-block shrink-0 overflow-hidden", className)}
      style={{ width: size, height: size }}
    >
      {/* eslint-disable-next-line @next/next/no-img-element */}
      <img
        src={COPIQ_LOGO_PNG}
        alt=""
        width={size}
        height={size}
        decoding="async"
        className="h-full w-full scale-[1.3] object-contain"
      />
    </span>
  )
}

/**
 * Marque affichée dans les en-têtes : le logo seul, sans texte (décision du
 * propriétaire, 9 octobre 2026). Le nom reste lisible par les lecteurs
 * d'écran. `tone` est conservé pour compatibilité, le logo ne change pas.
 */
export function BrandWordmark({
  size = 40,
  className,
}: {
  size?: number
  tone?: "light" | "auto"
  className?: string
}) {
  return (
    <span className={cn("inline-flex items-center", className)}>
      <BrandMark size={Math.round(size * 1.3)} />
      <span className="sr-only">COP&apos;IQ</span>
    </span>
  )
}

/** Liseré bleu-blanc-rouge. Purement décoratif. */
export function Tricolore({ className }: { className?: string }) {
  return <span aria-hidden="true" className={cn("cq-tricolore block", className)} />
}
