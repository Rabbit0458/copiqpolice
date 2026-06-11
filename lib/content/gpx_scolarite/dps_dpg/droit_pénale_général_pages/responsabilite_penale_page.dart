// lib/gpx_scolarite_pages/droit_pénale_général_pages/responsabilite_penale_page.dart

import 'package:flutter/material.dart';

/// Page : Droit pénal général — De la responsabilité pénale
/// Route alignée avec la config centrale : /dpg/responsabilite_penale
class ResponsabilitePenalePage extends StatelessWidget {
  static const String routeName = '/dpg/responsabilite_penale';
  const ResponsabilitePenalePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _HeroHeader(
            badge: 'Droit pénal général',
            title: 'De la responsabilité pénale',
            subtitle:
                'Auteurs & complices · Élément moral · Causes d’irresponsabilité',
            image: 'assets/images/droit_penal_general.jpeg',
            onPrimaryTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Panorama responsabilité pénale 👌'),
                ),
              );
            },
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            sliver: SliverList.list(
              children: [
                const _SectionCard(
                  title: 'Principes',
                  child: Text(
                    'La responsabilité pénale suppose un fait prévu par la loi (élément légal), un comportement '
                    'matériel (élément matériel) et un élément moral (intention/négligence). Elle peut être personnelle '
                    'ou, dans certains cas, engagée à l’égard des personnes morales.',
                  ),
                ),

                const SizedBox(height: 12),
                const _KeyChips(
                  items: [
                    'Élément légal',
                    'Élément matériel',
                    'Élément moral',
                    'Participation criminelle',
                    'Irresponsabilités',
                  ],
                ),

                const SizedBox(height: 16),
                const _SectionCard(
                  title: '1) Auteurs & complices',
                  caption:
                      'Coauteur · Complicité par aide/assistance · Provocation/Instructions',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Bullet(
                        'Auteur/coauteur : exécution directe des éléments constitutifs.',
                      ),
                      _Bullet(
                        'Complice : aide/assistance ou provocation/instructions, avec intention.',
                      ),
                      _Bullet(
                        'Responsabilité autonome du complice si l’infraction principale est caractérisée.',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                const _SectionCard(
                  title: '2) Élément moral',
                  caption: 'Intention · Imprudence/Négligence',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Bullet(
                        'Infractions intentionnelles : volonté de commettre les faits prohibés.',
                      ),
                      _Bullet(
                        'Infractions non-intentionnelles : imprudence, négligence, manquement à une obligation.',
                      ),
                      _Bullet(
                        'Dolos éventuels/acceptation du risque : appréciation au cas par cas (éléments objectifs).',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                const _SectionCard(
                  title: '3) Tentative & faits justificatifs',
                  caption:
                      'Tentative punissable · Légitime défense · État de nécessité',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Bullet(
                        'Tentative : commencement d’exécution + absence de désistement volontaire.',
                      ),
                      _Bullet(
                        'Faits justificatifs : légitime défense, ordre/autorisation de la loi, commandement de l’autorité légitime.',
                      ),
                      _Bullet(
                        'État de nécessité : sauvegarde d’un intérêt supérieur, conditions strictes.',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                const _SectionCard(
                  title: '4) Personnes morales',
                  caption: 'Conditions & limites',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Bullet(
                        'Responsabilité pour les infractions commises pour leur compte par leurs organes/ représentants.',
                      ),
                      _Bullet(
                        'Cumul possible avec la responsabilité des personnes physiques (auteurs/complices).',
                      ),
                      _Bullet(
                        'Peines spécifiques : amendes, peines complémentaires (fermeture, interdictions…).',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                const _SectionCard(
                  title: '5) Empêchements & irresponsabilités',
                  caption:
                      'Mineurs · Trouble mental · Erreur invincible · Contrainte',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Bullet(
                        'Mineurs : règles spécifiques d’irresponsabilité atténuée & mesures éducatives/peines adaptées.',
                      ),
                      _Bullet(
                        'Abolition du discernement : irresponsabilité ; altération : atténuation de responsabilité/peine.',
                      ),
                      _Bullet(
                        'Erreur invincible/Contrainte : appréciation stricte, preuves circonstanciées.',
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
                  title: 'De la loi pénale',
                  subtitle: 'Sources · Application · Interprétation',
                  route: '/dpg/loi_penale',
                ),
                const SizedBox(height: 10),
                const _LinkTile(
                  title: 'La sanction',
                  subtitle: 'Classification des peines · Aggravations',
                  route: '/sanction',
                ),
                const SizedBox(height: 10),
                const _LinkTile(
                  title: 'Généralités',
                  subtitle:
                      'Infraction · Tentative · Complicité · Légitime défense',
                  route: '/generalite',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ====================== HERO + STYLES (communs page) ======================

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

class _ChecklistLine extends StatelessWidget {
  final String text;
  const _ChecklistLine(this.text);
  @override
  Widget build(BuildContext context) {
    final muted = (Theme.of(context).textTheme.bodySmall?.color ?? _Ink.ink)
        .withValues(alpha: .9);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle_rounded, size: 18, color: Colors.green),
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
            child: const Icon(Icons.balance_rounded, color: _Ink.ink),
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
