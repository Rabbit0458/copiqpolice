import { create } from "zustand"

interface HeroScrollState {
  /** 0 → top of hero, 1 → hero fully scrolled past. Driven by GSAP ScrollTrigger. */
  progress: number
  setProgress: (value: number) => void
}

/**
 * Bridge between the DOM-driven GSAP ScrollTrigger timeline and the R3F
 * canvas. R3F components read `useHeroScroll.getState().progress` inside
 * useFrame instead of subscribing, so scroll doesn't trigger React re-renders
 * on every frame.
 */
export const useHeroScroll = create<HeroScrollState>((set) => ({
  progress: 0,
  setProgress: (value) => set({ progress: value }),
}))
