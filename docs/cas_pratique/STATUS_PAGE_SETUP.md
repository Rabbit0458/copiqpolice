# COP'IQ — Status page & uptime monitoring

Réf : `docs/cas_pratique/PROGRESSION_CODE.md` — CODE-083

**Objectif** : page publique `status.copiq.fr` qui ping tous les endpoints critiques toutes les 60 secondes, garde 90 jours d'historique, et envoie des alertes Slack/Discord en cas d'incident.

---

## 1. Stack recommandée

### Option A — Uptime Kuma (self-hosted, gratuit) ⭐ Recommandé

| Critère | Uptime Kuma |
|---|---|
| Prix | 0 € (self-hosted) |
| Setup | 5 min en Docker |
| Status page publique | ✅ |
| Historique | ✅ 90j+ configurable |
| Webhooks | ✅ Slack, Discord, Telegram, Email, custom |
| API | ✅ Push monitors |
| Multi-monitor types | HTTP, TCP, Ping, DNS, gRPC, Steam |

→ **Choix par défaut** : excellent rapport qualité/prix, zéro coût récurrent.

### Option B — statuspage.io (Atlassian, SaaS)

→ Plus pro, mais 79 $/mois minimum. Réserver pour quand on aura 10 000+ utilisateurs et besoin d'un branding premium.

### Option C — BetterStack (ex-Better Uptime)

→ Hybride solide, free tier 10 monitors, $29/mois pour 50 monitors + status page. Bon compromis quand on ne veut pas auto-héberger.

---

## 2. Endpoints à monitorer

| Endpoint | Type | Fréquence | Seuil alerte |
|---|---|---|---|
| `https://copiq.fr` | HTTP 200 | 60s | down > 2 min |
| `https://app.copiq.fr` | HTTP 200 | 60s | down > 2 min |
| `https://<project>.supabase.co/auth/v1/health` | HTTP 200 | 60s | down > 1 min |
| `https://<project>.supabase.co/rest/v1/cas_pratique_themes?select=id&limit=1` | HTTP 200 + JSON valid | 120s | down > 3 min |
| `https://<project>.supabase.co/functions/v1/cas_pratique_correct_attempt` | HTTP 405 (HEAD) | 120s | down > 5 min |
| `https://<project>.supabase.co/functions/v1/cas_pratique_export_user_data` | HTTP 405 | 300s | down > 10 min |
| `https://<project>.supabase.co/storage/v1/object/public/<bucket>/health.png` | HTTP 200 | 300s | down > 5 min |
| `https://cdn.copiq.fr/heartbeat` | HTTP 200 | 60s | down > 2 min |
| `https://api.posthog.com/decide/?v=3` | HTTP 200 | 300s | down > 10 min |
| `https://sentry.io/api/0/` | HTTP 401 (auth expected) | 300s | down > 15 min |

> Pour les `HEAD 405` : Uptime Kuma supporte les requêtes HEAD. On accepte 405 comme "le service répond mais refuse HEAD" → service vivant.

---

## 3. Setup Uptime Kuma — docker-compose

Fichier : `infra/uptime-kuma/docker-compose.yml`

```yaml
version: "3.8"

services:
  uptime-kuma:
    image: louislam/uptime-kuma:1
    container_name: copiq-uptime-kuma
    restart: unless-stopped
    ports:
      - "3001:3001"
    volumes:
      - uptime-kuma-data:/app/data
    environment:
      - UPTIME_KUMA_DISABLE_FRAME_SAMEORIGIN=false
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3001"]
      interval: 30s
      timeout: 10s
      retries: 3

volumes:
  uptime-kuma-data:
    driver: local
```

### Reverse proxy Nginx (status.copiq.fr → :3001)

```nginx
server {
  listen 443 ssl http2;
  server_name status.copiq.fr;

  ssl_certificate     /etc/letsencrypt/live/status.copiq.fr/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/status.copiq.fr/privkey.pem;

  location / {
    proxy_pass http://127.0.0.1:3001;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "Upgrade";
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_read_timeout 86400;
  }
}

server {
  listen 80;
  server_name status.copiq.fr;
  return 301 https://$host$request_uri;
}
```

### Démarrage

```bash
cd infra/uptime-kuma
docker compose up -d
# Premier login : http://localhost:3001 → créer admin
```

---

## 4. Création de la status page publique

