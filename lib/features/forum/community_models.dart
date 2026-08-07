import 'package:flutter/material.dart';

String _twoDigits(int value) => value.toString().padLeft(2, '0');

String communityTime(DateTime value) {
  final date = value.toLocal();
  return '${_twoDigits(date.hour)}:${_twoDigits(date.minute)}';
}

String communityShortDateTime(DateTime value) {
  final date = value.toLocal();
  return '${_twoDigits(date.day)}/${_twoDigits(date.month)} · ${communityTime(date)}';
}

String communityFullDateTime(DateTime value) {
  final date = value.toLocal();
  return '${_twoDigits(date.day)}/${_twoDigits(date.month)}/${date.year} · ${communityTime(date)}';
}

String communityMonthYear(DateTime value) {
  const months = [
    'janvier',
    'février',
    'mars',
    'avril',
    'mai',
    'juin',
    'juillet',
    'août',
    'septembre',
    'octobre',
    'novembre',
    'décembre',
  ];
  final date = value.toLocal();
  return '${months[date.month - 1]} ${date.year}';
}

enum CommunityScope { global, paExam, gpxExam, paSchool, gpxSchool }

extension CommunityScopeX on CommunityScope {
  String get id => switch (this) {
    CommunityScope.global => 'global',
    CommunityScope.paExam => 'pa_exam',
    CommunityScope.gpxExam => 'gpx_exam',
    CommunityScope.paSchool => 'pa_school',
    CommunityScope.gpxSchool => 'gpx_school',
  };

  String get label => switch (this) {
    CommunityScope.global => 'Tout le monde',
    CommunityScope.paExam => 'Concours Policier adjoint',
    CommunityScope.gpxExam => 'Concours Gardien de la paix',
    CommunityScope.paSchool => 'École Policier adjoint',
    CommunityScope.gpxSchool => 'École Gardien de la paix',
  };

  String get shortLabel => switch (this) {
    CommunityScope.global => 'Général',
    CommunityScope.paExam => 'Concours PA',
    CommunityScope.gpxExam => 'Concours GPX',
    CommunityScope.paSchool => 'École PA',
    CommunityScope.gpxSchool => 'École GPX',
  };

  String get description => switch (this) {
    CommunityScope.global => 'Visible par toute la communauté',
    CommunityScope.paExam => 'Préparation au recrutement de policier adjoint',
    CommunityScope.gpxExam => 'Préparation au concours de gardien de la paix',
    CommunityScope.paSchool => 'Formation des policiers adjoints',
    CommunityScope.gpxSchool => 'Formation des gardiens de la paix',
  };

  Color get color => switch (this) {
    CommunityScope.global => const Color(0xFF173B57),
    CommunityScope.paExam => const Color(0xFFE33D4F),
    CommunityScope.gpxExam => const Color(0xFF2463EB),
    CommunityScope.paSchool => const Color(0xFF0F9F82),
    CommunityScope.gpxSchool => const Color(0xFF7C4DDB),
  };

  IconData get icon => switch (this) {
    CommunityScope.global => Icons.groups_rounded,
    CommunityScope.paExam => Icons.shield_rounded,
    CommunityScope.gpxExam => Icons.local_police_rounded,
    CommunityScope.paSchool => Icons.school_rounded,
    CommunityScope.gpxSchool => Icons.account_balance_rounded,
  };

  static CommunityScope fromId(String? value) =>
      CommunityScope.values.where((scope) => scope.id == value).firstOrNull ??
      CommunityScope.global;
}

class CommunityCategory {
  const CommunityCategory({
    required this.id,
    required this.scope,
    required this.slug,
    required this.label,
    required this.description,
  });
  final String id;
  final CommunityScope scope;
  final String slug;
  final String label;
  final String description;

  factory CommunityCategory.fromJson(Map<String, dynamic> json) =>
      CommunityCategory(
        id: json['id'] as String,
        scope: CommunityScopeX.fromId(json['space_id'] as String?),
        slug: json['slug'] as String? ?? '',
        label: json['label'] as String? ?? 'Catégorie',
        description: json['description'] as String? ?? '',
      );
}

