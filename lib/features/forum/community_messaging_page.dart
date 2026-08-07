import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'community_models.dart';
import 'community_repository.dart';
import 'community_feedback.dart';
import 'community_discovery_pages.dart';

class CommunityInboxPage extends StatefulWidget {
  const CommunityInboxPage({super.key});
  @override
  State<CommunityInboxPage> createState() => _CommunityInboxPageState();
}

class _CommunityInboxPageState extends State<CommunityInboxPage> {
  final _repository = CommunityRepository();
  late Future<List<CommunityRoom>> _future = _repository.rooms();
  RealtimeChannel? _notificationChannel;

  @override
  void initState() {
    super.initState();
    _notificationChannel = _repository.subscribeToOwnNotifications(() {
      if (mounted) setState(() => _future = _repository.rooms());
    });
  }

  @override
  void dispose() {
    final channel = _notificationChannel;
    if (channel != null) _repository.unsubscribe(channel);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Messages'),
      actions: [
        IconButton(
          tooltip: 'Nouvelle conversation',
          onPressed: _findMember,
          icon: const Icon(Icons.edit_square),
        ),
      ],
    ),
    body: FutureBuilder<List<CommunityRoom>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return const Center(child: CircularProgressIndicator());
        if (snapshot.hasError)
          return _EmptyState(
            icon: Icons.cloud_off_rounded,
            label: 'Impossible de charger les conversations',
            action: () => setState(() => _future = _repository.rooms()),
          );
        final rooms = snapshot.data ?? const [];
        if (rooms.isEmpty)
          return _EmptyState(
            icon: Icons.mark_chat_unread_outlined,
            label: 'Aucune conversation pour le moment',
            action: _findMember,
            actionLabel: 'Trouver un membre',
          );
        return RefreshIndicator(
          onRefresh: () async => setState(() => _future = _repository.rooms()),
          child: ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: rooms.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final room = rooms[index];
              return ListTile(
                minTileHeight: 68,
                leading: CommunityAvatar(
                  name: room.title,
                  color: room.scope.color,
                  avatarIndex: room.otherAvatarIndex,
                  size: 50,
                ),
                title: Text(
                  room.title,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                subtitle: Text(
                  room.lastMessage.isNotEmpty
                      ? room.lastMessage
                      : room.otherUsername.isNotEmpty
                      ? '@${room.otherUsername}'
                      : room.scope.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: room.unreadCount > 0
                    ? Semantics(
                        label: '${room.unreadCount} message non lu',
                        child: Container(
                          constraints: const BoxConstraints(minWidth: 24),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: room.scope.color,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            room.unreadCount > 99
                                ? '99+'
                                : '${room.unreadCount}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      )
                    : const Icon(Icons.chevron_right_rounded),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        CommunityChatPage(room: room, repository: _repository),
                  ),
                ),
              );
            },
          ),
        );
      },
    ),
  );

  Future<void> _findMember() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            const CommunitySearchPage(initialScope: CommunityScope.global),
      ),
    );
    if (mounted) setState(() => _future = _repository.rooms());
  }
}

class CommunityChatPage extends StatefulWidget {
  const CommunityChatPage({
    super.key,
    required this.room,
    required this.repository,
  });
  final CommunityRoom room;
  final CommunityRepository repository;
  @override
  State<CommunityChatPage> createState() => _CommunityChatPageState();
}

class _CommunityChatPageState extends State<CommunityChatPage> {
  final _text = TextEditingController(), _scroll = ScrollController();
  List<CommunityMessage> _messages = [];
  List<CommunityPublicIdentity> _participants = [];
  bool _loading = true, _sending = false;
  RealtimeChannel? _channel;
  @override
  void initState() {
    super.initState();
    _load();
    _loadParticipants();
    _channel = widget.repository.subscribeToMessages(widget.room.id, _load);
  }

  Future<void> _loadParticipants() async {
    try {
      final values = await widget.repository.roomParticipants(widget.room.id);
      if (mounted) setState(() => _participants = values);
    } catch (_) {
      // Le chat reste utilisable si l'identité décorative est indisponible.
    }
  }

