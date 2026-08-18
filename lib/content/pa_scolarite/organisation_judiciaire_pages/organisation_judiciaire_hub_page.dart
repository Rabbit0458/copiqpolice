import 'package:flutter/material.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaOrganisationJudiciaireHubPage extends StatelessWidget {
  const PaOrganisationJudiciaireHubPage({super.key});
  static const String routeName = '/pa/hub/organisation_judiciaire';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0B1016)
          : const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: isDark
            ? const Color(0xFF0B1016)
            : const Color(0xFFF5F7FA),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          tooltip: ScolariteText.value(
            "lib/content/pa_scolarite/organisation_judiciaire_pages/organisation_judiciaire_hub_page.dart",
            "f00001",
            'Retour',
          ),
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _HeroHeader(
            badge: ScolariteText.value(
              "lib/content/pa_scolarite/organisation_judiciaire_pages/organisation_judiciaire_hub_page.dart",
              "f00002",
              'Organisation judiciaire',
            ),
            title: ScolariteText.value(
              "lib/content/pa_scolarite/organisation_judiciaire_pages/organisation_judiciaire_hub_page.dart",
              "f00003",
              'L\'organisation judiciaire',
            ),
            subtitle: ScolariteText.value(
              "lib/content/pa_scolarite/organisation_judiciaire_pages/organisation_judiciaire_hub_page.dart",
              "f00004",
              'Juridictions · Parquet · Instruction',
            ),
            image: 'assets/images/institution_valeurs.jpeg',
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            sliver: SliverList.list(
              children: [
                _SectionCard(
                  title: ScolariteText.value(
                    "lib/content/pa_scolarite/organisation_judiciaire_pages/organisation_judiciaire_hub_page.dart",
                    "f00005",
                    'Objectif pédagogique',
                  ),
                  child: Text(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/organisation_judiciaire_pages/organisation_judiciaire_hub_page.dart",
                          "f00006",
                          'Maîtriser la structure des juridictions françaises, comprendre ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/organisation_judiciaire_pages/organisation_judiciaire_hub_page.dart",
                          "f00007",
                          'le rôle du parquet, du juge d\'instruction et les différentes ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/organisation_judiciaire_pages/organisation_judiciaire_hub_page.dart",
                          "f00008",
                          'juridictions pénales pour agir efficacement dans vos missions.',
                        ),
                  ),
                ),
                const SizedBox(height: 12),
                _KeyChips(
                  items: [
                    'Juridictions',
                    'Parquet',
                    'Instruction',
                    'Tribunaux',
                    ScolariteText.value(
                      "lib/content/pa_scolarite/organisation_judiciaire_pages/organisation_judiciaire_hub_page.dart",
                      "f00009",
                      'Cours d\'appel',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _SectionCard(
                  title: ScolariteText.value(
                    "lib/content/pa_scolarite/organisation_judiciaire_pages/organisation_judiciaire_hub_page.dart",
                    "f00010",
                    'Points clés',
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Bullet(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/organisation_judiciaire_pages/organisation_judiciaire_hub_page.dart",
                          "f00011",
                          'L\'ordre judiciaire se divise en juridictions civiles et pénales.',
                        ),
                      ),
                      _Bullet(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/organisation_judiciaire_pages/organisation_judiciaire_hub_page.dart",
                          "f00012",
                          'Le ministère public (parquet) représente la société et décide des poursuites.',
                        ),
                      ),
                      _Bullet(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/organisation_judiciaire_pages/organisation_judiciaire_hub_page.dart",
                          "f00013",
                          'Le juge d\'instruction est saisi pour les affaires complexes.',
                        ),
                      ),
                      _Bullet(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/organisation_judiciaire_pages/organisation_judiciaire_hub_page.dart",
                          "f00014",
                          'La Cour d\'assises juge les crimes — seule juridiction avec jury populaire.',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/organisation_judiciaire_pages/organisation_judiciaire_hub_page.dart",
                    "f00015",
                    'Cours disponibles',
                  ),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : const Color(0xFF212529),
                  ),
                ),
                const SizedBox(height: 10),
                _LinkTile(
                  title: ScolariteText.value(
                    "lib/content/pa_scolarite/organisation_judiciaire_pages/organisation_judiciaire_hub_page.dart",
                    "f00016",
                    'Structure judiciaire',
                  ),
                  subtitle: ScolariteText.value(
                    "lib/content/pa_scolarite/organisation_judiciaire_pages/organisation_judiciaire_hub_page.dart",
                    "f00017",
                    'Ordres, degrés et juridictions',
                  ),
                  route: '/pa/organisation_judiciaire/structure',
                ),
                const SizedBox(height: 10),
                _LinkTile(
                  title: ScolariteText.value(
                    "lib/content/pa_scolarite/organisation_judiciaire_pages/organisation_judiciaire_hub_page.dart",
                    "f00018",
                    'Le ministère public',
                  ),
                  subtitle: ScolariteText.value(
                    "lib/content/pa_scolarite/organisation_judiciaire_pages/organisation_judiciaire_hub_page.dart",
                    "f00019",
                    'Parquet, procureur, substituts',
                  ),
                  route: '/pa/organisation_judiciaire/ministere_public',
                ),
                const SizedBox(height: 10),
                _LinkTile(
                  title: ScolariteText.value(
                    "lib/content/pa_scolarite/organisation_judiciaire_pages/organisation_judiciaire_hub_page.dart",
                    "f00020",
                    'Le juge d\'instruction',
                  ),
                  subtitle: ScolariteText.value(
                    "lib/content/pa_scolarite/organisation_judiciaire_pages/organisation_judiciaire_hub_page.dart",
                    "f00021",
                    'Rôle, pouvoirs et procédure',
                  ),
                  route: '/pa/organisation_judiciaire/juge_instruction',
                ),
                const SizedBox(height: 10),
                _LinkTile(
                  title: ScolariteText.value(
                    "lib/content/pa_scolarite/organisation_judiciaire_pages/organisation_judiciaire_hub_page.dart",
                    "f00022",
                    'Juridictions pénales',
                  ),
                  subtitle: ScolariteText.value(
                    "lib/content/pa_scolarite/organisation_judiciaire_pages/organisation_judiciaire_hub_page.dart",
                    "f00023",
                    'Tribunal correctionnel, assises, proximité',
                  ),
                  route: '/pa/organisation_judiciaire/juridictions_penales',
                ),
                const SizedBox(height: 10),
                _LinkTile(
                  title: ScolariteText.value(
                    "lib/content/pa_scolarite/organisation_judiciaire_pages/organisation_judiciaire_hub_page.dart",
                    "f00024",
                    'Voies de recours',
                  ),
                  subtitle: ScolariteText.value(
                    "lib/content/pa_scolarite/organisation_judiciaire_pages/organisation_judiciaire_hub_page.dart",
                    "f00025",
                    'Appel, cassation, opposition',
                  ),
                  route: '/pa/organisation_judiciaire/voies_recours',
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
// Widgets privés
// ═══════════════════════════════════════════════════════════════════════════

class _HeroHeader extends StatelessWidget {
  final String badge, title, subtitle, image;
  const _HeroHeader({
    required this.badge,
    required this.title,
    required this.subtitle,
    required this.image,
  });
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
        child: Container(
          height: 218,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .08),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(image, fit: BoxFit.cover),
              DecoratedBox(
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
              Positioned(
                left: 16,
                right: 16,
                bottom: 14,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .90),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        badge,
                        style: const TextStyle(
                          color: Color(0xFF212529),
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                    ),
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

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _SectionCard({required this.title, required this.child});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ink = isDark ? Colors.white : const Color(0xFF212529);
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF151D27) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: .07)
              : const Color(0xFFE4E9F0),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 16,
              color: ink,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet(this.text);
  @override
  Widget build(BuildContext context) {
    final c =
        (Theme.of(context).textTheme.bodyMedium?.color ??
                const Color(0xFF212529))
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
            child: Text(text, style: TextStyle(height: 1.25, color: c)),
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
  final String title, subtitle, route;
  const _LinkTile({
    required this.title,
    required this.subtitle,
    required this.route,
  });
  @override
  Widget build(BuildContext context) {
    final muted =
        (Theme.of(context).textTheme.bodySmall?.color ??
                const Color(0xFF212529))
            .withValues(alpha: .7);
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(route),
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .08),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
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
              color: const Color(0xFF212529).withValues(alpha: .08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.gavel_rounded, color: Color(0xFF212529)),
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
