// lib/gpx_scolarite_pages/cadres_juridiques_pages/cadres_enquete_page.dart

import 'package:flutter/material.dart';

/// Page : Les cadres d'enquête (vue d’ensemble)
/// Route : /gpx/cadres_juridiques/cadres_enquete
class CadresEnquetePage extends StatelessWidget {
  static const String routeName = '/gpx/cadres_juridiques/cadres_enquete';
  const CadresEnquetePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _HeroHeader(
            title: 'Les cadres d’enquête',
            subtitle: 'Flagrance · Préliminaire · Autres cadres',
            image: 'assets/images/cadres_juridiques.jpeg',
            onPrimaryTap: () {},
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            sliver: SliverList.list(
              children: [
                _SectionCard(
                  title: 'Vue d’ensemble',
                  child: const Text(
                    'L’enquête judiciaire repose sur plusieurs cadres légaux. '
                    'Chaque cadre détermine les pouvoirs d’enquête, la durée, les autorisations requises '
                    'et les garanties procédurales. Le choix du cadre sécurise la preuve et conditionne la suite procédurale.',
                  ),
                ),
                const SizedBox(height: 12),
                const _KeyChips(
                  items: [
                    'Base légale',
                    'Pouvoirs d’enquête',
                    'Autorisation judiciaire',
                    'Durée',
                    'Garanties procédurales',
                  ],
                ),
                const SizedBox(height: 16),
                _SectionCard(
                  title: 'Pourquoi qualifier le cadre ?',
                  caption: 'Sécurisation de la preuve',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      _Bullet(
                        'Détermine l’étendue des actes possibles (perquisition, saisie, interceptions…).',
                      ),
                      _Bullet(
                        'Impacte la durée des mesures de contrainte (ex. GAV) et les formalités.',
                      ),
                      _Bullet(
                        'Conditionne l’autorisation requise (OPJ/Procureur/JLD/JI).',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _SectionCard(
                  title: 'Cadres principaux',
                  caption: 'Les trois blocs usuels',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      _Bullet(
                        'Enquête de flagrance : infraction en train de se commettre ou venant de se commettre.',
                      ),
                      _Bullet(
                        'Enquête préliminaire : en l’absence de flagrance, sous direction Procureur.',
                      ),
                      _Bullet(
                        'Autres cadres : commission rogatoire, JI, douanes, enquêtes spécialisées, etc.',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _SectionCard(
                  title: 'Réflexes PV',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      _ChecklistLine(
                        'Poser le contexte factuel justifiant le cadre choisi.',
                      ),
                      _ChecklistLine(
                        'Tracer les autorisations/avis donnés (Procureur/JLD/JI).',
                      ),
                      _ChecklistLine(
                        'Respecter les durées/process PV, informer des droits.',
                      ),
                      _ChecklistLine(
                        'Adapter le cadre si la situation évolue (requalification).',
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
                  title: 'Enquête de flagrant délit',
                  subtitle: 'Actes immédiats · Pouvoirs renforcés',
                  route: '/gpx/cadres_juridiques/enquete_flagrant_delit',
                ),
                const SizedBox(height: 10),
                const _LinkTile(
                  title: 'Enquête préliminaire',
                  subtitle: 'Direction Procureur · Autorisations requises',
                  route: '/gpx/cadres_juridiques/enquete_preliminaire',
                ),
                const SizedBox(height: 10),
                const _LinkTile(
                  title: 'Autres cadres d’enquête',
                  subtitle: 'JI · CR · Douanes · Spécialités',
                  route: '/gpx/cadres_juridiques/autres_cadres_enquete',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ======= Style widgets communs (local à la page) =======
class _Ink {
  static const ink = Color(0xFF212529);
}

class _Token {
  static const r16 = 16.0, r20 = 20.0, r24 = 24.0;
  static BoxShadow get shadow => BoxShadow(
    color: Colors.black.withOpacity(.08),
    blurRadius: 20,
    offset: const Offset(0, 10),
  );
}

class _HeroHeader extends StatelessWidget {
  final String title, subtitle, image;
  final VoidCallback onPrimaryTap;
  const _HeroHeader({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.onPrimaryTap,
  });
  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
        child: Container(
          height: (MediaQuery.of(context).size.height * .30).clamp(
            220.0,
            300.0,
          ),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_Token.r24),
            boxShadow: [_Token.shadow],
          ),
          child: Stack(
            children: [
              Positioned.fill(child: Image.asset(image, fit: BoxFit.cover)),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                      colors: [
                        Colors.black.withOpacity(dark ? .55 : .45),
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
                    const _Badge(text: 'Cadres juridiques'),
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
                        color: Colors.white.withOpacity(.85),
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

class _Badge extends StatelessWidget {
  final String text;
  const _Badge({required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.90),
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

class _SectionCard extends StatelessWidget {
  final String title;
  final String? caption;
  final Widget child;
  const _SectionCard({required this.title, required this.child, this.caption});
  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
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
                color: (dark ? Colors.white : _Ink.ink).withOpacity(.6),
              ),
            ),
            const SizedBox(height: 4),
          ],
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 16,
              color: dark ? Colors.white : _Ink.ink,
            ),
          ),
          const SizedBox(height: 10),
          child,
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
                side: BorderSide(color: Colors.black.withOpacity(.06)),
              ),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
          )
          .toList(),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet(this.text);
  @override
  Widget build(BuildContext context) {
    final color = (Theme.of(context).textTheme.bodyMedium?.color ?? _Ink.ink)
        .withOpacity(.9);
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
            child: Text(text, style: TextStyle(height: 1.25, color: color)),
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
    final color = (Theme.of(context).textTheme.bodySmall?.color ?? _Ink.ink)
        .withOpacity(.9);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle_rounded, size: 18, color: Colors.green),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: TextStyle(height: 1.25, color: color)),
          ),
        ],
      ),
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
    final muted = (Theme.of(context).textTheme.bodySmall?.color ?? _Ink.ink)
        .withOpacity(.7);
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
              color: _Ink.ink.withOpacity(.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.article_rounded, color: _Ink.ink),
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
