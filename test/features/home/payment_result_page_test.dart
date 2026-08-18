import 'package:copiqpolice/features/home/payment_result_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PaymentResultPage.fromUri', () {
    test('reconnait un succès via le lien interne et conserve la session', () {
      final uri = Uri.parse(
        'copiqpolice://paywall/success?session_id=cs_test_123',
      );

      expect(PaymentResultPage.supportsUri(uri), isTrue);
      final page = PaymentResultPage.fromUri(uri);
      expect(page.status, PaymentResultStatus.success);
      expect(page.sessionId, 'cs_test_123');
    });

    test('reconnait une annulation provenant du domaine officiel', () {
      final uri = Uri.parse('https://app.copiq.fr/payment-cancel');

      expect(PaymentResultPage.supportsUri(uri), isTrue);
      expect(PaymentResultPage.fromUri(uri).status, PaymentResultStatus.cancel);
    });

    test('convertit les codes Stripe en états détaillés', () {
      const cases = <String, PaymentResultStatus>{
        'card_declined': PaymentResultStatus.declined,
        'insufficient_funds': PaymentResultStatus.insufficientFunds,
        'incorrect_cvc': PaymentResultStatus.incorrectCvc,
        'expired_card': PaymentResultStatus.expiredCard,
        'authentication_required': PaymentResultStatus.authenticationRequired,
        'network_error': PaymentResultStatus.networkError,
      };

      for (final entry in cases.entries) {
        final page = PaymentResultPage.fromUri(
          Uri.parse('/payment-failure?code=${entry.key}'),
        );
        expect(page.status, entry.value, reason: entry.key);
      }
    });

    test('refuse un domaine externe qui imite une page de paiement', () {
      final uri = Uri.parse('https://example.com/payment-success');

      expect(PaymentResultPage.supportsUri(uri), isFalse);
    });

    test('accepte le retour web officiel et conserve la session Stripe', () {
      final uri = Uri.parse(
        'https://app.copiq.fr/paywall/success?session_id=cs_test_web',
      );

      final page = PaymentResultPage.fromUri(uri);

      expect(PaymentResultPage.supportsUri(uri), isTrue);
      expect(page.status, PaymentResultStatus.success);
      expect(page.sessionId, 'cs_test_web');
    });

    test('reste compatible avec l’ancienne route relative de succès', () {
      final uri = Uri.parse('/success?session_id=cs_test_legacy');

      final page = PaymentResultPage.fromUri(uri);

      expect(PaymentResultPage.supportsUri(uri), isTrue);
      expect(page.status, PaymentResultStatus.success);
      expect(page.sessionId, 'cs_test_legacy');
    });

    test('reconnaît une annulation via le lien profond natif', () {
      final uri = Uri.parse('copiqpolice://paywall/cancel');

      expect(PaymentResultPage.fromUri(uri).status, PaymentResultStatus.cancel);
    });

    test('utilise l’échec générique si aucun code précis n’est fourni', () {
      final uri = Uri.parse('/payment/failed');

      expect(PaymentResultPage.fromUri(uri).status, PaymentResultStatus.failed);
    });
  });
}
