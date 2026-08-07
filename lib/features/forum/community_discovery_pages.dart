import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:copiqpolice/core/widgets/user_verification_badge.dart';

import 'community_messaging_page.dart';
import 'community_models.dart';
import 'community_repository.dart';
import 'community_feedback.dart';

class CommunitySearchPage extends StatefulWidget {
  const CommunitySearchPage({super.key, required this.initialScope});
  final CommunityScope initialScope;
  @override
  State<CommunitySearchPage> createState() => _CommunitySearchPageState();
}

class _CommunitySearchPageState extends State<CommunitySearchPage> {
  final _repository = CommunityRepository();
  final _controller = TextEditingController();
  Timer? _debounce;
  late CommunityScope _scope = widget.initialScope;
  List<CommunityPost> _posts = const [];
  List<CommunityPublicProfile> _profiles = const [];
  bool _loading = false;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _changed(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () => _search(value));
    setState(() {});
  }

  Future<void> _search(String value) async {
    final query = value.trim();
    if (query.length < 2) {
      if (mounted)
        setState(() {
          _posts = const [];
          _profiles = const [];
          _loading = false;
        });
      return;
    }
    setState(() => _loading = true);
    try {
      final values = await Future.wait([
        _repository.searchPosts(query, _scope),
        _repository.searchProfiles(query),
      ]);
      if (mounted)
        setState(() {
          _posts = values[0] as List<CommunityPost>;
          _profiles = values[1] as List<CommunityPublicProfile>;
        });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Rechercher')),
    body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 9),
          child: TextField(
            controller: _controller,
            autofocus: true,
            onChanged: _changed,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search_rounded),
              hintText: 'Publications ou membres',
              filled: true,
              fillColor: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withValues(alpha: .36),
              contentPadding: const EdgeInsets.symmetric(vertical: 15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          child: Material(
            color: _scope.color.withValues(alpha: .09),
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              onTap: _chooseScope,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 13),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _scope.color.withValues(alpha: .27),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 31,
                      height: 31,
                      decoration: BoxDecoration(
                        color: _scope.color.withValues(alpha: .13),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(_scope.icon, size: 17, color: _scope.color),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rechercher dans',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                          Text(
                            _scope.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down_rounded),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (_loading) const LinearProgressIndicator(minHeight: 2),
        Expanded(child: _results()),
      ],
    ),
  );

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
                'Filtrer la recherche',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 4),
              Text(
                'Choisis l’espace dans lequel rechercher les publications.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 14),
              for (final scope in CommunityScope.values)
                Padding(
                  padding: const EdgeInsets.only(bottom: 7),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    tileColor: scope == _scope
                        ? scope.color.withValues(alpha: .1)
                        : null,
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: scope.color.withValues(alpha: .12),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Icon(scope.icon, color: scope.color, size: 20),
                    ),
                    title: Text(
                      scope.label,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    trailing: scope == _scope
                        ? Icon(Icons.check_circle_rounded, color: scope.color)
                        : const Icon(Icons.chevron_right_rounded),
                    onTap: () => Navigator.pop(sheetContext, scope),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
    if (selected == null || selected == _scope) return;
    setState(() => _scope = selected);
    await _search(_controller.text);
  }

  Widget _results() {
    if (_controller.text.trim().length < 2)
      return const _Centered(
        icon: Icons.manage_search_rounded,
        text: 'Saisis au moins deux caractères',
      );
    if (!_loading && _posts.isEmpty && _profiles.isEmpty)
      return const _Centered(
        icon: Icons.search_off_rounded,
        text: 'Aucun résultat',
      );
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 30),
      children: [
        if (_profiles.isNotEmpty) ...[
          const _SectionTitle('Membres'),
          ..._profiles.map(
            (profile) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CommunityAvatar(
                name: profile.displayName,
                color: profile.primaryScope.color,
                avatarIndex: profile.avatarIndex,
              ),
              title: Text(
                profile.displayName,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              subtitle: Text(
                '@${profile.username} · ${profile.primaryScope.label}',
              ),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CommunityProfilePage(userId: profile.userId),
                ),
              ),
            ),
          ),
        ],
        if (_posts.isNotEmpty) ...[
          const SizedBox(height: 12),
          const _SectionTitle('Publications'),
          ..._posts.map(
            (post) => Card(
              child: ListTile(
                title: Text(
                  post.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                subtitle: Text(
                  '${post.scope.label} · ${post.content}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => Navigator.pushNamed(context, '/forum/${post.id}'),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class CommunityProfilePage extends StatefulWidget {
  const CommunityProfilePage({super.key, required this.userId});
  final String userId;
  @override
  State<CommunityProfilePage> createState() => _CommunityProfilePageState();
}

class _CommunityProfilePageState extends State<CommunityProfilePage> {
  final _repository = CommunityRepository();
  late Future<CommunityPublicProfile> _future = _repository.profile(
    widget.userId,
  );
  bool _starting = false;

  Future<void> _message(CommunityPublicProfile profile) async {
    setState(() => _starting = true);
    try {
      final id = await _repository.directRoom(profile.userId);
      final rooms = await _repository.rooms();
      final room =
          rooms.where((room) => room.id == id).firstOrNull ??
          CommunityRoom(
            id: id,
            title: profile.username,
            scope: profile.primaryScope,
            updatedAt: DateTime.now(),
          );
      if (mounted)
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                CommunityChatPage(room: room, repository: _repository),
          ),
        );
    } catch (_) {
      if (mounted)
        showCommunityNotice(
          context,
          'Impossible d’ouvrir cette conversation',
          type: CommunityNoticeType.error,
        );
    } finally {
      if (mounted) setState(() => _starting = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Profil communautaire')),
    body: FutureBuilder<CommunityPublicProfile>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return const Center(child: CircularProgressIndicator());
        if (!snapshot.hasData)
          return const _Centered(
            icon: Icons.person_off_rounded,
            text: 'Ce profil n’est pas disponible',
          );
        final profile = snapshot.data!;
        final mine =
            profile.userId == Supabase.instance.client.auth.currentUser?.id;
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 28),
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    profile.primaryScope.color,
                    profile.primaryScope.color.withValues(alpha: .68),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: profile.primaryScope.color.withValues(alpha: .22),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CommunityAvatar(
                    name: profile.displayName,
                    color: profile.primaryScope.color,
                    ringColor: const Color(0xFF2D6CEA),
                    avatarIndex: profile.avatarIndex,
                    size: 96,
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          profile.displayName,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                      ),
                      const SizedBox(width: 7),
                      UserVerificationBadge(
                        type: UserBadgeType.fromString(profile.badgeType),
                        size: 19,
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '@${profile.username}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: .76),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .16),
                      borderRadius: BorderRadius.circular(99),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: .28),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          profile.primaryScope.icon,
                          size: 16,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            profile.primaryScope.label,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            if (profile.bio.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest.withValues(alpha: .38),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  profile.bio,
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(height: 1.5),
                ),
              ),
              const SizedBox(height: 16),
            ],
            Container(
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
              child: Row(
                children: [
                  CommunityStat(
                    label: 'Publications',
                    value: profile.postCount,
                  ),
                  CommunityStat(label: 'Réponses', value: profile.commentCount),
                  CommunityStat(
                    label: 'Solutions',
                    value: profile.solutionsCount,
                  ),
                ],
              ),
            ),
            if (profile.joinedAt != null) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_month_outlined,
                    size: 17,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Membre depuis ${communityMonthYear(profile.joinedAt!)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 20),
            if (!mine)
              FilledButton.icon(
                onPressed: _starting ? null : () => _message(profile),
                icon: _starting
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.chat_bubble_rounded),
                label: const Text('Envoyer un message'),
              ),
            if (mine)
              OutlinedButton.icon(
                onPressed: () => _edit(profile),
                icon: const Icon(Icons.edit_rounded),
                label: const Text('Modifier mon profil'),
              ),
          ],
        );
      },
    ),
  );

  Future<void> _edit(CommunityPublicProfile profile) async {
    final bio = TextEditingController(text: profile.bio);
    bool activity = true,
        joined = true,
        spaces = true,
        displayName = profile.showDisplayName;
    final save = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, local) => Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,
            MediaQuery.viewInsetsOf(context).bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Confidentialité du profil',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: bio,
                maxLength: 300,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Biographie',
                  border: OutlineInputBorder(),
                ),
              ),
              SwitchListTile(
                value: displayName,
                onChanged: (v) => local(() => displayName = v),
                title: const Text('Afficher mon prénom et mon nom'),
                subtitle: const Text('Sinon, seul ton @username sera public.'),
              ),
              SwitchListTile(
                value: activity,
                onChanged: (v) => local(() => activity = v),
                title: const Text('Afficher mes statistiques'),
              ),
              SwitchListTile(
                value: joined,
                onChanged: (v) => local(() => joined = v),
                title: const Text('Afficher ma date d’arrivée'),
              ),
              SwitchListTile(
                value: spaces,
                onChanged: (v) => local(() => spaces = v),
                title: const Text('Afficher mon espace'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
    if (save == true) {
      await _repository.updateOwnCommunityProfile(
        bio: bio.text,
        showActivity: activity,
        showJoinedAt: joined,
        showSpaces: spaces,
        showDisplayName: displayName,
      );
      if (mounted) setState(() => _future = _repository.profile(widget.userId));
    }
    bio.dispose();
  }
}

