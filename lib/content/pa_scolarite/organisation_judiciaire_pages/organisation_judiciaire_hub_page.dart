import 'package:flutter/material.dart';

class PaOrganisationJudiciaireHubPage extends StatelessWidget {
  const PaOrganisationJudiciaireHubPage({super.key});
  static const String routeName = '/pa/hub/organisation_judiciaire';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          const _HeroHeader(
            badge: 'Organisation judiciaire',
            title: 'L\'organisation judiciaire',
            subtitle: 'Juridictions · Parquet · Instruction',
            image: 'assets/images/institution_valeurs.jpeg',
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            sliver: SliverList.list(
              children: [
                const _SectionCard(
                  title: 'Objectif pédagogique',
                  child: Text(
                    'Maîtriser la structure des juridictions françaises, comprendre '
                    'le rôle du parquet, du juge d\'instruction et les différentes '
                    'juridictions pénales pour agir efficacement dans vos missions.',
                  ),
                ),
                const SizedBox(height: 12),
                const _KeyChips(items: [
                  'Juridictions',
                  'Parquet',
                  'Instruction',
                  'Tribunaux',
                  'Cours d\'appel',
                ]),
                const SizedBox(height: 16),
                const _SectionCard(
                  title: 'Points clés',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Bullet('L\'ordre judiciaire se divise en juridictions civiles et pénales.'),
                      _Bullet('Le ministère public (parquet) représente la société et décide des poursuites.'),
                      _Bullet('Le juge d\'instruction est saisi pour les affaires complexes.'),
                      _Bullet('La Cour d\'assises juge les crimes — seule juridiction avec jury populaire.'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Cours disponibles',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : const Color(0xFF212529),
                  ),
                ),
                const SizedBox(height: 10),
                const _LinkTile(
                  title: 'Structure judiciaire',
                  subtitle: 'Ordres, degrés et juridictions',
                  route: '/pa/organisation_judiciaire/structure',
                ),
                const SizedBox(height: 10),
                const _LinkTile(
                  title: 'Le ministère public',
                  subtitle: 'Parquet, procureur, substituts',
                  route: '/pa/organisation_judiciaire/ministere_public',
                ),
                const SizedBox(height: 10),
                const _LinkTile(
                  title: 'Le juge d\'instruction',
                  subtitle: 'Rôle, pouvoirs et procédure',
                  route: '/pa/organisation_judiciaire/juge_instruction',
                ),
                const SizedBox(height: 10),
                const _LinkTile(
                  title: 'Juridictions pénales',
                  subtitle: 'Tribunal correctionnel, assises, proximité',
                  route: '/pa/organisation_judiciaire/juridictions_penales',
                ),
                const SizedBox(height: 10),
                const _LinkTile(
                  title: 'Voies de recours',
                  subtitle: 'Appel, cassation, opposition',
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
  const _HeroHeader({required this.badge, required this.title, required this.subtitle, required this.image});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
        child: Container(
          height: (MediaQuery.of(context).size.height * 0.30).clamp(220.0, 300.0),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .08), blurRadius: 20, offset: const Offset(0, 10))],
          ),
          child: Stack(fit: StackFit.expand, children: [
            Image.asset(image, fit: BoxFit.cover),
            DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.center, colors: [Colors.black.withValues(alpha: isDark ? .55 : .45), Colors.transparent]))),
            Positioned(left: 16, right: 16, bottom: 14, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: Colors.white.withValues(alpha: .90), borderRadius: BorderRadius.circular(999)), child: Text(badge, style: const TextStyle(color: Color(0xFF212529), fontWeight: FontWeight.w800, fontSize: 12))),
              const SizedBox(height: 8),
              Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 22, height: 1.1)),
              const SizedBox(height: 6),
              Text(subtitle, style: TextStyle(color: Colors.white.withValues(alpha: .85), fontWeight: FontWeight.w700)),
            ])),
          ]),
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
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .08), blurRadius: 20, offset: const Offset(0, 10))]),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: ink)),
        const SizedBox(height: 10),
        child,
      ]),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet(this.text);
  @override
  Widget build(BuildContext context) {
    final c = (Theme.of(context).textTheme.bodyMedium?.color ?? const Color(0xFF212529)).withValues(alpha: .9);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Padding(padding: EdgeInsets.only(top: 6), child: Icon(Icons.fiber_manual_record, size: 8)),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: TextStyle(height: 1.25, color: c))),
      ]),
    );
  }
}

class _KeyChips extends StatelessWidget {
  final List<String> items;
  const _KeyChips({required this.items});
  @override
  Widget build(BuildContext context) {
    return Wrap(spacing: 8, runSpacing: -4, children: items.map((e) => Chip(
      label: Text(e, style: const TextStyle(fontWeight: FontWeight.w700)),
      backgroundColor: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.black.withValues(alpha: .06))),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    )).toList());
  }
}

class _LinkTile extends StatelessWidget {
  final String title, subtitle, route;
  const _LinkTile({required this.title, required this.subtitle, required this.route});
  @override
  Widget build(BuildContext context) {
    final muted = (Theme.of(context).textTheme.bodySmall?.color ?? const Color(0xFF212529)).withValues(alpha: .7);
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(route),
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .08), blurRadius: 20, offset: const Offset(0, 10))]),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          leading: Container(width: 42, height: 42, decoration: BoxDecoration(color: const Color(0xFF212529).withValues(alpha: .08), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.gavel_rounded, color: Color(0xFF212529))),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
          subtitle: Text(subtitle, style: TextStyle(color: muted)),
          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        ),
      ),
    );
  }
}
