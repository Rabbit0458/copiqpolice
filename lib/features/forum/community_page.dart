import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:copiqpolice/core/widgets/user_verification_badge.dart';
import 'community_models.dart';
import 'community_repository.dart';
import 'community_messaging_page.dart';
import 'community_discovery_pages.dart';
import 'community_feedback.dart';
import 'community_notification_service.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key, required this.initialScope});
  final CommunityScope initialScope;
  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final _repository = CommunityRepository();
  late CommunityScope _scope = widget.initialScope;
  late CommunityScope _writeScope = widget.initialScope;
  List<CommunityPost> _posts = const [];
  bool _loading = true;
  String? _error;
  int _unreadNotifications = 0;
  RealtimeChannel? _notificationChannel;

  @override
  void initState() {
    super.initState();
    _loadActiveScope();
    _load();
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    await _refreshUnreadNotifications();
    _notificationChannel = _repository.subscribeToOwnNotifications(
      _refreshUnreadNotifications,
    );
    final prefs = await SharedPreferences.getInstance();
    if (!(prefs.getBool('community_notifications_permission_asked') ?? false)) {
      await prefs.setBool('community_notifications_permission_asked', true);
      await CommunityNotificationService.I.requestPermission();
    }
  }

  Future<void> _refreshUnreadNotifications() async {
    try {
      final count = await _repository.unreadNotificationCount();
      if (mounted) setState(() => _unreadNotifications = count);
    } catch (_) {
      // Le fil reste utilisable même si le badge est momentanément indisponible.
    }
  }

  @override
  void dispose() {
    final channel = _notificationChannel;
    if (channel != null) unawaited(_repository.unsubscribe(channel));
    super.dispose();
  }

  Future<void> _loadActiveScope() async {
    try {
      final active = await _repository.activeScope();
      if (active != null && mounted) {
        setState(() {
          _writeScope = active;
          _scope = active;
        });
        await _load();
      }
    } catch (_) {
      // Le module transmis par la page d'accueil reste un repli fiable.
    }
  }

  bool get _readOnly => _scope != _writeScope;

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final value = await _repository.posts(scope: _scope);
      if (mounted) setState(() => _posts = value);
    } catch (e) {
      if (mounted)
        setState(() => _error = 'Impossible de charger la communauté.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _select(CommunityScope scope) async {
    if (scope == _scope) return;
    setState(() => _scope = scope);
    await _load();
  }

  Future<void> _chooseScope() async {
    final selected = await showModalBottomSheet<CommunityScope>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choisir un espace',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 4),
              Text(
                'Ton module actif permet de participer. Les autres sont en lecture seule.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 14),
              for (final scope in CommunityScope.values)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Material(
                    color: scope == _scope
                        ? scope.color.withValues(alpha: .11)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(17),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(17),
                      onTap: () => Navigator.pop(sheetContext, scope),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 13,
                          vertical: 11,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: scope.color.withValues(alpha: .12),
                                borderRadius: BorderRadius.circular(13),
                              ),
                              child: Icon(
                                scope.icon,
                                color: scope.color,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    scope.label,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  Text(
                                    scope == _writeScope
                                        ? 'Module actif · participation autorisée'
                                        : 'Consultation uniquement',
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: scope == _writeScope
                                              ? scope.color
                                              : Theme.of(
                                                  context,
                                                ).colorScheme.onSurfaceVariant,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            if (scope == _scope)
                              Icon(
                                Icons.check_circle_rounded,
                                color: scope.color,
                              )
                            else if (scope != _writeScope)
                              const Icon(Icons.lock_outline_rounded, size: 18),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
    if (selected != null) await _select(selected);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Communauté'),
        actions: [
          IconButton(
            tooltip: 'Rechercher',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => CommunitySearchPage(initialScope: _scope),
              ),
            ),
            icon: const Icon(Icons.search_rounded),
          ),
          IconButton(
            tooltip: 'Notifications',
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const CommunityNotificationsPage(),
                ),
              );
              await _refreshUnreadNotifications();
            },
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.notifications_none_rounded),
                if (_unreadNotifications > 0)
                  Positioned(
                    right: -7,
                    top: -7,
                    child: Container(
                      constraints: const BoxConstraints(minWidth: 18),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.error,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.surface,
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        _unreadNotifications > 9
                            ? '9+'
                            : '$_unreadNotifications',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Messages',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const CommunityInboxPage()),
            ),
            icon: const Icon(Icons.chat_bubble_outline_rounded),
          ),
          IconButton(
            tooltip: 'Mon profil communautaire',
            onPressed: () {
              final id = Supabase.instance.client.auth.currentUser?.id;
              if (id != null) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CommunityProfilePage(userId: id),
                  ),
                );
              }
            },
            icon: const Icon(Icons.account_circle_outlined),
          ),
          IconButton(
            tooltip: 'Publications enregistrées',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => CommunitySavedPage(repository: _repository),
              ),
            ),
            icon: const Icon(Icons.bookmark_border_rounded),
          ),
        ],
      ),
      floatingActionButton: _readOnly
          ? null
          : _CommunityComposeButton(
              color: _writeScope.color,
              onPressed: _compose,
            ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 7, 16, 7),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: _chooseScope,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        height: 48,
                        padding: const EdgeInsets.symmetric(horizontal: 13),
                        decoration: BoxDecoration(
                          color: _scope.color.withValues(alpha: .09),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _scope.color.withValues(alpha: .28),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(_scope.icon, size: 18, color: _scope.color),
                            const SizedBox(width: 9),
                            Expanded(
                              child: Text(
                                _scope.label,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            if (_readOnly)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.surface.withValues(alpha: .72),
                                  borderRadius: BorderRadius.circular(99),
                                ),
                                child: const Text(
                                  'Lecture',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            const SizedBox(width: 7),
                            const Icon(Icons.keyboard_arrow_down_rounded),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(onRefresh: _load, child: _body(theme)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _body(ThemeData theme) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null)
      return ListView(
        children: [
          const SizedBox(height: 140),
          Icon(
            Icons.cloud_off_rounded,
            size: 52,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(height: 12),
          Text(_error!, textAlign: TextAlign.center),
          Center(
            child: TextButton(onPressed: _load, child: const Text('Réessayer')),
          ),
        ],
      );
    if (_posts.isEmpty)
      return ListView(
        children: [
          const SizedBox(height: 140),
          Icon(
            Icons.forum_outlined,
            size: 56,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(height: 12),
          const Text(
            'Aucune publication pour le moment',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          const Text(
            'Lance la première discussion.',
            textAlign: TextAlign.center,
          ),
        ],
      );
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      itemCount: _posts.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _PostCard(
        post: _posts[index],
        onOpen: () => _open(_posts[index]),
        onLike: () => _toggleLike(index),
        onBookmark: () => _toggleBookmark(index),
        onManage: () => _managePost(index),
      ),
    );
  }

  Future<void> _toggleLike(int index) async {
    if (_readOnly) {
      showCommunityNotice(
        context,
        'Lecture seule · passe sur ${_writeScope.shortLabel} pour participer',
        type: CommunityNoticeType.info,
      );
      return;
    }
    final old = _posts[index];
    setState(
      () => _posts = [..._posts]
        ..[index] = old.copyWith(
          reactionCount: old.reactionCount + (old.liked ? -1 : 1),
          liked: !old.liked,
        ),
    );
    try {
      await _repository.toggleLike(old);
    } catch (_) {
      await _load();
    }
  }

  Future<void> _toggleBookmark(int index) async {
    final old = _posts[index];
    setState(
      () =>
          _posts = [..._posts]
            ..[index] = old.copyWith(bookmarked: !old.bookmarked),
    );
    try {
      await _repository.toggleBookmark(old);
    } catch (_) {
      await _load();
    }
  }

  Future<void> _managePost(int index) async {
    final post = _posts[index];
    final mine = post.authorId == _repository.userId;
    final action = await showPostManageSheet(
      context,
      mine: mine,
      authorName: post.authorDisplayName,
    );
    if (!mounted || action == null) return;
    if (action == 'profile') {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => CommunityProfilePage(userId: post.authorId),
        ),
      );
    } else if (action == 'report') {
      await _reportPost(post);
    } else if (action == 'delete') {
      await _confirmDelete(post);
    }
  }

  Future<void> _confirmDelete(CommunityPost post) async {
    final confirmed = await showDeletePostConfirmation(context);
    if (confirmed != true) return;
    await _repository.deleteOwnPost(post);
    if (!mounted) return;
    setState(
      () => _posts = _posts.where((item) => item.id != post.id).toList(),
    );
    showCommunityNotice(
      context,
      'Publication supprimée',
      type: CommunityNoticeType.success,
    );
  }

  Future<void> _reportPost(CommunityPost post) async {
    final reason = await showCommunityReportSheet(context);
    if (reason == null) return;
    try {
      await _repository.reportPost(post, reason, null);
      if (mounted) {
        showCommunityNotice(
          context,
          'Signalement transmis à la modération',
          type: CommunityNoticeType.success,
        );
      }
    } on PostgrestException catch (error) {
      if (mounted) {
        final duplicate = error.code == '23505';
        showCommunityNotice(
          context,
          duplicate
              ? 'Cette publication a déjà été signalée'
              : 'Impossible d’envoyer le signalement',
          type: duplicate
              ? CommunityNoticeType.warning
              : CommunityNoticeType.error,
        );
      }
    }
  }

  Future<void> _compose() async {
    final postId = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) => CommunityComposerPage(
          initialScope: _scope,
          repository: _repository,
        ),
      ),
    );
    if (postId == null) return;
    await _load();
    if (!mounted) return;
    _showPublishSuccess(postId);
  }

  void _showPublishSuccess(String postId) {
    final published = _posts.where((post) => post.id == postId).firstOrNull;
    final destination = published == null
        ? 'Visible dans la communauté'
        : '${published.scope.shortLabel} · ${published.categoryLabel}';
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        elevation: 12,
        duration: const Duration(seconds: 5),
        dismissDirection: DismissDirection.horizontal,
        backgroundColor: const Color(0xFF10261E),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
        padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF2E6651)),
        ),
        content: Semantics(
          liveRegion: true,
          label: 'Publication envoyée avec succès. $destination',
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  color: Color(0xFF1E4B3A),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Color(0xFF67E8A8),
                  size: 25,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Publication envoyée',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      destination,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFFB9D7CB),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF67E8A8),
                  minimumSize: const Size(52, 44),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () => _openPublishedPost(postId, published),
                child: const Text(
                  'Voir',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openPublishedPost(
    String postId,
    CommunityPost? published,
  ) async {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    try {
      final post = published ?? await _repository.post(postId);
      if (mounted) _open(post);
    } catch (_) {
      if (mounted) {
        showCommunityNotice(
          context,
          'La publication est disponible dans le fil',
          type: CommunityNoticeType.info,
        );
      }
    }
  }

  Future<void> _open(CommunityPost post) async {
    final deleted = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => CommunityPostPage(post: post, repository: _repository),
      ),
    );
    if (deleted == true && mounted) await _load();
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({
    required this.post,
    required this.onOpen,
    required this.onLike,
    required this.onBookmark,
    required this.onManage,
  });
  final CommunityPost post;
  final VoidCallback onOpen, onLike, onBookmark, onManage;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CommunityAvatar(
                    name: post.authorDisplayName,
                    color: post.scope.color,
                    avatarIndex: post.authorAvatarIndex,
                    size: 38,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                post.authorDisplayName,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            UserVerificationBadge(
                              type: UserBadgeType.fromString(
                                post.authorBadgeType,
                              ),
                              size: 15,
                            ),
                          ],
                        ),
                        Text(
                          '@${post.authorUsername} · ${communityShortDateTime(post.createdAt)}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (post.isPinned)
                    const Icon(Icons.push_pin_rounded, size: 18),
                  IconButton(
                    tooltip: 'Gérer la publication',
                    visualDensity: VisualDensity.compact,
                    onPressed: onManage,
                    icon: const Icon(Icons.more_horiz_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: post.scope.color.withValues(alpha: .12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          post.scope.icon,
                          size: 14,
                          color: post.scope.color,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          post.scope.label,
                          style: TextStyle(
                            color: post.scope.color,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      post.categoryLabel,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                post.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                post.content,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.45),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  const Spacer(),
                  _Action(
                    icon: post.liked
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    label: '${post.reactionCount}',
                    color: post.liked ? Colors.red : null,
                    onTap: onLike,
                  ),
                  _Action(
                    icon: Icons.chat_bubble_outline_rounded,
                    label: '${post.commentCount}',
                    onTap: onOpen,
                  ),
                  IconButton(
                    tooltip: post.bookmarked
                        ? 'Retirer des favoris'
                        : 'Enregistrer',
                    onPressed: onBookmark,
                    icon: Icon(
                      post.bookmarked
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Action extends StatelessWidget {
  const _Action({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;
  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: label,
    child: InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Icon(icon, size: 19, color: color),
            const SizedBox(width: 4),
            Text(label),
          ],
        ),
      ),
    ),
  );
}

class CommunitySavedPage extends StatefulWidget {
  const CommunitySavedPage({super.key, required this.repository});
  final CommunityRepository repository;
  @override
  State<CommunitySavedPage> createState() => _CommunitySavedPageState();
}

class _CommunitySavedPageState extends State<CommunitySavedPage> {
  late Future<List<CommunityPost>> _future = widget.repository
      .bookmarkedPosts();
  final Set<String> _removing = {};

  Future<void> _refresh() async {
    setState(() => _future = widget.repository.bookmarkedPosts());
    await _future;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Publications enregistrées')),
    body: FutureBuilder<List<CommunityPost>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final posts = snapshot.data ?? const <CommunityPost>[];
        if (posts.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(30),
              child: Text(
                'Aucune publication enregistrée.\nAppuie sur le marque-page d’une publication pour la retrouver ici.',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: _refresh,
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
            itemCount: posts.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final post = posts[index];
              void open() => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CommunityPostPage(
                    post: post,
                    repository: widget.repository,
                  ),
                ),
              );
              return _PostCard(
                post: post,
                onOpen: open,
                onLike: () async {
                  await widget.repository.toggleLike(post);
                  await _refresh();
                },
                onBookmark: () async {
                  if (_removing.contains(post.id)) return;
                  setState(() => _removing.add(post.id));
                  try {
                    await widget.repository.removeBookmark(post.id);
                    if (!mounted) return;
                    setState(() {
                      _removing.remove(post.id);
                      _future = Future.value(
                        posts.where((item) => item.id != post.id).toList(),
                      );
                    });
                    showCommunityNotice(
                      context,
                      'Publication retirée des enregistrements.',
                      type: CommunityNoticeType.success,
                    );
                  } catch (_) {
                    if (!mounted) return;
                    setState(() => _removing.remove(post.id));
                    showCommunityNotice(
                      context,
                      'Impossible de retirer cette publication.',
                      type: CommunityNoticeType.error,
                    );
                  }
                },
                onManage: open,
              );
            },
          ),
        );
      },
    ),
  );
}

