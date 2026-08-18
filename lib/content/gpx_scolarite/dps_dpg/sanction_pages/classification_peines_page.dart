// lib/gpx_scolarite_pages/sanction_pages/classification_peines_page.dart

import 'package:flutter/material.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

/// Page : La sanction — Classification des peines et mesures de sûreté
/// Route alignée avec la config : /gpx/sanction/classification_peines
class ClassificationPeinesPage extends StatelessWidget {
  static const String routeName = '/gpx/sanction/classification_peines';
  const ClassificationPeinesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _HeroHeader(
            badge: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/sanction_pages/classification_peines_page.dart",
              "f00001",
              'La sanction',
            ),
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/sanction_pages/classification_peines_page.dart",
              "f00002",
              'Classification des peines & mesures de sûreté',
            ),
            subtitle: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/sanction_pages/classification_peines_page.dart",
              "f00003",
              'Natures · Régimes · Peines complémentaires',
            ),
            image: 'assets/images/sanction.jpeg',
            onPrimaryTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/sanction_pages/classification_peines_page.dart",
                      "f00004",
                      'Classification — Récap 👌',
                    ),
                  ),
                ),
              );
            },
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            sliver: SliverList.list(
              children: [
                _SectionCard(
                  title: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/sanction_pages/classification_peines_page.dart",
                    "f00005",
                    'Finalité',
                  ),
                  child: Text(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/classification_peines_page.dart",
                          "f00006",
                          'Qualifier la nature de la peine (criminelle, correctionnelle, contraventionnelle), ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/classification_peines_page.dart",
                          "f00007",
                          'distinguer peines principales, complémentaires et alternatives, et situer les mesures de sûreté.',
                        ),
                  ),
                ),

                const SizedBox(height: 12),
                _KeyChips(
                  items: [
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/sanction_pages/classification_peines_page.dart",
                      "f00008",
                      'Peines principales',
                    ),
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/sanction_pages/classification_peines_page.dart",
                      "f00009",
                      'Peines complémentaires',
                    ),
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/sanction_pages/classification_peines_page.dart",
                      "f00010",
                      'Peines alternatives',
                    ),
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/sanction_pages/classification_peines_page.dart",
                      "f00011",
                      'Mesures de sûreté',
                    ),
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/sanction_pages/classification_peines_page.dart",
                      "f00012",
                      'Exécution/Aménagement',
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                _SectionCard(
                  title: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/sanction_pages/classification_peines_page.dart",
                    "f00013",
                    '1) Natures de peines',
                  ),
                  caption: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/sanction_pages/classification_peines_page.dart",
                    "f00014",
                    'Qualification pénale & échelles',
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Bullet(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/classification_peines_page.dart",
                          "f00015",
                          'Criminelles : réclusion/criminalité organisée — cour d’assises.',
                        ),
                      ),
                      _Bullet(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/classification_peines_page.dart",
                          "f00016",
                          'Correctionnelles : emprisonnement, amende délictuelle, TIG, etc.',
                        ),
                      ),
                      _Bullet(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/classification_peines_page.dart",
                          "f00017",
                          'Contraventionnelles : amendes 1 à 5ᵉ classe, sanctions spécifiques.',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                _SectionCard(
                  title: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/sanction_pages/classification_peines_page.dart",
                    "f00018",
                    '2) Peines principales / alternatives',
                  ),
                  caption: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/sanction_pages/classification_peines_page.dart",
                    "f00019",
                    'Prononcé & articulation',
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Bullet(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/classification_peines_page.dart",
                          "f00020",
                          'Principales : privatives de liberté, amendes, jours-amende, TIG.',
                        ),
                      ),
                      _Bullet(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/classification_peines_page.dart",
                          "f00021",
                          'Alternatives : ajournement, sursis probatoire, peine autonome (TIG, stage…).',
                        ),
                      ),
                      _Bullet(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/classification_peines_page.dart",
                          "f00022",
                          'Aménagements : semi-liberté, bracelet, libération sous contrainte (conditions légales).',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                _SectionCard(
                  title: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/sanction_pages/classification_peines_page.dart",
                    "f00023",
                    '3) Peines complémentaires',
                  ),
                  caption: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/sanction_pages/classification_peines_page.dart",
                    "f00024",
                    'Interdictions · Confiscations · Affichage',
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Bullet(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/classification_peines_page.dart",
                          "f00025",
                          'Interdictions de droits, d’exercer, de paraître ; suspension permis, armes, etc.',
                        ),
                      ),
                      _Bullet(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/classification_peines_page.dart",
                          "f00026",
                          'Confiscations : objets dangereux/prohibés, profits ; traçabilité patrimoniale.',
                        ),
                      ),
                      _Bullet(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/classification_peines_page.dart",
                          "f00027",
                          'Publications/affichages : quand la loi le prévoit.',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                _SectionCard(
                  title: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/sanction_pages/classification_peines_page.dart",
                    "f00028",
                    '4) Mesures de sûreté',
                  ),
                  caption: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/sanction_pages/classification_peines_page.dart",
                    "f00029",
                    'Prévention de la récidive/risque',
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Bullet(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/classification_peines_page.dart",
                          "f00030",
                          'Mesures non répressives : ex. suivi socio-judiciaire, interdictions, soins.',
                        ),
                      ),
                      _Bullet(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/classification_peines_page.dart",
                          "f00031",
                          'Prononcé et durée guidés par la dangerosité et l’intérêt de la société.',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                _SectionCard(
                  title: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/sanction_pages/classification_peines_page.dart",
                    "f00032",
                    '5) Points de vigilance',
                  ),
                  caption: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/sanction_pages/classification_peines_page.dart",
                    "f00033",
                    'Légalité du prononcé & motivation',
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Bullet(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/classification_peines_page.dart",
                          "f00034",
                          'Motivation de la peine : individualisation (personnalité, faits, insertion).',
                        ),
                      ),
                      _Bullet(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/classification_peines_page.dart",
                          "f00035",
                          'Compatibilité peines/mesures ; limites légales (cumul, non bis in idem).',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                Text(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/sanction_pages/classification_peines_page.dart",
                    "f00036",
                    'Aller plus loin',
                  ),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : _Ink.ink,
                  ),
                ),
                const SizedBox(height: 12),
                _LinkTile(
                  title: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/sanction_pages/classification_peines_page.dart",
                    "f00037",
                    'Causes d’aggravation de la sanction',
                  ),
                  subtitle: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/sanction_pages/classification_peines_page.dart",
                    "f00038",
                    'Récidive · Circonstances aggravantes',
                  ),
                  route: '/gpx/sanction/causes_aggravation',
                ),
                const SizedBox(height: 10),
                _LinkTile(
                  title: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/sanction_pages/classification_peines_page.dart",
                    "f00039",
                    'Pluralité d’infractions',
                  ),
                  subtitle: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/sanction_pages/classification_peines_page.dart",
                    "f00040",
                    'Cumul/Concours · Confusion de peines',
                  ),
                  route: '/gpx/sanction/pluralite_infractions',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ====================== HERO + STYLES (communs) ======================

