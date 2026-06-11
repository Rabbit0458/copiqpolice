// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Page "Mes appels" (lecture seule user)        ║
// ║  Référence : docs/cas_pratique/05_DESIGN_SYSTEM.md                      ║
// ║  Tâche      : CODE-045                                                  ║
// ║                                                                         ║
// ║  Liste de tous les appels que l'utilisateur a soumis, avec :           ║
// ║   - Chips filtres par statut (Tous / En cours / Approuvés / Rejetés)  ║
// ║   - Cards premium : statut pill + message tronqué + date + admin reply ║
// ║   - Pull-to-refresh + skeleton / empty / error                         ║
// ║   - Realtime auto-refresh : on écoute watchMyAppeals() et reflete les ║
// ║     changements de statut sans rechargement manuel.                    ║
// ║                                                                         ║
// ║  Route : `/gpx_exam/concours/cas_pratique/my_appeals` (enregistrée    ║
// ║  dans app_router.dart sous `CasPratiqueMyAppealsPage.routeName`).      ║
// ╚════════════════════════════════════════════════════════════════════════╝

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:copiqpolice/core/cas_pratique/theme/cp_tokens.dart';
import 'package:copiqpolice/core/cas_pratique/widgets/cas_pratique_scaffold.dart';
import 'package:copiqpolice/data/cas_pratique/cas_pratique_exception.dart';
import 'package:copiqpolice/data/cas_pratique/cas_pratique_repository.dart';
import 'package:copiqpolice/data/cas_pratique/cas_pratique_repository_impl.dart';
import 'package:copiqpolice/data/cas_pratique/models/cas_pratique_models.dart';

/// Filtre statut UI (super-set du modèle pour autoriser "tous").
enum _AppealFilter { all, pending, approved, rejected }

class CasPratiqueMyAppealsPage extends StatefulWidget {
  const CasPratiqueMyAppealsPage({super.key});

  static const String routeName = '/gpx_exam/concours/cas_pratique/my_appeals';

  @override
  State<CasPratiqueMyAppealsPage> createState() =>
      _CasPratiqueMyAppealsPageState();
}

class _CasPratiqueMyAppealsPageState extends State<CasPratiqueMyAppealsPage> {
  final CasPratiqueRepository _repo = CasPratiqueRepositoryImpl();

  List<Appeal>? _appeals;
  Object? _loadError;
  bool _loading = true;
  StreamSubscription<Appeal>? _realtimeSub;