class CommunityComposerPage extends StatefulWidget {
  const CommunityComposerPage({
    super.key,
    required this.initialScope,
    required this.repository,
  });
  final CommunityScope initialScope;
  final CommunityRepository repository;
  @override
  State<CommunityComposerPage> createState() => _CommunityComposerPageState();
}

class _CommunityComposerPageState extends State<CommunityComposerPage> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController(), _content = TextEditingController();
  late CommunityScope _scope = widget.initialScope;
  List<CommunityCategory> _categories = [];
  String? _category;
  bool _saving = false;
  Timer? _draftTimer;

  String get _draftKey {
    final user = widget.repository.userId ?? 'guest';
    return 'community_composer_draft_$user';
  }

  @override
  void initState() {
    super.initState();
    _title.addListener(_refreshComposer);
    _content.addListener(_refreshComposer);
    _restoreDraft();
  }

  void _refreshComposer() {
    if (mounted) setState(() {});
    _draftTimer?.cancel();
    _draftTimer = Timer(const Duration(milliseconds: 500), _saveDraft);
  }

  Future<void> _restoreDraft() async {
    final preferences = await SharedPreferences.getInstance();
    final values = preferences.getStringList(_draftKey);
    String? preferredCategory;
    if (values != null && values.length == 4) {
      _scope = CommunityScopeX.fromId(values[0]);
      preferredCategory = values[1].isEmpty ? null : values[1];
      _title.text = values[2];
      _content.text = values[3];
    }
    await _loadCategories(preferredCategory: preferredCategory);
  }

  Future<void> _saveDraft() async {
    if (_title.text.isEmpty && _content.text.isEmpty) return;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setStringList(_draftKey, [
      _scope.id,
      _category ?? '',
      _title.text,
      _content.text,
    ]);
  }

  Future<void> _clearDraft() async {
    _draftTimer?.cancel();
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_draftKey);
  }

  Future<void> _loadCategories({String? preferredCategory}) async {
    final rows = await widget.repository.categories(_scope);
    if (mounted)
      setState(() {
        _categories = rows;
        _category = rows.any((item) => item.id == preferredCategory)
            ? preferredCategory
            : rows.firstOrNull?.id;
      });
  }

  Future<void> _chooseCategory() async {
    FocusScope.of(context).unfocus();
    final selected = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: Text(
              'Choisir un sujet',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
            ),
          ),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: 12),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final item = _categories[index];
                final selected = item.id == _category;
                return ListTile(
                  minTileHeight: 54,
                  leading: Icon(
                    selected ? Icons.tag_rounded : Icons.tag_outlined,
                    color: selected ? _scope.color : null,
                  ),
                  title: Text(
                    item.label,
                    style: TextStyle(
                      fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                    ),
                  ),
                  trailing: selected
                      ? Icon(Icons.check_circle_rounded, color: _scope.color)
                      : null,
                  onTap: () => Navigator.pop(context, item.id),
                );
              },
            ),
          ),
        ],
      ),
    );
    if (selected != null && mounted) {
      setState(() => _category = selected);
      await _saveDraft();
    }
  }

  @override
  void dispose() {
    _draftTimer?.cancel();
    _title.removeListener(_refreshComposer);
    _content.removeListener(_refreshComposer);
    _title.dispose();
    _content.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    try {
      final postId = await widget.repository.createPost(
        scope: _scope,
        categoryId: _category!,
        title: _title.text,
        content: _content.text,
      );
      await _clearDraft();
      if (mounted) Navigator.pop(context, postId);
    } on PostgrestException catch (error) {
      if (mounted) {
        final message = switch (error.code) {
          '42501' => 'Tu n’as pas l’autorisation de publier dans cet espace.',
          '23505' => 'Cette publication a déjà été envoyée.',
          _ => 'Publication impossible. Vérifie ta connexion et réessaie.',
        };
        showCommunityNotice(context, message, type: CommunityNoticeType.error);
      }
    } catch (_) {
      if (mounted) {
        showCommunityNotice(
          context,
          'Publication impossible. Vérifie ta connexion.',
          type: CommunityNoticeType.error,
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  bool get _canPublish =>
      _title.text.trim().length >= 10 &&
      _content.text.trim().length >= 20 &&
      _category != null;

  InputDecoration _fieldDecoration(
    BuildContext context, {
    required String hint,
    required IconData icon,
  }) {
    final colors = Theme.of(context).colorScheme;
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: colors.onSurfaceVariant.withOpacity(.72)),
      prefixIcon: Icon(icon, size: 21),
      filled: true,
      fillColor: colors.surfaceContainerHighest.withOpacity(.42),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: colors.outlineVariant),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: colors.outlineVariant.withOpacity(.7)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: _scope.color, width: 1.8),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: colors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: colors.error, width: 1.8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final keyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: const Text(
          'Créer une publication',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Form(
          key: _formKey,
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.fromLTRB(18, 12, 18, keyboardOpen ? 24 : 116),
            children: [
              Text(
                'Module de publication',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'La publication sera envoyée dans ton module actif.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 58,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: _scope.color.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: _scope.color.withValues(alpha: .32),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(_scope.icon, color: _scope.color),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _scope.label,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                    Icon(Icons.lock_rounded, color: _scope.color, size: 18),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              FormField<String>(
                key: ValueKey('$_scope-$_category'),
                initialValue: _category,
                validator: (value) => value == null ? 'Choisis un sujet' : null,
                builder: (field) {
                  final selected = _categories
                      .where((item) => item.id == _category)
                      .firstOrNull;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Semantics(
                        button: true,
                        label: 'Choisir le sujet de la publication',
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () async {
                            await _chooseCategory();
                            field.didChange(_category);
                          },
                          child: Container(
                            constraints: const BoxConstraints(minHeight: 54),
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              color: colors.surfaceContainerHighest.withOpacity(
                                .38,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: field.hasError
                                    ? colors.error
                                    : colors.outlineVariant.withOpacity(.7),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.tag_rounded,
                                  size: 20,
                                  color: _scope.color,
                                ),
                                const SizedBox(width: 11),
                                Expanded(
                                  child: Text(
                                    selected?.label ?? 'Choisir un sujet',
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const Icon(Icons.keyboard_arrow_down_rounded),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (field.hasError)
                        Padding(
                          padding: const EdgeInsets.only(left: 14, top: 6),
                          child: Text(
                            field.errorText!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colors.error,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 22),
              Text(
                'Ta publication',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _title,
                maxLength: 120,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.next,
                style: const TextStyle(fontWeight: FontWeight.w700),
                decoration:
                    _fieldDecoration(
                      context,
                      hint: 'Un titre clair et précis',
                      icon: Icons.title_rounded,
                    ).copyWith(
                      counterText: _title.text.length >= 90
                          ? '${_title.text.length}/120'
                          : '',
                    ),
                validator: (value) => (value?.trim().length ?? 0) < 10
                    ? 'Le titre doit contenir au moins 10 caractères'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _content,
                minLines: 7,
                maxLines: 14,
                maxLength: 10000,
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.multiline,
                decoration:
                    _fieldDecoration(
                      context,
                      hint:
                          'Explique ta question, ton expérience ou ton conseil…',
                      icon: Icons.notes_rounded,
                    ).copyWith(
                      alignLabelWithHint: true,
                      prefixIconConstraints: const BoxConstraints(
                        minWidth: 52,
                        minHeight: 52,
                      ),
                      counterText: _content.text.length >= 9000
                          ? '${_content.text.length}/10 000'
                          : '',
                    ),
                validator: (value) => (value?.trim().length ?? 0) < 20
                    ? 'Ajoute au moins 20 caractères pour donner du contexte'
                    : null,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(
                    Icons.verified_user_outlined,
                    size: 17,
                    color: colors.onSurfaceVariant,
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      'Reste respectueux et ne partage aucune donnée personnelle.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: keyboardOpen
          ? null
          : SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
                decoration: BoxDecoration(
                  color: colors.surface,
                  border: Border(
                    top: BorderSide(
                      color: colors.outlineVariant.withOpacity(.5),
                    ),
                  ),
                ),
                child: Semantics(
                  button: true,
                  label: 'Publier dans la communauté',
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(54),
                      backgroundColor: _scope.color,
                      disabledBackgroundColor: colors.surfaceContainerHighest,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: _saving || !_canPublish ? null : _save,
                    icon: _saving
                        ? const SizedBox.square(
                            dimension: 19,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.send_rounded),
                    label: Text(
                      _saving ? 'Publication…' : 'Publier maintenant',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

class _CommunityComposeButton extends StatelessWidget {
  const _CommunityComposeButton({required this.color, required this.onPressed});

  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Semantics(
      button: true,
      label: 'Créer une publication',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            onPressed();
          },
          borderRadius: BorderRadius.circular(18),
          child: Ink(
            height: 54,
            padding: const EdgeInsets.fromLTRB(8, 7, 17, 7),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: dark
                    ? [color.withValues(alpha: .96), color]
                    : [color, Color.lerp(color, Colors.black, .16)!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withValues(alpha: .18)),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: dark ? .28 : .34),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .16),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(
                    Icons.add_rounded,
                    size: 25,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Créer',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CommunityPostPage extends StatefulWidget {
  const CommunityPostPage({
    super.key,
    required this.post,
    required this.repository,
    this.initialCommentId,
  });
  final CommunityPost post;
  final CommunityRepository repository;
  final String? initialCommentId;
  @override
  State<CommunityPostPage> createState() => _CommunityPostPageState();
}

class _CommunityPostPageState extends State<CommunityPostPage> {
  static const _rootPageSize = 20;
  static const _replyPageSize = 10;
  final _controller = TextEditingController();
  final _replyFocus = FocusNode();
  List<CommunityComment> _comments = [];
  final Map<String, List<CommunityComment>> _repliesByParent = {};
  final Map<String, int> _localReplyIncrements = {};
  final Set<String> _loadingReplies = {};
  final Set<String> _hiddenReplies = {};
  final Set<String> _expandedComments = {};
  final Map<String, GlobalKey> _commentKeys = {};
  List<CommunityPublicIdentity> _likers = [];
  bool _loading = true, _sending = false, _subscribed = false;
  bool _loadingMoreRoots = false;
  int _totalCommentCount = 0;
  int _rootCommentCount = 0;
  int _pendingNewReplies = 0;
  String _commentSort = 'relevant';
  bool _solutionsOnly = false;
  RealtimeChannel? _commentChannel;
  Timer? _draftDebounce;
  DateTime? _lastCommentSentAt;
  CommunityComment? _replyingTo;
  late bool _liked = widget.post.liked;
  late bool _bookmarked = widget.post.bookmarked;
  late int _reactionCount = widget.post.reactionCount;
  CommunityScope? _writeScope;
  bool get _readOnly => _writeScope != widget.post.scope;
  @override
  void initState() {
    super.initState();
    _load();
    _loadSubscription();
    _loadWriteScope();
    _initCommentRealtime();
    _restoreDraft();
    _controller.addListener(_scheduleDraftSave);
  }

  String get _draftKey => 'community_comment_draft_${widget.post.id}';

  Future<void> _restoreDraft() async {
    final preferences = await SharedPreferences.getInstance();
    final draft = preferences.getString(_draftKey) ?? '';
    if (mounted && _controller.text.isEmpty && draft.trim().isNotEmpty) {
      _controller.text = draft;
      _controller.selection = TextSelection.collapsed(offset: draft.length);
    }
  }

  void _scheduleDraftSave() {
    _draftDebounce?.cancel();
    _draftDebounce = Timer(const Duration(milliseconds: 450), () async {
      final preferences = await SharedPreferences.getInstance();
      final value = _controller.text;
      if (value.trim().isEmpty) {
        await preferences.remove(_draftKey);
      } else {
        await preferences.setString(_draftKey, value);
      }
    });
  }

  void _initCommentRealtime() {
    _commentChannel = widget.repository.subscribeToPostComments(
      widget.post.id,
      (record) {
        if (!mounted || record['author_id'] == widget.repository.userId) return;
        setState(() => _pendingNewReplies++);
      },
    );
  }

  Future<void> _loadWriteScope() async {
    final value = await widget.repository.activeScope();
    if (mounted) setState(() => _writeScope = value);
  }

  Future<void> _loadSubscription() async {
    final value = await widget.repository.isSubscribed(widget.post.id);
    if (mounted) setState(() => _subscribed = value);
  }

  Future<void> _toggleSubscription() async {
    final value = await widget.repository.toggleSubscription(widget.post.id);
    if (mounted) {
      setState(() => _subscribed = value);
      showCommunityNotice(
        context,
        value ? 'Discussion suivie' : 'Suivi désactivé',
        type: value ? CommunityNoticeType.success : CommunityNoticeType.info,
      );
    }
  }

  Future<void> _share() async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(
              title: Text(
                'Partager la publication',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.ios_share_rounded),
              title: const Text('Partager avec une autre application'),
              onTap: () => Navigator.pop(context, 'system'),
            ),
            ListTile(
              leading: const Icon(Icons.chat_bubble_outline_rounded),
              title: const Text('Envoyer dans une conversation COP’IQ'),
              onTap: () => Navigator.pop(context, 'internal'),
            ),
          ],
        ),
      ),
    );
    if (choice == 'system') {
      final link = 'https://copiqpolice.app/forum/${widget.post.id}';
      await Share.share('${widget.post.title}\n$link');
      await widget.repository.recordShare(widget.post.id, 'system');
    } else if (choice == 'internal' && mounted) {
      final rooms = await widget.repository.rooms();
      if (!mounted) return;
      final room = await showModalBottomSheet<CommunityRoom>(
        context: context,
        builder: (context) => SafeArea(
          child: rooms.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(28),
                  child: Text('Aucune conversation disponible.'),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: rooms.length,
                  itemBuilder: (context, index) => ListTile(
                    leading: const Icon(Icons.chat_rounded),
                    title: Text(rooms[index].title),
                    subtitle: Text(rooms[index].scope.label),
                    onTap: () => Navigator.pop(context, rooms[index]),
                  ),
                ),
        ),
      );
      if (room != null) {
        await widget.repository.shareToRoom(room.id, widget.post);
        if (mounted) {
          showCommunityNotice(
            context,
            'Publication envoyée dans la conversation',
            type: CommunityNoticeType.success,
          );
        }
      }
    }
  }

  Future<void> _load() async {
    final values = await Future.wait([
      widget.repository.comments(
        widget.post.id,
        limit: _rootPageSize,
        sort: _commentSort,
        solutionsOnly: _solutionsOnly,
      ),
      widget.repository.postLikers(widget.post.id),
      widget.repository.commentCount(widget.post.id),
      widget.repository.commentCount(widget.post.id, topLevelOnly: true),
    ]);
    if (mounted)
      setState(() {
        _repliesByParent.clear();
        _localReplyIncrements.clear();
        _hiddenReplies.clear();
        _comments = values[0] as List<CommunityComment>;
        _likers = values[1] as List<CommunityPublicIdentity>;
        _totalCommentCount = values[2] as int;
        _rootCommentCount = values[3] as int;
        _reactionCount = _likers.length;
        _liked = _likers.any(
          (person) => person.userId == widget.repository.userId,
        );
        _loading = false;
      });
    if (widget.initialCommentId != null) {
      await _revealComment(widget.initialCommentId!);
    }
  }

  Future<void> _toggleLike() async {
    if (_readOnly) {
      showCommunityNotice(
        context,
        'Cet espace est en lecture seule pour ton profil',
        type: CommunityNoticeType.info,
      );
      return;
    }
    final oldLiked = _liked;
    setState(() {
      _liked = !oldLiked;
      _reactionCount += oldLiked ? -1 : 1;
    });
    try {
      await widget.repository.toggleLike(
        widget.post.copyWith(liked: oldLiked, reactionCount: _reactionCount),
      );
      _likers = await widget.repository.postLikers(widget.post.id);
      if (mounted) setState(() => _reactionCount = _likers.length);
    } catch (_) {
      if (mounted) {
        setState(() {
          _liked = oldLiked;
          _reactionCount += oldLiked ? 1 : -1;
        });
      }
    }
  }

  Future<void> _toggleBookmark() async {
    final old = _bookmarked;
    setState(() => _bookmarked = !old);
    try {
      await widget.repository.toggleBookmark(
        widget.post.copyWith(bookmarked: old),
      );
    } catch (_) {
      if (mounted) setState(() => _bookmarked = old);
    }
  }

  @override
  void dispose() {
    _draftDebounce?.cancel();
    _controller.removeListener(_scheduleDraftSave);
    final channel = _commentChannel;
    if (channel != null) unawaited(widget.repository.unsubscribe(channel));
    _controller.dispose();
    _replyFocus.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (_readOnly) return;
    if (_controller.text.trim().isEmpty) return;
    final now = DateTime.now();
    if (_lastCommentSentAt != null &&
        now.difference(_lastCommentSentAt!) < const Duration(seconds: 4)) {
      showCommunityNotice(
        context,
        'Attends quelques secondes avant de renvoyer un commentaire.',
        type: CommunityNoticeType.warning,
      );
      return;
    }
    setState(() => _sending = true);
    final replyingTo = _replyingTo;
    try {
      await widget.repository.addComment(
        widget.post.id,
        _controller.text,
        parentId: replyingTo?.id,
      );
      _controller.clear();
      _lastCommentSentAt = now;
      final preferences = await SharedPreferences.getInstance();
      await preferences.remove(_draftKey);
      _replyingTo = null;
      if (replyingTo == null) {
        await _load();
      } else {
        _localReplyIncrements.update(
          replyingTo.id,
          (value) => value + 1,
          ifAbsent: () => 1,
        );
        await _loadReplies(replyingTo, refresh: true);
        final count = await widget.repository.commentCount(widget.post.id);
        if (mounted) setState(() => _totalCommentCount = count);
      }
    } catch (error) {
      if (mounted) {
        showCommunityNotice(
          context,
          error.toString().contains('déjà')
              ? 'Ce commentaire vient déjà d’être envoyé.'
              : 'Envoi impossible pour le moment.',
          type: CommunityNoticeType.error,
        );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(widget.post.scope.label),
      actions: [
        IconButton(
          tooltip: _subscribed ? 'Ne plus suivre' : 'Suivre la discussion',
          onPressed: _toggleSubscription,
          icon: Icon(
            _subscribed
                ? Icons.notifications_active_rounded
                : Icons.notifications_none_rounded,
          ),
        ),
        IconButton(
          tooltip: 'Partager',
          onPressed: _share,
          icon: const Icon(Icons.ios_share_rounded),
        ),
        PopupMenuButton<String>(
          tooltip: 'Gérer la publication',
          onSelected: (v) async {
            if (v == 'report') await _report();
            if (v == 'delete') await _delete();
            if (v == 'profile') {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                      CommunityProfilePage(userId: widget.post.authorId),
                ),
              );
            }
          },
          itemBuilder: (_) {
            final mine = widget.post.authorId == widget.repository.userId;
            return [
              const PopupMenuItem(
                value: 'profile',
                child: ListTile(
                  leading: Icon(Icons.person_outline_rounded),
                  title: Text('Voir le profil'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              if (mine)
                const PopupMenuItem(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(Icons.delete_outline_rounded),
                    title: Text('Supprimer'),
                    contentPadding: EdgeInsets.zero,
                  ),
                )
              else
                const PopupMenuItem(
                  value: 'report',
                  child: ListTile(
                    leading: Icon(Icons.flag_outlined),
                    title: Text('Signaler'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
            ];
          },
        ),
      ],
    ),
    body: _postBody(context),
  );

  Widget _postBody(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 24),
            children: [
              Container(
                padding: const EdgeInsets.all(17),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: colors.outlineVariant),
                  boxShadow: [
                    BoxShadow(
                      color: widget.post.scope.color.withValues(alpha: .07),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _authorHeader(context),
                    const SizedBox(height: 17),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _PostMetaChip(
                          icon: widget.post.scope.icon,
                          label: widget.post.scope.label,
                          color: widget.post.scope.color,
                        ),
                        _PostMetaChip(
                          icon: Icons.tag_rounded,
                          label: widget.post.categoryLabel,
                          color: colors.onSurfaceVariant,
                        ),
                      ],
                    ),
                    const SizedBox(height: 17),
                    Text(
                      widget.post.title,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: -.4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.post.content,
                      style: theme.textTheme.bodyLarge?.copyWith(height: 1.55),
                    ),
                    const SizedBox(height: 20),
                    Divider(color: colors.outlineVariant, height: 1),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _SocialAction(
                          icon: _liked
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          label: _reactionCount == 0
                              ? 'J’aime'
                              : '$_reactionCount',
                          selected: _liked,
                          color: const Color(0xFFFF5364),
                          onTap: _toggleLike,
                          onLongPress: _showLikers,
                        ),
                        _SocialAction(
                          icon: Icons.chat_bubble_outline_rounded,
                          label: '${_comments.length}',
                          onTap: () => _focusReply(),
                        ),
                        const Spacer(),
                        IconButton(
                          tooltip: _bookmarked ? 'Retirer' : 'Enregistrer',
                          onPressed: _toggleBookmark,
                          icon: Icon(
                            _bookmarked
                                ? Icons.bookmark_rounded
                                : Icons.bookmark_border_rounded,
                          ),
                        ),
                        IconButton(
                          tooltip: 'Partager',
                          onPressed: _share,
                          icon: const Icon(Icons.ios_share_rounded),
                        ),
                      ],
                    ),
                    if (_reactionCount > 0) ...[
                      const SizedBox(height: 7),
                      InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: _showLikers,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            children: [
                              _LikerStack(
                                likers: _likers,
                                color: widget.post.scope.color,
                              ),
                              const SizedBox(width: 9),
                              Expanded(
                                child: Text(
                                  _likers.isEmpty
                                      ? 'Voir les personnes qui aiment'
                                      : _likers.length == 1
                                      ? '${_likers.first.displayName} aime cette publication'
                                      : '${_likers.first.displayName} et ${_likers.length - 1} autre${_likers.length > 2 ? 's' : ''}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: colors.onSurfaceVariant,
                                  ),
                                ),
                              ),
                              const Icon(Icons.chevron_right_rounded, size: 18),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Text(
                    'Réponses',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: colors.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text('$_totalCommentCount'),
                  ),
                  const Spacer(),
                  PopupMenuButton<String>(
                    tooltip: 'Trier les commentaires',
                    initialValue: _solutionsOnly ? 'solutions' : _commentSort,
                    onSelected: (value) async {
                      setState(() {
                        _solutionsOnly = value == 'solutions';
                        if (!_solutionsOnly) _commentSort = value;
                        _loading = true;
                      });
                      await _load();
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(
                        value: 'relevant',
                        child: Text('Plus pertinents'),
                      ),
                      PopupMenuItem(
                        value: 'recent',
                        child: Text('Plus récents'),
                      ),
                      PopupMenuItem(
                        value: 'oldest',
                        child: Text('Plus anciens'),
                      ),
                      PopupMenuDivider(),
                      PopupMenuItem(
                        value: 'solutions',
                        child: Text('Solutions uniquement'),
                      ),
                    ],
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: colors.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.tune_rounded, size: 17),
                          SizedBox(width: 5),
                          Text(
                            'Trier',
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (_pendingNewReplies > 0) ...[
                FilledButton.icon(
                  onPressed: () async {
                    setState(() {
                      _pendingNewReplies = 0;
                      _loading = true;
                    });
                    await _load();
                  },
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(
                    '$_pendingNewReplies nouvelle${_pendingNewReplies > 1 ? 's' : ''} réponse${_pendingNewReplies > 1 ? 's' : ''}',
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: widget.post.scope.color,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
              ],
              if (_loading)
                const Padding(
                  padding: EdgeInsets.all(30),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (_comments.isEmpty)
                _emptyReplies(context)
              else ...[
                ..._commentThreads(context),
                if (_comments.length < _rootCommentCount)
                  _moreRootCommentsButton(context),
              ],
            ],
          ),
        ),
        if (_readOnly) _readOnlyBar(context) else _replyComposer(context),
      ],
    );
  }

  Widget _authorHeader(BuildContext context) => InkWell(
    borderRadius: BorderRadius.circular(16),
    onTap: () => Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CommunityProfilePage(userId: widget.post.authorId),
      ),
    ),
    child: Row(
      children: [
        CommunityAvatar(
          name: widget.post.authorDisplayName,
          color: widget.post.scope.color,
          avatarIndex: widget.post.authorAvatarIndex,
          size: 50,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      widget.post.authorDisplayName,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  UserVerificationBadge(
                    type: UserBadgeType.fromString(widget.post.authorBadgeType),
                    size: 16,
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                '@${widget.post.authorUsername} · ${communityFullDateTime(widget.post.createdAt)}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const Icon(Icons.chevron_right_rounded, size: 20),
      ],
    ),
  );

  Widget _emptyReplies(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 28),
    decoration: BoxDecoration(
      color: Theme.of(
        context,
      ).colorScheme.surfaceContainerHighest.withValues(alpha: .32),
      borderRadius: BorderRadius.circular(22),
    ),
    child: Column(
      children: [
        Icon(
          Icons.forum_outlined,
          size: 29,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(height: 10),
        const Text(
          'Lance la conversation',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 4),
        Text(
          'Sois la première personne à répondre.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    ),
  );

  List<Widget> _commentThreads(BuildContext context) {
    final widgets = <Widget>[];
    void append(CommunityComment comment, int depth, Set<String> branch) {
      if (!branch.add(comment.id)) return;
      widgets.add(_commentCard(context, comment, depth: depth));
      final loaded = _repliesByParent[comment.id] ?? const <CommunityComment>[];
      if (!_hiddenReplies.contains(comment.id)) {
        for (final reply in loaded) {
          append(reply, depth + 1, {...branch});
        }
      }
      if (comment.replyCount > 0) {
        widgets.add(_replyPaginationButton(context, comment, depth, loaded));
      }
    }

    for (final root in _comments) {
      append(root, 0, <String>{});
    }
    return widgets;
  }

  Future<void> _loadMoreRoots() async {
    if (_loadingMoreRoots) return;
    setState(() => _loadingMoreRoots = true);
    try {
      final page = await widget.repository.comments(
        widget.post.id,
        offset: _comments.length,
        limit: _rootPageSize,
        sort: _commentSort,
        solutionsOnly: _solutionsOnly,
      );
      if (mounted) {
        setState(() {
          final known = _comments.map((comment) => comment.id).toSet();
          _comments.addAll(page.where((comment) => known.add(comment.id)));
        });
      }
    } finally {
      if (mounted) setState(() => _loadingMoreRoots = false);
    }
  }

  Future<void> _loadReplies(
    CommunityComment parent, {
    bool refresh = false,
  }) async {
    if (!_loadingReplies.add(parent.id)) return;
    setState(() => _hiddenReplies.remove(parent.id));
    try {
      final current = refresh
          ? const <CommunityComment>[]
          : (_repliesByParent[parent.id] ?? const <CommunityComment>[]);
      final refreshLimit =
          (_repliesByParent[parent.id]?.length ?? _replyPageSize).clamp(
            _replyPageSize,
            100,
          );
      final page = await widget.repository.comments(
        widget.post.id,
        parentId: parent.id,
        offset: current.length,
        limit: refresh ? refreshLimit : _replyPageSize,
        sort: 'recent',
      );
      if (mounted) {
        setState(() {
          if (refresh) {
            _repliesByParent[parent.id] = page;
          } else {
            final known = current.map((comment) => comment.id).toSet();
            _repliesByParent[parent.id] = [
              ...current,
              ...page.where((comment) => known.add(comment.id)),
            ];
          }
        });
      }
    } catch (_) {
      if (mounted) {
        showCommunityNotice(
          context,
          'Impossible de charger les réponses.',
          type: CommunityNoticeType.error,
        );
      }
    } finally {
      _loadingReplies.remove(parent.id);
      if (mounted) setState(() {});
    }
  }

  Widget _replyPaginationButton(
    BuildContext context,
    CommunityComment parent,
    int depth,
    List<CommunityComment> loaded,
  ) {
    final hidden = _hiddenReplies.contains(parent.id);
    final loading = _loadingReplies.contains(parent.id);
    final databaseCount =
        parent.replyCount + (_localReplyIncrements[parent.id] ?? 0);
    final effectiveCount = databaseCount < loaded.length
        ? loaded.length
        : databaseCount;
    final remaining = (effectiveCount - loaded.length).clamp(0, effectiveCount);
    final nextCount = remaining.clamp(0, _replyPageSize);
    final label = hidden
        ? 'Afficher les $effectiveCount réponse${effectiveCount > 1 ? 's' : ''}'
        : loaded.isEmpty
        ? 'Voir les $effectiveCount réponse${effectiveCount > 1 ? 's' : ''}'
        : remaining > 0
        ? 'Voir $nextCount réponse${nextCount > 1 ? 's' : ''} supplémentaire${nextCount > 1 ? 's' : ''}'
        : 'Masquer les réponses';
    return Padding(
      padding: EdgeInsets.only(
        left: ((depth + 1).clamp(1, 2) * 22) + 42,
        bottom: 10,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          onPressed: loading
              ? null
              : () {
                  if (hidden) {
                    setState(() => _hiddenReplies.remove(parent.id));
                  } else if (loaded.isNotEmpty && remaining == 0) {
                    setState(() => _hiddenReplies.add(parent.id));
                  } else {
                    _loadReplies(parent);
                  }
                },
          icon: loading
              ? const SizedBox.square(
                  dimension: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(
                  hidden || remaining > 0
                      ? Icons.keyboard_arrow_down_rounded
                      : Icons.keyboard_arrow_up_rounded,
                  size: 20,
                ),
          label: Text(label),
          style: TextButton.styleFrom(
            minimumSize: const Size(44, 42),
            foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
            textStyle: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
      ),
    );
  }

  Widget _moreRootCommentsButton(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 2, bottom: 12),
    child: OutlinedButton.icon(
      onPressed: _loadingMoreRoots ? null : _loadMoreRoots,
      icon: _loadingMoreRoots
          ? const SizedBox.square(
              dimension: 17,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.expand_more_rounded),
      label: Text(
        'Voir ${(_rootCommentCount - _comments.length).clamp(0, _rootPageSize)} autres discussions',
      ),
    ),
  );

  Future<void> _revealComment(String commentId) async {
    try {
      final chain = <CommunityComment>[];
      var current = await widget.repository.comment(commentId);
      chain.add(current);
      while (current.parentId != null && chain.length < 12) {
        current = await widget.repository.comment(current.parentId!);
        chain.add(current);
      }
      final ordered = chain.reversed.toList();
      if (!mounted) return;
      setState(() {
        final root = ordered.first;
        if (!_comments.any((comment) => comment.id == root.id)) {
          _comments.insert(0, root);
        }
        for (var index = 0; index < ordered.length - 1; index++) {
          final parent = ordered[index];
          final child = ordered[index + 1];
          final values = _repliesByParent.putIfAbsent(parent.id, () => []);
          if (!values.any((comment) => comment.id == child.id))
            values.add(child);
          _hiddenReplies.remove(parent.id);
        }
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final target = _commentKeys[commentId]?.currentContext;
        if (target != null) {
          Scrollable.ensureVisible(
            target,
            duration: const Duration(milliseconds: 420),
            curve: Curves.easeOutCubic,
            alignment: .2,
          );
        }
      });
    } catch (_) {
      // La publication reste consultable même si le commentaire a été retiré.
    }
  }

  void _replyTo(CommunityComment comment) {
    setState(() {
      _replyingTo = comment;
      if (_controller.text.trim().isEmpty) {
        _controller.text = '@${comment.authorUsername} ';
        _controller.selection = TextSelection.collapsed(
          offset: _controller.text.length,
        );
      }
    });
    _replyFocus.requestFocus();
  }

  List<({String id, IconData icon, String label, bool destructive})>
  _commentMenuItems(CommunityComment comment) {
    final mine = comment.authorId == widget.repository.userId;
    final canChooseSolution =
        widget.post.authorId == widget.repository.userId &&
        comment.status == 'published';
    return [
      if (comment.parentId != null)
        (
          id: 'parent',
          icon: Icons.subdirectory_arrow_left_rounded,
          label: 'Voir le commentaire parent',
          destructive: false,
        ),
      if (comment.reactionCount > 0)
        (
          id: 'likes',
          icon: Icons.favorite_outline_rounded,
          label: 'Voir les mentions J’aime',
          destructive: false,
        ),
      (
        id: 'copy',
        icon: Icons.copy_rounded,
        label: 'Copier le texte',
        destructive: false,
      ),
      if (mine && comment.status == 'published') ...[
        (
          id: 'edit',
          icon: Icons.edit_outlined,
          label: 'Modifier le commentaire',
          destructive: false,
        ),
        (
          id: 'delete',
          icon: Icons.delete_outline_rounded,
          label: 'Supprimer le commentaire',
          destructive: true,
        ),
      ],
      if (canChooseSolution)
        (
          id: 'solution',
          icon: comment.isSolution
              ? Icons.check_circle_rounded
              : Icons.check_circle_outline_rounded,
          label: comment.isSolution
              ? 'Solution choisie'
              : 'Choisir comme solution',
          destructive: false,
        ),
      if (!mine) ...[
        (
          id: 'report',
          icon: Icons.flag_outlined,
          label: 'Signaler le commentaire',
          destructive: false,
        ),
        (
          id: 'block',
          icon: Icons.block_rounded,
          label: 'Bloquer ce membre',
          destructive: true,
        ),
      ],
    ];
  }

  Future<void> _showCommentMenu(CommunityComment comment) async {
    final actions = _commentMenuItems(comment);
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        final theme = Theme.of(sheetContext);
        final colors = theme.colorScheme;
        return SafeArea(
          minimum: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: Material(
            color: colors.surface,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
              side: BorderSide(color: colors.outlineVariant),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colors.outlineVariant,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      CommunityAvatar(
                        name: comment.authorDisplayName,
                        color: widget.post.scope.color,
                        avatarIndex: comment.authorAvatarIndex,
                        size: 38,
                      ),
                      const SizedBox(width: 11),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Actions du commentaire',
                              style: TextStyle(fontWeight: FontWeight.w900),
                            ),
                            Text(
                              '@${comment.authorUsername}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: 'Fermer',
                        onPressed: () => Navigator.pop(sheetContext),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: colors.surfaceContainerHighest.withValues(
                        alpha: .46,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        for (
                          var index = 0;
                          index < actions.length;
                          index++
                        ) ...[
                          if (index > 0)
                            Divider(
                              height: 1,
                              indent: 58,
                              color: colors.outlineVariant.withValues(
                                alpha: .65,
                              ),
                            ),
                          Semantics(
                            button: true,
                            label: actions[index].label,
                            child: ListTile(
                              minTileHeight: 54,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              leading: Container(
                                width: 36,
                                height: 36,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: actions[index].destructive
                                      ? colors.errorContainer.withValues(
                                          alpha: .58,
                                        )
                                      : colors.surface,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  actions[index].icon,
                                  size: 20,
                                  color: actions[index].destructive
                                      ? colors.error
                                      : actions[index].id == 'solution'
                                      ? const Color(0xFF169B62)
                                      : colors.onSurfaceVariant,
                                ),
                              ),
                              title: Text(
                                actions[index].label,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: actions[index].destructive
                                      ? colors.error
                                      : colors.onSurface,
                                ),
                              ),
                              trailing: const Icon(
                                Icons.chevron_right_rounded,
                                size: 19,
                              ),
                              onTap: () => Navigator.pop(
                                sheetContext,
                                actions[index].id,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
    if (selected != null && mounted) {
      await _handleCommentAction(comment, selected);
    }
  }

  Future<void> _handleCommentAction(
    CommunityComment comment,
    String action,
  ) async {
    if (action == 'parent') {
      final target = _commentKeys[comment.parentId]?.currentContext;
      if (target != null) {
        await Scrollable.ensureVisible(
          target,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
          alignment: .18,
        );
      }
    } else if (action == 'likes') {
      await _showCommentLikers(comment);
    } else if (action == 'copy') {
      await Clipboard.setData(ClipboardData(text: comment.content));
      if (mounted)
        showCommunityNotice(
          context,
          'Commentaire copié',
          type: CommunityNoticeType.success,
        );
    } else if (action == 'edit') {
      await _editComment(comment);
    } else if (action == 'delete') {
      await _deleteComment(comment);
    } else if (action == 'report') {
      await _reportComment(comment);
    } else if (action == 'block') {
      await widget.repository.blockUser(comment.authorId);
      if (mounted) {
        showCommunityNotice(
          context,
          '${comment.authorDisplayName} est bloqué',
          type: CommunityNoticeType.success,
        );
        await _load();
      }
    } else if (action == 'solution' && !comment.isSolution) {
      await widget.repository.setSolution(widget.post.id, comment.id);
      await _load();
      if (mounted)
        showCommunityNotice(
          context,
          'Réponse choisie comme solution',
          type: CommunityNoticeType.success,
        );
    }
  }

  void _replaceComment(CommunityComment fresh) {
    setState(() {
      final root = _comments.indexWhere((item) => item.id == fresh.id);
      if (root >= 0) _comments[root] = fresh;
      for (final replies in _repliesByParent.values) {
        final index = replies.indexWhere((item) => item.id == fresh.id);
        if (index >= 0) replies[index] = fresh;
      }
    });
  }

  Future<void> _refreshComment(CommunityComment comment) async =>
      _replaceComment(await widget.repository.comment(comment.id));

  Future<void> _toggleCommentLike(CommunityComment comment) async {
    try {
      await widget.repository.toggleCommentLike(comment);
      await _refreshComment(comment);
    } catch (_) {
      if (mounted)
        showCommunityNotice(
          context,
          'Impossible de mettre à jour la réaction',
          type: CommunityNoticeType.error,
        );
    }
  }

  Future<void> _showCommentLikers(CommunityComment comment) async {
    final people = await widget.repository.commentLikers(comment.id);
    if (!mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          children: [
            const ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Mentions J’aime',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
            for (final person in people)
              ListTile(
                leading: CommunityAvatar(
                  name: person.displayName,
                  color: widget.post.scope.color,
                  avatarIndex: person.avatarIndex,
                  size: 42,
                ),
                title: Text(
                  person.displayName,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                subtitle: Text('@${person.username}'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          CommunityProfilePage(userId: person.userId),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _editComment(CommunityComment comment) async {
    final field = TextEditingController(text: comment.content);
    final content = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Modifier le commentaire'),
        content: TextField(
          controller: field,
          minLines: 3,
          maxLines: 8,
          maxLength: 3000,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, field.text.trim()),
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
    field.dispose();
    if (content == null || content.length < 2) return;
    await widget.repository.updateOwnComment(comment.id, content);
    await _refreshComment(comment);
  }

  Future<void> _deleteComment(CommunityComment comment) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Supprimer ce commentaire ?'),
        content: const Text(
          'Le texte sera retiré. Les réponses resteront visibles pour préserver la discussion.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await widget.repository.deleteOwnComment(comment.id);
    await _refreshComment(comment);
  }

  Future<void> _reportComment(CommunityComment comment) async {
    final reason = await showCommunityReportSheet(context);
    if (reason == null) return;
    await widget.repository.reportComment(widget.post, comment.id, reason);
    if (mounted)
      showCommunityNotice(
        context,
        'Signalement transmis à la modération',
        type: CommunityNoticeType.success,
      );
  }

  Widget _moderationPlaceholder(BuildContext context, String status) {
    final label = switch (status) {
      'deleted_by_author' => 'Commentaire supprimé par son auteur',
      'pending_review' => 'Commentaire en cours de vérification',
      _ => 'Commentaire retiré par la modération',
    };
    return Row(
      children: [
        Icon(
          Icons.shield_outlined,
          size: 17,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _openMention(String username) async {
    final results = await widget.repository.searchProfiles(username);
    final normalized = username.toLowerCase();
    final profile = results
        .where((item) => item.username.toLowerCase() == normalized)
        .firstOrNull;
    if (profile != null && mounted) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => CommunityProfilePage(userId: profile.userId),
        ),
      );
    }
  }

  Widget _commentContent(BuildContext context, CommunityComment comment) {
    final mention = RegExp(r'@[A-Za-z0-9_.-]{2,30}');
    final matches = mention.allMatches(comment.content).toList();
    if (matches.isEmpty) {
      return Text(
        comment.content,
        maxLines: _expandedComments.contains(comment.id) ? null : 8,
        overflow: _expandedComments.contains(comment.id)
            ? TextOverflow.visible
            : TextOverflow.ellipsis,
        style: const TextStyle(height: 1.45),
      );
    }
    final spans = <InlineSpan>[];
    var cursor = 0;
    for (final match in matches) {
      if (match.start > cursor) {
        spans.add(
          TextSpan(text: comment.content.substring(cursor, match.start)),
        );
      }
      spans.add(
        TextSpan(
          text: match.group(0),
          style: TextStyle(
            color: widget.post.scope.color,
            fontWeight: FontWeight.w800,
          ),
        ),
      );
      cursor = match.end;
    }
    if (cursor < comment.content.length) {
      spans.add(TextSpan(text: comment.content.substring(cursor)));
    }
    return GestureDetector(
      onTap: () => _openMention(matches.first.group(0)!.substring(1)),
      child: Text.rich(
        TextSpan(
          style: DefaultTextStyle.of(context).style.copyWith(height: 1.45),
          children: spans,
        ),
        maxLines: _expandedComments.contains(comment.id) ? null : 8,
        overflow: _expandedComments.contains(comment.id)
            ? TextOverflow.visible
            : TextOverflow.ellipsis,
      ),
    );
  }

  Widget _commentCard(
    BuildContext context,
    CommunityComment comment, {
    required int depth,
  }) => Padding(
    key: _commentKeys.putIfAbsent(comment.id, () => GlobalKey()),
    padding: EdgeInsets.only(
      left: depth == 0 ? 0 : (depth.clamp(1, 2) * 22),
      bottom: 10,
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          customBorder: const CircleBorder(),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => CommunityProfilePage(userId: comment.authorId),
            ),
          ),
          child: CommunityAvatar(
            name: comment.authorDisplayName,
            color: widget.post.scope.color,
            avatarIndex: comment.authorAvatarIndex,
            size: depth == 0 ? 40 : 34,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.fromLTRB(14, 11, 14, 12),
            decoration: BoxDecoration(
              color: comment.isSolution
                  ? const Color(0xFF2DCB86).withValues(alpha: .08)
                  : Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(19),
                bottomLeft: Radius.circular(19),
                bottomRight: Radius.circular(19),
                topLeft: Radius.circular(5),
              ),
              border: Border.all(
                color: comment.isSolution
                    ? const Color(0xFF2DCB86).withValues(alpha: .6)
                    : Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        comment.authorDisplayName,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                    const SizedBox(width: 5),
                    UserVerificationBadge(
                      type: UserBadgeType.fromString(comment.authorBadgeType),
                      size: 14,
                    ),
                    const Spacer(),
                    Text(
                      communityShortDateTime(comment.createdAt),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 2),
                    IconButton(
                      tooltip: 'Actions du commentaire',
                      onPressed: () => _showCommentMenu(comment),
                      icon: const Icon(Icons.more_horiz_rounded, size: 20),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 44,
                        minHeight: 44,
                      ),
                    ),
                  ],
                ),
                if (comment.isSolution) ...[
                  const SizedBox(height: 5),
                  const Row(
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        size: 16,
                        color: Color(0xFF169B62),
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Solution choisie',
                        style: TextStyle(
                          color: Color(0xFF169B62),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ],
                Text(
                  '@${comment.authorUsername}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: widget.post.scope.color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                if (comment.status != 'published')
                  _moderationPlaceholder(context, comment.status)
                else ...[
                  _commentContent(context, comment),
                  if (comment.content.length > 280)
                    TextButton(
                      onPressed: () => setState(() {
                        if (!_expandedComments.add(comment.id)) {
                          _expandedComments.remove(comment.id);
                        }
                      }),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(44, 36),
                      ),
                      child: Text(
                        _expandedComments.contains(comment.id)
                            ? 'Réduire'
                            : 'Lire la suite',
                      ),
                    ),
                ],
                if (comment.editedAt != null)
                  Text(
                    'Modifié',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                const SizedBox(height: 4),
                if (comment.status == 'published')
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: _readOnly
                            ? null
                            : () => _toggleCommentLike(comment),
                        style: TextButton.styleFrom(
                          minimumSize: const Size(44, 40),
                          padding: const EdgeInsets.symmetric(horizontal: 7),
                          foregroundColor: comment.liked
                              ? widget.post.scope.color
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        icon: Icon(
                          comment.liked
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          size: 17,
                        ),
                        label: Text(
                          comment.reactionCount == 0
                              ? 'J’aime'
                              : '${comment.reactionCount}',
                        ),
                      ),
                      TextButton.icon(
                        onPressed: _readOnly ? null : () => _replyTo(comment),
                        style: TextButton.styleFrom(
                          minimumSize: const Size(44, 40),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          foregroundColor: widget.post.scope.color,
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        icon: const Icon(Icons.reply_rounded, size: 17),
                        label: const Text('Répondre'),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    ),
  );

  Widget _replyComposer(BuildContext context) => Material(
    color: Theme.of(context).colorScheme.surface,
    elevation: 12,
    shadowColor: Colors.black.withValues(alpha: .22),
    child: SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: _replyingTo == null
                  ? const SizedBox.shrink()
                  : Container(
                      key: ValueKey(_replyingTo!.id),
                      margin: const EdgeInsets.only(bottom: 7),
                      padding: const EdgeInsets.fromLTRB(12, 7, 5, 7),
                      decoration: BoxDecoration(
                        color: widget.post.scope.color.withValues(alpha: .10),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.reply_rounded,
                            size: 18,
                            color: widget.post.scope.color,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Réponse à ${_replyingTo!.authorDisplayName}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: widget.post.scope.color,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          IconButton(
                            tooltip: 'Annuler la réponse ciblée',
                            onPressed: () => setState(() => _replyingTo = null),
                            visualDensity: VisualDensity.compact,
                            icon: const Icon(Icons.close_rounded, size: 19),
                          ),
                        ],
                      ),
                    ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(14, 3, 5, 3),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest.withValues(alpha: .55),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _replyFocus,
                      minLines: 1,
                      maxLines: 5,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: _replyingTo == null
                            ? 'Répondre à la discussion…'
                            : 'Écrire à ${_replyingTo!.authorDisplayName}…',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton.filled(
                    tooltip: 'Envoyer la réponse',
                    onPressed: _sending ? null : _send,
                    style: IconButton.styleFrom(
                      backgroundColor: widget.post.scope.color,
                      foregroundColor: Colors.white,
                    ),
                    icon: _sending
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.arrow_upward_rounded),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _readOnlyBar(BuildContext context) => Material(
    color: Theme.of(context).colorScheme.surface,
    elevation: 10,
    child: SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 11),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest.withValues(alpha: .55),
            borderRadius: BorderRadius.circular(17),
          ),
          child: Row(
            children: [
              const Icon(Icons.lock_outline_rounded, size: 19),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Lecture seule · change de module pour participer',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  void _focusReply() => _replyFocus.requestFocus();

  Future<void> _showLikers() async {
    if (_reactionCount == 0) return;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(sheetContext).height * .66,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                child: Row(
                  children: [
                    const Icon(
                      Icons.favorite_rounded,
                      color: Color(0xFFFF5364),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Aimé par $_reactionCount personne${_reactionCount > 1 ? 's' : ''}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 18),
                  itemCount: _likers.length,
                  itemBuilder: (context, index) {
                    final person = _likers[index];
                    return ListTile(
                      leading: CommunityAvatar(
                        name: person.displayName,
                        color: widget.post.scope.color,
                        avatarIndex: person.avatarIndex,
                      ),
                      title: Row(
                        children: [
                          Flexible(
                            child: Text(
                              person.displayName,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          UserVerificationBadge(
                            type: UserBadgeType.fromString(person.badgeType),
                            size: 14,
                          ),
                        ],
                      ),
                      subtitle: Text('@${person.username}'),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () {
                        Navigator.pop(sheetContext);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                CommunityProfilePage(userId: person.userId),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _report() async {
    final reason = await showCommunityReportSheet(context);
    if (reason != null) {
      await widget.repository.reportPost(widget.post, reason, null);
      if (mounted)
        showCommunityNotice(
          context,
          'Signalement transmis à la modération',
          type: CommunityNoticeType.success,
        );
    }
  }

  Future<void> _delete() async {
    final confirmed = await showDeletePostConfirmation(context);
    if (confirmed != true) return;
    await widget.repository.deleteOwnPost(widget.post);
    if (mounted) Navigator.pop(context, true);
  }
}

class _PostMetaChip extends StatelessWidget {
  const _PostMetaChip({
    required this.icon,
    required this.label,
    required this.color,
  });
  final IconData icon;
  final String label;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: color.withValues(alpha: .1),
      borderRadius: BorderRadius.circular(99),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    ),
  );
}

class _SocialAction extends StatelessWidget {
  const _SocialAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.onLongPress,
    this.selected = false,
    this.color,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final bool selected;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    final foreground = selected
        ? (color ?? Theme.of(context).colorScheme.primary)
        : Theme.of(context).colorScheme.onSurfaceVariant;
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: onTap,
      onLongPress: onLongPress,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 44),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Icon(icon, size: 20, color: foreground),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: foreground,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LikerStack extends StatelessWidget {
  const _LikerStack({required this.likers, required this.color});
  final List<CommunityPublicIdentity> likers;
  final Color color;
  @override
  Widget build(BuildContext context) {
    final visible = likers.take(3).toList(growable: false);
    if (visible.isEmpty) {
      return Container(
        width: 26,
        height: 26,
        decoration: const BoxDecoration(
          color: Color(0xFFFF5364),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.favorite_rounded,
          color: Colors.white,
          size: 14,
        ),
      );
    }
    return SizedBox(
      width: 26 + (visible.length - 1) * 17,
      height: 28,
      child: Stack(
        children: [
          for (var i = 0; i < visible.length; i++)
            Positioned(
              left: i * 17,
              child: CommunityAvatar(
                name: visible[i].displayName,
                color: color,
                avatarIndex: visible[i].avatarIndex,
                size: 28,
              ),
            ),
        ],
      ),
    );
  }
}

Future<bool?> showDeletePostConfirmation(BuildContext context) {
  final theme = Theme.of(context);
  final colors = theme.colorScheme;
  const danger = Color(0xFFFF4D5E);
  return showModalBottomSheet<bool>(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: .72),
    isScrollControlled: true,
    useSafeArea: true,
    builder: (sheetContext) => Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(22, 12, 22, 14),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: colors.outlineVariant.withValues(alpha: .7),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x52000000),
              blurRadius: 40,
              offset: Offset(0, 18),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.onSurfaceVariant.withValues(alpha: .28),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: danger.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(17),
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                color: danger,
                size: 25,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Supprimer cette publication ?',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: -.45,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Elle disparaîtra immédiatement de la communauté. Cette action ne pourra pas être annulée.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: danger,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17),
                  ),
                ),
                onPressed: () => Navigator.pop(sheetContext, true),
                icon: const Icon(Icons.delete_outline_rounded, size: 20),
                label: const Text(
                  'Supprimer définitivement',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: TextButton(
                onPressed: () => Navigator.pop(sheetContext, false),
                child: const Text(
                  'Conserver la publication',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Future<String?> showPostManageSheet(
  BuildContext context, {
  required bool mine,
  required String authorName,
}) {
  final theme = Theme.of(context);
  final colors = theme.colorScheme;
  const danger = Color(0xFFFF5A67);
  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: .66),
    useSafeArea: true,
    builder: (sheetContext) => Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: colors.outlineVariant.withValues(alpha: .65),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x52000000),
              blurRadius: 40,
              offset: Offset(0, 18),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.onSurfaceVariant.withValues(alpha: .28),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Gérer la publication',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: -.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    mine ? 'Choisis une action.' : 'Publication de $authorName',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            _ManageSheetAction(
              icon: Icons.person_outline_rounded,
              title: 'Voir le profil',
              subtitle: 'Photo, activité et informations publiques',
              onTap: () => Navigator.pop(sheetContext, 'profile'),
            ),
            const SizedBox(height: 9),
            _ManageSheetAction(
              icon: mine ? Icons.delete_outline_rounded : Icons.flag_outlined,
              title: mine
                  ? 'Supprimer la publication'
                  : 'Signaler la publication',
              subtitle: mine
                  ? 'La retirer définitivement du forum'
                  : 'Prévenir confidentiellement la modération',
              color: danger,
              onTap: () =>
                  Navigator.pop(sheetContext, mine ? 'delete' : 'report'),
            ),
          ],
        ),
      ),
    ),
  );
}

class _ManageSheetAction extends StatelessWidget {
  const _ManageSheetAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.color,
  });
  final IconData icon;
  final String title, subtitle;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final foreground = color ?? colors.onSurface;
    return Material(
      color: color == null
          ? colors.surfaceContainerHighest.withValues(alpha: .52)
          : color!.withValues(alpha: .08),
      borderRadius: BorderRadius.circular(19),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(19),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 68),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: foreground.withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: foreground, size: 21),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: foreground,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: color == null
                              ? colors.onSurfaceVariant
                              : color!.withValues(alpha: .78),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: foreground.withValues(alpha: .58),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<String?> showCommunityReportSheet(BuildContext context) =>
    showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(
              title: Text(
                'Pourquoi signaler cette publication ?',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
              subtitle: Text('Le signalement sera envoyé à la modération.'),
            ),
            for (final entry in const {
              'spam': 'Spam',
              'harassment': 'Harcèlement',
              'personal_data': 'Données personnelles',
              'fraud': 'Fraude ou arnaque',
              'off_topic': 'Hors sujet',
              'other': 'Autre raison',
            }.entries)
              ListTile(
                leading: const Icon(Icons.flag_outlined),
                title: Text(entry.value),
                onTap: () => Navigator.pop(context, entry.key),
              ),
          ],
        ),
      ),
    );
