import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// La sanction — portail de la classification des peines et mesures de sûreté.
class PaClassificationPeinesPage extends StatelessWidget {
  const PaClassificationPeinesPage({super.key});

  static const String routeName = '/pa/dps_dpg/sanctions/classification_peines';
  static const _navy = Color(0xFF102A43);
  static const _blue = Color(0xFF2563EB);
  static const _gold = Color(0xFFD99A2B);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
          tooltip: 'Retour',
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
        title: Text(
          'Classification des peines',
          style: GoogleFonts.fustat(fontSize: 18, fontWeight: FontWeight.w800),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 32),
        children: [
          _HeroCard(isDark: isDark),
          const SizedBox(height: 22),
          const _SectionTitle(
            eyebrow: 'PARCOURS',
            title: 'Deux notions à distinguer',
            subtitle:
                'Commence par les peines, puis étudie la prévention du risque.',
          ),
          const SizedBox(height: 12),
          const _CourseTile(
            index: '01',
            icon: Icons.gavel_rounded,
            title: 'Classification légale des peines',
            subtitle: 'Crimes, délits, contraventions et peines applicables',
            route:
                '/pa/dps_dpg/sanctions/classification_peines/classification_legale_peines',
          ),
          const SizedBox(height: 10),
          const _CourseTile(
            index: '02',
            icon: Icons.health_and_safety_outlined,
            title: 'Mesures de sûreté',
            subtitle: 'Prévenir la récidive, surveiller et accompagner',
            route:
                '/pa/dps_dpg/sanctions/classification_peines/classification_mesures_surete',
          ),
          const SizedBox(height: 24),
          const _SectionTitle(
            eyebrow: 'REPÈRES',
            title: 'Les trois natures de peines',
            subtitle:
                'La qualification de l’infraction détermine l’échelle applicable.',
          ),
          const SizedBox(height: 12),
          const _PenaltyCard(
            number: '01',
            title: 'Criminelles',
            body:
                'Réclusion ou détention criminelle. Compétence de la cour d’assises.',
            icon: Icons.account_balance_rounded,
          ),
          const SizedBox(height: 10),
          const _PenaltyCard(
            number: '02',
            title: 'Correctionnelles',
            body:
                'Emprisonnement, amende délictuelle, travail d’intérêt général.',
            icon: Icons.balance_rounded,
          ),
          const SizedBox(height: 10),
          const _PenaltyCard(
            number: '03',
            title: 'Contraventionnelles',
            body: 'Amendes de la 1re à la 5e classe et sanctions spécifiques.',
            icon: Icons.receipt_long_outlined,
          ),
          const SizedBox(height: 24),
          const _SectionTitle(
            eyebrow: 'À RETENIR',
            title: 'Articuler la réponse pénale',
            subtitle: 'Trois familles complémentaires à ne pas confondre.',
          ),
          const SizedBox(height: 12),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _PrincipleCard(
                  icon: Icons.looks_one_outlined,
                  title: 'Principale',
                  body: 'La sanction de référence.',
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _PrincipleCard(
                  icon: Icons.add_circle_outline_rounded,
                  title: 'Complémentaire',
                  body: 'S’ajoute si la loi le prévoit.',
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _PrincipleCard(
                  icon: Icons.alt_route_rounded,
                  title: 'Alternative',
                  body: 'Se substitue à une peine.',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const _SectionTitle(
            eyebrow: 'CONTINUER',
            title: 'Cours associés',
            subtitle: 'Replace la peine dans le raisonnement pénal complet.',
          ),
          const SizedBox(height: 12),
          const _RelatedTile(
            icon: Icons.trending_up_rounded,
            title: 'Causes d’aggravation',
            subtitle: 'Récidive et circonstances aggravantes',
            route: '/pa/dps_dpg/sanctions/causes_aggravation',
          ),
          const SizedBox(height: 10),
          const _RelatedTile(
            icon: Icons.account_tree_outlined,
            title: 'Pluralité d’infractions',
            subtitle: 'Concours, cumul et confusion des peines',
            route: '/pa/dps_dpg/sanctions/pluralite_infractions',
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
      label: 'Introduction à la classification des peines',
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
              'assets/images/sanction.jpeg',
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) =>
                  const ColoredBox(color: PaClassificationPeinesPage._navy),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x26000000), Color(0xEE101B2B)],
                  stops: [0, .92],
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
                    'Peines & mesures\nde sûreté',
                    style: GoogleFonts.fustat(
                      color: Colors.white,
                      fontSize: 27,
                      height: 1.02,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    'Qualifier la sanction, comprendre son rôle et son articulation.',
                    maxLines: 2,
                    style: GoogleFonts.fustat(
                      color: Colors.white.withValues(alpha: .82),
                      fontSize: 14,
                      height: 1.25,
                      fontWeight: FontWeight.w500,
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
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: .94),
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(
      'LA SANCTION',
      style: GoogleFonts.fustat(
        color: PaClassificationPeinesPage._navy,
        fontSize: 11,
        letterSpacing: .6,
        fontWeight: FontWeight.w900,
      ),
    ),
  );
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
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        eyebrow,
        style: GoogleFonts.fustat(
          color: PaClassificationPeinesPage._blue,
          fontSize: 11,
          letterSpacing: .8,
          fontWeight: FontWeight.w900,
        ),
      ),
      const SizedBox(height: 3),
      Text(
        title,
        style: GoogleFonts.fustat(fontSize: 21, fontWeight: FontWeight.w900),
      ),
      const SizedBox(height: 3),
      Text(
        subtitle,
        style: GoogleFonts.fustat(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: .62),
          fontSize: 13,
          height: 1.3,
        ),
      ),
    ],
  );
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
  Widget build(BuildContext context) => _TappableCard(
    onTap: () => Navigator.of(context).pushNamed(route),
    semanticLabel: '$index. $title',
    child: Row(
      children: [
        _IconBox(icon: icon),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$index  ·  $title',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: GoogleFonts.fustat(
                  fontSize: 12.5,
                  height: 1.25,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: .62),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        const Icon(Icons.arrow_forward_rounded, size: 20),
      ],
    ),
  );
}

