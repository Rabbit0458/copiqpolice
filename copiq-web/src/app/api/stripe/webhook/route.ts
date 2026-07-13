import { NextRequest, NextResponse } from "next/server"
import { headers } from "next/headers"
import { getStripe } from "@/lib/stripe/client"
import { createServiceClient } from "@/lib/supabase/server"
import type Stripe from "stripe"

export async function POST(request: NextRequest) {
  const body = await request.text()
  const headersList = await headers()
  const signature = headersList.get("stripe-signature") ?? ""

  let event: Stripe.Event

  try {
    const stripe = getStripe()
    event = stripe.webhooks.constructEvent(body, signature, process.env.STRIPE_WEBHOOK_SECRET!)
  } catch {
    return NextResponse.json({ error: "Webhook signature invalide" }, { status: 400 })
  }

  const supabase = await createServiceClient()

  try {
    switch (event.type) {
      case "customer.subscription.created":
      case "customer.subscription.updated": {
        const sub = event.data.object as Stripe.Subscription
        const userId = sub.metadata?.user_id
        if (!userId) break

        const tier = ["active", "trialing"].includes(sub.status) ? "premium" : "free"
        const status = sub.status as string

        await (supabase as any).from("cas_pratique_subscriptions").upsert({
          user_id: userId,
          tier,
          status,
          stripe_customer_id: sub.customer as string,
          stripe_subscription_id: sub.id,
          stripe_price_id: sub.items.data[0]?.price?.id ?? null,
          stripe_product_id: sub.items.data[0]?.price?.product as string ?? null,
          current_period_start: new Date((sub as unknown as { current_period_start: number }).current_period_start * 1000).toISOString(),
          current_period_end: new Date((sub as unknown as { current_period_end: number }).current_period_end * 1000).toISOString(),
          cancel_at_period_end: sub.cancel_at_period_end,
          canceled_at: sub.canceled_at ? new Date(sub.canceled_at * 1000).toISOString() : null,
          trial_ends_at: sub.trial_end ? new Date(sub.trial_end * 1000).toISOString() : null,
          updated_at: new Date().toISOString(),
        }, { onConflict: "user_id" })
        break
      }

      case "customer.subscription.deleted": {
        const sub = event.data.object as Stripe.Subscription
        const userId = sub.metadata?.user_id
        if (!userId) break

        await (supabase as any).from("cas_pratique_subscriptions").upsert({
          user_id: userId,
          tier: "free",
          status: "canceled",
          cancel_at_period_end: false,
          updated_at: new Date().toISOString(),
        }, { onConflict: "user_id" })
        break
      }

      case "checkout.session.completed": {
        const session = event.data.object as Stripe.Checkout.Session
        const userId = session.metadata?.user_id
        if (!userId || !session.customer) break

        // S'assurer que le customer_id est bien mappé
        await (supabase as any).from("cas_pratique_subscriptions").upsert({
          user_id: userId,
          stripe_customer_id: session.customer as string,
          tier: "premium",
          status: "active",
          updated_at: new Date().toISOString(),
        }, { onConflict: "user_id" })
        break
      }
    }
  } catch (err) {
    console.error("Webhook handler error:", err)
  }

  return NextResponse.json({ received: true })
}

