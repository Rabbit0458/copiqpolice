import type { Metadata } from "next"
import { SignupForm } from "@/features/auth/signup-form"


export const metadata: Metadata = {
  title: "Créer un compte",
  description: "Rejoignez COP'IQ gratuitement et commencez votre préparation",
  robots: { index: false, follow: false },
}

export default function SignupPage() {
  return <SignupForm />
}
