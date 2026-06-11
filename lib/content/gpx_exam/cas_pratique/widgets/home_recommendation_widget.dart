// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Home recommendation widget                    ║
// ║  Tâche      : CODE-062                                                  ║
// ║                                                                         ║
// ║  Widget premium "À toi de jouer" :                                      ║
// ║   - Header "À TOI DE JOUER" + bouton refresh                            ║
// ║   - 3 cards horizontales scrollables (1 par recommandation)             ║
// ║   - Couleur d'accent selon le thème + chip raison                      ║
// ║   - Tap → push CasPratiqueDynamicPage avec le slug                      ║
// ║                                                                         ║
// ║  Usage : juste l'inclure dans une Column de la home — il se charge    ║
// ║  tout seul.                                                              ║
// ╚════════════════════════════════════════════════════════════════════════╝

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:copiqpolice/content/gpx_exam/cas_pratique/cas_pratique_excercice/case_dynamic_page.dart';
import 'package:copiqpolice/core/cas_pratique/recommendations/recommendation_service.dart';
import 'package:copiqpolice/core/cas_pratique/theme/cp_tokens.dart';

class HomeRecommendationWidget extends StatefulWidget {
  const HomeRecommendationWidget({
    super.key,
    this.n = 3,
    this.onSurface,
    this.onSurfaceMuted,
  });

  /// Nombre de recommandations à afficher.
  final int n;

  /// Override de couleur de texte si nécessaire (white sur fond bleu, etc.).
  final Color? onSurface;
  final Color? onSurfaceMuted;

  @override
  State<HomeRecommendationWidget> createState() =>
      _HomeRecommendationWidgetState();
}

class _HomeRecommendationWidgetState extends State<HomeRecommendationWidget> {
  bool _loading = true;
  List<RecommendedCase> _items = const [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load({bool forceRefresh = false}) async {
    setState(() => _loading = _items.isEmpty);
    final list = await RecommendationService.instance
        .getNext(n: widget.n, forceRefresh: forceRefresh);
    if (!mounted) return;
    setState(() {
      _items = list;
      _loading = false;
    });
  }

  Future<void> _refresh() async {
    HapticFeedback.selectionClick();
    await _load(forceRefresh: true);
  }

  void _openCase(RecommendedCase r) {
    HapticFeedback.selectionClick();
    Navigator.of(context).pushNamed(
      CasPratiqueDynamicPage.routeName,
      arguments: r.slug,
    );
  }

  @override
  Widget build(BuildContext context) {
    final onSurface = widget.onSurface ?? Colors.white.withValues(alpha: 0.92);
    final onSurfaceMuted = widget.onSurfaceMuted ?? Colors.white.withValues(alpha: 0.62);

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                color: onSurface,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                'À TOI DE JOUER',
                style: GoogleFonts.montserrat(
                  color: onSurface,
                  fontWeight: FontWeight.w900,
                  fontSize: 11,
                  letterSpacing: 1.4,
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: _refresh,
                borderRadius: BorderRadius.circular(999),
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Icon(
                    Icons.refresh_rounded,
                    color: onSurfaceMuted,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Sélectionnés selon ton historique',
            style: GoogleFonts.montserrat(
              color: onSurfaceMuted,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 168,
            child: _loading
                ? const _SkeletonRow()
                : _items.isEmpty
                    ? _EmptyHint(textColor: onSurfaceMuted)
                    : ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: _items.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (_, i) {
                          final r = _items[i];
                          return _RecCard(rec: r, onTap: () => _openCase(r));
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  CARD
// ═══════════════════════════════════════════════════════════════════════════

class _RecCard extends StatelessWidget {
  const _RecCard({required this.rec, required this.onTap});
  final RecommendedCase rec;
  final VoidCallback onTap;

  Color _reasonColor() {
    switch (rec.reason) {
      case RecommendationReason.weakestThemeNew:    return CpTokens.warning;
      case RecommendationReason.weakestThemeReplay: return CpTokens.danger;
      case RecommendationReason.fresh:              return CpTokens.success;
      case RecommendationReason.unknown:            return CpTokens.blueLight;
    }
  }

  Color _difficultyColor() {
    switch (rec.difficulty) {
      case 'facile':    return CpTokens.success;
      case 'difficile': return CpTokens.danger;
      default:          return CpTokens.warning;
    }
  }

  String _periodLabel() {
    if (rec.month != null && rec.month!.isNotEmpty) {
      return '${rec.month} ${rec.year}';
    }
    return rec.year > 0 ? '${rec.year}' : '';
  }

  @override
  Widget build(BuildContext context) {
    final accent = CpTokens.themeColorFor(rec.themeSlug);
    final reasonColor = _reasonColor();
    final difficultyColor = _difficultyColor();
    final period = _periodLabel();

    return SizedBox(
      width: 268,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(CpTokens.r3),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(CpTokens.r3),
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  accent.withValues(alpha: 0.94),
                  Color.lerp(accent, Colors.black, 0.30) ?? accent,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(CpTokens.r3),
              boxShadow: [
                BoxShadow(
                  color: accent.withValues(alpha: 0.40),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Reason chip
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: reasonColor.withValues(alpha: 0.30),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: reasonColor.withValues(alpha: 0.65)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        rec.reason ==
                                RecommendationReason.weakestThemeReplay
                            ? Icons.replay_rounded
                            : Icons.auto_awesome_rounded,
                        size: 12,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        rec.reason.label.toUpperCase(),
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 9.5,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  rec.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 14.5,
                    height: 1.2,
                    letterSpacing: -0.2,
                  ),
                ),
                if (period.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    period,
                    style: GoogleFonts.montserrat(
                      color: Colors.white.withValues(alpha: 0.78),
                      fontWeight: FontWeight.w800,
                      fontSize: 11,
                    ),
                  ),
                ],
                const Spacer(),
                Text(
                  rec.reason.motivation,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(
                    color: Colors.white.withValues(alpha: 0.88),
                    fontWeight: FontWeight.w600,
                    fontSize: 11.5,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _Pill(
                      label: rec.difficulty,
                      color: difficultyColor,
                    ),
                    const SizedBox(width: 6),
                    _Pill(
                      label: '~${rec.estimatedMinutes} min',
                      color: Colors.white,
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.20),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.35),
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.20),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.55)),
      ),
      child: Text(
        label,
        style: GoogleFonts.montserrat(
          color: color,
          fontWeight: FontWeight.w900,
          fontSize: 10,
          letterSpacing: -0.1,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  Skeleton + empty
// ═══════════════════════════════════════════════════════════════════════════

class _SkeletonRow extends StatefulWidget {
  const _SkeletonRow();

  @override
  State<_SkeletonRow> createState() => _SkeletonRowState();
}

class _SkeletonRowState extends State<_SkeletonRow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      separatorBuilder: (_, __) => const SizedBox(width: 10),
      itemBuilder: (_, __) => AnimatedBuilder(
        animation: _ctrl,
        builder: (_, ___) {
          final t = _ctrl.value;
          return Container(
            width: 268,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06 + 0.04 * t),
              borderRadius: BorderRadius.circular(CpTokens.r3),
              border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
            ),
          );
        },
      ),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  const _EmptyHint({required this.textColor});
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(CpTokens.r3),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(20),
      child: Text(
        'Pas encore assez de données pour te recommander des cas.\n'
        'Démarre ton premier cas pour ouvrir l\'algorithme !',
        textAlign: TextAlign.center,
        style: GoogleFonts.montserrat(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 12,
          height: 1.45,
        ),
      ),
    );
  }
}