  Future<void> _load() async {
    final rows = await widget.repository.messages(widget.room.id);
    if (!mounted) return;
    setState(() {
      _messages = rows;
      _loading = false;
    });
    await widget.repository.markRoomRead(
      widget.room.id,
      rows.isEmpty ? null : rows.last.id,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) _scroll.jumpTo(_scroll.position.maxScrollExtent);
    });
  }

  @override
  void dispose() {
    if (_channel != null) widget.repository.unsubscribe(_channel!);
    _text.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final value = _text.text.trim();
    if (value.isEmpty || _sending) return;
    setState(() => _sending = true);
    _text.clear();
    try {
      await widget.repository.sendMessage(widget.room.id, value);
      await _load();
    } catch (_) {
      if (mounted) {
        _text.text = value;
        showCommunityNotice(
          context,
          'Message non envoyé. Réessaie.',
          type: CommunityNoticeType.error,
        );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _showMessageActions(CommunityMessage message) async {
    final me = Supabase.instance.client.auth.currentUser?.id;
    if (message.senderId == me) return;
    final action = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Sécurité du message',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              'Le signalement transmet uniquement ce message et un contexte limité à l’équipe de modération.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 18),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              leading: const Icon(Icons.flag_outlined),
              title: const Text('Signaler ce message'),
              subtitle: const Text('Menace, harcèlement, contenu sexuel…'),
              onTap: () => Navigator.pop(context, 'report'),
            ),
          ],
        ),
      ),
    );
    if (action == 'report' && mounted) await _reportMessage(message);
  }

  Future<void> _reportMessage(CommunityMessage message) async {
    final result = await showModalBottomSheet<_MessageReportValue>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (_) => const _MessageReportSheet(),
    );
    if (result == null || !mounted) return;
    try {
      await widget.repository.reportMessage(
        message.id,
        result.reason,
        result.details,
      );
      if (mounted)
        showCommunityNotice(
          context,
          'Signalement transmis en toute confidentialité.',
          type: CommunityNoticeType.success,
        );
    } catch (_) {
      if (mounted)
        showCommunityNotice(
          context,
          'Le signalement n’a pas pu être envoyé.',
          type: CommunityNoticeType.error,
        );
    }
  }

  Future<void> _showConversationSafety() async {
    final other = _participants.isEmpty ? null : _participants.first;
    final action = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Confidentialité et sécurité',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              'COP’IQ ne permet pas aux modérateurs de parcourir tes conversations. Seuls les messages que tu signales, avec un court contexte, peuvent être examinés.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            if (other != null)
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                leading: const Icon(Icons.block_rounded),
                title: Text('Bloquer ${other.displayName}'),
                subtitle: const Text(
                  'La conversation sera fermée et aucun nouveau message ne passera.',
                ),
                onTap: () => Navigator.pop(context, 'block'),
              ),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              leading: const Icon(Icons.logout_rounded),
              title: const Text('Quitter la conversation'),
              onTap: () => Navigator.pop(context, 'leave'),
            ),
          ],
        ),
      ),
    );
    if (!mounted || action == null) return;
    try {
      if (action == 'block' && other != null) {
        await widget.repository.blockRoomMember(widget.room.id, other.userId);
      } else if (action == 'leave') {
        await widget.repository.leaveRoom(widget.room.id);
      } else {
        return;
      }
      if (mounted) Navigator.pop(context, true);
    } catch (_) {
      if (mounted)
        showCommunityNotice(
          context,
          'Cette action n’a pas pu être réalisée.',
          type: CommunityNoticeType.error,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final me = Supabase.instance.client.auth.currentUser?.id;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CommunityAvatar(
              name: widget.room.title,
              color: widget.room.scope.color,
              avatarIndex: widget.room.otherAvatarIndex,
              size: 38,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.room.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  if (widget.room.otherUsername.isNotEmpty)
                    Text(
                      '@${widget.room.otherUsername}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Confidentialité et sécurité',
            onPressed: _showConversationSafety,
            icon: const Icon(Icons.shield_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: _scroll,
                    padding: const EdgeInsets.all(14),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index],
                          mine = message.senderId == me;
                      return Align(
                        alignment: mine
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: GestureDetector(
                          onLongPress: mine
                              ? null
                              : () => _showMessageActions(message),
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 320),
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: mine
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(
                                      context,
                                    ).colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  message.content,
                                  style: TextStyle(
                                    color: mine
                                        ? Theme.of(
                                            context,
                                          ).colorScheme.onPrimary
                                        : null,
                                    height: 1.35,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  communityTime(message.createdAt),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: mine
                                        ? Theme.of(context)
                                              .colorScheme
                                              .onPrimary
                                              .withValues(alpha: .7)
                                        : Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lock_outline_rounded,
                        size: 13,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Conversation privée · appui long pour signaler',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _text,
                          minLines: 1,
                          maxLines: 5,
                          decoration: InputDecoration(
                            hintText: 'Message…',
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        tooltip: 'Envoyer',
                        onPressed: _sending ? null : _send,
                        icon: const Icon(Icons.send_rounded),
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
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.label,
    this.action,
    this.actionLabel = 'Réessayer',
  });
  final IconData icon;
  final String label;
  final VoidCallback? action;
  final String actionLabel;
  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 52, color: Theme.of(context).colorScheme.outline),
        const SizedBox(height: 12),
        Text(label),
        if (action != null)
          FilledButton.tonal(onPressed: action, child: Text(actionLabel)),
      ],
    ),
  );
}

