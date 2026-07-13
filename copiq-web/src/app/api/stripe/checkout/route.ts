import { NextRequest, NextResponse } from "next/server"
import { createClient } from "@/lib/supabase/server"
import { getStripe } from "@/lib/stripe/client"

const PRICE_IDS: Record<string, string> = {
  week: process.env.STRIPE_PRICE_WEEK ?? "",
  month: process.env.STRIPE_PRICE_MONTH ?? "",
  year: process.env.STRIPE_PRICE_YEAR ?? "",
}

export async function POST(request: NextRequest) {
  try {
    const supabase = await createClient()
    const { data: { user } } = await supabase.auth.getUser()

    if (!user) {
      return NextResponse.json({ error: "Non authentifié" }, { status: 401 })
    }

    const body = await request.json()
    const { plan } = body as { plan: "week" | "month" | "year" }

    const priceId = PRICE_IDS[plan]
    if (!priceId) {
      return NextResponse.json({ error: "Plan invalide" }, { status: 400 })
    }

    const stripe = getStripe()

    // Chercher ou créer le customer Stripe
    const { data: sub } = await supabase
      .from("cas_pratique_subscriptions")
      .select("stripe_customer_id")
      .eq("user_id", user.id)
      .single()

    let customerId = (sub as any)?.stripe_customer_id

    if (!customerId) {
      const customer = await stripe.customers.create({
        email: user.email,
        metadata: { user_id: user.id },
      })
      customerId = customer.id
    }

    const session = await stripe.checkout.sessions.create({
      customer: customerId,
      mode: "subscription",
      payment_method_types: ["card"],
      line_items: [{ price: priceId, quantity: 1 }],
      success_url: `${process.env.NEXT_PUBLIC_SITE_URL}/abonnement?success=true`,
      cancel_url: `${process.env.NEXT_PUBLIC_SITE_URL}/abonnement?canceled=true`,
      subscription_data: {
        trial_period_days: plan === "week" ? undefined : 7,
        metadata: { user_id: user.id },
      },
      metadata: { user_id: user.id, plan },
      allow_promotion_codes: true,
    })

    return NextResponse.json({ url: session.url })
  } catch (error: unknown) {
    const message = error instanceof Error ? error.message : "Erreur interne"
    return NextResponse.json({ error: message }, { status: 500 })
  }
}
