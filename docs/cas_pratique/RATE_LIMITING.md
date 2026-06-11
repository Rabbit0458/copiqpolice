# 🚦 COP'IQ — Cas Pratique — Rate limiting (CODE-054)

Guide d'utilisation du token bucket Supabase pour limiter les endpoints critiques.

---

## 1. Architecture

```
   ┌─────────────────────┐
   │ Client Dart / Edge  │  ← caller (JWT user)
   └──────────┬──────────┘
              │ RPC fn_cp_consume_token(scope, ...)
              ▼
   ┌─────────────────────┐
   │  Postgres function  │  SECURITY DEFINER, lit auth.uid()
   │  fn_cp_consume_token│  algorithme token bucket atomique
   └──────────┬──────────┘
              ▼ UPDATE … FOR UPDATE (row lock)
   ┌─────────────────────┐
   │ cas_pratique_rate_  │  PK (user_id, scope) — 1 bucket par user/scope
   │     buckets         │  RLS : aucun accès direct user
   └─────────────────────┘
```

L'algorithme token bucket :
- `capacity` jetons max
- `refill_per_window / window_seconds` = jetons/sec
- À chaque appel : on calcule combien de jetons ont été reconstitués depuis `last_refill_at`, on plafonne à `capacity`, on tente de consommer 1.
- Si OK → `allowed: true, tokens_remaining`
- Sinon → `allowed: false, retry_after_seconds`

---

## 2. Profiles de rate

| Endpoint logique                         | Scope SQL              | Capacité | Refill (par fenêtre) | Fenêtre  |
|------------------------------------------|------------------------|---------:|---------------------:|---------:|
| `listCases`                              | `cp.list_cases`        |  60      | 60                   | 60 s     |
| `saveDraft` (autosave)                   | `cp.save_draft`        | 600      | 600                  | 60 s     |
| `validateAnswer`                         | `cp.validate_answer`   |  30      | 30                   | 60 s     |
| `finishAttemptAndCorrect` (edge fn)      | `cp.finish_correct`    |  10      | 10                   | 60 s     |
| `createAppeal`                           | `cp.create_appeal`     |  20      | 20                   | 86 400 s |

Toutes les valeurs sont exposées dans `supabase/functions/_shared/rate_limit.ts` via `RATE_PROFILES`.

---

## 3. Côté Edge function (Deno)

Wiring effectif dans `supabase/functions/cas_pratique_correct_attempt/index.ts` (CODE-051) :

```ts
import { consumeRateLimit, rateLimitedResponse, RATE_PROFILES }
  from "../_shared/rate_limit.ts";

const rl = await consumeRateLimit(callerClient, RATE_PROFILES.finishCorrect);
if (!rl.allowed) return rateLimitedResponse(rl);
```

Headers retournés sur 429 :
- `Retry-After: <secondes>`
- `x-ratelimit-capacity: <capacity>`

---

## 4. Côté Dart (client) — intégration recommandée

Pour les opérations qui ne passent PAS par une edge function (donc directement PostgREST), on appelle l'RPC avant chaque action gateable. Exemple type :

```dart
extension on CasPratiqueRepositoryImpl {
  Future<void> _checkRate({
    required String scope,
    required int capacity,
    required int refillPerWindow,
    required int windowSeconds,
  }) async {
    final res = await _sb.rpc(
      'fn_cp_consume_token',
      params: {
        'p_scope': scope,
        'p_capacity': capacity,
        'p_refill_per_window': refillPerWindow,
        'p_window_seconds': windowSeconds,
      },
    );
    final m = Map<String, dynamic>.from(res as Map);
    if (m['allowed'] != true) {
      final wait = (m['retry_after_seconds'] as num?)?.toInt() ?? 1;
      throw CasPratiqueException(
        code: CasPratiqueErrorCode.rateLimited,
        message: 'Trop de requêtes. Réessaie dans ${wait}s.',
      );
    }
  }
}
```

Appelé avant chaque endpoint :

```dart
@override
Future<void> saveDraftAnswer({...}) async {
  await _checkRate(
    scope: 'cp.save_draft',
    capacity: 600,
    refillPerWindow: 600,
    windowSeconds: 60,
  );
  // ... la requête originale
}
```

> ⚠️ **Note d'implémentation** : ce wiring est documenté ici mais **pas encore branché** dans `cas_pratique_repository_impl.dart`. Le brancher revient à ajouter 1 ligne `_checkRate(...)` au début de chaque méthode publique gateable. À faire dans une session dédiée pour respecter la règle « pas de breaking change non documenté ».

---

## 5. Fail-closed

En cas d'erreur lors de l'appel RPC (réseau, DB down) :
- **TS helper** : retourne `{ allowed: false, retryAfterSeconds: 1 }` → 429 → le client retry après 1 sec.
- **Dart helper** (à brancher) : throw `CasPratiqueException(rateLimited, …)` → l'UI affiche un snackbar.

Mieux vaut bloquer 1 sec qu'autoriser une boucle infinie sur un endpoint coûteux.

---

## 6. Reset / debug admin

Si un user est bloqué et qu'on veut reset son bucket (support) :

```sql
-- Reset un scope précis
DELETE FROM public.cas_pratique_rate_buckets
WHERE user_id = '<uuid>' AND scope = 'cp.finish_correct';

-- Reset tous ses buckets
DELETE FROM public.cas_pratique_rate_buckets
WHERE user_id = '<uuid>';
```

Lister les utilisateurs proches de la limite :

```sql
SELECT user_id, scope, tokens, capacity, last_refill_at
FROM public.cas_pratique_rate_buckets
WHERE tokens < (capacity * 0.1)
ORDER BY tokens ASC;
```

---

## 7. Monitoring

Le helper TS log via `console.error` en cas d'erreur RPC, ce qui est repris par Sentry (CODE-053) en breadcrumb. Ajouter une alerte Sentry sur :

```
event.tags.module == "cas_pratique"
AND event.message contains "rate_limited"
```

Si le taux 429 dépasse 1 % en 5 min → potentielle attaque ou bug client → investiguer.

---

## 8. Évolutions possibles (post-MVP)

- **Cloudflare WAF** en front pour bloquer les IPs malveillantes avant qu'elles atteignent Supabase
- **Tier-based limits** : multiplier la capacité × 5 pour les users premium (lecture `cas_pratique_subscriptions.tier`)
- **Sliding window log** au lieu de token bucket pour une politique plus stricte (mais coûteux en perf)
- **Distributed rate limit Redis** si Supabase devient le bottleneck

---

**CODE-054 livré : table + fonction SQL + helper TS + wiring edge function + doc.**