class CommunityNotificationsPage extends StatefulWidget {
  const CommunityNotificationsPage({super.key});
  @override
  State<CommunityNotificationsPage> createState() =>
      _CommunityNotificationsPageState();
}

class _CommunityNotificationsPageState
    extends State<CommunityNotificationsPage> {
  final _repository = CommunityRepository();
  late Future<List<CommunityNotification>> _future = _repository
      .notifications();
  RealtimeChannel? _channel;
  final Set<String> _selected = {};
  bool _deleting = false;

  bool get _selecting => _selected.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _channel = _repository.subscribeToOwnNotifications(() {
      if (mounted) setState(() => _future = _repository.notifications());
    });
  }

  @override
  void dispose() {
    final channel = _channel;
    if (channel != null) unawaited(_repository.unsubscribe(channel));
    super.dispose();
  }

  String _label(String type) => switch (type) {
    'post_reply' => 'Quelqu’un a répondu à ta publication',
    'comment_reply' => 'Quelqu’un a répondu à ton commentaire',
    'followed_post_reply' => 'Nouvelle réponse dans une discussion suivie',
    'reaction' => 'Nouvelle réaction sur ta publication',
    'comment_reaction' => 'Nouvelle réaction sur ton commentaire',
    'message' => 'Tu as reçu un message',
    _ => 'Nouvelle activité',
  };
  String _title(CommunityNotification item) {
    final actor = item.actorDisplayName.trim();
    if (actor.isEmpty) return _label(item.type);
    return switch (item.type) {
      'message' => '$actor t’a envoyé un message',
      'post_reply' => '$actor a répondu à ta publication',
      'comment_reply' => '$actor a répondu à ton commentaire',
      'followed_post_reply' => '$actor a répondu dans une discussion suivie',
      'reaction' => '$actor a réagi à ta publication',
      'comment_reaction' => '$actor a aimé ton commentaire',
      _ => _label(item.type),
    };
  }

  IconData _icon(String type) => switch (type) {
    'post_reply' ||
    'comment_reply' ||
    'followed_post_reply' => Icons.reply_rounded,
    'reaction' || 'comment_reaction' => Icons.favorite_rounded,
    'message' => Icons.chat_bubble_rounded,
    _ => Icons.notifications_rounded,
  };
  Future<void> _all() async {
    await _repository.markAllNotificationsRead();
    if (mounted) setState(() => _future = _repository.notifications());
  }

  void _toggleSelection(String id) {
    setState(() {
      if (!_selected.add(id)) _selected.remove(id);
    });
  }

  void _startSelection(String id) {
    HapticFeedback.mediumImpact();
    setState(() => _selected.add(id));
  }

  void _cancelSelection() => setState(_selected.clear);

  Future<void> _deleteSelected() async {
    if (_selected.isEmpty || _deleting) return;
    final count = _selected.length;
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => SafeArea(
        minimum: const EdgeInsets.all(12),
        child: Material(
          color: Theme.of(sheetContext).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
            side: BorderSide(
              color: Theme.of(sheetContext).colorScheme.outlineVariant,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 12, 22, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(sheetContext).colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      sheetContext,
                    ).colorScheme.errorContainer.withValues(alpha: .62),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.delete_outline_rounded,
                    color: Theme.of(sheetContext).colorScheme.error,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Supprimer $count notification${count > 1 ? 's' : ''} ?',
                  style: Theme.of(
                    sheetContext,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 7),
                Text(
                  'Elles disparaîtront uniquement de ton centre de notifications.',
                  style: TextStyle(
                    color: Theme.of(sheetContext).colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(sheetContext, false),
                        child: const Text('Annuler'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton(
                        onPressed: () => Navigator.pop(sheetContext, true),
                        style: FilledButton.styleFrom(
                          backgroundColor: Theme.of(
                            sheetContext,
                          ).colorScheme.error,
                          foregroundColor: Theme.of(
                            sheetContext,
                          ).colorScheme.onError,
                        ),
                        child: const Text('Supprimer'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _deleting = true);
    try {
      await _repository.deleteNotifications(_selected);
      if (!mounted) return;
      setState(() {
        _deleting = false;
        _selected.clear();
        _future = _repository.notifications();
      });
      showCommunityNotice(
        context,
        '$count notification${count > 1 ? 's supprimées' : ' supprimée'}.',
        type: CommunityNoticeType.success,
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _deleting = false);
      showCommunityNotice(
        context,
        'Impossible de supprimer les notifications.',
        type: CommunityNoticeType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: _selecting
          ? IconButton(
              tooltip: 'Annuler la sélection',
              onPressed: _cancelSelection,
              icon: const Icon(Icons.close_rounded),
            )
          : null,
      title: Text(
        _selecting
            ? '${_selected.length} sélectionnée${_selected.length > 1 ? 's' : ''}'
            : 'Notifications',
      ),
      actions: [
        if (_selecting) ...[
          IconButton(
            tooltip: 'Tout sélectionner',
            onPressed: () async {
              final rows = await _future;
              if (mounted) {
                setState(() => _selected.addAll(rows.map((item) => item.id)));
              }
            },
            icon: const Icon(Icons.select_all_rounded),
          ),
          IconButton(
            tooltip: 'Supprimer la sélection',
            onPressed: _deleting ? null : _deleteSelected,
            icon: _deleting
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.delete_outline_rounded),
          ),
        ] else
          IconButton(
            tooltip: 'Tout marquer comme lu',
            onPressed: _all,
            icon: const Icon(Icons.done_all_rounded),
          ),
      ],
    ),
    body: FutureBuilder<List<CommunityNotification>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return const Center(child: CircularProgressIndicator());
        final rows = snapshot.data ?? const [];
        if (rows.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest
                          .withValues(alpha: .55),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(
                      Icons.notifications_none_rounded,
                      size: 31,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Tout est à jour',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Les réponses, réactions et messages apparaîtront ici.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        final unreadCount = rows.where((item) => item.readAt == null).length;
        return RefreshIndicator(
          onRefresh: () async =>
              setState(() => _future = _repository.notifications()),
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
            itemCount: rows.length + 1,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(4, 4, 4, 8),
                  child: Text(
                    unreadCount == 0
                        ? 'Aucune nouvelle notification'
                        : '$unreadCount nouvelle${unreadCount > 1 ? 's' : ''} notification${unreadCount > 1 ? 's' : ''}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                );
              }
              final rowIndex = index - 1;
              final item = rows[rowIndex], unread = item.readAt == null;
              final selected = _selected.contains(item.id);
              return Material(
                color: selected
                    ? item.scope.color.withValues(alpha: .16)
                    : unread
                    ? item.scope.color.withValues(alpha: .09)
                    : Theme.of(context).colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: selected
                        ? item.scope.color.withValues(alpha: .72)
                        : unread
                        ? item.scope.color.withValues(alpha: .28)
                        : Theme.of(context).colorScheme.outlineVariant,
                    width: selected ? 1.7 : 1,
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onLongPress: () => _startSelection(item.id),
                  onTap: () =>
                      _selecting ? _toggleSelection(item.id) : _open(item),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        if (item.actorDisplayName.isNotEmpty)
                          CommunityAvatar(
                            name: item.actorDisplayName,
                            color: item.scope.color,
                            avatarIndex: item.actorAvatarIndex,
                            size: 46,
                          )
                        else
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: item.scope.color.withValues(alpha: .13),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Icon(
                              _icon(item.type),
                              color: item.scope.color,
                            ),
                          ),
                        const SizedBox(width: 13),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _title(item),
                                style: TextStyle(
                                  fontWeight: unread
                                      ? FontWeight.w900
                                      : FontWeight.w700,
                                  height: 1.25,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '${item.actorUsername.isNotEmpty ? '@${item.actorUsername} · ' : ''}${item.scope.label} · ${communityShortDateTime(item.createdAt)}',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (selected)
                          Semantics(
                            label: 'Notification sélectionnée',
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: item.scope.color,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check_rounded,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          )
                        else if (unread)
                          Container(
                            width: 9,
                            height: 9,
                            decoration: BoxDecoration(
                              color: item.scope.color,
                              shape: BoxShape.circle,
                            ),
                          )
                        else
                          Icon(
                            Icons.chevron_right_rounded,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    ),
  );

  Future<void> _open(CommunityNotification item) async {
    if (item.readAt == null) await _repository.markNotificationRead(item.id);
    if (!mounted) return;
    if (item.targetType == 'post' && item.targetId != null) {
      Navigator.pushNamed(
        context,
        '/forum/${item.targetId}',
        arguments: {'commentId': item.commentId},
      );
    } else if (item.targetType == 'room' && item.targetId != null) {
      final rooms = await _repository.rooms();
      if (!mounted) return;
      final room = rooms.where((room) => room.id == item.targetId).firstOrNull;
      if (room != null)
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                CommunityChatPage(room: room, repository: _repository),
          ),
        );
    }
    if (mounted) setState(() => _future = _repository.notifications());
  }
}

class CommunityAvatar extends StatelessWidget {
  const CommunityAvatar({
    super.key,
    required this.name,
    required this.color,
    this.size = 44,
    this.avatarIndex = 0,
    this.ringColor,
  });
  final String name;
  final Color color;
  final double size;
  final int avatarIndex;
  final Color? ringColor;
  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Avatar de $name',
    child: Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size >= 80 ? 2.2 : 1.5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ringColor ?? color,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: .2),
            blurRadius: size * .18,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipOval(
        child: avatarIndex >= 1 && avatarIndex <= 20
            ? Transform.scale(
                scale: 1.71,
                child: Image.asset(
                  'assets/icon_profile/$avatarIndex.png',
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      _AvatarFallback(name: name, color: color, size: size),
                ),
              )
            : _AvatarFallback(name: name, color: color, size: size),
      ),
    ),
  );
}

class _AvatarFallback extends StatelessWidget {
  const _AvatarFallback({
    required this.name,
    required this.color,
    required this.size,
  });
  final String name;
  final Color color;
  final double size;
  @override
  Widget build(BuildContext context) => ColoredBox(
    color: Theme.of(context).colorScheme.surface,
    child: Center(
      child: Text(
        name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: size * .34,
          fontWeight: FontWeight.w900,
        ),
      ),
    ),
  );
}

class CommunityStat extends StatelessWidget {
  const CommunityStat({super.key, required this.label, required this.value});
  final String label;
  final int value;
  @override
  Widget build(BuildContext context) => Expanded(
    child: Column(
      children: [
        Text(
          '$value',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ],
    ),
  );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
    ),
  );
}

class _Centered extends StatelessWidget {
  const _Centered({required this.icon, required this.text});
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 54, color: Theme.of(context).colorScheme.outline),
        const SizedBox(height: 12),
        Text(text, textAlign: TextAlign.center),
      ],
    ),
  );
}
