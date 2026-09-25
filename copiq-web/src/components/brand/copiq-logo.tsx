import Image from "next/image"
import { cn } from "@/lib/utils"

/**
 * Logo officiel COP'IQ — point d'entrée UNIQUE.
 *
 * Le fichier fourni (`logo-png-copiq.png`, 1254 × 1254) a un **fond noir
 * opaque**, pas de transparence. Posé tel quel sur une surface claire il
 * afficherait un carré noir. Il est donc systématiquement enfermé dans une
 * pastille bleu nuit : le fichier reste intact, seul son environnement reçoit
 * un fond, une bordure et éventuellement un halo.
 *
 * Interdictions respectées ici :
 *  - jamais recréé en CSS ni en texte,
 *  - jamais étiré (ratio 1:1 verrouillé, `width` === `height`),
 *  - jamais recoloré ni filtré,
 *  - jamais remplacé par une icône.
 */

export const COPIQ_LOGO_URL =
  "https://nuoonagnkhbeeymtvrcn.supabase.co/storage/v1/object/public/assets/logo-png-copiq.png"

type Props = {
  /** Côté du logo en pixels CSS. Le ratio reste 1:1. */
  size?: number
  /** `true` au-dessus de la ligne de flottaison (en-tête, hero). */
  priority?: boolean
  /** Halo bleu autour de la pastille. Décor du conteneur, pas du fichier. */
  halo?: boolean
  className?: string
}

export function CopiqLogo({
  size = 40,
  priority = false,
  halo = false,
  className,
}: Props) {
  return (
    <span
      className={cn(
        "relative inline-flex shrink-0 items-center justify-center overflow-hidden",
        "rounded-[28%] bg-[#02040E] ring-1 ring-white/12",
        halo && "cq-halo",
        className,
      )}
      style={{ width: size, height: size }}
    >
      <Image
        src={COPIQ_LOGO_URL}
        alt="COP'IQ"
        width={size}
        height={size}
        priority={priority}
        loading={priority ? undefined : "lazy"}
        unoptimized
        className="h-full w-full object-contain"
      />
    </span>
  )
}

/**
 * Logo + mot-symbole. `tone` choisit la couleur du texte selon le fond ;
 * le logo lui-même ne change jamais.
 */
export function CopiqWordmark({
  size = 40,
  tone = "light",
  priority = false,
  className,
}: Props & { tone?: "light" | "dark" | "auto" }) {
  return (
    <span className={cn("inline-flex items-center gap-2.5", className)}>
      <CopiqLogo size={size} priority={priority} />
      <span
        className={cn(
          "text-[1.0625rem] font-bold tracking-[-0.02em]",
          tone === "light" && "text-white",
          tone === "dark" && "text-[#0F172A]",
          tone === "auto" && "text-[var(--on-surface)]",
        )}
      >
        COP&apos;IQ
      </span>
    </span>
  )
}
