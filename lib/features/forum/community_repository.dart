import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'community_models.dart';

class CommunityRepository {
  CommunityRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;
  final SupabaseClient _client;
  String? get userId => _client.auth.currentUser?.id;

  Future<CommunityScope?> activeScope() async {
    final uid = userId;
    if (uid == null) return null;
    final row = await _client
        .from('user_profiles')
        .select('user_mode,user_track')
        .eq('user_id', uid)
        .single();
    final mode = row['user_mode'] as String?;
    final track = row['user_track'] as String?;
    return switch ((mode, track)) {
      ('exam', 'pa') => CommunityScope.paExam,
      ('exam', 'gpx') => CommunityScope.gpxExam,
      ('school', 'pa') => CommunityScope.paSchool,
      ('school', 'gpx') => CommunityScope.gpxSchool,
      _ => null,
    };
  }

  Future<Map<String, CommunityPublicIdentity>> _publicIdentities(
    Iterable<String> userIds,
  ) async {
    final ids = userIds.toSet().toList(growable: false);
    if (ids.isEmpty) return const {};
    try {
      final rows = await _client.rpc(
        'community_public_identities',
        params: {'p_user_ids': ids},
      );
      return {
        for (final row in (rows as List).cast<Map<String, dynamic>>())
          row['user_id'] as String: CommunityPublicIdentity.fromJson(row),
      };
    } catch (_) {
      // L'identité enrichie est décorative : le contenu reste disponible.
      return const {};
    }
  }

  Future<List<CommunityPost>> _enrichPosts(List<CommunityPost> posts) async {
    final identities = await _publicIdentities(posts.map((p) => p.authorId));
    return posts
        .map((post) {
          final identity = identities[post.authorId];
          return identity == null
              ? post
              : post.copyWith(
                  authorUsername: identity.username,
                  authorDisplayName: identity.displayName,
                  authorAvatarIndex: identity.avatarIndex,
                  authorBadgeType: identity.badgeType,
                );
        })
        .toList(growable: false);
  }

  Future<List<CommunityCategory>> categories(CommunityScope scope) async {
    final rows = await _client
        .from('community_categories')
        .select()
        .eq('space_id', scope.id)
        .eq('posting_role', 'user')
        .eq('is_active', true)
        .order('sort_order');
    return (rows as List)
        .cast<Map<String, dynamic>>()
        .map(CommunityCategory.fromJson)
        .toList();
  }

  Future<List<CommunityPost>> posts({
    required CommunityScope scope,
    DateTime? before,
    int limit = 20,
  }) async {
    var query = _client
        .from('community_posts')
        .select('''
      id,author_id,space_id,category_id,title,content,created_at,reaction_count,comment_count,is_pinned,is_resolved,
      community_categories(label),community_reactions(user_id,kind),community_bookmarks(user_id)
    ''')
        .inFilter('status', ['published', 'locked']);
    if (scope != CommunityScope.global) query = query.eq('space_id', scope.id);
    if (before != null)
      query = query.lt('created_at', before.toUtc().toIso8601String());
    final rows = await query
        .order('is_pinned', ascending: false)
        .order('created_at', ascending: false)
        .limit(limit);
    final posts = (rows as List)
        .cast<Map<String, dynamic>>()
        .map((e) => CommunityPost.fromJson(e, userId))
        .toList();
    return _enrichPosts(posts);
  }

  Future<List<CommunityPost>> bookmarkedPosts({int limit = 50}) async {
    final uid = userId;
    if (uid == null) throw const AuthException('Connexion requise');
    final bookmarkRows = await _client
        .from('community_bookmarks')
        .select('post_id')
        .eq('user_id', uid)
        .order('created_at', ascending: false)
        .limit(limit);
    final ids = (bookmarkRows as List)
        .cast<Map<String, dynamic>>()
        .map((row) => row['post_id'] as String)
        .toList(growable: false);
    if (ids.isEmpty) return const [];
    final rows = await _client
        .from('community_posts')
        .select(
          '''id,author_id,space_id,category_id,title,content,created_at,reaction_count,comment_count,is_pinned,is_resolved,community_categories(label),community_reactions(user_id,kind),community_bookmarks(user_id)''',
        )
        .inFilter('id', ids)
        .inFilter('status', ['published', 'locked']);
    final byId = {
      for (final row in (rows as List).cast<Map<String, dynamic>>())
        row['id'] as String: CommunityPost.fromJson(row, uid),
    };
    return _enrichPosts([
      for (final id in ids)
        if (byId[id] != null) byId[id]!,
    ]);
  }

