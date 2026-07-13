import { cn } from "@/lib/utils"
import { cva, type VariantProps } from "class-variance-authority"
import { forwardRef } from "react"

const buttonVariants = cva(
  "inline-flex items-center justify-center gap-2 rounded-xl font-semibold text-sm transition-all duration-200 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-brand/50 disabled:opacity-50 disabled:cursor-not-allowed active:scale-[0.98]",
  {
    variants: {
      variant: {
        default: "bg-brand hover:bg-brand-mid text-white shadow-brand hover:shadow-brand-lg",
        secondary: "bg-[var(--surface-container)] hover:bg-[var(--surface-container-hi)] text-[var(--on-surface)] border border-[var(--outline)]",
        ghost: "hover:bg-[var(--surface-container)] text-[var(--on-surface-muted)] hover:text-[var(--on-surface)]",
        danger: "bg-danger hover:bg-red-600 text-white",
        outline: "border border-[var(--outline)] text-[var(--on-surface)] hover:bg-[var(--surface-container)]",
        premium: "bg-gradient-to-r from-brand to-brand-mid text-white shadow-brand hover:shadow-brand-lg",
      },
      size: {
        sm: "px-3 py-1.5 text-xs rounded-lg",
        md: "px-4 py-2.5",
        lg: "px-6 py-3.5",
        icon: "p-2 rounded-xl",
      },
    },
    defaultVariants: { variant: "default", size: "md" },
  }
)

interface ButtonProps
  extends React.ButtonHTMLAttributes<HTMLButtonElement>,
    VariantProps<typeof buttonVariants> {
  loading?: boolean
}

export const Button = forwardRef<HTMLButtonElement, ButtonProps>(
  ({ className, variant, size, loading, children, disabled, ...props }, ref) => (
    <button
      ref={ref}
      disabled={disabled || loading}
      className={cn(buttonVariants({ variant, size }), className)}
      {...props}
    >
      {loading && (
        <span className="w-4 h-4 border-2 border-current/30 border-t-current rounded-full animate-spin" />
      )}
      {children}
    </button>
  )
)
Button.displayName = "Button"
