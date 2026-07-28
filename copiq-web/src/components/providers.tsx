"use client"

import { ThemeProvider } from "next-themes"
import { Toaster } from "react-hot-toast"
import { CookieBanner } from "@/components/cookie-banner"

export function Providers({ children }: { children: React.ReactNode }) {
  return (
    <ThemeProvider
      attribute="class"
      defaultTheme="system"
      enableSystem
      disableTransitionOnChange={false}
    >
      {children}
      <Toaster
        position="top-right"
        toastOptions={{
          duration: 4000,
          style: {
            background: "var(--surface-container)",
            color: "var(--on-surface)",
            border: "1px solid var(--outline)",
            borderRadius: "12px",
            fontSize: "0.875rem",
            fontFamily: "var(--font-instrument-sans, system-ui)",
          },
          success: {
            iconTheme: { primary: "#22C55E", secondary: "#fff" },
          },
          error: {
            iconTheme: { primary: "#EF4444", secondary: "#fff" },
          },
        }}
      />
      {/* Consentement RGPD. Le bandeau ne s'affiche que si aucun choix n'a
          encore été fait, ou si la politique a changé depuis. */}
      <CookieBanner />
    </ThemeProvider>
  )
}
