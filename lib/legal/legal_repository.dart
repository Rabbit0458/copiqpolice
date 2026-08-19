// lib/legal/legal_repository.dart
//
// Accès Supabase centralisé pour les documents juridiques
// (public.information_contents). Aucun texte légal n'est stocké en dur dans
// l'app : Supabase est la source de vérité, ce repository est le seul point
// d'entrée réseau, avec un cache local (SharedPreferences) pour l'affichage
// hors-ligne / instantané.
//
// RLS : la policy `information_contents_public_read` autorise déjà la
// lecture publique (anon + authenticated) des lignes `status = 'published'`
// (ou `scheduled` échue) — aucune session utilisateur n'est requise ici.

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:copiqpolice/legal/legal_document.dart';

class LegalRepository {
  LegalRepository._();
  static final LegalRepository instance = LegalRepository._();
  static LegalRepository get I => instance;

  SupabaseClient get _sb => Supabase.instance.client;

  static const _cachePrefix = 'legal_doc_cache_v1_';

  final Map<String, LegalDocument> _memoryCache = {};

  static const _selectColumns =
      'id,content_type,slug,title,summary,body_md,status,version,published_at,updated_at';

  /// Récupère le document publié le plus récent pour [documentKey]
  /// (= `content_type`). Retourne `null` si aucun document publié
  /// n'existe — ne révèle jamais un brouillon ou une archive (RLS côté BDD).
  Future<LegalDocument?> getPublishedDocument(String documentKey) async {
    if (_memoryCache.containsKey(documentKey)) {
      // Rafraîchissement en tâche de fond, retour immédiat de la valeur en
      // mémoire — évite une requête réseau à chaque ouverture de page dans
      // la même session.
      _fetchAndCache(documentKey).ignore();
      return _memoryCache[documentKey];
    }

    final cached = await _readCache(documentKey);
    if (cached != null) {
      _memoryCache[documentKey] = cached;
      _fetchAndCache(documentKey).ignore();
      return cached;
    }

    return _fetchAndCache(documentKey);
  }

  /// Force un appel réseau (pull-to-refresh) sans jamais vider le cache
  /// avant d'avoir reçu une réponse valide.
  Future<LegalDocument?> refresh(String documentKey) =>
      _fetchAndCache(documentKey);

  Future<LegalDocument?> _fetchAndCache(String documentKey) async {
    try {
      final rows = await _sb
          .from('information_contents')
          .select(_selectColumns)
          .eq('content_type', documentKey)
          .eq('status', 'published')
          .order('published_at', ascending: false)
          .limit(1);

      final list = (rows as List).cast<Map<String, dynamic>>();
      if (list.isEmpty) return null;

      final doc = LegalDocument.fromJson(list.first);
      _memoryCache[documentKey] = doc;
      await _writeCache(doc);
      return doc;
    } catch (_) {
      // Pas de connexion / erreur Supabase : on retombe sur le cache local
      // s'il existe, sinon la page affichera l'état d'erreur.
      return _readCache(documentKey);
    }
  }

  Future<LegalDocument?> _readCache(String documentKey) async {
    try {
      final sp = await SharedPreferences.getInstance();
      final raw = sp.getString('$_cachePrefix$documentKey');
      if (raw == null) return null;
      return LegalDocument.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> _writeCache(LegalDocument doc) async {
    try {
      final sp = await SharedPreferences.getInstance();
      await sp.setString(
        '$_cachePrefix${doc.documentKey}',
        jsonEncode(doc.toCacheJson()),
      );
    } catch (_) {}
  }
}