class _HeroHeader extends StatelessWidget {
  final String badge;
  final String title;
  final String subtitle;
  final String image;
  final VoidCallback onPrimaryTap;

  const _HeroHeader({
    required this.badge,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.onPrimaryTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
        child: Container(
          height: (MediaQuery.of(context).size.height * 0.30).clamp(
            220.0,
            300.0,
          ),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_Token.r24),
            boxShadow: [_Token.shadow],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(child: Image.asset(image, fit: BoxFit.cover)),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                      colors: [
                        Colors.black.withValues(alpha: isDark ? .55 : .45),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 14,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Badge(text: badge),
                    const SizedBox(height: 8),
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 22,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: .85),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: onPrimaryTap,
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: Text(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/classification_peines_page.dart",
                          "f00041",
                          'Découvrir',
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.white,
                        foregroundColor: _Ink.ink,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
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
  }
}

class _Ink {
  static const ink = Color(0xFF212529);
}

class _Token {
  static const double r16 = 16, r20 = 20, r24 = 24;
  static BoxShadow get shadow => BoxShadow(
    color: Colors.black.withValues(alpha: .08),
    blurRadius: 20,
    offset: const Offset(0, 10),
  );
}

class _SectionCard extends StatelessWidget {
  final String title;
  final String? caption;
  final Widget child;
  const _SectionCard({required this.title, required this.child, this.caption});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(_Token.r20),
        boxShadow: [_Token.shadow],
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (caption != null) ...[
            Text(
              caption!,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: (isDark ? Colors.white : _Ink.ink).withValues(alpha: .6),
              ),
            ),
            const SizedBox(height: 4),
          ],
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 16,
              color: isDark ? Colors.white : _Ink.ink,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  const _Badge({required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .90),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: _Ink.ink,
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet(this.text);
  @override
  Widget build(BuildContext context) {
    final muted = (Theme.of(context).textTheme.bodyMedium?.color ?? _Ink.ink)
        .withValues(alpha: .9);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(Icons.fiber_manual_record, size: 8),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: TextStyle(height: 1.25, color: muted)),
          ),
        ],
      ),
    );
  }
}

class _KeyChips extends StatelessWidget {
  final List<String> items;
  const _KeyChips({required this.items});
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: -4,
      children: items
          .map(
            (e) => Chip(
              label: Text(
                e,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              backgroundColor: Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.black.withValues(alpha: .06)),
              ),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
          )
          .toList(),
    );
  }
}

class _LinkTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String route;
  const _LinkTile({
    required this.title,
    required this.subtitle,
    required this.route,
  });
  @override
  Widget build(BuildContext context) {
    final muted = (Theme.of(context).textTheme.bodySmall?.color ?? _Ink.ink)
        .withValues(alpha: .7);
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(route),
      borderRadius: BorderRadius.circular(_Token.r16),
      child: Ink(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(_Token.r16),
          boxShadow: [_Token.shadow],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          leading: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: _Ink.ink.withValues(alpha: .08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.scale_rounded, color: _Ink.ink),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          subtitle: Text(subtitle, style: TextStyle(color: muted)),
          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        ),
      ),
    );
  }
}
