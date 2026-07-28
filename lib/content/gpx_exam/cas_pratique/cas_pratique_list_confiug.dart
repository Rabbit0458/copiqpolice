import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// ✅ ton import correct
import 'package:copiqpolice/core/widgets/app_notifier.dart' show AppSettingsController;
import 'package:copiqpolice/content/gpx_exam/cas_pratique/cas_pratique_excercice/case_dynamic_page.dart';
import 'package:copiqpolice/data/cas_pratique/cas_pratique_repository_impl.dart';
import 'package:copiqpolice/data/cas_pratique/models/cas_pratique_models.dart';
import 'package:copiqpolice/features/home/home_page_gpx_exam.dart';

/// Convertit `#RRGGBB` (ou `#AARRGGBB`) en [Color]. Retourne [fallback] si le
/// theme n'a pas de couleur exploitable — on ne veut jamais crasher la liste
/// pour une couleur mal saisie depuis le panel admin.
Color _hexToColor(String? hex, Color fallback) {
  if (hex == null) return fallback;
  var h = hex.trim().replaceFirst('#', '');
  if (h.length == 6) h = 'FF$h';
  if (h.length != 8) return fallback;
  final v = int.tryParse(h, radix: 16);
  return v == null ? fallback : Color(v);
}

class GpxCasPratiqueListPage extends StatefulWidget {
  const GpxCasPratiqueListPage({super.key});

  static const String routeName = '/gpx_exam/concours/cas_pratique/list';

  @override
  State<GpxCasPratiqueListPage> createState() => _GpxCasPratiqueListPageState();
}

