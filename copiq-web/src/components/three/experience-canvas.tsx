"use client"

import { Suspense, createContext, useContext, useEffect, useState } from "react"
import { Canvas } from "@react-three/fiber"
import { useWebglSupport } from "@/hooks/use-webgl-support"
import { useReducedMotion } from "@/hooks/use-reduced-motion"
import { ExperienceLoader } from "@/components/three/experience-loader"

const ReducedMotionContext = createContext(false)
const IsMobileContext = createContext(false)

export const useSceneReducedMotion = () => useContext(ReducedMotionContext)
export const useSceneIsMobile = () => useContext(IsMobileContext)

interface ExperienceCanvasProps {
  children: React.ReactNode
  /** Rendered instead of the Canvas when WebGL is unavailable. Never leave the section empty. */
  fallback: React.ReactNode
  className?: string
}

function useIsMobile() {
  const [isMobile, setIsMobile] = useState(false)
  useEffect(() => {
    const query = window.matchMedia("(max-width: 767px)")
    setIsMobile(query.matches)
    const onChange = (e: MediaQueryListEvent) => setIsMobile(e.matches)
    query.addEventListener("change", onChange)
    return () => query.removeEventListener("change", onChange)
  }, [])
  return isMobile
}

/**
 * Shared WebGL entry point for every 3D scene on the marketing site.
 * - Never SSR'd: import this component with next/dynamic({ ssr: false }).
 * - Falls back to plain markup when WebGL is unavailable (point 28).
 * - Caps DPR and respects prefers-reduced-motion (points 26-27).
 */
export function ExperienceCanvas({ children, fallback, className }: ExperienceCanvasProps) {
  const webglSupported = useWebglSupport()
  const reducedMotion = useReducedMotion()
  const isMobile = useIsMobile()

  if (webglSupported === false) return <>{fallback}</>
  if (webglSupported === null) return <ExperienceLoader />

  return (
    <div className={className}>
      <Canvas
        dpr={isMobile ? [1, 1] : [1, 1.5]}
        gl={{ antialias: true, powerPreference: "high-performance", alpha: false }}
        camera={{ fov: 35, position: [0, 0, 8] }}
        onCreated={({ gl }) => gl.setClearColor("#00040F", 1)}
      >
        <Suspense fallback={null}>
          {/* prefers-reduced-motion is threaded through context so scenes can
              skip scroll-driven camera work while still rendering statically. */}
          <ReducedMotionContext.Provider value={reducedMotion}>
            <IsMobileContext.Provider value={isMobile}>{children}</IsMobileContext.Provider>
          </ReducedMotionContext.Provider>
        </Suspense>
      </Canvas>
    </div>
  )
}
