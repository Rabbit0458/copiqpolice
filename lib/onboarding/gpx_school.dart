// lib/home/gpx_school.dart
// Espace GPX — Choix du programme du jour (NON sauvegardé)
// - 6 cartes héro ultra premium (blur + spotlight + badge glass)
// - DPS/DPG -> redirection directe vers /home-gpx-school
// - Les autres -> Navigator.pop(GpxSchoolProgram)

import 'dart:ui'; // ImageFilter.blur

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class _T {
  static const Color ink = Color(0xFF212529);

  static BoxShadow get shadow => BoxShadow(
    color: Colors.black.withValues(alpha: .12),
    blurRadius: 28,
    offset: const Offset(0, 16),
  );

  static BoxShadow get softShadow => BoxShadow(
    color: Colors.black.withValues(alpha: .08),
    blurRadius: 18,
    offset: const Offset(0, 10),
  );
}

Color _muted(BuildContext context, [double a = .72]) {
  final base =
      Theme.of(context).textTheme.bodySmall?.color ??
      (Theme.of(context).brightness == Brightness.dark ? Colors.white : _T.ink);
  return base.withValues(alpha: a);
}

/// ✅ UNIQUE SOURCE de vérité (à importer partout si besoin)
enum GpxSchoolProgram {
  institutionValeurs,
  dpsDpg,
  mememtoCirculationRoutiere,
  policierEnIntervention,
  policierEnInterventionsa,
  recueilPvApj20,
  dimensionHumaine,
}

extension GpxSchoolProgramX on GpxSchoolProgram {
  String get key => switch (this) {
    GpxSchoolProgram.institutionValeurs => 'institution_valeurs',
    GpxSchoolProgram.dpsDpg => 'dps_dpg',
    GpxSchoolProgram.mememtoCirculationRoutiere =>
      'memento_circulation_routiere',
    GpxSchoolProgram.policierEnIntervention => 'policier_en_intervention',
    GpxSchoolProgram.policierEnInterventionsa =>
      'policier_en_intervention_avance',
    GpxSchoolProgram.recueilPvApj20 => 'recueil_pv_apj20',
    GpxSchoolProgram.dimensionHumaine => 'dimension_humaine',
  };

  String get title => switch (this) {
    GpxSchoolProgram.institutionValeurs => 'Institution & Valeurs',
    GpxSchoolProgram.dpsDpg => 'DPS / DPG',
    GpxSchoolProgram.mememtoCirculationRoutiere =>
      'Mémento • Circulation routière',
    GpxSchoolProgram.policierEnIntervention =>
      'Policier en intervention               (Socle initial)',
    GpxSchoolProgram.policierEnInterventionsa =>
      'Policier en intervention               (Socle Avancé)',
    GpxSchoolProgram.recueilPvApj20 => 'Recueil de procès-verbaux (APJ 20)',
    GpxSchoolProgram.dimensionHumaine => 'Dimension humaine',
  };

  String get subtitle => switch (this) {
    GpxSchoolProgram.institutionValeurs =>
      'Déontologie, hiérarchie, institutions : les repères essentiels.',
    GpxSchoolProgram.dpsDpg =>
      'Droit pénal spécial + droit pénal général : le cœur des infractions.',
    GpxSchoolProgram.mememtoCirculationRoutiere =>
      'Contraventions, contrôles, documents, procédures : l’essentiel terrain.',
    GpxSchoolProgram.policierEnInterventionsa =>
      'Posture, sécurité, coordination : réflexes d’action et tactiques simples.',
    GpxSchoolProgram.policierEnIntervention =>
      'Posture, sécurité, coordination : réflexes d’action et tactiques simples.',
    GpxSchoolProgram.recueilPvApj20 =>
      'PV, auditions, actes de procédure : méthode claire et rigoureuse.',
    GpxSchoolProgram.dimensionHumaine =>
      'Dignité, discriminations, relation : l’humain au centre du service.',
  };

