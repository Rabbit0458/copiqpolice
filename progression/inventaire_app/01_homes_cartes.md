# 01 — Les 4 Home de parcours COP'IQ : sections, système de cartes, navigation

Périmètre : app Flutter `/home/claude/app/lib` (lecture seule). Objectif : reproduire à l'identique sur le site Next.js les 4 Home de parcours
(PA Concours, GPX Concours, PA Scolarité, GPX Scolarité), leur carrousel de cartes et la hiérarchie de navigation.

Fichiers sources principaux :

| Rôle | Fichier |
|---|---|
| Aiguillage vers la bonne Home | `lib/features/home/home_bootstrap.dart` (`/home-bootstrap`) |
| Home PA Concours | `lib/features/home/home_page_pa_exam.dart` (`/home-pa-exam`, 1776 l.) |
| Home GPX Concours | `lib/features/home/home_page_gpx_exam.dart` (`/home-gpx-exam`, 2731 l.) |
| Home PA Scolarité | `lib/features/home/home_page_pa_school.dart` (`/home-pa-school`, 5045 l.) |
| Home GPX Scolarité | `lib/features/home/home_page_gpx_school.dart` (`/home-gpx-school`, 6358 l.) |
| Bloc « Continue ta préparation » (PA exam) | `lib/features/home/widgets/continue_preparation_panel.dart` |
| Modèles `CategoryConfig` / `SubCategoryConfig`, `Track`, `UserMode`, `redirectConfigHome`, `resolveHomeRoute` | `lib/features/home/home_page.dart` (l. 561-856) |
| Routeur | `lib/routes/app_router.dart` (`RouteRegistry.routes` + `appOnGenerateRoute`) + `lib/routes/pa_school_routes.dart` (`PaSchoolRouteRegistry`, généré) |
| Sélecteurs de programme scolarité | `lib/features/onboarding/gpx_school.dart` (`GpxSchoolArt`), `lib/features/onboarding/pa_school.dart` (`PaSchoolArt`) |
| Garde premium | `lib/core/services/premium_guard.dart` (`canAccessPremiumContent = state.isPremium`), `lib/core/services/subscription_service.dart` |