class _MessageReportValue {
  const _MessageReportValue(this.reason, this.details);
  final String reason;
  final String? details;
}

class _MessageReportSheet extends StatefulWidget {
  const _MessageReportSheet();
  @override
  State<_MessageReportSheet> createState() => _MessageReportSheetState();
}

class _MessageReportSheetState extends State<_MessageReportSheet> {
  static const _reasons = <(String, String, IconData)>[
    ('threat', 'Menace ou danger immédiat', Icons.crisis_alert_rounded),
    ('sexual', 'Contenu sexuel ou impliquant un mineur', Icons.gpp_bad_rounded),
    ('harassment', 'Harcèlement ou intimidation', Icons.person_off_outlined),
    ('hate', 'Haine ou propos discriminatoires', Icons.forum_outlined),
    (
      'personal_data',
      'Données personnelles partagées',
      Icons.privacy_tip_outlined,
    ),
    ('spam', 'Spam ou arnaque', Icons.report_gmailerrorred_rounded),
    ('other', 'Autre problème', Icons.more_horiz_rounded),
  ];
  final _details = TextEditingController();
  String? _reason;

  @override
  void dispose() {
    _details.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(
      20,
      0,
      20,
      MediaQuery.viewInsetsOf(context).bottom + 20,
    ),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Pourquoi signales-tu ce message ?',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 5),
          Text(
            'Choisis le motif le plus précis. Les urgences sont placées en priorité.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 14),
          ..._reasons.map(
            (reason) => RadioListTile<String>(
              value: reason.$1,
              groupValue: _reason,
              onChanged: (value) => setState(() => _reason = value),
              secondary: Icon(reason.$3),
              title: Text(reason.$2),
              contentPadding: EdgeInsets.zero,
              dense: true,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _details,
            maxLength: 1000,
            minLines: 2,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: 'Précisions facultatives',
              hintText: 'Explique brièvement ce qui s’est passé…',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: _reason == null
                ? null
                : () => Navigator.pop(
                    context,
                    _MessageReportValue(
                      _reason!,
                      _details.text.trim().isEmpty
                          ? null
                          : _details.text.trim(),
                    ),
                  ),
            icon: const Icon(Icons.shield_outlined),
            label: const Text('Envoyer le signalement'),
          ),
          const SizedBox(height: 8),
          Text(
            'En cas de danger immédiat, contacte les services d’urgence. Le signalement COP’IQ ne remplace pas un dépôt de plainte.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              height: 1.35,
            ),
          ),
        ],
      ),
    ),
  );
}
