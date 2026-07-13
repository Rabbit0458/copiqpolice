import { cn } from "@/lib/utils"
import { cva, type VariantProps } from "class-variance-authority"

const badgeVariants = cva(
  "inline-flex items-center gap-1 rounded-full text-xs font-semibold px-2.5 py-0.5",
  {
    variants: {
      variant: {
        default: "bg-brand/10 text-brand",
        premium: "bg-gradient-to-r from-brand/10 to-brand-mid/10 text-brand border border-brand/20",
        success: "bg-success/10 text-success",
        warning: "bg-warning/10 text-warning",
        danger: "bg-danger/10 text-danger",
        muted: "bg-[var(--surface-container)] text-[var(--on-surface-muted)]",
      },
    },
    defaultVariants: { variant: "default" },
  }
)

interface BadgeProps extends VariantProps<typeof badgeVariants> {
  className?: string
  children: React.ReactNode
}

export function Badge({ className, variant, children }: BadgeProps) {
  return <span className={cn(badgeVariants({ variant }), className)}>{children}</span>
}