class CommunityPost {
  const CommunityPost({
    required this.id,
    required this.authorId,
    required this.scope,
    required this.categoryId,
    required this.categoryLabel,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.reactionCount,
    required this.commentCount,
    required this.isPinned,
    required this.isResolved,
    required this.liked,
    required this.bookmarked,
    this.authorUsername = 'Membre COP’IQ',
    this.authorDisplayName = 'Membre COP’IQ',
    this.authorAvatarIndex = 0,
    this.authorBadgeType,
  });

  final String id;
  final String authorId;
  final CommunityScope scope;
  final String categoryId;
  final String categoryLabel;
  final String title;
  final String content;
  final DateTime createdAt;
  final int reactionCount;
  final int commentCount;
  final bool isPinned;
  final bool isResolved;
  final bool liked;
  final bool bookmarked;
  final String authorUsername;
  final String authorDisplayName;
  final int authorAvatarIndex;
  final String? authorBadgeType;

  CommunityPost copyWith({
    int? reactionCount,
    bool? liked,
    bool? bookmarked,
    String? authorUsername,
    String? authorDisplayName,
    int? authorAvatarIndex,
    String? authorBadgeType,
  }) => CommunityPost(
    id: id,
    authorId: authorId,
    scope: scope,
    categoryId: categoryId,
    categoryLabel: categoryLabel,
    title: title,
    content: content,
    createdAt: createdAt,
    reactionCount: reactionCount ?? this.reactionCount,
    commentCount: commentCount,
    isPinned: isPinned,
    isResolved: isResolved,
    liked: liked ?? this.liked,
    bookmarked: bookmarked ?? this.bookmarked,
    authorUsername: authorUsername ?? this.authorUsername,
    authorDisplayName: authorDisplayName ?? this.authorDisplayName,
    authorAvatarIndex: authorAvatarIndex ?? this.authorAvatarIndex,
    authorBadgeType: authorBadgeType ?? this.authorBadgeType,
  );

  factory CommunityPost.fromJson(Map<String, dynamic> json, String? userId) {
    final category = json['community_categories'] as Map<String, dynamic>?;
    final reactions = (json['community_reactions'] as List?) ?? const [];
    final bookmarks = (json['community_bookmarks'] as List?) ?? const [];
    return CommunityPost(
      id: json['id'] as String,
      authorId: json['author_id'] as String,
      scope: CommunityScopeX.fromId(json['space_id'] as String?),
      categoryId: json['category_id'] as String,
      categoryLabel: category?['label'] as String? ?? 'Discussion',
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      createdAt:
          DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.now(),
      reactionCount: json['reaction_count'] as int? ?? 0,
      commentCount: json['comment_count'] as int? ?? 0,
      isPinned: json['is_pinned'] as bool? ?? false,
      isResolved: json['is_resolved'] as bool? ?? false,
      liked: reactions.any((e) => e is Map && e['user_id'] == userId),
      bookmarked: bookmarks.any((e) => e is Map && e['user_id'] == userId),
    );
  }
}

class CommunityComment {
  const CommunityComment({
    required this.id,
    required this.authorId,
    required this.content,
    required this.createdAt,
    this.parentId,
    this.replyCount = 0,
    this.reactionCount = 0,
    this.liked = false,
    this.isSolution = false,
    this.status = 'published',
    this.editedAt,
    this.authorUsername = 'Membre COP’IQ',
    this.authorDisplayName = 'Membre COP’IQ',
    this.authorAvatarIndex = 0,
    this.authorBadgeType,
  });
  final String id;
  final String authorId;
  final String content;
  final DateTime createdAt;
  final String? parentId;
  final int replyCount;
  final int reactionCount;
  final bool liked;
  final bool isSolution;
  final String status;
  final DateTime? editedAt;
  final String authorUsername;
  final String authorDisplayName;
  final int authorAvatarIndex;
  final String? authorBadgeType;

