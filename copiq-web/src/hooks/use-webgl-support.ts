"use client"

import { useEffect, useState } from "react"

function detectWebgl(): boolean {
  try {
    const canvas = document.createElement("canvas")
    return !!(
      window.WebGLRenderingContext &&
      (canvas.getContext("webgl2") || canvas.getContext("webgl"))
    )
  } catch {
    return false
  }
}

/**
 * Returns null while detection hasn't run yet (avoids a hydration flash),
 * then true/false once known.
 */
export function useWebglSupport(): boolean | null {
  const [supported, setSupported] = useState<boolean | null>(null)

  useEffect(() => {
    setSupported(detectWebgl())
  }, [])

  return supported
}
