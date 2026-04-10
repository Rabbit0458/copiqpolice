// lib/home/favoris_home.dart
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/favorites.dart';

/// ===================================================================
/// Tokens locaux (pas de dépendance à _T de la Home)
/// ===================================================================
class _FavTokens {
  static const double r12 = 12, r16 = 16, r20 = 20, r24 = 24;
  static const Color ink = Color(0xFF212529);

  static const Duration fast = Duration(milliseconds: 220);

  static BoxShadow get shadow => BoxShadow(
    color: Colors.black.withValues(alpha: .10),
    blurRadius: 20,
    offset: const Offset(0, 10),
  );
}

Color _muted(BuildContext context, [double a = .7]) {
  final base =
      Theme.of(context).textTheme.bodySmall?.color ??
      (Theme.of(context).brightness == Brightness.dark
          ? Colors.white
          : _FavTokens.ink);
  return base.withValues(alpha: a);
}

/// ===================================================================
/// PAGE FAVORIS (hérite du thème du shell HomePage — pas de Scaffold)
/// ===================================================================
class FavorisHomePage extends StatelessWidget {
  static const routeName = '/favoris';
  const FavorisHomePage({super.key});

  Future<void> _onRefresh(BuildContext context) async {
    // Haptique + léger délai pour une sensation de fluidité maximale
    HapticFeedback.mediumImpact();
    await Future<void>.delayed(const Duration(milliseconds: 600));

    // Feedback optionnel
    if (context.mounted) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Favoris actualisés'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 1),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Scroll ultra fluide: on autorise le drag via tous les devices + bouncing
    return ScrollConfiguration(
      behavior: const _UltraSmoothScrollBehavior(),
      child: Column(
        children: [
          const _Header(),
          const SizedBox(height: 8),
          Expanded(
            child: RefreshIndicator.adaptive(
              displacement: 56,
              edgeOffset: 0,
              strokeWidth: 2.5,
              color: Theme.of(context).colorScheme.primary,
              onRefresh: () => _onRefresh(context),
              child: ValueListenableBuilder<List<FavoriteItem>>(
                valueListenable: FavoritesStore.I.favorites,
                builder: (_, items, __) {
                  if (items.isEmpty) return const _EmptyStateScrollable();
                  return _FavoritesGrid(items: items);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ===================================================================
/// ScrollBehavior qui accepte souris + touch + stylus + trackpad,
/// et conserve le "bouncing" pour une sensation très fluide.
/// ===================================================================
class _UltraSmoothScrollBehavior extends MaterialScrollBehavior {
  const _UltraSmoothScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
    PointerDeviceKind.invertedStylus,
    PointerDeviceKind.trackpad,
  };

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics());
  }
}

/// ===================================================================
/// Header
/// ===================================================================
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.instrumentSansTextTheme(
      Theme.of(context).textTheme,
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Favoris',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
                fontSize: 22,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(_FavTokens.r16),
              boxShadow: [_FavTokens.shadow],
            ),
            child: IconButton(
              icon: const Icon(Icons.tune_rounded),
              onPressed: () =>
                  Navigator.of(context).pushNamed('/parametre_home'),
              tooltip: 'Paramètres',
            ),
          ),
        ],
      ),
    );
  }
}

/// ===================================================================
/// Empty state (composant d'origine)
/// ===================================================================
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 86,
              height: 86,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                shape: BoxShape.circle,
                boxShadow: [_FavTokens.shadow],
              ),
              child: const Icon(Icons.favorite_outline_rounded, size: 40),
            ),
            const SizedBox(height: 16),
            Text(
              'Aucun favori pour le moment',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 18,
                color: isDark ? Colors.white : _FavTokens.ink,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ajoutez des catégories en appuyant sur le cœur depuis la page d’accueil.',
              textAlign: TextAlign.center,
              style: TextStyle(color: _muted(context, .75)),
            ),
          ],
        ),
      ),
    );
  }
}

/// ===================================================================
/// Empty state scrollable pour permettre le pull-to-refresh quand vide
/// ===================================================================
class _EmptyStateScrollable extends StatelessWidget {
  const _EmptyStateScrollable();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: const _EmptyState(),
    );
  }
}

/// ===================================================================
/// Grid de favoris (look premium + responsive) — toujours scrollable
/// ===================================================================
class _FavoritesGrid extends StatelessWidget {
  final List<FavoriteItem> items;
  const _FavoritesGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final isWide = c.maxWidth >= 700;
        final crossAxisCount = isWide ? 2 : 1;

        // Légèrement plus haut en “étroit” pour laisser respirer le texte
        final childAspectRatio = isWide ? (16 / 9) : 1.25;

        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: childAspectRatio,
          ),
          itemBuilder: (_, i) => _FavoriteCard(item: items[i]),
        );
      },
    );
  }
}

/// ===================================================================
/// Carte Favori — Incassable (pas d’overflow)
/// ===================================================================
class _FavoriteCard extends StatelessWidget {
  final FavoriteItem item;
  const _FavoriteCard({required this.item});

  @override
  Widget build(BuildContext context) {
    Widget img;
    try {
      img = Image.asset(item.image, fit: BoxFit.cover);
    } catch (_) {
      img = Container(color: const Color(0xFF9CA3AF).withValues(alpha: .25));
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(item.route),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(_FavTokens.r20),
          boxShadow: [_FavTokens.shadow],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image + bouton cœur (supprimer)
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(_FavTokens.r20),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Positioned.fill(child: img),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Material(
                        color: Theme.of(
                          context,
                        ).cardColor.withValues(alpha: .95),
                        shape: const CircleBorder(),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () async {
                            HapticFeedback.selectionClick();
                            await FavoritesStore.I.removeByRoute(item.route);
                          },
                          child: const SizedBox(
                            width: 40,
                            height: 40,
                            child: Icon(
                              Icons.favorite_rounded,
                              color: Colors.redAccent,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bloc texte flexible
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Titre + sous-titre
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : _FavTokens.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: _muted(context, .7),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Ligne notes/meta + flèche
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: Colors.amber,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${item.rating}',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.color,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${item.reviews} avis',
                          style: TextStyle(
                            fontSize: 12,
                            color: _muted(context, .75),
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 20,
                          color: _muted(context, .8),
                        ),
                      ],
                    ),

                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
