import PsychoClient from "./psycho-client"
export function generateStaticParams() {
  return ["calcul", "suites-logiques", "raisonnement"].map(t => ({ type: t }))
}
export default function PsychotechniquesTypePage() { return <PsychoClient /> }
