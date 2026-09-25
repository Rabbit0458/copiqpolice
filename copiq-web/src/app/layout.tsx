import type { Metadata, Viewport } from "next"
import { Instrument_Sans } from "next/font/google"
import Script from "next/script"
import { Providers } from "@/components/providers"
import "@/styles/globals.css"

const SITE_URL = "https://copiq.fr"
const APP_ICON_URL =
  "https://nuoonagnkhbeeymtvrcn.supabase.co/storage/v1/object/public/assets/app_icon.png"

const instrumentSans = Instrument_Sans({
  subsets: ["latin"],
  weight: ["400", "500", "600", "700"],
  variable: "--font-instrument-sans",
  display: "swap",
})

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
  metadataBase: new URL(SITE_URL),
  alternates: { canonical: "/" },
  icons: {
    icon: [{ url: APP_ICON_URL, type: "image/png", sizes: "1024x1024" }],
    shortcut: APP_ICON_URL,
    apple: [{ url: APP_ICON_URL, type: "image/png", sizes: "1024x1024" }],
  },
  openGraph: {
    type: "website",
    locale: "fr_FR",
    url: SITE_URL,
    siteName: "COP'IQ",
    title: "COP'IQ — Préparation Police Nationale",
    description: "Quiz, cours et cas pratiques pour réussir le concours Policier Adjoint et Gardien de la Paix.",
    images: [{ url: "/opengraph-image", width: 1200, height: 630, alt: "COP'IQ — Préparation Police Nationale" }],
  },
  twitter: {
    card: "summary_large_image",
    title: "COP'IQ — Préparation Police Nationale",
    description: "Quiz, cours et cas pratiques pour réussir le concours.",
    images: ["/opengraph-image"],
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
    <html
      lang="fr"
      suppressHydrationWarning
      data-scroll-behavior="smooth"
      className={instrumentSans.variable}
    >
      <head>
        {/* Sans JavaScript, l'IntersectionObserver qui déclenche les reveals
            ne tourne pas : sans ce repli, les sections de la vitrine
            resteraient à `opacity: 0` et la page paraîtrait vide. Le contenu
            doit rester lisible même si le JS ne se charge pas (§16). */}
        <noscript>
          <style>{`.cq-reveal{opacity:1!important;transform:none!important}`}</style>
        </noscript>
      </head>
      <body>
        <Script src="/copiq-config.js" strategy="beforeInteractive" />
        <Providers>{children}</Providers>
      </body>
    </html>
  )
}
