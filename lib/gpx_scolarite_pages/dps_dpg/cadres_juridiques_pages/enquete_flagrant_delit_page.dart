// lib/gpx_scolarite_pages/cadres_juridiques_pages/enquete_flagrant_delit_page.dart

import 'package:flutter/material.dart';

/// Page : Enquête de flagrant délit
/// Route : /gpx/cadres_juridiques/enquete_flagrant_delit
class EnqueteFlagrantDelitPage extends StatelessWidget {
  static const String routeName =
      '/gpx/cadres_juridiques/enquete_flagrant_delit';
  const EnqueteFlagrantDelitPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _HeroHeader(
            title: 'Enquête de flagrant délit',
            subtitle: 'Actes immédiats · Pouvoirs renforcés · Urgence',
            image: 'assets/images/cadres_juridiques.jpeg',
            onPrimaryTap: () {},
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            sliver: SliverList.list(
              children: [
                _SectionCard(
                  title: 'Définition pratique',
                  child: const Text(
                    'La flagrance s’applique lorsque l’infraction se commet actuellement ou vient de se commettre. '
                    'Elle confère aux OPJ des pouvoirs étendus pour agir vite, conserver la preuve et rechercher les auteurs.',
                  ),
                ),
                const SizedBox(height: 12),
                const _KeyChips(
                  items: [
                    'Urgence',
                    'Pouvoirs renforcés',
                    'Périmètre spatio-temporel',
                    'GAV',
                    'Perquisitions/saisies',
                  ],
                ),
                const SizedBox(height: 16),
                _SectionCard(
                  title: 'Conditions de la flagrance',
                  caption: 'Indices apparents & temporalité',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      _Bullet('Infraction en cours ou tout juste commise.'),
                      _Bullet(
                        'Indices apparents d’un comportement infractionnel.',
                      ),
                      _Bullet(
                        'Périmètre de flagrance limité dans le temps et l’espace (se referme avec l’éloignement temporel).',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _SectionCard(
                  title: 'Pouvoirs principaux',
                  caption: 'Actes réalisables',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      _Bullet(
                        'Interpellations immédiates, GAV si conditions réunies.',
                      ),
                      _Bullet(
                        'Perquisitions et saisies (cadre flagrant) avec formalités spécifiques.',
                      ),
                      _Bullet(
                        'Constatations, auditions rapides, sécurisation des lieux et personnes.',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _SectionCard(
                  title: 'Réflexes opérationnels',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      _ChecklistLine(
                        'Justifier clairement le caractère flagrant (faits/horodatage).',
                      ),
                      _ChecklistLine(
                        'Tracer les actes urgents et leur nécessité.',
                      ),
                      _ChecklistLine(
                        'Respecter les droits (GAV, perquisitions, scellés).',
                      ),
                      _ChecklistLine(
                        'Basculer ensuite vers un cadre adapté si la flagrance cesse.',
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
                const SizedBox(height: 10),
                const _LinkTile(
                  title: 'Les cadres d’enquête (vue d’ensemble)',
                  subtitle: 'Flagrance · Préliminaire · Autres',
                  route: '/gpx/cadres_juridiques/cadres_enquete',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ======= Widgets de style (local à la page) =======
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
  Widget build(BuildContext context) => Container(
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
  Widget build(BuildContext context) => Wrap(
    spacing: 8,
    runSpacing: -4,
    children: items
        .map(
          (e) => Chip(
            label: Text(e, style: const TextStyle(fontWeight: FontWeight.w700)),
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
            child: const Icon(Icons.flash_on_rounded, color: _Ink.ink),
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