// NB : TickerProviderStateMixin (et non Single…) car la page pilote maintenant
// deux AnimationController : le fond animé et la cascade d'apparition.
class _GpxCasPratiqueListPageState extends State<GpxCasPratiqueListPage>
    with TickerProviderStateMixin {
  /// Anime le fond en continu.
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  )..forward();

  // La cascade d'apparition est gérée carte par carte (_ApparitionCascade),
  // sans contrôleur partagé : voir le commentaire dans l'itemBuilder.

  /// ✅ Empêche les doubles taps / doubles navigations (fixe ! _debugLocked)
  bool _navBusy = false;

  // ─── Supabase data ───────────────────────────────────────────────────────
  final _repo = CasPratiqueRepositoryImpl();
  List<CaseSummary>? _cases;
  bool _loadingCases = true;
  String? _casesError;

  /// Nombre de cas récupérés par page.
  ///
  /// Auparavant la page appelait `listCases(limit: 50)` une seule fois : avec
  /// un catalogue de 22 cas cela passait inaperçu, mais tout cas au-delà du
  /// 50ᵉ devenait purement invisible pour l'utilisateur. Le catalogue visant
  /// 500 cas, la liste charge désormais par pages successives.
  ///
  /// 40 est un compromis : assez pour remplir plusieurs écrans d'un coup (donc
  /// pas de pagination perceptible au scroll normal), assez peu pour que le
  /// premier affichage reste rapide en réseau mobile dégradé.
  static const int _pageSize = 40;

  /// Distance (en pixels) avant le bas de liste à partir de laquelle on
  /// déclenche le chargement de la page suivante. Prendre de l'avance évite
  /// que l'utilisateur ne voie le spinner en scroll fluide.
  static const double _loadMoreThreshold = 600;

  final ScrollController _scrollController = ScrollController();

  /// `false` dès qu'une page revient incomplète : inutile de re-solliciter
  /// Supabase, on a atteint la fin du catalogue.
  bool _hasMoreCases = true;
  bool _loadingMoreCases = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadCases();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - _loadMoreThreshold) {
      _loadMoreCases();
    }
  }

  Future<void> _loadCases() async {
    try {
      final cases = await _repo.listCases(limit: _pageSize);
      if (mounted) {
        setState(() {
          _cases = cases;
          _loadingCases = false;
          // Une première page incomplète = catalogue plus court qu'une page.
          _hasMoreCases = cases.length == _pageSize;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _casesError = e.toString();
          _loadingCases = false;
        });
      }
    }
  }

  /// Charge la page suivante et l'ajoute à la liste courante.
  ///
  /// Les gardes en tête de méthode sont essentielles : `_onScroll` se déclenche
  /// à chaque frame de défilement, donc sans `_loadingMoreCases` on lancerait
  /// des dizaines de requêtes concurrentes pour la même page.
  Future<void> _loadMoreCases() async {
    if (_loadingMoreCases || !_hasMoreCases || _loadingCases) return;
    if (_cases == null) return;

    setState(() => _loadingMoreCases = true);

    try {
      final next = await _repo.listCases(
        limit: _pageSize,
        offset: _cases!.length,
      );
      if (!mounted) return;
      setState(() {
        // Filet anti-doublon : si deux appels se croisaient malgré les gardes,
        // un slug déjà présent ne doit pas produire une seconde carte.
        final seen = _cases!.map((c) => c.slug).toSet();
        _cases!.addAll(next.where((c) => seen.add(c.slug)));
        _hasMoreCases = next.length == _pageSize;
        _loadingMoreCases = false;
      });
    } catch (_) {
      if (!mounted) return;
      // Un échec de page suivante ne doit pas effacer les cas déjà affichés :
      // on relâche simplement le verrou, le prochain scroll réessaiera.
      setState(() => _loadingMoreCases = false);
    }
  }

  bool _reduceMotion(BuildContext context) {
    final mq = MediaQuery.maybeOf(context);
    final disableByOS = WidgetsBinding
        .instance
        .platformDispatcher
        .accessibilityFeatures
        .disableAnimations;
    return (mq?.disableAnimations ?? false) || disableByOS;
  }

  @override
  void dispose() {
    // Un seul dispose() sur le contrôleur : le rappeler une seconde fois lève
    // « A ScrollController was used after being disposed » au démontage.
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _c.dispose();
    super.dispose();
  }

  Future<void> _safeNav(Future<void> Function() action) async {
    if (_navBusy) return;
    _navBusy = true;
    try {
      // ✅ attend la fin du frame courant avant de naviguer (évite le "locked")
      await WidgetsBinding.instance.endOfFrame;
      if (!mounted) return;

      await action();
    } finally {
      _navBusy = false;
    }
  }

  void _goBack() {
    if (_navBusy) return;
    _navBusy = true;

    HapticFeedback.selectionClick();

    // On laisse Flutter finir les transitions / pops précédents
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) {
        _navBusy = false;
        return;
      }

      // micro délai = laisse finir l'unlock interne du Navigator
      await Future<void>.delayed(const Duration(milliseconds: 1));
      if (!mounted) {
        _navBusy = false;
        return;
      }

      final nav = Navigator.of(context, rootNavigator: true);

      try {
        if (nav.canPop()) {
          nav.pop();
        } else {
          // Cas fréquent : la page a été atteinte par pushReplacement, ou via un
          // deep link / une notification. La pile est alors vide, `canPop()`
          // renvoie false et l'ancien code ne faisait STRICTEMENT RIEN — le
          // bouton « Retour » paraissait mort.
          // On renvoie donc explicitement vers l'accueil « Préparation au
          // concours de Gardien de la Paix ».
          nav.pushNamedAndRemoveUntil(
            HomePageGpxExam.routeName,
            (route) => false,
          );
        }
      } finally {
        _navBusy = false;
      }
    });
  }

  void _openCase(String slug) {
    _safeNav(() async {
      HapticFeedback.selectionClick();
      if (!mounted) return;

      await Navigator.of(context).pushNamed(
        CasPratiqueDynamicPage.routeName,
        arguments: slug,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = _reduceMotion(context);
    final appCtrl = AppSettingsController.I;

    // ── Chargement depuis Supabase (dynamique) ─────────────────────────────
    final cases = _loadingCases
        ? <_CaseTileData>[]
        : (_cases ?? []).asMap().entries.map((e) {
            final idx = e.key;
            final c = e.value;
            final done = (c.userProgress?.attemptsCount ?? 0) > 0;
            final best = c.userProgress?.bestScorePercent;
            return _CaseTileData(
              index: idx + 1,
              title: c.title,
              points: c.totalPoints,
              eta: '~ ${c.estimatedMinutes} min',
              slug: c.slug,
              themeLabel: c.theme?.label,
              themeColor: _hexToColor(c.theme?.colorHex, const Color(0xFF1147D9)),
              difficulty: c.difficulty,
              status: done ? _CaseStatus.done : _CaseStatus.ready,
              score15: (done && best != null)
                  ? (best / 100 * c.totalPoints).round()
                  : null,
            );
          }).toList();

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: appCtrl.themeMode,
      builder: (_, mode, __) {
        final theme = Theme.of(context);

        // ✅ système / dark / light (comme tes autres pages)
        final platformDark = theme.brightness == Brightness.dark;
        final bool isDark = switch (mode) {
          ThemeMode.dark => true,
          ThemeMode.light => false,
          ThemeMode.system => platformDark,
        };

        final cs = theme.colorScheme;

        // ✅ Fond COP’IQ : Light vraiment clair / Dark navy
        final bgTop = isDark
            ? const Color(0xFF000B36)
            : const Color(0xFF1147D9);
        final bgMid = isDark
            ? const Color(0xFF000A33)
            : const Color(0xFF1A55E6);
        final bgBot = isDark
            ? const Color(0xFF00082D)
            : const Color(0xFF0E2F9E);

        // ✅ Overlay contrast
        final overlayTop = Colors.black.withValues(alpha: isDark ? 0.32 : 0.22);
        final overlayBot = Colors.black.withValues(alpha: isDark ? 0.42 : 0.32);

        // ✅ Halo blanc (lumière premium)
        final haloA = Colors.white.withValues(alpha: isDark ? 0.10 : 0.07);
        final haloB = Colors.white.withValues(alpha: isDark ? 0.04 : 0.03);

        return Theme(
          data: theme.copyWith(
            textTheme: GoogleFonts.montserratTextTheme(theme.textTheme),
            splashFactory: InkSparkle.splashFactory,
          ),
          // Le bouton retour matériel d'Android doit suivre exactement la même
          // logique que la pastille « Retour » : sinon l'utilisateur sort de
          // l'app au lieu de revenir à l'accueil concours.
          child: PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) _goBack();
          },
          child: Scaffold(
            backgroundColor: bgTop,
            body: Stack(
              children: [
                // ✅ Fond principal gradient (COPIQ)
                Positioned.fill(
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [bgTop, bgMid, bgBot],
                        ),
                      ),
                    ),
                  ),
                ),

                // ✅ Halo blanc radial
                Positioned.fill(
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: const Alignment(0.0, -0.18),
                          radius: 1.18,
                          colors: [haloA, haloB, Colors.transparent],
                          stops: const [0.0, 0.62, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),

                // ✅ Backdrop premium (lignes)
                Positioned.fill(
                  child: _PremiumBackdrop(
                    enabledMotion: !reduceMotion,
                    controller: _c,
                    colorScheme: cs,
                    isDark: isDark,
                  ),
                ),

                // ✅ Overlay final contrast
                Positioned.fill(
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [overlayTop, Colors.transparent, overlayBot],
                        ),
                      ),
                    ),
                  ),
                ),

                SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(14, 12, 14, 6),
                        child: Row(
                          children: [
                            // ✅ bouton retour SAFE (désactivé pendant nav)
                            _BackButtonPill(
                              onTap: _navBusy ? () {} : _goBack,
                              fg: Colors.white.withValues(alpha: 0.92),
                              stroke: Colors.white.withValues(alpha: 0.18),
                              bg: Colors.white.withValues(alpha: 0.12),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    "Cas pratiques",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white.withValues(alpha: 0.98),
                                      fontWeight: FontWeight.w900,
                                      fontSize: 16.8,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    cases.isEmpty
                                        ? "Entraînement concours"
                                        : "${cases.length} cas · entraînement concours",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white.withValues(alpha: 0.78),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 76),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 10, 18, 12),
                        child: _BannerCard(
                          title: "Mode concours",
                          subtitle:
                              "Lis attentivement. Structure ta réponse.\nValide pour verrouiller la progression.",
                          chips: const [
                            _InfoChip(
                              icon: Icons.shield_rounded,
                              label: "Déontologie",
                            ),
                            _InfoChip(
                              icon: Icons.timer_rounded,
                              label: "Timing",
                            ),
                            _InfoChip(
                              icon: Icons.check_circle_rounded,
                              label: "Validation",
                            ),
                          ],
                          surface: cs.surface,
                          onSurface: cs.onSurface,
                          primary: cs.primary,
                          outline: cs.outlineVariant,
                          shadowOpacity: isDark ? 0.35 : 0.14,
                          chipBg: cs.primaryContainer.withValues(alpha: 
                            isDark ? 0.35 : 0.55,
                          ),
                          chipFg: cs.onPrimaryContainer,
                          chipStroke: cs.outlineVariant,
                        ),
                      ),

                      if (_loadingCases)
                        const Expanded(
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          ),
                        )
                      else if (_casesError != null)
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.wifi_off_rounded,
                                    color: Colors.white54, size: 40),
                                const SizedBox(height: 12),
                                Text(
                                  'Impossible de charger les cas',
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _loadingCases = true;
                                      _casesError = null;
                                    });
                                    _loadCases();
                                  },
                                  child: Text(
                                    'Réessayer',
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else if (cases.isEmpty)
                        Expanded(
                          child: Center(
                            child: Text(
                              'Aucun cas disponible pour le moment',
                              style: GoogleFonts.montserrat(
                                color: Colors.white70,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )
                      else
                      Expanded(
                        child: ListView.separated(
                          controller: _scrollController,
                          padding: const EdgeInsets.fromLTRB(18, 8, 18, 22),
                          // +1 quand il reste des pages : la dernière ligne est
                          // l'indicateur de chargement, pas une carte de cas.
                          itemCount: cases.length + (_hasMoreCases ? 1 : 0),
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 14),
                          itemBuilder: (context, i) {
                            if (i >= cases.length) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 18),
                                child: Center(
                                  child: SizedBox(
                                    height: 26,
                                    width: 26,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.4,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                              );
                            }

                            final d = cases[i];

                            final child = _CaseTile(
                              data: d,
                              onTap: () => _openCase(d.slug),
                              cs: cs,
                              isDark: isDark,
                            );

                            if (reduceMotion) return child;

                            // Chaque carte anime la sienne, via un
                            // TweenAnimationBuilder autonome.
                            //
                            // ⚠️ Choix délibéré : NE PAS repasser par un
                            // AnimationController partagé. Une cascade pilotée
                            // par un contrôleur unique a un défaut grave — si le
                            // contrôleur ne démarre pas (ordre d'initialisation,
                            // rebuild, données arrivées trop tôt ou trop tard),
                            // l'opacité reste à 0 et **toutes les cartes
                            // deviennent invisibles** alors que les données sont
                            // bien là. C'est exactement ce qui s'est produit.
                            //
                            // Ici l'état final (opaque, en place) est garanti :
                            // au pire l'animation ne se joue pas, mais la carte
                            // s'affiche toujours.
                            return _ApparitionCascade(
                              rang: i,
                              child: child,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ),
        );
      },
    );
  }
}

