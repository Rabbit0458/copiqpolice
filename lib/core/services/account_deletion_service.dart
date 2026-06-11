// lib/core/services/account_deletion_service.dart
//
// Suppression définitive de compte (RGPD).
//
// Côté Supabase, la fonction RPC `delete_user_account()` (SECURITY DEFINER)
// supprime :
//   - Toutes les données utilisateur dans les tables publiques (toutes les
//     tables ayant une colonne uid / user_id / user_uid).
//   - La ligne dans auth.users.
//
// Côté client, on :
//   1. Appelle le RPC.
//   2. Nettoie le cache local (SharedPreferences, UserContextService).
//   3. Force un signOut (la session est de toute façon invalide après le DELETE).
//
// IMPORTANT : cette opération est IRRÉVERSIBLE.

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:copiqpolice/core/services/user_context_service.dart';

/// Résultat d'une tentative de suppression de compte.
class AccountDeletionResult {
  final bool success;
  final String? errorCode;
  final String? errorMessage;

  const AccountDeletionResult._({
    required this.success,
    this.errorCode,
    this.errorMessage,
  });

  factory AccountDeletionResult.success() =>
      const AccountDeletionResult._(success: true);

  factory AccountDeletionResult.failure(String code, [String? message]) =>
      AccountDeletionResult._(
        success: false,
        errorCode: code,
        errorMessage: message,
      );
}

class AccountDeletionService {
  AccountDeletionService._();
  static final AccountDeletionService instance = AccountDeletionService._();
  static AccountDeletionService get I => instance;

  SupabaseClient get _sb => Supabase.instance.client;

  /// Supprime définitivement le compte courant.
  ///
  /// Étapes :
  ///   1. RPC `delete_user_account()` côté Supabase (DELETE en cascade).
  ///   2. Nettoyage local (SharedPreferences + UserContextService).
  ///   3. signOut explicite (par sécurité).
  Future<AccountDeletionResult> deleteCurrentAccount() async {
    final user = _sb.auth.currentUser;
    if (user == null) {
      return AccountDeletionResult.failure(
        'not_authenticated',
        'Aucune session active.',
      );
    }

    try {
      await _sb.rpc('delete_user_account');
    } on PostgrestException catch (e) {
      debugPrint('[AccountDeletion] RPC failed: ${e.message}');
      return AccountDeletionResult.failure(
        'rpc_failed',
        e.message,
      );
    } catch (e) {
      debugPrint('[AccountDeletion] Unexpected error: $e');
      return AccountDeletionResult.failure('unexpected', e.toString());
    }

    // Nettoyage local — best-effort.
    try {
      final sp = await SharedPreferences.getInstance();
      await sp.clear();
    } catch (_) {}
    try {
      await UserContextService.I.clear();
    } catch (_) {}

    // signOut explicite : la session devrait déjà être invalide
    // (auth.users.id supprimé), mais on force le reset côté client.
    try {
      await _sb.auth.signOut();
    } catch (_) {}

    return AccountDeletionResult.success();
  }
}
