import type { Metadata } from "next"
import { Suspense } from "react"
import { LoginForm } from "@/features/auth/login-form"


export const metadata: Metadata = {
  title: "Connexion",
  description: "Connectez-vous à votre compte COP'IQ",
  robots: { index: false, follow: false },
}

export default function LoginPage() {
  return (
    <Suspense fallback={<div className="flex items-center justify-center h-full"><div className="w-6 h-6 border-2 border-[#1147D9] border-t-transparent rounded-full animate-spin" /></div>}>
      <LoginForm />
    </Suspense>
  )
}
