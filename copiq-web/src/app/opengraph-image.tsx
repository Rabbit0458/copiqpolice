import { ImageResponse } from "next/og"

export const alt = "COP'IQ — Préparation Police Nationale"
export const size = { width: 1200, height: 630 }
export const contentType = "image/png"
export const dynamic = "force-static"

export default function OpenGraphImage() {
  return new ImageResponse(
    <div style={{ width: "100%", height: "100%", display: "flex", position: "relative", overflow: "hidden", background: "#070b1c", color: "white", fontFamily: "sans-serif" }}>
      <div style={{ position: "absolute", inset: 0, display: "flex", background: "radial-gradient(circle at 18% 12%, rgba(37,99,235,.52), transparent 36%), radial-gradient(circle at 85% 82%, rgba(220,38,38,.28), transparent 34%)" }} />
      <div style={{ position: "absolute", left: 76, top: 64, display: "flex", alignItems: "center", gap: 18 }}>
        <div style={{ width: 76, height: 76, display: "flex", alignItems: "center", justifyContent: "center", borderRadius: 24, background: "linear-gradient(145deg,#2563eb,#1237a6)", boxShadow: "0 20px 50px rgba(37,99,235,.35)", fontSize: 36, fontWeight: 800 }}>C</div>
        <div style={{ display: "flex", flexDirection: "column" }}><span style={{ fontSize: 36, fontWeight: 800 }}>COP&apos;IQ</span><span style={{ marginTop: 4, color: "#93b4ff", fontSize: 18, letterSpacing: 5, textTransform: "uppercase" }}>Préparation Police Nationale</span></div>
      </div>
      <div style={{ position: "absolute", left: 76, right: 76, bottom: 78, display: "flex", flexDirection: "column" }}>
        <span style={{ maxWidth: 920, fontSize: 66, lineHeight: 1.06, fontWeight: 800, letterSpacing: -2 }}>Prépare ton avenir avec méthode.</span>
        <span style={{ marginTop: 24, maxWidth: 900, color: "#c5ccdc", fontSize: 27, lineHeight: 1.35 }}>Cours, quiz, cas pratiques et suivi personnalisé pour progresser vers la Police nationale.</span>
      </div>
      <div style={{ position: "absolute", right: 76, top: 76, width: 128, height: 5, display: "flex", borderRadius: 999, background: "linear-gradient(90deg,#2563eb 0 45%,#fff 45% 67%,#ef3340 67%)" }} />
    </div>,
    size,
  )
}
