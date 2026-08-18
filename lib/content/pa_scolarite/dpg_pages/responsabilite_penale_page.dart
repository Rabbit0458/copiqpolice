import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

/// Droit pénal général — portail de la responsabilité pénale.
class PaResponsabilitePenalePage extends StatelessWidget {
  const PaResponsabilitePenalePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/droit_penal_general/responsabilite_penale';

  static const _navy = Color(0xFF102A43);
  static const _blue = Color(0xFF2563EB);
  static const _gold = Color(0xFFD99A2B);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final background = isDark
        ? const Color(0xFF0B1016)
        : const Color(0xFFF5F7FA);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          tooltip: ScolariteText.value(
            "lib/content/pa_scolarite/dpg_pages/responsabilite_penale_page.dart",
            "f00001",
            'Retour',
          ),
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/dpg_pages/responsabilite_penale_page.dart",
            "f00002",
            'Responsabilité pénale',
          ),
          style: GoogleFonts.fustat(fontSize: 18, fontWeight: FontWeight.w800),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 32),
        children: [
          _HeroCard(isDark: isDark),
          const SizedBox(height: 22),
          _SectionTitle(
            eyebrow: 'PARCOURS',
            title: ScolariteText.value(
              "lib/content/pa_scolarite/dpg_pages/responsabilite_penale_page.dart",
              "f00003",
              'Comprendre en 4 étapes',
            ),
            subtitle: ScolariteText.value(
              "lib/content/pa_scolarite/dpg_pages/responsabilite_penale_page.dart",
              "f00004",
              'Avance dans l’ordre ou ouvre directement une notion.',
            ),
          ),
          const SizedBox(height: 12),
          _CourseTile(
            index: '01',
            icon: Icons.gavel_rounded,
            title: ScolariteText.value(
              "lib/content/pa_scolarite/dpg_pages/responsabilite_penale_page.dart",
              "f00005",
              'Principes généraux',
            ),
            subtitle: ScolariteText.value(
              "lib/content/pa_scolarite/dpg_pages/responsabilite_penale_page.dart",
              "f00006",
              'Responsabilité personnelle, culpabilité et imputabilité',
            ),
            route:
                '/pa/dps_dpg/droit_penal_general/responsabilite_penale/principes_generaux',
          ),
          const SizedBox(height: 10),
          _CourseTile(
            index: '02',
            icon: Icons.group_outlined,
            title: ScolariteText.value(
              "lib/content/pa_scolarite/dpg_pages/responsabilite_penale_page.dart",
              "f00007",
              'Auteur, coauteur et complice',
            ),
            subtitle: ScolariteText.value(
              "lib/content/pa_scolarite/dpg_pages/responsabilite_penale_page.dart",
              "f00008",
              'Participation, aide, assistance et provocation',
            ),
            route:
                '/pa/dps_dpg/droit_penal_general/responsabilite_penale/complicite_coaction',
          ),
          const SizedBox(height: 10),
          _CourseTile(
            index: '03',
            icon: Icons.apartment_rounded,
            title: ScolariteText.value(
              "lib/content/pa_scolarite/dpg_pages/responsabilite_penale_page.dart",
              "f00009",
              'Personnes morales',
            ),
            subtitle: ScolariteText.value(
              "lib/content/pa_scolarite/dpg_pages/responsabilite_penale_page.dart",
              "f00010",
              'Conditions, cumul des responsabilités et sanctions',
            ),
            route:
                '/pa/dps_dpg/droit_penal_general/responsabilite_penale/personnes_morales',
          ),
          const SizedBox(height: 10),
          _CourseTile(
            index: '04',
            icon: Icons.shield_outlined,
            title: ScolariteText.value(
              "lib/content/pa_scolarite/dpg_pages/responsabilite_penale_page.dart",
              "f00011",
              'Causes d’irresponsabilité',
            ),
            subtitle: ScolariteText.value(
              "lib/content/pa_scolarite/dpg_pages/responsabilite_penale_page.dart",
              "f00012",
              'Trouble mental, contrainte, erreur et faits justificatifs',
            ),
            route:
                '/pa/dps_dpg/droit_penal_general/responsabilite_penale/causes_irresponsabilite',
          ),
          const SizedBox(height: 24),
          _SectionTitle(
            eyebrow: ScolariteText.value(
              "lib/content/pa_scolarite/dpg_pages/responsabilite_penale_page.dart",
              "f00013",
              'À RETENIR',
            ),
            title: ScolariteText.value(
              "lib/content/pa_scolarite/dpg_pages/responsabilite_penale_page.dart",
              "f00014",
              'Les trois conditions',
            ),
            subtitle: ScolariteText.value(
              "lib/content/pa_scolarite/dpg_pages/responsabilite_penale_page.dart",
              "f00015",
              'Le raisonnement essentiel à maîtriser.',
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _PrincipleCard(
                  number: '1',
                  title: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/responsabilite_penale_page.dart",
                    "f00016",
                    'Un texte',
                  ),
                  body: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/responsabilite_penale_page.dart",
                    "f00017",
                    'Un fait prévu et réprimé par la loi.',
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _PrincipleCard(
                  number: '2',
                  title: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/responsabilite_penale_page.dart",
                    "f00018",
                    'Un acte',
                  ),
                  body: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/responsabilite_penale_page.dart",
                    "f00019",
                    'Un comportement matériel caractérisé.',
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _PrincipleCard(
                  number: '3',
                  title: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/responsabilite_penale_page.dart",
                    "f00020",
                    'Une faute',
                  ),
                  body: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/responsabilite_penale_page.dart",
                    "f00021",
                    'Une intention ou une négligence.',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _SectionTitle(
            eyebrow: 'CONTINUER',
            title: ScolariteText.value(
              "lib/content/pa_scolarite/dpg_pages/responsabilite_penale_page.dart",
              "f00022",
              'Cours associés',
            ),
            subtitle: ScolariteText.value(
              "lib/content/pa_scolarite/dpg_pages/responsabilite_penale_page.dart",
              "f00023",
              'Replace cette notion dans le droit pénal général.',
            ),
          ),
          const SizedBox(height: 12),
          _RelatedTile(
            icon: Icons.menu_book_rounded,
            title: ScolariteText.value(
              "lib/content/pa_scolarite/dpg_pages/responsabilite_penale_page.dart",
              "f00024",
              'De la loi pénale',
            ),
            subtitle: ScolariteText.value(
              "lib/content/pa_scolarite/dpg_pages/responsabilite_penale_page.dart",
              "f00025",
              'Sources, application et interprétation',
            ),
            route: '/pa/dps_dpg/droit_penal_general/loi_penale',
          ),
          const SizedBox(height: 10),
          _RelatedTile(
            icon: Icons.balance_rounded,
            title: ScolariteText.value(
              "lib/content/pa_scolarite/dpg_pages/responsabilite_penale_page.dart",
              "f00026",
              'La sanction',
            ),
            subtitle: ScolariteText.value(
              "lib/content/pa_scolarite/dpg_pages/responsabilite_penale_page.dart",
              "f00027",
              'Classification des peines et aggravations',
            ),
            route: '/pa/dps_dpg/sanctions/classification_peines',
          ),
          const SizedBox(height: 10),
          _RelatedTile(
            icon: Icons.account_tree_outlined,
            title: ScolariteText.value(
              "lib/content/pa_scolarite/dpg_pages/responsabilite_penale_page.dart",
              "f00028",
              'Les généralités',
            ),
            subtitle: ScolariteText.value(
              "lib/content/pa_scolarite/dpg_pages/responsabilite_penale_page.dart",
              "f00029",
              'Infraction, tentative, complicité et légitime défense',
            ),
            route: '/pa/dps_dpg/socle_initial/generalites/infraction_intro',
          ),
        ],
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: ScolariteText.value(
        "lib/content/pa_scolarite/dpg_pages/responsabilite_penale_page.dart",
        "f00030",
        'Introduction au cours sur la responsabilité pénale',
      ),
      child: Container(
        height: 218,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? .24 : .12),
              blurRadius: 28,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/droit_penal_general.jpeg',
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) =>
                  const ColoredBox(color: PaResponsabilitePenalePage._navy),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x1A000000), Color(0xE6101B2B)],
                  stops: [0, .9],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _HeroBadge(),
                  const Spacer(),
                  Text(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/responsabilite_penale_page.dart",
                      "f00031",
                      'De la responsabilité\npénale',
                    ),
                    style: GoogleFonts.fustat(
                      color: Colors.white,
                      fontSize: 26,
                      height: 1.03,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/responsabilite_penale_page.dart",
                      "f00032",
                      'Identifier qui répond pénalement des faits, et pourquoi.',
                    ),
                    maxLines: 2,
                    style: GoogleFonts.fustat(
                      color: Colors.white.withValues(alpha: .82),
                      fontSize: 14,
                      height: 1.25,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 44,
                    child: FilledButton.icon(
                      onPressed: () => Navigator.of(context).pushNamed(
                        '/pa/dps_dpg/droit_penal_general/responsabilite_penale/principes_generaux',
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: PaResponsabilitePenalePage._navy,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.play_arrow_rounded, size: 20),
                      label: Text(
                        'Commencer',
                        style: GoogleFonts.fustat(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroBadge extends StatelessWidget {
  const _HeroBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .92),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        ScolariteText.value(
          "lib/content/pa_scolarite/dpg_pages/responsabilite_penale_page.dart",
          "f00033",
          'DROIT PÉNAL GÉNÉRAL',
        ),
        style: GoogleFonts.fustat(
          color: PaResponsabilitePenalePage._navy,
          fontSize: 10,
          letterSpacing: .55,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
  });

  final String eyebrow;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    return Semantics(
      header: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            eyebrow,
            style: GoogleFonts.fustat(
              color: PaResponsabilitePenalePage._blue,
              fontSize: 11,
              letterSpacing: .8,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            title,
            style: GoogleFonts.fustat(
              color: textColor,
              fontSize: 21,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            subtitle,
            style: GoogleFonts.fustat(
              color: textColor.withValues(alpha: .62),
              fontSize: 13.5,
              height: 1.35,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _CourseTile extends StatelessWidget {
  const _CourseTile({
    required this.index,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
  });

  final String index;
  final IconData icon;
  final String title;
  final String subtitle;
  final String route;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Semantics(
      button: true,
      label: '$index. $title. $subtitle',
      child: Material(
        color: isDark ? const Color(0xFF151C24) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () => Navigator.of(context).pushNamed(route),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            constraints: const BoxConstraints(minHeight: 82),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: theme.colorScheme.outlineVariant.withValues(alpha: .65),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: PaResponsabilitePenalePage._blue.withValues(
                      alpha: isDark ? .18 : .09,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    icon,
                    color: isDark
                        ? const Color(0xFF76A7FF)
                        : PaResponsabilitePenalePage._blue,
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$index  $title',
                        style: GoogleFonts.fustat(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.fustat(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: .60,
                          ),
                          height: 1.25,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_ios_rounded, size: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PrincipleCard extends StatelessWidget {
  const _PrincipleCard({
    required this.number,
    required this.title,
    required this.body,
  });

  final String number;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      constraints: const BoxConstraints(minHeight: 146),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF151C24) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: .65),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: PaResponsabilitePenalePage._gold.withValues(alpha: .15),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Text(
              number,
              style: GoogleFonts.fustat(
                color: isDark
                    ? const Color(0xFFF2BC5C)
                    : const Color(0xFF9A5D00),
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: GoogleFonts.fustat(
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            body,
            style: GoogleFonts.fustat(
              color: theme.colorScheme.onSurface.withValues(alpha: .62),
              height: 1.3,
              fontSize: 11.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _RelatedTile extends StatelessWidget {
  const _RelatedTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String route;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Material(
      color: isDark ? const Color(0xFF151C24) : Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed(route),
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          child: Row(
            children: [
              Icon(icon, color: PaResponsabilitePenalePage._blue, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.fustat(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.fustat(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: .58,
                        ),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_rounded, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