  Future<CommunityPost> post(String id) async {
    final row = await _client
        .from('community_posts')
        .select(
          '''id,author_id,space_id,category_id,title,content,created_at,reaction_count,comment_count,is_pinned,is_resolved,community_categories(label),community_reactions(user_id,kind),community_bookmarks(user_id)''',
        )
        .eq('id', id)
        .single();
    return (await _enrichPosts([CommunityPost.fromJson(row, userId)])).single;
  }

  Future<String> createPost({
    required CommunityScope scope,
    required String categoryId,
    required String title,
    required String content,
  }) async {
    final uid = userId;
    if (uid == null) throw const AuthException('Connexion requise');
    final postId = const Uuid().v4();
    await _client.from('community_posts').insert({
      // Générer l'identifiant côté client évite une seconde lecture RLS après
      // l'insertion. L'opération reste idempotente grâce à client_id.
      'id': postId,
      'client_id': postId,
      'author_id': uid,
      'space_id': scope.id,
      'category_id': categoryId,
      'title': title.trim(),
      'content': content.trim(),
      'type': 'discussion',
    });
    return postId;
  }

  Future<void> toggleLike(CommunityPost post) async {
    final uid = userId;
    if (uid == null) throw const AuthException('Connexion requise');
    if (post.liked) {
      await _client
          .from('community_reactions')
          .delete()
          .eq('user_id', uid)
          .eq('post_id', post.id)
          .eq('kind', 'like');
    } else {
      await _client.from('community_reactions').insert({
        'user_id': uid,
        'post_id': post.id,
        'kind': 'like',
      });
    }
  }

  Future<List<CommunityPublicIdentity>> postLikers(String postId) async {
    final rows = await _client
        .from('community_reactions')
        .select('user_id,created_at')
        .eq('post_id', postId)
        .eq('kind', 'like')
        .order('created_at', ascending: false)
        .limit(100);
    final ids = (rows as List)
        .cast<Map<String, dynamic>>()
        .map((row) => row['user_id'] as String)
        .toList(growable: false);
    final identities = await _publicIdentities(ids);
    return [
      for (final id in ids)
        if (identities[id] != null) identities[id]!,
    ];
  }

  Future<void> toggleBookmark(CommunityPost post) async {
    final uid = userId;
    if (uid == null) throw const AuthException('Connexion requise');
    if (post.bookmarked) {
      await _client
          .from('community_bookmarks')
          .delete()
          .eq('user_id', uid)
          .eq('post_id', post.id);
    } else {
      await _client.from('community_bookmarks').insert({
        'user_id': uid,
        'post_id': post.id,
      });
    }
  }

  Future<void> removeBookmark(String postId) async {
    final uid = userId;
    if (uid == null) throw const AuthException('Connexion requise');
    await _client
        .from('community_bookmarks')
        .delete()
        .eq('user_id', uid)
        .eq('post_id', postId);
  }

  Future<List<CommunityComment>> comments(
    String postId, {
    String? parentId,
    int offset = 0,
    int limit = 20,
    String sort = 'relevant',
    bool solutionsOnly = false,
  }) async {
    var query = _client
        .from('community_comments')
        .select(
          'id,author_id,parent_id,content,created_at,edited_at,reply_count,reaction_count,is_solution,status,community_reactions(user_id,kind)',
        )
        .eq('post_id', postId)
        .inFilter('status', [
          'published',
          'pending_review',
          'hidden',
          'removed_by_moderator',
          'deleted_by_author',
        ]);
    query = parentId == null
        ? query.isFilter('parent_id', null)
        : query.eq('parent_id', parentId);
    if (solutionsOnly) query = query.eq('is_solution', true);
    final ordered = switch (sort) {
      'oldest' => query.order('created_at', ascending: true),
      'recent' => query.order('created_at', ascending: false),
      _ =>
        query
            .order('is_solution', ascending: false)
            .order('reaction_count', ascending: false)
            .order('created_at', ascending: false),
    };
    final rows = await ordered.range(offset, offset + limit - 1);
    final comments = (rows as List)
        .cast<Map<String, dynamic>>()
        .map((json) => CommunityComment.fromJson(json, userId))
        .toList();
    final identities = await _publicIdentities(
      comments.map((comment) => comment.authorId),
    );
    return comments
        .map(
          (comment) => identities[comment.authorId] == null
              ? comment
              : comment.copyWithAuthor(identities[comment.authorId]!),
        )
        .toList(growable: false);
  }

