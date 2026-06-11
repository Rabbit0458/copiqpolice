# Open Graph / Twitter Cards — Spec (CODE-072)

> Module : Cas Pratique — Phase M (Partage & viralité)  
> Périmètre : Site web futur **app.copiq.fr** (Next.js / TypeScript)  
> Dépendance : Site web non encore créé → spec documentée ici pour transfer.

---

## 1. Objectif

Quand un utilisateur partage le lien `https://app.copiq.fr/c/<slug>`, les plateformes
(WhatsApp, Telegram, Twitter/X, LinkedIn, iMessage, Discord…) affichent une **link card riche** :

- Image preview : mise en situation tronquée + badge thème + logo COP'IQ
- Titre : nom du cas (ex. "Agression en centre commercial")
- Description : 2 premières phrases de la mise en situation
- Badge difficulté + année (visible dans l'image OG)

---

## 2. Balises meta requises (page `/c/[slug]`)

```html
<!-- Open Graph -->
<meta property="og:type"        content="article" />
<meta property="og:url"         content="https://app.copiq.fr/c/{{slug}}" />
<meta property="og:title"       content="{{cas.title}} — COP'IQ" />
<meta property="og:description" content="{{cas.mise_en_situation | truncate(160)}}" />
<meta property="og:image"       content="https://app.copiq.fr/og/c/{{slug}}.png" />
<meta property="og:image:width" content="1200" />
<meta property="og:image:height" content="630" />
<meta property="og:site_name"   content="COP'IQ — Concours Gardien de la Paix" />
<meta property="og:locale"      content="fr_FR" />

<!-- Twitter Cards -->
<meta name="twitter:card"        content="summary_large_image" />
<meta name="twitter:site"        content="@copiqpolice" />
<meta name="twitter:title"       content="{{cas.title}} — COP'IQ" />
<meta name="twitter:description" content="{{cas.mise_en_situation | truncate(160)}}" />
<meta name="twitter:image"       content="https://app.copiq.fr/og/c/{{slug}}.png" />

<!-- Canonical + Article -->
<link rel="canonical" href="https://app.copiq.fr/c/{{slug}}" />
<meta property="article:published_time" content="{{cas.created_at}}" />
<meta property="article:section"        content="{{cas.theme.label}}" />
```

---

## 3. Image OG dynamique (`/og/c/[slug].png`)

### Dimensions
- **1200 × 630 px** (ratio 1.91:1) — standard OG
- Rendue côté serveur via **`@vercel/og`** (Edge Runtime) ou **`satori`**

### Layout de l'image OG

```
┌─────────────────────────────────────────────┐  1200px
│  [Logo COP'IQ]   COP'IQ — Cas Pratique      │  haut 80px, bg #000B36
├─────────────────────────────────────────────┤
│                                             │
│  [Badge Thème]  [Badge Année]  [Badge Diff] │  chips 36px
│                                             │
│  Nom du cas (2 lignes max, bold 32px)       │
│                                             │
│  Mise en situation (3 lignes max,           │
│  couleur #B0B8D1, 18px)                     │
│                                             │
│  … Découvrir ce cas →                       │
├─────────────────────────────────────────────┤
│  app.copiq.fr   Montserrat · Police Badge   │  footer 40px
└─────────────────────────────────────────────┘
Background : gradient #000B36 → #1147D9 (angle 135°)
```

### Implémentation Next.js (Edge Route)

```typescript
// app/og/c/[slug]/route.tsx  (Next.js App Router)
import { ImageResponse } from 'next/og';
import { createClient } from '@supabase/supabase-js';

export const runtime = 'edge';

export async function GET(
  _req: Request,
  { params }: { params: { slug: string } },
) {
  const supabase = createClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.SUPABASE_SERVICE_ROLE_KEY!,
  );

  const { data: cas } = await supabase
    .from('cases')
    .select('title, mise_en_situation, theme:themes(label), difficulty, year')
    .eq('slug', params.slug)
    .single();

  if (!cas) {
    return new Response('Not found', { status: 404 });
  }

  const mise = (cas.mise_en_situation as string).slice(0, 200) + '…';
  const diffLabel =
    cas.difficulty === 1 ? 'Facile' :
    cas.difficulty === 2 ? 'Intermédiaire' : 'Difficile';

  return new ImageResponse(
    (
      <div
        style={{
          display: 'flex',
          flexDirection: 'column',
          width: '1200px',
          height: '630px',
          background: 'linear-gradient(135deg, #000B36 0%, #1147D9 100%)',
          fontFamily: 'Montserrat',
          color: '#FFFFFF',
          padding: '40px',
        }}
      >
        {/* Header */}
        <div style={{ display: 'flex', alignItems: 'center', marginBottom: 24 }}>
          <span style={{ fontSize: 20, fontWeight: 700, letterSpacing: 2 }}>
            COP'IQ
          </span>
          <span style={{ marginLeft: 12, fontSize: 16, color: '#B0B8D1' }}>
            Cas Pratique
          </span>
        </div>

        {/* Chips */}
        <div style={{ display: 'flex', gap: 10, marginBottom: 20 }}>
          <Chip label={(cas.theme as { label: string }).label} color="#1147D9" />
          <Chip label={String(cas.year ?? '')} color="#374151" />
          <Chip label={diffLabel} color="#B45309" />
        </div>

        {/* Titre */}
        <div style={{ fontSize: 36, fontWeight: 800, lineHeight: 1.2, marginBottom: 16 }}>
          {cas.title}
        </div>

        {/* Extrait */}
        <div style={{ fontSize: 18, color: '#B0B8D1', lineHeight: 1.5, flex: 1 }}>
          {mise}
        </div>

        {/* Footer */}
        <div style={{ fontSize: 14, color: '#6B7280', marginTop: 24 }}>
          app.copiq.fr
        </div>
      </div>
    ),
    { width: 1200, height: 630 },
  );
}

function Chip({ label, color }: { label: string; color: string }) {
  return (
    <div
      style={{
        background: color,
        borderRadius: 6,
        padding: '4px 12px',
        fontSize: 14,
        fontWeight: 600,
      }}
    >
      {label}
    </div>
  );
}
```

---

## 4. Page de fallback web (`/c/[slug]`)

Quand l'app n'est pas installée, le lien deep link doit atterrir sur une page web qui :
1. Affiche le titre + résumé du cas (SEO + partage)
2. Propose un bouton **"Ouvrir dans COP'IQ"** → `copiqpolice://cas/<slug>`
3. Propose un bouton **"Télécharger COP'IQ"** → App Store / Play Store
4. Contient les balises OG ci-dessus (server-side rendered)

```typescript
// app/c/[slug]/page.tsx
import { Metadata } from 'next';

export async function generateMetadata(
  { params }: { params: { slug: string } },
): Promise<Metadata> {
  const cas = await fetchCase(params.slug);
  return {
    title: `${cas.title} — COP'IQ`,
    description: cas.mise_en_situation.slice(0, 160),
    openGraph: {
      title: `${cas.title} — COP'IQ`,
      description: cas.mise_en_situation.slice(0, 160),
      images: [`/og/c/${params.slug}`],
      type: 'article',
    },
    twitter: {
      card: 'summary_large_image',
      images: [`/og/c/${params.slug}`],
    },
  };
}
```

---

## 5. Cache OG images

Les images OG sont statiques par cas. Mettre en cache avec headers :
```
Cache-Control: public, s-maxage=86400, stale-while-revalidate=3600
```

Pour forcer la régénération après modification d'un cas :
- Webhook Supabase Database → `DELETE /api/revalidate?slug=<slug>&token=<secret>`
- Next.js `revalidatePath('/c/[slug]')` + `revalidatePath('/og/c/[slug]')`

---

## 6. Debug OG

- **Facebook Debugger** : https://developers.facebook.com/tools/debug/
- **Twitter Card Validator** : https://cards-dev.twitter.com/validator
- **LinkedIn Inspector** : https://www.linkedin.com/post-inspector/
- **Open Graph Preview** : https://www.opengraph.xyz/url/https%3A%2F%2Fapp.copiq.fr%2Fc%2Fcase_1

---

## 7. Intégration Flutter (CODE-072 → CODE-071 lien)

Dans le bouton de partage Flutter (page correction), utiliser :
```dart
final url = CpDeepLinksHandler.I.shareUrl(
  caseSlug,
  utmSource: 'share',
  utmMedium: 'app',
  utmCampaign: 'correction_result',
);
// Ce lien aura un OG card riche sur WhatsApp, Telegram, etc.
await Share.share(url, subject: 'Cas pratique COP\'IQ');
```
