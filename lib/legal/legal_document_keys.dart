// lib/legal/legal_document_keys.dart
//
// Clés de documents = valeurs de public.information_contents.content_type
// pour la famille "documents légaux". Les valeurs `terms`, `sales_terms`,
// `cookies`, `community_rules`, `legal_notice` et `privacy` existent déjà en
// base (CMS web) — on les réutilise telles quelles, sans renommage, pour ne
// pas diverger du panneau d'administration existant.

abstract final class LegalDocumentKeys {
  static const privacyPolicy = 'privacy';
  static const termsOfUse = 'terms';
  static const termsOfSale = 'sales_terms';
  static const legalNotice = 'legal_notice';
  static const communityGuidelines = 'community_rules';
  static const cookiesPolicy = 'cookies';
}
