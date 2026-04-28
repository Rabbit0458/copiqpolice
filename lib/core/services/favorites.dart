// lib/services/favorites.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteItem {
  final String route;
  final String title;
  final String subtitle;
  final String image;
  final double rating;
  final int reviews;

  const FavoriteItem({
    required this.route,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.rating,
    required this.reviews,
  });

  Map<String, dynamic> toJson() => {
    'route': route,
    'title': title,
    'subtitle': subtitle,
    'image': image,
    'rating': rating,
    'reviews': reviews,
  };

  static FavoriteItem fromJson(Map<String, dynamic> json) => FavoriteItem(
    route: json['route'] as String,
    title: json['title'] as String,
    subtitle: (json['subtitle'] as String?) ?? '',
    image: (json['image'] as String?) ?? '',
    rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    reviews: (json['reviews'] as num?)?.toInt() ?? 0,
  );
}

class FavoritesStore {
  FavoritesStore._();
  static final FavoritesStore I = FavoritesStore._();

  static const _kKey = 'favorites_v1';

  final ValueNotifier<List<FavoriteItem>> favorites = ValueNotifier(const []);
  bool _loaded = false;

  Future<void> _ensureLoaded() async {
    if (_loaded) return;
    _loaded = true;
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getStringList(_kKey) ?? const [];
    final parsed = <FavoriteItem>[];
    for (final s in raw) {
      try {
        parsed.add(FavoriteItem.fromJson(jsonDecode(s)));
      } catch (_) {}
    }
    favorites.value = parsed;
  }

  Future<void> _save() async {
    final sp = await SharedPreferences.getInstance();
    await sp.setStringList(
      _kKey,
      favorites.value.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }

  Future<bool> isFavorite(String route) async {
    await _ensureLoaded();
    return favorites.value.any((e) => e.route == route);
  }

  Future<void> toggle(FavoriteItem item) async {
    await _ensureLoaded();
    final list = List<FavoriteItem>.from(favorites.value);
    final idx = list.indexWhere((e) => e.route == item.route);
    if (idx >= 0) {
      list.removeAt(idx);
    } else {
      list.insert(0, item);
    }
    favorites.value = list;
    await _save();
  }

  Future<void> removeByRoute(String route) async {
    await _ensureLoaded();
    favorites.value = favorites.value
        .where((e) => e.route != route)
        .toList(growable: false);
    await _save();
  }
}
