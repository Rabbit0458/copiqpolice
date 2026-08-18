"use client"

import { useRef } from "react"
import { useFrame } from "@react-three/fiber"
import { Sparkles } from "@react-three/drei"
import type { PointLight } from "three"
import { PhoneMockup } from "@/components/three/phone-mockup"
import { Halo } from "@/components/three/halo"
import { useSceneReducedMotion, useSceneIsMobile } from "@/components/three/experience-canvas"

const INTRO_DURATION = 1.8

export function HeroScene() {
  const keyLight = useRef<PointLight>(null)
  const rimLight = useRef<PointLight>(null)
  const reducedMotion = useSceneReducedMotion()
  const isMobile = useSceneIsMobile()

  useFrame((state) => {
    // "Écran presque noir, une lumière apparaît progressivement" (brief point 10).
    const introProgress = reducedMotion
      ? 1
      : Math.min(state.clock.elapsedTime / INTRO_DURATION, 1)
    if (keyLight.current) keyLight.current.intensity = introProgress * 90
    if (rimLight.current) rimLight.current.intensity = introProgress * 45
  })

  return (
    <>
      <ambientLight intensity={0.6} />
      <pointLight ref={keyLight} position={[2.5, 2, 3]} color="#7FB3FF" intensity={0} decay={1.5} />
      <pointLight ref={rimLight} position={[-3, -1.5, -2]} color="#1147D9" intensity={0} decay={1.5} />

      <Halo />
      <Sparkles
        count={isMobile ? 30 : 90}
        scale={[7, 7, 4]}
        size={1.6}
        speed={0.15}
        opacity={0.35}
        color="#7FB3FF"
      />

      <PhoneMockup />
    </>
  )
}