  CommunityComment copyWithAuthor(CommunityPublicIdentity identity) =>
      CommunityComment(
        id: id,
        authorId: authorId,
        content: content,
        createdAt: createdAt,
        parentId: parentId,
        replyCount: replyCount,
        reactionCount: reactionCount,
        liked: liked,
        isSolution: isSolution,
        status: status,
        editedAt: editedAt,
        authorUsername: identity.username,
        authorDisplayName: identity.displayName,
        authorAvatarIndex: identity.avatarIndex,
        authorBadgeType: identity.badgeType,
      );
  factory CommunityComment.fromJson(
    Map<String, dynamic> json, [
    String? userId,
  ]) => CommunityComment(
    id: json['id'] as String,
    authorId: json['author_id'] as String,
    content: json['content'] as String? ?? '',
    parentId: json['parent_id'] as String?,
    replyCount: (json['reply_count'] as num?)?.toInt() ?? 0,
    reactionCount: (json['reaction_count'] as num?)?.toInt() ?? 0,
    liked: ((json['community_reactions'] as List?) ?? const []).any(
      (reaction) =>
          reaction is Map &&
          reaction['user_id'] == userId &&
          reaction['kind'] == 'like',
    ),
    isSolution: json['is_solution'] as bool? ?? false,
    status: json['status'] as String? ?? 'published',
    editedAt: DateTime.tryParse(json['edited_at'] as String? ?? ''),
    createdAt:
        DateTime.tryParse(json['created_at'] as String? ?? '') ??
        DateTime.now(),
  );
}

class CommunityPublicIdentity {
  const CommunityPublicIdentity({
    required this.userId,
    required this.username,
    required this.displayName,
    required this.avatarIndex,
    this.badgeType,
  });
  final String userId, username, displayName;
  final int avatarIndex;
  final String? badgeType;

  factory CommunityPublicIdentity.fromJson(Map<String, dynamic> json) =>
      CommunityPublicIdentity(
        userId: json['user_id'] as String,
        username: (json['username'] as String?)?.trim().isNotEmpty == true
            ? (json['username'] as String).trim()
            : 'Membre COP’IQ',
        displayName:
            (json['display_name'] as String?)?.trim().isNotEmpty == true
            ? (json['display_name'] as String).trim()
            : ((json['username'] as String?)?.trim().isNotEmpty == true
                  ? (json['username'] as String).trim()
                  : 'Membre COP’IQ'),
        avatarIndex: (json['avatar_index'] as num?)?.toInt() ?? 0,
        badgeType: json['badge_type'] as String?,
      );
}

class CommunityRoom {
  const CommunityRoom({
    required this.id,
    required this.title,
    required this.scope,
    required this.updatedAt,
    this.otherUserId,
    this.otherUsername = '',
    this.otherAvatarIndex = 0,
    this.lastMessage = '',
    this.lastMessageAt,
    this.unreadCount = 0,
  });
  final String id;
  final String title;
  final CommunityScope scope;
  final DateTime updatedAt;
  final String? otherUserId;
  final String otherUsername, lastMessage;
  final int otherAvatarIndex, unreadCount;
  final DateTime? lastMessageAt;
  factory CommunityRoom.fromJson(Map<String, dynamic> json) => CommunityRoom(
    id: json['id'] as String,
    title: (json['title'] as String?)?.trim().isNotEmpty == true
        ? json['title'] as String
        : 'Conversation',
    scope: CommunityScopeX.fromId(json['space_id'] as String?),
    updatedAt:
        DateTime.tryParse(json['updated_at'] as String? ?? '') ??
        DateTime.now(),
    otherUserId: json['other_user_id'] as String?,
    otherUsername: json['other_username'] as String? ?? '',
    otherAvatarIndex: (json['other_avatar_index'] as num?)?.toInt() ?? 0,
    lastMessage: json['last_message'] as String? ?? '',
    lastMessageAt: DateTime.tryParse(json['last_message_at'] as String? ?? ''),
    unreadCount: (json['unread_count'] as num?)?.toInt() ?? 0,
  );
}

class CommunityMessage {
  const CommunityMessage({
    required this.id,
    required this.senderId,
    required this.content,
    required this.createdAt,
  });
  final String id, senderId, content;
  final DateTime createdAt;
  factory CommunityMessage.fromJson(Map<String, dynamic> json) =>
      CommunityMessage(
        id: json['id'] as String,
        senderId: json['sender_id'] as String,
        content: json['content'] as String? ?? '',
        createdAt:
            DateTime.tryParse(json['created_at'] as String? ?? '') ??
            DateTime.now(),
      );
}

