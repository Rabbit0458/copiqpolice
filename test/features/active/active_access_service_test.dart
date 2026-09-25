import 'package:copiqpolice/features/active/active_access_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ActiveModeConfig', () {
    test('conserve la visibilité publique comme comportement par défaut', () {
      final config = ActiveModeConfig.fromJson({
        'enabled': true,
        'revision': 2,
        'disable_message': 'Maintenance',
        'countdown_seconds': 30,
      });

      expect(config.enabled, isTrue);
      expect(config.available, isTrue);
      expect(config.ownerPreviewActive, isFalse);
    });

    test('autorise la disponibilité privée renvoyée au compte owner', () {
      final config = ActiveModeConfig.fromJson({
        'enabled': false,
        'available': true,
        'owner_preview_active': true,
        'revision': 3,
      });

      expect(config.enabled, isFalse);
      expect(config.available, isTrue);
      expect(config.ownerPreviewActive, isTrue);
    });

    test('reste fermé pour un utilisateur sans droit privé', () {
      final config = ActiveModeConfig.fromJson({
        'enabled': false,
        'available': false,
        'owner_preview_active': false,
      });

      expect(config.available, isFalse);
      expect(config.ownerPreviewActive, isFalse);
    });
  });

  group('ActiveContentNode', () {
    Map<String, dynamic> nodeWith(dynamic imageUrl) => {
      'id': '4eb45d86-1b95-4d95-a244-e424f0d13895',
      'node_type': 'category',
      'title': 'Interventions',
      'sort_order': 0,
      'published_content': <dynamic>[],
      'image_url': imageUrl,
    };

    test('conserve une URL HTTPS exploitable', () {
      final node = ActiveContentNode.fromJson(
        nodeWith(' https://example.com/police.webp '),
      );

      expect(node.imageUrl, 'https://example.com/police.webp');
    });

    test('transforme une URL vide en absence d’image', () {
      final node = ActiveContentNode.fromJson(nodeWith('   '));

      expect(node.imageUrl, isNull);
    });

    test('rejette une valeur qui ne peut pas charger une image distante', () {
      final node = ActiveContentNode.fromJson(nodeWith('image-police'));

      expect(node.imageUrl, isNull);
    });
  });

  group('favoris actifs', () {
    test('le dernier événement de chaque contenu détermine son état', () {
      final ids = activeFavoriteNodeIdsFromEvents([
        {'node_id': 'a', 'event_type': 'favorite_added'},
        {'node_id': 'b', 'event_type': 'favorite_removed'},
        {'node_id': 'a', 'event_type': 'favorite_removed'},
        {'node_id': 'b', 'event_type': 'favorite_added'},
      ]);

      // Les événements arrivent du serveur du plus récent au plus ancien.
      expect(ids, {'a'});
    });

    test('ignore les événements de progression sans écraser le favori', () {
      final ids = activeFavoriteNodeIdsFromEvents([
        {'node_id': 'a', 'event_type': 'opened'},
        {'node_id': 'a', 'event_type': 'favorite_added'},
      ]);

      expect(ids, {'a'});
    });
  });
}
