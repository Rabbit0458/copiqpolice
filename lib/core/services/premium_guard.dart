// lib/core/services/premium_guard.dart
// =============================================================================
//  COP'IQ — Premium Guard
//  Logique centralisée d'accès au contenu premium.
//  Utilisation :
//    if (!canAccessPremiumContent(SubscriptionService.instance.state.value)) {
//      Navigator.of(context).pushNamed(PremiumRequiredPage.routeName);
//      return;
//    }
// =============================================================================

import 'package:copiqpolice/core/services/subscription_service.dart';

/// Retourne true si l'utilisateur peut accéder au contenu premium.
bool canAccessPremiumContent(SubscriptionState state) {
  return state.isPremium;
}

