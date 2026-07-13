import type { Metadata, Viewport } from "next"
import { Providers } from "@/components/providers"
import "@/styles/globals.css"

export const metadata: Metadata = {
  title: {
    default: "COP'IQ — Préparation Police Nationale",
    template: "%s | COP'IQ",
  },
  description:
    "La plateforme de référence pour préparer le concours Policier Adjoint et Gardien de la Paix. Quiz, cours, cas pratiques, statistiques.",
  keywords: [
    "police nationale",
    "concours policier adjoint",
    "gardien de la paix",
    "préparation concours",
    "quiz police",
    "droit pénal",
    "procédure pénale",
    "QCM police",
  ],
  authors: [{ name: "COP'IQ" }],
  creator: "COP'IQ",
  metadataBase: new URL(process.env.NEXT_PUBLIC_SITE_URL ?? "https://copiqpolice.app"),
  openGraph: {
    type: "website",
    locale: "fr_FR",
    url: "https://copiqpolice.app",
    siteName: "COP'IQ",
    title: "COP'IQ — Préparation Police Nationale",
    description: "Quiz, cours et cas pratiques pour réussir le concours Policier Adjoint et Gardien de la Paix.",
  },
  twitter: {
    card: "summary_large_image",
    title: "COP'IQ — Préparation Police Nationale",
    description: "Quiz, cours et cas pratiques pour réussir le concours.",
  },
  robots: {
    index: true,
    follow: true,
    googleBot: { index: true, follow: true },
  },
}

export const viewport: Viewport = {
  themeColor: [
    { media: "(prefers-color-scheme: light)", color: "#ffffff" },
    { media: "(prefers-color-scheme: dark)", color: "#0B102A" },
  ],
  width: "device-width",
  initialScale: 1,
}

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="fr" suppressHydrationWarning>
      <head>
        <link rel="icon" href="/favicon.ico" />
        <script src="/copiq-config.js" />
      </head>
      <body>
        <Providers>{children}</Providers>
      </body>
    </html>
  )
}
