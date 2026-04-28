import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:copiqpolice/core/widgets/app_notifier.dart';
import 'package:copiqpolice/features/home/annulation_conditions_page.dart';

class AbonnementPage extends StatefulWidget {
  const AbonnementPage({super.key});
  static const routeName = '/abonnement';

  @override
  State<AbonnementPage> createState() => _AbonnementPageState();
}

class _AbonnementPageState extends State<AbonnementPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  // ===================== NOTIFICATIONS =====================

  void _info(String message) {
    AppNotifier.info(context, title: "COP’IQ", message: message);
  }

  void _success(String title, String message) {
    AppNotifier.success(context, title: title, message: message);
  }

  // ===================== RÉSILIATION =====================

  void _openResiliationFlow() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const _ResiliationSheet(),
    );
  }

  // ===================== UI =====================

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final isDark = t.brightness == Brightness.dark;

    final stroke = isDark
        ? Colors.white.withOpacity(0.10)
        : Colors.black.withOpacity(0.08);

    final subtle = t.colorScheme.onSurface.withOpacity(isDark ? 0.72 : 0.66);

    return Scaffold(
      backgroundColor: t.scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Abonnement",
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.2,
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 32),
            children: [
              // ================= HERO =================
              Text(
                "Accès Premium",
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 10),

              // ================= FEATURES =================
              Text(
                "Ce que l’abonnement débloque",
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.25,
                  height: 1.1,
                  color: t.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),

              _FeatureCard(stroke: stroke),

              const SizedBox(height: 18),

              // ================= OFFRES =================
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Choisis ton accès",
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.25,
                        height: 1.1,
                        color: t.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      HapticFeedback.selectionClick();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AnnulationConditionsPage(),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: t.colorScheme.primary,
                      textStyle: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.1,
                      ),
                    ),
                    child: const Text("Gérer / annuler"),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // ================= PLAN SEMAINE =================
              _PlanCard(
                stroke: stroke,
                tone: const Color(0xFFB07A2A),
                title: "Semaine",
                price: "4,99 € / semaine",
                subtitle: "Renouvellement automatique • Accès intégral 7 jours",
                badge: "Découverte",
                highlighted: false,
                valueLine: "Idéal pour tester COP’IQ à fond",
                billingLine: "Facturé via App Store / Google Play / AppGallery",
                details: const [
                  "Accès complet concours + scolarité + quiz",
                  "Entraînements illimités (culture G + psycho + langues)",
                  "Annulable à tout moment (effet fin de période)",
                ],
                onTap: () {
                  HapticFeedback.lightImpact();
                  _success(
                    "Offre sélectionnée",
                    "Abonnement semaine sélectionné.",
                  );
                },
              ),

              const SizedBox(height: 12),

              // ================= PLAN MENSUEL =================
              _PlanCard(
                stroke: stroke,
                tone: t.colorScheme.primary,
                title: "Mensuel",
                price: "8,99 € / mois",
                subtitle: "Renouvellement automatique",
                badge: "Recommandé",
                highlighted: true,
                valueLine: "Le plus flexible • Résiliation en 30 secondes",
                billingLine: "Facturé via App Store / Google Play / AppGallery",
                details: const [
                  "Tout débloqué + entraînements illimités",
                  "Mises à jour incluses — chaque semaine",
                  "Annulable à tout moment (effet fin de période)",
                ],
                onTap: () {
                  HapticFeedback.lightImpact();
                  _success(
                    "Offre sélectionnée",
                    "Abonnement mensuel sélectionné.",
                  );
                },
              ),

              const SizedBox(height: 12),

              // ================= PLAN ANNUEL =================
              _PlanCard(
                stroke: stroke,
                tone: const Color(0xFF7B3FE4),
                title: "Annuel",
                price: "86,99 € / an",
                subtitle: "20 % d’économie • Renouvellement automatique",
                badge: "-20 %",
                highlighted: false,
                valueLine: "Meilleur prix sur l’année",
                billingLine: "Facturé via App Store / Google Play / AppGallery",
                details: const [
                  "Accès complet 12 mois + mises à jour incluses",
                  "Le meilleur rapport valeur / prix",
                  "Annulable à tout moment (effet fin de période)",
                ],
                onTap: () {
                  HapticFeedback.lightImpact();
                  _success(
                    "Offre sélectionnée",
                    "Abonnement annuel sélectionné.",
                  );
                },
              ),

              // ================= LÉGAL =================
              _LegalFooter(),

              const SizedBox(height: 22),

              // ================= RÉSILIER =================
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: t.colorScheme.error,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  textStyle: GoogleFonts.inter(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.1,
                  ),
                ),
                onPressed: _openResiliationFlow,
                child: const Text("Résilier mon abonnement"),
              ),

              const SizedBox(height: 22),

              // ================= GRATUIT =================
              _FreeVersionBlock(stroke: stroke),
            ],
          ),
        ),
      ),
    );
  }
}

