# COP'IQ — Cookies & Consent Banner Spec (Web — Next.js futur)

> **Statut** : Placeholder spec — implémentation prévue lors du développement du site web Next.js.
> **Référence tâche** : CODE-080 — Phase O Compliance & accessibilité
> **Dernière mise à jour** : 2026-06-05

---

## 1. Contexte légal

La RGPD (Règlement Général sur la Protection des Données, UE 2016/679) et la directive ePrivacy imposent :
- Obtenir le **consentement préalable** avant tout dépôt de cookie non-strictement-nécessaire.
- Permettre à l'utilisateur de **refuser** aussi facilement qu'il accepte.
- Journaliser les consentements (preuve).
- Permettre le **retrait du consentement** à tout moment.

---

## 2. Catégories de cookies

| Catégorie | Exemples | Consentement requis |
|---|---|---|
| **Strict / fonctionnel** | Session auth, CSRF token, panier, préférences langue | ❌ Non (nécessaire au service) |
| **Analytics** | PostHog, Plausible, Mixpanel | ✅ Oui |
| **Marketing** | Meta Pixel, Google Ads, TikTok Pixel | ✅ Oui |

---

## 3. Banner UI — comportement

### 3.1 Affichage initial
- Apparaît sur la **première visite** (aucun cookie `copiq_consent` présent).
- Position : **bottom-center** (desktop) / **bottom fullwidth** (mobile).
- Z-index : 9999 (au-dessus de tout).
- Ne bloque pas le scroll ni le contenu (pas de modal plein écran).

### 3.2 Options proposées
1. **Tout accepter** — accepte toutes les catégories.
2. **Tout refuser** — n'accepte que les cookies stricts.
3. **Personnaliser** — ouvre un panel avec des toggles par catégorie.

### 3.3 Panel "Personnaliser"
- Drawer ou modal latéral.
- Un toggle par catégorie (Analytics / Marketing).
- Toggle "Strict" toujours ON et grisé (non désactivable).
- Bouton "Enregistrer mes préférences".

### 3.4 Comportement post-consentement
- Le cookie `copiq_consent` est écrit avec :
  - `version` : version du banner (semver, ex. `1.0.0`)
  - `timestamp` : ISO 8601
  - `categories` : `{ strict: true, analytics: boolean, marketing: boolean }`
- Expiration : **13 mois** (CNIL).
- Si l'utilisateur refuse les analytics → **ne pas charger** le SDK PostHog/Mixpanel.
- Si l'utilisateur refuse le marketing → **ne pas charger** les pixels publicitaires.

### 3.5 Retrait du consentement
- Lien "Gérer mes préférences" dans le footer (visible sur chaque page).
- Clique → rouvre le Panel "Personnaliser" pré-rempli avec les préférences actuelles.

---

## 4. Architecture React / Next.js

```typescript
// Composants
components/
  consent/
    ConsentBanner.tsx       // Banner bottom
    ConsentPanel.tsx        // Drawer/modal personnalisation
    ConsentProvider.tsx     // Context React + hook useConsent()
    consentStorage.ts       // lecture/écriture cookie copiq_consent
    consentTypes.ts         // types ConsentCategories, ConsentRecord

// Hook public
const { consent, acceptAll, rejectAll, updateConsent } = useConsent();

// Types
interface ConsentCategories {
  strict: true;         // toujours true
  analytics: boolean;
  marketing: boolean;
}

interface ConsentRecord {
  version: string;
  timestamp: string;    // ISO 8601
  categories: ConsentCategories;
}
```

### 4.1 ConsentProvider
- Wraps `_app.tsx` (ou `layout.tsx` dans App Router).
- Au mount : lit `copiq_consent` depuis les cookies.
- Si consent présent + non expiré : charge les scripts correspondants.
- Si absent : affiche le `ConsentBanner`.
- Expose `useConsent()` context.

### 4.2 Chargement conditionnel des scripts
```typescript
// Dans ConsentProvider, après résolution du consent
if (consent.categories.analytics) {
  loadPostHog(POSTHOG_API_KEY);
}
if (consent.categories.marketing) {
  loadMetaPixel(META_PIXEL_ID);
}
```

Utiliser `next/script` avec `strategy="lazyOnload"` pour éviter tout chargement avant consent.

### 4.3 Logging du consentement (RGPD Art. 7)
```typescript
// POST /api/consent-log (optionnel, server-side)
// Body: { userId?: string, record: ConsentRecord, ip_hash: string }
// Stockage : table Supabase consent_logs (user_id nullable, record JSONB, ip_hash TEXT, created_at TIMESTAMPTZ)
```
Le logging côté serveur est recommandé pour disposer d'une preuve de consentement.

---

## 5. Design (cohérent avec COP'IQ brand)

| Propriété | Valeur |
|---|---|
| Fond banner | `#000B36` (dark) / `#F5F7FF` (light) |
| Texte | Montserrat 14px regular |
| Bouton "Tout accepter" | Background `#1147D9`, texte blanc |
| Bouton "Tout refuser" | Outlined `#1147D9` |
| Bouton "Personnaliser" | Texte link, underlined |
| Radius | 12px (desktop), 0px en bas (mobile fullwidth) |
| Animation | Slide-up 200ms ease-out |

---

## 6. Accessibilité (WCAG AA)

- Role `dialog` + `aria-modal="true"` sur le panel personnalisation.
- `aria-label="Bandeau de consentement"` sur le banner.
- Focus trap dans le panel (Tab/Shift+Tab circule dans le panel).
- Boutons avec labels explicites (pas juste une icône).
- Contraste ≥ 4.5:1 sur tous les textes.
- ESC ferme le panel (retour au banner, pas de consentement implicite).

---

## 7. Tests requis

- [ ] Première visite → banner visible.
- [ ] Clic "Tout accepter" → PostHog chargé, cookie écrit.
- [ ] Clic "Tout refuser" → PostHog non chargé, cookie écrit.
- [ ] Deuxième visite → banner absent (cookie présent).
- [ ] Après 13 mois → banner réapparaît.
- [ ] Retrait → "Gérer mes préférences" → panel pré-rempli → sauvegarde.
- [ ] Scripts marketing non chargés si marketing=false.
- [ ] Versioning : si `version` du cookie < version courante → réafficher le banner.

---

## 8. TODO production

- [ ] Implémenter `ConsentBanner.tsx` + `ConsentPanel.tsx`
- [ ] Intégrer `ConsentProvider` dans `layout.tsx`
- [ ] Créer table Supabase `consent_logs`
- [ ] API route `/api/consent-log`
- [ ] Tests E2E Cypress/Playwright
- [ ] Audit CNIL : vérifier que les scripts tiers ne se chargent PAS avant consent (DevTools → Network)
- [ ] Mentionner les cookies dans la politique de confidentialité (`/privacy`)
