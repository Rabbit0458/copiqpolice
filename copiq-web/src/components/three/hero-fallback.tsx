/**
 * Rendered instead of the WebGL canvas when the browser has no WebGL
 * support (point 28 of the redesign brief) — pure CSS, no external image,
 * never a blank section.
 */
export function HeroFallback() {
  return (
    <div className="absolute inset-0 overflow-hidden bg-[#00040F]">
      <div
        className="absolute left-1/2 top-1/2 h-[420px] w-[420px] -translate-x-1/2 -translate-y-1/2 rounded-full opacity-40 blur-3xl"
        style={{ background: "radial-gradient(circle, #1147D9 0%, transparent 70%)" }}
      />
      <div className="absolute left-1/2 top-1/2 h-64 w-32 -translate-x-1/2 -translate-y-1/2 rounded-[2.5rem] border border-white/10 bg-white/[0.03] backdrop-blur-sm" />
    </div>
  )
}