/// Fait apparaître une carte en fondu + glissement, avec un retard
/// proportionnel à son rang dans la liste (effet cascade).
///
/// Autonome par carte : aucun AnimationController partagé, donc aucun risque
/// qu'un problème d'ordonnancement laisse la liste entière invisible.
class _ApparitionCascade extends StatefulWidget {
  const _ApparitionCascade({required this.rang, required this.child});

  final int rang;
  final Widget child;

  @override
  State<_ApparitionCascade> createState() => _ApparitionCascadeState();
}

class _ApparitionCascadeState extends State<_ApparitionCascade> {
  bool _pret = false;

  @override
  void initState() {
    super.initState();
    // Retard plafonné : sur une longue liste, la dernière carte ne doit pas
    // attendre plusieurs secondes.
    final retard = Duration(milliseconds: math.min(600, widget.rang * 70));
    Future<void>.delayed(retard, () {
      if (mounted) setState(() => _pret = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _pret ? 1 : 0,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOut,
      child: AnimatedSlide(
        offset: _pret ? Offset.zero : const Offset(0.06, 0.10),
        duration: const Duration(milliseconds: 460),
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}

/* ───────────────────────────────────────────── */
/* BACKDROP (inchangé, déjà theme-driven)        */
/* ───────────────────────────────────────────── */

class _PremiumBackdrop extends StatelessWidget {
  const _PremiumBackdrop({
    required this.enabledMotion,
    required this.controller,
    required this.colorScheme,
    required this.isDark,
  });

  final bool enabledMotion;
  final AnimationController controller;
  final ColorScheme colorScheme;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // on laisse transparent pour ne pas écraser le fond COPIQ
        const DecoratedBox(
          decoration: BoxDecoration(),
          child: SizedBox.expand(),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: _LinesPainter(
                progress: enabledMotion ? controller : null,
                ink: Colors.white.withValues(alpha: isDark ? 0.055 : 0.040),
                glow: Colors.white.withValues(alpha: isDark ? 0.11 : 0.09),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.0, -0.2),
                  radius: 1.15,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: isDark ? 0.38 : 0.26),
                  ],
                  stops: const [0.55, 1.0],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LinesPainter extends CustomPainter {
  _LinesPainter({required this.progress, required this.ink, required this.glow})
    : super(repaint: progress);

  final Animation<double>? progress;
  final Color ink;
  final Color glow;

  @override
  void paint(Canvas canvas, Size size) {
    final t = progress?.value ?? 0.0;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = ink;

    for (int i = 0; i < 14; i++) {
      final y = (i / 14) * size.height;
      final wobble = math.sin((t * 2 * math.pi) + i) * 6.0;

      final p = Path()
        ..moveTo(0, y + wobble)
        ..cubicTo(
          size.width * 0.25,
          y - 8 + wobble,
          size.width * 0.75,
          y + 8 + wobble,
          size.width,
          y + wobble,
        );

      canvas.drawPath(p, paint);
    }

    final glowPaint = Paint()
      ..color = glow
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 24);

    canvas.drawCircle(
      Offset(size.width * 0.18, size.height * 0.12),
      80,
      glowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _LinesPainter oldDelegate) => false;
}

/* ───────────────────────────────────────────── */
/* TOP BUTTON                                   */
/* ───────────────────────────────────────────── */

class _BackButtonPill extends StatelessWidget {
  const _BackButtonPill({
    required this.onTap,
    required this.bg,
    required this.stroke,
    required this.fg,
  });

  final VoidCallback onTap;
  final Color bg;
  final Color stroke;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: "Retour",
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: stroke),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.chevron_left_rounded, size: 18, color: fg),
              const SizedBox(width: 4),
              Text(
                "Retour",
                style: GoogleFonts.montserrat(
                  color: fg,
                  fontWeight: FontWeight.w900,
                  fontSize: 12.5,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ───────────────────────────────────────────── */
/* BANNER                                       */
/* ───────────────────────────────────────────── */

class _BannerCard extends StatelessWidget {
  const _BannerCard({
    required this.title,
    required this.subtitle,
    required this.chips,
    required this.surface,
    required this.onSurface,
    required this.primary,
    required this.outline,
    required this.shadowOpacity,
    required this.chipBg,
    required this.chipFg,
    required this.chipStroke,
  });

  final String title;
  final String subtitle;
  final List<_InfoChip> chips;

  final Color surface;
  final Color onSurface;
  final Color primary;
  final Color outline;
  final double shadowOpacity;

  final Color chipBg;
  final Color chipFg;
  final Color chipStroke;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: outline),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: shadowOpacity),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: primary,
              boxShadow: [
                BoxShadow(
                  color: primary.withValues(alpha: 0.35),
                  blurRadius: 14,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.assignment_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                    color: onSurface,
                    fontWeight: FontWeight.w900,
                    fontSize: 15.2,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: GoogleFonts.montserrat(
                    color: onSurface.withValues(alpha: 0.80),
                    fontWeight: FontWeight.w700,
                    fontSize: 12.6,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: chips
                      .map(
                        (c) => _InfoChip(
                          icon: c.icon,
                          label: c.label,
                          bg: chipBg,
                          fg: chipFg,
                          stroke: chipStroke,
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
    this.bg,
    this.fg,
    this.stroke,
  });

  final IconData icon;
  final String label;

  final Color? bg;
  final Color? fg;
  final Color? stroke;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final chipBg = bg ?? cs.primaryContainer;
    final chipFg = fg ?? cs.onPrimaryContainer;
    final chipStroke = stroke ?? cs.outlineVariant;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: chipBg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: chipStroke),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: chipFg),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.montserrat(
              color: chipFg,
              fontWeight: FontWeight.w900,
              fontSize: 12.2,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }
}

/* ───────────────────────────────────────────── */
/* CASE TILE                                    */
/* ───────────────────────────────────────────── */

enum _CaseStatus { ready, locked, done }

class _CaseTileData {
  final int index;
  final String title;
  final int points;
  final String eta;
  final String slug;
  final _CaseStatus status;
  final int? score15;

  /// Libellé du thème (« Procédure pénale »…), piloté depuis le panel admin.
  final String? themeLabel;

  /// Couleur d'accent de la carte, issue de `cas_pratique_themes.color_hex`.
  final Color themeColor;

  final CpDifficulty difficulty;

  const _CaseTileData({
    required this.index,
    required this.title,
    required this.points,
    required this.eta,
    required this.slug,
    required this.status,
    required this.themeColor,
    required this.difficulty,
    this.themeLabel,
    this.score15,
  });
}

/// Couleur + libellé d'une difficulté. Volontairement indépendant du
/// ColorScheme : ces quatre teintes doivent rester lisibles dans les deux
/// thèmes et garder la même sémantique (vert = facile → violet = expert).
///
/// Le violet de `expert` est choisi hors de la rampe vert/ambre/rouge : ce
/// niveau ne signale pas « encore plus dangereux », mais une nature de cas
/// différente (situation évolutive, arbitrage déontologique). Une quatrième
/// nuance de rouge aurait été indiscernable de `difficile` en usage réel.
({Color color, String label}) _difficultyStyle(CpDifficulty d) => switch (d) {
      CpDifficulty.facile => (color: const Color(0xFF22C55E), label: 'Facile'),
      CpDifficulty.moyen => (color: const Color(0xFFF59E0B), label: 'Moyen'),
      CpDifficulty.difficile => (color: const Color(0xFFEF4444), label: 'Difficile'),
      CpDifficulty.expert => (color: const Color(0xFF8B5CF6), label: 'Expert'),
    };

class _CaseTile extends StatelessWidget {
  const _CaseTile({
    required this.data,
    required this.onTap,
    required this.cs,
    required this.isDark,
  });

  final _CaseTileData data;
  final VoidCallback onTap;
  final ColorScheme cs;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final locked = data.status == _CaseStatus.locked;
    final done = data.status == _CaseStatus.done;
    final accent = data.themeColor;
    final diff = _difficultyStyle(data.difficulty);

    return Opacity(
      opacity: locked ? 0.55 : 1.0,
      child: Material(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: locked ? null : onTap,
          splashColor: accent.withValues(alpha: 0.12),
          highlightColor: accent.withValues(alpha: 0.06),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              // Halo teinté du thème : la carte prend la couleur de sa matière
              // au lieu du gris uniforme précédent.
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.alphaBlend(
                    accent.withValues(alpha: isDark ? 0.16 : 0.09),
                    cs.surface,
                  ),
                  cs.surface,
                ],
                stops: const [0.0, 0.72],
              ),
              // Liseré épais à gauche + contour fin : porté par la décoration
              // et non par un Container dans un Row en CrossAxisAlignment
              // .stretch, qui exigeait une hauteur que la Row ne pouvait pas
              // fournir (contrainte verticale non bornée).
              border: Border(
                left: BorderSide(color: accent, width: 5),
                top: BorderSide(
                    color: accent.withValues(alpha: isDark ? 0.42 : 0.30),
                    width: 1.2),
                right: BorderSide(
                    color: accent.withValues(alpha: isDark ? 0.42 : 0.30),
                    width: 1.2),
                bottom: BorderSide(
                    color: accent.withValues(alpha: isDark ? 0.42 : 0.30),
                    width: 1.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: accent.withValues(alpha: isDark ? 0.22 : 0.14),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
                    padding: const EdgeInsets.fromLTRB(13, 14, 13, 14),
                    child: Row(
                      children: [
                        _NumberBadge(
                          index: data.index,
                          status: data.status,
                          cs: cs,
                          accent: accent,
                        ),
                        const SizedBox(width: 13),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (data.themeLabel != null) ...[
                                Text(
                                  data.themeLabel!.toUpperCase(),
                                  style: GoogleFonts.montserrat(
                                    color: accent,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 10.2,
                                    letterSpacing: 0.9,
                                  ),
                                ),
                                const SizedBox(height: 4),
                              ],
                              Text(
                                data.title,
                                style: GoogleFonts.montserrat(
                                  color: cs.onSurface,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15.4,
                                  height: 1.22,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  _Dot(color: diff.color, label: diff.label, cs: cs),
                                  _MetaChip(
                                    icon: Icons.stars_rounded,
                                    label: '${data.points} pts',
                                    cs: cs,
                                    accent: accent,
                                  ),
                                  _MetaChip(
                                    icon: Icons.schedule_rounded,
                                    label: data.eta,
                                    cs: cs,
                                    accent: accent,
                                  ),
                                  if (done)
                                    _StatusPillDone(
                                      score15: data.score15,
                                      cs: cs,
                                    ),
                                  if (locked) _StatusPillLocked(cs: cs),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: accent.withValues(alpha: isDark ? 0.20 : 0.12),
                          ),
                          child: Icon(
                            locked
                                ? Icons.lock_rounded
                                : Icons.arrow_forward_rounded,
                            color: accent,
                            size: 17,
                          ),
                        ),
                      ],
                    ),   // Row interne
            ),           // Padding
          ),             // Ink
        ),               // InkWell
      ),                 // Material
    );                   // Opacity
  }
}

/// Pastille de difficulté : un point de couleur + un mot. Plus lisible qu'un
/// badge plein, et ne concurrence pas la couleur du thème.
class _Dot extends StatelessWidget {
  const _Dot({required this.color, required this.label, required this.cs});

