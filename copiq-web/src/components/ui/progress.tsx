import { cn } from "@/lib/utils"

interface ProgressProps {
  value: number
  max?: number
  className?: string
  color?: "brand" | "success" | "warning" | "danger"
  size?: "sm" | "md" | "lg"
  animated?: boolean
}

const COLOR_MAP = {
  brand: "bg-brand",
  success: "bg-success",
  warning: "bg-warning",
  danger: "bg-danger",
}

const SIZE_MAP = {
  sm: "h-1",
  md: "h-2",
  lg: "h-3",
}

export function Progress({ value, max = 100, className, color = "brand", size = "md", animated }: ProgressProps) {
  const percent = Math.min(100, Math.max(0, (value / max) * 100))
  return (
    <div className={cn("w-full rounded-full bg-[var(--surface-container)]", SIZE_MAP[size], className)}>
      <div
        className={cn("rounded-full transition-all duration-500", COLOR_MAP[color], SIZE_MAP[size], animated && "animate-pulse")}
        style={{ width: `${percent}%` }}
      />
    </div>
  )
}