1. Login Uptime Kuma → **Status Pages** → **New Status Page**
2. Slug : `copiq`
3. Titre : `COP'IQ — Statut des services`
4. Description : `État en temps réel des services COP'IQ (app mobile, backend, paiements)`
5. Logo : `/uploads/logo.png` (le logo COP'IQ)
6. Domaine : `status.copiq.fr`
7. **Groups** :
   - 🟢 **Application** : copiq.fr, app.copiq.fr, cdn.copiq.fr
   - 🟢 **Backend Supabase** : auth, REST, edge functions, storage
   - 🟢 **Services tiers** : PostHog, Sentry, Stripe (CODE-085)
8. Activer "Show tags" + "Show certificate expiry"
9. Theme : `dark` (cohérent avec le branding bleu nuit)
10. Custom CSS (optionnel) :

```css
:root {
  --primary: #1147D9;
  --dark: #000B36;
  --accent: #FFC700;
}
.heartbeat-status-up { background: #22C55E; }
.heartbeat-status-down { background: #EF4444; }
.heartbeat-status-pending { background: var(--accent); }
```

---

## 5. Webhooks d'alerte

### Slack (#alerts-prod)

1. Slack → Apps → Incoming Webhooks → New Webhook
2. Canal : `#alerts-prod`
3. Copier l'URL : `https://hooks.slack.com/services/T0XXX/B0YYY/zzzzz`
4. Uptime Kuma → Settings → Notifications → New
   - Type : Slack
   - Webhook URL : `<copier-coller>`
   - Channel : `#alerts-prod`
   - Priority : critical pour P0, warning pour P1

### Discord (canal #status)

1. Discord → Server Settings → Integrations → Webhooks → New
2. Canal : `#status`
3. Copier l'URL
4. Uptime Kuma → Settings → Notifications → New
   - Type : Discord
   - Webhook URL : `<copier-coller>`
   - Username : `COP'IQ Bot`
   - Avatar : logo

### Email (DPD pour incidents critiques RGPD)

- Type : SMTP
- Host : `smtp.gmail.com` (ou Mailgun)
- To : `incidents@copiq.fr`

### Règles d'escalade

| Sévérité | Canal | Condition |
|---|---|---|
| P0 (down complet auth/db) | Slack + Discord + Email + SMS Twilio | down > 1 min |
| P1 (1 service down) | Slack + Discord | down > 2 min |
| P2 (perf dégradée) | Slack uniquement | latence > 2s pendant 5 min |

---

## 6. Health check endpoint custom (Supabase)

Edge function `cas_pratique_health` à créer :

```typescript
// supabase/functions/cas_pratique_health/index.ts
import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.0";

serve(async () => {
  const start = Date.now();
  const sb = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );

  // Test simple : compter les thèmes (fast index lookup)
  const { count, error } = await sb
    .from("cas_pratique_themes")
    .select("*", { count: "exact", head: true });

  const latency = Date.now() - start;
  const healthy = !error && (count ?? 0) >= 0;

  return new Response(
    JSON.stringify({
      status: healthy ? "ok" : "degraded",
      latency_ms: latency,
      themes_count: count ?? 0,
      checked_at: new Date().toISOString(),
    }),
    {
      status: healthy ? 200 : 503,
      headers: { "Content-Type": "application/json" },
    },
  );
});
```

Uptime Kuma monitor :
- URL : `https://<project>.supabase.co/functions/v1/cas_pratique_health`
- Headers : `Authorization: Bearer <ANON_KEY>`
- Expected : HTTP 200 + JSON contient `"status":"ok"`
- Frequency : 60s

---

## 7. Page status dans l'app mobile

Le status d'Uptime Kuma a une API JSON publique :

```
GET https://status.copiq.fr/api/status-page/copiq
```

→ Brancher dans `lib/features/settings/cp_status_widget.dart` (à créer plus tard) pour afficher un badge `🟢 All systems operational` dans Settings.

---

## 8. Historique & rapports

- Uptime Kuma garde **365 jours** d'historique par défaut (configurable)
- Export CSV via API : `GET /api/maintenance/list`
- Calcul SLA mensuel auto sur la status page
- **Cible interne** : 99.5% uptime backend (= 3h36 d'indispo/mois max)
- **Cible publique** : 99.9% (= 43 min d'indispo/mois)

---

## 9. Checklist de mise en prod

- [ ] VPS / VM provisionné (1 vCPU, 1 GB RAM suffit)
- [ ] DNS `status.copiq.fr` pointe vers le serveur
- [ ] Let's Encrypt configuré (certbot)
- [ ] Nginx en place
- [ ] `docker compose up -d` réussi
- [ ] Admin Uptime Kuma créé
- [ ] 10 monitors configurés
- [ ] Status page publique créée et accessible
- [ ] Webhooks Slack + Discord testés (faux down volontaire pour valider)
- [ ] Email d'alerte testé
- [ ] Badge status branché dans l'app (plus tard)
- [ ] Process incident documenté (qui répond, en combien de temps, comment communiquer)

---

## 10. Process en cas d'incident (runbook)

1. **Détection** : alerte Slack reçue
2. **Triage** (5 min) : P0 / P1 / P2
3. **Communication** : publier l'incident sur la status page (Uptime Kuma → Incidents → New)
4. **Investigation** : Sentry + logs Supabase
5. **Mitigation** : feature flag CODE-076 si possible (rollback rapide)
6. **Résolution** : fix code + déploiement
7. **Post-mortem** (sous 48h) : doc dans `docs/cas_pratique/incidents/YYYY-MM-DD.md`

Template post-mortem :

```markdown
# Incident YYYY-MM-DD — <résumé>

**Durée** : XXmin
**Impact** : XX% des utilisateurs affectés
**Sévérité** : P0 / P1 / P2

## Timeline
- HH:MM : alerte Slack
- HH:MM : début investigation
- HH:MM : cause identifiée
- HH:MM : mitigation déployée
- HH:MM : tout vert

## Cause racine
...

## Actions correctives
- [ ] ...
- [ ] ...
```