  String get heroImage => switch (this) {
    // ✅ identiques à PA (comme tu veux)
    GpxSchoolProgram.institutionValeurs => 'assets/images/school.jpeg',
    GpxSchoolProgram.dpsDpg => 'assets/images/exam.jpeg',
    GpxSchoolProgram.mememtoCirculationRoutiere =>
      'assets/images/contravention.jpeg',

    // ✅ images que tu as données
    GpxSchoolProgram.policierEnIntervention =>
      'assets/images/cat_hierarchie.jpg',
    GpxSchoolProgram.policierEnInterventionsa =>
      'assets/images/cat_hierarchie.jpg',
    GpxSchoolProgram.recueilPvApj20 =>
      'assets/images/pp_instruction_mandats_detention.jpeg',
    GpxSchoolProgram.dimensionHumaine =>
      'assets/images/dignite_discriminations.jpeg',
  };

  String get badge => switch (this) {
    GpxSchoolProgram.institutionValeurs => 'Aujourd’hui • Valeurs',
    GpxSchoolProgram.dpsDpg => 'Aujourd’hui • Pénal',
    GpxSchoolProgram.mememtoCirculationRoutiere => 'Aujourd’hui • Route',
    GpxSchoolProgram.policierEnIntervention => 'Aujourd’hui • Terrain',
    GpxSchoolProgram.policierEnInterventionsa => 'Aujourd’hui • Terrain',
    GpxSchoolProgram.recueilPvApj20 => 'Aujourd’hui • Procédure',
    GpxSchoolProgram.dimensionHumaine => 'Aujourd’hui • Humain',
  };

  IconData get icon => switch (this) {
    GpxSchoolProgram.institutionValeurs => Icons.account_balance_rounded,
    GpxSchoolProgram.dpsDpg => Icons.gavel_rounded,
    GpxSchoolProgram.mememtoCirculationRoutiere => Icons.directions_car_rounded,
    GpxSchoolProgram.policierEnIntervention => Icons.local_police_rounded,
    GpxSchoolProgram.policierEnInterventionsa => Icons.local_police_rounded,
    GpxSchoolProgram.recueilPvApj20 => Icons.description_rounded,
    GpxSchoolProgram.dimensionHumaine => Icons.volunteer_activism_rounded,
  };
}

class GpxSchoolArt extends StatefulWidget {
  const GpxSchoolArt({
    super.key,
    this.lockToApj20Only = false,
    this.apj20CardKey,
    this.onApj20TapOverride,
    this.onProgramSelectedOverride,
  });

  static const String routeName = 'espace-gpx';
  final bool lockToApj20Only;

  /// Permet au tuto de mesurer précisément la carte APJ20
  final GlobalKey? apj20CardKey;

  /// Mode tuto: quand on tape APJ20, on ne navigue pas, on appelle l’override
  final VoidCallback? onApj20TapOverride;

  /// Mode tuto: intercepte la sélection d’un programme (au lieu de Navigator.pop)
  final Future<void> Function(GpxSchoolProgram program)?
  onProgramSelectedOverride;

  @override
  State<GpxSchoolArt> createState() => _GpxSchoolArtState();
}

class _GpxSchoolArtState extends State<GpxSchoolArt> {
  bool _loading = false;
  GpxSchoolProgram? _selected;

