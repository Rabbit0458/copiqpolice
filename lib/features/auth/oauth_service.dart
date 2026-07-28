// ╔══════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Connexion via fournisseur externe (Apple, Google)              ║
// ║                                                                          ║
// ║  POURQUOI                                                                ║
// ║  ────────                                                                ║
// ║  Apple impose « Sign in with Apple » dès lors qu'une application propose ║
// ║  une autre connexion tierce ou par e-mail. Son absence est un motif de   ║
// ║  rejet systématique sur l'App Store (règle 4.8 des App Review            ║
// ║  Guidelines).                                                            ║
// ║                                                                          ║
// ║  IMPLÉMENTATION                                                          ║
// ║  ──────────────                                                          ║
// ║  On s'appuie sur `signInWithOAuth` de `supabase_flutter`, déjà présent    ║
// ║  dans le projet : AUCUN paquet supplémentaire n'est ajouté, donc aucun   ║
// ║  risque de casser le build.                                              ║
// ║                                                                          ║
// ║  Le retour se fait sur `copiqpolice://login-callback`, déclaré depuis le ║
// ║  2026-07-26 dans AndroidManifest.xml et Info.plist.                       ║
// ║                                                                          ║
// ║  ⚠️ ACTIVATION — à faire une seule fois côté Supabase                     ║
// ║  Voir `docs/AUTH_OAUTH_SETUP.md`. Tant que le fournisseur n'est pas      ║
// ║  activé dans le tableau de bord Supabase, `isEnabled` renvoie false et   ║
// ║  les boutons ne sont pas affichés : l'écran de connexion actuel reste    ║
// ║  strictement inchangé.                                                    ║
// ╚══════════════════════════════════════════════════════════════════════════╝

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Fournisseurs pris en charge.
enum AuthProviderKind { apple, google }

/// Résultat d'une tentative de connexion externe.
class OAuthResult {
  final bool started;
  final String? errorMessage;

  const OAuthResult._(this.started, this.errorMessage);

  factory OAuthResult.ok() => const OAuthResult._(true, null);
  factory OAuthResult.error(String m) => OAuthResult._(false, m);
}

class OAuthService {
  OAuthService._();
  static final OAuthService I = OAuthService._();

  /// URL de retour après authentification chez le fournisseur.
  /// Doit correspondre à une « Redirect URL » autorisée dans Supabase.
  static const String kRedirectTo = 'copiqpolice://login-callback';

  /// Drapeaux d'activation, pilotés au build :
  /// `flutter run --dart-define=ENABLE_APPLE_SIGNIN=true`
  ///
  /// Ils évitent d'afficher un bouton qui échouerait tant que le fournisseur
  /// n'est pas configuré dans Supabase.
  static const bool _appleEnabled =
      bool.fromEnvironment('ENABLE_APPLE_SIGNIN', defaultValue: false);
  static const bool _googleEnabled =
      bool.fromEnvironment('ENABLE_GOOGLE_SIGNIN', defaultValue: false);

  /// Le fournisseur doit-il être proposé sur cette plateforme ?
  bool isEnabled(AuthProviderKind kind) {
    switch (kind) {
      case AuthProviderKind.apple:
        if (!_appleEnabled) return false;
        // Apple n'a de sens que sur les plateformes Apple et sur le web.
        return kIsWeb ||
            defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.macOS;
      case AuthProviderKind.google:
        return _googleEnabled;
    }
  }

  /// Au moins un fournisseur externe est-il disponible ?
  bool get hasAnyProvider =>
      isEnabled(AuthProviderKind.apple) || isEnabled(AuthProviderKind.google);

  String label(AuthProviderKind kind) => switch (kind) {
    AuthProviderKind.apple => 'Continuer avec Apple',
    AuthProviderKind.google => 'Continuer avec Google',
  };

  OAuthProvider _toSupabase(AuthProviderKind kind) => switch (kind) {
    AuthProviderKind.apple => OAuthProvider.apple,
    AuthProviderKind.google => OAuthProvider.google,
  };

  /// Lance le parcours de connexion.
  ///
  /// La méthode retourne dès l'ouverture du navigateur : la session est
  /// établie plus tard, via le deep link de retour. Il faut donc écouter
  /// `onAuthStateChange` pour savoir quand l'utilisateur est connecté.
  Future<OAuthResult> signIn(AuthProviderKind kind) async {
    if (!isEnabled(kind)) {
      return OAuthResult.error(
        'Cette méthode de connexion n’est pas disponible pour le moment.',
      );
    }
    try {
      // On laisse `supabase_flutter` choisir le mode d'ouverture par defaut :
      // il selectionne l'onglet personnalise sur Android et SFSafariViewController
      // sur iOS, ce qui est le comportement recommande par Apple et Google.
      await Supabase.instance.client.auth.signInWithOAuth(
        _toSupabase(kind),
        redirectTo: kIsWeb ? null : kRedirectTo,
      );
      return OAuthResult.ok();
    } on AuthException catch (e) {
      return OAuthResult.error(_humanize(e.message));
    } catch (e) {
      debugPrint('OAuthService: echec $kind — $e');
      return OAuthResult.error(
        'Connexion impossible. Vérifie ta connexion internet et réessaie.',
      );
    }
  }

  /// Traduit les messages techniques de Supabase en français lisible.
  String _humanize(String raw) {
    final m = raw.toLowerCase();
    if (m.contains('provider') && m.contains('not enabled')) {
      return 'Cette méthode de connexion n’est pas encore activée.';
    }
    if (m.contains('redirect')) {
      return 'Configuration de retour invalide. Contacte le support.';
    }
    if (m.contains('cancel')) {
      return 'Connexion annulée.';
    }
    return 'Connexion impossible : $raw';
  }
}
