"use client"

import { useMemo, type RefObject } from "react"
import * as THREE from "three"

/**
 * Temporary procedural placeholder for the phone screen, rendered as a flat
 * canvas texture (same reliable technique as Halo) rather than a live DOM
 * overlay. drei's <Html transform> blew up in scale once the phone started
 * moving toward the camera — swapped out until that's debugged with a real
 * browser in hand. See phone-screen-ui.tsx for the real dashboard
 * recreation this will eventually be replaced by.
 */
export function PhoneScreenTexture({ materialRef }: { materialRef: RefObject<THREE.MeshBasicMaterial | null> }) {
  const texture = useMemo(() => {
    const canvas = document.createElement("canvas")
    canvas.width = 512
    canvas.height = 1024
    const ctx = canvas.getContext("2d")!

    const gradient = ctx.createLinearGradient(0, 0, 0, canvas.height)
    gradient.addColorStop(0, "#0F1740")
    gradient.addColorStop(1, "#0B102A")
    ctx.fillStyle = gradient
    ctx.fillRect(0, 0, canvas.width, canvas.height)

    ctx.fillStyle = "#7FB3FF"
    ctx.font = "bold 64px system-ui, sans-serif"
    ctx.textAlign = "center"
    ctx.fillText("COP'IQ", canvas.width / 2, canvas.height / 2 - 20)

    ctx.strokeStyle = "rgba(127,179,255,0.4)"
    ctx.lineWidth = 4
    ctx.beginPath()
    ctx.roundRect(80, canvas.height / 2 + 40, canvas.width - 160, 60, 16)
    ctx.stroke()

    const tex = new THREE.CanvasTexture(canvas)
    tex.needsUpdate = true
    return tex
  }, [])

  return (
    <mesh position={[0, 0, 0.09]}>
      <planeGeometry args={[1.0, 2.15]} />
      <meshBasicMaterial ref={materialRef} map={texture} toneMapped={false} transparent />
    </mesh>
  )
}
