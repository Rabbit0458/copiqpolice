/// Plans Premium COP'IQ vendus par l'App Store et Google Play.
///
/// Les identifiants ci-dessous doivent rester identiques dans les boutiques,
/// RevenueCat et l'application. Les tarifs France de référence sont signalés
/// comme tels sur iOS si la boutique renvoie une autre devise.
enum CopiqPlan { month, year }

extension CopiqPlanX on CopiqPlan {
  String get id => switch (this) {
    CopiqPlan.month => 'month',
    CopiqPlan.year => 'year',
  };

  String get revenueCatPackageId => switch (this) {
    CopiqPlan.month => r'$rc_monthly',
    CopiqPlan.year => r'$rc_annual',
  };

  String get androidProductId => switch (this) {
    CopiqPlan.month => 'copiq_premium_monthly',
    CopiqPlan.year => 'copiq_premium_yearly',
  };

  String get iosProductId => switch (this) {
    CopiqPlan.month => 'fr.copiq.premium.monthly',
    CopiqPlan.year => 'fr.copiq.premium.yearly',
  };

  String get title => switch (this) {
    CopiqPlan.month => 'Mensuel',
    CopiqPlan.year => 'Annuel',
  };

  String get fallbackPriceLabel => switch (this) {
    CopiqPlan.month => '8,99 € / mois',
    CopiqPlan.year => '79,99 € / an',
  };

  // France reference prices checked in App Store Connect on 2026-10-16.
  // Keep these in sync when changing French App Store prices.
  String displayPrice({
    required String? storePrice,
    required String? currencyCode,
    required bool isIOS,
  }) {
    if (storePrice == null || storePrice.trim().isEmpty) {
      return 'Prix indisponible';
    }
    if (isIOS && currencyCode != 'EUR') return fallbackPriceLabel;
    final period = this == CopiqPlan.month ? 'mois' : 'an';
    return '$storePrice / $period';
  }

  String get subtitle => switch (this) {
    CopiqPlan.month => 'Renouvellement automatique chaque mois',
    CopiqPlan.year => 'Renouvellement automatique chaque année',
  };

  String get badge => switch (this) {
    CopiqPlan.month => 'Flexible',
    CopiqPlan.year => 'Meilleur choix',
  };

  String get valueLine => switch (this) {
    CopiqPlan.month => 'La liberté de résilier à tout moment',
    CopiqPlan.year => 'Un accès Premium pour douze mois',
  };

  List<String> get details => switch (this) {
    CopiqPlan.month => const [
      'Tous les parcours concours et scolarité',
      'Quiz et entraînements sans limite',
      'Mises à jour pédagogiques incluses',
    ],
    CopiqPlan.year => const [
      'Tous les avantages Premium pendant 12 mois',
      'Renouvellement annuel, annulable à tout moment',
      'Mises à jour pédagogiques incluses',
    ],
  };

  bool get highlighted => this == CopiqPlan.year;
}
