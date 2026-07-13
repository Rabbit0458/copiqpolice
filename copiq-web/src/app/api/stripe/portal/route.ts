import { NextResponse } from "next/server"
import { createClient } from "@/lib/supabase/server"
import { getStripe } from "@/lib/stripe/client"

export async function POST() {
  try {
    const supabase = await createClient()
    const { data: { user } } = await supabase.auth.getUser()

    if (!user) return NextResponse.json({ error: "Non authentifié" }, { status: 401 })

    const { data: sub } = await supabase
      .from("cas_pratique_subscriptions")
      .select("stripe_customer_id")
      .eq("user_id", user.id)
      .single()

    if (!(sub as any)?.stripe_customer_id) {
      return NextResponse.json({ error: "Aucun client Stripe trouvé" }, { status: 404 })
    }

    const stripe = getStripe()
    const session = await stripe.billingPortal.sessions.create({
      customer: (sub as any)?.stripe_customer_id,
      return_url: `${process.env.NEXT_PUBLIC_SITE_URL}/abonnement`,
    })

    return NextResponse.json({ url: session.url })
  } catch (error: unknown) {
    const message = error instanceof Error ? error.message : "Erreur interne"
    return NextResponse.json({ error: message }, { status: 500 })
  }
}
