"use client"

import { useRef } from "react"
import { useFrame } from "@react-three/fiber"
import { RoundedBox } from "@react-three/drei"
import * as THREE from "three"
import { useHeroScroll } from "@/lib/animations/scroll-store"
import { useSceneReducedMotion } from "@/components/three/experience-canvas"
import { PhoneScreenTexture } from "@/components/three/phone-screen-texture"

/**
 * Generic premium smartphone silhouette (procedural, not a copy of any
 * specific manufacturer's design).
 *
 * Scroll choreography (brief points 10-11): floats gently at rest, then on
 * scroll drifts toward the camera, slides sideways in front of the hero
 * text, and fades out to leave the composition — a single continuous
 * travelling shot rather than a cut between scenes.
 */
export function PhoneMockup() {
  const group = useRef<THREE.Group>(null)
  const bodyMaterial = useRef<THREE.MeshPhysicalMaterial>(null)
  const screenMaterial = useRef<THREE.MeshBasicMaterial>(null)
  const reducedMotion = useSceneReducedMotion()

  useFrame((state, delta) => {
    const g = group.current
    if (!g) return

    const t = state.clock.elapsedTime
    const progress = reducedMotion ? 0 : useHeroScroll.getState().progress

    // Resting float + very subtle mouse parallax.
    const floatY = Math.sin(t * 0.6) * 0.08
    const idleRotY = Math.sin(t * 0.15) * 0.12
    const mouseInfluenceX = reducedMotion ? 0 : state.pointer.y * 0.06
    const mouseInfluenceY = reducedMotion ? 0 : state.pointer.x * 0.1

    // Scroll travelling: approach camera, slide across, then leave + fade.
    const targetZ = THREE.MathUtils.lerp(0, 3.4, progress)
    const targetX = THREE.MathUtils.lerp(0, -2.6, Math.min(progress * 1.3, 1))
    const targetRotY = idleRotY + progress * Math.PI * 0.6
    const fade = 1 - THREE.MathUtils.smoothstep(progress, 0.55, 1)

    g.position.z = THREE.MathUtils.damp(g.position.z, targetZ, 4, delta)
    g.position.x = THREE.MathUtils.damp(g.position.x, targetX, 4, delta)
    g.position.y = floatY
    g.rotation.y = THREE.MathUtils.damp(g.rotation.y, targetRotY + mouseInfluenceY, 4, delta)
    g.rotation.x = THREE.MathUtils.damp(g.rotation.x, mouseInfluenceX, 4, delta)
    g.scale.setScalar(THREE.MathUtils.lerp(1, 0.85, progress))

    if (bodyMaterial.current) bodyMaterial.current.opacity = fade
    if (screenMaterial.current) screenMaterial.current.opacity = fade
  })

  return (
    <group ref={group}>
      <RoundedBox args={[1.2, 2.4, 0.12]} radius={0.16} smoothness={4}>
        <meshPhysicalMaterial
          ref={bodyMaterial}
          color="#1B2340"
          emissive="#1147D9"
          emissiveIntensity={0.25}
          metalness={0.7}
          roughness={0.2}
          clearcoat={0.6}
          clearcoatRoughness={0.3}
          transparent
        />
      </RoundedBox>

      <PhoneScreenTexture materialRef={screenMaterial} />
    </group>
  )
}