  Future<void> _pick(GpxSchoolProgram program) async {
    if (_loading) return;

    setState(() {
      _loading = true;
      _selected = program;
    });

    await Future.delayed(const Duration(milliseconds: 140));
    if (!mounted) return;

    // ✅ si le tuto veut intercepter
    final override = widget.onProgramSelectedOverride;
    if (override != null) {
      await override(program);
      if (mounted) setState(() => _loading = false);
      return;
    }

    // ✅ comportement normal
    Navigator.of(context).pop(program);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final lock = widget.lockToApj20Only;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Espace GPX',
                        style: GoogleFonts.instrumentSans(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: isDark ? Colors.white : _T.ink,
                          letterSpacing: .2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Qu’est-ce que tu révises aujourd’hui ?',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: _muted(context, .86),
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  height: 46,
                  width: 46,
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [_T.softShadow],
                    border: Border.all(
                      color: theme.dividerColor.withValues(alpha: .22),
                    ),
                  ),
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              '💡 Ce choix n’est pas mémorisé : tu le sélectionnes à chaque démarrage.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: _muted(context, .72),
                height: 1.35,
              ),
            ),
            const SizedBox(height: 18),

            _ProgramHeroCard(
              program: GpxSchoolProgram.institutionValeurs,
              selected: _selected == GpxSchoolProgram.institutionValeurs,
              disabled: _loading || lock,
              onTap: lock
                  ? null
                  : () => _pick(GpxSchoolProgram.institutionValeurs),
            ),
            const SizedBox(height: 16),

            _ProgramHeroCard(
              program: GpxSchoolProgram.dpsDpg,
              selected: _selected == GpxSchoolProgram.dpsDpg,
              disabled: _loading || lock,
              onTap: lock ? null : () => _pick(GpxSchoolProgram.dpsDpg),
            ),
            const SizedBox(height: 16),

            _ProgramHeroCard(
              program: GpxSchoolProgram.mememtoCirculationRoutiere,
              selected:
                  _selected == GpxSchoolProgram.mememtoCirculationRoutiere,
              disabled: _loading || lock,
              onTap: lock
                  ? null
                  : () => _pick(GpxSchoolProgram.mememtoCirculationRoutiere),
            ),
            const SizedBox(height: 16),

            _ProgramHeroCard(
              program: GpxSchoolProgram.policierEnIntervention,
              selected: _selected == GpxSchoolProgram.policierEnIntervention,
              disabled: _loading || lock,
              onTap: lock
                  ? null
                  : () => _pick(GpxSchoolProgram.policierEnIntervention),
            ),
            const SizedBox(height: 16),

            _ProgramHeroCard(
              program: GpxSchoolProgram.policierEnInterventionsa,
              selected: _selected == GpxSchoolProgram.policierEnInterventionsa,
              disabled: _loading || lock,
              onTap: lock
                  ? null
                  : () => _pick(GpxSchoolProgram.policierEnInterventionsa),
            ),
            const SizedBox(height: 16),

            // ✅ APJ20 : focusable + seul autorisé en lock
            KeyedSubtree(
              key: widget.apj20CardKey,
              child: _ProgramHeroCard(
                program: GpxSchoolProgram.recueilPvApj20,
                selected: _selected == GpxSchoolProgram.recueilPvApj20 || lock,
                disabled: _loading,
                onTap: () async {
                  if (lock) {
                    widget.onApj20TapOverride?.call();
                    return;
                  }
                  await _pick(GpxSchoolProgram.recueilPvApj20);
                },
              ),
            ),
            const SizedBox(height: 16),

            _ProgramHeroCard(
              program: GpxSchoolProgram.dimensionHumaine,
              selected: _selected == GpxSchoolProgram.dimensionHumaine,
              disabled: _loading || lock,
              onTap: lock
                  ? null
                  : () => _pick(GpxSchoolProgram.dimensionHumaine),
            ),

            if (_loading) ...[
              const SizedBox(height: 18),
              Center(
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    valueColor: AlwaysStoppedAnimation(
                      theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 16),
            Center(
              child: Text(
                'Tu pourras revenir ici quand tu veux pour changer de focus.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: _muted(context, .70),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgramHeroCard extends StatelessWidget {
  final GpxSchoolProgram program;
  final bool selected;
  final bool disabled;
  final VoidCallback? onTap;

  const _ProgramHeroCard({
    super.key,
    required this.program,
    required this.selected,
    required this.disabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // ✅ Blur vraiment visible (sans être “illisible”)
    final double imgPreBlur = isDark
        ? 6.0
        : 4.5; // flou appliqué DIRECTEMENT à l’image
    final double glassBlur = isDark
        ? 26.0
        : 22.0; // flou “glass” (BackdropFilter)

    // ✅ Le voile sombre : trop fort => on ne voit plus le blur
    // (sur ta capture, c’est ça qui tue tout)
    final double topShade = isDark ? 0.26 : 0.22;
    final double midShade = isDark ? 0.10 : 0.08;
    final double botShade = isDark ? 0.34 : 0.28;

    Widget img;
    try {
      img = Image.asset(program.heroImage, fit: BoxFit.cover);
    } catch (_) {
      img = Container(color: Colors.black.withValues(alpha: .06));
    }

    final borderColor = selected
        ? (isDark
              ? const Color(0xFF90CAF9)
              : const Color(0xFF1565C0).withValues(alpha: .92))
        : theme.dividerColor.withValues(alpha: .18);

    final canTap = !disabled && onTap != null;

    return AnimatedScale(
      scale: selected ? 1.0 : 0.975,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 180),
        opacity: disabled ? .75 : (selected ? 1 : 0.965),
        child: GestureDetector(
          onTap: canTap ? onTap : null,
          child: Container(
            height: 245,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              boxShadow: [_T.shadow],
              border: Border.all(color: borderColor, width: selected ? 2 : 1),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // ✅ 1) Blur DIRECT sur l’image (garanti visible)
                Positioned.fill(
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(
                      sigmaX: imgPreBlur,
                      sigmaY: imgPreBlur,
                    ),
                    child: img,
                  ),
                ),

                // ✅ 2) Blur “glass” + voile plus léger
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: glassBlur,
                      sigmaY: glassBlur,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: topShade),
                            Colors.black.withValues(alpha: midShade),
                            Colors.black.withValues(alpha: botShade),
                          ],
                          stops: const [0.0, 0.55, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),

                // ✅ Spotlight central (un poil réduit pour laisser voir l’image)
                Center(
                  child: Container(
                    width: 300,
                    height: 170,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.center,
                        radius: 0.78,
                        colors: [
                          Colors.white.withValues(alpha: isDark ? .22 : .18),
                          Colors.white.withValues(alpha: isDark ? .10 : .08),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.55, 1.0],
                      ),
                    ),
                  ),
                ),

                Positioned(
                  left: 14,
                  top: 14,
                  child: _GlassPill(
                    isDark: isDark,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(program.icon, size: 16, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          program.badge,
                          style: GoogleFonts.instrumentSans(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 12.5,
                            letterSpacing: .2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          program.title,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.instrumentSans(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 23,
                            letterSpacing: .3,
                            height: 1.05,
                            shadows: const [
                              Shadow(
                                offset: Offset(0, 2),
                                blurRadius: 10,
                                color: Colors.black87,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          program.subtitle,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.instrumentSans(
                            color: Colors.white.withValues(alpha: .92),
                            fontWeight: FontWeight.w600,
                            fontSize: 13.8,
                            height: 1.25,
                            shadows: const [
                              Shadow(
                                offset: Offset(0, 2),
                                blurRadius: 10,
                                color: Colors.black54,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Positioned(
                  left: 14,
                  right: 14,
                  bottom: 14,
                  child: _DiscoverButton(
                    label: selected ? 'Continuer' : 'Choisir',
                    onTap: canTap ? onTap : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassPill extends StatelessWidget {
  final Widget child;
  final bool isDark;

  const _GlassPill({required this.child, required this.isDark});

  @override
  Widget build(BuildContext context) {
    // ✅ Glass pill légèrement plus flou que avant, mais pas “gelée”
    final double pillBlur = isDark ? 18.0 : 16.0;

    // ✅ un peu moins opaque pour laisser “lire” l’arrière
    final glassFill = Colors.white.withValues(alpha: isDark ? .10 : .12);
    final glassStroke = Colors.white.withValues(alpha: isDark ? .22 : .24);

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: pillBlur, sigmaY: pillBlur),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: glassFill,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: glassStroke),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withValues(alpha: isDark ? .14 : .16),
                          Colors.transparent,
                          Colors.black.withValues(alpha: isDark ? .10 : .08),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _DiscoverButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String label;
  const _DiscoverButton({required this.onTap, required this.label});

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 160),
        opacity: disabled ? .55 : 1,
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: _T.ink.withValues(alpha: .92),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .18),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    label,
                    style: GoogleFonts.instrumentSans(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 14.5,
                      letterSpacing: .2,
                      shadows: const [
                        Shadow(
                          offset: Offset(0, 1),
                          blurRadius: 3,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const CircleAvatar(
                radius: 14,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.arrow_forward_rounded,
                  size: 18,
                  color: _T.ink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