  Future<CommunityComment> comment(String id) async {
    final row = await _client
        .from('community_comments')
        .select(
          'id,author_id,parent_id,content,created_at,edited_at,reply_count,reaction_count,is_solution,status,community_reactions(user_id,kind)',
        )
        .eq('id', id)
        .single();
    final value = CommunityComment.fromJson(row, userId);
    final identities = await _publicIdentities([value.authorId]);
    return identities[value.authorId] == null
        ? value
        : value.copyWithAuthor(identities[value.authorId]!);
  }

  Future<int> commentCount(String postId, {bool topLevelOnly = false}) async {
    var query = _client
        .from('community_comments')
        .count(CountOption.exact)
        .eq('post_id', postId)
        .eq('status', 'published');
    if (topLevelOnly) query = query.isFilter('parent_id', null);
    return query;
  }

  Future<void> addComment(
    String postId,
    String content, {
    String? parentId,
  }) async {
    final uid = userId;
    if (uid == null) throw const AuthException('Connexion requise');
    await _client.from('community_comments').insert({
      'client_id': const Uuid().v4(),
      'post_id': postId,
      'author_id': uid,
      'content': content.trim(),
      if (parentId != null) 'parent_id': parentId,
    });
  }

  Future<void> toggleCommentLike(CommunityComment comment) async {
    final uid = userId;
    if (uid == null) throw const AuthException('Connexion requise');
    if (comment.liked) {
      await _client
          .from('community_reactions')
          .delete()
          .eq('user_id', uid)
          .eq('comment_id', comment.id)
          .eq('kind', 'like');
    } else {
      await _client.from('community_reactions').insert({
        'user_id': uid,
        'comment_id': comment.id,
        'kind': 'like',
      });
    }
  }

  Future<List<CommunityPublicIdentity>> commentLikers(String commentId) async {
    final rows = await _client
        .from('community_reactions')
        .select('user_id,created_at')
        .eq('comment_id', commentId)
        .eq('kind', 'like')
        .order('created_at', ascending: false)
        .limit(100);
    final ids = (rows as List)
        .cast<Map<String, dynamic>>()
        .map((row) => row['user_id'] as String)
        .toList(growable: false);
    final identities = await _publicIdentities(ids);
    return [
      for (final id in ids)
        if (identities[id] != null) identities[id]!,
    ];
  }

