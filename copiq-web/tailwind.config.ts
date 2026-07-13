import type { Config } from "tailwindcss";

const config: Config = {
  darkMode: "class",
  content: [
    "./src/pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/components/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/app/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/features/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      colors: {
        // ── Brand ──────────────────────────────────────
        brand: {
          DEFAULT: "#1147D9",
          mid: "#1A55E6",
          deep: "#0E2F9E",
        },
        navy: {
          DEFAULT: "#000B36",
          mid: "#000A33",
          deep: "#00082D",
        },
        // ── Surface light ───────────────────────────────
        surface: {
          DEFAULT: "#FFFFFF",
          container: "#F4F6FB",
          "container-hi": "#EAEEf7",
        },
        outline: {
          DEFAULT: "#D5DBE8",
          variant: "#E7EBF3",
        },
        // ── Surface dark ────────────────────────────────
        "surface-dark": {
          DEFAULT: "#0B102A",
          container: "#0F1438",
          "container-hi": "#13193F",
        },
        "outline-dark": {
          DEFAULT: "#1F2A52",
          variant: "#1A2050",
        },
        // ── Sémantique ──────────────────────────────────
        success: {
          DEFAULT: "#22C55E",
          dark: "#34D399",
          "soft-l": "#DCFCE7",
          "soft-d": "#022C22",
        },
        warning: {
          DEFAULT: "#F59E0B",
          dark: "#FBBF24",
          "soft-l": "#FEF3C7",
          "soft-d": "#451A03",
        },
        danger: {
          DEFAULT: "#EF4444",
          dark: "#F87171",
          "soft-l": "#FEE2E2",
          "soft-d": "#450A0A",
        },
        info: {
          DEFAULT: "#0EA5E9",
          dark: "#38BDF8",
          "soft-l": "#E0F2FE",
          "soft-d": "#082F49",
        },
        // ── Modules ─────────────────────────────────────
        module: {
          deontologie: "#0EA5E9",
          "cadre-legal": "#22C55E",
          securite: "#F59E0B",
          intervention: "#EF4444",
          famille: "#A855F7",
          routier: "#06B6D4",
        },
      },
      fontFamily: {
        sans: ["var(--font-instrument-sans)", "system-ui", "sans-serif"],
      },
      fontSize: {
        "2xs": "0.625rem",
      },
      borderRadius: {
        "4xl": "2rem",
      },
      animation: {
        "fade-in": "fadeIn 0.3s ease-out",
        "slide-up": "slideUp 0.3s ease-out",
        "slide-in-right": "slideInRight 0.3s ease-out",
        "scale-in": "scaleIn 0.2s ease-out",
        shimmer: "shimmer 1.5s infinite",
        pulse: "pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite",
      },
      keyframes: {
        fadeIn: {
          from: { opacity: "0" },
          to: { opacity: "1" },
        },
        slideUp: {
          from: { opacity: "0", transform: "translateY(12px)" },
          to: { opacity: "1", transform: "translateY(0)" },
        },
        slideInRight: {
          from: { opacity: "0", transform: "translateX(12px)" },
          to: { opacity: "1", transform: "translateX(0)" },
        },
        scaleIn: {
          from: { opacity: "0", transform: "scale(0.95)" },
          to: { opacity: "1", transform: "scale(1)" },
        },
        shimmer: {
          "0%": { backgroundPosition: "-200% 0" },
          "100%": { backgroundPosition: "200% 0" },
        },
      },
      backgroundImage: {
        "gradient-brand": "linear-gradient(135deg, #1147D9 0%, #1A55E6 50%, #0E2F9E 100%)",
        "gradient-dark": "linear-gradient(135deg, #000B36 0%, #000A33 50%, #00082D 100%)",
        "gradient-glass": "linear-gradient(135deg, rgba(255,255,255,0.1) 0%, rgba(255,255,255,0.05) 100%)",
        shimmer:
          "linear-gradient(90deg, transparent 0%, rgba(255,255,255,0.08) 50%, transparent 100%)",
      },
      boxShadow: {
        brand: "0 4px 24px rgba(17, 71, 217, 0.25)",
        "brand-lg": "0 8px 40px rgba(17, 71, 217, 0.35)",
        card: "0 1px 3px rgba(0,0,0,0.06), 0 1px 2px rgba(0,0,0,0.04)",
        "card-hover": "0 4px 12px rgba(0,0,0,0.08), 0 2px 4px rgba(0,0,0,0.04)",
        glass: "0 8px 32px rgba(0, 0, 0, 0.12), inset 0 0 0 1px rgba(255,255,255,0.08)",
      },
      backdropBlur: {
        xs: "2px",
      },
    },
  },
  plugins: [],
};

export default config;
