import { NextResponse, type NextRequest } from "next/server";
import { updateSession } from "@/lib/supabase/middleware";

// Routes nécessitant une auth
const PROTECTED_ROUTES = [
  "/dashboard",
  "/profil",
  "/parametres",
  "/progression",
  "/historique",
  "/favoris",
  "/abonnement",
  "/notifications",
  "/pa",
  "/gpx",
  "/quiz",
];

// Routes nécessitant un abonnement premium
const PREMIUM_ROUTES = ["/gpx/cas-pratiques", "/gpx/cours", "/pa/cours"];

// Routes publiques (pas de redirect si connecté)
const AUTH_ROUTES = ["/login", "/signup", "/forgot-password", "/reset-password"];

export async function middleware(request: NextRequest) {
  const { supabaseResponse, user } = await updateSession(request);
  const { pathname } = request.nextUrl;

  // Redirect vers /dashboard si déjà connecté et sur page auth
  if (user && AUTH_ROUTES.some((r) => pathname.startsWith(r))) {
    return NextResponse.redirect(new URL("/dashboard", request.url));
  }

  // Redirect vers /login si route protégée et non connecté
  if (
    !user &&
    PROTECTED_ROUTES.some((r) => pathname.startsWith(r))
  ) {
    const redirectUrl = new URL("/login", request.url);
    redirectUrl.searchParams.set("redirect", pathname);
    return NextResponse.redirect(redirectUrl);
  }

  // Vérification premium (gérée côté page/layout pour performance)
  // Le middleware ne bloque pas ici — la page vérifie le tier via Supabase

  return supabaseResponse;
}

export const config = {
  matcher: [
    "/((?!_next/static|_next/image|favicon.ico|.*\\.(?:svg|png|jpg|jpeg|gif|webp)$).*)",
  ],
};