Non utilisés par les Home (code mort, à NE PAS reproduire) : `category_detail_cards_page.dart` (`CategoryDetailCardsPage`, jamais référencée),
`gpx_exam_concours_home_page.dart` (`/gpx_exam/concours`, enregistrée mais aucune carte n'y mène), et dans les fichiers Home : `_MiniCard`, `_HomeActionCard`,
`ProgressCardV4`, `_DepthCard`, `_ModeBubble` (school), `_QuickActionsGrid`, `_MiniHeroCard` (GPX exam) — définis mais jamais instanciés.
`home_page.dart` (`/home`, `HomePage` générique avec chips de track) n'est qu'un repli ; les 4 Home réelles sont les fichiers dédiés.

Les images (`assets/images/...`) ne sont PAS présentes dans ce dépôt (pas de dossier `assets/`) : il faudra les récupérer depuis le repo Flutter complet.

---

## 0. Aiguillage (home_bootstrap.dart)

1. Lit `user_mode` / `selected_track` dans SharedPreferences, puis **Supabase `user_profiles.select('user_mode, user_track').eq('user_id', uid)`** (la base gagne).
2. Mode invalide → `/mode_picker`. Mode `active` → `/active-home` ou `/active-verification`. Track invalide ou `reserve` → `/grade_picker`.
3. `gpx` + `exam` → `HomePageGpxExam`. `pa` + `exam` → `HomePagePaExam`.
4. `gpx` + `school` → programme lu via `SchoolProgramPreferences.readGpx()` (local), sinon ouverture de `GpxSchoolArt` (sélecteur) → `HomePageGpxSchool.program = picked`.
5. `pa` + `school` → idem avec `readPa()` / `PaSchoolArt` → `HomePagePaSchool.program`.

Programmes scolarité (enum → clé locale → titre) :

| GPX (`GpxSchoolProgram`) | clé | titre | heroImage (sélecteur) |
|---|---|---|---|
| institutionValeurs | `institution_valeurs` | Institution & Valeurs | `assets/images/school.jpeg` |
| dpsDpg | `dps_dpg` | DPS / DPG | `assets/images/exam.jpeg` |
| mememtoCirculationRoutiere | `memento_circulation_routiere` | Mémento • Circulation routière | `assets/images/contravention.jpeg` |
| policierEnIntervention | `policier_en_intervention` | Policier en intervention — Socle initial | `assets/images/cat_hierarchie.jpg` |
| policierEnInterventionsa | `policier_en_intervention_avance` | Policier en intervention — Socle avancé | `assets/images/cat_hierarchie.jpg` |
| recueilPvApj20 | `recueil_pv_apj20` | Recueil de procès-verbaux (APJ 20) | `assets/images/pp_instruction_mandats_detention.jpeg` |
| dimensionHumaine | `dimension_humaine` | Dimension humaine | `assets/images/dignite_discriminations.jpeg` |

PA (`PaSchoolProgram`) : `institutionValeurs` (Institution & Valeurs, icône `account_balance_rounded`, `school.jpeg`), `dpsDpg` (DPS / DPG, `gavel_rounded`, `exam.jpeg`),
`mememtoCirculationRoutiere` (Mémento circulation routière, `directions_car_rounded`). Sous-titres GPX : voir `gpx_school.dart` l. 80-95.

---

## 1. Design system commun aux 4 Home

### 1.1 Tokens locaux `_T` (identiques dans les 4 fichiers)

| Token | Valeur |
|---|---|
| `ink` | `#1C1C1C` |
| `g300` / `g400` / `g500` | `#E0E0E0` / `#BDBDBD` / `#9E9E9E` |
| rayons | `r16 = 16`, `r20 = 20`, `r24 = 24` |
| durées | `fast = 180 ms`, `med = 260 ms` |
| `shadow` | `BoxShadow(blur 16, color #14000000 (noir 8 %), offset (0, 10))` → CSS `0 10px 16px rgba(0,0,0,.08)` |
| `_muted(ctx, o)` | noir (clair) ou blanc (sombre) à opacité `o` (défaut .7) |

Thème global (`main.dart` l. 1537 + 2035-2070) :
- Clair : `scaffoldBackgroundColor = #F5F6F8`, seed `#212529`, `textTheme = GoogleFonts.instrumentSans`, Material 3. `cardColor` non défini → défaut Flutter (blanc `#FFFFFF`).
- Sombre : fond `#0F1114`, `cardColor #161A1E`, surface `#15181C`, primary gris.
- Polices utilisées dans les Home : **Poppins** (salutation, badges, deck, nav) ×77, **Instrument Sans** (texte par défaut + titre de carte deck, cartes « prochaine étape ») ×22, **Fustat** (pages catégorie + `_ModuleCard`) ×20, Montserrat ×3 (marginal).
- Rythme : padding horizontal de page **20 px**, gap carte-catégorie **14 px**, padding page catégorie `16/8/16/28`.

### 1.2 Structure commune d'une Home

`Scaffold(bg = scaffoldBackgroundColor)` → `SafeArea(top)` → `AnimatedSwitcher(duration 260 ms)` entre 5 pages d'onglets → `bottomNavigationBar: _SlidingPillNavBar(height 64)`.
L'onglet 0 est un `ListView(BouncingScrollPhysics)` dans un `PageStorage` (scroll + index du deck mémorisés).

En-tête (toutes) :
- `SizedBox(14)` puis Row : colonne [« Bonjour {prénom} » ou « Bonjour 👋 » — Poppins 22 / w900, 1 ligne ellipsis ; 4 px ; sous-titre `bodySmall` muted .7 w600/w700] + boutons à droite.
- Bouton rond `_IconCircle` icône `school_rounded` → `ModePickerScreen` (changer de mode/grade).
  - PA exam / GPX exam : `Material(cardColor, CircleBorder)` **40×40**, sans ombre, icône `#1C1C1C` (blanc en sombre).
  - PA school / GPX school : Container cercle **44×44**, `cardColor`, ombre `_T.shadow`, opacité .55 si désactivé.
- Écoles uniquement : avant le rond, bouton pill `_SpacePaButton` / `_SpaceGpxButton` : `Material(cardColor, radius 14)`, minHeight 44, padding h 12, bordure ink 10 %,
  Row [`arrow_back_rounded` 18, 6 px, texte « Espace PA » / « Espace GPX » Poppins 12 w800] → ouvre `PaSchoolArt` / `GpxSchoolArt` puis recharge la Home (`pushAndRemoveUntil`). 8 px entre ce bouton et le rond.
- `SizedBox(12)` puis Row recherche : Container **h 44**, `cardColor`, radius **14**, ombre `_T.shadow`, padding h 12, [`search_rounded` 20, 8 px, TextField sans bordure, hint muted .6] + 10 px + `_IconCircle(settings_rounded)` → `ParametreHomePage`.
  - Recherche active (GPX exam, PA school, GPX school) : normalisation sans accents, ≥ 3 caractères, match préfixe du label ou d'un mot du label des **catégories** ; debounce 160 ms ; si **exactement 1** résultat → ouverture automatique de la catégorie, champ vidé. Bouton `close_rounded` 18 quand non vide. PA exam : TextField décoratif (aucune logique).
- Titre de parcours `titleLarge` w900 ; sous-titre « Sélection de contenu » `titleMedium` w800.

### 1.3 Le carrousel héro `_HeroDeck` (identique dans les 4 Home)

PAS un `PageView` : pile `Stack` pilotée par un `AnimationController.unbounded` (valeur = page fractionnaire) + `GestureDetector` horizontal.

| Paramètre | Valeur |
|---|---|
| `viewportFraction` | **0.78** → `cardWidth = (screenW − 40) × 0.78` ; `sidePeek = (deckW − cardW)/2` en padding horizontal |
| Hauteur | Exam (PA+GPX) : **232** si écran < 700 px, **272** si < 820, sinon **320**. School (PA+GPX) : **330** fixe |
| Cartes rendues | uniquement celles avec `|i − page| ≤ 1.25`, triées pour que la carte active soit dessinée en dernier (au-dessus) |
| `t` | `1 − clamp(|i − page|, 0, 1)` |
| scale | `0.90 + 0.10·t` (active = 1.0, voisines = 0.90) |
| translateX | `(i − page) × 52 px` (cartes voisines décalées de 52 px, pas d'une largeur entière : effet « pile ») |
| translateY | `(1 − t) × 18 px` (voisines abaissées de 18 px) |
| opacity | `0.75 + 0.25·t` |
| Rayon | 24 (ClipRRect) |
| Drag | `page = startPage − dx / cardWidth`, clampé [0, n−1] |
| Relâchement | `target = round(page + vitessePages × 0.20)` puis **ressort** `SpringDescription(mass 1, stiffness 420, damping 32)` avec la vitesse initiale |
| Points / autoplay | **aucun** indicateur de pagination, **aucun** autoplay, pas de flèches |
| Mémoire de l'index | PA exam : `PageStorage` (`ValueKey('hero-deck-index')`) ; GPX exam : SharedPreferences `gpx_exam_hero_deck_index` ; PA school : `pa_school_hero_deck_index` ; GPX school : `gpx_school_hero_deck_index` |
| Index initial | PA exam : 1re catégorie contenant « cadres juridiques » sinon 0 (→ 0) ; GPX exam : contenant « structure » (→ 0) ; écoles : label == « cadres juridiques » (DPS/DPG) sinon 0 |

Équivalent web conseillé : composant React à état `page: number` (float) + pointer events + ressort (framer-motion `animate(value, target, {type:'spring', stiffness:420, damping:32, mass:1, velocity})`), rendu en `position:absolute; inset:0` avec `transform: translate(dx,dy) scale(s)`.

### 1.4 La carte héro `HeroCard` / `_HeroCard`

Pile plein cadre, rayon 24 :
1. `Image.asset(item.image, cover)` (fallback gris `#9E9E9E` 25 %).
2. Dégradé `bottom→top`, stops `[0.05, 0.35, 0.75]`, couleurs `[noir 65 %, noir 30 %, transparent]`.
3. Haut-droite (12/12) : bouton favori cercle **40×40**, fond `cardColor` 95 %, icône `favorite_border_rounded` / `favorite_rounded` (rouge `Colors.redAccent` = `#FF5252`). Pop : scale 1→1.15 `easeOutBack` 260 ms + `AnimatedSwitcher` 160 ms (scale). Stocké dans `FavoritesStore` (route, title, subtitle=badge, image, rating, reviews).
   - **GPX exam diffère** : favori en **haut-GAUCHE** (top 12, left 12) ; badge **Premium** (si `isLocked`) en haut-droite → `/subscription` ;
     dégradés : voile haut `topCenter→center` `[noir 18 %, transparent]` + voile bas `bottom→top` stops `[0, .42, .85]` `[noir 72 %, noir 30 %, transparent]`.
4. Bas (left 16, right 16, bottom 14), colonne :
   - badge : Poppins 12 w600 blanc 85 %, letterSpacing .2, 1 ligne ;
   - 4 px ; label : **Instrument Sans 20 w900 blanc**, max 3 lignes ;
   - 8 px ; Row [`star_rounded` 16 ambre `#FFC107`, 4 px, « 4.9 » Poppins 12 w800 blanc] (note fixe 4.9, min 4.5) ;
   - 12 px ; bouton CTA : h **46**, padding h 16, radius **18**, Row [texte centré « Découvrir » (ou « Reprendre » sur la carte du dernier module ouvert, écoles) w800 blanc, 8 px, `CircleAvatar` r14 blanc avec `arrow_forward_rounded` 18 noir 87 %].
     - Exam (PA/GPX) : fond anthracite **`#2E3137`**.
     - School (PA/GPX) : fond **`#474B53`** (ARGB 255,71,75,83) + bordure blanc 10 %.

### 1.5 La page catégorie `_CategoryDetailPage` (niveau 2) et `_ModuleCard`

`Scaffold(bg = blanc / sombre #0E0F12)`, `AppBar` sans élévation, centré, leading `arrow_back_ios_new` (couleur `#050505` / blanc), titre = label de la catégorie, **Fustat 18 w900**, 2 lignes.
Corps : `ListView.separated` padding `16,8,16,28`, séparateur **14 px**, une `_ModuleCard` par sous-catégorie.

`_ModuleCard` : rayon **18**, hauteur = max(**190**, calcul texte), Stack :
- image (`sub.image ?? _imageFor(label)`, cover, dans un `Hero(tag)`),
- dégradé `top→bottom` `[noir 10 %, noir 55 %, noir 78 %]` stops `[0, .55, 1]`,
- padding 16 : chip haut-gauche « Module » (padding 10/6, radius 999, fond blanc 10 % (14 % sombre), bordure blanc 14 % (18 %), Fustat 12 w800 blanc),
- si `isLocked` (PA exam, GPX exam, PA school) : badge **Premium** haut-droite (padding 10/6, radius 999, fond noir 36 %, bordure blanc 24 %, ombre blur 18 offset (0,10) `#22000000`, icône `lock_rounded` 14 + « Premium » Poppins 12 w900) → `/abonnement` (GPX exam : `/subscription`),
- bas-gauche (réserve 118+12 px à droite) : titre **Fustat 24 w900 blanc**, line-height 1.06 ; 6 px ; sous-titre `_subtitleFor(label)` **Fustat 14 w600 blanc 85 %**, lh 1.15,
- bas-droite : `_RoundCTA` pill (StadiumBorder) fond blanc 12 %, padding 12/10, [`arrow_forward_rounded` 22 blanc, 6 px, « Découvrir » Fustat 13 w800].
- Tap carte ou CTA → `guardAppAccess` (quota/lock global) puis navigation.

Les tables `_imageFor` / `_subtitleFor` (fallback par mots-clés du label) sont en **Annexe A**.

### 1.6 Barre de navigation `_SlidingPillNavBar` (identique, 5 onglets, icônes seules)

- `SafeArea(bottom)`, padding `16, 8, 16, max(safeBottom, 8)`. Hauteur **64**, rayon 32 (pill), ombre `_T.shadow`.
- Fond : clair **`#1C1C1C`** (ink) ; sombre blanc 8 %.
- Pastille active : cercle **blanc**, diamètre `clamp(64×0.62, 30, 44)` = **39.7 px**, `AnimatedPositioned` 260 ms `easeOutCubic` ; padding intérieur `dot/2 + 10`.
- Icônes taille `clamp(64×0.42, 18, 26)` = **26.9→26 px** ; active `#1C1C1C` (noir en sombre), inactive blanc (GPX school : blanc 92 % en clair).
- Ordre (les 4 Home) : 0 `home_rounded` Accueil · 1 `insights_rounded` Suivi · 2 `forum_rounded` Forum · 3 `favorite_rounded` Favoris · 4 `person_rounded` Profil.
- Changement d'onglet : `HapticFeedback.selectionClick` + `AnimatedSwitcher` 260 ms (GPX exam : courbes `easeOutCubic`/`easeInCubic`). Pas d'URL distincte : état interne `_currentTab`.

| Onglet | PA exam | GPX exam | PA school | GPX school |
|---|---|---|---|---|
| 1 Suivi | `PaExamProgressPage(onStart)` (source par défaut PA exam) | `PaExamProgressPage(coachTrack:'gpx', dataSource: GpxExamProgressService(), moduleMetaResolver: gpxModuleMeta)` | `PaExamProgressPage(dataSource: PaSchoolProgressService(), paSchoolModuleMeta)` | `PaExamProgressPage(coachTrack:'gpx', GpxSchoolProgressService(), gpxSchoolModuleMeta)` |
| 2 Forum | `CommunityPage(CommunityScope.paExam)` | `.gpxExam` | `.paSchool` | `.gpxSchool` |
| 3 Favoris | `FavorisHomePage` | idem | idem | idem |
| 4 Profil | `ProfilPage` | idem | idem | idem |

### 1.7 Animation d'entrée (PA exam uniquement)

`AnimationController` 760 ms, démarré après le 1er frame, une seule fois ; désactivé si « réduire les animations ». Chaque bloc : `FadeTransition` + `SlideTransition(Offset(0, .045) → 0)` avec `Interval(begin, end, easeOutCubic)` :
salutation 0–.34 · recherche .08–.44 · titre concours .18–.54 · « Sélection de contenu » .24–.60 · deck .32–.78 · reprise .48–1.0.
Les 3 autres Home n'ont pas cette animation (seulement l'`AnimatedSwitcher` d'onglets).

### 1.8 Garde d'accès

- `isLocked = !isPremium && quota.remaining <= 0` (quota gratuit, RPC `consume_free_request`). `guardAppAccess(context)` bloque si verrouillé.
- `canAccessPremiumContent(state) = state.isPremium` → sinon `PremiumRequiredPage` (`/premium-required`).
- PA exam : `guardAppAccess` sur `_ModuleCard` seulement.
- GPX exam : `guardAppAccess` sur la HeroCard et les routes ; en plus, routes « feuille quiz » (`/gpx_exam/concours/culture_generale_*`, `/tests_psychotechniques/*`, `/langue_etrangere/exemples_*`, `/cas_pratique/*`) consomment 1 crédit (`consumeFreeRequest`) → dialogue « Limite atteinte — Tu as utilisé tes 10 quiz gratuits » [Plus tard | Voir Premium → `/abonnement`].
- Écoles : listes de cours (catégorie avec sous-cartes) **libres** ; contenu direct (catégorie sans sous-cartes, carte « prochaine étape ») → `canAccessPremiumContent` sinon `/premium-required`. GPX school : chaque sous-carte aussi gardée par `canAccessPremiumContent`. PA school : sous-cartes gardées par `guardAppAccess` (quota) uniquement.

---
## 2. Home PA Concours — `HomePagePaExam` (`/home-pa-exam`)

Contexte : `UserMode.exam` + `Track.pa`. Catégories : `categoriesConfigPA[exam][pa]` (local, `home_page_pa_exam.dart` l. 1610-1758).

### 2.1 Sections (haut → bas)

| # | Espacement avant | Section | Données / source |
|---|---|---|---|
| 1 | 14 | Salutation « Bonjour {prénom} » / « Bonjour 👋 » + « Prêt à préparer ton concours ? » + rond `school_rounded` 40 px | prénom via `HomePagePaExam.usernameLoader` = `firstNameLoader` (`main.dart` ~l.1640) : Supabase `user_profiles.first_name` puis `username`, puis `auth.userMetadata` |
| 2 | 12 | Recherche « Rechercher un cours, un quiz… » (non fonctionnelle) + réglages | — |
| 3 | 22 (14 si écran < 760) | Titre « Examen — Policier adjoint » | statique |
| 4 | 8 (4) | « Sélection de contenu » | statique |
| 5 | 10 (7) | `_HeroDeck` (h 232/272/320) | local `categoriesConfigPA` |
| 6 | 26 (16) | `_ContinuePreparationSection` → `ContinuePreparationPanel` | `PaProgressionService.fetchSnapshot()` → Supabase **`quiz_history`** (`track='pa'`, `mode='exam'`, order `finished_at desc`, limit 200) ; objectif quotidien `kPaDailyGoal = 3` |
| 7 | `64+8+max(safeBottom,8)+24` | espace sous la nav flottante | — |

`ContinuePreparationPanel` (widgets/continue_preparation_panel.dart) :
- En-tête : « Continue ta préparation » (18 / w800, ink) + « Reprends exactement là où tu t’es arrêté. » (muted w500) ; à droite pill « Mon parcours » → (stadium, fond `softSurface`, bordure `border`, flèche) → onglet 1.
- 14 px puis `AnimatedSwitcher` 220 ms (`easeOutCubic`/`easeInCubic`) : skeleton / carte reprise / carte démarrage.
- Carte reprise (radius 24, dégradé `topLeft→bottomRight` surface→tintSurface, bordure, ombre `0 12px 22px rgba(0,0,0,.07)`, padding 16) : icône 50×50 r16 `menu_book_rounded`, pastille 6 px, titre = `quiz_name` (17 / w800), sous-titre = `module_name`, barre « Dernier score » (h 7, radius 999), « Ta progression est prête à continuer. », bouton « Continuer » (`play_arrow_rounded`, minHeight 46, radius 15, fond `cta`).
- Carte démarrage : « Commence ta préparation » / « Lance ton premier module concours PA et suis ta progression. », icône `rocket_launch_rounded`, bouton rond 46 `arrow_forward_rounded`.
- 12 px puis 2 `_StatCard` (r18, icône 38×38 r12) : `local_fire_department_rounded` `#FFA72C` « N jour(s) de suite » ; `track_changes_rounded` accent `#3977F6` (ou `check_circle_rounded` `#25B978` si atteint) « x/3 objectif du jour ».
- Palette clair/sombre : surface `#FFFFFF`/`#171B20`, softSurface `#F7F8FA`/`#15191E`, ink `#15171B`/`#F7F8FA`, muted `#5E6671`/`#AEB4BD`, border `#E5E8ED`/`#272D35`, progressTrack `#E9EDF3`/`#292E35`, cta `#171A1F`/`#F5F7FA`, ctaInk blanc/`#14171B`, skeleton `#EBEEF2`/`#242930`, accent `#3977F6`.
- Tap carte reprise → catégorie résolue par mots-clés de `module_name + quiz_name` (photolang → photolangage ; psycho/logique/aptitude/observation/raisonnement/personnalit → tests psy ; culture/connaissance/institution/géograph/histoire/sciences/droit/police/sport → connaissances générales ; épreuve/tableau/médical → épreuves ; sinon 1re).

### 2.2 Cartes du deck (4) — ordre d'affichage

| # | Titre (label) | Badge (sur-titre) | Image | Route | Ouverture |
|---|---|---|---|---|---|
| 1 | Les épreuves du concours PA | Bien démarrer | `assets/images/concours_pa_epreuves.jpeg` | `/pa_exam/concours/epreuves` | `_CategoryDetailPage` (2 sous-cartes) |
| 2 | Épreuve de photolangage | Expression écrite | `assets/images/concours_photolangage.jpeg` | `/pa_exam/concours/photolangage` | **direct** → `PaPhotolangageHubPage` |
| 3 | Tests psychotechniques | Logique & profil | `assets/images/concours_tests_psy.jpeg` | `/pa_exam/concours/tests_psychotechniques` | **direct** → `PaTestsPsyHomePage` |
| 4 | Connaissances générales | Institution & culture | `assets/images/concours_connaissances_generales.jpeg` | `/pa_exam/concours/connaissances_generales` | **direct** → `PaConnaissancesGeneralesHomePage` |

Règle `_openRouteOrDetails` : `redirectConfigPA` (`/pa/cadres_juridiques` → `/pa_scolarité_pages/cadres_juridiques`, `/pa/pp/gav` → `/pa_scolarité_pages/procedure_penale/pp_gav`) → si dans
`directOpenRoutesPA` → `pushNamed(route)` (hub dédié) → sinon si sous-cartes → `_CategoryDetailPage` → sinon `pushNamed`.
Aucune icône ni couleur par carte : chaque carte = image + dégradé noir ; pas de verrou premium sur le deck PA exam.

Hubs dédiés PA exam (niveau 2, `lib/content/pa_exam/...`) : liste de tuiles `PaPsyTile` (radius 18, padding 14, pastille icône 44×44 teintée, titre `PaPsychoBrand.h3`, description, chevron) dans `PaPsyScaffold`
(fond `#F5F6F7` / `#0E1014`, surface `#FFFFFF`/`#161A20`, bordure `#E7E9ED`/`#22262E`, header icône 64×64, accent **`#6C63FF`**, apparition `PaPsyReveal` 320 ms + délai, translateY 14 px, `easeOutCubic`).
- Tests psy : « Analyse de l’épreuve » (`insights_rounded`), « Personnalité & comportements » (`self_improvement_rounded`), « Mes corrigés & historique » (`history_rounded`) + section « Les exercices » :
  Attention visuelle `#6C63FF` `visibility_rounded`, Suites logiques `#14B8A6` `timeline_rounded`, Calcul mental `#F59E0B` `calculate_rounded`, Concentration `#EA580C` `center_focus_strong_rounded`,
  Logique verbale `#EC4899` `menu_book_rounded`, Raisonnement logique `#3B82F6` `psychology_alt_rounded` (routes `PaTestsPsyRoutes.ex*`).
- Connaissances générales (`pa_cg_hub_pages.dart`) : « Fiches de cours » (`menu_book_rounded`, `#6C63FF`), « Mes corrigés & historique » (`#06B6D4`) + matières :
  Histoire de France `#8B5CF6`, Institutions européennes `#3B82F6`, Actualité, Géographie `#14B8A6`, Langue française `#EC4899`, Sport `#EA580C`, Sciences `#06B6D4`, Santé `#22C55E`, Police & sécurité `#1D4ED8`, Mythologie `#F59E0B`, …
- Photolangage : Analyse (`insights_rounded`), Étapes de la réussite (`route_rounded`), Entraînements — sujets & corrigés (`photo_camera_rounded`), « Mon historique » + 3 stats (« Cas travaillés », « Moyenne COP’IQ », « Meilleur récent ») depuis `photolangage_attempts`.

---

## 3. Home GPX Concours — `HomePageGpxExam` (`/home-gpx-exam`)

Contexte : `UserMode.exam` + `Track.gpx`. Catégories : `categoriesConfigGPX` (`home_page_gpx_exam.dart` l. 2506-2731), `redirectConfigGPX = {}`.
Affiche un `CircularProgressIndicator` tant que l'index du deck n'est pas lu (SharedPreferences).

### 3.1 Sections

| # | Avant | Section | Données / source |
|---|---|---|---|
| 1 | 14 | « Bonjour {first_name} » / « Bonjour 👋 » + « Bienvenue sur COP’IQ » (w700) + rond `school_rounded` 40 | Supabase **`user_profiles.select('first_name').eq('user_id', uid)`** (rechargé au retour au 1er plan) |
| 2 | 12 | Recherche « Rechercher (ex: cas, psy, annales...) » (active, auto-open) + réglages | catégories locales |
| 3 | 18 (12) | « Examen — Gardien de la paix » | — |
| 4 | 8 (4) | « Sélection de contenu » | — |
| 5 | 10 (7) | `_HeroDeck` h 232/272/320 | local |
| 6 | 20 (14) | En-tête de section « Ta prochaine étape » (16 / w900) + action texte « Mon suivi » (w900 muted .7) → onglet 1 | — |
| 7 | 10 (7) | `_NextStepCard` (AnimatedSwitcher 260 ms, skeleton pendant chargement) | `GpxExamProgressService().load()` → Supabase **`quiz_history`** (gpx/exam) + **`tests_psychotechnique_history`** + **`cas_pratique_attempts`** + **`quiz_answer_history`** ; rechargé au retour d'une page et au resume |
| 8 | navBarFootprint | — | — |

`_NextStepCard` : radius 24 (20 si compact), padding 18 (14), dégradé `topLeft→bottomRight` clair `#F3F7FF → #E8F0FF` / sombre `#152238 → #0E1726`, bordure accent 16 % (30 %), ombre `_T.shadow`, accent **`#2563EB`**.
Row [carré 42 (38) r14 fond accent + icône blanche 22 ; eyebrow Instrument Sans 12 w800 accent ; titre Poppins 17 (15) w900 lh 1.15] ; 13 px ; sous-titre Instrument Sans 13 w600 muted .70 lh 1.4 ;
14 px ; `LinearProgressIndicator` h 6 radius 99 (fond accent 12 %) ; 14 px ; Row [bouton accent minHeight 44 (40) r15 « action » + flèche ; spacer ; `auto_awesome_rounded` 20 accent].
États :
- aucun historique → eyebrow « Bien démarrer », « Découvre ton niveau », « Commence par un exercice court pour personnaliser tes prochaines recommandations. », « Commencer », `rocket_launch_rounded`, route `/gpx_exam/concours/tests_psychotechniques/calcul_rapide`, progress 0 ;
- recommandation → « Priorité personnalisée », « Renforce {matière} », « {moy} % de moyenne · {n} activité(s). Une session ciblée peut faire la différence. », « M’entraîner », icône `gpxModuleMeta(key).icon`, progress = moyenne ;
- sinon → « Continuer sur ta lancée », titre dernière activité, « Dernier résultat : {p} % · {fait}/{objectif} objectif du jour. », « Continuer », `play_arrow_rounded`.

### 3.2 Cartes du deck (5)

| # | Titre | Badge | Image | Route | Ouverture |
|---|---|---|---|---|---|
| 1 | Structure du concours GPX | Organisation & déroulement | `assets/images/concours_pa_epreuves.jpeg` | `/gpx_exam/concours/epreuves_gpx` | `_CategoryDetailPage` (3) |
| 2 | Cas pratique | Méthodologie & raisonnement | `assets/images/comprendre.jpg` | `/gpx_exam/concours/cas_pratique/welcome` | direct → `GpxCasPratiqueEntrainementWelcomePage` |
| 3 | Culture générale | Institutions & société | `assets/images/concours_connaissances_generales.jpeg` | `/gpx_exam/concours/culture_generale` | `_CategoryDetailPage` (15) |
| 4 | Langue étrangère | Anglais • Espagnol • Allemand | `assets/images/diffusion_images.jpeg` | `/gpx_exam/concours/langue_etrangere` | `_CategoryDetailPage` (3) |
| 5 | Tests psychotechniques | Logique • Numérique • Verbal • Spatial | `assets/images/concours_tests_psy.jpeg` | `/gpx_exam/concours/tests_psychotechniques` | `_CategoryDetailPage` (9) |

Tap HeroCard → `guardAppAccess` → `_openRouteOrDetails`. Sous-cartes → `_openRouteWithQuota` (consommation d'un crédit gratuit pour les feuilles quiz, cf. 1.8). Badge Premium sur HeroCard et `_ModuleCard` si `isLocked` (→ `/subscription`).

---

## 4. Home PA Scolarité — `HomePagePaSchool` (`/home-pa-school`)

Contexte : `UserMode.school` + `Track.pa`, programme `HomePagePaSchool.program` (`PaSchoolProgram`). Catégories `paSchoolCategoriesConfig[program]` (l. 3654-4827).
Redirections : `redirectConfigPaSchool` (l. 4828, 94 alias, ex. `/generalite` → `/gpx_scolarite_pages/generalite_pages`) puis `resolveHomeRoute` (`redirectConfigHome` de `home_page.dart`).

### 4.1 Sections

| # | Avant | Section | Données / source |
|---|---|---|---|
| 1 | 14 | « Bonjour {prénom} » + « Bienvenue sur COP’IQ » (w600) + pill « Espace PA » + rond `school_rounded` 44 (ombre) | `usernameLoader` (= `firstNameLoader`, `user_profiles`) |
| 2 | 12 | Recherche « Rechercher (ex: san, nat, arm...) » + réglages 44 | catégories locales |
| 3 | 22 | « Scolarité — Policier Adjoint » | — |
| 4 | 8 | « Sélection de contenu » | — |
| 5 | 10 | `_HeroDeck` **h 330**, CTA « Reprendre » sur la carte = dernier module ouvert | dernier ouvert : SharedPreferences `pa_school_last_route` / `pa_school_last_label` |
| 6 | 18 | `_PaSchoolNextStepCard` « Ta prochaine étape » | **aléatoire local** : une sous-catégorie tirée au hasard parmi toutes celles du programme (stable pendant la session) |
| 7 | 24 | fin (pas de réserve pour la nav) | — |

Carte « Ta prochaine étape » (écoles PA et GPX, identique) : en-tête Row [`auto_awesome_rounded` 19 accent **`#2D6CDF`**, 8 px, « Ta prochaine étape » Poppins 16 w900, « Aujourd’hui » Instrument Sans 12 w700 muted .58] ; 10 px ;
carte **h 148**, radius 24, ombre `_T.shadow` : image (sub.image ?? cat.image, cover, `centerRight`, fallback `#EAF1FF`/`#121D31`) + dégradé `centerLeft→centerRight` `[#101C31 (sombre #0B1220), #E6101C31, #5C101C31]` stops `[0, .54, 1]` ;
padding 16 : catégorie en MAJUSCULES Instrument Sans 11 w800 `#9FC0FF` ls .7 ; 7 px ; titre Poppins 18 w900 blanc lh 1.12 (maxWidth 240, 3 lignes) ; spacer ; « Commencer » Instrument Sans 14 w800 blanc + rond blanc 30 avec flèche `#101C31`.
Tap → `_openRouteOrDetails(label, route)` sans sous-cartes → garde `canAccessPremiumContent`.

Onglet Suivi : `PaSchoolProgressService` → Supabase **`quiz_history`** (`uid`, `track='pa'`, `mode='school'`, order `started_at desc`, limit 750).

### 4.2 Cartes du deck par programme

Toutes les catégories ont des sous-cartes → ouverture `_CategoryDetailPage` (libre). Liste complète avec sous-cartes et pages Dart : voir §7.3.

- **Institution & Valeurs** (7) : Formation initiale · Organisation de la Police Nationale · Déontologie · Information de la hiérarchie · Accueil du public · Laïcité, police et religions · Histoire de la police.
- **DPS / DPG** (21 ; « Socle initial » puis « Socle avancé ») : Généralités · Hiérarchie — fonctions judiciaires · Cadres juridiques · Armes & munitions · La sanction · Crimes & délits contre la nation · Atteintes aux mineurs & à la famille · Procédure Pénale · Contrôle d'identité · Circulation routière · Organisation judiciaire · Atteintes aux biens · Atteintes aux personnes · Autorité de l’État · Généralités (avancé) · Acteurs de la Police Judiciaire · Atteintes aux biens · Atteintes aux personnes · Délits routiers · Autorité de l’État · Stupéfiants.
- **Mémento circulation routière** (3) : Procédures circulation routière · Contrôle routier & pièces · Équipements véhicules & usagers.

---

## 5. Home GPX Scolarité — `HomePageGpxSchool` (`/home-gpx-school`)

Contexte : `UserMode.school` + `Track.gpx`, programme `HomePageGpxSchool.program` (défaut `institutionValeurs`). Catégories `gpxSchoolCategoriesConfig[program]` (l. 3690-5944). `redirectConfigGpxSchool = {}`.
Mise en page **identique à PA school** (§4.1) avec : pill « Espace GPX », titre « Scolarité — Gardien de la Paix », recherche « Rechercher (ex: san, nat, arm...) »,
SharedPreferences `gpx_school_hero_deck_index`, `gpx_school_last_route`, `gpx_school_last_label`, carte « Ta prochaine étape » `_GpxSchoolNextStepCard` (même design, accent `#2D6CDF`).
Spécificités : clés `GlobalKey` pour le tutoriel de découverte (`HomePageGpxSchoolDiscoveryTutorial`, overlay focus + flou + bulle, verrouillage `tutorialLock` qui laisse swiper mais bloque l'ouverture) ;
sous-cartes gardées par `canAccessPremiumContent` → `/premium-required` ; pas de badge Premium sur `_ModuleCard`.
Onglet Suivi : `GpxSchoolProgressService` → **`quiz_history`** (`track='gpx'`, `mode='school'`, `finished_at` non nul), objectif local `gpx_school_daily_goal`.

### 5.1 Cartes du deck par programme (nb de sous-cartes)

- **Institution & Valeurs** : Formation initiale (2) · Organisation de la Police Nationale (9) · Déontologie (8) · Information de la hiérarchie (3) · Accueil du public (6) · Laïcité, police et religions (3) · Histoire de la police (1).
- **DPS / DPG** : Généralités (10) · Cadres juridiques (12) · Procédure Pénale (5) · Droit pénal général (2) · La sanction (4) · Crimes & délits contre la personne (10) · Atteintes aux mineurs & à la famille (5) · Crimes & délits contre la nation (7) · Crimes & délits contre les biens (7) · Infractions à la circulation routière (13) · Armes & munitions (9) · **Libertés publiques (0 → direct `LibertesPubliquesIntroPage`, gardé premium)** · Stupéfiants — usage & trafic (11).
- **Mémento • Circulation routière** : Procédures circulation routière (10) · Contrôle routier & pièces (7) · Équipements véhicules & usagers (12) · Natinf (1).
- **Policier en intervention — Socle initial** (`policierEnIntervention`) : La prise de service (6) · La patrouille (16) · L’accident de la circulation (3) · L’intervention au domicile (4) · Les autres interventions (5) · Formulaires utiles (3).
- **Policier en intervention — Socle avancé** (`policierEnInterventionsa`) : Circulation & séjour des étrangers (4) · Protection des mineurs (3) · Accident de la circulation (7) · Intervention : usage de stupéfiants (2) · Intervention : débit de boissons (3) · Les malades mentaux (3) · Intervention : présence d’un animal (5) · Les autres interventions (8).
- **Recueil de procès-verbaux (APJ 20)** : 14 cartes « Recueil PV — … » (Introduction 4, La plainte 7, Constatations 2, Témoignage 3, Contrôle d’identité 3, Interpellation & conduite au poste 8, GAV & suspect libre 8, Audition du suspect 6, Perquisition (enquête préliminaire) 3, Réquisitions 3, Confrontation 3, Procédures spéciales (étrangers) 3, Circulation routière 25, I.V.P.M 3).
- **Dimension humaine** : Communication & posture (6) · Stress & gestion émotionnelle (5) · Éthique au quotidien (4).

---

## 6. Tableau comparatif rapide

| | PA exam | GPX exam | PA school | GPX school |
|---|---|---|---|---|
| Sous-titre salutation | Prêt à préparer ton concours ? | Bienvenue sur COP’IQ | Bienvenue sur COP’IQ | Bienvenue sur COP’IQ |
| Prénom | `firstNameLoader` | `user_profiles.first_name` direct | `firstNameLoader` | `firstNameLoader` |
| Bouton « Espace » | — | — | Espace PA → `PaSchoolArt` | Espace GPX → `GpxSchoolArt` |
| Rond école / réglages | 40 px sans ombre | 40 px sans ombre | 44 px ombre | 44 px ombre |
| Recherche fonctionnelle | non | oui | oui | oui |
| Titre | Examen — Policier adjoint | Examen — Gardien de la paix | Scolarité — Policier Adjoint | Scolarité — Gardien de la Paix |
| Hauteur deck | 232/272/320 | 232/272/320 | 330 | 330 |
| CTA deck | Découvrir, `#2E3137` | Découvrir, `#2E3137` | Découvrir/Reprendre, `#474B53` | Découvrir/Reprendre, `#474B53` |
| Bloc sous le deck | Continue ta préparation (Supabase) | Ta prochaine étape (Supabase, adaptatif, `#2563EB`) | Ta prochaine étape (aléatoire local, `#2D6CDF`) | idem PA school |
| Animation d'entrée | oui (760 ms) | non | non | non |
| Forum scope | paExam | gpxExam | paSchool | gpxSchool |

---

## 7. Cartographie pyramidale (Home → carte deck → sous-cartes → page)

Légende : niveau 1 = carte du deck (`HeroCard`) ; niveau 2 = `_CategoryDetailPage` interne (liste de `_ModuleCard`, PAS une route nommée) ou hub dédié (route nommée) ;
niveau 3 = route nommée de la sous-carte ⇒ **classe Dart** résolue dans `RouteRegistry.routes` / `PaSchoolRouteRegistry.routes` (redirections appliquées).
Replis dynamiques du routeur : `/scolarite/quiz/{module}` → `QuizScolariteDynamiquePage` ; préfixes `/gpx_scolarite/`, `/pa_scolarite/`, `/scolarite/course/` → `CoursScolaritePage(courseRoute)` ; sinon `_NotFoundScreen`.
Toutes les routes des 4 configs se résolvent (0 route introuvable). Niveaux plus profonds (fiches → sous-fiches → quiz) : voir `progression/CARTOGRAPHIE_COMPLETE_SCOLARITE_GPX_PA.md` (1 409 fichiers) et `CARTOGRAPHIE_PYRAMIDALE_SCOLARITE_GPX_PA.png`.

### 7.1 PA Concours (`categoriesConfigPA`)

- **Les épreuves du concours PA** — badge: _Bien démarrer_ — img `assets/images/concours_pa_epreuves.jpeg` — route `/pa_exam/concours/epreuves` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - Tableau des épreuves → `/pa_exam/concours/epreuves/tableau` ⇒ **CoursScolaritePage**
    - Visite médicale & enquête administrative → `/pa_exam/concours/epreuves/visite_medicale_enquete` ⇒ **CoursScolaritePage**
- **Épreuve de photolangage** — badge: _Expression écrite_ — img `assets/images/concours_photolangage.jpeg` — route `/pa_exam/concours/photolangage` ⇒ **PaPhotolangageHubPage** _(directOpenRoutesPA : hub dédié ouvert directement; les sous-cartes ci-dessous sont la config, le hub les présente lui-même)_
    - Analyse de l’épreuve → `/pa_exam/concours/photolangage/analyse` ⇒ **PaPhotolangageAnalysePage**
    - Les étapes de la réussite → `/pa_exam/concours/photolangage/etapes_reussite` ⇒ **PaPhotolangageEtapesPage**
    - Entraînements (sujets & corrigés) → `/pa_exam/concours/photolangage/entrainements` ⇒ **PaPhotolangageTrainingListPage**
- **Tests psychotechniques** — badge: _Logique & profil_ — img `assets/images/concours_tests_psy.jpeg` — route `/pa_exam/concours/tests_psychotechniques` ⇒ **PaTestsPsyHomePage** _(directOpenRoutesPA : hub dédié ouvert directement; les sous-cartes ci-dessous sont la config, le hub les présente lui-même)_
    - Analyse de l’épreuve → `/pa_exam/concours/tests_psy/analyse` ⇒ **PaTestsPsyAnalysePage**
    - Aptitude verbale → `/pa_exam/concours/tests_psy/aptitude_verbale` ⇒ **PaQuizPsycotechniquesVerbal**
    - Raisonnement logique → `/pa_exam/concours/tests_psy/raisonnement_logique` ⇒ **PaTestsPsyRaisonnementHubPage**
    - Observation & attention → `/pa_exam/concours/tests_psy/observation_attention` ⇒ **PaTestsPsyObservationHubPage**
    - Personnalité & comportements → `/pa_exam/concours/tests_psy/personnalite` ⇒ **PaTestsPsyPersonnalitePage**
    - Entraînements — QCM → `/pa_exam/concours/tests_psy/entrainements_qcm` ⇒ **PaTestsPsyQcmHubPage**
    - Entraînements — Exercices → `/pa_exam/concours/tests_psy/entrainements_exercices` ⇒ **PaTestsPsyExercicesHubPage**
    - Entraînements — Corrigés → `/pa_exam/concours/tests_psy/entrainements_corriges` ⇒ **PaTestsPsyCorrigesPage**
- **Connaissances générales** — badge: _Institution & culture_ — img `assets/images/concours_connaissances_generales.jpeg` — route `/pa_exam/concours/connaissances_generales` ⇒ **PaConnaissancesGeneralesHomePage** _(directOpenRoutesPA : hub dédié ouvert directement; les sous-cartes ci-dessous sont la config, le hub les présente lui-même)_
    - Fiches de cours → `/pa_exam/concours/connaissances_generales/fiches_de_cours` ⇒ **PaCgFichesPage**
    - Entraînements — QCM → `/pa_exam/concours/connaissances_generales/entrainements_qcm` ⇒ **PaCgQcmHubPage**
    - Entraînements — Exercices → `/pa_exam/concours/connaissances_generales/entrainements_exercices` ⇒ **PaCgExercicesHubPage**
    - Entraînements — Corrigés → `/pa_exam/concours/connaissances_generales/entrainements_corriges` ⇒ **PaCgCorrigesPage**


### 7.2 GPX Concours (`categoriesConfigGPX`)

- **Structure du concours GPX** — badge: _Organisation & déroulement_ — img `assets/images/concours_pa_epreuves.jpeg` — route `/gpx_exam/concours/epreuves_gpx` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - Tableau récapitulatif des épreuves → `/gpx_exam/concours/epreuves_gpx/tableau` ⇒ **TableauRecapitulatifEpreuvesGPXPage**
    - Épreuves d’admissibilité — écrit → `/gpx_exam/concours/epreuves_gpx/admissibilite` ⇒ **GPXAdmissibilitePage**
    - Épreuves d’admission — oral & sport → `/gpx_exam/concours/epreuves_gpx/admission` (img `assets/images/sport.jpg`) ⇒ **GPXAdmissionPage**
- **Cas pratique** — badge: _Méthodologie & raisonnement_ — img `assets/images/comprendre.jpg` — route `/gpx_exam/concours/cas_pratique/welcome` ⇒ **GpxCasPratiqueEntrainementWelcomePage**
- **Culture générale** — badge: _Institutions & société_ — img `assets/images/concours_connaissances_generales.jpeg` — route `/gpx_exam/concours/culture_generale` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - Histoire de france & institutions → `/gpx_exam/concours/culture_generale_histoire_france` (img `assets/images/histoire_de_france.webp`) ⇒ **QuizCultureGeneraleHistoireFranceGPX**
    - Institutions européennes → `/gpx_exam/concours/culture_generale_institutions_europeennes` (img `assets/images/ue.jpg`) ⇒ **QuizCultureGeneralInstitutionsEuropeenes**
    - Actualité & société → `/gpx_exam/concours/culture_generale_actualite` (img `assets/images/macron.jpg`) ⇒ **QuizCultureGeneraleActualite**
    - Géographie française & mondiale → `/gpx_exam/concours/culture_generale_geographie` (img `assets/images/geographie.png`) ⇒ **QuizCultureGeneraleGeographie**
    - Français & Humanités → `/gpx_exam/concours/culture_generale_francais` (img `assets/images/francais_cg.jpg`) ⇒ **QuizCultureGeneralFrance**
    - Sport & culture générale → `/gpx_exam/concours/culture_generale_sport` (img `assets/images/sport_cg.jpg`) ⇒ **QuizCultureGeneraleSport**
    - Sciences & environnement → `/gpx_exam/concours/culture_generale_sciences` (img `assets/images/science.jpg`) ⇒ **QuizCultureGeneraleSciences**
    - Santé & bien-être → `/gpx_exam/concours/culture_generale_sante` (img `assets/images/sante.png`) ⇒ **QuizCultureGeneraleSante**
    - Police & sécurité publique → `/gpx_exam/concours/culture_generale_police_securite` (img `assets/images/police.webp`) ⇒ **QuizCultureGeneralePolice**
    - Mythologie & culture générale → `/gpx_exam/concours/culture_generale_mythologie` (img `assets/images/mythologie.webp`) ⇒ **QuizCultureGeneraleMythologie**
    - Musique & culture générale → `/gpx_exam/concours/culture_generale_musique` (img `assets/images/musique.jpg`) ⇒ **QuizCultureGeneraleMusique**
    - Cinéma & culture générale → `/gpx_exam/concours/culture_generale_cinema` (img `assets/images/cinema.png`) ⇒ **QuizCultureGeneraleCinema**
    - Droit & culture générale → `/gpx_exam/concours/culture_generale_droit` (img `assets/images/action_justice.jpeg`) ⇒ **QuizCultureGeneraleDroit**
    - Langue & culture générale → `/gpx_exam/concours/culture_generale_langue` (img `assets/images/langue_francaise.webp`) ⇒ **QuizCultureGeneralFrance**
    - Sécurité routière & culture générale → `/gpx_exam/concours/culture_generale_securite_routiere` (img `assets/images/secu.webp`) ⇒ **QuizCultureGeneraleSecuriteRoutiere**
- **Langue étrangère** — badge: _Anglais • Espagnol • Allemand_ — img `assets/images/diffusion_images.jpeg` — route `/gpx_exam/concours/langue_etrangere` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - QCM  — Anglais → `/gpx_exam/concours/langue_etrangere/exemples_anglais` (img `assets/images/anglais.webp`) ⇒ **QuizLangueEtrangereAnglais**
    - QCM  — Espagnol → `/gpx_exam/concours/langue_etrangere/exemples_espagnol` (img `assets/images/espagne.png`) ⇒ **QuizLangueEtrangereEspagnol**
    - QCM  — Allemand → `/gpx_exam/concours/langue_etrangere/exemples_allemand` (img `assets/images/allemand.jpg`) ⇒ **QuizLangueEtrangereAllemand**
- **Tests psychotechniques** — badge: _Logique • Numérique • Verbal • Spatial_ — img `assets/images/concours_tests_psy.jpeg` — route `/gpx_exam/concours/tests_psychotechniques` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - Comprendre l’épreuve → `/gpx_exam/concours/tests_psychotechniques/comprendre_epreuve` (img `assets/images/comprendre_psyco.png`) ⇒ **ComprendreEpreuvePsychoPage**
    - Attention visuelle → `/gpx_exam/concours/tests_psychotechniques/attention_visuelle` (img `assets/images/attention_visuelle.jpg`) ⇒ **AttentionVisuellePageNew**
    - Suites logiques → `/gpx_exam/concours/tests_psychotechniques/suites_logiques` (img `assets/images/suite_logique.png`) ⇒ **SuitesLogiquesPageNew**
    - Raisonnement logique → `/gpx_exam/concours/tests_psychotechniques/raisonnement_logique` (img `assets/images/raisonnement.png`) ⇒ **RaisonnementLogiquePage**
    - Calcul mental → `/gpx_exam/concours/tests_psychotechniques/calcul_mental` (img `assets/images/calcul.png`) ⇒ **CalculMentalPage**
    - Logique verbale → `/gpx_exam/concours/tests_psychotechniques/logique_verbale` (img `assets/images/verbal.png`) ⇒ **LogiqueVerbalePage**
    - Raisonnement spatial → `/gpx_exam/concours/tests_psychotechniques/spatial` (img `assets/images/spatial.png`) ⇒ **RaisonnementSpatialPage**
    - Rotations & symétries → `/gpx_exam/concours/tests_psychotechniques/rotations` (img `assets/images/rotation.png`) ⇒ **RotationsSymetriesPage**
    - Mode concours (chronométré) → `/gpx_exam/concours/tests_psychotechniques/mode_concours` (img `assets/images/chrono.jpg`) ⇒ **ModeConcoursPsychoPage**


### 7.3 PA Scolarité (`paSchoolCategoriesConfig`, redirections `redirectConfigPaSchool` → `redirectConfigHome` appliquées)

#### PaSchoolProgram.institutionValeurs
- **Formation initiale** — badge: _Bases & méthodo_ — img `assets/images/copic_institutions.jpg` — route `/pa/institution/formation_initiale` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - La formation initiale → `/pa/institution/formation_initiale/formation` (img `assets/images/copic_institutions.jpg`) ⇒ **FormationInitialePolicierAdjointPage**
    - Mémento prise de notes & méthodologie → `/pa/institution/formation_initiale/memento_notes` (img `assets/images/concours_connaissances_generales.jpeg`) ⇒ **MementoPriseDeNotesMethodologiePage**
- **Organisation de la Police Nationale** — badge: _Structures & rôles_ — img `assets/images/background.jpeg` — route `/pa/institution/organisation_pn` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - Organigramme du Ministère de l’Intérieur → `/pa/institution/organisation_pn/organigramme_mi` (img `assets/images/organigramme_mi.jpeg`) ⇒ **PaOrganigrammeMinistereInterieurPage**
    - Organisation & Direction de la Police Nationale → `/pa/institution/organisation_pn/organisation` ⇒ **PaOrganisationPoliceNationalePage**
    - Direction générale de la sécurité intérieure → `/pa/institution/organisation_pn/dgsi` (img `assets/images/dgsi.jpeg`) ⇒ **PaDgsiPage**
    - Préfecture de police → `/pa/institution/organisation_pn/prefecture_police` (img `assets/images/prefecture_police.jpeg`) ⇒ **PaPrefecturePolicePage**
    - Organigrammes → `/pa/institution/organisation_pn/organigrammes` ⇒ **PaOrganigrammesPnPage**
    - Hiérarchie des personnels de la Police Nationale → `/pa/institution/organisation_pn/hierarchie` (img `assets/images/hierarchie_police.jpeg`) ⇒ **PaHierarchiePnPage**
    - Règles d’emploi des policiers adjoints → `/pa/institution/organisation_pn/regles_emploi_pa` (img `assets/images/regles_emploi_pa.jpeg`) ⇒ **PaReglesEmploiPaPage**
    - Horaires de service en sécurité publique → `/pa/institution/organisation_pn/horaires_service_sp` (img `assets/images/horaires_service_sp.jpeg`) ⇒ **PaHorairesServiceSpPage**
    - Quiz — Organisation de la Police Nationale → `/pa/institution/organisation_pn/quiz` (img `assets/images/quiz.jpeg`) ⇒ **PaQuizOrganisationPnPage**
- **Déontologie** — badge: _Éthique & cadre_ — img `assets/images/cat_organisation.jpg` — route `/pa/institution/deontologie` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - Code de déontologie commenté (PN & GN) → `/pa/institution/deontologie/code_commente` (img `assets/images/code_commente.webp`) ⇒ **PaCodeDeontologieCodeCommentePage**
    - Marques extérieures de respect (salut, présentation) → `/pa/institution/deontologie/marques_respect` (img `assets/images/marques_respect.jpeg`) ⇒ **PaMarquesExterieuresRespectPage**
    - Droits & obligations des policiers → `/pa/institution/deontologie/droits_obligations` ⇒ **PaDroitsObligationsPoliciersPage**
    - Policier hors service : dois-je intervenir ? (AMARIS) → `/pa/institution/deontologie/hors_service_amaris` (img `assets/images/hors_service_amaris.jpeg`) ⇒ **PaHorsServiceAmarisPage**
    - Sanctions & récompenses → `/pa/institution/deontologie/sanctions_recompenses` (img `assets/images/sanction.jpeg`) ⇒ **PaSanctionsRecompensesPage**
    - Enquête administrative → `/pa/institution/deontologie/enquete_administrative` ⇒ **PaEnqueteAdministrativePage**
    - Usage des réseaux sociaux → `/pa/institution/deontologie/reseaux_sociaux` (img `assets/images/reseaux_sociaux.jpg`) ⇒ **PaReseauxSociauxPage**
    - Quiz — Déontologie → `/pa/institution/deontologie/quiz` (img `assets/images/quiz.jpeg`) ⇒ **PaQuizDeontologiePage**
- **Information de la hiérarchie** — badge: _Écrits pro_ — img `assets/images/cat_hierarchie.jpg` — route `/pa/institution/hierarchie_info` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - Le compte-rendu → `/pa/institution/hierarchie_info/compte_rendu` (img `assets/images/compte_rendu.jpeg`) ⇒ **PaCompteRenduPage**
    - Le formalisme du rapport → `/pa/institution/hierarchie_info/formalisme_rapport` (img `assets/images/formalisme_rapport.jpeg`) ⇒ **PaFormalismeRapportPage**
    - Modèles de rapports → `/pa/institution/hierarchie_info/modeles` (img `assets/images/modeles.jpeg`) ⇒ **PaModelesRapportsPage**
- **Accueil du public** — badge: _Victimes & assistance_ — img `assets/images/image1.jpeg` — route `/pa/institution/accueil_public` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - Charte de l’accueil du public & assistance aux victimes → `/pa/institution/accueil_public/charte` (img `assets/images/charte.jpeg`) ⇒ **PaCharteAccueilPublicVictimesPage**
    - Référentiel Marianne → `/pa/institution/accueil_public/marianne` (img `assets/images/marianne.jpg`) ⇒ **PaReferentielMariannePage**
    - Dépliants & doctrine accueil / prise en charge → `/pa/institution/accueil_public/doctrine` (img `assets/images/doctrine.jpeg`) ⇒ **PaGpxDoctrineAccueilVictimesVcPage**
    - Quelques démarches administratives → `/pa/institution/accueil_public/demarches` ⇒ **PaDemarchesAdministrativesPage**
    - Protection des locaux de police → `/pa/institution/accueil_public/protection_locaux` (img `assets/images/protection_locaux.jpeg`) ⇒ **PaProtectionLocauxPolicePage**
    - Quiz — Accueil du public → `/pa/institution/accueil_public/quiz` (img `assets/images/quiz.jpeg`) ⇒ **PaQuizAccueilPublicPage**
- **Laïcité, police et religions** — badge: _Neutralité_ — img `assets/images/image6.jpg` — route `/pa/institution/laicite` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - La laïcité (DLPAJ / bureau des cultes) → `/pa/institution/laicite/laicite_dlpaj` (img `assets/images/laicite_dlpaj.jpeg`) ⇒ **PaGpxLaiciteDlpajPage**
    - Charte de la laïcité dans les services publics → `/pa/institution/laicite/charte` (img `assets/images/charte_laicite.jpeg`) ⇒ **PaCharteLaiciteServicesPublicsPage**
    - Principaux rites & pratiques des cultes en France → `/pa/institution/laicite/rites_cultes` (img `assets/images/rites_cultes.jpeg`) ⇒ **PaRitesCultesFrancePage**
    - Quiz — Laïcité → `/pa/institution/laicite/quiz` (img `assets/images/image6.jpg`) ⇒ **QuizScolariteDynamiquePage**
- **Histoire de la police** — badge: _Repères_ — img `assets/images/image4.jpeg` — route `/pa/institution/histoire` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - Points de repères chronologiques → `/pa/institution/histoire/reperes` ⇒ **PaHistoireReperesPage**

#### PaSchoolProgram.dpsDpg
- **Généralités** — badge: _Socle initial_ — img `assets/images/generalite.jpeg` — route `/pa/dps_dpg/socle_initial/generalites` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - Classification des infractions → `/pa/dps_dpg/socle_initial/generalites/classification_infractions` ⇒ **PaClassificationInfractionsPage**
    - L’infraction → `/pa/dps_dpg/socle_initial/generalites/infraction_intro` ⇒ **PaInfractionIntroPage**
    - La tentative punissable → `/pa/dps_dpg/socle_initial/generalites/tentative_intro` ⇒ **PaTentativeIntroPage**
    - La complicité → `/pa/dps_dpg/socle_initial/generalites/complicite_intro` ⇒ **PaCompliciteIntroPage**
    - La légitime défense → `/pa/dps_dpg/socle_initial/generalites/legitimedefense_intro` ⇒ **PaLegitimeDefenseIntroPage**
    - Cadre légal d’usage des armes → `/pa/dps_dpg/socle_initial/generalites/usagedesarmes_intro` ⇒ **PaUsageArmesIntroPage**
    - Les libertés publiques → `/pa/dps_dpg/libertes_publiques_intro` ⇒ **PaLibertesPubliquesIntroPage**
    - Rétention dans les locaux de police → `/pa/dps_dpg/socle_initial/generalites/retention_locaux_police_intro` ⇒ **PaRetentionLocauxIntroPage**
- **Hiérarchie — fonctions judiciaires** — badge: _Socle initial_ — img `assets/images/cat_hierarchie.jpg` — route `/pa/dps_dpg/socle_initial/hierarchie` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - Hiérarchie des personnels de la Police Nationale → `/pa/dps_dpg/socle_initial/hierarchie/hierarchie_intro` ⇒ **PaHierarchieIntroPage**
- **Cadres juridiques** — badge: _Socle initial_ — img `assets/images/cadres_juridiques.jpeg` — route `/pa/dps_dpg/socle_initial/cadres_juridiques` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - Les cadres d'enquête → `/pa/dps_dpg/cadres_juridiques/cadres_enquete_intro` ⇒ **PaCadresEnqueteIntroPage**
    - L'enquête de flagrant délit → `/pa/dps_dpg/cadres_juridiques/flagrant_delit_intro` ⇒ **PaFlagrantDelitIntroPage**
    - L'enquête préliminaire → `/pa/dps_dpg/cadres_juridiques/enquete_preliminaire_intro` ⇒ **PaEnquetePreliminaireIntroPage**
    - La commission rogatoire → `/pa/dps_dpg/cadres_juridiques/commission_rogatoire_intro` ⇒ **PaCommissionRogatoireIntroPage**
    - Découverte d'une personne grièvement blessée → `/pa/dps_dpg/cadres_juridiques/personne_blessee_intro` ⇒ **PaPersonneBlesseGrievementntroPage**
    - Mort de cause inconnue ou suspecte → `/pa/dps_dpg/cadres_juridiques/mort_inconnue/intro` ⇒ **PaMortInconnueIntroPage**
    - Délinquance & criminalité organisées → `/pa/dps_dpg/cadres_juridiques/criminalite_organisee_contenu` ⇒ **PaCriminaliteOrganiseeContenuPage**
    - Recherche des personnes en fuite → `/pa/dps_dpg/cadres_juridiques/recherche_personnes_fuite/intro` ⇒ **PaPersonnesFuiteIntroGpxSchool**
    - Disparitions inquiétantes → `/pa/dps_dpg/cadres_juridiques/disparitions_inquietantes_intro` ⇒ **PaDisparitionIntroPage**
- **Armes & munitions** — badge: _Régimes spéciaux_ — img `assets/images/armes_munitions.jpeg` — route `/pa/dps_dpg/socle_initial/armes_munitions` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - Classification des armes et des munitions → `/pa/dps_dpg/armes_munitions_pages/armes_classification` ⇒ **PaArmesClassificationPage**
    - Définitions → `/pa/dps_dpg/armes_munitions_pages/armes_definitions` ⇒ **PaArmesDefinitionsPage**
    - Introduction → `/pa/dps_dpg/armes_munitions_pages/armes_introduction` ⇒ **PaArmesIntroductionPage**
    - Acquisition/détention cat. A ou B sans autorisation → `/pa/dps_dpg/armes_munitions_pages/armes_acquisition_detention_ab` ⇒ **PaArmesAcquisitionDetentionABPage**
    - Port/transport sans motif légitime (cat. C ou D) → `/pa/dps_dpg/armes_munitions_pages/armes_port_transport_cd` ⇒ **PaArmesPortTransportCDPage**
    - Régimes matériels de guerre / éléments d’arme → `/pa/dps_dpg/armes_munitions_pages/armes_materiels_guerre_elements` ⇒ **PaArmesMaterielsGuerreElementsPage**
    - Règles d’acquisition & détention → `/pa/dps_dpg/armes_munitions_pages/armes_regles_acquisition_detention` ⇒ **PaArmesReglesAcquisitionDetentionPage**
    - Règles de port & transport → `/pa/dps_dpg/armes_munitions_pages/armes_regles_port_transport` ⇒ **PaArmesReglesPortTransportPage**
    - Quiz — Classification des armes et des munitions → `/pa/armes_munitions_pages/quiz/pa_quiz_armes_munitions_pages` (img `assets/images/quiz.jpeg`) ⇒ **QuizArmesMunitionsPA**
- **La sanction** — badge: _Peines & sûreté_ — img `assets/images/sanction.jpeg` — route `/pa/dps_dpg/sanctions` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - Classification des peines et mesures de sûreté → `/pa/dps_dpg/sanctions/classification_peines` ⇒ **PaClassificationPeinesPage**
    - Causes d’aggravation de la sanction → `/pa/dps_dpg/sanctions/causes_aggravation_sanction` ⇒ **PaCausesAggravationSanctionContenuPage**
    - Règles en cas de pluralité d’infractions → `/pa/dps_dpg/sanctions/pluralite_infractions` ⇒ **PaPluraliteInfractionsPage**
    - Quiz — Sanction (récidive, réitération, concours réel) → `/pa/sanction/quiz/sanction_page` ⇒ **QuizSanctionPA**
- **Crimes & délits contre la nation** — badge: _Institutions & justice_ — img `assets/images/contre_nation.jpeg` — route `/pa/dps_dpg/crimes_nation` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - Association de malfaiteurs → `/pa/dps_dpg/atteintes_nation_pages/association_malfaiteurs` ⇒ **PaAssociationMalfaiteursPage**
    - Abus d’autorité contre les particuliers → `/pa/dps_dpg/atteintes_nation_pages/abus_autorite` ⇒ **PaAbusAutoriteParticuliersContenuPage**
    - Atteintes à l’action de la justice → `/pa/dps_dpg/atteintes_nation_pages/atteintes_action_justice` ⇒ **PaAtteintesActionJusticeContenuPage**
    - Atteintes à l’administration par des particuliers → `/pa/dps_dpg/socle_initial/autorite_etat/outrage` ⇒ **PaAtteintesAdministrationContenuPage**
    - Faux et usage de faux → `/pa/dps_dpg/atteintes_nation_pages/faux_usage_faux` ⇒ **PaFauxUsageFauxContenuPage**
    - Manquements au devoir de probité → `/pa/dps_dpg/atteintes_nation_pages/probite` ⇒ **PaProbiteContenuPage**
    - Quiz — Abus d’autorité contre les particuliers → `/pa/nation/quiz/abus_autorite_particuliers` ⇒ **QuizAbusAutoritePA**
    - Quiz — Atteintes à l’action de la justice → `/pa/nation/quiz/atteintes_action_justice` ⇒ **QuizAtteinteActionJusticePA**
    - Quiz — Atteintes à l’administration → `/pa/nation/quiz/atteintes_administration` ⇒ **QuizAtteinteAdministrationPA**
    - Quiz — Faux et usage de faux → `/pa/nation/quiz/faux_usage_faux` ⇒ **QuizFauxUsageFauxPA**
    - Quiz — Manquements au devoir de probité → `/pa/nation/quiz/probite` ⇒ **QuizProbitePA**
- **Atteintes aux mineurs & à la famille** — badge: _Protection des mineurs_ — img `assets/images/mineurs_famille.jpeg` — route `/pa/dps_dpg/mineurs_famille` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - La mise en péril des mineurs → `/pa/dps_dpg/socle_initial/atteintes_personnes/mineurs_mise_en_peril` ⇒ **PaMiseEnPerilDesMineursPage**
    - Violation d’ordonnances JAF (violences) → `/pa/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf` ⇒ **PaViolationOrdonnancesJafPage**
    - Atteintes à l’exercice de l’autorité parentale → `/pa/dps_dpg/mineurs_famille_pages/autorite_parentale` ⇒ **PaAutoriteParentalePage**
    - L’abandon de famille → `/pa/dps_dpg/mineurs_famille_pages/abandon_famille` ⇒ **PaAbandonFamillePage**
    - Quiz — L’abandon de famille → `/pa/mineurs_famille_pages/quiz/pa_quiz_mineurs_famille` ⇒ **QuizMineursFamillePA**
- **Procédure Pénale** — badge: _Cours & cas pratiques_ — img `assets/images/procedure_penale.jpg` — route `/pa/dps_dpg/procedure_penale` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - Action publique, action civile, autorités & contrôle de la PJ → `/pa/dps_dpg/procedure_penale/pp_action_publique_action_civile_intro` ⇒ **PaActionPubliqueIntroPage**
    - Nullité des actes de procédure → `/pa/dps_dpg/procedure_penale/nullite_intro_page` ⇒ **PaNulliteIntroPage**
    - Juridictions de jugement & exécution des décisions → `/pa/dps_dpg/procedure_penale/juridictions_contenu` ⇒ **PaJuridictionContenuPage**
    - Instruction préparatoire, mandats, contrôle jud., détention provisoire → `/pa/dps_dpg/procedure_penale/pp_instruction_mandats_controle_detention` ⇒ **PaInstructionIntroPage**
    - Quiz — Action publique → `/pa/procedure_penale/quiz/action_publique` ⇒ **QuizActionPubliquePagePA**
    - Quiz — Nullité des actes de procédure → `/pa/procedure_penale/quiz/nullite` ⇒ **QuizNullitePagePA**
    - Quiz — Juridictions pénales → `/pa/procedure_penale/quiz/juridictions_penales` ⇒ **QuizJuridictionsPagePA**
    - Quiz — Instruction préparatoire, mandats & détention provisoire → `/pa/procedure_penale/quiz/instruction_preparatoire` ⇒ **QuizInstructionPagePA**
- **Contrôle d'identité** — badge: _Socle initial_ — img `assets/images/controle_identite.jpeg` — route `/pa/dps_dpg/socle_initial/controle_identite` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - Contrôles et vérifications d'identité → `/pa/dps_dpg/cadres_juridiques/controle_identite` ⇒ **PaControleIdentiteContenuPage**
- **Circulation routière** — badge: _Socle initial_ — img `assets/images/circulation_routiere.jpeg` — route `/pa/dps_dpg/socle_initial/circulation` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - Compétences des agents verbalisateurs → `/pa/dps_dpg/socle_initial/circulation/agents_verbalisateurs` (img `assets/images/agents_verbalisateurs.png`) ⇒ **AgentsVerbalisateursCirculationPage**
    - Conduite après usage de stupéfiants → `/pa/dps_dpg/socle_initial/circulation/conduite_stupefiants` ⇒ **PaConduiteStupefiantsPage**
    - Conduite en état d'ivresse → `/pa/dps_dpg/socle_initial/circulation/ivresse` ⇒ **PaIvressePage**
    - Conduite sous l'empire d'un état alcoolique → `/pa/dps_dpg/socle_initial/circulation/etat_alcoolique` ⇒ **PaEtatAlcooliquePage**
    - Défaut d'assurance → `/pa/dps_dpg/socle_initial/circulation/defaut_assurance` ⇒ **PaDefautAssurancePage**
    - Défaut de permis de conduire → `/pa/dps_dpg/socle_initial/circulation/defaut_permis` ⇒ **PaDefautPermisPage**
    - Délit de fuite → `/pa/dps_dpg/socle_initial/circulation/delit_fuite` ⇒ **PaDelitFuitePage**
    - Grand excès de vitesse → `/pa/dps_dpg/socle_initial/circulation/grand_exces_vitesse` ⇒ **PaGrandExcesVitessePage**
    - Refus de vérifications → `/pa/dps_dpg/socle_initial/circulation/refus_verifications` ⇒ **PaRefusVerificationsPage**
    - Refus d'obtempérer → `/pa/dps_dpg/socle_initial/circulation/refus_obtemperer` ⇒ **PaRefusObtempererPage**
    - Rodéo motorisé → `/pa/dps_dpg/socle_initial/circulation/rodeo_motorise` ⇒ **PaRodeoMotorisePage**
    - Plaques & inscriptions (délits liés) → `/pa/dps_dpg/socle_initial/circulation/plaques_inscriptions` ⇒ **PaPlaquesInscriptionsPage**
    - Incitation / organisation / promotion → `/pa/dps_dpg/socle_initial/circulation/incitation_organisation_promotion` (img `assets/images/incitation.png`) ⇒ **PaIncitationOrganisationPromotionPage**
    - Quiz — Infractions à la circulation routière → `/pa/dps_dpg/quiz/quiz_circulation_routiere` ⇒ **QuizCirculationRoutierePA**
- **Organisation judiciaire** — badge: _Socle initial_ — img `assets/images/cat_organisation.jpg` — route `/pa/dps_dpg/socle_initial/organisation_judiciaire` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - L’organisation judiciaire → `/pa/dps_dpg/socle_initial/organisation_judiciaire/organisation` ⇒ **PaOrganisationJudiciaireHubPage**
    - La magistrature → `/pa/dps_dpg/socle_initial/organisation_judiciaire/magistrature` (img `assets/images/magistrature.png`) ⇒ **JuridictionsPenalesPage**
- **Atteintes aux biens** — badge: _Socle initial_ — img `assets/images/atteintes_biens.jpeg` — route `/pa/dps_dpg/socle_initial/atteintes_biens` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - Le vol → `/pa/dps_dpg/socle_initial/atteintes_biens/vol` ⇒ **PaVolPage**
    - Destructions, dégradations, détériorations → `/pa/dps_dpg/socle_initial/atteintes_biens/destructions` ⇒ **PaDestructionsDegradationsContenuPage**
    - Infractions sans danger pour les personnes → `/pa/dps_dpg/socle_initial/atteintes_biens/sans_danger_personnes` ⇒ **PaSansDangerDommageLegerPage**
    - Infractions dangereuses pour les personnes → `/pa/dps_dpg/socle_initial/atteintes_biens/dangereuses_personnes` ⇒ **PaDestructionsDangereusesPersonnesIntentionnellePage**
    - Tags et graffitis → `/pa/dps_dpg/socle_initial/atteintes_biens/tags_graffitis` (img `assets/images/tags_graffitis.png`) ⇒ **PaTagsInscriptionsSignesDessinsPage**
- **Atteintes aux personnes** — badge: _Socle initial_ — img `assets/images/atteintes_personnes.jpeg` — route `/pa/dps_dpg/socle_initial/atteintes_personnes` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - Les discriminations → `/pa/dps_dpg/socle_initial/atteintes_personnes/discriminations` (img `assets/images/discriminations.png`) ⇒ **PaDiscriminationsPage**
    - Les violences volontaires → `/pa/dps_dpg/socle_initial/atteintes_personnes/violences_volontaires` ⇒ **PaAtteintesVolontairesIntegriteContenuPage**
    - Les violences habituelles → `/pa/dps_dpg/socle_initial/atteintes_personnes/violences_habituelles` ⇒ **PaViolencesHabituellesCoupleExPage**
    - Violences contre les forces de sécurité intérieure → `/pa/dps_dpg/socle_initial/atteintes_personnes/violences_fsi` (img `assets/images/violence_pdap.png`) ⇒ **PaViolencesSurFsiPage**
    - Atteintes volontaires à la vie → `/pa/dps_dpg/socle_initial/atteintes_personnes/atteintes_vie` ⇒ **PaAtteintesVolontairesVieContenuPage**
    - Le viol → `/pa/dps_dpg/socle_initial/atteintes_personnes/viol` ⇒ **PaViolIncesteAgressionsContenuPage**
    - Agressions sexuelles → `/pa/dps_dpg/socle_initial/atteintes_personnes/agressions_sexuelles` ⇒ **PaAgressionsSexuellesAutresQueViolPage**
    - Harcèlement sexuel → `/pa/dps_dpg/socle_initial/atteintes_personnes/harcelement_sexuel` ⇒ **PaHarcelementSexuelPage**
    - Exhibition sexuelle → `/pa/dps_dpg/socle_initial/atteintes_personnes/exhibition` ⇒ **PaExhibitionSexuellePage**
    - Mise en péril des mineurs → `/pa/dps_dpg/socle_initial/atteintes_personnes/mineurs_mise_en_peril` ⇒ **PaMiseEnPerilDesMineursPage**
    - Atteinte à l’intimité d’une personne → `/pa/dps_dpg/socle_initial/atteintes_personnes/atteinte_intimite` ⇒ **PaAtteintePersonnaliteContenuPage**
    - Outrage sexiste et sexuel → `/pa/dps_dpg/socle_initial/atteintes_personnes/outrage_sexiste` (img `assets/images/outrage_sexiste.png`) ⇒ **PaOutrageSexistePage**
- **Autorité de l’État** — badge: _Socle initial_ — img `assets/images/autorite_etat.png` — route `/pa/dps_dpg/socle_initial/autorite_etat` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - Refus d’obtempérer → `/pa/dps_dpg/socle_initial/autorite_etat/refus_obtemperer` (img `assets/images/refus_obtemperer_pn.png`) ⇒ **PaRefusObtempererPage**
    - L’outrage → `/pa/dps_dpg/socle_initial/autorite_etat/outrage` (img `assets/images/outrage_pn.png`) ⇒ **PaAtteintesAdministrationContenuPage**
    - La rébellion → `/pa/dps_dpg/socle_initial/autorite_etat/rebellion` (img `assets/images/rebellion_pn.png`) ⇒ **PaRebellionPage**
    - Provocation directe à la rébellion → `/pa/dps_dpg/socle_initial/autorite_etat/provocation_rebellion` (img `assets/images/provocation_rebellion_pn.png`) ⇒ **PaProvocationDirecteRebellionPage**
- **Généralités** — badge: _Socle avancé_ — img `assets/images/droit_penal_general.jpeg` — route `/pa/dps_dpg/socle_avance/generalites` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - Le droit pénal → `/pa/dps_dpg/socle_avance/generalites/droit_penal` (img `assets/images/droit_penal_generalite.png`) ⇒ **PaLoiPenaleContenuPage**
    - Immunités et inviolabilités → `/pa/dps_dpg/socle_avance/generalites/immunites_inviolabilites` (img `assets/images/immunite.png`) ⇒ **PaGPXSchoolEtendueApplicationLoisPage**
    - La responsabilité pénale → `/pa/dps_dpg/socle_avance/generalites/responsabilite_penale` (img `assets/images/responsabilite_penale.png`) ⇒ **PaResponsabilitePenalePage**
- **Acteurs de la Police Judiciaire** — badge: _Socle avancé_ — img `assets/images/police_judiciaire.png` — route `/pa/dps_dpg/socle_avance/acteurs_pj` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - Compétences des OPJ → `/pa/dps_dpg/socle_avance/acteurs_pj/opj` (img `assets/images/opj.png`) ⇒ **HierarchieOpjPage**
    - Compétences des APJ → `/pa/dps_dpg/socle_avance/acteurs_pj/apj` (img `assets/images/gardien_de_la_paix.png`) ⇒ **HierarchieApjPage**
    - Assistants d’enquête → `/pa/dps_dpg/socle_avance/acteurs_pj/assistants_enquete` (img `assets/images/assistant_enquete.png`) ⇒ **HierarchieAssistantsEnquetePage**
    - Prérogatives judiciaires (OPJ / APJ / APJA) → `/pa/dps_dpg/socle_avance/acteurs_pj/prerogatives` (img `assets/images/prerogative.png`) ⇒ **PaAutoriteInvestiesLoiPage**
    - Le procureur de la République → `/pa/dps_dpg/socle_avance/acteurs_pj/procureur` (img `assets/images/procureur.png`) ⇒ **PaPPOrganisationMinisterePublicContenuPage**
    - Le juge d’instruction → `/pa/dps_dpg/socle_avance/acteurs_pj/juge_instruction` (img `assets/images/juge_instruction.png`) ⇒ **JugeInstructionPage**
- **Atteintes aux biens** — badge: _Socle avancé_ — img `assets/images/atteintes_biens.jpeg` — route `/pa/dps_dpg/socle_avance/atteintes_biens` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - L’extorsion → `/pa/dps_dpg/socle_avance/atteintes_biens/extorsion` (img `assets/images/extorsion.png`) ⇒ **PaExtorsionPage**
    - L’escroquerie → `/pa/dps_dpg/socle_avance/atteintes_biens/escroquerie` (img `assets/images/escroquerie.png`) ⇒ **PaEscroqueriePage**
    - L’abus de confiance → `/pa/dps_dpg/socle_avance/atteintes_biens/abus_confiance` (img `assets/images/abus_confiance.png`) ⇒ **PaAbusDeConfiancePage**
    - La filouterie → `/pa/dps_dpg/socle_avance/atteintes_biens/filouterie` (img `assets/images/filouterie.png`) ⇒ **PaFilouteriesPage**
    - Le recel → `/pa/dps_dpg/socle_avance/atteintes_biens/recel` (img `assets/images/recel_vol.png`) ⇒ **PaRecelPage**
    - Abstention volontaire de combattre un sinistre → `/pa/dps_dpg/socle_avance/atteintes_biens/abstention_sinistre` (img `assets/images/abstention_volontaire.png`) ⇒ **PaAtteintesVolontairesIntegriteContenuPage**
- **Atteintes aux personnes** — badge: _Socle avancé_ — img `assets/images/contre_personne.jpeg` — route `/pa/dps_dpg/socle_avance/atteintes_personnes` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - Atteintes involontaires à la vie et à l’intégrité → `/pa/dps_dpg/socle_avance/atteintes_personnes/involontaires` (img `assets/images/atteintes_involontaires.png`) ⇒ **PaAtteintesInvolontairesContenuPage**
    - Menaces contre les personnes → `/pa/dps_dpg/socle_avance/atteintes_personnes/menaces` (img `assets/images/menaces.png`) ⇒ **PaMenaceSansConditionPage**
    - Entrave volontaire à l’arrivée des secours → `/pa/dps_dpg/socle_avance/atteintes_personnes/entrave_secours` (img `assets/images/entrave_secours.png`) ⇒ **PaMiseEnDangerContenuPage**
    - Non-obstacle à la commission d’un crime ou délit → `/pa/dps_dpg/socle_avance/atteintes_personnes/non_obstacle` (img `assets/images/non_obstacle.png`) ⇒ **PaNonObstacleCommissionCrimeDelitPage**
    - Non-assistance à personne en péril → `/pa/dps_dpg/socle_avance/atteintes_personnes/non_assistance` (img `assets/images/non_assistance.png`) ⇒ **PaNonAssistancePersonnePerilPage**
    - Appels téléphoniques malveillants → `/pa/dps_dpg/socle_avance/atteintes_personnes/appels_malveillants` (img `assets/images/appels_malveillants.png`) ⇒ **PaAppelsMessagesMalveillantsAgressionsSonoresPage**
    - Risque causé à autrui → `/pa/dps_dpg/socle_avance/atteintes_personnes/risque_autrui` (img `assets/images/risque_autrui.png`) ⇒ **PaRisqueCauseAutruiPage**
- **Délits routiers** — badge: _Socle avancé_ — img `assets/images/circulation_routiere.jpeg` — route `/pa/dps_dpg/socle_avance/delits_routiers` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - Rodéo motorisé → `/pa/dps_dpg/socle_avance/delits_routiers/rodeo` ⇒ **PaRodeoMotorisePage**
    - Incitation / organisation / promotion → `/pa/dps_dpg/socle_avance/delits_routiers/incitation` (img `assets/images/incitation.png`) ⇒ **PaIncitationOrganisationPromotionPage**
    - Délit de fuite → `/pa/dps_dpg/socle_avance/delits_routiers/delit_fuite` ⇒ **PaDelitFuitePage**
    - Refus d’obtempérer → `/pa/dps_dpg/socle_avance/delits_routiers/refus_obtemperer` (img `assets/images/refus_obtemperer.png`) ⇒ **PaRefusObtempererPage**
    - Autres délits routiers (alcool, stup, permis, vérifications…) → `/pa/dps_dpg/socle_avance/delits_routiers/autres` (img `assets/images/autres_delits_routiers.png`) ⇒ **PaEtatAlcooliquePage**
- **Autorité de l’État** — badge: _Socle avancé_ — img `assets/images/autorite_etat.png` — route `/pa/dps_dpg/socle_avance/autorite_etat` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - Menaces envers les dépositaires de l’autorité publique → `/pa/dps_dpg/socle_avance/autorite_etat/menaces` (img `assets/images/menaces_pdap.png`) ⇒ **PaMenacesEnversDepositaireAutoritePage**
    - Corruption passive → `/pa/dps_dpg/socle_avance/autorite_etat/corruption_passive` (img `assets/images/corruption_passive.png`) ⇒ **PaCorruptionPage**
    - Corruption active → `/pa/dps_dpg/socle_avance/autorite_etat/corruption_active` (img `assets/images/corruption_active.png`) ⇒ **PaCorruptionPage**
- **Stupéfiants** — badge: _Socle avancé_ — img `assets/images/stupefiants.jpeg` — route `/pa/dps_dpg/socle_avance/stupefiants` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - Usage illicite de stupéfiants → `/pa/dps_dpg/socle_avance/stupefiants/usage_illicite` ⇒ **PaStupefiantsUsageIllicitePage**
    - Cession / offre illicites (consommation personnelle) → `/pa/dps_dpg/socle_avance/stupefiants/cession_offre` ⇒ **PaStupefiantsCessionOffrePage**

#### PaSchoolProgram.mememtoCirculationRoutiere
- **Procédures circulation routière** — badge: _Procédures_ — img `assets/images/memento_procedures.jpeg` — route `/pa/memento_circulation/procedures` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - L’amende forfaitaire → `/pa/memento_circulation/procedures/amende_forfaitaire` (img `assets/images/amende_forfaitaire.jpeg`) ⇒ **AmendeForfaitairePage**
    - L’amende forfaitaire délictuelle → `/pa/memento_circulation/procedures/amende_forfaitaire_delictuelle` (img `assets/images/amende_forfaitaire_delictuelle.jpeg`) ⇒ **AmendeForfaitaireDelictuellePage**
    - La consignation → `/pa/memento_circulation/procedures/consignation` (img `assets/images/consignation.jpeg`) ⇒ **ConsignationPage**
    - L’immobilisation du véhicule → `/pa/memento_circulation/procedures/immobilisation` (img `assets/images/immobilisation.jpeg`) ⇒ **ImmobilisationPage**
    - La mise en fourrière → `/pa/memento_circulation/procedures/mise_en_fourriere` (img `assets/images/mise_en_fourriere.jpeg`) ⇒ **MiseEnFourrierePage**
    - La conduite sous l’influence de l’alcool → `/pa/memento_circulation/procedures/conduite_alcool` (img `assets/images/ivresse.jpeg`) ⇒ **ConduiteAlcoolPage**
    - La conduite après usage de stupéfiants → `/pa/memento_circulation/procedures/conduite_stupefiants` (img `assets/images/stupefiants.jpeg`) ⇒ **ConduiteApresUsageStupefiantsPage**
    - La rétention du permis de conduire → `/pa/memento_circulation/procedures/retention_permis` (img `assets/images/retention_permis.jpeg`) ⇒ **RetentionPermisConduirePage**
    - Le permis à points → `/pa/memento_circulation/procedures/permis_a_points` (img `assets/images/permis_points.jpeg`) ⇒ **PermisAPointsPage**
    - Quiz — Procédures circulation → `/pa/memento_circulation/procedures/quiz` (img `assets/images/quiz.jpeg`) ⇒ **QuizScolariteDynamiquePage**
- **Contrôle routier & pièces** — badge: _Contrôle_ — img `assets/images/memento_controle_routier.jpeg` — route `/pa/memento_circulation/controle_routier` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - Le cadre légal du contrôle routier → `/pa/memento_circulation/controle_routier/cadre_legal` (img `assets/images/cadres_juridiques.jpeg`) ⇒ **CadreLegalControleRoutierPage**
    - Le permis de conduire → `/pa/memento_circulation/controle_routier/permis_conduire` (img `assets/images/permis_conduire.jpeg`) ⇒ **PermisConduirePage**
    - Le brevet de sécurité routière → `/pa/memento_circulation/controle_routier/bsr` (img `assets/images/bsr.jpeg`) ⇒ **BsrPage**
    - Les certificats d’immatriculation → `/pa/memento_circulation/controle_routier/certificat_immatriculation` (img `assets/images/certificat_immatriculation.jpeg`) ⇒ **CertificatImmatriculationPage**
    - Le contrôle technique des véhicules → `/pa/memento_circulation/controle_routier/controle_technique` (img `assets/images/controle_technique.jpeg`) ⇒ **ControleTechniquePage**
    - L’assurance → `/pa/memento_circulation/controle_routier/assurance_obligatoire` (img `assets/images/assurance_obligatoire.jpeg`) ⇒ **AssuranceObligatoirePage**
    - Quiz — Contrôle routier → `/pa/memento_circulation/controle_routier/quiz` (img `assets/images/quiz.jpeg`) ⇒ **QuizScolariteDynamiquePage**
- **Équipements véhicules & usagers** — badge: _Équipements_ — img `assets/images/memento_equipements.jpeg` — route `/pa/memento_circulation/equipements` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - Les pneumatiques → `/pa/memento_circulation/equipements/pneumatiques` (img `assets/images/pneumatiques.jpeg`) ⇒ **PneumatiquesPage**
    - Éclairage et signalisation → `/pa/memento_circulation/equipements/eclairage_signalisation` (img `assets/images/eclairage_signalisation.jpeg`) ⇒ **EclairageSignalisationPage**
    - Chargement → `/pa/memento_circulation/equipements/chargement` (img `assets/images/chargement.jpeg`) ⇒ **ChargementPage**
    - Les plaques → `/pa/memento_circulation/equipements/plaques` (img `assets/images/plaques.jpeg`) ⇒ **PlaquesPage**
    - Miroirs / rétroviseurs / vision indirecte → `/pa/memento_circulation/equipements/retroviseurs_vision` (img `assets/images/retroviseurs.jpeg`) ⇒ **RetroviseursVisionPage**
    - Les essuie-glace → `/pa/memento_circulation/equipements/essuie_glace` (img `assets/images/essuie_glace.jpeg`) ⇒ **EssuieGlacePage**
    - Nuisances des véhicules (fumées, bruit, avertisseur sonore) → `/pa/memento_circulation/equipements/nuisances` (img `assets/images/nuisances.jpeg`) ⇒ **NuisancesVehiculesPage**
    - Ceinture de sécurité / retenue enfant → `/pa/memento_circulation/equipements/ceinture_retenue_enfant` (img `assets/images/ceinture_retenue_enfant.jpeg`) ⇒ **CeintureRetenueEnfantPage**
    - Casque et gants de protection → `/pa/memento_circulation/equipements/casque_gants` (img `assets/images/casque_gants.jpeg`) ⇒ **CasqueGantsPage**
    - Casque "cycliste" → `/pa/memento_circulation/equipements/casque_cycliste` (img `assets/images/casque_cycliste.jpeg`) ⇒ **CasqueCyclistePage**
    - Gilet de haute visibilité → `/pa/memento_circulation/equipements/gilet_haute_visibilite` (img `assets/images/gilet_haute_visibilite.jpeg`) ⇒ **GiletHauteVisibilitePage**
    - Quiz — Équipements → `/pa/memento_circulation/equipements/quiz` (img `assets/images/quiz.jpeg`) ⇒ **QuizScolariteDynamiquePage**


### 7.4 GPX Scolarité (`gpxSchoolCategoriesConfig`)

#### GpxSchoolProgram.institutionValeurs
- **Formation initiale** — badge: _Bases & méthodo_ — img `assets/images/copic_institutions.jpg` — route `/gpx/institution/formation_initiale` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - La formation initiale → `/gpx/institution/formation_initiale/formation` (img `assets/images/copic_institutions.jpg`) ⇒ **GpxFormationInitialeFormationPage**
    - Mémento prise de notes & méthodologie → `/gpx/institution/formation_initiale/memento_notes` (img `assets/images/concours_connaissances_generales.jpeg`) ⇒ **GpxMementoPriseDeNoteMethodologiePage**
- **Organisation de la Police Nationale** — badge: _Structures & rôles_ — img `assets/images/background.jpeg` — route `/gpx/institution/organisation_pn` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - Organigramme du Ministère de l’Intérieur → `/gpx/institution/organisation_pn/organigramme_mi` (img `assets/images/organigramme_mi.jpeg`) ⇒ **OrganigrammeMinistereInterieurPage**
    - Organisation & Direction de la Police Nationale → `/gpx/institution/organisation_pn/organisation` ⇒ **OrganisationPoliceNationalePage**
    - Direction générale de la sécurité intérieure → `/gpx/institution/organisation_pn/dgsi` (img `assets/images/dgsi.jpeg`) ⇒ **DgsiPage**
    - Préfecture de police → `/gpx/institution/organisation_pn/prefecture_police` (img `assets/images/prefecture_police.jpeg`) ⇒ **PrefecturePolicePage**
    - Organigrammes → `/gpx/institution/organisation_pn/organigrammes` ⇒ **OrganigrammesPnPage**
    - Hiérarchie des personnels de la Police Nationale → `/gpx/institution/organisation_pn/hierarchie` (img `assets/images/hierarchie_police.jpeg`) ⇒ **HierarchiePnPage**
    - Règles d’emploi des policiers adjoints → `/gpx/institution/organisation_pn/regles_emploi_pa` (img `assets/images/regles_emploi_pa.jpeg`) ⇒ **ReglesEmploiPaPage**
    - Horaires de service en sécurité publique → `/gpx/institution/organisation_pn/horaires_service_sp` (img `assets/images/horaires_service_sp.jpeg`) ⇒ **HorairesServiceSpPage**
    - Quiz — Organisation (global) → `/gpx/institution/organisation_pn/quiz` (img `assets/images/quiz.jpeg`) ⇒ **QuizOrganisationPnGPX**
- **Déontologie** — badge: _Éthique & cadre_ — img `assets/images/cat_organisation.jpg` — route `/gpx/institution/deontologie` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - Code de déontologie commenté (PN & GN) → `/gpx/institution/deontologie/code_commente` (img `assets/images/code_commente.webp`) ⇒ **CodeDeontologieCodeCommentePage**
    - Marques extérieures de respect (salut, présentation) → `/gpx/institution/deontologie/marques_respect` (img `assets/images/marques_respect.jpeg`) ⇒ **MarquesExterieuresRespectPage**
    - Droits & obligations des policiers → `/gpx/institution/deontologie/droits_obligations` ⇒ **DroitsObligationsPoliciersPage**
    - Policier hors service : dois-je intervenir ? (AMARIS) → `/gpx/institution/deontologie/hors_service_amaris` (img `assets/images/hors_service_amaris.jpeg`) ⇒ **HorsServiceAmarisPage**
    - Sanctions & récompenses → `/gpx/institution/deontologie/sanctions_recompenses` (img `assets/images/sanction.jpeg`) ⇒ **SanctionsRecompensesPage**
    - Enquête administrative → `/gpx/institution/deontologie/enquete_administrative` ⇒ **EnqueteAdministrativePage**
    - Usage des réseaux sociaux → `/gpx/institution/deontologie/reseaux_sociaux` (img `assets/images/reseaux_sociaux.jpg`) ⇒ **ReseauxSociauxPage**
    - Quiz — Déontologie → `/gpx/institution/deontologie/quiz` (img `assets/images/quiz.jpeg`) ⇒ **QuizDeontologieGPX**
- **Information de la hiérarchie** — badge: _Écrits pro_ — img `assets/images/cat_hierarchie.jpg` — route `/gpx/institution/hierarchie_info` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - Le compte-rendu → `/gpx/institution/hierarchie_info/compte_rendu` (img `assets/images/compte_rendu.jpeg`) ⇒ **CompteRenduPage**
    - Le formalisme du rapport → `/gpx/institution/hierarchie_info/formalisme_rapport` (img `assets/images/formalisme_rapport.jpeg`) ⇒ **FormalismeRapportPage**
    - Modèles de rapports → `/gpx/institution/hierarchie_info/modeles` (img `assets/images/modeles.jpeg`) ⇒ **ModelesRapportsPage**
- **Accueil du public** — badge: _Victimes & assistance_ — img `assets/images/image1.jpeg` — route `/gpx/institution/accueil_public` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - Charte de l’accueil du public & assistance aux victimes → `/gpx/institution/accueil_public/charte` (img `assets/images/charte.jpeg`) ⇒ **CharteAccueilPublicVictimesPage**
    - Référentiel Marianne → `/gpx/institution/accueil_public/marianne` (img `assets/images/marianne.jpg`) ⇒ **ReferentielMariannePage**
    - Dépliants & doctrine accueil / prise en charge → `/gpx/institution/accueil_public/doctrine` (img `assets/images/doctrine.jpeg`) ⇒ **GpxDoctrineAccueilVictimesVcPage**
    - Quelques démarches administratives → `/gpx/institution/accueil_public/demarches` ⇒ **DemarchesAdministrativesPage**
    - Protection des locaux de police → `/gpx/institution/accueil_public/protection_locaux` (img `assets/images/protection_locaux.jpeg`) ⇒ **ProtectionLocauxPolicePage**
    - Quiz — Accueil du public → `/gpx/institution/accueil_public/quiz` (img `assets/images/quiz.jpeg`) ⇒ **QuiAccueilGpx**
- **Laïcité, police et religions** — badge: _Neutralité_ — img `assets/images/image6.jpg` — route `/gpx/institution/laicite` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - La laïcité (DLPAJ / bureau des cultes) → `/gpx/institution/laicite/laicite_dlpaj` (img `assets/images/laicite_dlpaj.jpeg`) ⇒ **GpxLaiciteDlpajPage**
    - Charte de la laïcité dans les services publics → `/gpx/institution/laicite/charte` (img `assets/images/charte_laicite.jpeg`) ⇒ **CharteLaiciteServicesPublicsPage**
    - Principaux rites & pratiques des cultes en France → `/gpx/institution/laicite/rites_cultes` (img `assets/images/rites_cultes.jpeg`) ⇒ **RitesCultesFrancePage**
- **Histoire de la police** — badge: _Repères_ — img `assets/images/image4.jpeg` — route `/gpx/institution/histoire` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - Points de repères chronologiques → `/gpx/institution/histoire/reperes` ⇒ **HistoireReperesPage**

#### GpxSchoolProgram.dpsDpg
- **Généralités** — badge: _Concepts de base_ — img `assets/images/generalite.jpeg` — route `/gpx_scolarite_pages/generalite_pages` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - Classification des infractions → `/gpx/generalites/classification_infractions` ⇒ **ClassificationInfractionsPage**
    - L\'infraction → `/gpx/generalites/infraction_intro` ⇒ **InfractionIntroPage**
    - La tentative punissable → `/gpx/generalites/tentative_intro` ⇒ **TentativeIntroPage**
    - La complicité → `/gpx/generalites/complicite_intro` ⇒ **CompliciteIntroPage**
    - La légitime défense → `/gpx/generalites/legitimedefense_intro` ⇒ **LegitimeDefenseIntroPage**
    - Cadre légal d\'usage des armes → `/gpx/generalites/usagedesarmes_intro` ⇒ **UsageArmesIntroPage**
    - Les libertés publiques → `/gpx/generalites/libertespubliques_intro` ⇒ **LibertesPubliquesIntroPage**
    - Cas de rétention dans les locaux de police → `/gpx/generalites/retention_locaux_police_intro` ⇒ **RetentionLocauxIntroPage**
    - La hiérarchie des personnels de la Police Nationale : Fonctions judiciaires → `/gpx/generalites/hierarchie_intro` ⇒ **HierarchieIntroPage**
    - Quiz généralités, classification des infractions, infraction, tentative punissable etc.. → `/gpx/procedure_penale/quiz/generalité_principales` ⇒ **QuizGeneralitePage**
- **Cadres juridiques** — badge: _Cadres d\'enquête_ — img `assets/images/cadres_juridiques.jpeg` — route `/gpx_scolarite_pages/cadres_juridiques_pages` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - Les cadres d\'enquête → `/gpx/generalites/cadres_enquete_intro` ⇒ **CadresEnqueteIntroPage**
    - L’enquête de flagrant délit → `/gpx/generalites/flagrant_delit_intro` ⇒ **FlagrantDelitIntroPage**
    - L’enquête préliminaire → `/gpx/generalites/enquete_preliminaire_intro` ⇒ **EnquetePreliminaireIntroPage**
    - La commission rogatoire → `/gpx/generalites/commission_rogatoire_intro` ⇒ **CommissionRogatoireIntroPage**
    - Découverte d’une personne grièvement blessée → `/gpx/generalites/personne_blessee_intro` ⇒ **PersonneBlesseGrievementntroPage**
    - Mort de cause inconnue ou suspecte → `/gpx/generalites/mort_inconnue_intro` ⇒ **MortInconnueIntroductionPage**
    - Délinquance & criminalité organisées → `/gpx/generalites/criminalite_deliquance_intro` ⇒ **CriminaliteDeliquanceIntroPage**
    - Recherche des personnes en fuite → `/gpx/generalites/personnes_fuite_intro` ⇒ **PersonnesFuiteIntroPage**
    - Disparitions inquiétantes → `/gpx/cadres_juridiques/disparitions_inquietantes_intro` ⇒ **DisparitionIntroPage**
    - Contrôles et vérifications d’identité → `/gpx/generalites/flagrant_delit_intro` ⇒ **FlagrantDelitIntroPage**
    - Entraide judiciaire internationale → `/gpx/generalites/entraide_judiciaire_intro` ⇒ **EntraideJudiciaireIntroPage**
    - Quiz cadres juridiques, les cadres d\'enquête, l\'enquête de flagrant délit etc.. → `/gpx/procedure_penale/quiz/cadres_juridiques_principales` ⇒ **QuizCadresPrincipalesPage**
- **Procédure Pénale** — badge: _Cours & cas pratiques_ — img `assets/images/procedure_penale.jpg` — route `/gpx_scolarite_pages/procédure_pénale_pages` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - Action publique, action civile, autorités & contrôle de la PJ → `/gpx_scolarite_pages/procédure_pénale_pages/pp_action_publique_autorites_pj` ⇒ **PPActionPubliqueAutoritesPJPage**
    - Nullité des actes de procédure → `/gpx_scolarite_pages/procédure_pénale_pages/nullite_intro_page` ⇒ **NulliteIntroPage**
    - Juridictions de jugement & exécution des décisions → `/gpx_scolarite_pages/procédure_pénale_pages/juridictions_intro` ⇒ **JuridictionIntroPage**
    - Instruction préparatoire, mandats, contrôle jud., détention provisoire → `/gpx_scolarite_pages/procédure_pénale_pages/pp_instruction_mandats_controle_detention` ⇒ **InstructionIntroPage**
    - Quiz instruction préparatoire, mandats & détention provisoire → `/gpx/procedure_penale/quiz/instruction_preparatoire` ⇒ **QuizInstructionPage**
- **Droit pénal général** — badge: _Loi & responsabilité_ — img `assets/images/droit_penal_general.jpeg` — route `/gpx_scolarite_pages/droit_pénale_général_pages` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - De la loi pénale → `/gpx_scolarite_pages/droit_pénale_général_pages/loi_penale` ⇒ **LoiPenaleContenuPage**
    - De la responsabilité pénale → `/gpx_scolarite_pages/droit_pénale_général_pages/responsabilite_penale` ⇒ **ResponsabilitePenaleContenuPage**
- **La sanction** — badge: _Peines & sûreté_ — img `assets/images/sanction.jpeg` — route `/gpx_scolarite_pages/sanction_pages` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - Classification des peines et mesures de sûreté → `/gpx_scolarite_pages/sanction_pages/classification_peines` ⇒ **ClassificationPeinesContenuPage**
    - Causes d’aggravation de la sanction → `/gpx_scolarite_pages/sanction_pages/causes_aggravation_sanction` ⇒ **CausesAggravationSanctionContenuPage**
    - Règles en cas de pluralité d’infractions → `/gpx_scolarite_pages/sanction_pages/pluralite_infractions` ⇒ **PluraliteInfractionsContenuPage**
    - Quiz — Sanction  (récidive, réitération, concours réel) → `/gpx/sanction/quiz/sanction_page` ⇒ **QuizSanction**
- **Crimes & délits contre la personne** — badge: _Atteintes aux personnes_ — img `assets/images/contre_personne.jpeg` — route `/gpx_scolarite_pages/crime_delit_contre_personne_pages` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - La mise en danger de la personne → `/gpx_scolarite_pages/crime_delit_contre_personne_pages/mise_en_danger` ⇒ **MiseEnDangerContenuPage**
    - Le viol, l’inceste et autres agressions sexuelles → `/gpx_scolarite_pages/crime_delit_contre_personne_pages/viol_inceste_agressions/avertissement` ⇒ **ViolIncesteAgressionsAvertissementPage**
    - L’enlèvement et la séquestration → `/gpx_scolarite_pages/crime_delit_contre_personne_pages/enlevement_sequestration` ⇒ **EnlevementSequestrationPage**
    - Enregistrement & diffusion d’images → `/gpx_scolarite_pages/crime_delit_contre_personne_pages/enregistrement_diffusion_images` ⇒ **EnregistrementDiffusionImagesContenuPage**
    - Atteintes à la dignité de la personne → `/gpx_scolarite_pages/crime_delit_contre_personne_pages/dignite_personne` ⇒ **DignitePersonneContenuPage**
    - Atteintes à la personnalité → `/gpx_scolarite_pages/crime_delit_contre_personne_pages/personnalite` ⇒ **AtteintePersonnaliteContenuPage**
    - Atteintes involontaires à la vie et à l’intégrité → `/gpx_scolarite_pages/crime_delit_contre_personne_pages/atteintes_involontaires` ⇒ **AtteintesInvolontairesContenuPage**
    - Atteintes volontaires à la vie → `/gpx_scolarite_pages/crime_delit_contre_personne_pages/atteintes_volontaires_vie` ⇒ **AtteintesVolontairesVieContenuPage**
    - Atteintes volontaires à l’intégrité physique → `/gpx_scolarite_pages/crime_delit_contre_personne_pages/atteintes_volontaires_integrite` ⇒ **AtteintesVolontairesIntegriteContenuPage**
    - Quiz — Crimes & délits contre la personne → `/gpx/crimes_personne/quiz/crimes_delits_personne` ⇒ **QuizCrimeDelitsPersonne**
- **Atteintes aux mineurs & à la famille** — badge: _Protection des mineurs_ — img `assets/images/mineurs_famille.jpeg` — route `/gpx_scolarite_pages/mineurs_famille_pages` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - La mise en péril des mineurs → `/gpx_scolarite_pages/mineurs_famille_pages/mise_en_peril` ⇒ **MiseEnPerilDesMineursPage**
    - Violation d’ordonnances JAF (violences) → `/gpx_scolarite_pages/mineurs_famille_pages/violation_ordonnances_jaf` ⇒ **ViolationOrdonnancesJafPage**
    - Atteintes à l’exercice de l’autorité parentale → `/gpx_scolarite_pages/mineurs_famille_pages/autorite_parentale` ⇒ **AutoriteParentalePage**
    - L’abandon de famille → `/gpx_scolarite_pages/mineurs_famille_pages/abandon_famille` ⇒ **AbandonFamillePage**
    - Quiz — L’abandon de famille → `/gpx/mineurs_famille_pages/quiz/quiz_mineurs_famille` ⇒ **QuizMineursFamille**
- **Crimes & délits contre la nation** — badge: _Institutions & justice_ — img `assets/images/contre_nation.jpeg` — route `/gpx_scolarite_pages/crime_delit_nation_pages` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - Association de malfaiteurs → `/gpx_scolarite_pages/crime_delit_nation_pages/association_malfaiteurs` ⇒ **AssociationMalfaiteursPage**
    - Abus d’autorité contre les particuliers → `/gpx_scolarite_pages/crime_delit_nation_pages/abus_autorite` ⇒ **AbusAutoriteParticuliersContenuPage**
    - Atteintes à l’action de la justice → `/gpx_scolarite_pages/crime_delit_nation_pages/atteintes_action_justice` ⇒ **AtteintesActionJusticeContenuPage**
    - Atteintes à l’administration par des particuliers → `/gpx_scolarite_pages/crime_delit_nation_pages/atteintes_administration` ⇒ **AtteintesAdministrationContenuPage**
    - Faux et usage de faux → `/gpx_scolarite_pages/crime_delit_nation_pages/faux_usage_faux` ⇒ **FauxUsageFauxContenuPage**
    - Manquements au devoir de probité → `/gpx_scolarite_pages/crime_delit_nation_pages/probite` ⇒ **ProbiteContenuPage**
    - Quiz — Crimes & délits contre la nation → `/gpx/crime_delit_nation_pages/quiz/quiz_crimes_delits_nation` ⇒ **QuizCrimesDelitsNation**
- **Crimes & délits contre les biens** — badge: _Atteintes aux biens_ — img `assets/images/contre_biens.jpeg` — route `/gpx_scolarite_pages/crime_delit_bien_pages` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - Recel & non-justification de ressources → `/gpx_scolarite_pages/crime_delit_bien_pages/recel_non_justification` ⇒ **RecelNonJustificationContenuPage**
    - Le vol → `/gpx_scolarite_pages/crime_delit_bien_pages/vol` ⇒ **VolPage**
    - Atteintes aux STAD (informatique) → `/gpx_scolarite_pages/crime_delit_bien_pages/stad` ⇒ **StadContenuPage**
    - Contrefaçons & falsifications de chèques → `/gpx_scolarite_pages/crime_delit_bien_pages/contrefacons_falsifications` ⇒ **ContrefaconsFalsificationsChequesPage**
    - Destructions, dégradations, détériorations → `/gpx_scolarite_pages/crime_delit_bien_pages/destructions_degradations` ⇒ **DestructionsDegradationsContenuPage**
    - Infractions voisines du vol → `/gpx_scolarite_pages/crime_delit_bien_pages/voisines_du_vol` ⇒ **VoisinesDuVolContenuPage**
    - Quiz — Crimes & délits contre les biens → `/gpx/crime_delit_nation_pages/quiz/quiz_crimes_delits_bien` ⇒ **QuizCrimesDelitsBiens**
- **Infractions à la circulation routière** — badge: _Code de la route_ — img `assets/images/circulation_routiere.jpeg` — route `/gpx_scolarite_pages/infraction_circulation_routière_pages` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - Conduite après usage de stupéfiants → `/gpx_scolarite_pages/infraction_circulation_routière_pages/conduite_stupefiants` ⇒ **ConduiteStupefiantsPage**
    - Conduite en état d’ivresse → `/gpx_scolarite_pages/infraction_circulation_routière_pages/ivresse` ⇒ **IvressePage**
    - Conduite sous l’empire d’un état alcoolique → `/gpx_scolarite_pages/infraction_circulation_routière_pages/etat_alcoolique` ⇒ **EtatAlcooliquePage**
    - Défaut d’assurance → `/gpx_scolarite_pages/infraction_circulation_routière_pages/defaut_assurance` ⇒ **DefautAssurancePage**
    - Défaut de permis de conduire → `/gpx_scolarite_pages/infraction_circulation_routière_pages/defaut_permis` ⇒ **DefautPermisPage**
    - Délit de fuite → `/gpx_scolarite_pages/infraction_circulation_routière_pages/delit_fuite` ⇒ **DelitFuitePage**
    - Grand excès de vitesse → `/gpx_scolarite_pages/infraction_circulation_routière_pages/grand_exces_vitesse` ⇒ **GrandExcesVitessePage**
    - Refus de vérifications → `/gpx_scolarite_pages/infraction_circulation_routière_pages/refus_verifications` ⇒ **RefusVerificationsPage**
    - Refus d’obtempérer → `/gpx_scolarite_pages/infraction_circulation_routière_pages/refus_obtemperer` ⇒ **RefusObtempererPage**
    - Rodéo motorisé → `/gpx_scolarite_pages/infraction_circulation_routière_pages/rodeo_motorise` ⇒ **RodeoMotorisePage**
    - Plaques & inscriptions (délits liés) → `/gpx_scolarite_pages/infraction_circulation_routière_pages/plaques_inscriptions` ⇒ **PlaquesInscriptionsPage**
    - Incitation / organisation / promotion → `/gpx_scolarite_pages/infraction_circulation_routière_pages/incitation_organisation_promotion` ⇒ **IncitationOrganisationPromotionPage**
    - Quiz — Infractions à la circulation routière → `/gpx/infraction_circulation_routière_pages/quiz/quiz_circulation_routiere` ⇒ **QuizCirculationRoutiere**
- **Armes & munitions** — badge: _Régimes spéciaux_ — img `assets/images/armes_munitions.jpeg` — route `/gpx_scolarite_pages/armes_munitions_pages` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - Classification des armes et des munitions → `/gpx_scolarite_pages/armes_munitions_pages/armes_classification` ⇒ **ArmesClassificationPage**
    - Définitions → `/gpx_scolarite_pages/armes_munitions_pages/armes_definitions` ⇒ **ArmesDefinitionsPage**
    - Introduction → `/gpx_scolarite_pages/armes_munitions_pages/armes_introduction` ⇒ **ArmesIntroductionPage**
    - Acquisition/détention cat. A ou B sans autorisation → `/gpx_scolarite_pages/armes_munitions_pages/armes_acquisition_detention_ab` ⇒ **ArmesAcquisitionDetentionABPage**
    - Port/transport sans motif légitime (cat. C ou D) → `/gpx_scolarite_pages/armes_munitions_pages/armes_port_transport_cd` ⇒ **ArmesPortTransportCDPage**
    - Régimes matériels de guerre / éléments d’arme → `/gpx_scolarite_pages/armes_munitions_pages/armes_materiels_guerre_elements` ⇒ **ArmesMaterielsGuerreElementsPage**
    - Règles d’acquisition & détention → `/gpx_scolarite_pages/armes_munitions_pages/armes_regles_acquisition_detention` ⇒ **ArmesReglesAcquisitionDetentionPage**
    - Règles de port & transport → `/gpx_scolarite_pages/armes_munitions_pages/armes_regles_port_transport` ⇒ **ArmesReglesPortTransportPage**
    - Quiz — Classification des armes et des munitions → `/gpx/armes_munitions_pages/quiz/quiz_armes_munitions_pages` ⇒ **QuizArmesMunitions**
- **Libertés publiques** — badge: _Droits & garanties_ — img `assets/images/libertes_publiques.jpeg` — route `/gpx/generalites/libertespubliques_intro` ⇒ **LibertesPubliquesIntroPage**
- **Stupéfiants — usage & trafic** — badge: _Stups_ — img `assets/images/stupefiants.jpeg` — route `/gpx_scolarite_pages/stupéfiants_pages` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - Introduction → `/gpx_scolarite_pages/stupéfiants_pages/introduction` ⇒ **StupefiantsIntroductionPage**
    - Cession/offre illicites pour consommation personnelle → `/gpx_scolarite_pages/stupéfiants_pages/cession_offre` ⇒ **StupefiantsCessionOffrePage**
    - Direction/organisation d’un trafic → `/gpx_scolarite_pages/stupéfiants_pages/direction_organisation` ⇒ **StupefiantsDirectionOrganisationPage**
    - Facilitation à l’usage illicite → `/gpx_scolarite_pages/stupéfiants_pages/facilitation_usage` ⇒ **StupefiantsFacilitationUsagePage**
    - Production/fabrication illicites → `/gpx_scolarite_pages/stupéfiants_pages/production_fabrication` ⇒ **StupefiantsProductionFabricationPage**
    - Provocation d’un majeur à l’usage ou au trafic → `/gpx_scolarite_pages/stupéfiants_pages/provocation_majeur` ⇒ **StupefiantsProvocationMajeurPage**
    - Blanchiment du produit du trafic → `/gpx_scolarite_pages/stupéfiants_pages/blanchiment_produit` ⇒ **StupefiantsBlanchimentProduitPage**
    - Transport/détention/offre/cession/acquisition/emploi → `/gpx_scolarite_pages/stupéfiants_pages/transport_detention_offre` ⇒ **StupefiantsTransportDetentionOffrePage**
    - Importation/exportation illicites → `/gpx_scolarite_pages/stupéfiants_pages/import_export` ⇒ **StupefiantsImportExportPage**
    - Usage illicite de stupéfiants → `/gpx_scolarite_pages/stupéfiants_pages/usage_illicite` ⇒ **StupefiantsUsageIllicitePage**
    - Quiz — Stupéfiants — usage & trafic → `/gpx/stupéfiants_pages/quiz/quiz_stupéfiants` ⇒ **QuizStupefiant**

#### GpxSchoolProgram.mememtoCirculationRoutiere
- **Procédures circulation routière** — badge: _Procédures_ — img `assets/images/memento_procedures.jpeg` — route `/gpx/memento_circulation/procedures` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - L’amende forfaitaire → `/gpx/memento_circulation/procedures/amende_forfaitaire` (img `assets/images/amende_forfaitaire.jpeg`) ⇒ **AmendeForfaitairePage**
    - L’amende forfaitaire délictuelle → `/gpx/memento_circulation/procedures/amende_forfaitaire_delictuelle` (img `assets/images/amende_forfaitaire_delictuelle.jpeg`) ⇒ **AmendeForfaitaireDelictuellePage**
    - La consignation → `/gpx/memento_circulation/procedures/consignation` (img `assets/images/consignation.jpeg`) ⇒ **ConsignationPage**
    - L’immobilisation du véhicule → `/gpx/memento_circulation/procedures/immobilisation` (img `assets/images/immobilisation.jpeg`) ⇒ **ImmobilisationPage**
    - La mise en fourrière → `/gpx/memento_circulation/procedures/mise_en_fourriere` (img `assets/images/mise_en_fourriere.jpeg`) ⇒ **MiseEnFourrierePage**
    - La conduite sous l’influence de l’alcool → `/gpx/memento_circulation/procedures/conduite_alcool` (img `assets/images/ivresse.jpeg`) ⇒ **ConduiteAlcoolPage**
    - La conduite après usage de stupéfiants → `/gpx/memento_circulation/procedures/conduite_stupefiants` (img `assets/images/stupefiants.jpeg`) ⇒ **ConduiteApresUsageStupefiantsPage**
    - La rétention du permis de conduire → `/gpx/memento_circulation/procedures/retention_permis` (img `assets/images/retention_permis.jpeg`) ⇒ **RetentionPermisConduirePage**
    - Le permis à points → `/gpx/memento_circulation/procedures/permis_a_points` (img `assets/images/permis_points.jpeg`) ⇒ **PermisAPointsPage**
    - Quiz — Procédures circulation → `/gpx/memento_circulation/procedures/quiz` (img `assets/images/quiz.jpeg`) ⇒ **QuizScolariteDynamiquePage**
- **Contrôle routier & pièces** — badge: _Contrôle_ — img `assets/images/memento_controle_routier.jpeg` — route `/gpx/memento_circulation/controle_routier` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - Le cadre légal du contrôle routier → `/gpx/memento_circulation/controle_routier/cadre_legal` (img `assets/images/cadres_juridiques.jpeg`) ⇒ **CadreLegalControleRoutierPage**
    - Le permis de conduire → `/gpx/memento_circulation/controle_routier/permis_conduire` (img `assets/images/permis_conduire.jpeg`) ⇒ **PermisConduirePage**
    - Le brevet de sécurité routière → `/gpx/memento_circulation/controle_routier/bsr` (img `assets/images/bsr.jpeg`) ⇒ **BsrPage**
    - Les certificats d’immatriculation → `/gpx/memento_circulation/controle_routier/certificat_immatriculation` (img `assets/images/certificat_immatriculation.jpeg`) ⇒ **CertificatImmatriculationPage**
    - Le contrôle technique des véhicules → `/gpx/memento_circulation/controle_routier/controle_technique` (img `assets/images/controle_technique.jpeg`) ⇒ **ControleTechniquePage**
    - L’assurance → `/gpx/memento_circulation/controle_routier/assurance_obligatoire` (img `assets/images/assurance_obligatoire.jpeg`) ⇒ **AssuranceObligatoirePage**
    - Quiz — Contrôle routier → `/gpx/memento_circulation/controle_routier/quiz` (img `assets/images/quiz.jpeg`) ⇒ **QuizScolariteDynamiquePage**
- **Équipements véhicules & usagers** — badge: _Équipements_ — img `assets/images/memento_equipements.jpeg` — route `/gpx/memento_circulation/equipements` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - Les pneumatiques → `/gpx/memento_circulation/equipements/pneumatiques` (img `assets/images/pneumatiques.jpeg`) ⇒ **PneumatiquesPage**
    - Éclairage et signalisation → `/gpx/memento_circulation/equipements/eclairage_signalisation` (img `assets/images/eclairage_signalisation.jpeg`) ⇒ **EclairageSignalisationPage**
    - Chargement → `/gpx/memento_circulation/equipements/chargement` (img `assets/images/chargement.jpeg`) ⇒ **ChargementPage**
    - Les plaques → `/gpx/memento_circulation/equipements/plaques` (img `assets/images/plaques.jpeg`) ⇒ **PlaquesPage**
    - Miroirs / rétroviseurs / vision indirecte → `/gpx/memento_circulation/equipements/retroviseurs_vision` (img `assets/images/retroviseurs.jpeg`) ⇒ **RetroviseursVisionPage**
    - Les essuie-glace → `/gpx/memento_circulation/equipements/essuie_glace` (img `assets/images/essuie_glace.jpeg`) ⇒ **EssuieGlacePage**
    - Nuisances des véhicules (fumées, bruit, avertisseur sonore) → `/gpx/memento_circulation/equipements/nuisances` (img `assets/images/nuisances.jpeg`) ⇒ **NuisancesVehiculesPage**
    - Ceinture de sécurité / retenue enfant → `/gpx/memento_circulation/equipements/ceinture_retenue_enfant` (img `assets/images/ceinture_retenue_enfant.jpeg`) ⇒ **CeintureRetenueEnfantPage**
    - Casque et gants de protection → `/gpx/memento_circulation/equipements/casque_gants` (img `assets/images/casque_gants.jpeg`) ⇒ **CasqueGantsPage**
    - Casque “cycliste” → `/gpx/memento_circulation/equipements/casque_cycliste` (img `assets/images/casque_cycliste.jpeg`) ⇒ **CasqueCyclistePage**
    - Gilet de haute visibilité → `/gpx/memento_circulation/equipements/gilet_haute_visibilite` (img `assets/images/gilet_haute_visibilite.jpeg`) ⇒ **GiletHauteVisibilitePage**
    - Quiz — Équipements → `/gpx/memento_circulation/equipements/quiz` (img `assets/images/quiz.jpeg`) ⇒ **QuizScolariteDynamiquePage**
- **Natinf** — badge: _Natinf_ — img `assets/images/natinf.png` — route `/gpx/memento_circulation/natinf` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - Natinf → `/gpx/memento_circulation/controle_routier/natinf` (img `assets/images/natinf.png`) ⇒ **PrincipesGenerauxCirculationPage**

#### GpxSchoolProgram.policierEnInterventionsa
- **Circulation & séjour des étrangers** — badge: _Étrangers_ — img `assets/images/mandat_arret.jpeg` — route `/gpx/intervention/etrangers` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - L’accord de Schengen → `/gpx/intervention/etrangers/schengen` (img `assets/images/schengen.jpeg`) ⇒ **AccordSchengenPage**
    - Coopération policière et judiciaire (UE) → `/gpx/intervention/etrangers/cooperation-ue` (img `assets/images/cooperation_ue.jpeg`) ⇒ **CooperationUEPage**
    - Les différents titres de séjour → `/gpx/intervention/etrangers/titres-sejour` (img `assets/images/titres_sejour.jpeg`) ⇒ **TitresSejourPage**
    - Quiz — Étrangers → `/gpx/intervention/etrangers/quiz` ⇒ **QuizScolariteDynamiquePage**
- **Protection des mineurs** — badge: _Mineurs_ — img `assets/images/mineurs_famille.jpeg` — route `/gpx/intervention/mineurs` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - Le statut juridique du mineur → `/gpx/intervention/mineurs/statut-juridique` ⇒ **StatutJuridiqueMineurPage**
    - Protection des mineurs sur la voie publique → `/gpx/intervention/mineurs/voie-publique` ⇒ **ProtectionMineursVoiePubliquePage**
    - Quiz — Mineurs → `/gpx/intervention/mineurs/quiz` ⇒ **QuizScolariteDynamiquePage**
- **Accident de la circulation** — badge: _Accident_ — img `assets/images/mise_en_danger.jpeg` — route `/gpx/intervention/accident-circulation` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - Technique du plan des lieux → `/gpx/intervention/accident-circulation/plan-lieux-technique` (img `assets/images/plan_lieux.jpeg`) ⇒ **PlanLieuxTechniquePage**
    - Différents modèles de plan → `/gpx/intervention/accident-circulation/modeles-plan` (img `assets/images/modele-sans-cotes.jpeg`) ⇒ **ModelesPlanPage**
    - Renseignements à recueillir sur les lieux → `/gpx/intervention/accident-circulation/renseignements-a-recueillir` (img `assets/images/renseignements.jpeg`) ⇒ **RenseignementsARecueillirPage**
    - Tableau synthèse des renseignements à recueillir → `/gpx/intervention/accident-circulation/tableau-synthese` (img `assets/images/tableau_synthese.jpeg`) ⇒ **TableauSynthesePage**
    - L’avis à la famille → `/gpx/intervention/accident-circulation/avis-famille` (img `assets/images/avis_famille.jpeg`) ⇒ **AvisFamillePage**
    - “J’annonce une mauvaise nouvelle” (AMARIS) → `/gpx/intervention/accident-circulation/annoncer-mauvaise-nouvelle` (img `assets/images/mauvaise_nouvelle.jpeg`) ⇒ **AnnoncerMauvaiseNouvellePage**
    - Quiz — Accident → `/gpx/intervention/accident-circulation/quiz` ⇒ **QuizScolariteDynamiquePage**
- **Intervention : usage de stupéfiants** — badge: _Stupéfiants_ — img `assets/images/stupefiants.jpeg` — route `/gpx/intervention/stupefiants` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - Amende forfaitaire délictuelle (usage illicite) → `/gpx/intervention/stupefiants/amende-forfaitaire-delictuelle` ⇒ **AmendeForfaitaireDelictuelleStupPage**
    - Quiz — Stupéfiants → `/gpx/intervention/stupefiants/quiz` ⇒ **QuizScolariteDynamiquePage**
- **Intervention : débit de boissons** — badge: _Débit_ — img `assets/images/ivresse.jpeg` — route `/gpx/intervention/debit-boissons` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - Intervention dans un débit de boissons → `/gpx/intervention/debit-boissons/intervention` (img `assets/images/boissons_intervention.jpeg`) ⇒ **InterventionDebitBoissonsPage**
    - Contrôle des débits de boissons → `/gpx/intervention/debit-boissons/controle` (img `assets/images/boissons_controle.jpeg`) ⇒ **ControleDebitsBoissonsPage**
    - Quiz — Débit de boissons → `/gpx/intervention/debit-boissons/quiz` ⇒ **QuizScolariteDynamiquePage**
- **Les malades mentaux** — badge: _Psychiatrie_ — img `assets/images/malades_mentaux.jpeg` — route `/gpx/intervention/malades-mentaux` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - Intervenir auprès de personnes ne jouissant pas de toutes leurs capacités mentales → `/gpx/intervention/malades-mentaux/intervenir` (img `assets/images/malades_mentaux_intervenir.jpeg`) ⇒ **IntervenirMaladesMentauxPage**
    - Admission en soins psychiatriques sans consentement → `/gpx/intervention/malades-mentaux/soins-sans-consentement` (img `assets/images/soins_sans_consentement.jpeg`) ⇒ **SoinsSansConsentementPage**
    - Quiz — Malades mentaux → `/gpx/intervention/malades-mentaux/quiz` ⇒ **QuizScolariteDynamiquePage**
- **Intervention : présence d’un animal** — badge: _Animal_ — img `assets/images/animal.jpeg` — route `/gpx/intervention/animal` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - Lutte contre la maltraitance animale → `/gpx/intervention/animal/maltraitance` (img `assets/images/maltraitance.jpeg`) ⇒ **MaltraitanceAnimalePage**
    - “Intervenir face à un chien dangereux” (AMARIS) → `/gpx/intervention/animal/chien-dangereux` (img `assets/images/chien_dangereux.jpeg`) ⇒ **ChienDangereuxPage**
    - Protocole sanitaire en cas de morsure → `/gpx/intervention/animal/protocole-morsure` (img `assets/images/protocole_morsure.jpeg`) ⇒ **ProtocoleMorsurePage**
    - Chiens d’attaque, de garde ou de défense → `/gpx/intervention/animal/chiens-categories` (img `assets/images/chiens_categories.jpeg`) ⇒ **ChiensCategoriesPage**
    - Quiz — Animal → `/gpx/intervention/animal/quiz` ⇒ **QuizScolariteDynamiquePage**
- **Les autres interventions** — badge: _Divers_ — img `assets/images/autres_interventions.jpeg` — route `/gpx/intervention/autres` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - Intervention sur les lieux d’un sinistre → `/gpx/intervention/autres/sinistre` (img `assets/images/sinistre.jpeg`) ⇒ **SinistrePage**
    - “Primo-intervenant sur un incendie” (AMARIS) → `/gpx/intervention/autres/incendie-primo` (img `assets/images/incendie_primo.jpeg`) ⇒ **IncendiePrimoPage**
    - Intervention sur une alarme (établissement à caractère financier ou commercial) → `/gpx/intervention/autres/alarme-etablissement` (img `assets/images/alarme_etablissement.jpeg`) ⇒ **AlarmeEtablissementPage**
    - Principes de levée de doute lors d’agressions armées → `/gpx/intervention/autres/levee-doute-agression-armee` (img `assets/images/levee_doute_agression_armee.jpeg`) ⇒ **LeveeDouteAgressionArmeePage**
    - Intervention suite à une agression armée à caractère crapuleux → `/gpx/intervention/autres/agression-armee-crapuleux` (img `assets/images/agression_armee_crapuleux.jpeg`) ⇒ **AgressionArmeeCrapuleuxPage**
    - Intervention suite à la violation d’un bracelet anti-rapprochement (interdiction de se rapprocher) → `/gpx/intervention/autres/violation-bar` ⇒ **ViolationBarPage**
    - Plan Vigipirate → `/gpx/intervention/autres/plan-vigipirate` (img `assets/images/vigipirate.jpeg`) ⇒ **PlanVigipiratePage**
    - Quiz — Autres interventions → `/gpx/intervention/autres/quiz` ⇒ **QuizScolariteDynamiquePage**

#### GpxSchoolProgram.policierEnIntervention
- **La prise de service** — badge: _Service_ — img `assets/images/cat_hierarchie.jpg` — route `/gpx/intervention/prise-service` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - La prise de service : l’appel → `/gpx/intervention/prise-service/appel` (img `assets/images/prise_de_service.png`) ⇒ **PriseServiceAppelPage**
    - Les principaux registres du poste → `/gpx/intervention/prise-service/registres` (img `assets/images/registe_poste.png`) ⇒ **PriseServiceRegistresPage**
    - Les applications “main courante” et “déclaration d’usagers” → `/gpx/intervention/prise-service/applications` (img `assets/images/main_courante.jpeg`) ⇒ **PriseServiceApplicationsPage**
    - Mesures de sécurité, la fouille intégrale → `/gpx/intervention/prise-service/fouille-integrale` (img `assets/images/fouille.jpeg`) ⇒ **PriseServiceFouilleIntegralePage**
    - La gestion humaine et matérielle de la garde à vue → `/gpx/intervention/prise-service/garde-a-vue` (img `assets/images/gav.jpeg`) ⇒ **PriseServiceGardeAVuePage**
    - Maîtriser le risque d’évasion et de fuite (AMARIS) → `/gpx/intervention/prise-service/risque-evasion-fuite` (img `assets/images/amaris.jpg`) ⇒ **PriseServiceRisqueEvasionFuitePage**
- **La patrouille** — badge: _Patrouille_ — img `assets/images/memento_controle_routier.jpeg` — route `/gpx/intervention/patrouille` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - La patrouille → `/gpx/intervention/patrouille/patrouille` (img `assets/images/cat_infractions.jpg`) ⇒ **PatrouillePatrouillePage**
    - La communication radioélectrique → `/gpx/intervention/patrouille/communication-radio` (img `assets/images/prise_de_service.png`) ⇒ **CommunicationRadioPage**
    - Plaquette : respect de la procédure radio → `/gpx/intervention/patrouille/procedure-radio` (img `assets/images/prise_de_service.png`) ⇒ **ProcedureRadioPage**
    - MEMO TPH 900 → `/gpx/intervention/patrouille/memo-tph-900` (img `assets/images/prise_de_service.png`) ⇒ **MemoTph900Page**
    - Les principaux fichiers → `/gpx/intervention/patrouille/principaux-fichiers` (img `assets/images/copic_institutions.jpg`) ⇒ **PrincipauxFichiersPage**
    - L’interrogation du F.P.R. → `/gpx/intervention/patrouille/interrogation-fpr` (img `assets/images/criminalite_organisee.jpeg`) ⇒ **InterrogationFprPage**
    - La caméra piéton → `/gpx/intervention/patrouille/camera-pieton` (img `assets/images/camera_pieton.jpg`) ⇒ **CameraPietonPage**
    - L’utilité de la caméra piéton (AMARIS) → `/gpx/intervention/patrouille/utilite-camera` (img `assets/images/amaris.jpg`) ⇒ **UtiliteCameraPietonPage**
    - Les équipements de sécurité → `/gpx/intervention/patrouille/equipements-securite` (img `assets/images/equipement_securite.jpg`) ⇒ **EquipementsSecuritePage**
    - La conduite des véhicules de police → `/gpx/intervention/patrouille/conduite-vehicules` (img `assets/images/voiture_police.jpg`) ⇒ **ConduiteVehiculesPolicePage**
    - L’usage des signaux sonores et lumineux → `/gpx/intervention/patrouille/signaux-sonores-lumineux` (img `assets/images/gyro.jpg`) ⇒ **SignauxSonoresLumineuxPage**
    - Le signalement descriptif → `/gpx/intervention/patrouille/signalement-descriptif` (img `assets/images/signalement_descriptif.jpg`) ⇒ **SignalementDescriptifPage**
    - La palpation de sécurité → `/gpx/intervention/patrouille/palpation-securite` (img `assets/images/fouille.jpeg`) ⇒ **PalpationSecuritePage**
    - Le menottage → `/gpx/intervention/patrouille/menottage` (img `assets/images/menottage.jpeg`) ⇒ **MenottagePage**
    - Enregistrement et diffusion éventuelle d'images et de paroles de fonctionnaires de police dans l'exercice de leurs fonctions. → `/gpx/intervention/patrouille/enregistrement-diffusion-images-paroles` (img `assets/images/enregistement_police.jpg`) ⇒ **EnregistrementDiffusionImagesParolesPage**
    - Synthèse des indicateurs de basculement → `/gpx/intervention/patrouille/synthese-indicateurs-basculement` (img `assets/images/emotion.webp`) ⇒ **SyntheseIndicateursBasculementPage**
- **L’accident de la circulation** — badge: _Accident_ — img `assets/images/mise_en_danger.jpeg` — route `/gpx/intervention/accident-circulation` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - La sécurité pendant le trajet et sur les lieux du constat d’un accident de la circulation → `/gpx/intervention/accident-circulation/securite-trajet-lieux` (img `assets/images/acccident_voiture.jpeg`) ⇒ **SecuriteTrajetLieuxPage**
    - Les différents types d’accidents de la circulation routière → `/gpx/intervention/accident-circulation/types-accidents` (img `assets/images/different_accident.jpg`) ⇒ **TypesAccidentsCirculationPage**
    - La régulation de la circulation → `/gpx/intervention/accident-circulation/regulation-circulation` (img `assets/images/regulastion_accident.webp`) ⇒ **RegulationCirculationPage**
- **L’intervention au domicile** — badge: _Domicile_ — img `assets/images/mineurs_famille.jpeg` — route `/gpx/intervention/domicile` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - Le domicile et la violation de domicile → `/gpx/intervention/domicile/violation-domicile` (img `assets/images/violation_domicile.webp`) ⇒ **ViolationDomicilePage**
    - Les bruits et tapages → `/gpx/intervention/domicile/bruits-tapages` (img `assets/images/tapage.jpg`) ⇒ **BruitsTapagesPage**
    - Le différend familial → `/gpx/intervention/domicile/differend-familial` (img `assets/images/different_familiale.jpg`) ⇒ **DifferendFamilialPage**
    - Violences conjugales : conduite à tenir lors des interventions à domicile → `/gpx/intervention/domicile/violences-conjugales` (img `assets/images/violence_conjugale.jpg`) ⇒ **ViolencesConjugalesPage**
- **Les autres interventions** — badge: _Divers_ — img `assets/images/hierarchie_police.jpeg` — route `/gpx/intervention/autres` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - “Primo-intervenant sur une scène d’infraction” (AMARIS) → `/gpx/intervention/autres/primo-scene-infraction-amaris` (img `assets/images/flagrant_delit.webp`) ⇒ **PrimoSceneInfractionAmarisPage**
    - Bagages abandonnés, oubliés ; objets, engins ou véhicules suspects → `/gpx/intervention/autres/alertes-a-la-bombe` (img `assets/images/deminage_camion.png`) ⇒ **AlertesALaBombePage**
    - Identification et détection des produits suspects → `/gpx/intervention/autres/identification-detection-produits-suspects` (img `assets/images/identifiacation_colis.png`) ⇒ **IdentificationDetectionProduitsSuspectsPage**
    - L’ivresse publique et manifeste (I.P.M.) → `/gpx/intervention/autres/ipm` (img `assets/images/ipm.jpg`) ⇒ **IvressePubliqueManifestePage**
    - Les plans ORSEC → `/gpx/intervention/autres/plans-orsec` (img `assets/images/ORSEC_large.jpg`) ⇒ **PlansOrsecPage**
- **Formulaires utiles** — badge: _Docs_ — img `assets/images/copic_institutions.jpg` — route `/gpx/intervention/formulaires-utiles` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - Avis de rétention d’un permis de conduire → `/gpx/intervention/formulaires-utiles/avis-retention-permis` (img `assets/images/retention_permis_conduire.jpg`) ⇒ **AvisRetentionPermisPage**
    - Fiche d’immobilisation → `/gpx/intervention/formulaires-utiles/fiche-immobilisation` (img `assets/images/fiche_immobilisation.jpg`) ⇒ **FicheImmobilisationPage**
    - Fiche descriptive de l’état du véhicule à enlever en fourrière → `/gpx/intervention/formulaires-utiles/fiche-descriptive-fourriere` (img `assets/images/fourrière.webp`) ⇒ **FicheDescriptiveFourrierePage**

#### GpxSchoolProgram.recueilPvApj20
- **Recueil PV — Introduction** — badge: _Bases_ — img `assets/images/pv_intro.jpg` — route `/gpx/pv_apj20/introduction` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    -  → `/gpx/pv_apj20/introduction/preambule` (img `assets/images/pv_preambule.png`) ⇒ **PVPreambulePage**
    -  → `/gpx/pv_apj20/introduction/procedure` (img `assets/images/pv_procedure.png`) ⇒ **PVProcedurePage**
    -  → `/gpx/pv_apj20/introduction/proces_verbaux` (img `assets/images/proces_verbaux.png`) ⇒ **PVProcesVerbauxPage**
    - L’état-civil → `/gpx/pv_apj20/introduction/etat_civil` (img `assets/images/etat_civil.png`) ⇒ **PVEtatCivilPage**
- **Recueil PV — La plainte** — badge: _Plainte_ — img `assets/images/pv_plainte.jpeg` — route `/gpx/pv_apj20/plainte` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    -  → `/gpx/pv_apj20/plainte/generalites` (img `assets/images/généralités.png`) ⇒ **PVPlainteGeneralitesPage**
    - Canevas de procès-verbal de plainte contre auteur inconnu → `/gpx/pv_apj20/plainte/pv_saisine_personne_inconnue` (img `assets/images/canevas.png`) ⇒ **PVPvSaisinePersonneInconnuePage**
    - Canevas de procès-verbal de plainte contre personne dénommée → `/gpx/pv_apj20/plainte/pv_saisine_personne_denommee` (img `assets/images/canevas.png`) ⇒ **PVPvSaisinePersonneDenommeePage**
    - Canevas de procès-verbal de plainte contre personne dénommée — Suite → `/gpx/pv_apj20/plainte/pv_saisine_personne_denommee_suite` (img `assets/images/canevas.png`) ⇒ **PVPvSaisinePersonneDenommeeSuitePage**
    - Violences conjugales — Grille d’évaluation du danger → `/gpx/pv_apj20/plainte/violences_conjugales/presentation_grille_danger` (img `assets/images/pv_vc_grille_danger.jpg`) ⇒ **PresentationGrilleDangerPage**
    - Violences conjugales — Document d’information synthétique (démarches & dispositifs) → `/gpx/pv_apj20/plainte/violences_conjugales/document_info_synthetique` (img `assets/images/pv_vc_document_info.webp`) ⇒ **DocumentInfoSynthetiquePage**
    - Canevas & PV de plainte d’une victime de violences conjugales → `/gpx/pv_apj20/plainte/violences_conjugales/pv_victime` (img `assets/images/canevas.png`) ⇒ **PVVictimeViolencesConjugalesPage**
- **Recueil PV — Constatations** — badge: _Constats_ — img `assets/images/perquisition.jpeg` — route `/gpx/pv_apj20/constatations` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    -  → `/gpx/pv_apj20/constatations/generalites` (img `assets/images/généralités.png`) ⇒ **ConstatationsGeneralitesPage**
    -  → `/gpx/pv_apj20/constatations/canevas_pv` (img `assets/images/canevas.png`) ⇒ **CanevasPVConstatationsPage**
- **Recueil PV — Témoignage** — badge: _Audition_ — img `assets/images/renseignements.jpeg` — route `/gpx/pv_apj20/temoignage` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    -  → `/gpx/pv_apj20/temoignage/generalites` (img `assets/images/généralités.png`) ⇒ **TemoignageGeneralitesPage**
    - Canevas & PV d’enquête de voisinage → `/gpx/pv_apj20/temoignage/enquete_voisinage` (img `assets/images/canevas.png`) ⇒ **EnqueteVoisinagePage**
    - Canevas & PV d’audition de témoin → `/gpx/pv_apj20/temoignage/audition_temoins` (img `assets/images/canevas.png`) ⇒ **AuditionTemoinsPage**
- **Recueil PV — Contrôle d’identité** — badge: _Identité_ — img `assets/images/pv_controle_identite.jpeg` — route `/gpx/pv_apj20/controle_identite` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    -  → `/gpx/pv_apj20/controle_identite/generalites` (img `assets/images/généralités.png`) ⇒ **ControleIdentiteGeneralitesPage**
    - Canevas & PV de contrôle d’identité → `/gpx/pv_apj20/controle_identite/pv_controle_identite` (img `assets/images/canevas.png`) ⇒ **PvControleIdentitePage**
    - Canevas & PV de contrôle d’identité + fiche de recherche → `/gpx/pv_apj20/controle_identite/pv_ci_fiche_recherche` (img `assets/images/canevas.png`) ⇒ **PvCiFicheRecherchePage**
- **Recueil PV — Interpellation & conduite au poste** — badge: _Interpellation_ — img `assets/images/pv_interpellation.jpeg` — route `/gpx/pv_apj20/interpellation` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    -  → `/gpx/pv_apj20/interpellation/generalites` (img `assets/images/généralités.png`) ⇒ **InterpellationGeneralitesPage**
    - Canevas & PV de contrôle d’identité + découverte d’une arme → `/gpx/pv_apj20/interpellation/ci_decouverte_arme` (img `assets/images/canevas.png`) ⇒ **PVCIDecouverteArmePage**
    - Canevas & PV d’interpellation → `/gpx/pv_apj20/interpellation/pv_interpellation` (img `assets/images/canevas.png`) ⇒ **PVInterpellationPage**
    - Canevas & PV de conduite au poste → `/gpx/pv_apj20/interpellation/conduite_au_poste` (img `assets/images/canevas.png`) ⇒ **ConduiteAuPostePage**
    - Les mandats (recherche, comparution, amener, arrêt) → `/gpx/pv_apj20/interpellation/mandats` (img `assets/images/pv_mandats.png`) ⇒ **MandatsPage**
    - Canevas & PV de notification de mandat → `/gpx/pv_apj20/interpellation/notification_mandat` (img `assets/images/canevas.png`) ⇒ **NotificationMandatPage**
    - Canevas & PV de recherches infructueuses (exécution mandat) → `/gpx/pv_apj20/interpellation/recherches_infructueuses_mandat` (img `assets/images/canevas.png`) ⇒ **RecherchesInfructueusesMandatPage**
    - Canevas de compte-rendu à l’O.P.J. → `/gpx/pv_apj20/interpellation/compte_rendu_opj` (img `assets/images/canevas.png`) ⇒ **CompteRenduOPJPage**
- **Recueil PV — GAV & suspect libre** — badge: _Droits_ — img `assets/images/pv_gav_suspect_libre.jpeg` — route `/gpx/pv_apj20/gav_suspect_libre` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - La garde à vue : généralités → `/gpx/pv_apj20/gav_suspect_libre/gav_generalites` (img `assets/images/généralités.png`) ⇒ **GavGeneralitesPage**
    - Canevas & PV : notification placement GAV + droits (A.P.J.) → `/gpx/pv_apj20/gav_suspect_libre/notification_gav_droits_apj` (img `assets/images/canevas.png`) ⇒ **NotificationGavDroitsApjPage**
    - Le suspect libre : généralités → `/gpx/pv_apj20/gav_suspect_libre/suspect_libre_generalites` (img `assets/images/généralités.png`) ⇒ **SuspectLibreGeneralitesPage**
    - Canevas & PV : notification des droits au suspect majeur → `/gpx/pv_apj20/gav_suspect_libre/notification_droits_suspect_majeur_emprisonnement` (img `assets/images/canevas.png`) ⇒ **NotificationDroitsSuspectMajeurEmprisonnementPage**
    - Canevas & PV : notification en audition libre (contravention/délit non puni emprisonnement) → `/gpx/pv_apj20/gav_suspect_libre/notification_audition_libre_sans_emprisonnement` (img `assets/images/canevas.png`) ⇒ **NotificationAuditionLibreSansEmprisonnementPage**
    - Canevas & PV : notification des droits — Art. 65 du C.P.P. → `/gpx/pv_apj20/gav_suspect_libre/notification_droits_art_65_cpp` (img `assets/images/canevas.png`) ⇒ **NotificationDroitsArticle65CPPPage**
    - Intervention de l’avocat : généralités → `/gpx/pv_apj20/gav_suspect_libre/avocat_generalites` (img `assets/images/généralités.png`) ⇒ **AvocatGeneralitesPage**
    - Canevas & PV : entretien du gardé à vue avec l’avocat → `/gpx/pv_apj20/gav_suspect_libre/entretien_gav_avocat` (img `assets/images/canevas.png`) ⇒ **EntretienGavAvocatPage**
- **Recueil PV — Audition du suspect** — badge: _Audition_ — img `assets/images/pv_audition_suspect.jpeg` — route `/gpx/pv_apj20/audition_suspect` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    -  → `/gpx/pv_apj20/audition_suspect/generalites` (img `assets/images/généralités.png`) ⇒ **AuditionSuspectGeneralitesPage**
    - Canevas & PV : audition du gardé à vue → `/gpx/pv_apj20/audition_suspect/audition_gav` (img `assets/images/canevas.png`) ⇒ **AuditionGavPage**
    - Canevas & PV : audition du suspect libre → `/gpx/pv_apj20/audition_suspect/audition_suspect_libre` (img `assets/images/canevas.png`) ⇒ **AuditionSuspectLibrePage**
    - Canevas & PV : audition du suspect libre + notification des droits (contravention/délit non puni emprisonnement) → `/gpx/pv_apj20/audition_suspect/audition_libre_notification_droits_sans_emprisonnement` (img `assets/images/canevas.png`) ⇒ **AuditionLibreNotificationDroitsSansEmprisonnementPage**
    - Le civilement responsable : généralités → `/gpx/pv_apj20/audition_suspect/civilement_responsable_generalites` (img `assets/images/généralités.png`) ⇒ **CivilementResponsableGeneralitesPage**
    - Canevas & PV : audition du civilement responsable → `/gpx/pv_apj20/audition_suspect/audition_civilement_responsable` (img `assets/images/canevas.png`) ⇒ **CivilementResponsableGeneralitesCanevasPage**
- **Recueil PV — Perquisition (enquête préliminaire)** — badge: _Enquête_ — img `assets/images/pv_perquisition.jpeg` — route `/gpx/pv_apj20/perquisition_preliminaire` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    -  → `/gpx/pv_apj20/perquisition_preliminaire/generalites` (img `assets/images/généralités.png`) ⇒ **PerquisitionPreliminaireGeneralitesPage**
    - Canevas & PV : perquisition en enquête préliminaire → `/gpx/pv_apj20/perquisition_preliminaire/perquisition` (img `assets/images/canevas.png`) ⇒ **PerquisitionPreliminairePerquisitionPage**
    - Canevas & PV : fouille de véhicule en enquête préliminaire → `/gpx/pv_apj20/perquisition_preliminaire/fouille_vehicule` (img `assets/images/canevas.png`) ⇒ **FouilleVehiculePreliminairePage**
- **Recueil PV — Réquisitions** — badge: _Réquisitions_ — img `assets/images/pv_requisitions.jpeg` — route `/gpx/pv_apj20/requisitions` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    -  → `/gpx/pv_apj20/requisitions/generalites` (img `assets/images/généralités.png`) ⇒ **RequisitionsGeneralitesPage**
    - Canevas & PV : réquisition à personne → `/gpx/pv_apj20/requisitions/requisition_personne` (img `assets/images/canevas.png`) ⇒ **RequisitionPersonnePage**
    - Canevas & rapport : réquisition à personne → `/gpx/pv_apj20/requisitions/rapport_requisition_personne` (img `assets/images/canevas.png`) ⇒ **RapportRequisitionPersonnePage**
- **Recueil PV — Confrontation** — badge: _Procédure_ — img `assets/images/pv_confrontation.jpeg` — route `/gpx/pv_apj20/confrontation` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    -  → `/gpx/pv_apj20/confrontation/generalites` (img `assets/images/généralités.png`) ⇒ **ConfrontationGeneralitesPage**
    - Canevas & PV : confrontation victime / gardé à vue → `/gpx/pv_apj20/confrontation/victime_gav` (img `assets/images/canevas.png`) ⇒ **ConfrontationVictimeGavPage**
    - Canevas & PV : confrontation victime / suspect libre (crime/délit puni emprisonnement) → `/gpx/pv_apj20/confrontation/victime_suspect_libre_emprisonnement` (img `assets/images/canevas.png`) ⇒ **ConfrontationVictimeSuspectLibreEmprisonnementPage**
- **Recueil PV — Procédures spéciales (étrangers)** — badge: _Spécial_ — img `assets/images/pv_etrangers.jpeg` — route `/gpx/pv_apj20/procedures_speciales/etrangers` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    -  → `/gpx/pv_apj20/procedures_speciales/etrangers/generalites` (img `assets/images/généralités.png`) ⇒ **EtrangersGeneralitesPage**
    - Canevas & PV : contrôle d’identité + contrôle du séjour et de la circulation des étrangers → `/gpx/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation` (img `assets/images/canevas.png`) ⇒ **CIControleSejourCirculationPage**
    - Canevas & PV : contrôle du séjour et de la circulation des étrangers → `/gpx/pv_apj20/procedures_speciales/etrangers/controle_sejour_circulation` (img `assets/images/canevas.png`) ⇒ **ControleSejourCirculationPage**
- **Recueil PV — Circulation routière** — badge: _Circulation_ — img `assets/images/pv_circulation_routiere.jpeg` — route `/gpx/pv_apj20/circulation_routiere` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - Alcool — Généralités → `/gpx/pv_apj20/circulation_routiere/alcool/generalites` (img `assets/images/généralités.png`) ⇒ **AsControleAlcoolemiePage**
    - Alcool — Canevas & PV conduite au poste (dépistage CEEA positif / refus / sans dépistage) → `/gpx/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus` (img `assets/images/canevas.png`) ⇒ **ConduitePosteCeeaPositifOuRefusPage**
    - Alcool — Canevas & PV d’interpellation suite conduite en état d’ivresse → `/gpx/pv_apj20/circulation_routiere/alcool/interpellation_etat_ivresse` (img `assets/images/canevas.png`) ⇒ **InterpellationEtatIvressePage**
    - Alcool — Tableau des taux d’alcool (affichés & retenus) → `/gpx/pv_apj20/circulation_routiere/alcool/tableau_taux` (img `assets/images/pv_tableau_taux_alcool.png`) ⇒ **TableauTauxPage**
    - Alcool — Canevas & PV vérification + notification des taux (CEEA) → `/gpx/pv_apj20/circulation_routiere/alcool/verification_notification_taux_ceea` (img `assets/images/canevas.png`) ⇒ **VerificationNotificationTauxCeeaPage**
    - Alcool — Canevas & PV vérification des taux (CEI) → `/gpx/pv_apj20/circulation_routiere/alcool/verification_taux_cei` (img `assets/images/canevas.png`) ⇒ **VerificationTauxCeiPage**
    - Alcool — Canevas & PV prélèvement sanguin (vérification état alcoolique) → `/gpx/pv_apj20/circulation_routiere/alcool/prelevement_sanguin` (img `assets/images/canevas.png`) ⇒ **PrelevementSanguinPage**
    - Alcool — Canevas & rapport réquisition (examen clinique médical + prélèvement sanguin) → `/gpx/pv_apj20/circulation_routiere/alcool/requisition_examen_clinique_prelevement` (img `assets/images/canevas.png`) ⇒ **RequisitionExamenCliniquePrelevementPage**
    - Alcool — Fiches A, B, C → `/gpx/pv_apj20/circulation_routiere/alcool/fiches_abc` (img `assets/images/pv_fiches_abc.png`) ⇒ **FichesAbcPage**
    - Stupéfiants — Généralités → `/gpx/pv_apj20/circulation_routiere/stupefiants/generalites` (img `assets/images/stupefiants.jpeg`) ⇒ **StupefiantsGeneralitesPage**
    - Stupéfiants — Canevas & PV conduite au poste (dépistage positif / refus) → `/gpx/pv_apj20/circulation_routiere/stupefiants/conduite_poste_depistage_positif_ou_refus` (img `assets/images/canevas.png`) ⇒ **ConduitePosteDepistagePositifOuRefusPage**
    - Stupéfiants — Formulaire d’information → `/gpx/pv_apj20/circulation_routiere/stupefiants/formulaire_information` (img `assets/images/pv_formulaire_information.png`) ⇒ **FormulaireInformationPage**
    - Stupéfiants — Canevas & PV vérifications destinées à établir l’usage → `/gpx/pv_apj20/circulation_routiere/stupefiants/verifications_etablir_usage` (img `assets/images/canevas.png`) ⇒ **VerificationsEtablirUsageStupefiantsPage**
    - Stupéfiants — Fiche suivi prélèvements (analyse salivaire) → `/gpx/pv_apj20/circulation_routiere/stupefiants/fiche_suivi_salivaire` (img `assets/images/pv_suivi_prelevements.png`) ⇒ **FicheSuiviSalivairePage**
    - Stupéfiants — Canevas & PV suite à prélèvement sanguin → `/gpx/pv_apj20/circulation_routiere/stupefiants/suite_prelevement_sanguin` (img `assets/images/canevas.png`) ⇒ **SuitePrelevementSanguinPage**
    - Stupéfiants — Canevas & PV prélèvement sanguin (établir usage stupéfiants) → `/gpx/pv_apj20/circulation_routiere/stupefiants/prelevement_sanguin_etablir_usage` (img `assets/images/canevas.png`) ⇒ **PrelevementSanguinEtablirUsagePage**
    - Stupéfiants — Fiche suivi prélèvements (analyse sanguine) → `/gpx/pv_apj20/circulation_routiere/stupefiants/fiche_suivi_sanguine` (img `assets/images/pv_suivi_prelevements.png`) ⇒ **FicheSuiviSanguinePage**
    - Stupéfiants — Canevas & rapport réquisition (examen clinique + prélèvement sanguin) + expertise → `/gpx/pv_apj20/circulation_routiere/stupefiants/requisition_examen_clinique_prelevement_expertise` (img `assets/images/canevas.png`) ⇒ **RequisitionExamenCliniquePrelevementExpertisePage**
    - Alcool + Stups — Conduite au poste (dépistages positifs / refus) → `/gpx/pv_apj20/circulation_routiere/alcool_stupefiants/conduite_poste_depistages_positifs_ou_refus` (img `assets/images/pv_conduite_poste.png`) ⇒ **ConduitePosteDepistagesPositifsOuRefusPage**
    - Alcool + Stups — Conduite au poste (refus de se soumettre aux vérifications) → `/gpx/pv_apj20/circulation_routiere/alcool_stupefiants/refus_verifications` (img `assets/images/pv_refus_verifications.png`) ⇒ **RefusVerificationsGPXPage**
    - Contravention 5e classe — Grand excès de vitesse (+50 km/h) → `/gpx/pv_apj20/circulation_routiere/contravention_5e/grand_exces_vitesse` (img `assets/images/grand_exces_vitesse.jpeg`) ⇒ **GrandExcesVitesseGPXPage**
    - Contravention 5e classe — Tableau des vitesses retenues → `/gpx/pv_apj20/circulation_routiere/contravention_5e/tableau_vitesses` (img `assets/images/pv_tableau_vitesses.png`) ⇒ **TableauVitessesPage**
    - Formulaires utiles — Avis de rétention du permis → `/gpx/intervention/formulaires-utiles/avis-retention-permis` (img `assets/images/retention_permis.jpeg`) ⇒ **AvisRetentionPermisPage**
    - Formulaires utiles — Fiche d’immobilisation → `/gpx/intervention/formulaires-utiles/fiche-immobilisation` (img `assets/images/immobilisation.jpeg`) ⇒ **FicheImmobilisationPage**
    - Formulaires utiles — Fiche descriptive état véhicule (fourrière) → `/gpx/intervention/formulaires-utiles/fiche-descriptive-fourriere` (img `assets/images/mise_en_fourriere.jpeg`) ⇒ **FicheDescriptiveFourrierePage**
- **Recueil PV — I.V.P.M** — badge: _IPM_ — img `assets/images/ipm.jpeg` — route `/gpx/pv_apj20/ipm` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    -  → `/gpx/pv_apj20/ipm/generalites` (img `assets/images/généralités.png`) ⇒ **IpmGeneralitesPage**
    - Canevas & PV contravention d’ivresse publique et manifeste (examen médical) → `/gpx/pv_apj20/ipm/pv_ipm_examen_medical` (img `assets/images/canevas.png`) ⇒ **PvIpmExamenMedicalPage**
    - Canevas & PV contravention d’ivresse publique et manifeste (remise à un tiers) → `/gpx/pv_apj20/ipm/pv_ipm_remise_tiers` (img `assets/images/canevas.png`) ⇒ **PvIpmRemiseTiersPage**

#### GpxSchoolProgram.dimensionHumaine
- **Communication & posture** — badge: _Relationnel_ — img `assets/images/dh_communication.jpeg` — route `/gpx/dimension_humaine/communication` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - DH1 — Le fonctionnement intellectuel et émotionnel dans l’intervention → `/gpx/dimension_humaine/communication/dh1_fonctionnement` (img `assets/images/dh1_fonctionnement.jpeg`) ⇒ **CoursScolaritePage**
    - DH3 — Les stratégies de communication adaptées avec le public → `/gpx/dimension_humaine/communication/dh3_strategies_public` (img `assets/images/dh3_strategies_public.jpeg`) ⇒ **CoursScolaritePage**
    - DH4 — La coordination au sein des équipes de police → `/gpx/dimension_humaine/communication/dh4_coordination_equipes` (img `assets/images/dh4_coordination.jpeg`) ⇒ **CoursScolaritePage**
    - ADH2 — La posture professionnelle adaptée face à une victime → `/gpx/dimension_humaine/communication/adh2_posture_victime` (img `assets/images/adh2_posture_victime.jpeg`) ⇒ **CoursScolaritePage**
    - S3-2 — L’intervention auprès de victimes de violences intrafamiliales → `/gpx/dimension_humaine/communication/s3_2_violences_intrafamiliales` (img `assets/images/s3_2_violences_intrafamiliales.jpeg`) ⇒ **CoursScolaritePage**
    - Quiz — Communication & posture → `/gpx/dimension_humaine/communication/quiz` (img `assets/images/quiz.jpeg`) ⇒ **QuizScolariteDynamiquePage**
- **Stress & gestion émotionnelle** — badge: _Bien-être_ — img `assets/images/dh_stress.jpeg` — route `/gpx/dimension_humaine/stress` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - DH2 — Le stress → `/gpx/dimension_humaine/stress/dh2_stress` (img `assets/images/dh2_stress.jpeg`) ⇒ **CoursScolaritePage**
    - DH2 — Le carnet des ressources → `/gpx/dimension_humaine/stress/dh2_carnet_ressources` (img `assets/images/dh2_carnet_ressources.jpeg`) ⇒ **CoursScolaritePage**
    - ADH9 — Faire face à une situation d’agressivité → `/gpx/dimension_humaine/stress/adh9_agressivite` (img `assets/images/adh9_agressivite.jpeg`) ⇒ **CoursScolaritePage**
    - AC6 — Les conduites suicidaires → `/gpx/dimension_humaine/stress/ac6_conduites_suicidaires` (img `assets/images/ac6_suicide.jpeg`) ⇒ **CoursScolaritePage**
    - Quiz — Stress & gestion émotionnelle → `/gpx/dimension_humaine/stress/quiz` (img `assets/images/quiz.jpeg`) ⇒ **QuizScolariteDynamiquePage**
- **Éthique au quotidien** — badge: _Valeurs_ — img `assets/images/dignite_discriminations.jpeg` — route `/gpx/dimension_humaine/ethique` ⇒ _ouvre `_CategoryDetailPage` interne (liste de `_ModuleCard`)_
    - ADH1 — L’intervention auprès de personnes ne jouissant pas de toutes ses facultés mentales → `/gpx/dimension_humaine/ethique/adh1_facultes_mentales` (img `assets/images/adh1_facultes_mentales.jpeg`) ⇒ **CoursScolaritePage**
    - ADH4 — Les violences sexuelles et sexistes → `/gpx/dimension_humaine/ethique/adh4_violences_sexuelles_sexistes` (img `assets/images/adh4_violences_sexuelles.jpeg`) ⇒ **CoursScolaritePage**
    - ADH6 — La confrontation à la mort en situation professionnelle → `/gpx/dimension_humaine/ethique/adh6_confrontation_mort` (img `assets/images/adh6_confrontation_mort.jpeg`) ⇒ **CoursScolaritePage**
    - Quiz — Éthique au quotidien → `/gpx/dimension_humaine/ethique/quiz` (img `assets/images/quiz.jpeg`) ⇒ **QuizScolariteDynamiquePage**


---

## Annexe A — Fallbacks image / sous-titre des sous-cartes (`_CategoryDetailPage._imageFor` / `_subtitleFor`)

Règle : `imagePath = sub.image ?? _imageFor(label)` (PA exam : idem) ; `subtitle = _subtitleFor(label)`. Test `label.toLowerCase().contains(mot)` dans l'ordre, première règle vraie gagne. Les mots-clés multiples d’une règle sont en OU (`||`), SAUF ces combinaisons en ET (`&&`) : commission+rogatoire, découverte+blessée, personnes+fuite, faux+usage, (quiz+sanction) || … — vérifier la source pour ces lignes.

**PA Exam — `_imageFor` (9 règles, ordre = priorité)**

| mots-clés (label.toLowerCase().contains) | valeur |
|---|---|
| méthodologie | `assets/images/concours_connaissances_generales.jpeg` |
| fiche, cours | `assets/images/concours_pa_epreuves.jpeg` |
| qcm, entraînement, entrainement | `assets/images/quiz.jpeg` |
| exercice | `assets/images/infraction_materiel.jpeg` |
| corrig | `assets/images/concours_photolangage.jpeg` |
| photolangage | `assets/images/concours_photolangage.jpeg` |
| tableau | `assets/images/concours_pa_epreuves.jpeg` |
| analyse | `assets/images/concours_connaissances_generales.jpeg` |
| aptitude, logique | `assets/images/quiz.jpeg` |
| _(défaut)_ | `assets/images/concours_pa_epreuves.jpeg` |

**PA Exam — `_subtitleFor` (11 règles, ordre = priorité)**

| mots-clés (label.toLowerCase().contains) | valeur |
|---|---|
| méthodologie | `Conseils & stratégies pour l'épreuve` |
| fiche | `Synthèse des points clés` |
| qcm | `Questions à choix multiples` |
| exercice | `Mises en situation pratiques` |
| corrig | `Corrections détaillées` |
| tableau | `Vue synthétique et repères clés` |
| analyse | `Comprendre l'épreuve` |
| aptitude | `Exercices verbaux` |
| logique | `Raisonnement et déduction` |
| observation | `Attention et concentration` |
| personnalit | `Profil comportemental` |
| _(défaut)_ | `Module` |

**GPX Exam — `_imageFor` (3 règles, ordre = priorité)**

| mots-clés (label.toLowerCase().contains) | valeur |
|---|---|
| tableau | `assets/images/concours_pa_epreuves.jpeg` |
| admiss | `assets/images/concours_connaissances_generales.jpeg` |
| admission | `assets/images/concours_photolangage.jpeg` |
| _(défaut)_ | `assets/images/concours_pa_epreuves.jpeg` |

**GPX Exam — `_subtitleFor` (3 règles, ordre = priorité)**

| mots-clés (label.toLowerCase().contains) | valeur |
|---|---|
| tableau | `Vue synthétique et repères clés` |
| admiss | `Épreuves écrites : contenu & attentes` |
| admission | `Oral & sport : préparation et critères` |
| _(défaut)_ | `Module` |

**PA School — `_imageFor` (93 règles, ordre = priorité)**

| mots-clés (label.toLowerCase().contains) | valeur |
|---|---|
|  | `assets/images/quiz.jpeg` |
| quiz generalite, quiz generalite | `assets/images/quiz.jpeg` |
| classification | `assets/images/classification.jpeg` |
| infraction | `assets/images/infraction_materiel.jpeg` |
| tentative | `assets/images/infraction_legal.jpeg` |
| complic | `assets/images/complicite.jpeg` |
| légitime, legitime | `assets/images/legitime_defense.jpeg` |
| arme, cadre légal | `assets/images/armes_munitions.jpeg` |
| libert | `assets/images/libertes_publiques.jpeg` |
| rétention, retention | `assets/images/retention.jpeg` |
| hierarchie, hierarchie | `assets/images/libertes_intro.jpeg` |
| quiz cadres, quiz cadres | `assets/images/quiz.jpeg` |
| cadres d\, cadres d’enquête | `assets/images/cadres_enquete.jpeg` |
| flagrant | `assets/images/enquete_flagrant.jpeg` |
| préliminaire, preliminaire | `assets/images/enquete_preliminaire.jpeg` |
| commission, rogatoire | `assets/images/commission_rogatoire.jpeg` |
| découverte, blessée | `assets/images/personne_blessee.jpeg` |
| mort, cause inconnue, suspecte | `assets/images/mort_suspecte.jpeg` |
| délinquance, criminalité | `assets/images/criminalite_organisee.jpeg` |
| personnes, fuite | `assets/images/recherche_fuite.jpeg` |
| disparitions, inquiétantes | `assets/images/abandon_famille.jpeg` |
| contrôles, vérifications, identité | `assets/images/controle_identite.jpeg` |
| entraide, internationale | `assets/images/libertes_expression.jpeg` |
| action publique, autorités, police judiciaire, mission de police | `assets/images/pp_action_publique_autorites_pj.jpeg` |
| nullité, actes de procédure | `assets/images/pp_nullite_actes.jpeg` |
| juridictions, jugement, exécution des décisions | `assets/images/pp_juridictions_execution.jpeg` |
| quiz instruction préparatoire, quiz instruction preparatoire | `assets/images/quiz.jpeg` |
| instruction préparatoire, instruction preparatoire, mandats de justice, contrôle judiciaire, controle judiciaire, détention provisoire, detention provisoire | `assets/images/pp_instruction_mandats_detention.jpeg` |
| loi pénale, loi penale | `assets/images/droit_penal_general.jpeg` |
| responsabilité pénale, responsabilite penale | `assets/images/droit_penal_general_2.jpeg` |
| peines, sûreté, surete | `assets/images/sanction.jpeg` |
| aggravation | `assets/images/aggravations.jpeg` |
| pluralité, pluralite | `assets/images/pluralite_infractions.jpeg` |
| quiz, sanction, sanction | `assets/images/quiz.jpeg` |
| mise en danger | `assets/images/mise_en_danger.jpeg` |
| viol, agressions sexuelles | `assets/images/viol_agressions.jpeg` |
| enlèvement, enlevement | `assets/images/enlevement.jpeg` |
| diffusion d’images, diffusion d\ | `assets/images/diffusion_images.jpeg` |
| dignité, dignite | `assets/images/dignite.jpeg` |
| personnalité, personnalite | `assets/images/personnalite.jpeg` |
| involontaires | `assets/images/atteintes_involontaires.jpeg` |
| volontaires à la vie, volontaires a la vie | `assets/images/atteintes_vie.jpeg` |
| volontaires à l’intégrité, volontaires a l’integrite, integrite | `assets/images/atteintes_integrite.jpeg` |
| mineurs | `assets/images/mineurs_famille.jpeg` |
| jaf | `assets/images/ordonnances_jaf.jpeg` |
| autorité parentale, autorite parentale | `assets/images/autorite_parentale.jpeg` |
| abandon de famille | `assets/images/abandon_famille.jpeg` |
| association de malfaiteurs | `assets/images/association_malfaiteurs.jpeg` |
| abus d’autorité, abus d\ | `assets/images/abus_autorite.jpeg` |
| action de la justice | `assets/images/action_justice.jpeg` |
| administration par des particuliers | `assets/images/administration_particuliers.jpeg` |
| faux, usage | `assets/images/faux_usage_faux.jpeg` |
| probité, probite | `assets/images/probite.jpeg` |
| recel | `assets/images/recel.jpeg` |
| vol | `assets/images/vol.jpeg` |
| stad | `assets/images/stad.jpeg` |
| chèques, cheques, contrefa | `assets/images/contrefacons.jpeg` |
| destructions, dégradations, degradations | `assets/images/destructions.jpeg` |
| voisines du vol | `assets/images/voisines_vol.jpeg` |
| stupéfiants, stupefiants | `assets/images/conduite_stupefiants.jpeg` |
| ivresse | `assets/images/ivresse.jpeg` |
| état alcoolique, etat alcoolique | `assets/images/etat_alcoolique.jpeg` |
| assurance | `assets/images/defaut_assurance.jpeg` |
| permis | `assets/images/defaut_permis.jpeg` |
| délit de fuite, delit de fuite | `assets/images/delit_fuite.jpeg` |
| excès de vitesse, exces de vitesse | `assets/images/grand_exces_vitesse.jpeg` |
| vérifications, verifications | `assets/images/refus_verifications.jpeg` |
| obtempérer, obtemperer | `assets/images/refus_obtemperer.jpeg` |
| rodéo, rodeo | `assets/images/rodeo_motorise.jpeg` |
| plaques, inscriptions | `assets/images/plaques_inscriptions.jpeg` |
| incitation, organisation, promotion | `assets/images/image4.jpeg` |
| classification des armes | `assets/images/armes_munitions.jpeg` |
| définitions, definitions | `assets/images/armes_definitions.jpeg` |
| introduction | `assets/images/armes_intro.jpeg` |
| cat. a, cat. b, cat a, cat b | `assets/images/armes_cat_ab.jpeg` |
| cat. c, cat. d, cat c, cat d | `assets/images/armes_cat_cd.jpeg` |
| matériels de guerre, materiels de guerre | `assets/images/armes_materiels_guerre.jpeg` |
| acquisition, détention, detention | `assets/images/armes_acquisition_detention.jpeg` |
| port, transport | `assets/images/armes_port_transport.jpeg` |
| introduction générale, introduction generale | `assets/images/libertes_intro.jpeg` |
| garanties | `assets/images/libertes_garanties.jpeg` |
| expression collectives | `assets/images/libertes_expression.jpeg` |
| vie privée, vie privee | `assets/images/libertes_vie_privee.jpeg` |
| stupéfiants, stupefiants | `assets/images/stupefiants.jpeg` |
| cession, offre illicite | `assets/images/stup_cession_offre.jpeg` |
| direction, organisation | `assets/images/stup_direction_org.jpeg` |
| facilitation | `assets/images/stup_facilitation.jpeg` |
| production, fabrication | `assets/images/stup_production.jpeg` |
| provocation d’un majeur, provocation d\ | `assets/images/stup_provocation.jpeg` |
| blanchiment | `assets/images/stup_blanchiment.jpeg` |
| transport, détention, detention | `assets/images/stup_transport_detention.jpeg` |
| importation, exportation | `assets/images/stup_import_export.jpeg` |
| usage illicite | `assets/images/stup_usage.jpeg` |
| _(défaut)_ | `assets/images/generalite.jpeg` |

**PA School — `_subtitleFor` (26 règles, ordre = priorité)**

| mots-clés (label.toLowerCase().contains) | valeur |
|---|---|
| classification | `Concepts de base` |
| infraction | `Éléments légal, matériel & moral` |
| tentative | `Actes non consommés mais punissables` |
| complic | `Participation punissable à l’infraction` |
| légitime, legitime | `Protection immédiate et nécessaire` |
| armes | `Usage et régimes applicables` |
| libert | `Droits fondamentaux et garanties` |
| rétention, retention | `Mesures temporaires en locaux de police` |
| quiz generalites | `Testez vos connaissances sur les généralités` |
| cadres d\, cadres d’enquête | `Vue d’ensemble des différents cadres prévus par le code de procédure pénale` |
| flagrant | `Enquête de police sur infraction flagrante (art. 53 à 73 du code de procédure pénale)` |
| préliminaire, preliminaire | `Cadre d’enquête hors flagrance (art. 75 à 78 du code de procédure pénale)` |
| commission, rogatoire | `Instruction déléguée par le juge (art. 81 et 151 à 154-2 du code de procédure pénale)` |
| découverte, blessée | `Premiers actes en cas de blessé grave (art. 74 al. 6 du code de procédure pénale)` |
| mort, cause inconnue, suspecte | `Constat, enquête et saisines (art. 74 et 80-4 du code de procédure pénale)` |
| délinquance, criminalité | `Procédure renforcée pour la délinquance et la criminalité organisées` |
| personnes, fuite | `Cadre juridique de la recherche des personnes recherchées (art. 74-2 du code de procédure pénale)` |
| disparitions, inquiétantes | `Disparition de cause inconnue ou suspecte (art. 74-1 et 80-4 du code de procédure pénale)` |
| contrôles, vérifications, identité | `Contrôles, relevés signalétiques et vérifications d’identité` |
| entraide, internationale | `Coopération entre autorités judiciaires françaises et étrangères` |
| quiz cadres | `Testez vos connaissances sur la procédure pénale` |
| action publique, autorités, police judiciaire, mission de police | `Action civile/pénale, organisation, compétences, contrôle PJ` |
| nullité, actes de procédure | `Causes, effets et régime juridique des nullités` |
| juridictions, jugement, exécution des décisions | `Organisation, compétences, voies de recours, exécution` |
| instruction préparatoire, mandats de justice, contrôle judiciaire, détention provisoire, detention provisoire | `Instruction, mandats, CJ, détention provisoire` |
| quiz instruction | `Testez vos connaissances sur la procédure pénale` |
| _(défaut)_ | `Module` |

**GPX School — `_imageFor` (93 règles, ordre = priorité)**

| mots-clés (label.toLowerCase().contains) | valeur |
|---|---|
|  | `assets/images/quiz.jpeg` |
| quiz generalite, quiz generalite | `assets/images/quiz.jpeg` |
| classification | `assets/images/classification.jpeg` |
| infraction | `assets/images/infraction_materiel.jpeg` |
| tentative | `assets/images/infraction_legal.jpeg` |
| complic | `assets/images/complicite.jpeg` |
| légitime, legitime | `assets/images/legitime_defense.jpeg` |
| arme, cadre légal | `assets/images/armes_munitions.jpeg` |
| libert | `assets/images/libertes_publiques.jpeg` |
| rétention, retention | `assets/images/retention.jpeg` |
| hierarchie, hierarchie | `assets/images/libertes_intro.jpeg` |
| quiz cadres, quiz cadres | `assets/images/quiz.jpeg` |
| cadres d\, cadres d’enquête | `assets/images/cadres_enquete.jpeg` |
| flagrant | `assets/images/enquete_flagrant.jpeg` |
| préliminaire, preliminaire | `assets/images/enquete_preliminaire.jpeg` |
| commission, rogatoire | `assets/images/commission_rogatoire.jpeg` |
| découverte, blessée | `assets/images/personne_blessee.jpeg` |
| mort, cause inconnue, suspecte | `assets/images/mort_suspecte.jpeg` |
| délinquance, criminalité | `assets/images/criminalite_organisee.jpeg` |
| personnes, fuite | `assets/images/recherche_fuite.jpeg` |
| disparitions, inquiétantes | `assets/images/abandon_famille.jpeg` |
| contrôles, vérifications, identité | `assets/images/controle_identite.jpeg` |
| entraide, internationale | `assets/images/libertes_expression.jpeg` |
| action publique, autorités, police judiciaire, mission de police | `assets/images/pp_action_publique_autorites_pj.jpeg` |
| nullité, actes de procédure | `assets/images/pp_nullite_actes.jpeg` |
| juridictions, jugement, exécution des décisions | `assets/images/pp_juridictions_execution.jpeg` |
| quiz instruction préparatoire, quiz instruction preparatoire | `assets/images/quiz.jpeg` |
| instruction préparatoire, instruction preparatoire, mandats de justice, contrôle judiciaire, controle judiciaire, détention provisoire, detention provisoire | `assets/images/pp_instruction_mandats_detention.jpeg` |
| loi pénale, loi penale | `assets/images/droit_penal_general.jpeg` |
| responsabilité pénale, responsabilite penale | `assets/images/droit_penal_general_2.jpeg` |
| peines, sûreté, surete | `assets/images/sanction.jpeg` |
| aggravation | `assets/images/aggravations.jpeg` |
| pluralité, pluralite | `assets/images/pluralite_infractions.jpeg` |
| quiz, sanction, sanction | `assets/images/quiz.jpeg` |
| mise en danger | `assets/images/mise_en_danger.jpeg` |
| viol, agressions sexuelles | `assets/images/viol_agressions.jpeg` |
| enlèvement, enlevement | `assets/images/enlevement.jpeg` |
| diffusion d’images, diffusion d\ | `assets/images/diffusion_images.jpeg` |
| dignité, dignite | `assets/images/dignite.jpeg` |
| personnalité, personnalite | `assets/images/personnalite.jpeg` |
| involontaires | `assets/images/atteintes_involontaires.jpeg` |
| volontaires à la vie, volontaires a la vie | `assets/images/atteintes_vie.jpeg` |
| volontaires à l’intégrité, volontaires a l’integrite, integrite | `assets/images/atteintes_integrite.jpeg` |
| mineurs | `assets/images/mineurs_famille.jpeg` |
| jaf | `assets/images/ordonnances_jaf.jpeg` |
| autorité parentale, autorite parentale | `assets/images/autorite_parentale.jpeg` |
| abandon de famille | `assets/images/abandon_famille.jpeg` |
| association de malfaiteurs | `assets/images/association_malfaiteurs.jpeg` |
| abus d’autorité, abus d\ | `assets/images/abus_autorite.jpeg` |
| action de la justice | `assets/images/action_justice.jpeg` |
| administration par des particuliers | `assets/images/administration_particuliers.jpeg` |
| faux, usage | `assets/images/faux_usage_faux.jpeg` |
| probité, probite | `assets/images/probite.jpeg` |
| recel | `assets/images/recel.jpeg` |
| vol | `assets/images/vol.jpeg` |
| stad | `assets/images/stad.jpeg` |
| chèques, cheques, contrefa | `assets/images/contrefacons.jpeg` |
| destructions, dégradations, degradations | `assets/images/destructions.jpeg` |
| voisines du vol | `assets/images/voisines_vol.jpeg` |
| stupéfiants, stupefiants | `assets/images/conduite_stupefiants.jpeg` |
| ivresse | `assets/images/ivresse.jpeg` |
| état alcoolique, etat alcoolique | `assets/images/etat_alcoolique.jpeg` |
| assurance | `assets/images/defaut_assurance.jpeg` |
| permis | `assets/images/defaut_permis.jpeg` |
| délit de fuite, delit de fuite | `assets/images/delit_fuite.jpeg` |
| excès de vitesse, exces de vitesse | `assets/images/grand_exces_vitesse.jpeg` |
| vérifications, verifications | `assets/images/refus_verifications.jpeg` |
| obtempérer, obtemperer | `assets/images/refus_obtemperer.jpeg` |
| rodéo, rodeo | `assets/images/rodeo_motorise.jpeg` |
| plaques, inscriptions | `assets/images/plaques_inscriptions.jpeg` |
| incitation, organisation, promotion | `assets/images/image4.jpeg` |
| classification des armes | `assets/images/armes_munitions.jpeg` |
| définitions, definitions | `assets/images/armes_definitions.jpeg` |
| introduction | `assets/images/armes_intro.jpeg` |
| cat. a, cat. b, cat a, cat b | `assets/images/armes_cat_ab.jpeg` |
| cat. c, cat. d, cat c, cat d | `assets/images/armes_cat_cd.jpeg` |
| matériels de guerre, materiels de guerre | `assets/images/armes_materiels_guerre.jpeg` |
| acquisition, détention, detention | `assets/images/armes_acquisition_detention.jpeg` |
| port, transport | `assets/images/armes_port_transport.jpeg` |
| introduction générale, introduction generale | `assets/images/libertes_intro.jpeg` |
| garanties | `assets/images/libertes_garanties.jpeg` |
| expression collectives | `assets/images/libertes_expression.jpeg` |
| vie privée, vie privee | `assets/images/libertes_vie_privee.jpeg` |
| stupéfiants, stupefiants | `assets/images/stupefiants.jpeg` |
| cession, offre illicite | `assets/images/stup_cession_offre.jpeg` |
| direction, organisation | `assets/images/stup_direction_org.jpeg` |
| facilitation | `assets/images/stup_facilitation.jpeg` |
| production, fabrication | `assets/images/stup_production.jpeg` |
| provocation d’un majeur, provocation d\ | `assets/images/stup_provocation.jpeg` |
| blanchiment | `assets/images/stup_blanchiment.jpeg` |
| transport, détention, detention | `assets/images/stup_transport_detention.jpeg` |
| importation, exportation | `assets/images/stup_import_export.jpeg` |
| usage illicite | `assets/images/conduite_stupefiants.jpeg` |
| _(défaut)_ | `assets/images/generalite.jpeg` |

**GPX School — `_subtitleFor` (26 règles, ordre = priorité)**

| mots-clés (label.toLowerCase().contains) | valeur |
|---|---|
| classification | `Concepts de base` |
| infraction | `Éléments légal, matériel & moral` |
| tentative | `Actes non consommés mais punissables` |
| complic | `Participation punissable à l’infraction` |
| légitime, legitime | `Protection immédiate et nécessaire` |
| armes | `Usage et régimes applicables` |
| libert | `Droits fondamentaux et garanties` |
| rétention, retention | `Mesures temporaires en locaux de police` |
| quiz generalites | `Testez vos connaissances sur les généralités` |
| cadres d\, cadres d’enquête | `Vue d’ensemble des différents cadres prévus par le code de procédure pénale` |
| flagrant | `Enquête de police sur infraction flagrante (art. 53 à 73 du code de procédure pénale)` |
| préliminaire, preliminaire | `Cadre d’enquête hors flagrance (art. 75 à 78 du code de procédure pénale)` |
| commission, rogatoire | `Instruction déléguée par le juge (art. 81 et 151 à 154-2 du code de procédure pénale)` |
| découverte, blessée | `Premiers actes en cas de blessé grave (art. 74 al. 6 du code de procédure pénale)` |
| mort, cause inconnue, suspecte | `Constat, enquête et saisines (art. 74 et 80-4 du code de procédure pénale)` |
| délinquance, criminalité | `Procédure renforcée pour la délinquance et la criminalité organisées` |
| personnes, fuite | `Cadre juridique de la recherche des personnes recherchées (art. 74-2 du code de procédure pénale)` |
| disparitions, inquiétantes | `Disparition de cause inconnue ou suspecte (art. 74-1 et 80-4 du code de procédure pénale)` |
| contrôles, vérifications, identité | `Contrôles, relevés signalétiques et vérifications d’identité` |
| entraide, internationale | `Coopération entre autorités judiciaires françaises et étrangères` |
| quiz cadres | `Testez vos connaissances sur la procédure pénale` |
| action publique, autorités, police judiciaire, mission de police | `Action civile/pénale, organisation, compétences, contrôle PJ` |
| nullité, actes de procédure | `Causes, effets et régime juridique des nullités` |
| juridictions, jugement, exécution des décisions | `Organisation, compétences, voies de recours, exécution` |
| instruction préparatoire, mandats de justice, contrôle judiciaire, détention provisoire, detention provisoire | `Instruction, mandats, CJ, détention provisoire` |
| quiz instruction | `Testez vos connaissances sur la procédure pénale` |
| _(défaut)_ | `Module` |

---

## Annexe B — Écarts doc ↔ code relevés

- `MISE_A_JOUR_HOME_PA_EXAM_REFERENCE_COMPLETE.md` §8 annonce un deck de 330 px pour PA exam ; le code actuel est responsive 232/272/320 (Exam) et 330 fixe (School). Le code fait foi.
- Le doc §9 cite `_ResumeSkeleton/_ResumeCard/_StartCard` et un en-tête 16 px « Voir mon parcours » ; le code délègue à `ContinuePreparationPanel` (titre 18 px, pill « Mon parcours »).
- Le doc §14 cite les intitulés « Concours Gardien de la paix », « École Policier adjoint », « École Gardien de la paix » ; les intitulés réels affichés sont « Examen — Gardien de la paix », « Scolarité — Policier Adjoint », « Scolarité — Gardien de la Paix ».
- PA exam : la recherche n'a aucune logique (champ décoratif).
- GPX exam : sous-carte « Langue & culture générale » (`/gpx_exam/concours/culture_generale_langue`) ouvre en réalité `QuizCultureGeneralFrance` (même quiz que « Français & Humanités »).
- PA exam : cible du badge Premium `/abonnement` ; GPX exam : `/subscription` (incohérence de route).
- Bas de liste : Exam réserve `64+8+safe+24` px sous la nav ; School seulement 24 px (le dernier bloc peut passer sous la nav flottante).
