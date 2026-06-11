// lib/pa/dps_dpg/sanctions/causes_aggravation_page.dart

import 'package:flutter/material.dart';

/// Page : La sanction — Causes d’aggravation de la sanction
/// Route alignée avec la config : /pa/dps_dpg/sanctions/causes_aggravation
class PaCausesAggravationPage extends StatelessWidget {
  static const String routeName = '/pa/dps_dpg/sanctions/causes_aggravation';
  const PaCausesAggravationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _HeroHeader(
            badge: 'La sanction',
            title: 'Causes d’aggravation de la sanction',
            subtitle: 'Récidive · Circonstances aggravantes · Pluralité',
            image: 'assets/images/sanction.jpeg',
            onPrimaryTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Aggravations — Récap 👌')),
              );
            },
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            sliver: SliverList.list(
              children: [
                const _SectionCard(
                  title: 'Objet',
                  child: Text(
                    'Identifier les causes d’aggravation prévues par la loi (récidive, circonstances aggravantes, '
                    'statuts particuliers) et leur impact sur la qualification et l’échelle des peines.',
                  ),
                ),

                const SizedBox(height: 12),
                const _KeyChips(
                  items: [
                    'Récidive',
                    'Circonstances aggravantes',
                    'Statuts protégés',
                    'Peines planchers (si texte)',
                    'Motivation renforcée',
                  ],
                ),

                const SizedBox(height: 16),
                const _SectionCard(
                  title: '1) Récidive',
                  caption: 'Conditions temporelles et matérielles',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Bullet(
                        'Contrainte légale : antécédent définitif + nouvelle infraction dans les délais légaux.',
                      ),
                      _Bullet(
                        'Effets : élévation des maxima, planchers éventuels, aménagements limités selon textes.',
                      ),
                      _Bullet(
                        'PV : relever les références du jugement antérieur et dates utiles.',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                const _SectionCard(
                  title: '2) Circonstances aggravantes',
                  caption:
                      'Qualité de la victime · Bande organisée · Arme · Lieu',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Bullet(
                        'Victime vulnérable / dépositaire de l’autorité publique.',
                      ),
                      _Bullet(
                        'Bande organisée, préméditation, réunion, escalade…',
                      ),
                      _Bullet(
                        'Usage/port d’arme, véhicule comme arme, lieu protégé (école, transports…).',
                      ),
                      _Bullet(
                        'Effet : requalification possible (délit → crime) et maxima relevés.',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                const _SectionCard(
                  title: '3) Statuts/professions protégés',
                  caption:
                      'Ex. conjoint, mineur, magistrat, policier… (suivant textes)',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Bullet(
                        'Aggravations automatiques si l’infraction vise certaines victimes ou fonctions.',
                      ),
                      _Bullet(
                        'Rappeler précisément la qualité et le contexte dans la procédure.',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                const _SectionCard(
                  title: '4) Vigilance procédurale',
                  caption: 'Preuves & mentions',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ChecklistLine(
                        'Rassembler les éléments objectifs (pièces du casier, jugement, constats).',
                      ),
                      _ChecklistLine(
                        'Identifier clairement la circonstance retenue et le texte applicable.',
                      ),
                      _ChecklistLine(
                        'Motiver le prononcé de la peine (individualisation + aggravation).',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                Text(
                  'Aller plus loin',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : _Ink.ink,
                  ),
                ),
                const SizedBox(height: 12),
                const _LinkTile(
                  title: 'Classification des peines',
                  subtitle: 'Natures · Alternatives · Mesures de sûreté',
                  route: '/pa/dps_dpg/sanctions/classification_peines',
                ),
                const SizedBox(height: 10),
                const _LinkTile(
                  title: 'Pluralité d’infractions',
                  subtitle: 'Concours & cumul · Confusion de peines',
                  route: '/pa/dps_dpg/sanctions/pluralite_infractions',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==== (mêmes widgets utilitaires que le fichier précédent) ====

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
                      label: const Text('Découvrir'),
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
    final c = (Theme.of(context).textTheme.bodyMedium?.color ?? _Ink.ink)
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

class _ChecklistLine extends StatelessWidget {
  final String text;
  const _ChecklistLine(this.text);
  @override
  Widget build(BuildContext context) {
    final c = (Theme.of(context).textTheme.bodySmall?.color ?? _Ink.ink)
        .withValues(alpha: .9);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle_rounded, size: 18, color: Colors.green),
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
            child: const Icon(Icons.trending_up_rounded, color: _Ink.ink),
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
