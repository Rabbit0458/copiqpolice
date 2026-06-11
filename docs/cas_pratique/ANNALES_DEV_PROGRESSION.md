# 📚 COP'IQ — Page ANNALES — Roadmap de développement A→Z

> **Statut actuel** : placeholder créé (`lib/features/home/annales_page.dart`), routé dans la bottom bar GPX Exam (tab 1, icône `menu_book_rounded`). La page affiche "Cette page doit être codée plus tard". Tout reste à faire.

> **Objectif final** : module Annales complet où l'utilisateur peut **consulter, télécharger et étudier hors-ligne** les PDF des sujets et corrigés officiels des concours passés (cas pratiques, culture générale, QCM, oral, etc.). Stockés sur Supabase Storage, indexés en base, téléchargés progressivement avec cache local.

---

## 🎯 Vision produit

L'utilisateur doit pouvoir :
- 📥 Télécharger n'importe quelle annale en 1 tap (PDF cached localement)
- 📖 La lire dans une visionneuse intégrée (sans quitter l'app)
- 🔍 Chercher par année, concours, épreuve, mot-clé
- 🏷️ Filtrer (Cas pratique / QCM / Oral / Synthèse / etc.)
- 📊 Voir laquelle est la plus téléchargée (signal social)
- ⭐ Marquer comme favori
- 📤 Partager le lien (deep link CODE-071)
- 🔁 Resynchroniser hors-ligne sa bibliothèque
- 🆕 Recevoir une notification quand une nouvelle annale est publiée

Côté admin :
- Upload de PDF via panel admin (Phase R)
- Indexation auto des métadonnées
- Stats de téléchargement par annale

---

## 📋 Plan A→Z (30 tâches sur 10 phases)

### 🟦 Phase A — Spec & design (3 tâches)

#### A1. Spec produit détaillée
- Lister tous les types d'annales (cas pratique, culture G, QCM, synthèse, oral, langues, sport)
- Définir les concours couverts (GPX nationale, GPX régionale, officier, gendarmerie)
- Plage d'années à couvrir (2015 → en cours, ~10 ans = ~50 annales potentielles)
- Format des PDFs : noms standardisés `annale_{concours}_{annee}_{epreuve}.pdf`
- **Output** : `docs/cas_pratique/ANNALES_SPEC.md`

#### A2. Design système (Figma)
- Page liste : header + filtres pills + cards d'annales (cover + métadonnées + badge `Téléchargé` / `Nouveau`)
- Page détail : preview PDF, score moyen, téléchargements, bouton télécharger / lire
- Visionneuse PDF : header minimal, zoom, scroll, partage, marque-page
- Modal upload (admin) : drag-drop PDF + formulaire
- **Output** : maquettes Figma + tokens couleur (réutilisation `CpTokens`)

#### A3. Estimation effort
- Découpage en stories, estimation en story points
- Tracking dans `PROGRESSION_CODE.md` ou tableau Linear/Notion

---

### 🟩 Phase B — Database & Storage (5 tâches)

#### B1. Migration SQL — table `cp_annales`
```sql
create table public.cp_annales (
  id              uuid primary key default uuid_generate_v4(),
  slug            text unique not null,           -- ex: 'gpx-2024-cas-pratique'
  concours        text not null,                  -- 'gpx_nationale' | 'gpx_regionale' | 'officier' | ...
  annee           integer not null,
  epreuve         text not null,                  -- 'cas_pratique' | 'culture_g' | 'qcm' | 'synthese' | 'oral'
  titre           text not null,                  -- 'Cas pratique GPX 2024 — Session 1'
  description     text,
  pdf_path        text not null,                  -- chemin Storage : 'annales/2024/gpx-2024-cas-pratique.pdf'
  pdf_size_bytes  bigint,
  page_count      integer,
  has_corrige     boolean not null default false,
  pdf_corrige_path text,                          -- corrigé séparé si dispo
  thumbnail_path  text,                           -- preview JPG/WebP 1ʳᵉ page
  tags            text[] default array[]::text[], -- ['droit_penal', 'organisation_police', ...]
  difficulty      smallint check (difficulty between 1 and 5),
  is_premium      boolean not null default false, -- accès libre vs paywall (CODE-084)
  published_at    timestamptz not null default now(),
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);

create index idx_cp_annales_year_concours on public.cp_annales(annee desc, concours);
create index idx_cp_annales_epreuve on public.cp_annales(epreuve);
create index idx_cp_annales_tags on public.cp_annales using gin(tags);
```

#### B2. Table `cp_annales_downloads` (stats anonymisées)
```sql
create table public.cp_annales_downloads (
  id              bigserial primary key,
  annale_id       uuid not null references public.cp_annales(id) on delete cascade,
  user_id         uuid references auth.users(id) on delete set null,
  downloaded_at   timestamptz not null default now(),
  source          text                            -- 'list' | 'detail' | 'shared_link' | 'admin'
);

create index idx_cp_annales_downloads_annale on public.cp_annales_downloads(annale_id, downloaded_at desc);
```

#### B3. Table `cp_user_annales` (favoris + suivi local)
```sql
create table public.cp_user_annales (
  user_id         uuid not null references auth.users(id) on delete cascade,
  annale_id       uuid not null references public.cp_annales(id) on delete cascade,
  is_favorite     boolean not null default false,
  last_opened_at  timestamptz,
  notes           text,
  primary key (user_id, annale_id)
);
```

#### B4. Bucket Storage Supabase
- Créer bucket `annales` (public read pour les non-premium, signed URL pour les premium)
- Structure : `annales/{annee}/{slug}.pdf` + `annales/{annee}/{slug}-thumb.webp` + `annales/{annee}/{slug}-corrige.pdf`
- Policy upload : service_role uniquement (admin)
- Policy download : authenticated avec check `is_premium` + abonnement actif

#### B5. RLS policies
```sql
alter table public.cp_annales enable row level security;

-- Lecture publique du catalogue (métadonnées seulement)
create policy "Public can read annales metadata"
on public.cp_annales for select to anon, authenticated using (true);

-- Lecture des téléchargements : que les siens
create policy "Users read own downloads"
on public.cp_annales_downloads for select to authenticated
using (user_id = auth.uid());

-- Lecture/écriture des favoris : que les siens
create policy "Users manage own favorites"
on public.cp_user_annales for all to authenticated
using (user_id = auth.uid()) with check (user_id = auth.uid());
```

---

### 🟨 Phase C — Modèles & Repository Dart (4 tâches)

#### C1. Modèles immuables
- `lib/data/annales/models/annale_model.dart`
- `lib/data/annales/models/annale_download_model.dart`
- `lib/data/annales/models/user_annale_model.dart`
- Champs typés, `fromJson` / `toJson`, `copyWith`, `==` & `hashCode`, `@immutable`

#### C2. Repository abstrait
```dart
abstract class AnnalesRepository {
  Future<List<Annale>> listAnnales({
    int? year,
    String? concours,
    String? epreuve,
    List<String>? tags,
    String? search,
    int? limit,
    int? offset,
  });
  Future<Annale> getBySlug(String slug);
  Future<String> getSignedDownloadUrl(String annaleId);
  Future<void> trackDownload(String annaleId, {String? source});
  Future<void> toggleFavorite(String annaleId, bool isFavorite);
  Stream<List<Annale>> watchFavorites();
}
```

#### C3. Implémentation Supabase
- `lib/data/annales/annales_repository_impl.dart`
- Utilise `Supabase.instance.client`
- Erreurs typées (`AnnalesException`)
- Logs Sentry sur échec

#### C4. Cache local (Hive ou shared_preferences)
- Liste des annales en cache 24h
- État de téléchargement par PDF (`downloading` / `done` / `failed`)
- Chemins locaux des PDFs téléchargés

---

### 🟧 Phase D — UI page Annales (5 tâches)

#### D1. Liste principale
- `lib/features/home/annales_page.dart` (refonte du placeholder)
- Header avec titre + recherche inline (debounce 300ms)
- Filtres pill horizontaux : Année / Concours / Épreuve / Premium-only
- Grid 2 colonnes ou liste 1 colonne selon densité d'écran
- Pull-to-refresh
- Skeleton screen pendant le chargement

#### D2. Card d'annale
- `lib/features/annales/widgets/annale_card.dart`
- Cover : thumbnail de la 1ʳᵉ page du PDF (via Supabase Storage)
- Badge `Nouveau` (< 30j), `Téléchargé` (cache local), `Premium`
- Tags (3 max visibles)
- Action principale : tap → page détail
- Action secondaire : icône cœur (favori)

#### D3. Page détail
- `lib/features/annales/annale_detail_page.dart`
- Hero animation depuis la card
- Métadonnées (concours, épreuve, année, difficulté, nb pages, taille)
- Description + tags
- Stats (nombre de téléchargements, taux moyen de réussite si lié à un cas pratique)
- Boutons : **Télécharger** / **Ouvrir** (si déjà téléchargé) / **Voir le corrigé**
- Lien deep partage (CODE-071)

#### D4. État vide + erreurs
- Empty state : "Aucune annale trouvée avec ces filtres"
- Empty state initial : "Bientôt : nos premières annales arrivent"
- Error state : retry + lien support

#### D5. Filtres bottom sheet
- Bottom sheet pour filtres avancés (multi-tags, plage d'années, tri)
- Persistance des filtres (shared_preferences)

---

### 🟪 Phase E — Téléchargement PDF (4 tâches)

#### E1. Service de téléchargement
- `lib/core/services/annales_download_service.dart`
- Utilise `http` + `path_provider` pour stockage local
- Progress callback (0..1)
- Annulation possible
- File de téléchargement (max 3 simultanés)

#### E2. Cache local intelligent
- Dossier `getApplicationDocumentsDirectory()/annales/{slug}.pdf`
- Vérification existence avant download
- Eviction LRU : si > 500 MB de PDFs, supprime les plus anciens non-favoris
- Settings : "Vider le cache des annales" dans `parametre_home.dart`

#### E3. UI de progression
- Bouton télécharger → spinner circulaire avec % (CircularProgressIndicator value)
- Notification système Android via `flutter_local_notifications` (déjà en pubspec)
- Snackbar "Annale téléchargée" avec action "Ouvrir"

#### E4. Gestion offline
- Si pas de réseau et PDF déjà cached → ouverture directe
- Si pas de réseau et PDF non cached → message "Annale non disponible hors-ligne"
- Indicateur dans la card "📥 Disponible hors-ligne"

---

### 🟫 Phase F — Visionneuse PDF intégrée (3 tâches)

#### F1. Choix de la lib
- Évaluer : `syncfusion_flutter_pdfviewer` (gratuit jusqu'à un certain CA) vs `flutter_pdfview` (open source)
- Recommandation : `syncfusion_flutter_pdfviewer` pour la qualité du rendu et les fonctionnalités (zoom, recherche, marque-page, signets)
- Ajouter au `pubspec.yaml`

#### F2. Page visionneuse
- `lib/features/annales/annale_viewer_page.dart`
- Header minimal (transparent au scroll) avec : retour, titre, partage, marque-page
- Footer : pagination, zoom +/-, recherche
- Mode lecture immersive : tap pour cacher/montrer les barres
- Sauvegarde de la position de lecture (page courante)

#### F3. Marque-pages & annotations (V2)
- Table SQL `cp_annale_bookmarks` (annale_id, user_id, page, label, created_at)
- Sidebar avec liste des marque-pages
- (V2) Surlignage de texte → stockage des coordonnées + couleur

---

### 🟥 Phase G — Recherche & Stats (2 tâches)

#### G1. Recherche full-text
- Index PostgreSQL `tsvector` sur titre + description + tags
- Edge function `cp_search_annales` qui retourne les meilleurs résultats
- UI : barre de recherche inline avec suggestions

#### G2. Stats publiques
- Vue SQL `cp_annales_stats` : par annale, nombre de téléchargements 7j / 30j / total
- Endpoint repo : `getTopDownloaded(limit: 10)` → liste "Tendances"
- Badge `🔥 Tendance` sur la card si dans le top 10 du mois

---

### 🟨 Phase H — Admin upload (3 tâches)

#### H1. Page admin upload (Phase R du roadmap principal)
- `lib/features/admin/annales_admin_page.dart`
- Drag-drop PDF (ou file picker)
- Formulaire : concours, année, épreuve, titre, description, tags, difficulté, is_premium
- Upload progress
- Validation : taille max 50 MB, type `application/pdf` uniquement

#### H2. Génération thumbnail
- Edge function `cp_annales_generate_thumbnail` :
  - Reçoit le PDF
  - Rend la 1ʳᵉ page en WebP 600x800
  - Upload dans `annales/{annee}/{slug}-thumb.webp`

#### H3. Indexation auto
- Trigger SQL `before insert` qui :
  - Génère le slug à partir du concours + année + épreuve
  - Compte les pages PDF (via service externe ou edge fn)
  - Notifie les users abonnés (push)

---

### 🟩 Phase I — Tests & qualité (1 tâche)

#### I1. Couverture tests
- Tests unitaires : `AnnalesRepositoryImpl`, modèles
- Tests d'intégration : flow `liste → détail → télécharger → ouvrir`
- Tests E2E (Maestro) : ouvrir l'app, cliquer Annales, télécharger 1 PDF, l'ouvrir, le partager

---

### 🟪 Phase J — Release (1 tâche)

#### J1. Migration douce
- Feature flag `cp_annales_enabled` (via `CpFeatureFlags` CODE-075/076)
- Rollout 5% → 25% → 100% sur 2 semaines
- Monitoring Sentry + PostHog (events : `annale_viewed`, `annale_downloaded`, `annale_opened`, `annale_shared`)
- Rétrocompatibilité : si désactivé, la bottom bar reaffiche Journal à la place

---

## 🎯 Métriques de succès

| KPI | Cible mois 1 | Cible mois 3 |
|---|---|---|
| Téléchargements / utilisateur actif | 2 | 5 |
| Taux de retour sur Annales (D7) | 30% | 50% |
| % d'utilisateurs ayant ≥ 1 favori | 25% | 60% |
| Temps moyen passé dans la visionneuse | 8 min | 15 min |
| Taux conversion paywall via Annales premium | 3% | 8% |

---

## 🔗 Dépendances avec la roadmap principale

| Tâche Annales | Dépend de |
|---|---|
| B1-B5 (SQL) | Aucune |
| C1-C4 (Repository) | A1 (spec) |
| D1-D5 (UI) | C3 (repo impl) + Design tokens existants (`CpTokens`) |
| E1-E4 (Download) | `path_provider`, `share_plus` (déjà au pubspec) |
| F1-F3 (Viewer) | E1 (téléchargement local) + ajout `syncfusion_flutter_pdfviewer` |
| G1-G2 (Recherche/Stats) | B1 + edge functions Supabase |
| H1-H3 (Admin) | Phase R du roadmap principal (panel admin CODE-094/095/096) |
| J1 (Release) | CODE-075/076 (feature flags) |

---

## ✅ Checklist de Definition of Done

Avant de mettre la feature en production :

- [ ] Au moins 10 annales seedées (2020-2024, GPX nationale, plusieurs épreuves)
- [ ] Thumbnails générées pour 100% des annales
- [ ] Téléchargement testé en offline / poor connection
- [ ] Visionneuse PDF testée sur iOS + Android (zoom, scroll, recherche)
- [ ] Partage via deep link fonctionnel (`copiqpolice://annales/{slug}`)
- [ ] Stats remontées dans PostHog (annale_viewed/downloaded/opened/shared)
- [ ] Feature flag activé pour 5% du trafic
- [ ] Pas d'erreur Sentry critique sur 48h
- [ ] Doc admin pour upload (`docs/cas_pratique/ANNALES_ADMIN_GUIDE.md`)
- [ ] Migration de retour testée (rollback si bug majeur)

---

## 📝 Notes ouvertes

- **Format PDF protégé ?** : envisager DRM léger (watermark dynamique avec email utilisateur sur chaque page) pour les annales premium → décourager le partage public
- **OCR sur les PDFs scannés** : si annales anciennes scannées de basse qualité, prévoir un pass OCR pour activer la recherche dans le texte
- **Versionning** : si un corrigé est mis à jour, garder la trace de la version précédente
- **Internationalisation** : à partir du moment où on ajoute l'anglais (CODE-082), traduire les titres standards (Culture générale → General Knowledge, etc.)

---

*Document de roadmap — à compléter au fur et à mesure de l'avancement. Lié à `PROGRESSION_CODE.md` quand la phase Annales sera lancée officiellement.*