class CommunityPublicProfile {
  const CommunityPublicProfile({
    required this.userId,
    required this.username,
    required this.displayName,
    required this.avatarIndex,
    required this.bio,
    required this.primaryScope,
    required this.joinedAt,
    required this.postCount,
    required this.commentCount,
    required this.solutionsCount,
    this.staffRole,
    this.badgeType,
    this.showDisplayName = true,
  });
  final String userId, username, displayName, bio;
  final int avatarIndex, postCount, commentCount, solutionsCount;
  final CommunityScope primaryScope;
  final DateTime? joinedAt;
  final String? staffRole;
  final String? badgeType;
  final bool showDisplayName;
  factory CommunityPublicProfile.fromJson(Map<String, dynamic> json) =>
      CommunityPublicProfile(
        userId: json['user_id'] as String,
        username: json['username'] as String? ?? 'Membre COP’IQ',
        displayName:
            (json['display_name'] as String?)?.trim().isNotEmpty == true
            ? (json['display_name'] as String).trim()
            : (json['username'] as String? ?? 'Membre COP’IQ'),
        avatarIndex: (json['avatar_index'] as num?)?.toInt() ?? 0,
        bio: json['bio'] as String? ?? '',
        primaryScope: CommunityScopeX.fromId(json['primary_space'] as String?),
        joinedAt: DateTime.tryParse(json['joined_at'] as String? ?? ''),
        postCount: (json['post_count'] as num?)?.toInt() ?? 0,
        commentCount: (json['comment_count'] as num?)?.toInt() ?? 0,
        solutionsCount: (json['solutions_count'] as num?)?.toInt() ?? 0,
        staffRole: json['staff_role'] as String?,
        badgeType: json['badge_type'] as String?,
        showDisplayName: json['show_display_name'] as bool? ?? true,
      );
}

class CommunityNotification {
  const CommunityNotification({
    required this.id,
    required this.type,
    required this.scope,
    required this.targetType,
    required this.targetId,
    required this.createdAt,
    this.readAt,
    this.actorId,
    this.actorDisplayName = '',
    this.actorUsername = '',
    this.actorAvatarIndex = 0,
    this.commentId,
  });
  final String id, type, targetType;
  final String? targetId;
  final CommunityScope scope;
  final DateTime createdAt;
  final DateTime? readAt;
  final String? actorId;
  final String actorDisplayName, actorUsername;
  final int actorAvatarIndex;
  final String? commentId;
  factory CommunityNotification.fromJson(Map<String, dynamic> json) =>
      CommunityNotification(
        id: json['id'] as String,
        type: json['type'] as String? ?? 'activity',
        scope: CommunityScopeX.fromId(json['space_id'] as String?),
        targetType: json['target_type'] as String? ?? '',
        targetId: json['target_id'] as String?,
        createdAt:
            DateTime.tryParse(json['created_at'] as String? ?? '') ??
            DateTime.now(),
        readAt: DateTime.tryParse(json['read_at'] as String? ?? ''),
        actorId: json['actor_id'] as String?,
        actorDisplayName: json['actor_display_name'] as String? ?? '',
        actorUsername: json['actor_username'] as String? ?? '',
        actorAvatarIndex: (json['actor_avatar_index'] as num?)?.toInt() ?? 0,
        commentId: (json['payload'] is Map)
            ? (json['payload'] as Map)['comment_id'] as String?
            : null,
      );

  CommunityNotification copyWithActor(CommunityPublicIdentity actor) =>
      CommunityNotification(
        id: id,
        type: type,
        scope: scope,
        targetType: targetType,
        targetId: targetId,
        createdAt: createdAt,
        readAt: readAt,
        actorId: actor.userId,
        actorDisplayName: actor.displayName,
        actorUsername: actor.username,
        actorAvatarIndex: actor.avatarIndex,
        commentId: commentId,
      );
}

class CommunityNotificationPreferences {
  const CommunityNotificationPreferences({
    this.enabled = true,
    this.messagesEnabled = true,
    this.forumEnabled = true,
  });
  final bool enabled, messagesEnabled, forumEnabled;
  factory CommunityNotificationPreferences.fromJson(
    Map<String, dynamic> json,
  ) => CommunityNotificationPreferences(
    enabled: json['enabled'] as bool? ?? true,
    messagesEnabled: json['messages_enabled'] as bool? ?? true,
    forumEnabled: json['forum_enabled'] as bool? ?? true,
  );
}
