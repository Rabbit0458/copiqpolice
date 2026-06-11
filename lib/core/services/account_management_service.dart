// lib/core/services/account_management_service.dart
//
// Service unifié pour la gestion du compte utilisateur :
//   - Changement d'email (Supabase Auth)
//   - Changement de mot de passe (Supabase Auth)
//   - Export RGPD des données utilisateur (toutes les tables)
//   - Switch de track / mode (avec mise à jour user_profiles + cache)
//
// Pour la suppression de compte, voir AccountDeletionService.

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:copiqpolice/core/services/user_context_service.dart';

class AccountActionResult {
  final bool success;
  final String? errorCode;
  final String? errorMessage;
  final Map<String, dynamic>? data;

  const AccountActionResult._({
    required this.success,
    this.errorCode,
    this.errorMessage,
    this.data,
  });

  factory AccountActionResult.success([Map<String, dynamic>? data]) =>
      AccountActionResult._(success: true, data: data);

  factory AccountActionResult.failure(String code, [String? message]) =>
      AccountActionResult._(
        success: false,
        errorCode: code,
        errorMessage: message,
      );
}

class AccountManagementService {
  AccountManagementService._();
  static final AccountManagementService instance = AccountManagementService._();
  static AccountManagementService get I => instance;

  SupabaseClient get _sb => Supabase.instance.client;

  // ---------------------------------------------------------------------------
  // Email
  // ---------------------------------------------------------------------------

  /// Change l'email Supabase. Envoie un email de confirmation à la nouvelle
  /// adresse — le changement n'est effectif qu'après confirmation.
  Future<AccountActionResult> changeEmail(String newEmail) async {
    final user = _sb.auth.currentUser;
    if (user == null) {
      return AccountActionResult.failure('not_authenticated');
    }
    if (!_isValidEmail(newEmail)) {
      return AccountActionResult.failure('invalid_email');
    }
    try {
      await _sb.auth.updateUser(UserAttributes(email: newEmail));
      // user_profiles.email reste l'ancien tant que la confirmation n'a pas
      // eu lieu. Un trigger côté DB peut le synchroniser automatiquement.
      return AccountActionResult.success({
        'pending_confirmation': true,
        'new_email': newEmail,
      });
    } on AuthException catch (e) {
      return AccountActionResult.failure(
        'auth_error',
        e.message,
      );
    } catch (e) {
      return AccountActionResult.failure('unexpected', e.toString());
    }
  }

  // ---------------------------------------------------------------------------
  // Password
  // ---------------------------------------------------------------------------

  /// Change le mot de passe. Doit faire au moins 8 caractères.
  Future<AccountActionResult> changePassword(String newPassword) async {
    final user = _sb.auth.currentUser;
    if (user == null) {
      return AccountActionResult.failure('not_authenticated');
    }
    if (newPassword.length < 8) {
      return AccountActionResult.failure(
        'weak_password',
        'Le mot de passe doit faire au moins 8 caractères.',
      );
    }
    try {
      await _sb.auth.updateUser(UserAttributes(password: newPassword));
      return AccountActionResult.success();
    } on AuthException catch (e) {
      return AccountActionResult.failure('auth_error', e.message);
    } catch (e) {
      return AccountActionResult.failure('unexpected', e.toString());
    }
  }

  // ---------------------------------------------------------------------------
  // Track / Mode
  // ---------------------------------------------------------------------------

  /// Change le track utilisateur (gpx / pa / reserve).
  Future<AccountActionResult> changeTrack(String newTrack) async {
    if (!UserTracks.isValid(newTrack)) {
      return AccountActionResult.failure('invalid_track');
    }
    final user = _sb.auth.currentUser;
    if (user == null) {
      return AccountActionResult.failure('not_authenticated');
    }
    try {
      await _sb.from('user_profiles').upsert({
        'user_id': user.id,
        'user_track': newTrack,
        'updated_at': DateTime.now().toIso8601String(),
      }, onConflict: 'user_id');
      await UserContextService.I.setTrack(newTrack);
      await UserContextService.I.refresh();
      return AccountActionResult.success({'track': newTrack});
    } catch (e) {
      return AccountActionResult.failure('upsert_failed', e.toString());
    }
  }

  /// Change le mode utilisateur (school / exam).
  Future<AccountActionResult> changeMode(String newMode) async {
    if (!UserModes.isValid(newMode)) {
      return AccountActionResult.failure('invalid_mode');
    }
    final user = _sb.auth.currentUser;
    if (user == null) {
      return AccountActionResult.failure('not_authenticated');
    }
    try {
      await _sb.from('user_profiles').upsert({
        'user_id': user.id,
        'user_mode': newMode,
        'updated_at': DateTime.now().toIso8601String(),
      }, onConflict: 'user_id');
      await UserContextService.I.setMode(newMode);
      await UserContextService.I.refresh();
      return AccountActionResult.success({'mode': newMode});
    } catch (e) {
      return AccountActionResult.failure('upsert_failed', e.toString());
    }
  }

  // ---------------------------------------------------------------------------
  // Export RGPD
  // ---------------------------------------------------------------------------

  /// Rassemble toutes les données utilisateur du compte et retourne un JSON
  /// que l'app peut afficher / partager / sauvegarder.
  ///
  /// Le RPC `export_user_data()` côté Supabase fait l'agrégation
  /// (cf. migration export_user_data_rpc).
  Future<AccountActionResult> exportData() async {
    final user = _sb.auth.currentUser;
    if (user == null) {
      return AccountActionResult.failure('not_authenticated');
    }
    try {
      final data = await _sb.rpc('export_user_data');
      // data peut être Map ou null
      if (data == null) {
        return AccountActionResult.failure('empty_export');
      }
      const encoded = JsonEncoder.withIndent('  ').convert(data);
      return AccountActionResult.success({
        'json': encoded,
        'raw': data,
        'bytes': encoded.codeUnits.length,
      });
    } catch (e) {
      debugPrint('[AccountManagement] exportData failed: $e');
      return AccountActionResult.failure('rpc_failed', e.toString());
    }
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  bool _isValidEmail(String s) {
    final r = RegExp(r'^[\w\.\-\+]+@[\w\-]+\.[\w\-\.]+$');
    return r.hasMatch(s.trim());
  }
}