  Future<void> updateOwnComment(String id, String content) async {
    final uid = userId;
    if (uid == null) throw const AuthException('Connexion requise');
    await _client
        .from('community_comments')
        .update({
          'content': content.trim(),
          'edited_at': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('id', id)
        .eq('author_id', uid);
  }

  Future<void> deleteOwnComment(String id) async {
    final uid = userId;
    if (uid == null) throw const AuthException('Connexion requise');
    await _client
        .from('community_comments')
        .update({
          'content': '[supprimé]',
          'status': 'deleted_by_author',
          'deleted_at': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('id', id)
        .eq('author_id', uid);
  }

  Future<void> reportComment(
    CommunityPost post,
    String commentId,
    String reason,
  ) async {
    final uid = userId;
    if (uid == null) throw const AuthException('Connexion requise');
    await _client.from('community_reports').insert({
      'reporter_id': uid,
      'space_id': post.scope.id,
      'target_type': 'comment',
      'target_id': commentId,
      'reason': reason,
    });
  }

  Future<void> blockUser(String blockedUserId) async {
    final uid = userId;
    if (uid == null) throw const AuthException('Connexion requise');
    if (uid == blockedUserId) throw const AuthException('Action impossible');
    await _client.from('community_blocks').upsert({
      'blocker_id': uid,
      'blocked_id': blockedUserId,
    });
  }

  Future<void> setSolution(String postId, String commentId) async {
    if (userId == null) throw const AuthException('Connexion requise');
    await _client.rpc(
      'community_set_solution',
      params: {'p_post_id': postId, 'p_comment_id': commentId},
    );
  }

  RealtimeChannel subscribeToPostComments(
    String postId,
    void Function(Map<String, dynamic> record) onInsert,
  ) => _client
      .channel('community-post-comments:$postId')
      .onPostgresChanges(
        event: PostgresChangeEvent.insert,
        schema: 'public',
        table: 'community_comments',
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'post_id',
          value: postId,
        ),
        callback: (payload) => onInsert(payload.newRecord),
      )
      .subscribe();

  Future<void> reportPost(
    CommunityPost post,
    String reason,
    String? details,
  ) async {
    final uid = userId;
    if (uid == null) throw const AuthException('Connexion requise');
    await _client.from('community_reports').insert({
      'reporter_id': uid,
      'space_id': post.scope.id,
      'target_type': 'post',
      'target_id': post.id,
      'reason': reason,
      'details': details?.trim(),
    });
  }

  Future<void> deleteOwnPost(CommunityPost post) async {
    final uid = userId;
    if (uid == null) throw const AuthException('Connexion requise');
    if (post.authorId != uid) throw const AuthException('Action non autorisée');
    await _client
        .from('community_posts')
        .update({
          'status': 'deleted_by_author',
          'deleted_at': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('id', post.id)
        .eq('author_id', uid);
  }

  Future<List<CommunityRoom>> rooms() async {
    final rows = await _client.rpc('community_my_rooms');
    return (rows as List)
        .cast<Map<String, dynamic>>()
        .map(CommunityRoom.fromJson)
        .toList();
  }

  Future<List<CommunityMessage>> messages(
    String roomId, {
    DateTime? before,
  }) async {
    var query = _client
        .from('community_messages')
        .select('id,sender_id,content,created_at')
        .eq('room_id', roomId)
        .eq('status', 'published');
    if (before != null)
      query = query.lt('created_at', before.toUtc().toIso8601String());
    final rows = await query.order('created_at', ascending: false).limit(50);
    return (rows as List)
        .cast<Map<String, dynamic>>()
        .map(CommunityMessage.fromJson)
        .toList()
        .reversed
        .toList();
  }

  Future<void> sendMessage(String roomId, String content) async {
    final uid = userId;
    if (uid == null) throw const AuthException('Connexion requise');
    await _client.from('community_messages').insert({
      'client_id': const Uuid().v4(),
      'room_id': roomId,
      'sender_id': uid,
      'content': content.trim(),
      'type': 'text',
    });
  }

  Future<void> markRoomRead(String roomId, String? messageId) async {
    if (userId == null) return;
    await _client.rpc(
      'community_mark_room_read',
      params: {'p_room_id': roomId, 'p_message_id': messageId},
    );
  }

  Future<List<CommunityPublicIdentity>> roomParticipants(String roomId) async {
    final uid = userId;
    if (uid == null) throw const AuthException('Connexion requise');
    final rows = await _client
        .from('community_room_members')
        .select('user_id')
        .eq('room_id', roomId)
        .isFilter('left_at', null);
    final ids = (rows as List)
        .cast<Map<String, dynamic>>()
        .map((row) => row['user_id'] as String)
        .where((id) => id != uid)
        .toList(growable: false);
    final identities = await _publicIdentities(ids);
    return [
      for (final id in ids)
        if (identities[id] != null) identities[id]!,
    ];
  }

  Future<void> reportMessage(
    String messageId,
    String reason,
    String? details,
  ) async {
    if (userId == null) throw const AuthException('Connexion requise');
    await _client.rpc(
      'community_report_message',
      params: {
        'p_message_id': messageId,
        'p_reason': reason,
        'p_details': details?.trim(),
      },
    );
  }

  Future<void> leaveRoom(String roomId) async {
    if (userId == null) throw const AuthException('Connexion requise');
    await _client.rpc('community_leave_room', params: {'p_room_id': roomId});
  }

  Future<void> blockRoomMember(String roomId, String otherUserId) async {
    if (userId == null) throw const AuthException('Connexion requise');
    await _client.rpc(
      'community_block_room_member',
      params: {'p_room_id': roomId, 'p_user_id': otherUserId},
    );
  }

  RealtimeChannel subscribeToMessages(
    String roomId,
    void Function() onChange,
  ) => _client
      .channel('community-room:$roomId')
      .onPostgresChanges(
        event: PostgresChangeEvent.insert,
        schema: 'public',
        table: 'community_messages',
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'room_id',
          value: roomId,
        ),
        callback: (_) => onChange(),
      )
      .subscribe();
  Future<void> unsubscribe(RealtimeChannel channel) =>
      _client.removeChannel(channel);

  Future<CommunityPublicProfile> profile(String id) async {
    final values = await Future.wait([
      _client.rpc('community_public_profile', params: {'p_user_id': id}),
      _client.rpc('get_public_profile_badge', params: {'p_user_id': id}),
    ]);
    final data = Map<String, dynamic>.from(values[0] as Map);
    final badges = values[1] as List;
    if (badges.isNotEmpty) {
      data['badge_type'] = (badges.first as Map<String, dynamic>)['badge_type'];
    }
    return CommunityPublicProfile.fromJson(data);
  }

  Future<List<CommunityPublicProfile>> searchProfiles(String query) async {
    final rows = await _client.rpc(
      'community_search_profiles',
      params: {'p_query': query, 'p_limit': 20},
    );
    final profiles = (rows as List)
        .cast<Map<String, dynamic>>()
        .map(CommunityPublicProfile.fromJson)
        .toList();
    final identities = await _publicIdentities(profiles.map((p) => p.userId));
    return profiles
        .map((profile) {
          final identity = identities[profile.userId];
          if (identity == null) return profile;
          return CommunityPublicProfile.fromJson({
            'user_id': profile.userId,
            'username': identity.username,
            'display_name': identity.displayName,
            'avatar_index': identity.avatarIndex,
            'bio': profile.bio,
            'primary_space': profile.primaryScope.id,
            'joined_at': profile.joinedAt?.toIso8601String(),
            'post_count': profile.postCount,
            'comment_count': profile.commentCount,
            'solutions_count': profile.solutionsCount,
            'staff_role': profile.staffRole,
            'badge_type': identity.badgeType,
            'show_display_name': profile.showDisplayName,
          });
        })
        .toList(growable: false);
  }

  Future<List<CommunityPost>> searchPosts(
    String query,
    CommunityScope scope,
  ) async {
    final rows = await _client.rpc(
      'community_search_posts',
      params: {'p_query': query, 'p_space_id': scope.id, 'p_limit': 30},
    );
    final posts = (rows as List)
        .cast<Map<String, dynamic>>()
        .map((e) => CommunityPost.fromJson(e, userId))
        .toList();
    return _enrichPosts(posts);
  }

  Future<String> directRoom(String otherUserId) async {
    final value = await _client.rpc(
      'community_get_or_create_direct_room',
      params: {
        'p_other_user_id': otherUserId,
        'p_client_id': const Uuid().v4(),
      },
    );
    return value as String;
  }

  Future<bool> isSubscribed(String postId) async {
    final rows = await _client
        .from('community_subscriptions')
        .select('post_id')
        .eq('post_id', postId)
        .limit(1);
    return (rows as List).isNotEmpty;
  }

  Future<bool> toggleSubscription(String postId) async =>
      await _client.rpc(
            'community_toggle_subscription',
            params: {'p_post_id': postId, 'p_level': 'all'},
          )
          as bool;
  Future<int> recordShare(String postId, String channel) async =>
      (await _client.rpc(
                'community_record_share',
                params: {
                  'p_post_id': postId,
                  'p_client_id': const Uuid().v4(),
                  'p_channel': channel,
                },
              )
              as num)
          .toInt();
  Future<void> shareToRoom(String roomId, CommunityPost post) async {
    final uid = userId;
    if (uid == null) throw const AuthException('Connexion requise');
    await _client.from('community_messages').insert({
      'client_id': const Uuid().v4(),
      'room_id': roomId,
      'sender_id': uid,
      'type': 'post_share',
      'content': post.title,
    });
    await recordShare(post.id, 'internal');
  }

  Future<List<CommunityNotification>> notifications() async {
    final rows = await _client
        .from('community_notifications')
        .select(
          'id,actor_id,type,space_id,target_type,target_id,payload,created_at,read_at',
        )
        .order('created_at', ascending: false)
        .limit(100);
    final notifications = (rows as List)
        .cast<Map<String, dynamic>>()
        .map(CommunityNotification.fromJson)
        .toList();
    final identities = await _publicIdentities(
      notifications.map((item) => item.actorId).whereType<String>(),
    );
    return notifications
        .map(
          (item) => item.actorId != null && identities[item.actorId] != null
              ? item.copyWithActor(identities[item.actorId]!)
              : item,
        )
        .toList(growable: false);
  }

  Future<int> unreadNotificationCount() async {
    final uid = userId;
    if (uid == null) return 0;
    final count = await _client
        .from('community_notifications')
        .count(CountOption.exact)
        .eq('recipient_id', uid)
        .isFilter('read_at', null);
    return count;
  }

  RealtimeChannel subscribeToOwnNotifications(void Function() onChange) {
    final uid = userId;
    return _client
        .channel('community-notifications:${uid ?? 'signed-out'}')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'community_notifications',
          filter: uid == null
              ? null
              : PostgresChangeFilter(
                  type: PostgresChangeFilterType.eq,
                  column: 'recipient_id',
                  value: uid,
                ),
          callback: (_) => onChange(),
        )
        .subscribe();
  }

  Future<CommunityNotificationPreferences> notificationPreferences() async {
    final uid = userId;
    if (uid == null) return const CommunityNotificationPreferences();
    final rows = await _client
        .from('community_notification_preferences')
        .select('enabled,messages_enabled,forum_enabled')
        .eq('user_id', uid)
        .limit(1);
    if ((rows as List).isEmpty) return const CommunityNotificationPreferences();
    return CommunityNotificationPreferences.fromJson(
      (rows.first as Map).cast<String, dynamic>(),
    );
  }

  Future<void> updateNotificationPreferences(
    CommunityNotificationPreferences preferences,
  ) async {
    final uid = userId;
    if (uid == null) throw const AuthException('Connexion requise');
    await _client.from('community_notification_preferences').upsert({
      'user_id': uid,
      'enabled': preferences.enabled,
      'messages_enabled': preferences.messagesEnabled,
      'forum_enabled': preferences.forumEnabled,
    });
  }

  Future<void> markNotificationRead(String id) => _client
      .from('community_notifications')
      .update({'read_at': DateTime.now().toUtc().toIso8601String()})
      .eq('id', id);
  Future<void> markAllNotificationsRead() async {
    final uid = userId;
    if (uid == null) return;
    await _client
        .from('community_notifications')
        .update({'read_at': DateTime.now().toUtc().toIso8601String()})
        .eq('recipient_id', uid)
        .isFilter('read_at', null);
  }

  Future<void> deleteNotifications(Iterable<String> notificationIds) async {
    final uid = userId;
    if (uid == null) throw const AuthException('Connexion requise');
    final ids = notificationIds.toSet().toList(growable: false);
    if (ids.isEmpty) return;
    await _client
        .from('community_notifications')
        .delete()
        .eq('recipient_id', uid)
        .inFilter('id', ids);
  }

  Future<void> updateOwnCommunityProfile({
    required String bio,
    required bool showActivity,
    required bool showJoinedAt,
    required bool showSpaces,
    required bool showDisplayName,
  }) async {
    final uid = userId;
    if (uid == null) throw const AuthException('Connexion requise');
    await _client.from('community_profiles').upsert({
      'user_id': uid,
      'bio': bio.trim(),
      'show_activity': showActivity,
      'show_joined_at': showJoinedAt,
      'show_spaces': showSpaces,
      'show_display_name': showDisplayName,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    });
  }
}
