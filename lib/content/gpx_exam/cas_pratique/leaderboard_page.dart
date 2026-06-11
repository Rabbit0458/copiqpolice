// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Page Leaderboard hebdomadaire                 ║
// ║  Tâche      : CODE-059                                                  ║
// ║                                                                         ║
// ║  Affiche le top 100 anonymisé + la position perso (si présente).      ║
// ║  Données rafraîchies toutes les heures côté DB (matview).              ║
// ║                                                                         ║
// ║  Route : `/gpx_exam/concours/cas_pratique/leaderboard` (à enregistrer  ║
// ║  dans app_router.dart, voir CODE-040 pour la procédure type).          ║
// ╚════════════════════════════════════════════════════════════════════════╝

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:copiqpolice/core/cas_pratique/gamification/leaderboard_service.dart';
import 'package:copiqpolice/core/cas_pratique/theme/cp_tokens.dart';
import 'package:copiqpolice/core/cas_pratique/widgets/cas_pratique_scaffold.dart';

class CasPratiqueLeaderboardPage extends StatefulWidget {
  const CasPratiqueLeaderboardPage({super.key});

  static const String routeName =
      '/gpx_exam/concours/cas_pratique/leaderboard';

  @override
  State<CasPratiqueLeaderboardPage> createState() =>
      _CasPratiqueLeaderboardPageState();
}