  final Color color;
  final String label;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            boxShadow: [
              BoxShadow(color: color.withValues(alpha: 0.55), blurRadius: 6),
            ],
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.montserrat(
            color: cs.onSurface.withValues(alpha: 0.82),
            fontWeight: FontWeight.w800,
            fontSize: 11.8,
            letterSpacing: -0.1,
          ),
        ),
      ],
    );
  }
}

class _NumberBadge extends StatelessWidget {
  const _NumberBadge({
    required this.index,
    required this.status,
    required this.cs,
    required this.accent,
  });

  final int index;
  final _CaseStatus status;
  final ColorScheme cs;

  /// Couleur du thème du cas : le badge en hérite pour que chaque matière
  /// soit identifiable d'un coup d'œil dans la liste.
  final Color accent;

  @override
  Widget build(BuildContext context) {
    Color bg;
    IconData? icon;

    switch (status) {
      case _CaseStatus.ready:
        bg = accent;
        icon = null;
        break;
      case _CaseStatus.locked:
        bg = cs.outline;
        icon = Icons.lock_rounded;
        break;
      case _CaseStatus.done:
        bg = const Color(0xFF22C55E);
        icon = Icons.check_rounded;
        break;
    }

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.alphaBlend(Colors.white.withValues(alpha: 0.22), bg),
            bg,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: bg.withValues(alpha: 0.42),
            blurRadius: 14,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Center(
        child: icon == null
            ? Text(
                '$index',
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 17.5,
                  letterSpacing: -0.3,
                ),
              )
            : Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({
    required this.icon,
    required this.label,
    required this.cs,
    this.accent,
  });

  final IconData icon;
  final String label;
  final ColorScheme cs;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final tint = accent ?? cs.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: tint.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: tint.withValues(alpha: 0.24)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13.5, color: tint),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.montserrat(
              color: cs.onSurface.withValues(alpha: 0.88),
              fontWeight: FontWeight.w800,
              fontSize: 11.8,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPillLocked extends StatelessWidget {
  const _StatusPillLocked({required this.cs});
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lock_rounded,
            size: 16,
            color: cs.onSurface.withValues(alpha: 0.75),
          ),
          const SizedBox(width: 6),
          Text(
            "Verrouillé",
            style: GoogleFonts.montserrat(
              color: cs.onSurface,
              fontWeight: FontWeight.w900,
              fontSize: 12.0,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPillDone extends StatelessWidget {
  const _StatusPillDone({required this.score15, required this.cs});
  final int? score15;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    final label = score15 != null ? '$score15 / 15' : 'Terminé';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: cs.tertiaryContainer,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cs.tertiary.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_rounded, size: 14, color: cs.tertiary),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.montserrat(
              color: cs.onTertiaryContainer,
              fontWeight: FontWeight.w700,
              fontSize: 11.5,
              letterSpacing: -0.1,
            ),
          ),
        ],
      ),
    );
  }
}