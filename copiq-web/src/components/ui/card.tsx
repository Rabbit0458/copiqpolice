import { cn } from "@/lib/utils"

interface CardProps {
  className?: string
  children: React.ReactNode
  hover?: boolean
  onClick?: () => void
}

export function Card({ className, children, hover, onClick }: CardProps) {
  return (
    <div
      onClick={onClick}
      className={cn(
        "rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-5",
        "shadow-card",
        hover && "hover:shadow-card-hover hover:-translate-y-0.5 transition-all duration-200 cursor-pointer",
        className
      )}
    >
      {children}
    </div>
  )
}

export function CardHeader({ className, children }: { className?: string; children: React.ReactNode }) {
  return <div className={cn("mb-4", className)}>{children}</div>
}

export function CardTitle({ className, children }: { className?: string; children: React.ReactNode }) {
  return <h3 className={cn("font-semibold text-[var(--on-surface)]", className)}>{children}</h3>
}

export function CardDescription({ className, children }: { className?: string; children: React.ReactNode }) {
  return <p className={cn("text-sm text-[var(--on-surface-muted)] mt-1", className)}>{children}</p>
}
