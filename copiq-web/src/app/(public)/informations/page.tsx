import type { Metadata } from "next";
import { InformationHub } from "@/components/information/information-hub";
export const metadata: Metadata = {
  title: "Centre d'information — COP'IQ",
  description: "FAQ, assistance, nouveautés et informations légales COP'IQ.",
};
export default function InformationsPage() {
  return <InformationHub />;
}