class _CasPratiqueLeaderboardPageState
    extends State<CasPratiqueLeaderboardPage> {
  bool _loading = true;
  Object? _error;
  List<LeaderboardEntry> _top = const [];
  MyLeaderboardPosition _me = MyLeaderboardPosition.outside;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load({bool forceRefresh = false}) async {
    setState(() {
      _loading = _top.isEmpty;
      _error = null;
    });
    try {
      final top = await LeaderboardService.instance
          .getTop(forceRefresh: forceRefresh);
      final me = await LeaderboardService.instance
          .getMyPosition(forceRefresh: forceRefresh);
      if (!mounted) return;
      setState(() {
        _top = top;
        _me = me;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e;
        _loading = false;
      });
    }
  }

  Future<void> _refresh() async {
    HapticFeedback.selectionClick();
    await _load(forceRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return CasPratiqueScaffold(
      title: 'Classement hebdo',
      subtitle: 'Top 100 sur 7 jours glissants',
      body: SafeArea(
        top: false,
        child: _loading
            ? const _SkeletonList()
            : _error != null
                ? _ErrorState(error: _error, onRetry: _refresh)
                : RefreshIndicator(
                    onRefresh: _refresh,
                    color: CpTokens.blueLight,
                    backgroundColor: Colors.white,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding:
                          const EdgeInsets.fromLTRB(18, 8, 18, 22),
                      children: [
                        _MyPositionCard(me: _me),
                        const SizedBox(height: 14),
                        if (_top.isEmpty)
                          const _EmptyState()
                        else
                          for (int i = 0; i < _top.length; i++) ...[
                            _LeaderboardTile(entry: _top[i]),
                            if (i < _top.length - 1)
                              const SizedBox(height: 10),
                          ],
                      ],
                    ),
                  ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  MY POSITION CARD
// ═══════════════════════════════════════════════════════════════════════════

class _MyPositionCard extends StatelessWidget {
  const _MyPositionCard({required this.me});
  final MyLeaderboardPosition me;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;
    final surface = CpTokens.surface(isDark);
    final onSurface = CpTokens.onSurface(isDark);
    final onSurfaceMuted = CpTokens.onSurfaceMuted(isDark);
    const accent = CpTokens.blueLight;

    if (!me.inLeaderboard) {
      return Container(
        padding: const EdgeInsets.all(CpTokens.s4),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(CpTokens.r3),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Row(
          children: [
            Container(
              width: 42, height: 42,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.leaderboard_rounded, color: accent, size: 20),
            ),
            const SizedBox(width: CpTokens.s3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tu n\'es pas encore classé',
                    style: GoogleFonts.montserrat(
                      color: onSurface,
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Gagne des XP cette semaine pour entrer dans le top.',
                    style: GoogleFonts.montserrat(
                      color: onSurfaceMuted,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(CpTokens.s4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [accent, Color.lerp(accent, Colors.black, 0.20) ?? accent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(CpTokens.r3),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: Colors.white.withValues(alpha: 0.32)),
            ),
            child: Text(
              '#${me.rank}',
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 16,
                letterSpacing: -0.2,
              ),
            ),
          ),
          const SizedBox(width: CpTokens.s3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  me.anonHandle ?? 'Toi',
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${me.weeklyXp ?? 0} XP cette semaine'
                  '${me.percentile != null ? '  ·  Top ${(100 - me.percentile!).toStringAsFixed(0)}%' : ''}',
                  style: GoogleFonts.montserrat(
                    color: Colors.white.withValues(alpha: 0.88),
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.bolt_rounded, color: Colors.white, size: 22),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  TILE (1 ligne du classement)
// ═══════════════════════════════════════════════════════════════════════════

class _LeaderboardTile extends StatelessWidget {
  const _LeaderboardTile({required this.entry});
  final LeaderboardEntry entry;

  ({Color bg, Color fg}) _rankStyle(BuildContext context, int rank) {
    if (rank == 1)  return (bg: const Color(0xFFFFD700), fg: const Color(0xFF7A5F00)); // gold
    if (rank == 2)  return (bg: const Color(0xFFC0C0C0), fg: const Color(0xFF555555)); // silver
    if (rank == 3)  return (bg: const Color(0xFFCD7F32), fg: Colors.white); // bronze
    return (
      bg: Colors.white.withValues(alpha: 0.10),
      fg: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;
    final surface = CpTokens.surface(isDark);
    final onSurface = CpTokens.onSurface(isDark);
    final onSurfaceMuted = CpTokens.onSurfaceMuted(isDark);
    final rs = _rankStyle(context, entry.rank);

    final selfBorder = entry.isSelf
        ? Border.all(color: CpTokens.blueLight, width: 2)
        : Border.all(color: cs.outlineVariant);

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: entry.isSelf
            ? CpTokens.blueLight.withValues(alpha: 0.06)
            : surface,
        borderRadius: BorderRadius.circular(CpTokens.r3),
        border: selfBorder,
        boxShadow: entry.isSelf
            ? [
                BoxShadow(
                  color: CpTokens.blueLight.withValues(alpha: 0.20),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: rs.bg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: entry.rank <= 3
                    ? Colors.white.withValues(alpha: 0.30)
                    : Colors.white.withValues(alpha: 0.18),
              ),
            ),
            alignment: Alignment.center,
            child: entry.rank <= 3
                ? Icon(
                    Icons.emoji_events_rounded,
                    color: rs.fg,
                    size: 20,
                  )
                : Text(
                    '#${entry.rank}',
                    style: GoogleFonts.montserrat(
                      color: rs.fg,
                      fontWeight: FontWeight.w900,
                      fontSize: 12.5,
                      letterSpacing: -0.2,
                    ),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      entry.anonHandle,
                      style: GoogleFonts.montserrat(
                        color: onSurface,
                        fontWeight: FontWeight.w900,
                        fontSize: 13.5,
                      ),
                    ),
                    if (entry.isSelf) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: CpTokens.blueLight,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          'TOI',
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 9,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${entry.actionsCount} action${entry.actionsCount > 1 ? 's' : ''} cette semaine',
                  style: GoogleFonts.montserrat(
                    color: onSurfaceMuted,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${entry.weeklyXp}',
                style: GoogleFonts.montserrat(
                  color: onSurface,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  letterSpacing: -0.4,
                ),
              ),
              Text(
                'XP',
                style: GoogleFonts.montserrat(
                  color: onSurfaceMuted,
                  fontWeight: FontWeight.w800,
                  fontSize: 10,
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  STATES (skeleton / empty / error)
// ═══════════════════════════════════════════════════════════════════════════

class _SkeletonList extends StatefulWidget {
  const _SkeletonList();

  @override
  State<_SkeletonList> createState() => _SkeletonListState();
}

class _SkeletonListState extends State<_SkeletonList>
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
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 22),
      itemCount: 8,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) {
        return AnimatedBuilder(
          animation: _ctrl,
          builder: (_, __) {
            final t = _ctrl.value;
            return Container(
              height: i == 0 ? 76 : 64,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05 + 0.04 * t),
                borderRadius: BorderRadius.circular(CpTokens.r3),
                border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
              ),
            );
          },
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 60, 18, 22),
      child: Column(
        children: [
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.10),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.20)),
            ),
            child: const Icon(
              Icons.leaderboard_rounded,
              color: Colors.white,
              size: 36,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Classement vide cette semaine',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Sois le premier à valider un cas pour ouvrir le bal.',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              color: Colors.white.withValues(alpha: 0.78),
              fontWeight: FontWeight.w600,
              fontSize: 12.5,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.error, required this.onRetry});
  final Object? error;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRetry,
      color: CpTokens.blueLight,
      backgroundColor: Colors.white,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 80, 18, 22),
        children: [
          Center(
            child: Column(
              children: [
                const Icon(
                  Icons.cloud_off_rounded,
                  color: Colors.white,
                  size: 44,
                ),
                const SizedBox(height: 14),
                Text(
                  'Chargement impossible',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  height: 46,
                  child: ElevatedButton(
                    onPressed: onRetry,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: CpTokens.darkNavy,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                    ),
                    child: Text(
                      'Réessayer',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

  }
}