  _AppealFilter _filter = _AppealFilter.all;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadAll());
  }

  @override
  void dispose() {
    _realtimeSub?.cancel();
    super.dispose();
  }

  // ─── Data ───────────────────────────────────────────────────────────────

  Future<void> _loadAll() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });
    try {
      final list = await _repo.listMyAppeals();
      if (!mounted) return;
      setState(() {
        _appeals = list;
        _loading = false;
      });
      _startRealtime();
    } on CasPratiqueException catch (e) {
      if (!mounted) return;
      setState(() {
        _loadError = e;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadError = CasPratiqueException.unknown(e);
        _loading = false;
      });
    }
  }

  void _startRealtime() {
    _realtimeSub?.cancel();
    try {
      _realtimeSub = _repo.watchMyAppeals().listen(
        _onAppealEvent,
        onError: (_) {/* silencieux : la liste manuelle reste utilisable */},
        cancelOnError: false,
      );
    } catch (_) {/* pas grave si realtime indispo */}
  }

  /// Insert ou update un appel dans la liste en mémoire.
  void _onAppealEvent(Appeal a) {
    final current = List<Appeal>.from(_appeals ?? const []);
    final idx = current.indexWhere((x) => x.id == a.id);
    if (idx < 0) {
      current.insert(0, a);
    } else {
      current[idx] = a;
    }
    // Re-tri par created_at desc (au cas où)
    current.sort((x, y) => y.createdAt.compareTo(x.createdAt));
    if (!mounted) return;
    setState(() => _appeals = current);
  }

  Future<void> _refresh() async {
    HapticFeedback.selectionClick();
    await _loadAll();
  }

  // ─── UI ─────────────────────────────────────────────────────────────────

  List<Appeal> _visible() {
    final all = _appeals ?? const <Appeal>[];
    switch (_filter) {
      case _AppealFilter.all:
        return all;
      case _AppealFilter.pending:
        return all.where((a) => a.status == AppealStatus.pending).toList();
      case _AppealFilter.approved:
        return all.where((a) => a.status == AppealStatus.approved).toList();
      case _AppealFilter.rejected:
        return all.where((a) => a.status == AppealStatus.rejected).toList();
    }
  }

  void _setFilter(_AppealFilter f) {
    if (_filter == f) return;
    HapticFeedback.selectionClick();
    setState(() => _filter = f);
  }

  @override
  Widget build(BuildContext context) {
    return CasPratiqueScaffold(
      title: 'Mes appels',
      subtitle: _subtitleText(),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _FilterChipsRow(
              current: _filter,
              onSelect: _setFilter,
              counts: _countByStatus(),
            ),
            const SizedBox(height: CpTokens.s3),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  String? _subtitleText() {
    final n = _appeals?.length;
    if (n == null) return null;
    if (n == 0) return 'Aucun appel pour le moment';
    return '$n appel${n > 1 ? 's' : ''} au total';
  }

  Map<_AppealFilter, int> _countByStatus() {
    final all = _appeals ?? const <Appeal>[];
    return {
      _AppealFilter.all: all.length,
      _AppealFilter.pending:
          all.where((a) => a.status == AppealStatus.pending).length,
      _AppealFilter.approved:
          all.where((a) => a.status == AppealStatus.approved).length,
      _AppealFilter.rejected:
          all.where((a) => a.status == AppealStatus.rejected).length,
    };
  }

  Widget _buildBody() {
    if (_loading) {
      return const _SkeletonList();
    }
    if (_loadError != null) {
      return _ErrorState(error: _loadError, onRetry: _refresh);
    }
    final visible = _visible();
    if (visible.isEmpty) {
      return _EmptyState(
        filter: _filter,
        hasAnyAppeals: (_appeals ?? const []).isNotEmpty,
        onClearFilter: () => _setFilter(_AppealFilter.all),
        onRetry: _refresh,
      );
    }
    return RefreshIndicator(
      onRefresh: _refresh,
      color: CpTokens.blueLight,
      backgroundColor: Colors.white,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 22),
        itemCount: visible.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (_, i) => _AppealCard(appeal: visible[i]),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  FILTER CHIPS ROW (statut)
// ═══════════════════════════════════════════════════════════════════════════

class _FilterChipsRow extends StatelessWidget {
  const _FilterChipsRow({
    required this.current,
    required this.onSelect,
    required this.counts,
  });

  final _AppealFilter current;
  final void Function(_AppealFilter) onSelect;
  final Map<_AppealFilter, int> counts;

  @override
  Widget build(BuildContext context) {
    final items = <({_AppealFilter v, String label, Color color})>[
      (v: _AppealFilter.all,      label: 'Tous',      color: Colors.white),
      (v: _AppealFilter.pending,  label: 'En cours',  color: CpTokens.info),
      (v: _AppealFilter.approved, label: 'Approuvés', color: CpTokens.success),
      (v: _AppealFilter.rejected, label: 'Rejetés',   color: CpTokens.danger),
    ];
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        physics: const BouncingScrollPhysics(),
        children: [
          for (final it in items) ...[
            _Chip(
              label: it.label,
              count: counts[it.v] ?? 0,
              active: current == it.v,
              accent: it.color,
              onTap: () => onSelect(it.v),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.count,
    required this.active,
    required this.accent,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool active;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bg = active ? Colors.white : Colors.white.withValues(alpha: 0.12);
    final stroke = active ? Colors.white : Colors.white.withValues(alpha: 0.18);
    final fg = active ? CpTokens.darkNavy : Colors.white.withValues(alpha: 0.92);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: stroke, width: 1.2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8, height: 8,
              decoration: BoxDecoration(
                color: accent,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.montserrat(
                color: fg,
                fontWeight: FontWeight.w900,
                fontSize: 12.5,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: active
                    ? CpTokens.darkNavy
                    : Colors.white.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '$count',
                style: GoogleFonts.montserrat(
                  color: active
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.92),
                  fontWeight: FontWeight.w900,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  CARD
// ═══════════════════════════════════════════════════════════════════════════

class _AppealCard extends StatelessWidget {
  const _AppealCard({required this.appeal});
  final Appeal appeal;

  ({Color main, Color soft, IconData icon, String shortLabel}) _styleFor(
    BuildContext context,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (appeal.status) {
      case AppealStatus.pending:
        return (
          main: CpTokens.infoFor(isDark),
          soft: isDark ? CpTokens.infoSoftD : CpTokens.infoSoftL,
          icon: Icons.hourglass_top_rounded,
          shortLabel: 'En cours',
        );
      case AppealStatus.approved:
        return (
          main: CpTokens.successFor(isDark),
          soft: isDark ? CpTokens.successSoftD : CpTokens.successSoftL,
          icon: Icons.check_circle_rounded,
          shortLabel: 'Approuvé',
        );
      case AppealStatus.rejected:
        return (
          main: CpTokens.dangerFor(isDark),
          soft: isDark ? CpTokens.dangerSoftD : CpTokens.dangerSoftL,
          icon: Icons.cancel_rounded,
          shortLabel: 'Rejeté',
        );
    }
  }

  String _dateLabel(DateTime utc) {
    final local = utc.toLocal();
    final diff = DateTime.now().difference(local);
    if (diff.inMinutes < 1)  return 'à l\'instant';
    if (diff.inMinutes < 60) return 'il y a ${diff.inMinutes} min';
    if (diff.inHours < 24)   return 'il y a ${diff.inHours} h';
    if (diff.inDays < 7)     return 'il y a ${diff.inDays} j';
    final d = local;
    return '${d.day.toString().padLeft(2, '0')}/'
        '${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;
    final surface = CpTokens.surface(isDark);
    final onSurface = CpTokens.onSurface(isDark);
    final onSurfaceMuted = CpTokens.onSurfaceMuted(isDark);
    final onSurfaceFaint = CpTokens.onSurfaceFaint(isDark);
    final style = _styleFor(context);

    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(CpTokens.r3),
        border: Border.all(color: cs.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.30 : 0.08),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(
        CpTokens.s4, CpTokens.s3, CpTokens.s4, CpTokens.s3,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: style.soft,
                  borderRadius: BorderRadius.circular(11),
                ),
                alignment: Alignment.center,
                child: Icon(style.icon, color: style.main, size: 19),
              ),
              const SizedBox(width: CpTokens.s3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _StatusPill(
                          label: style.shortLabel.toUpperCase(),
                          color: style.main,
                          isDark: isDark,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _dateLabel(appeal.createdAt),
                          style: GoogleFonts.montserrat(
                            color: onSurfaceFaint,
                            fontWeight: FontWeight.w800,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      (appeal.message != null &&
                              appeal.message!.trim().isNotEmpty)
                          ? appeal.message!.trim()
                          : 'Pas de message ajouté.',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.montserrat(
                        color: onSurface,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (appeal.adminResponse != null &&
              appeal.adminResponse!.trim().isNotEmpty) ...[
            const SizedBox(height: CpTokens.s3),
            _AdminResponse(
              text: appeal.adminResponse!.trim(),
              processedAt: appeal.processedAt,
              accent: style.main,
              onSurface: onSurface,
              onSurfaceMuted: onSurfaceMuted,
              isDark: isDark,
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.label,
    required this.color,
    required this.isDark,
  });
  final String label;
  final Color color;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.18 : 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.50)),
      ),
      child: Text(
        label,
        style: GoogleFonts.montserrat(
          color: color,
          fontWeight: FontWeight.w900,
          fontSize: 10.0,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

class _AdminResponse extends StatelessWidget {
  const _AdminResponse({
    required this.text,
    required this.processedAt,
    required this.accent,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.isDark,
  });

  final String text;
  final DateTime? processedAt;
  final Color accent;
  final Color onSurface;
  final Color onSurfaceMuted;
  final bool isDark;

  String _dateLabel(DateTime t) {
    final local = t.toLocal();
    return '${local.day.toString().padLeft(2, '0')}/'
        '${local.month.toString().padLeft(2, '0')}/${local.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(CpTokens.s3),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: isDark ? 0.10 : 0.07),
        borderRadius: BorderRadius.circular(CpTokens.r2),
        border: Border.all(color: accent.withValues(alpha: 0.30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.support_agent_rounded, color: accent, size: 14),
              const SizedBox(width: 6),
              Text(
                'RÉPONSE DE L\'ÉQUIPE',
                style: GoogleFonts.montserrat(
                  color: accent,
                  fontWeight: FontWeight.w900,
                  fontSize: 10,
                  letterSpacing: 1.0,
                ),
              ),
              if (processedAt != null) ...[
                const Spacer(),
                Text(
                  _dateLabel(processedAt!),
                  style: GoogleFonts.montserrat(
                    color: onSurfaceMuted,
                    fontWeight: FontWeight.w700,
                    fontSize: 10.5,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 6),
          Text(
            text,
            style: GoogleFonts.montserrat(
              color: onSurface,
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

// ═══════════════════════════════════════════════════════════════════════════
//  SKELETON / EMPTY / ERROR
// ═══════════════════════════════════════════════════════════════════════════

class _SkeletonList extends StatefulWidget {
  const _SkeletonList();

  @override
  State<_SkeletonList> createState() => _SkeletonListState();
}

class _SkeletonListState extends State<_SkeletonList>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimmer = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _shimmer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 22),
      itemCount: 4,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (_, __) {
        return AnimatedBuilder(
          animation: _shimmer,
          builder: (_, ___) {
            final t = _shimmer.value;
            return Container(
              height: 96,
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
  const _EmptyState({
    required this.filter,
    required this.hasAnyAppeals,
    required this.onClearFilter,
    required this.onRetry,
  });

  final _AppealFilter filter;
  final bool hasAnyAppeals;
  final VoidCallback onClearFilter;
  final Future<void> Function() onRetry;

  String get _title {
    if (!hasAnyAppeals) return 'Aucun appel pour le moment';
    switch (filter) {
      case _AppealFilter.all:       return 'Aucun appel';
      case _AppealFilter.pending:   return 'Aucun appel en cours';
      case _AppealFilter.approved:  return 'Aucun appel approuvé';
      case _AppealFilter.rejected:  return 'Aucun appel rejeté';
    }
  }

  String get _subtitle {
    if (!hasAnyAppeals) {
      return 'Tu n\'as encore jamais fait appel.\n'
          'Sur une correction, tape "Faire appel" sur un point manqué.';
    }
    return 'Aucun appel ne correspond à ce filtre.';
  }

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
                Container(
                  width: 96, height: 96,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.10),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withValues(alpha: 0.20)),
                  ),
                  child: const Icon(
                    Icons.gavel_rounded,
                    color: Colors.white,
                    size: 42,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _subtitle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: Colors.white.withValues(alpha: 0.80),
                    fontWeight: FontWeight.w600,
                    fontSize: 12.5,
                    height: 1.45,
                  ),
                ),
                if (hasAnyAppeals && filter != _AppealFilter.all) ...[
                  const SizedBox(height: 18),
                  SizedBox(
                    height: 46,
                    child: ElevatedButton.icon(
                      onPressed: onClearFilter,
                      icon: const Icon(
                        Icons.filter_alt_off_rounded,
                        size: 18,
                      ),
                      label: Text(
                        'Voir tous les appels',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w900,
                          fontSize: 13.5,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: CpTokens.darkNavy,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                      ),
                    ),
                  ),
                ],
              ],
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

  String get _message {
    if (error is CasPratiqueException) {
      return CasPratiqueErrorMessages.of(
        (error as CasPratiqueException).code,
      );
    }
    return 'Une erreur est survenue.';
  }

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
                Container(
                  width: 96, height: 96,
                  decoration: BoxDecoration(
                    color: CpTokens.danger.withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: CpTokens.danger.withValues(alpha: 0.45),
                    ),
                  ),
                  child: const Icon(
                    Icons.cloud_off_rounded,
                    color: Colors.white,
                    size: 42,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Chargement impossible',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _message,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: Colors.white.withValues(alpha: 0.82),
                    fontWeight: FontWeight.w600,
                    fontSize: 12.5,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  height: 48,
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
