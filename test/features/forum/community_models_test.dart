import 'package:copiqpolice/features/forum/community_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('les dates communautaires ne dépendent pas des données intl', () {
    final date = DateTime(2026, 8, 2, 0, 35);
    expect(communityTime(date), '00:35');
    expect(communityShortDateTime(date), '02/08 · 00:35');
    expect(communityFullDateTime(date), '02/08/2026 · 00:35');
    expect(communityMonthYear(date), 'août 2026');
  });

  test('les cinq portées ont un identifiant stable et unique', () {
    final ids = CommunityScope.values.map((scope) => scope.id).toSet();
    expect(ids, hasLength(5));
    expect(
      ids,
      containsAll(['global', 'pa_exam', 'gpx_exam', 'pa_school', 'gpx_school']),
    );
  });

  test('une portée inconnue revient au fil global', () {
    expect(CommunityScopeX.fromId('inconnu'), CommunityScope.global);
  });

  test('le parsing d’une publication conserve sa portée', () {
    final post = CommunityPost.fromJson({
      'id': 'post',
      'author_id': 'user',
      'space_id': 'pa_exam',
      'category_id': 'category',
      'title': 'Une question détaillée',
      'content': 'Un contenu suffisamment détaillé pour le forum.',
      'created_at': '2026-08-01T10:00:00Z',
      'reaction_count': 2,
      'comment_count': 1,
      'community_categories': {'label': 'Entretien'},
      'community_reactions': [
        {'user_id': 'user', 'kind': 'like'},
      ],
      'community_bookmarks': <Map<String, dynamic>>[],
    }, 'user');
    expect(post.scope, CommunityScope.paExam);
    expect(post.liked, isTrue);
    expect(post.categoryLabel, 'Entretien');
  });

  test('le profil public ignore les données privées absentes du modèle', () {
    final profile = CommunityPublicProfile.fromJson({
      'user_id': 'user',
      'username': 'Kais',
      'display_name': 'Kaïs Ouartani',
      'avatar_index': 2,
      'badge_type': 'active',
      'bio': 'Préparation PA',
      'primary_space': 'pa_exam',
      'post_count': 4,
      'comment_count': 8,
      'solutions_count': 1,
      'email': 'ne-doit-pas-etre-modele@example.test',
    });
    expect(profile.username, 'Kais');
    expect(profile.displayName, 'Kaïs Ouartani');
    expect(profile.primaryScope, CommunityScope.paExam);
    expect(profile.avatarIndex, 2);
    expect(profile.badgeType, 'active');
    expect(profile.solutionsCount, 1);
  });

  test('une notification conserve sa cible de navigation', () {
    final notification = CommunityNotification.fromJson({
      'id': 'notification',
      'type': 'post_reply',
      'space_id': 'gpx_exam',
      'target_type': 'post',
      'target_id': 'post-id',
      'payload': {'comment_id': 'comment-id'},
      'created_at': '2026-08-01T12:00:00Z',
      'read_at': null,
    });
    expect(notification.scope, CommunityScope.gpxExam);
    expect(notification.targetId, 'post-id');
    expect(notification.commentId, 'comment-id');
    expect(notification.readAt, isNull);
  });

  test('une réponse conserve le commentaire auquel elle répond', () {
    final reply = CommunityComment.fromJson({
      'id': 'reply-id',
      'author_id': 'user-id',
      'parent_id': 'parent-id',
      'reply_count': 12,
      'reaction_count': 3,
      'is_solution': true,
      'status': 'published',
      'edited_at': '2026-08-02T03:46:00Z',
      'community_reactions': [
        {'user_id': 'user-id', 'kind': 'like'},
      ],
      'content': 'Une réponse ciblée',
      'created_at': '2026-08-02T03:45:00Z',
    }, 'user-id');
    expect(reply.parentId, 'parent-id');
    expect(reply.replyCount, 12);
    expect(reply.reactionCount, 3);
    expect(reply.liked, isTrue);
    expect(reply.isSolution, isTrue);
    expect(reply.editedAt, isNotNull);
  });
}