class _PenaltyCard extends StatelessWidget {
  const _PenaltyCard({
    required this.number,
    required this.title,
    required this.body,
    required this.icon,
  });
  final String number;
  final String title;
  final String body;
  final IconData icon;

  @override
  Widget build(BuildContext context) => _SurfaceCard(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _IconBox(icon: icon, gold: true),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$number  ·  $title',
                style: GoogleFonts.fustat(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                body,
                style: GoogleFonts.fustat(
                  fontSize: 13,
                  height: 1.35,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: .68),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _PrincipleCard extends StatelessWidget {
  const _PrincipleCard({
    required this.icon,
    required this.title,
    required this.body,
  });
  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) => _SurfaceCard(
    padding: const EdgeInsets.all(12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: PaClassificationPeinesPage._blue, size: 22),
        const SizedBox(height: 12),
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.fustat(
            fontSize: 12.5,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          body,
          style: GoogleFonts.fustat(
            fontSize: 11.5,
            height: 1.25,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: .62),
          ),
        ),
      ],
    ),
  );
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
  Widget build(BuildContext context) => _TappableCard(
    onTap: () => Navigator.of(context).pushNamed(route),
    semanticLabel: title,
    child: Row(
      children: [
        _IconBox(icon: icon),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.fustat(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.fustat(
                  fontSize: 12.5,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: .6),
                ),
              ),
            ],
          ),
        ),
        const Icon(Icons.chevron_right_rounded),
      ],
    ),
  );
}

class _IconBox extends StatelessWidget {
  const _IconBox({required this.icon, this.gold = false});
  final IconData icon;
  final bool gold;

  @override
  Widget build(BuildContext context) => Container(
    width: 44,
    height: 44,
    decoration: BoxDecoration(
      color:
          (gold
                  ? PaClassificationPeinesPage._gold
                  : PaClassificationPeinesPage._blue)
              .withValues(alpha: .11),
      borderRadius: BorderRadius.circular(13),
    ),
    child: Icon(
      icon,
      color: gold
          ? PaClassificationPeinesPage._gold
          : PaClassificationPeinesPage._blue,
      size: 22,
    ),
  );
}

class _SurfaceCard extends StatelessWidget {
  const _SurfaceCard({
    required this.child,
    this.padding = const EdgeInsets.all(15),
  });
  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF151D27) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: .07)
              : const Color(0xFFE4E9F0),
        ),
      ),
      child: child,
    );
  }
}

class _TappableCard extends StatelessWidget {
  const _TappableCard({
    required this.onTap,
    required this.semanticLabel,
    required this.child,
  });
  final VoidCallback onTap;
  final String semanticLabel;
  final Widget child;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: semanticLabel,
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(child: _SurfaceCard(child: child)),
      ),
    ),
  );
}
