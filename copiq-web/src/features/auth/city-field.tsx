"use client"

import { useEffect, useId, useState } from "react"
import { Loader2, MapPin } from "lucide-react"
import { cn } from "@/lib/utils"

/**
 * Ville avec suggestions officielles (API Découpage administratif de l'État,
 * geo.api.gouv.fr). La saisie libre reste toujours possible : si l'API ne
 * répond pas, le champ fonctionne comme un champ texte normal.
 */

type Commune = { nom: string; codeDepartement?: string; codesPostaux?: string[] }

export function CityField({
  id,
  value,
  onChange,
  invalid,
  valid,
  inputClassName,
  describedBy,
}: {
  id: string
  value: string
  onChange: (v: string) => void
  invalid: boolean
  valid: boolean
  inputClassName: string
  describedBy?: string
}) {
  const listId = useId()
  const [results, setResults] = useState<{ q: string; items: Commune[] } | null>(null)
  const [open, setOpen] = useState(false)
  const [active, setActive] = useState(-1)
  /** Valeur choisie dans la liste : on ne relance pas de recherche dessus. */
  const [picked, setPicked] = useState<string | null>(null)

  const q = value.trim()
  const searching = open && q.length >= 2 && results?.q !== q && picked !== value
  const items = results?.q === q ? results.items : []

  useEffect(() => {
    if (q.length < 2 || picked === value) return
    const ctrl = new AbortController()
    const t = window.setTimeout(async () => {
      try {
        const url = `https://geo.api.gouv.fr/communes?nom=${encodeURIComponent(q)}&fields=nom,codeDepartement,codesPostaux&boost=population&limit=6`
        const res = await fetch(url, { signal: ctrl.signal })
        const data = (await res.json()) as Commune[]
        setResults({ q, items: Array.isArray(data) ? data : [] })
        setActive(-1)
      } catch {
        if (!ctrl.signal.aborted) setResults({ q, items: [] })
      }
    }, 220)
    return () => {
      ctrl.abort()
      window.clearTimeout(t)
    }
  }, [q, value, picked])

  function choose(c: Commune) {
    setPicked(c.nom)
    onChange(c.nom)
    setOpen(false)
    setActive(-1)
  }

  const show = open && items.length > 0 && picked !== value

  return (
    <div className="relative">
      <input
        id={id}
        type="text"
        role="combobox"
        aria-autocomplete="list"
        aria-expanded={show}
        aria-controls={listId}
        aria-activedescendant={show && active >= 0 ? `${listId}-${active}` : undefined}
        aria-invalid={invalid || undefined}
        aria-describedby={describedBy}
        autoComplete="address-level2"
        maxLength={80}
        value={value}
        placeholder="Ex. Lyon"
        onChange={(e) => {
          setPicked(null)
          onChange(e.target.value)
          setOpen(true)
        }}
        onFocus={() => setOpen(true)}
        onBlur={() => window.setTimeout(() => setOpen(false), 120)}
        onKeyDown={(e) => {
          if (!show) return
          if (e.key === "ArrowDown") {
            e.preventDefault()
            setActive((a) => (a + 1) % items.length)
          } else if (e.key === "ArrowUp") {
            e.preventDefault()
            setActive((a) => (a <= 0 ? items.length - 1 : a - 1))
          } else if (e.key === "Enter" && active >= 0) {
            e.preventDefault()
            choose(items[active])
          } else if (e.key === "Escape") {
            setOpen(false)
          }
        }}
        className={cn(inputClassName, "pl-11")}
      />
      <span className="pointer-events-none absolute left-4 top-1/2 -translate-y-1/2 text-[var(--on-surface-faint)]" aria-hidden="true">
        {searching ? <Loader2 className="h-4 w-4 animate-spin" /> : <MapPin className={cn("h-4 w-4", valid && "text-[#16A34A] dark:text-[#34D399]")} />}
      </span>

      {show && (
        <ul
          id={listId}
          role="listbox"
          aria-label="Villes suggérées"
          className="cq-pop-in absolute inset-x-0 top-[calc(100%+6px)] z-20 overflow-hidden rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-1.5 shadow-[0_24px_60px_-28px_rgba(0,11,54,0.55)]"
        >
          {items.map((c, i) => (
            <li
              key={`${c.nom}-${c.codeDepartement}-${i}`}
              id={`${listId}-${i}`}
              role="option"
              aria-selected={i === active}
              onMouseDown={(e) => {
                e.preventDefault()
                choose(c)
              }}
              onMouseEnter={() => setActive(i)}
              className={cn(
                "flex cursor-pointer items-center justify-between gap-3 rounded-xl px-3 py-2.5 text-[15px] transition-colors duration-150",
                i === active ? "bg-[var(--surface-container)]" : "",
              )}
            >
              <span className="font-medium text-[var(--on-surface)]">{c.nom}</span>
              <span className="text-[13px] tabular-nums text-[var(--on-surface-faint)]">
                {c.codesPostaux?.[0] ?? c.codeDepartement}
              </span>
            </li>
          ))}
        </ul>
      )}
    </div>
  )
}
