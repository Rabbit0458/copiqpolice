"use client";

import { createClient } from "@/lib/supabase/client";
import type {
  InformationContent,
  InformationContentType,
} from "@/lib/admin/api";

export async function listPublishedInformation(type: InformationContentType) {
  // La table vient d'une migration plus récente que le fichier de types généré.
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const supabase = createClient() as any;
  const { data, error } = await supabase
    .from("information_contents")
    .select("*")
    .eq("content_type", type)
    .order("sort_order", { ascending: true })
    .order("published_at", { ascending: false });
  if (error) throw error;
  return (data ?? []) as InformationContent[];
}

export async function submitSupportRequest(input: {
  name: string;
  email: string;
  category: string;
  subject: string;
  message: string;
  website?: string;
}) {
  // La RPC vient d'une migration plus récente que le fichier de types généré.
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const supabase = createClient() as any;
  const { data, error } = await supabase.rpc("submit_support_request", {
    p_name: input.name,
    p_email: input.email,
    p_category: input.category,
    p_subject: input.subject,
    p_message: input.message,
    p_website: input.website ?? "",
  });
  if (error) throw error;
  return data as string;
}
