import { forwardRef } from "react"
import { BarChart2, Bell, Brain, Crown, FileText, Target } from "lucide-react"

/**
 * Faithful miniature of the real COP'IQ dashboard (see
 * src/features/dashboard/dashboard-content.tsx), rebuilt in plain HTML/CSS
 * so it can be embedded on the 3D phone screen via drei's <Html transform>.
 * Not a screenshot: same copy, same icons, same design tokens.
 */
export const PhoneScreenUI = forwardRef<HTMLDivElement>(function PhoneScreenUI(_props, ref) {
  return (
    <div
      ref={ref}
      style={{
        width: 260,
        height: 560,
        borderRadius: 28,
        overflow: "hidden",
        background: "#0B102A",
        fontFamily: "var(--font-instrument-sans, system-ui)",
        color: "#F8FAFC",
        userSelect: "none",
        pointerEvents: "none",
        boxShadow: "inset 0 0 0 1px rgba(255,255,255,0.06)",
      }}
    >
      {/* Status bar */}
      <div style={{ display: "flex", justifyContent: "space-between", padding: "14px 18px 4px", fontSize: 11, color: "#94A3B8" }}>
        <span>9:41</span>
        <span>COP&apos;IQ</span>
      </div>

      {/* Header */}
      <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", padding: "10px 18px" }}>
        <div>
          <div style={{ fontSize: 15, fontWeight: 700 }}>Bonjour, Camille</div>
          <div style={{ fontSize: 10, color: "#94A3B8", marginTop: 2 }}>Gardien de la Paix — Scolarité</div>
        </div>
        <div style={{ width: 26, height: 26, borderRadius: 9999, background: "rgba(148,163,184,0.15)", display: "flex", alignItems: "center", justifyContent: "center" }}>
          <Bell size={12} color="#94A3B8" />
        </div>
      </div>

      {/* Stat cards */}
      <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 8, padding: "6px 18px" }}>
        <StatCard icon={<BarChart2 size={13} />} label="Points XP" value="2 340" />
        <StatCard icon={<Crown size={13} />} label="Abonnement" value="Premium" accent />
      </div>

      {/* Module grid */}
      <div style={{ padding: "12px 18px 0", fontSize: 10, fontWeight: 600, letterSpacing: 1, color: "#64748B", textTransform: "uppercase" }}>
        Votre parcours
      </div>
      <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 8, padding: "8px 18px" }}>
        <ModuleTile icon={<Target size={16} />} label="Quiz par thème" />
        <ModuleTile icon={<Brain size={16} />} label="Psychotechniques" />
        <ModuleTile icon={<FileText size={16} />} label="Cas pratiques" premium />
        <ModuleTile icon={<BarChart2 size={16} />} label="Progression" />
      </div>

      {/* Progress */}
      <div style={{ margin: "10px 18px 0", padding: 12, borderRadius: 16, background: "rgba(255,255,255,0.04)" }}>
        <div style={{ display: "flex", justifyContent: "space-between", fontSize: 10, color: "#94A3B8", marginBottom: 6 }}>
          <span>Progression module</span>
          <span>68%</span>
        </div>
        <div style={{ height: 5, borderRadius: 999, background: "rgba(255,255,255,0.08)" }}>
          <div style={{ width: "68%", height: "100%", borderRadius: 999, background: "linear-gradient(90deg,#1147D9,#7FB3FF)" }} />
        </div>
      </div>
    </div>
  )
})

function StatCard({ icon, label, value, accent }: { icon: React.ReactNode; label: string; value: string; accent?: boolean }) {
  return (
    <div style={{ padding: 10, borderRadius: 14, background: accent ? "rgba(17,71,217,0.18)" : "rgba(255,255,255,0.04)" }}>
      <div style={{ color: accent ? "#7FB3FF" : "#94A3B8", marginBottom: 6 }}>{icon}</div>
      <div style={{ fontSize: 13, fontWeight: 700 }}>{value}</div>
      <div style={{ fontSize: 9, color: "#64748B" }}>{label}</div>
    </div>
  )
}

function ModuleTile({ icon, label, premium }: { icon: React.ReactNode; label: string; premium?: boolean }) {
  return (
    <div style={{ padding: 10, borderRadius: 14, background: "rgba(255,255,255,0.04)", display: "flex", flexDirection: "column", gap: 8 }}>
      <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between" }}>
        <span style={{ color: "#7FB3FF" }}>{icon}</span>
        {premium && <Crown size={10} color="#FBBF24" />}
      </div>
      <span style={{ fontSize: 10, fontWeight: 600, color: "#E2E8F0" }}>{label}</span>
    </div>
  )
}
