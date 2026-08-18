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
      'Policier en intervention — Socle initial',
    GpxSchoolProgram.policierEnInterventionsa =>
      'Policier en intervention — Socle avancé',
    GpxSchoolProgram.recueilPvApj20 => 'Recueil de procès-verbaux (APJ 20)',
    GpxSchoolProgram.dimensionHumaine => 'Dimension humaine',
  };

  String get compactTitle => switch (this) {
    GpxSchoolProgram.mememtoCirculationRoutiere => 'Circulation routière',
    GpxSchoolProgram.policierEnIntervention => 'Intervention — Socle initial',
    GpxSchoolProgram.policierEnInterventionsa => 'Intervention — Socle avancé',
    GpxSchoolProgram.recueilPvApj20 => 'Procès-verbaux (APJ 20)',
    _ => title,
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
    final recommended = lock
        ? GpxSchoolProgram.recueilPvApj20
        : GpxSchoolProgram.institutionValeurs;
    final otherPrograms = GpxSchoolProgram.values
        .where((program) => program != recommended)
        .toList(growable: false);

    Widget cardFor(GpxSchoolProgram program) {
      final card = _ProgramCompactCard(
        program: program,
        selected: _selected == program,
        disabled: _loading || lock,
        onTap: () => _pick(program),
      );
      return program == GpxSchoolProgram.recueilPvApj20
          ? KeyedSubtree(key: widget.apj20CardKey, child: card)
          : card;
    }

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
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: .07),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 18,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      'Tu pourras changer de programme à chaque démarrage.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: _muted(context, .76),
                        height: 1.3,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            _SectionLabel(
              title: lock ? 'Programme du tutoriel' : 'Recommandé aujourd’hui',
              icon: Icons.auto_awesome_rounded,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 10),
            KeyedSubtree(
              key: recommended == GpxSchoolProgram.recueilPvApj20
                  ? widget.apj20CardKey
                  : null,
              child: _ProgramHeroCard(
                program: recommended,
                selected: _selected == recommended || lock,
                disabled: _loading,
                onTap: () async {
                  if (lock) {
                    widget.onApj20TapOverride?.call();
                    return;
                  }
                  await _pick(recommended);
                },
              ),
            ),
            const SizedBox(height: 24),
            _SectionLabel(
              title: 'Tous les programmes',
              trailing: '${otherPrograms.length} disponibles',
              icon: Icons.grid_view_rounded,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 10),
            for (var index = 0; index < otherPrograms.length; index++) ...[
              cardFor(otherPrograms[index]),
              if (index != otherPrograms.length - 1) const SizedBox(height: 10),
            ],

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

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({
    required this.title,
    required this.icon,
    required this.color,
    this.trailing,
  });

  final String title;
  final String? trailing;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 19, color: color),
      const SizedBox(width: 8),
      Expanded(
        child: Text(
          title,
          style: GoogleFonts.instrumentSans(
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      if (trailing != null)
        Text(
          trailing!,
          style: GoogleFonts.instrumentSans(
            fontSize: 12,
            color: _muted(context, .62),
            fontWeight: FontWeight.w700,
          ),
        ),
    ],
  );
}

class _ProgramCompactCard extends StatelessWidget {
  const _ProgramCompactCard({
    required this.program,
    required this.selected,
    required this.disabled,
    required this.onTap,
  });

  final GpxSchoolProgram program;
  final bool selected;
  final bool disabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    return Semantics(
      button: true,
      selected: selected,
      label: 'Choisir ${program.title}',
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 180),
        opacity: disabled && !selected ? .55 : 1,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: disabled ? null : onTap,
            borderRadius: BorderRadius.circular(20),
            child: Ink(
              height: 104,
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: selected
                      ? primary.withValues(alpha: .55)
                      : theme.dividerColor.withValues(alpha: .20),
                  width: selected ? 1.5 : 1,
                ),
                boxShadow: [_T.softShadow],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(19),
                    ),
                    child: SizedBox(
                      width: 96,
                      height: double.infinity,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            program.heroImage,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: primary.withValues(alpha: .10),
                            ),
                          ),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: .34),
                                ],
                              ),
                            ),
                          ),
                          Center(
                            child: Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: .38),
                                borderRadius: BorderRadius.circular(13),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: .22),
                                ),
                              ),
                              child: Icon(
                                program.icon,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          program.compactTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.instrumentSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          program.subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.instrumentSans(
                            fontSize: 12,
                            height: 1.25,
                            color: _muted(context, .67),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: selected
                          ? primary
                          : primary.withValues(alpha: .08),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: selected
                        ? const Padding(
                            padding: EdgeInsets.all(10),
                            child: CircularProgressIndicator(
                              strokeWidth: 2.2,
                              color: Colors.white,
                            ),
                          )
                        : Icon(
                            Icons.arrow_forward_rounded,
                            color: primary,
                            size: 19,
                          ),
                  ),
                  const SizedBox(width: 12),
                ],
              ),
            ),
          ),
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
                    label: selected ? 'Ouverture…' : 'Commencer',
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
