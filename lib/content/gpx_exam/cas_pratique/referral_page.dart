// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Page Parrainage                                ║
// ║  Tâche      : CODE-060                                                  ║
// ║                                                                         ║
// ║  Affiche le code de parrainage de l'user, ses stats (filleuls + XP    ║
// ║  gagnés), et propose à l'user de redeem un code reçu d'un autre user. ║
// ║                                                                         ║
// ║  Route : `/gpx_exam/concours/cas_pratique/referral` (enregistrée dans  ║
// ║  app_router.dart).                                                      ║
// ╚════════════════════════════════════════════════════════════════════════╝

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:copiqpolice/core/cas_pratique/gamification/referral_service.dart';
import 'package:copiqpolice/core/cas_pratique/theme/cp_tokens.dart';
import 'package:copiqpolice/core/cas_pratique/widgets/cas_pratique_scaffold.dart';

class CasPratiqueReferralPage extends StatefulWidget {
  const CasPratiqueReferralPage({super.key});

  static const String routeName =
      '/gpx_exam/concours/cas_pratique/referral';

  @override
  State<CasPratiqueReferralPage> createState() =>
      _CasPratiqueReferralPageState();
}

class _CasPratiqueReferralPageState extends State<CasPratiqueReferralPage> {
  ReferralCodeStatus _status = ReferralCodeStatus.empty;
  bool _loading = true;
  Object? _error;

  final TextEditingController _redeemCtrl = TextEditingController();
  bool _redeeming = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  void dispose() {
    _redeemCtrl.dispose();
    super.dispose();
  }

