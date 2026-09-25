/// Plans Premium COP'IQ vendus par l'App Store et Google Play.
///
/// Les identifiants ci-dessous doivent rester identiques dans les boutiques,
/// RevenueCat et l'application. Les prix affichés par défaut ne servent que
/// pendant le chargement : le prix final vient toujours de la boutique.
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

  String get subtitle => switch (this) {
    CopiqPlan.month => 'Renouvellement automatique chaque mois',
    CopiqPlan.year => '26 % d’économie • Renouvellement annuel',
  };

  String get badge => switch (this) {
    CopiqPlan.month => 'Flexible',
    CopiqPlan.year => 'Meilleur choix',
  };

  String get valueLine => switch (this) {
    CopiqPlan.month => 'La liberté de résilier à tout moment',
    CopiqPlan.year => 'Économise 27,89 € sur douze mois',
  };

  List<String> get details => switch (this) {
    CopiqPlan.month => const [
      'Tous les parcours concours et scolarité',
      'Quiz et entraînements sans limite',
      'Mises à jour pédagogiques incluses',
    ],
    CopiqPlan.year => const [
      'Tous les avantages Premium pendant 12 mois',
      'Le tarif le plus avantageux de COP’IQ',
      'Mises à jour pédagogiques incluses',
    ],
  };

  bool get highlighted => this == CopiqPlan.year;
}