/* ---------------- SUB WIDGETS ---------------- */

class _HeroCard extends StatelessWidget {
  final Color stroke;
  final Color subtle;
  const _HeroCard({required this.stroke, required this.subtle});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: t.colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: stroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Accès complet COP’IQ",
            style: t.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: -.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Tous les contenus, mises à jour incluses, "
            "pour préparer concours et scolarité dans les meilleures conditions.",
            style: t.textTheme.bodyMedium?.copyWith(
              height: 1.45,
              color: subtle,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _miniChip(
  BuildContext context, {
  required IconData icon,
  required String text,
}) {
  final t = Theme.of(context);
  final isDark = t.brightness == Brightness.dark;

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
    decoration: BoxDecoration(
      color: t.colorScheme.primary.withOpacity(isDark ? .14 : .10),
      borderRadius: BorderRadius.circular(999),
      border: Border.all(color: t.colorScheme.primary.withOpacity(.22)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: t.colorScheme.primary),
        const SizedBox(width: 6),
        Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 12.0,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.1,
            color: t.colorScheme.primary,
          ),
        ),
      ],
    ),
  );
}

class _FeatureCard extends StatelessWidget {
  final Color stroke;
  const _FeatureCard({required this.stroke});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);

    Widget row(IconData icon, String text) => Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: t.colorScheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: t.textTheme.bodyMedium?.copyWith(
                height: 1.4,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: t.colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: stroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Petit titre interne (premium)
          Text(
            "Inclus dans Premium",
            style: GoogleFonts.inter(
              fontSize: 13.5,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.15,
              color: t.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 10),

          row(
            Icons.school_rounded,
            "Préparation concours : PA, Réserviste, Gardien de la Paix (GPX)",
          ),
          row(Icons.menu_book_rounded, "Scolarité complète + quiz intégrés"),
          row(
            Icons.psychology_alt_rounded,
            "100 000+ tests psychotechniques variés",
          ),
          row(
            Icons.language_rounded,
            "Quiz & entraînements langues étrangères",
          ),
          row(
            Icons.update_rounded,
            "Mises à jour incluses chaque semaine (contenus + corrections)",
          ),

          const SizedBox(height: 8),
          Divider(color: stroke),
          const SizedBox(height: 10),

          // Badges rapides (lisibilité)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _miniChip(
                context,
                icon: Icons.all_inclusive_rounded,
                text: "Illimité",
              ),
              _miniChip(context, icon: Icons.update_rounded, text: "Hebdo"),
              _miniChip(context, icon: Icons.forum_rounded, text: "Communauté"),
            ],
          ),

          const SizedBox(height: 12),

          // Ligne de confiance (plus premium que du texte seul)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.timer_rounded, size: 16, color: t.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                "Annulation en 30 secondes — sans engagement",
                style: GoogleFonts.inter(
                  fontSize: 12.6,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.1,
                  color: t.colorScheme.onSurface.withOpacity(.85),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatefulWidget {
  final Color stroke;
  final Color tone;
  final String title;
  final String price;
  final String subtitle;
  final String? valueLine; // ex: "Le plus populaire"
  final String? billingLine; // ex: "Facturé via App Store/Google Play"
  final List<String> details; // bullets
  final String? badge; // ex: "Découverte" | "Recommandé" | "-20 %"
  final bool highlighted;
  final VoidCallback onTap;

  const _PlanCard({
    super.key,
    required this.stroke,
    required this.tone,
    required this.title,
    required this.price,
    required this.subtitle,
    required this.details,
    required this.onTap,
    this.valueLine,
    this.billingLine,
    this.badge,
    this.highlighted = false,
  });

  @override
  State<_PlanCard> createState() => _PlanCardState();
}

class _PlanCardState extends State<_PlanCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _badgeCtrl;
  late final Animation<double> _badgePulse;
  late final Animation<double> _badgeGlow;

  bool _pressed = false;

  bool get _isRecommended =>
      (widget.badge ?? '').trim().toLowerCase() == 'recommandé';

  void _setPressed(bool v) {
    if (_pressed == v) return;
    setState(() => _pressed = v);
  }

  @override
  void initState() {
    super.initState();

    // Animation uniquement utile pour "Recommandé" (mais controller safe partout)
    _badgeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    _badgePulse = Tween<double>(
      begin: 1.0,
      end: 1.06,
    ).animate(CurvedAnimation(parent: _badgeCtrl, curve: Curves.easeInOut));

    _badgeGlow = Tween<double>(
      begin: 0.10,
      end: 0.22,
    ).animate(CurvedAnimation(parent: _badgeCtrl, curve: Curves.easeInOut));

    if (_isRecommended) {
      _badgeCtrl.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant _PlanCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    final wasRecommended =
        (oldWidget.badge ?? '').trim().toLowerCase() == 'recommandé';
    final nowRecommended = _isRecommended;

    if (wasRecommended != nowRecommended) {
      if (nowRecommended) {
        _badgeCtrl.repeat(reverse: true);
      } else {
        _badgeCtrl.stop();
        _badgeCtrl.value = 0; // reset propre
      }
    }
  }

  @override
  void dispose() {
    _badgeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final isDark = t.brightness == Brightness.dark;

    final borderColor = widget.highlighted
        ? widget.tone.withOpacity(isDark ? .78 : .62)
        : widget.stroke;

    final surface = t.colorScheme.surface;

    final shadow = widget.highlighted
        ? [
            BoxShadow(
              blurRadius: 28,
              offset: const Offset(0, 14),
              color: Colors.black.withOpacity(isDark ? .42 : .10),
            ),
          ]
        : [
            BoxShadow(
              blurRadius: 18,
              offset: const Offset(0, 10),
              color: Colors.black.withOpacity(isDark ? .22 : .06),
            ),
          ];

    final titleStyle = GoogleFonts.inter(
      fontSize: 15.6,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.25,
      height: 1.1,
      color: t.colorScheme.onSurface,
    );

    final priceStyle = GoogleFonts.inter(
      fontSize: 22.2,
      fontWeight: FontWeight.w900,
      letterSpacing: -0.6,
      height: 1.05,
      color: widget.tone,
    );

    final subtitleStyle = GoogleFonts.inter(
      fontSize: 13.2,
      fontWeight: FontWeight.w600,
      height: 1.25,
      letterSpacing: -0.1,
      color: t.colorScheme.onSurface.withOpacity(isDark ? .74 : .68),
    );

    final metaStyle = GoogleFonts.inter(
      fontSize: 12.2,
      fontWeight: FontWeight.w600,
      height: 1.2,
      letterSpacing: -0.1,
      color: t.colorScheme.onSurface.withOpacity(isDark ? .66 : .60),
    );

    final bulletStyle = GoogleFonts.inter(
      fontSize: 13.0,
      fontWeight: FontWeight.w600,
      height: 1.28,
      letterSpacing: -0.05,
      color: t.colorScheme.onSurface.withOpacity(isDark ? .92 : .88),
    );

    Widget bullet(String text) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(
                Icons.check_circle_rounded,
                size: 18,
                color: widget.tone.withOpacity(isDark ? .95 : .90),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(text, style: bulletStyle)),
          ],
        ),
      );
    }

    final chipBg = widget.tone.withOpacity(isDark ? .18 : .12);
    final chipBorder = widget.tone.withOpacity(isDark ? .34 : .28);

    Widget baseChip(String text, {IconData? icon, bool emphasized = false}) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: emphasized
              ? widget.tone.withOpacity(isDark ? .22 : .16)
              : chipBg,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: chipBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: widget.tone),
              const SizedBox(width: 6),
            ],
            Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.1,
                color: widget.tone,
              ),
            ),
          ],
        ),
      );
    }

    Widget recommendedChip(String text) {
      // Pulse + glow discret style “premium”
      return AnimatedBuilder(
        animation: _badgeCtrl,
        builder: (_, __) {
          final scale = _badgePulse.value;
          final glow = _badgeGlow.value;

          return Transform.scale(
            scale: scale,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 18,
                    spreadRadius: 1,
                    color: widget.tone.withOpacity(glow),
                  ),
                ],
              ),
              child: baseChip(text, icon: Icons.star_rounded, emphasized: true),
            ),
          );
        },
      );
    }

    // CTA color = tone (pour TOUS les plans, comme tu veux)
    final ctaBg = _pressed ? widget.tone.withOpacity(.92) : widget.tone;

    return AnimatedScale(
      scale: _pressed ? 0.986 : 1,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: borderColor,
            width: widget.highlighted ? 1.45 : 1.05,
          ),
          boxShadow: shadow,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: widget.onTap,
            onHighlightChanged: _setPressed,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Expanded(child: Text(widget.title, style: titleStyle)),
                      if (widget.badge != null)
                        _isRecommended
                            ? recommendedChip(widget.badge!)
                            : baseChip(widget.badge!),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Price
                  Text(widget.price, style: priceStyle),

                  const SizedBox(height: 6),

                  // Subtitle
                  Text(widget.subtitle, style: subtitleStyle),

                  // Value line
                  if ((widget.valueLine ?? "").trim().isNotEmpty) ...[
                    const SizedBox(height: 8),
                    baseChip(
                      widget.valueLine!,
                      icon: Icons.verified_rounded,
                      emphasized: true,
                    ),
                  ],

                  // Billing line
                  if ((widget.billingLine ?? "").trim().isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.receipt_long_rounded,
                          size: 16,
                          color: t.colorScheme.onSurface.withOpacity(
                            isDark ? .60 : .55,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(widget.billingLine!, style: metaStyle),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 12),
                  Divider(color: widget.stroke),
                  const SizedBox(height: 12),

                  // Bullets
                  for (final d in widget.details) bullet(d),

                  const SizedBox(height: 10),

                  // CTA
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      onPressed: widget.onTap,
                      style: FilledButton.styleFrom(
                        backgroundColor: ctaBg,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        textStyle: GoogleFonts.inter(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.1,
                        ),
                      ),
                      child: const Text("Choisir"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LegalFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Column(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Text(
            "Les abonnements se renouvellent automatiquement sauf annulation au moins 24 h avant la fin de la période en cours. "
            "Le paiement est prélevé sur votre compte App Store/Google Play/AppGallery. "
            "Vous pouvez gérer ou annuler votre abonnement à tout moment dans les réglages de votre compte. "
            "L’annulation prend effet à la fin de la période en cours.",
            textAlign: TextAlign.center,
            style: t.textTheme.bodySmall?.copyWith(
              height: 1.45,
              fontWeight: FontWeight.w500,
              color: t.colorScheme.onSurface.withOpacity(.65),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Annulation en 30 secondes — sans engagement.",
          style: t.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _FreeVersionBlock extends StatelessWidget {
  final Color stroke;
  const _FreeVersionBlock({required this.stroke});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Column(
      children: [
        Divider(color: stroke),
        const SizedBox(height: 12),
        Text(
          "Version gratuite",
          style: t.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Text(
          "Accès limité au mode « Je prépare le concours ».\n"
          "Un nombre d’exercices gratuits est disponible chaque semaine.",
          textAlign: TextAlign.center,
          style: t.textTheme.bodyMedium?.copyWith(
            height: 1.4,
            fontWeight: FontWeight.w600,
            color: t.hintColor,
          ),
        ),
      ],
    );
  }
}

class _ResiliationSheet extends StatefulWidget {
  const _ResiliationSheet();

  @override
  State<_ResiliationSheet> createState() => _ResiliationSheetState();
}

class _ResiliationSheetState extends State<_ResiliationSheet> {
  bool confirmed = false;

  void _confirmResiliation() {
    Navigator.pop(context);

    AppNotifier.success(
      context,
      title: "Résiliation enregistrée",
      message:
          "Votre accès restera actif jusqu’à la fin de la période d’abonnement en cours.",
    );
  }

  void _openStoreManagement() {
    Navigator.pop(context);

    AppNotifier.info(
      context,
      title: "Gestion de l’abonnement",
      message:
          "Vous allez être redirigé vers la gestion de votre abonnement via le store.",
    );

    // 👉 Plus tard : redirection StoreKit / Play Billing
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "Confirmer la résiliation",
              style: GoogleFonts.inter(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.2,
              ),
            ),
          ),

          const SizedBox(height: 14),

          Text(
            "La résiliation prend effet à la fin de la période d’abonnement en cours.\n\n"
            "Exemple : si vous résiliez au 2ᵉ jour, l’accès reste actif jusqu’à la fin de la période en cours, puis ne sera pas renouvelé.",
            style: GoogleFonts.inter(
              fontSize: 14,
              height: 1.5,
              fontWeight: FontWeight.w600,
              color: t.colorScheme.onSurface.withOpacity(.85),
            ),
          ),

          const SizedBox(height: 18),

          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: confirmed,
            onChanged: (v) => setState(() => confirmed = v ?? false),
            title: Text(
              "J’ai compris que l’accès reste actif jusqu’à la fin de la période en cours.",
              style: GoogleFonts.inter(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 16),

          FilledButton(
            onPressed: confirmed ? _confirmResiliation : null,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              textStyle: GoogleFonts.inter(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.1,
              ),
            ),
            child: const Text("Confirmer la résiliation"),
          ),

          const SizedBox(height: 6),

          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Annuler",
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
          ),

          const SizedBox(height: 4),

          TextButton(
            onPressed: _openStoreManagement,
            child: Text(
              "Gérer mon abonnement",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
