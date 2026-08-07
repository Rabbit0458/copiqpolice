"use client"
import { useSyncExternalStore } from "react"

let cached: boolean | null = null

function detectWebgl() {
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

function subscribe() {
  return () => {}
}

function getSnapshot() {
  if (cached === null) cached = detectWebgl()
  return cached
}

function getServerSnapshot() {
  return false
}

/** false par défaut pendant le rendu serveur / avant hydratation. */
export function useWebglSupport() {
  return useSyncExternalStore(subscribe, getSnapshot, getServerSnapshot)
}
