"use client"

export function ExperienceLoader() {
  return (
    <div className="absolute inset-0 z-20 flex flex-col items-center justify-center gap-5 bg-[#00040F]">
      <div className="h-11 w-11 rounded-2xl bg-gradient-to-br from-[#1147D9] to-[#1A55E6] shadow-[0_0_40px_rgba(17,71,217,0.5)]" />
      <div className="h-[2px] w-40 overflow-hidden rounded-full bg-white/10">
        <div className="h-full w-1/3 animate-[loader-sweep_1.1s_ease-in-out_infinite] rounded-full bg-gradient-to-r from-[#1147D9] to-[#7FB3FF]" />
      </div>
      <p className="text-xs font-medium uppercase tracking-[0.2em] text-white/50">
        Préparation de votre expérience
      </p>
      <style>{`
        @keyframes loader-sweep {
          0% { transform: translateX(-120%); }
          100% { transform: translateX(340%); }
        }
      `}</style>
    </div>
  )
}
