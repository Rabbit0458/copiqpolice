import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LegalWarningConfig {
  const LegalWarningConfig({
    required this.enabled,
    required this.revision,
    required this.title,
    required this.content,
  });

  final bool enabled;
  final int revision;
  final String title;
  final String content;

  static const fallback = LegalWarningConfig(
    enabled: true,
    revision: 1,
    title: 'Avertissement',
    content:
        'COP’IQ est une application privée de préparation scolaire.\n'
        'Elle n’est ni affiliée ni autorisée par le Gouvernement.\n'
        'Les contenus sont pédagogiques et ne remplacent pas les instructions officielles.',
  );
}

enum AppStartupDestination { warning, onboarding, login, modePicker }

class AppStartupDecision {
  const AppStartupDecision({
    required this.destination,
    required this.warning,
    required this.hasValidSession,
    required this.shouldWelcomeReturningUser,
  });

  final AppStartupDestination destination;
  final LegalWarningConfig warning;
  final bool hasValidSession;
  final bool shouldWelcomeReturningUser;
}

class AppStartupService {
  AppStartupService(this._supabase);

  final SupabaseClient _supabase;

  static const onboardingCompletedKey = 'onboarding_completed_v2';
  static const accountConfiguredKey = 'account_configured_on_device_v1';
  static const warningRevisionKey = 'legal_warning_accepted_revision';
  static const _cachedWarningEnabledKey = 'legal_warning_cached_enabled';
  static const _cachedWarningRevisionKey = 'legal_warning_cached_revision';
  static const _cachedWarningTitleKey = 'legal_warning_cached_title';
  static const _cachedWarningContentKey = 'legal_warning_cached_content';

  Future<AppStartupDecision> resolve() async {
    final prefs = await SharedPreferences.getInstance();
    await _migrateLegacyPreferences(prefs);

    final warning = await _loadWarningConfig(prefs);
    final session = await _validatedSession();
    final hasSession = session != null;
    final wasAlreadyConfigured = prefs.getBool(accountConfiguredKey) ?? false;
    final shouldWelcomeReturningUser = hasSession && wasAlreadyConfigured;
    if (hasSession) {
      await prefs.setBool(accountConfiguredKey, true);
    }

    final acceptedRevision = prefs.getInt(warningRevisionKey) ?? 0;
    if (warning.enabled && acceptedRevision < warning.revision) {
      return AppStartupDecision(
        destination: AppStartupDestination.warning,
        warning: warning,
        hasValidSession: hasSession,
        shouldWelcomeReturningUser: shouldWelcomeReturningUser,
      );
    }

    final onboardingDone = prefs.getBool(onboardingCompletedKey) ?? false;
    final accountConfigured = prefs.getBool(accountConfiguredKey) ?? hasSession;

    final destination = hasSession
        ? AppStartupDestination.modePicker
        : (!onboardingDone && !accountConfigured)
        ? AppStartupDestination.onboarding
        : AppStartupDestination.login;

    return AppStartupDecision(
      destination: destination,
      warning: warning,
      hasValidSession: hasSession,
      shouldWelcomeReturningUser: shouldWelcomeReturningUser,
    );
  }

  Future<void> acceptWarning(int revision) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(warningRevisionKey, revision);
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(onboardingCompletedKey, true);
    await prefs.setBool(accountConfiguredKey, true);
  }

  Future<Session?> _validatedSession() async {
    final current = _supabase.auth.currentSession;
    if (current == null) return null;
    try {
      if (current.isExpired) {
        final refreshed = await _supabase.auth.refreshSession().timeout(
          const Duration(seconds: 6),
        );
        return refreshed.session;
      }
      await _supabase.auth
          .getUser(current.accessToken)
          .timeout(const Duration(seconds: 6));
      return _supabase.auth.currentSession;
    } catch (_) {
      try {
        await _supabase.auth.signOut(scope: SignOutScope.local);
      } catch (_) {}
      return null;
    }
  }

  Future<LegalWarningConfig> _loadWarningConfig(SharedPreferences prefs) async {
    try {
      final data = await _supabase
          .from('app_runtime_config')
          .select(
            'legal_warning_enabled,legal_warning_revision,legal_warning_title,legal_warning_content',
          )
          .eq('id', 1)
          .single()
          .timeout(const Duration(seconds: 5));
      final config = LegalWarningConfig(
        enabled: data['legal_warning_enabled'] as bool? ?? true,
        revision: data['legal_warning_revision'] as int? ?? 1,
        title:
            data['legal_warning_title'] as String? ??
            LegalWarningConfig.fallback.title,
        content:
            data['legal_warning_content'] as String? ??
            LegalWarningConfig.fallback.content,
      );
      await prefs.setBool(_cachedWarningEnabledKey, config.enabled);
      await prefs.setInt(_cachedWarningRevisionKey, config.revision);
      await prefs.setString(_cachedWarningTitleKey, config.title);
      await prefs.setString(_cachedWarningContentKey, config.content);
      return config;
    } catch (_) {
      return LegalWarningConfig(
        enabled: prefs.getBool(_cachedWarningEnabledKey) ?? true,
        revision: prefs.getInt(_cachedWarningRevisionKey) ?? 1,
        title:
            prefs.getString(_cachedWarningTitleKey) ??
            LegalWarningConfig.fallback.title,
        content:
            prefs.getString(_cachedWarningContentKey) ??
            LegalWarningConfig.fallback.content,
      );
    }
  }

  Future<void> _migrateLegacyPreferences(SharedPreferences prefs) async {
    // Les anciennes versions de production effaçaient `onboarding_done` à
    // chaque lancement. Les préférences ci-dessous ne sont créées qu'après
    // un véritable passage dans l'onboarding ou l'application et permettent de
    // reconnaître honnêtement une installation existante déconnectée.
    final legacyConfiguredInstall =
        prefs.containsKey('onboarding_theme_dark') ||
        prefs.containsKey('onboarding_done_local') ||
        prefs.containsKey('selected_user_mode') ||
        prefs.containsKey('user_mode');
    if (((prefs.getBool('onboarding_done') ?? false) ||
            legacyConfiguredInstall) &&
        !prefs.containsKey(onboardingCompletedKey)) {
      await prefs.setBool(onboardingCompletedKey, true);
      await prefs.setBool(accountConfiguredKey, true);
    }
    if ((prefs.getBool('warning_ack') ?? false) &&
        !prefs.containsKey(warningRevisionKey)) {
      await prefs.setInt(warningRevisionKey, 1);
    }
  }
}
