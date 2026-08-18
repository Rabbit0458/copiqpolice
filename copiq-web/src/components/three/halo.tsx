"use client"

import { useMemo } from "react"
import * as THREE from "three"

/**
 * Soft radial glow behind the hero phone. Generated procedurally on a
 * canvas at runtime — no external texture asset to ship or optimize.
 */
export function Halo({ color = "#1147D9", size = 9 }: { color?: string; size?: number }) {
  const texture = useMemo(() => {
    const canvas = document.createElement("canvas")
    canvas.width = 512
    canvas.height = 512
    const ctx = canvas.getContext("2d")!
    const gradient = ctx.createRadialGradient(256, 256, 0, 256, 256, 256)
    gradient.addColorStop(0, color)
    gradient.addColorStop(1, "rgba(0,0,0,0)")
    ctx.fillStyle = gradient
    ctx.fillRect(0, 0, 512, 512)
    const tex = new THREE.CanvasTexture(canvas)
    tex.needsUpdate = true
    return tex
  }, [color])

  return (
    <mesh position={[0, 0, -2]}>
      <planeGeometry args={[size, size]} />
      <meshBasicMaterial map={texture} transparent opacity={0.35} blending={THREE.AdditiveBlending} depthWrite={false} />
    </mesh>
  )
}
