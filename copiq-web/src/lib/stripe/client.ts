import Stripe from "stripe"

let stripeInstance: Stripe | null = null

export function getStripe(): Stripe {
  if (!stripeInstance) {
    stripeInstance = new Stripe(process.env.STRIPE_SECRET_KEY!, {
      // Use the API version pinned by the installed SDK and its types.
      typescript: true,
    })
  }
  return stripeInstance
}