  Future<void> _load({bool forceRefresh = false}) async {
    setState(() {
      _loading = !_status.isValid;
      _error = null;
    });
    try {
      final s = await ReferralService.instance
          .getMyCode(forceRefresh: forceRefresh);
      if (!mounted) return;
      setState(() {
        _status = s;
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

  Future<void> _copyCode() async {
    if (!_status.isValid) return;
    await Clipboard.setData(ClipboardData(text: _status.code));
    HapticFeedback.selectionClick();
    if (!mounted) return;
    _snack('Code copié dans le presse-papier');
  }

  Future<void> _copyLink() async {
    if (!_status.isValid) return;
    final link = ReferralService.instance.shareLink(_status.code);
    await Clipboard.setData(ClipboardData(text: link));
    HapticFeedback.selectionClick();
    if (!mounted) return;
    _snack('Lien copié — partage-le où tu veux');
  }

  Future<void> _redeemSubmitted() async {
    final code = _redeemCtrl.text.trim().toUpperCase();
    if (code.isEmpty) return;
    HapticFeedback.lightImpact();
    setState(() => _redeeming = true);
    final result = await ReferralService.instance.redeem(code);
    if (!mounted) return;
    setState(() => _redeeming = false);
    if (result.ok) {
      HapticFeedback.mediumImpact();
      _redeemCtrl.clear();
      _snack('🎉 Bravo ! +${result.xpAwarded} XP ajoutés à ton compte.');
      await _load(forceRefresh: true);
    } else {
      _snack(_errorMessage(result.error));
    }
  }

  String _errorMessage(RedeemError? e) {
    switch (e) {
      case RedeemError.notAuthenticated:
        return 'Connecte-toi pour utiliser un code de parrainage.';
      case RedeemError.invalidCode:
        return 'Le code n\'est pas valide.';
      case RedeemError.codeNotFound:
        return 'Ce code n\'existe pas.';
      case RedeemError.selfReferral:
        return 'Tu ne peux pas utiliser ton propre code 😅';
      case RedeemError.alreadyReferred:
        return 'Tu as déjà utilisé un code de parrainage.';
      case RedeemError.unknown:
      default:
        return 'Une erreur est survenue. Réessaie.';
    }
  }

  void _snack(String msg) {
    final m = ScaffoldMessenger.maybeOf(context);
    if (m == null) return;
    m.hideCurrentSnackBar();
    m.showSnackBar(SnackBar(
      content: Text(msg),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return CasPratiqueScaffold(
      title: 'Parrainage',
      subtitle: 'Invite un ami, gagnez chacun +500 XP',
      body: SafeArea(
        top: false,
        child: _loading
            ? const _LoadingState()
            : _error != null
                ? _ErrorState(error: _error, onRetry: _refresh)
                : RefreshIndicator(
                    onRefresh: _refresh,
                    color: CpTokens.blueLight,
                    backgroundColor: Colors.white,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
                      children: [
                        _CodeCard(
                          status: _status,
                          onCopyCode: _copyCode,
                          onCopyLink: _copyLink,
                        ),
                        const SizedBox(height: 16),
                        _StatsRow(status: _status),
                        const SizedBox(height: 22),
                        const _SectionTitle(label: 'Comment ça marche'),
                        const SizedBox(height: 10),
                        const _StepTile(
                          step: 1,
                          title: 'Partage ton code ou ton lien',
                          message:
                              'Envoie ton code unique à un ami qui prépare le concours.',
                        ),
                        const _StepTile(
                          step: 2,
                          title: "Ton ami s'inscrit et utilise le code",
                          message:
                              'Il colle ton code en bas de cette page après son inscription.',
                        ),
                        const _StepTile(
                          step: 3,
                          title: 'Vous gagnez chacun +500 XP',
                          message:
                              'Les XP sont crédités instantanément des deux côtés.',
                        ),
                        const SizedBox(height: 22),
                        const _SectionTitle(label: 'Tu as reçu un code ?'),
                        const SizedBox(height: 10),
                        _RedeemCard(
                          controller: _redeemCtrl,
                          submitting: _redeeming,
                          onSubmit: _redeemSubmitted,
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  CODE CARD (le code en grand, copy + lien)
// ═══════════════════════════════════════════════════════════════════════════

class _CodeCard extends StatelessWidget {
  const _CodeCard({
    required this.status,
    required this.onCopyCode,
    required this.onCopyLink,
  });

  final ReferralCodeStatus status;
  final VoidCallback onCopyCode;
  final VoidCallback onCopyLink;

  @override
  Widget build(BuildContext context) {
    const accent = CpTokens.blueLight;

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [accent, Color.lerp(accent, Colors.black, 0.20) ?? accent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(CpTokens.r4),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.35),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.card_giftcard_rounded,
                  color: Colors.white, size: 18),
              const SizedBox(width: 6),
              Text(
                'TON CODE DE PARRAINAGE',
                style: GoogleFonts.montserrat(
                  color: Colors.white.withValues(alpha: 0.92),
                  fontWeight: FontWeight.w900,
                  fontSize: 10.5,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Center(
            child: SelectableText(
              status.isValid ? status.code : '— — — — — —',
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 42,
                letterSpacing: 8,
                height: 1.0,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _CodeAction(
                  icon: Icons.content_copy_rounded,
                  label: 'Copier le code',
                  onTap: onCopyCode,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _CodeAction(
                  icon: Icons.link_rounded,
                  label: 'Copier le lien',
                  onTap: onCopyLink,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CodeAction extends StatelessWidget {
  const _CodeAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(CpTokens.rPill),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(CpTokens.rPill),
          border: Border.all(color: Colors.white.withValues(alpha: 0.32)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 12.5,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  STATS
// ═══════════════════════════════════════════════════════════════════════════

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.status});
  final ReferralCodeStatus status;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Filleuls',
            value: '${status.referralsCount}',
            icon: Icons.group_rounded,
            accent: const Color(0xFF22C55E),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            label: 'XP gagnés',
            value: '${status.xpEarnedFromReferrals}',
            icon: Icons.bolt_rounded,
            accent: const Color(0xFFF59E0B),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            label: 'Par parrainage',
            value: '+${status.xpPerReferral}',
            icon: Icons.add_circle_rounded,
            accent: CpTokens.blueLight,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.accent,
  });
  final String label;
  final String value;
  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: CpTokens.surface(isDark),
        borderRadius: BorderRadius.circular(CpTokens.r3),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        children: [
          Icon(icon, color: accent, size: 18),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.montserrat(
              color: CpTokens.onSurface(isDark),
              fontWeight: FontWeight.w900,
              fontSize: 17,
              letterSpacing: -0.4,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label.toUpperCase(),
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              color: CpTokens.onSurfaceMuted(isDark),
              fontWeight: FontWeight.w900,
              fontSize: 9.5,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  STEPS
// ═══════════════════════════════════════════════════════════════════════════

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: GoogleFonts.montserrat(
        color: Colors.white.withValues(alpha: 0.85),
        fontWeight: FontWeight.w900,
        fontSize: 11.5,
        letterSpacing: 1.2,
      ),
    );
  }
}

class _StepTile extends StatelessWidget {
  const _StepTile({
    required this.step,
    required this.title,
    required this.message,
  });
  final int step;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(CpTokens.s4),
      decoration: BoxDecoration(
        color: CpTokens.surface(isDark),
        borderRadius: BorderRadius.circular(CpTokens.r3),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30, height: 30,
            decoration: BoxDecoration(
              color: CpTokens.blueLight,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: CpTokens.blueLight.withValues(alpha: 0.30),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              '$step',
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: CpTokens.s3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                    color: CpTokens.onSurface(isDark),
                    fontWeight: FontWeight.w900,
                    fontSize: 13.5,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  message,
                  style: GoogleFonts.montserrat(
                    color: CpTokens.onSurfaceMuted(isDark),
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
}

// ═══════════════════════════════════════════════════════════════════════════
//  REDEEM (l'user colle un code reçu)
// ═══════════════════════════════════════════════════════════════════════════

class _RedeemCard extends StatelessWidget {
  const _RedeemCard({
    required this.controller,
    required this.submitting,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final bool submitting;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;
    final onSurface = CpTokens.onSurface(isDark);
    final onSurfaceMuted = CpTokens.onSurfaceMuted(isDark);

    return Container(
      padding: const EdgeInsets.all(CpTokens.s4),
      decoration: BoxDecoration(
        color: CpTokens.surface(isDark),
        borderRadius: BorderRadius.circular(CpTokens.r3),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Entre le code de ton parrain',
            style: GoogleFonts.montserrat(
              color: onSurface,
              fontWeight: FontWeight.w900,
              fontSize: 13.5,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: controller,
            enabled: !submitting,
            textCapitalization: TextCapitalization.characters,
            autocorrect: false,
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                  RegExp(r'[A-Za-z0-9]')),
              LengthLimitingTextInputFormatter(8),
            ],
            style: GoogleFonts.montserrat(
              color: onSurface,
              fontWeight: FontWeight.w900,
              fontSize: 18,
              letterSpacing: 4,
            ),
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: 'ABCDEF',
              hintStyle: GoogleFonts.montserrat(
                color: onSurfaceMuted.withValues(alpha: 0.45),
                fontWeight: FontWeight.w800,
                fontSize: 18,
                letterSpacing: 4,
              ),
              filled: true,
              fillColor: CpTokens.surfaceContainer(isDark),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(CpTokens.r2),
                borderSide: BorderSide(color: cs.outlineVariant),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(CpTokens.r2),
                borderSide: BorderSide(color: cs.outlineVariant),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(CpTokens.r2),
                borderSide: const BorderSide(color: CpTokens.blueLight, width: 1.5),
              ),
            ),
            onSubmitted: (_) => submitting ? null : onSubmit(),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: submitting ? null : onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: CpTokens.blueLight,
                foregroundColor: Colors.white,
                disabledBackgroundColor:
                    CpTokens.blueLight.withValues(alpha: 0.45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(CpTokens.r3),
                ),
              ),
              child: submitting
                  ? const SizedBox(
                      width: 22, height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                  : Text(
                      'Valider le code',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tu ne peux utiliser un code qu\'une seule fois.',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              color: onSurfaceMuted,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  STATES
// ═══════════════════════════════════════════════════════════════════════════

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        strokeWidth: 3.2,
        valueColor: AlwaysStoppedAnimation(Colors.white),
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
          const Center(
            child: Icon(Icons.cloud_off_rounded,
                color: Colors.white, size: 44),
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
          const SizedBox(height: 16),
          Center(
            child: SizedBox(
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
          ),
        ],
    
      ),
    );
  }
}
