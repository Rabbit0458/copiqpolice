import 'dart:async';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:copiqpolice/core/widgets/app_notifier.dart'
    show AppSettingsController, AppNotifier;
import 'package:copiqpolice/features/forum/forum_theme.dart';

/// ForumEspaceExamGPXPage
/// ✅ Profil Supabase user_profiles (username + role)
/// ✅ Feed forum_posts_exam_gpx + join user_profiles(role)
/// ✅ Badges :
/// - active = coche BLEUE
/// - moderator = coche JAUNE
/// - admin = coche ROUGE
/// ✅ Menu "..." : report, block, delete (mod+), promote/demote moderator (admin only)
/// ✅ Create post + upload image
/// ✅ Search overlay (content + username)
///
class ForumEspaceExamGPXPage extends StatefulWidget {
  const ForumEspaceExamGPXPage({super.key});

  @override
  State<ForumEspaceExamGPXPage> createState() => _ForumEspaceExamGPXPageState();
}

class _ForumEspaceExamGPXPageState extends State<ForumEspaceExamGPXPage> {
  final SupabaseClient _sb = Supabase.instance.client;

  _Profile? _me;

  final Set<String> _blockedUserIds = <String>{};
  List<_Post> _posts = <_Post>[];
  bool _loading = true;
  String? _error;

  // Search
  bool _searchOpen = false;
  final TextEditingController _searchCtrl = TextEditingController();
  Timer? _debounce;
  bool _searchLoading = false;
  List<_SearchHit> _searchHits = <_SearchHit>[];

  // Mute status
  bool _muted = false;
  DateTime? _mutedUntil; // null => permanent mute
  String? _muteReason;
  String? _muteBy;

  bool get _isMod => (_me?.role == 'moderator' || _me?.role == 'admin');
  bool get _isAdmin => (_me?.role == 'admin');
  bool get _isLocked => _muted;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  // ─────────────────────────── BOOTSTRAP ───────────────────────────

  Future<void> _bootstrap() async {
    if (!mounted) return;
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await _loadMe();
      await _loadMuteStatus();
      await _loadBlocks();
      await _loadFeed();
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = _prettyErr(e));
      AppNotifier.error(context, title: "Erreur", message: _prettyErr(e));
    } finally {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  // ─────────────────────────── PROFILE ───────────────────────────

  Future<void> _loadMe() async {
    final user = _sb.auth.currentUser;
    if (user == null) throw Exception("Not authenticated");

    final row = await _sb
        .from('user_profiles')
        .select('user_id, email, username, avatar_index, role')
        .eq('user_id', user.id)
        .maybeSingle();

    final email = ((row?['email'] as String?)?.trim() ?? user.email ?? '')
        .trim();
    final usernameFromDb = (row?['username'] as String?)?.trim();
    final avatarIndex = (row?['avatar_index'] as int?) ?? 0;

    final roleRaw = (row?['role'] as String?)?.trim().toLowerCase();
    final role = (roleRaw == null || roleRaw.isEmpty) ? 'active' : roleRaw;

    final username = (usernameFromDb != null && usernameFromDb.isNotEmpty)
        ? usernameFromDb
        : _buildPrivateUsername(email: email, uid: user.id);

    if (row == null) {
      await _sb.from('user_profiles').insert({
        'user_id': user.id,
        'email': email,
        'username': username,
        'avatar_index': avatarIndex,
        'role': role,
        'created_at': DateTime.now().toUtc().toIso8601String(),
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      });
    } else {
      final needsUsernameFix =
          (usernameFromDb == null || usernameFromDb.isEmpty);
      final needsRoleFix = (roleRaw == null || roleRaw.isEmpty);

      if (needsUsernameFix || needsRoleFix) {
        await _sb
            .from('user_profiles')
            .update({
              if (needsUsernameFix) 'username': username,
              if (needsRoleFix) 'role': role,
              'updated_at': DateTime.now().toUtc().toIso8601String(),
            })
            .eq('user_id', user.id);
      }
    }

    _me = _Profile(
      uid: user.id,
      username: username,
      role: role,
      avatarIndex: avatarIndex,
      avatarUrl: null,
    );
  }

  String _buildPrivateUsername({required String email, required String uid}) {
    final base = (email.isNotEmpty ? email : uid).toLowerCase();
    final hash = base.hashCode.abs().toString();
    final suffix = hash.length >= 4
        ? hash.substring(hash.length - 4)
        : hash.padLeft(4, '0');
    return 'candidat_$suffix';
  }

  // ─────────────────────────── MUTE (forum_bans) ───────────────────────────

  Future<void> _loadMuteStatus() async {
    final me = _me;
    if (me == null) return;

    try {
      final nowIso = DateTime.now().toUtc().toIso8601String();

      final rows = await _sb
          .from('forum_bans')
          .select('id, reason, expires_at, is_active, banned_by, created_at')
          .eq('user_id', me.uid)
          .eq('is_active', true)
          .or('expires_at.is.null,expires_at.gt.$nowIso')
          .order('created_at', ascending: false)
          .limit(1);

      if (rows.isEmpty) {
        _muted = false;
        _mutedUntil = null;
        _muteReason = null;
        _muteBy = null;
        return;
      }

      final r = rows.first;
      final expRaw = r['expires_at'] as String?;
      _muted = true;
      _mutedUntil = expRaw == null ? null : DateTime.tryParse(expRaw);
      _muteReason = (r['reason'] as String?)?.trim();
      _muteBy = r['banned_by']?.toString();
    } catch (_) {
      _muted = false;
      _mutedUntil = null;
      _muteReason = null;
      _muteBy = null;
    }
  }

  String _muteLabel() {
    if (!_muted) return '';
    if (_mutedUntil == null) return "Vous êtes mute définitivement.";
    final local = _mutedUntil!.toLocal();
    final d = local.day.toString().padLeft(2, '0');
    final m = local.month.toString().padLeft(2, '0');
    final hh = local.hour.toString().padLeft(2, '0');
    final mm = local.minute.toString().padLeft(2, '0');
    return "Vous êtes mute jusqu’au $d/$m à $hh:$mm.";
    // (optionnel) tu peux afficher _muteReason / _muteBy si tu veux.
  }

  Future<bool> _isMeMuted() async {
    final me = _me;
    if (me == null) return false;

    try {
      final nowIso = DateTime.now().toUtc().toIso8601String();
      final row = await _sb
          .from('forum_bans')
          .select('id')
          .eq('user_id', me.uid)
          .eq('is_active', true)
          .or('expires_at.is.null,expires_at.gt.$nowIso')
          .limit(1)
          .maybeSingle();

      return row != null;
    } catch (_) {
      return false;
    }
  }

  // ─────────────────────────── BLOCKS ───────────────────────────

  Future<void> _loadBlocks() async {
    final me = _me;
    if (me == null) return;

    try {
      final rows = await _sb
          .from('forum_blocks')
          .select('blocked_id')
          .eq('blocker_id', me.uid);

      _blockedUserIds
        ..clear()
        ..addAll(
          rows
              .map((e) => e['blocked_id'])
              .where((v) => v != null)
              .map((v) => v.toString()),
        );
    } catch (_) {
      _blockedUserIds.clear();
    }
  }

  Future<void> _blockUser(String blockedUid) async {
    final me = _me;
    if (me == null) return;

    if (_blockedUserIds.contains(blockedUid)) {
      AppNotifier.info(
        context,
        title: "Information",
        message: "Cet utilisateur est déjà bloqué.",
      );
      return;
    }

    try {
      await _sb.from('forum_blocks').insert({
        'blocker_id': me.uid,
        'blocked_id': blockedUid,
        'created_at': DateTime.now().toUtc().toIso8601String(),
      });

      if (!mounted) return;
      setState(() {
        _blockedUserIds.add(blockedUid);
        _posts = _posts.where((p) => p.authorId != blockedUid).toList();
      });

      AppNotifier.success(
        context,
        title: "Utilisateur bloqué",
        message: "Ses publications sont désormais masquées.",
      );
    } catch (e) {
      AppNotifier.error(
        context,
        title: "Erreur de blocage",
        message: _prettyErr(e),
      );
    }
  }

  // ─────────────────────────── FEED ───────────────────────────

  Future<void> _loadFeed() async {
    final user = _sb.auth.currentUser;
    if (user == null) return;
    final myId = user.id;

    final rows = await _sb
        .from('forum_posts_exam_gpx')
        .select('''
          id,
          author_id,
          username,
          title,
          content,
          image_url,
          created_at,
          is_deleted,
          user_profiles (
            role,
            avatar_index
          ),
          forum_post_likes (
            user_id
          ),
          forum_post_comments_exam_gpx (
            id
          )
        ''')
        .eq('is_deleted', false)
        .order('created_at', ascending: false)
        .limit(50);

    final all = rows
        .map((r) => _Post.fromRow(r, myUserId: myId))
        .where((p) => !_blockedUserIds.contains(p.authorId))
        .toList();

    if (!mounted) return;
    setState(() => _posts = all);
  }

  // ─────────────────────────── LIKES ───────────────────────────

  Future<void> _toggleLike(_Post post) async {
    if (_isLocked) {
      AppNotifier.warning(
        context,
        title: "Action impossible",
        message: "Votre compte est actuellement restreint (mute).",
      );
      return;
    }

    final user = _sb.auth.currentUser;
    if (user == null) return;

    final alreadyLiked = post.likedByMe;

    // Optimistic UI
    if (mounted) {
      setState(() {
        _posts = _posts.map((p) {
          if (p.id != post.id) return p;
          return _Post(
            id: p.id,
            authorId: p.authorId,
            username: p.username,
            authorRole: p.authorRole,
            avatarIndex: p.avatarIndex,
            title: p.title,
            content: p.content,
            imageUrl: p.imageUrl,
            createdAt: p.createdAt,
            likeCount: alreadyLiked ? (p.likeCount - 1) : (p.likeCount + 1),
            likedByMe: !alreadyLiked,
            commentCount: p.commentCount,
          );
        }).toList();
      });
    }

    try {
      if (alreadyLiked) {
        await _sb
            .from('forum_post_likes')
            .delete()
            .eq('post_id', post.id)
            .eq('user_id', user.id);
      } else {
        await _sb.from('forum_post_likes').insert({
          'post_id': post.id,
          'user_id': user.id,
          'created_at': DateTime.now().toUtc().toIso8601String(),
        });
      }
    } catch (e) {
      await _loadFeed(); // rollback
      if (!mounted) return;
      AppNotifier.error(
        context,
        title: "Erreur lors du like",
        message: _prettyErr(e),
      );
    }
  }

  // ─────────────────────────── POST DETAIL ───────────────────────────

  void _openPostDetail(_Post post) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _PostDetailPage(
          post: post,
          onToggleLike: () => _toggleLike(post),
          onOpenComments: () => _openComments(context, post),
          onOpenPostMenu: () => _openPostMenu(context, post),
        ),
      ),
    );
  }

  // ─────────────────────────── COMMENTS ───────────────────────────

  Future<void> _openComments(BuildContext context, _Post post) async {
    final me = _me;
    if (me == null) return;

    final muted = await _isMeMuted();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CommentsSheet(
        post: post,
        me: me,
        supabase: _sb,
        isMuted: muted,
        isMod: _isMod,
        onSendMessage: (String userId, String username) async {
          await _startOrOpenDmToUser(userId: userId, username: username);
        },
        onDeleteComment: (String commentId) async {
          await _modDeleteComment(commentId);
        },
        onReportComment: (String commentId, String reason) async {
          await _reportComment(
            commentId: commentId,
            reason: reason,
            postId: post.id,
          );
        },
      ),
    );

    await _loadFeed();
  }

  Future<void> _modDeleteComment(String commentId) async {
    if (!_isMod) {
      AppNotifier.error(
        context,
        title: "Accès refusé",
        message: "Réservé à la modération.",
      );
      return;
    }

    try {
      // ✅ Tables confirmées: forum_post_comments_exam_gpx => is_deleted (PAS deleted_at)
      final res = await _sb
          .from('forum_post_comments_exam_gpx')
          .update({'is_deleted': true})
          .eq('id', commentId)
          .select('id');

      if (res.isEmpty) {
        AppNotifier.warning(
          context,
          title: "Aucune suppression",
          message:
              "Aucune ligne modifiée. Vérifie tes policies (RLS) si activées.",
        );
        return;
      }

      AppNotifier.success(
        context,
        title: "Supprimé",
        message: "Le commentaire a été masqué.",
      );
    } catch (e) {
      AppNotifier.error(
        context,
        title: "Erreur suppression",
        message: _prettyErr(e),
      );
    }
  }

  Future<void> _modDeletePost(String postId) async {
    if (!_isMod) {
      AppNotifier.error(
        context,
        title: "Accès refusé",
        message: "Réservé à la modération.",
      );
      return;
    }

    try {
      // ✅ Tables confirmées: forum_posts_exam_gpx => is_deleted (PAS deleted_at)
      final res = await _sb
          .from('forum_posts_exam_gpx')
          .update({'is_deleted': true})
          .eq('id', postId)
          .select('id');

      if (res.isEmpty) {
        AppNotifier.warning(
          context,
          title: "Aucune suppression",
          message:
              "Aucune ligne modifiée. Vérifie tes policies (RLS) si activées.",
        );
        return;
      }

      if (!mounted) return;
      setState(() => _posts.removeWhere((p) => p.id == postId));

      AppNotifier.success(
        context,
        title: "Supprimé",
        message: "La publication a été masquée.",
      );
    } catch (e) {
      AppNotifier.error(
        context,
        title: "Erreur suppression",
        message: _prettyErr(e),
      );
    }
  }

  Future<void> _reportComment({
    required String commentId,
    required String reason,
    required String postId,
  }) async {
    final me = _me;
    if (me == null) return;

    try {
      await _sb.from('forum_reports').insert({
        'reporter_id': me.uid,
        'post_id': postId,
        'comment_id': commentId,
        'reason': reason.trim(),
        'created_at': DateTime.now().toUtc().toIso8601String(),
        'status': 'open',
      });

      if (!mounted) return;
      AppNotifier.success(
        context,
        title: "Signalement envoyé",
        message: "Merci pour votre contribution à la modération.",
      );
    } catch (e) {
      if (!mounted) return;
      AppNotifier.error(
        context,
        title: "Erreur lors du signalement",
        message: _prettyErr(e),
      );
    }
  }

  // ─────────────────────────── DM / ROOMS (forum_rooms + forum_room_members) ───────────────────────────

  Future<void> _startOrOpenDmToUser({
    required String userId,
    required String username,
  }) async {
    final me = _me;
    if (me == null) return;

    if (userId == me.uid) {
      AppNotifier.warning(
        context,
        title: "Action impossible",
        message: "Tu ne peux pas t’envoyer un message à toi-même.",
      );
      return;
    }

    final roomId = await _ensureDirectRoom(otherUserId: userId);

    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ForumChatPage(
          conversationId: roomId,
          title: username.trim().isEmpty ? "Discussion" : username.trim(),
        ),
      ),
    );
  }

  Future<String> _ensureDirectRoom({required String otherUserId}) async {
    final user = _sb.auth.currentUser;
    if (user == null) throw Exception("Not authenticated");

    // 1) mes rooms
    final myMemberships = await _sb
        .from('forum_room_members')
        .select('room_id')
        .eq('user_id', user.id);
    final ids = myMemberships.map((e) => e['room_id'].toString()).toList();

    if (ids.isNotEmpty) {
      final rooms = await _sb
          .from('forum_rooms')
          .select('id, is_group')
          .inFilter('id', ids)
          .eq('is_group', false);

      for (final r in rooms) {
        final rid = r['id'].toString();
        final members = await _sb
            .from('forum_room_members')
            .select('user_id')
            .eq('room_id', rid);
        final memberIds = members.map((m) => m['user_id'].toString()).toSet();

        if (memberIds.length == 2 &&
            memberIds.contains(user.id) &&
            memberIds.contains(otherUserId)) {
          return rid;
        }
      }
    }

    // 2) créer
    final created = await _sb
        .from('forum_rooms')
        .insert({
          'created_by': user.id,
          'title': null,
          'is_group': false,
          'created_at': DateTime.now().toUtc().toIso8601String(),
        })
        .select()
        .single();

    final roomId = created['id'].toString();

    // ⚠️ D’après tes tables: forum_room_members a "joined_at" (pas created_at)
    await _sb.from('forum_room_members').insert([
      {
        'room_id': roomId,
        'user_id': user.id,
        'joined_at': DateTime.now().toUtc().toIso8601String(),
      },
      {
        'room_id': roomId,
        'user_id': otherUserId,
        'joined_at': DateTime.now().toUtc().toIso8601String(),
      },
    ]);

    return roomId;
  }

  // ─────────────────────────── POST MENU ───────────────────────────

  Future<void> _openPostMenu(BuildContext context, _Post post) async {
    final action = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _Card(
        radius: 22,
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Actions",
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.flag_rounded),
              title: const Text("Signaler"),
              onTap: () => Navigator.pop(context, "report"),
            ),
            ListTile(
              leading: const Icon(Icons.block_rounded),
              title: const Text("Bloquer l’utilisateur"),
              onTap: () => Navigator.pop(context, "block"),
            ),
            if (_isMod)
              ListTile(
                leading: const Icon(Icons.delete_rounded, color: Colors.red),
                title: const Text("Supprimer (modération)"),
                onTap: () => Navigator.pop(context, "delete"),
              ),
          ],
        ),
      ),
    );

    if (action == null) return;

    if (action == "block") {
      await _blockUser(post.authorId);
      return;
    }

    if (action == "delete") {
      await _modDeletePost(post.id);
      return;
    }

    if (action == "report") {
      final reason = await _askReportReason();
      if (reason == null) return;

      // Si tu veux signaler un post, il te faut une colonne post_id dans forum_reports (tu l'as)
      final me = _me;
      if (me == null) return;

      try {
        await _sb.from('forum_reports').insert({
          'reporter_id': me.uid,
          'post_id': post.id,
          'reason': reason,
          'created_at': DateTime.now().toUtc().toIso8601String(),
          'status': 'open',
        });

        if (!mounted) return;
        AppNotifier.success(
          context,
          title: "Signalement envoyé",
          message: "Merci pour votre contribution à la modération.",
        );
      } catch (e) {
        if (!mounted) return;
        AppNotifier.error(
          context,
          title: "Erreur lors du signalement",
          message: _prettyErr(e),
        );
      }
      return;
    }
  }

  Future<String?> _askReportReason() async {
    final ctrl = TextEditingController();
    final res = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        final inset = MediaQuery.of(context).viewInsets.bottom;
        return Padding(
          padding: EdgeInsets.only(bottom: inset),
          child: _Card(
            radius: 22,
            padding: const EdgeInsets.all(14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Motif du signalement",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: ctrl,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: "Explique brièvement…",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Annuler"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () =>
                            Navigator.pop(context, ctrl.text.trim()),
                        child: const Text("Envoyer"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    final r = res?.trim();
    if (r == null || r.isEmpty) return null;
    return r;
  }

  // ─────────────────────────── CREATE POST ───────────────────────────

  Future<void> _openCreatePost({required String defaultHint}) async {
    if (_isLocked) {
      AppNotifier.warning(
        context,
        title: "Action bloquée",
        message: "Vous êtes actuellement mute. La publication est désactivée.",
      );
      return;
    }

    final created = await showModalBottomSheet<_Post>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CreatePostSheet(
        hint: defaultHint,
        onSubmit:
            ({required String title, required String body, XFile? image}) {
              return _createPost(title: title, body: body, image: image);
            },
      ),
    );

    if (created != null && mounted) {
      setState(() => _posts = [created, ..._posts]);
    }
  }

  Future<_Post> _createPost({
    required String title,
    required String body,
    XFile? image,
  }) async {
    final me = _me;
    if (me == null) throw Exception("Profile not loaded");

    final t = title.trim();
    final b = body.trim();
    if (t.isEmpty) throw Exception("Titre vide");
    if (b.isEmpty) throw Exception("Message vide");

    String? imageUrl;
    if (image != null) imageUrl = await _uploadImage(image);

    final insert = <String, dynamic>{
      'author_id': me.uid,
      'username': me.username,
      'title': t,
      'content': b,
      'image_url': imageUrl,
      'is_deleted': false,
      'created_at': DateTime.now().toUtc().toIso8601String(),
    };

    final row = await _sb
        .from('forum_posts_exam_gpx')
        .insert(insert)
        .select()
        .single();

    final enriched = <String, dynamic>{
      ...row,
      'user_profiles': {'role': me.role, 'avatar_index': me.avatarIndex},
      'forum_post_likes': [],
      'forum_post_comments_exam_gpx': [],
    };

    return _Post.fromRow(enriched, myUserId: _sb.auth.currentUser!.id);
  }

  Future<String> _uploadImage(XFile image) async {
    final me = _me;
    if (me == null) throw Exception("Profile not loaded");

    final bytes = await image.readAsBytes();
    final ext = image.name.split('.').last.toLowerCase();
    final safeExt = ext.isEmpty ? 'jpg' : ext;
    final path = '${me.uid}/${DateTime.now().millisecondsSinceEpoch}.$safeExt';

    await _sb.storage
        .from('forum-posts')
        .uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(
            upsert: false,
            contentType: image.mimeType ?? 'image/jpeg',
          ),
        );

    return _sb.storage.from('forum-posts').getPublicUrl(path);
  }

  // ─────────────────────────── GROUP FLOW ───────────────────────────

  Future<void> _openCreateGroupFlow() async {
    if (_isLocked) {
      AppNotifier.warning(
        context,
        title: "Action bloquée",
        message:
            "Vous êtes actuellement mute. La création de groupe est désactivée.",
      );
      return;
    }

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CreateGroupSheet(
        supabase: _sb,
        onCreated: () {
          AppNotifier.success(
            context,
            title: "Groupe créé",
            message: "Le groupe a été créé avec succès.",
          );
        },
      ),
    );
  }

  // ─────────────────────────── SEARCH ───────────────────────────

  void _openSearch() {
    setState(() {
      _searchOpen = true;
      _searchHits = [];
      _searchCtrl.text = '';
      _searchLoading = false;
    });
  }

  void _openMessages() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const ForumInboxPage()));
  }

  void _closeSearch() {
    setState(() => _searchOpen = false);
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void _onSearchChanged(String q) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 240), () => _runSearch(q));
  }

  Future<void> _runSearch(String query) async {
    final q = query.trim();
    if (q.isEmpty) {
      if (!mounted) return;
      setState(() {
        _searchHits = [];
        _searchLoading = false;
      });
      return;
    }

    if (!mounted) return;
    setState(() => _searchLoading = true);

    try {
      final postRows = await _sb
          .from('forum_posts_exam_gpx')
          .select('id, username, title, content, created_at, is_deleted')
          .eq('is_deleted', false)
          .or('content.ilike.%$q%,username.ilike.%$q%,title.ilike.%$q%')
          .order('created_at', ascending: false)
          .limit(40);

      final hits = <_SearchHit>[];
      for (final r in postRows) {
        final t = (r['title'] as String?)?.trim() ?? '';
        hits.add(
          _SearchHit(
            type: _SearchHitType.post,
            postId: r['id'].toString(),
            title: t.isNotEmpty
                ? t
                : ((r['username'] as String?) ?? 'Utilisateur'),
            snippet: (r['content'] as String?) ?? '',
            createdAt: DateTime.tryParse((r['created_at'] as String?) ?? ''),
          ),
        );
      }

      if (!mounted) return;
      setState(() => _searchHits = hits);
    } catch (e) {
      if (!mounted) return;
      AppNotifier.error(
        context,
        title: "Erreur de recherche",
        message: _prettyErr(e),
      );
    } finally {
      if (mounted) setState(() => _searchLoading = false);
    }
  }

  // ─────────────────────────── UI ───────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.forum.bgTop,
      body: Stack(
        children: [
          const _Background(),
          SafeArea(
            bottom: false,
            child: RefreshIndicator(
              onRefresh: _bootstrap,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        children: [
                          _TopBar(
                            avatarLetter:
                                _me?.username.characters.firstOrNull ?? 'C',
                            onSearch: _openSearch,
                            onMessages: _openMessages,
                          ),
                          const SizedBox(height: 10),

                          if (_muted)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: context.forum.danger.withOpacity(
                                  context.forum.isDark ? 0.14 : 0.10,
                                ),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: context.forum.danger.withOpacity(
                                    context.forum.isDark ? 0.28 : 0.22,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.lock_rounded,
                                    color: context.forum.danger,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      _muteLabel(),
                                      style: TextStyle(
                                        color: context.forum.danger,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 12.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          const SizedBox(height: 12),

                          Opacity(
                            opacity: _isLocked ? 0.55 : 1,
                            child: IgnorePointer(
                              ignoring: _isLocked,
                              child: _ComposerCard(
                                onTapAsk: () => _openCreatePost(
                                  defaultHint: "Pose ta question…",
                                ),
                                onTapAnswer: () => _openCreatePost(
                                  defaultHint: "Partage un conseil…",
                                ),
                                onTapPost: () => _openCreatePost(
                                  defaultHint: "Partage une info…",
                                ),
                              ),
                            ),
                          ),

                          if (_isLocked) ...[
                            const SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: context.forum.danger.withOpacity(
                                  context.forum.isDark ? 0.12 : 0.08,
                                ),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: context.forum.danger.withOpacity(
                                    context.forum.isDark ? 0.26 : 0.20,
                                  ),
                                ),
                              ),
                              child: Text(
                                "Vous ne pouvez pas publier/commenter pendant le mute.",
                                style: TextStyle(
                                  color: context.forum.danger,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 12.5,
                                ),
                              ),
                            ),
                          ],

                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                    sliver: SliverToBoxAdapter(child: _buildBody()),
                  ),
                ],
              ),
            ),
          ),

          _Fab(
            onCreatePost: () =>
                _openCreatePost(defaultHint: "Écris ton message…"),
            onCreateGroup: _openCreateGroupFlow,
          ),

          if (_searchOpen)
            _SearchOverlay(
              controller: _searchCtrl,
              loading: _searchLoading,
              hits: _searchHits,
              onClose: _closeSearch,
              onChanged: _onSearchChanged,
              onOpenPost: (_) {
                _closeSearch();
                AppNotifier.info(
                  context,
                  title: "Information",
                  message:
                      "Ouverture de la publication… (page détail à brancher)",
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) return const _SkeletonList();

    if (_error != null) {
      return _EmptyState(
        title: "Erreur",
        subtitle: _error!,
        cta: "Réessayer",
        onTap: _bootstrap,
      );
    }

    if (_posts.isEmpty) {
      return _EmptyState(
        title: "Aucune discussion",
        subtitle: "Sois le premier à lancer un sujet.",
        cta: "Créer une discussion",
        onTap: () => _openCreatePost(defaultHint: "Écris ton message…"),
      );
    }

    return Column(
      children: [
        for (final p in _posts) ...[
          _PostCard(
            post: p,
            onOpen: () => _openPostDetail(p),
            onMore: () => _openPostMenu(context, p),
            onLike: () => _toggleLike(p),
            onComments: () => _openComments(context, p),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }

  // ─────────────────────────── HELPERS ───────────────────────────

  void _toast(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }

  String _prettyErr(Object e) => e.toString();
}

class _Post {
  final String id;
  final String authorId;
  final String username;
  final String authorRole;
  final int avatarIndex;

  final String title; // ✅ NEW
  final String content;
  final String? imageUrl;
  final DateTime createdAt;

  final int likeCount;
  final bool likedByMe;
  final int commentCount;

  const _Post({
    required this.id,
    required this.authorId,
    required this.username,
    required this.authorRole,
    required this.avatarIndex,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.createdAt,
    required this.likeCount,
    required this.likedByMe,
    required this.commentCount,
  });

  _Post copyWith({
    String? id,
    String? authorId,
    String? username,
    String? authorRole,
    int? avatarIndex,
    String? title,
    String? content,
    String? imageUrl,
    DateTime? createdAt,
    int? likeCount,
    bool? likedByMe,
    int? commentCount,
  }) {
    return _Post(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      username: username ?? this.username,
      authorRole: authorRole ?? this.authorRole,
      avatarIndex: avatarIndex ?? this.avatarIndex,
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      likeCount: likeCount ?? this.likeCount,
      likedByMe: likedByMe ?? this.likedByMe,
      commentCount: commentCount ?? this.commentCount,
    );
  }

  factory _Post.fromRow(Map<String, dynamic> r, {required String myUserId}) {
    final profile = r['user_profiles'] as Map<String, dynamic>?;

    final likes = (r['forum_post_likes'] as List?) ?? const [];
    final comments = (r['forum_post_comments_exam_gpx'] as List?) ?? const [];

    final titleRaw = (r['title'] as String?)?.trim() ?? '';
    final contentRaw = (r['content'] as String?) ?? '';

    final createdAtRaw = r['created_at']?.toString() ?? '';
    final createdAt =
        DateTime.tryParse(createdAtRaw)?.toLocal() ?? DateTime.now();

    return _Post(
      id: r['id'].toString(),
      authorId: r['author_id'].toString(),
      username: (r['username'] as String?)?.trim().isNotEmpty == true
          ? (r['username'] as String).trim()
          : 'Utilisateur',
      authorRole:
          (profile?['role'] as String?)?.toLowerCase().trim().isNotEmpty == true
          ? (profile!['role'] as String).toLowerCase().trim()
          : 'active',
      avatarIndex: (profile?['avatar_index'] as int?) ?? 1,
      title: titleRaw.isNotEmpty ? titleRaw : "Sans titre",
      content: contentRaw,
      imageUrl: r['image_url'] as String?,
      createdAt: createdAt,
      likeCount: likes.length,
      likedByMe: likes.any(
        (l) => l is Map && l['user_id']?.toString() == myUserId,
      ),
      commentCount: comments.length,
    );
  }
}

class _Profile {
  final String uid;
  final String username;
  final String role; // active / moderator / admin
  final int avatarIndex;
  final String? avatarUrl;

  const _Profile({
    required this.uid,
    required this.username,
    required this.role,
    required this.avatarIndex,
    this.avatarUrl,
  });
}

enum _SearchHitType { post }

class _SearchHit {
  final _SearchHitType type;
  final String postId;
  final String title;
  final String snippet;
  final DateTime? createdAt;

  _SearchHit({
    required this.type,
    required this.postId,
    required this.title,
    required this.snippet,
    required this.createdAt,
  });
}

class _ForumTheme {
  static const bgTop = Color(0xFFEEF3FF);
  static const bgBottom = Color(0xFFF4F6FF);

  static const card = Color(0xFFFFFFFF);
  static const pill = Color(0xFFF3F6FF);
  static const outline = Color(0xFFE6ECFA);

  static const text = Color(0xFF0F172A);
  static const text2 = Color(0xFF64748B);
  static const placeholder = Color(0xFF94A3B8);

  static const accent = Color(0xFF3B82F6);
  static const accentSoft = Color(0xFFE7F0FF);
  static const danger = Color(0xFFEF4444);
  static const moderator = Color(0xFFF59E0B); // jaune
}

class _Background extends StatelessWidget {
  const _Background();

  @override
  Widget build(BuildContext context) {
    final t = ForumTheme.of(context, skin: ForumSkin.examGPX);

    return DecoratedBox(
      decoration: BoxDecoration(gradient: t.backgroundGradient),
      child: const SizedBox.expand(),
    );
  }
}

class _Pressable extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  /// Si true : pas de tap + feedback visuel léger (opacity)
  final bool disabled;

  /// Opacité appliquée quand disabled = true
  final double disabledOpacity;

  /// Optionnel : radius pour InkWell/InkResponse
  final BorderRadius? radius;

  /// Feedback “press”
  final double pressedScale;
  final double pressedOpacity;

  /// Durée/curve des anims
  final Duration duration;
  final Curve curve;

  const _Pressable({
    required this.child,
    this.onTap,
    this.disabled = false,
    this.disabledOpacity = 0.55,
    this.radius,
    this.pressedScale = 0.97,
    this.pressedOpacity = 0.92,
    this.duration = const Duration(milliseconds: 160),
    this.curve = const Cubic(0.2, 0.0, 0.0, 1.0),
    super.key,
  });

  @override
  State<_Pressable> createState() => _PressableState();
}

class _PressableState extends State<_Pressable> {
  bool _down = false;

  bool get _enabled => !widget.disabled && widget.onTap != null;

  void _setDown(bool v) {
    if (!mounted) return;
    if (!_enabled) return;
    if (_down == v) return;
    setState(() => _down = v);
  }

  void _handleTap() {
    if (!_enabled) return;
    widget.onTap?.call();
  }

  @override
  void didUpdateWidget(covariant _Pressable oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Si on passe disabled à true en cours de route, on reset l'état press
    if (widget.disabled && _down) {
      _down = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.radius ?? BorderRadius.circular(16);

    final scale = _down ? widget.pressedScale : 1.0;
    final opacity = _down ? widget.pressedOpacity : 1.0;
    final disabledOpacity = widget.disabled ? widget.disabledOpacity : 1.0;

    return Semantics(
      button: true,
      enabled: _enabled,
      child: MouseRegion(
        cursor: _enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
        child: Opacity(
          opacity: disabledOpacity,
          child: AnimatedScale(
            scale: scale,
            duration: widget.duration,
            curve: widget.curve,
            child: AnimatedOpacity(
              opacity: opacity,
              duration: widget.duration,
              curve: widget.curve,
              child: Material(
                type: MaterialType.transparency,
                child: InkResponse(
                  onTap: _enabled ? _handleTap : null,
                  onTapDown: _enabled ? (_) => _setDown(true) : null,
                  onTapCancel: _enabled ? () => _setDown(false) : null,
                  onTapUp: _enabled ? (_) => _setDown(false) : null,
                  containedInkWell: true,
                  highlightShape: BoxShape.rectangle,
                  borderRadius: r,
                  child: ClipRRect(borderRadius: r, child: widget.child),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final String avatarLetter;
  final VoidCallback onSearch;
  final VoidCallback onMessages;

  const _TopBar({
    required this.avatarLetter,
    required this.onSearch,
    required this.onMessages,
  });

  @override
  Widget build(BuildContext context) {
    final t = ForumTheme.of(context, skin: ForumSkin.examGPX);

    return SizedBox(
      height: 44,
      child: Row(
        children: [
          _Pressable(
            onTap: () {},
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: t.surface,
                border: Border.all(color: t.strokeStrong),
                boxShadow: t.cardShadow,
              ),
              child: ClipOval(
                child: ColoredBox(
                  color: t.primarySoft,
                  child: Center(
                    child: Text(
                      avatarLetter.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: t.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),
          _GlassCircleButton(
            icon: Icons.mail_outline_rounded,
            onTap: onMessages,
          ),
          const SizedBox(width: 10),
          _GlassCircleButton(icon: Icons.search_rounded, onTap: onSearch),
        ],
      ),
    );
  }
}

class _GlassCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _GlassCircleButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = ForumTheme.of(context, skin: ForumSkin.examGPX);

    return _Pressable(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(17),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            height: 34,
            width: 34,
            decoration: BoxDecoration(
              color: t.glassBg,
              borderRadius: BorderRadius.circular(17),
              border: Border.all(color: t.glassStroke),
            ),
            child: Icon(icon, size: 18, color: t.icon),
          ),
        ),
      ),
    );
  }
}

class _ComposerCard extends StatelessWidget {
  final VoidCallback onTapAsk;
  final VoidCallback onTapAnswer;
  final VoidCallback onTapPost;

  const _ComposerCard({
    required this.onTapAsk,
    required this.onTapAnswer,
    required this.onTapPost,
  });

  @override
  Widget build(BuildContext context) {
    return _Card(
      radius: 20,
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          _Pressable(
            onTap: onTapAsk,
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: _ForumTheme.pill,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: _ForumTheme.outline),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.auto_awesome_rounded,
                    size: 18,
                    color: _ForumTheme.accent,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Que veux-tu demander ou partager ?',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _ForumTheme.placeholder,
                      ),
                    ),
                  ),
                  Icon(Icons.tune_rounded, size: 18, color: _ForumTheme.text2),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _ComposerAction(
                icon: Icons.help_outline_rounded,
                label: 'Ask',
                onTap: onTapAsk,
              ),
              const SizedBox(width: 10),
              _ComposerAction(
                icon: Icons.chat_bubble_outline_rounded,
                label: 'Answer',
                onTap: onTapAnswer,
              ),
              const SizedBox(width: 10),
              _ComposerAction(
                icon: Icons.edit_outlined,
                label: 'Post',
                onTap: onTapPost,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ComposerAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ComposerAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: _Pressable(
        onTap: onTap,
        child: Container(
          height: 32,
          decoration: BoxDecoration(
            color: _ForumTheme.accentSoft,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: _ForumTheme.accent),
              const SizedBox(width: 7),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: _ForumTheme.accent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  final _Post post;
  final VoidCallback onOpen;
  final VoidCallback onMore;
  final VoidCallback onLike;
  final VoidCallback onComments;

  const _PostCard({
    required this.post,
    required this.onOpen,
    required this.onMore,
    required this.onLike,
    required this.onComments,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onOpen,
      child: _Card(
        radius: 22,
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PostHeader(
              username: post.username,
              time: _prettyTime(post.createdAt),
              role: post.authorRole,
              avatarIndex: post.avatarIndex,
              onMore: onMore,
            ),
            const SizedBox(height: 10),

            // ✅ Titre
            Text(
              post.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 15,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 6),

            // ✅ Message
            Text(
              post.content,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600, height: 1.4),
            ),

            if (post.imageUrl != null) ...[
              const SizedBox(height: 12),
              _PostImage(url: post.imageUrl!),
            ],
            const SizedBox(height: 10),
            PostActionsRow(
              likeCount: post.likeCount,
              commentCount: post.commentCount,
              liked: post.likedByMe,
              onLike: onLike,
              onComments: onComments,
            ),
          ],
        ),
      ),
    );
  }
}

class ForumAvatar extends StatelessWidget {
  final int index;
  const ForumAvatar({required this.index});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 18, // ❌ ON NE TOUCHE PAS
      backgroundColor: context.forum.isDark
          ? context.forum.surface2
          : const Color(0xFFEFF4FF),
      child: ClipOval(
        child: Image.asset(
          'assets/icon_profile/$index.png',
          fit: BoxFit.cover,

          // 🔥 C’EST ICI QUE TU AGRANDIS L’AVATAR 🔥
          width: 42,
          height: 42,
        ),
      ),
    );
  }
}

String _prettyTime(DateTime dt) {
  final now = DateTime.now();
  final diff = now.difference(dt);

  if (diff.inMinutes < 1) return "à l’instant";
  if (diff.inMinutes < 60) return "il y a ${diff.inMinutes} min";
  if (diff.inHours < 24) return "il y a ${diff.inHours} h";

  final d = dt.day.toString().padLeft(2, '0');
  final m = dt.month.toString().padLeft(2, '0');
  final hh = dt.hour.toString().padLeft(2, '0');
  final mm = dt.minute.toString().padLeft(2, '0');

  return "$d/$m • $hh:$mm";
}

class _PostImage extends StatelessWidget {
  final String url;

  const _PostImage({required this.url});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: AspectRatio(
        aspectRatio: 16 / 10,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(url, fit: BoxFit.cover),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.08), Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PostStats extends StatelessWidget {
  final int likes;
  final int comments;
  final bool liked;
  final VoidCallback onLike;
  final VoidCallback onComments;

  const _PostStats({
    required this.likes,
    required this.comments,
    required this.liked,
    required this.onLike,
    required this.onComments,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.forum;

    return Row(
      children: [
        _Pressable(
          onTap: onLike,
          child: Row(
            children: [
              Icon(
                liked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                size: 18,
                color: liked ? t.danger : t.iconSoft,
              ),
              const SizedBox(width: 4),
              Text(
                '$likes',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: t.textSoft,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 18),
        _Pressable(
          onTap: onComments,
          child: Row(
            children: [
              Icon(Icons.mode_comment_outlined, size: 18, color: t.iconSoft),
              const SizedBox(width: 4),
              Text(
                '$comments',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: t.textSoft,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  final double radius;
  final EdgeInsets padding;
  final Widget child;

  const _Card({
    required this.radius,
    required this.padding,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final t = ForumTheme.of(context, skin: ForumSkin.examGPX);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: t.stroke),
        boxShadow: t.cardShadow,
      ),
      child: DefaultTextStyle.merge(
        style: TextStyle(color: t.text, fontWeight: FontWeight.w600),
        child: child,
      ),
    );
  }
}

class _Fab extends StatelessWidget {
  final VoidCallback onCreatePost;
  final VoidCallback onCreateGroup;

  const _Fab({
    required this.onCreatePost,
    required this.onCreateGroup,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.forum;

    return Positioned(
      right: 16,
      bottom: 16 + 18,
      child: _Pressable(
        radius: BorderRadius.circular(999),
        onTap: () async {
          await showModalBottomSheet<void>(
            context: context,
            isScrollControlled: false,
            backgroundColor: Colors.transparent,
            barrierColor: t.overlayScrim,
            builder: (_) => _FabActionSheet(
              onCreatePost: onCreatePost,
              onCreateGroup: onCreateGroup,
            ),
          );
        },
        child: Container(
          height: 52,
          width: 52,
          decoration: BoxDecoration(
            color: t.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: t.primary.withOpacity(t.isDark ? 0.30 : 0.35),
                blurRadius: 40,
                offset: const Offset(0, 18),
              ),
              BoxShadow(
                color: t.primary.withOpacity(t.isDark ? 0.12 : 0.15),
                spreadRadius: 6,
              ),
            ],
          ),
          child: const Icon(Icons.add_rounded, size: 24, color: Colors.white),
        ),
      ),
    );
  }
}

enum _FabAction { post, group }

class _FabActionSheet extends StatelessWidget {
  final VoidCallback onCreatePost;
  final VoidCallback onCreateGroup;

  const _FabActionSheet({
    required this.onCreatePost,
    required this.onCreateGroup,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.forum;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Container(
        color: Colors.transparent,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(
                decoration: BoxDecoration(
                  color: t.sheetBg.withOpacity(t.isDark ? 0.92 : 0.98),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                  border: Border.all(color: t.stroke),
                ),
                padding: EdgeInsets.fromLTRB(
                  16,
                  12,
                  16,
                  16 + MediaQuery.of(context).padding.bottom,
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Drag handle
                      Container(
                        height: 4,
                        width: 44,
                        decoration: BoxDecoration(
                          color: t.divider,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      const SizedBox(height: 14),

                      Row(
                        children: [
                          Text(
                            "Créer",
                            style: TextStyle(
                              color: t.text, // ✅ texte visible en dark
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                          ),
                          const Spacer(),
                          _Pressable(
                            radius: BorderRadius.circular(14),
                            onTap: () => Navigator.pop(context),
                            child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: Icon(Icons.close_rounded, color: t.icon),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      _CreateTile(
                        icon: Icons.edit_rounded,
                        title: "Créer une discussion",
                        subtitle: "Poser une question, partager une info…",
                        onTap: () {
                          Navigator.pop(context);
                          onCreatePost();
                        },
                      ),

                      _CreateTile(
                        icon: Icons.group_add_rounded,
                        title: "Créer un groupe",
                        subtitle: "Discuter à plusieurs (DM / groupe)",
                        onTap: () {
                          Navigator.pop(context);
                          onCreateGroup();
                        },
                      ),

                      const SizedBox(height: 2),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CreateTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _CreateTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.forum;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: _Pressable(
        radius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          height: 66,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: t.surface, // ✅ surface dark
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: t.stroke),
          ),
          child: Row(
            children: [
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: t.primarySoft,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: t.primaryStroke),
                ),
                child: Icon(icon, color: t.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: t.text, // ✅ visible
                        fontWeight: FontWeight.w900,
                        fontSize: 14.5,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: t.textSoft, // ✅ lisible en dark
                        fontWeight: FontWeight.w700,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Icon(Icons.chevron_right_rounded, color: t.iconSoft),
            ],
          ),
        ),
      ),
    );
  }
}

class _CreatePostSheet extends StatefulWidget {
  final String hint;
  final Future<_Post> Function({
    required String title,
    required String body,
    XFile? image,
  })
  onSubmit;

  const _CreatePostSheet({
    required this.hint,
    required this.onSubmit,
    super.key,
  });

  @override
  State<_CreatePostSheet> createState() => _CreatePostSheetState();
}

class _CreatePostSheetState extends State<_CreatePostSheet> {
  final _titleCtrl = TextEditingController();
  final _bodyCtrl = TextEditingController();

  bool _saving = false;
  String? _err;
  XFile? _picked;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _bodyCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final x = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (!mounted) return;
      setState(() => _picked = x);
    } catch (e) {
      if (!mounted) return;
      setState(() => _err = e.toString());
    }
  }

  Future<void> _submit() async {
    final title = _titleCtrl.text.trim();
    final body = _bodyCtrl.text.trim();

    if (title.isEmpty) {
      setState(() => _err = "Ajoute un titre (court et clair).");
      return;
    }
    if (body.isEmpty) {
      setState(() => _err = "Écris ton message.");
      return;
    }

    setState(() {
      _saving = true;
      _err = null;
    });

    try {
      final created = await widget.onSubmit(
        title: title,
        body: body,
        image: _picked,
      );
      if (!mounted) return;
      Navigator.pop(context, created);
    } catch (e) {
      if (!mounted) return;
      setState(() => _err = e.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = ForumTheme.of(context, skin: ForumSkin.examGPX);
    final inset = MediaQuery.of(context).viewInsets.bottom;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Container(
        color: Colors.transparent,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                padding: EdgeInsets.fromLTRB(16, 12, 16, 14 + inset),
                decoration: BoxDecoration(
                  color: t.sheetBg.withOpacity(t.isDark ? 0.92 : 0.98),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                  border: Border.all(color: t.stroke),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // drag handle
                    Container(
                      height: 4,
                      width: 44,
                      decoration: BoxDecoration(
                        color: t.divider,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Text(
                          "Créer une publication",
                          style: TextStyle(
                            color: t.text,
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        _Pressable(
                          onTap: _saving ? null : () => Navigator.pop(context),
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Icon(Icons.close_rounded, color: t.icon),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // Title
                    _Card(
                      radius: 20,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.title_rounded, color: t.primary),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _titleCtrl,
                              enabled: !_saving,
                              style: TextStyle(
                                color: t.text,
                                fontWeight: FontWeight.w800,
                              ),
                              decoration: InputDecoration(
                                hintText:
                                    "Titre (ex : Question sur l’examen GPX)",
                                hintStyle: TextStyle(
                                  color: t.textMuted,
                                  fontWeight: FontWeight.w700,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Body
                    _Card(
                      radius: 20,
                      padding: const EdgeInsets.all(14),
                      child: TextField(
                        controller: _bodyCtrl,
                        enabled: !_saving,
                        maxLines: 6,
                        minLines: 6,
                        style: TextStyle(
                          color: t.text,
                          fontWeight: FontWeight.w700,
                          height: 1.25,
                        ),
                        decoration: InputDecoration(
                          hintText: widget.hint.isEmpty
                              ? "Écris ton message…"
                              : widget.hint,
                          hintStyle: TextStyle(
                            color: t.textMuted,
                            fontWeight: FontWeight.w700,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Image
                    _Pressable(
                      disabled: _saving,
                      radius: BorderRadius.circular(20),
                      onTap: _pickImage,
                      child: _Card(
                        radius: 20,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.image_rounded, color: t.primary),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _picked == null
                                    ? "Ajouter une image"
                                    : "Image sélectionnée",
                                style: TextStyle(
                                  color: t.text,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Container(
                              height: 26,
                              width: 26,
                              decoration: BoxDecoration(
                                color: t.primarySoft,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: t.primaryStroke),
                              ),
                              child: Icon(
                                Icons.add_rounded,
                                size: 18,
                                color: t.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    if (_err != null) ...[
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: t.danger.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: t.danger.withOpacity(0.22)),
                        ),
                        child: Text(
                          _err!,
                          style: TextStyle(
                            color: t.danger,
                            fontWeight: FontWeight.w800,
                            fontSize: 12.5,
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _saving ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: t.primary,
                          foregroundColor: t.textOnPrimary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: _saving
                            ? SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.4,
                                  color: t.textOnPrimary,
                                ),
                              )
                            : const Text(
                                "Publier",
                                style: TextStyle(fontWeight: FontWeight.w900),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchOverlay extends StatelessWidget {
  final TextEditingController controller;
  final bool loading;
  final List<_SearchHit> hits;
  final VoidCallback onClose;
  final ValueChanged<String> onChanged;
  final ValueChanged<_SearchHit> onOpenPost;

  const _SearchOverlay({
    required this.controller,
    required this.loading,
    required this.hits,
    required this.onClose,
    required this.onChanged,
    required this.onOpenPost,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final t = ForumTheme.of(context, skin: ForumSkin.examGPX);

    return Positioned.fill(
      child: Material(
        color: t.overlayScrim,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(26),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: Container(
                  decoration: BoxDecoration(
                    color: t.sheetBg.withOpacity(t.isDark ? 0.92 : 0.98),
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(color: t.stroke),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Rechercher",
                                style: TextStyle(
                                  color: t.text,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            _Pressable(
                              radius: BorderRadius.circular(14),
                              onTap: onClose,
                              child: Padding(
                                padding: const EdgeInsets.all(6),
                                child: Icon(Icons.close_rounded, color: t.icon),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: TextField(
                          controller: controller,
                          onChanged: onChanged,
                          autofocus: true,
                          style: TextStyle(
                            color: t.text,
                            fontWeight: FontWeight.w800,
                          ),
                          decoration: t.inputDecoration(
                            hint: "École, date, oral, sport…",
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              color: t.iconSoft,
                            ),
                            suffixIcon: _suffixIcon(context),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      Expanded(
                        child: _SearchBody(
                          loading: loading,
                          query: controller.text.trim(),
                          hits: hits,
                          onOpenPost: onOpenPost,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget? _suffixIcon(BuildContext context) {
    final t = ForumTheme.of(context, skin: ForumSkin.examGPX);

    if (loading) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2.2, color: t.primary),
        ),
      );
    }

    if (controller.text.trim().isEmpty) return null;

    return _Pressable(
      radius: BorderRadius.circular(14),
      onTap: () {
        controller.clear();
        onChanged('');
      },
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Icon(Icons.close_rounded, size: 18, color: t.iconSoft),
      ),
    );
  }
}

class _SearchBody extends StatelessWidget {
  final bool loading;
  final String query;
  final List<_SearchHit> hits;
  final ValueChanged<_SearchHit> onOpenPost;

  const _SearchBody({
    required this.loading,
    required this.query,
    required this.hits,
    required this.onOpenPost,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final t = ForumTheme.of(context, skin: ForumSkin.examGPX);

    if (query.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Text(
            "Tape un mot-clé (école, oral, sport…)",
            textAlign: TextAlign.center,
            style: TextStyle(color: t.textSoft, fontWeight: FontWeight.w800),
          ),
        ),
      );
    }

    if (!loading && hits.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Text(
            "Aucun résultat pour “$query”.",
            textAlign: TextAlign.center,
            style: TextStyle(color: t.textSoft, fontWeight: FontWeight.w800),
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 14),
      itemCount: hits.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) =>
          _SearchHitTile(hit: hits[i], onTap: () => onOpenPost(hits[i])),
    );
  }
}

class _SearchHitTile extends StatelessWidget {
  final _SearchHit hit;
  final VoidCallback onTap;

  const _SearchHitTile({required this.hit, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final t = ForumTheme.of(context, skin: ForumSkin.examGPX);

    final title = hit.title.trim().isEmpty ? "Publication" : hit.title.trim();
    final snippet = hit.snippet.trim();

    return _Pressable(
      radius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: t.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: t.stroke),
        ),
        child: Row(
          children: [
            Container(
              height: 38,
              width: 38,
              decoration: BoxDecoration(
                color: t.primarySoft,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: t.primaryStroke),
              ),
              child: Icon(Icons.article_rounded, color: t.primary, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: t.text,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  if (snippet.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      snippet,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: t.textSoft,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 10),
            Icon(Icons.chevron_right_rounded, color: t.iconSoft),
          ],
        ),
      ),
    );
  }
}

class _SearchEmpty extends StatelessWidget {
  const _SearchEmpty();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Tape un mot-clé (école, oral, sport…)",
        style: TextStyle(color: _ForumTheme.text2, fontWeight: FontWeight.w800),
      ),
    );
  }
}

enum _PostMenuAction {
  report,
  block,
  delete,
  promoteMod,
  demoteMod,

  // ✅ Admin-only mute
  mute1h,
  mute12h,
  mute24h,
  mute7d,
  mute30d,
  muteForever,
  unmute,
}

class _PostMenuSheet extends StatelessWidget {
  final bool isMod;
  final bool isAdmin;
  final bool isAlreadyBlocked;
  final String targetRole;
  final bool canUnmute; // ✅ si utilisateur déjà mute

  const _PostMenuSheet({
    required this.isMod,
    required this.isAdmin,
    required this.isAlreadyBlocked,
    required this.targetRole,
    required this.canUnmute,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.forum;
    final tr = targetRole.trim().toLowerCase();
    final isTargetModerator = tr == 'moderator';

    return _SheetShell(
      title: "Options",
      children: [
        _SheetAction(
          icon: Icons.flag_outlined,
          label: "Signaler ce post",
          color: t.danger,
          onTap: () => Navigator.pop(context, _PostMenuAction.report),
        ),

        _SheetAction(
          icon: Icons.block_outlined,
          label: isAlreadyBlocked
              ? "Utilisateur déjà bloqué"
              : "Bloquer l’utilisateur",
          color: t.text,
          disabled: isAlreadyBlocked,
          onTap: () => Navigator.pop(context, _PostMenuAction.block),
        ),

        // ✅ Admin controls
        if (isAdmin) ...[
          const SizedBox(height: 2),

          _SheetAction(
            icon: canUnmute
                ? Icons.lock_open_rounded
                : Icons.lock_clock_rounded,
            label: canUnmute ? "Retirer le mute" : "Mute (modération)",
            color: t.danger,
            onTap: () => Navigator.pop(
              context,
              canUnmute ? _PostMenuAction.unmute : _PostMenuAction.mute12h,
            ),
          ),

          if (!canUnmute) ...[
            _SheetAction(
              icon: Icons.timer_rounded,
              label: "Mute 1h",
              color: t.danger,
              onTap: () => Navigator.pop(context, _PostMenuAction.mute1h),
            ),
            _SheetAction(
              icon: Icons.timer_rounded,
              label: "Mute 12h",
              color: t.danger,
              onTap: () => Navigator.pop(context, _PostMenuAction.mute12h),
            ),
            _SheetAction(
              icon: Icons.timer_rounded,
              label: "Mute 24h",
              color: t.danger,
              onTap: () => Navigator.pop(context, _PostMenuAction.mute24h),
            ),
            _SheetAction(
              icon: Icons.timer_rounded,
              label: "Mute 1 semaine",
              color: t.danger,
              onTap: () => Navigator.pop(context, _PostMenuAction.mute7d),
            ),
            _SheetAction(
              icon: Icons.timer_rounded,
              label: "Mute 1 mois",
              color: t.danger,
              onTap: () => Navigator.pop(context, _PostMenuAction.mute30d),
            ),
            _SheetAction(
              icon: Icons.block_rounded,
              label: "Mute définitif",
              color: t.danger,
              onTap: () => Navigator.pop(context, _PostMenuAction.muteForever),
            ),
          ],

          const SizedBox(height: 2),

          _SheetAction(
            icon: isTargetModerator
                ? Icons.remove_moderator_outlined
                : Icons.admin_panel_settings_outlined,
            label: isTargetModerator
                ? "Retirer modérateur"
                : "Promouvoir en modérateur",
            // couleur “admin” premium (ambre)
            color: const Color(0xFFF59E0B),
            onTap: () => Navigator.pop(
              context,
              isTargetModerator
                  ? _PostMenuAction.demoteMod
                  : _PostMenuAction.promoteMod,
            ),
          ),
        ],

        // ✅ Mod controls
        if (isMod)
          _SheetAction(
            icon: Icons.delete_outline,
            label: "Supprimer (modération)",
            color: t.danger,
            onTap: () => Navigator.pop(context, _PostMenuAction.delete),
          ),
      ],
    );
  }
}

class _PostMenuButton extends StatelessWidget {
  final VoidCallback onTap;

  const _PostMenuButton({required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.forum;

    return _Pressable(
      onTap: onTap,
      child: Icon(Icons.more_horiz_rounded, size: 20, color: t.iconSoft),
    );
  }
}

class _ReportSheet extends StatefulWidget {
  const _ReportSheet();

  @override
  State<_ReportSheet> createState() => _ReportSheetState();
}

class _ReportSheetState extends State<_ReportSheet> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _SheetShell(
      title: "Signaler",
      children: [
        Container(
          decoration: BoxDecoration(
            color: _ForumTheme.pill,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: _ForumTheme.outline),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: TextField(
            controller: _ctrl,
            maxLines: 4,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "Explique brièvement le problème…",
              hintStyle: TextStyle(
                color: _ForumTheme.placeholder,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _Pressable(
                onTap: () => Navigator.pop(context),
                child: Container(
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(21),
                    border: Border.all(color: _ForumTheme.outline),
                  ),
                  child: const Center(
                    child: Text(
                      "Annuler",
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _Pressable(
                onTap: () => Navigator.pop(context, _ctrl.text),
                child: Container(
                  height: 42,
                  decoration: BoxDecoration(
                    color: _ForumTheme.danger,
                    borderRadius: BorderRadius.circular(21),
                    boxShadow: [
                      BoxShadow(
                        color: _ForumTheme.danger.withOpacity(0.25),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      "Envoyer",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SheetShell extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SheetShell({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final t = ForumTheme.of(context, skin: ForumSkin.examGPX);
    final inset = MediaQuery.of(context).viewInsets.bottom;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Container(
        color: Colors.transparent,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(
                padding: EdgeInsets.fromLTRB(16, 12, 16, 16 + inset),
                decoration: BoxDecoration(
                  color: t.sheetBg.withOpacity(t.isDark ? 0.92 : 0.98),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                  border: Border.all(color: t.stroke),
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 4,
                        width: 44,
                        decoration: BoxDecoration(
                          color: t.divider,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                              color: t.text,
                            ),
                          ),
                          const Spacer(),
                          _Pressable(
                            onTap: () => Navigator.pop(context),
                            child: Icon(Icons.close_rounded, color: t.icon),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...children,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SheetAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final bool disabled;
  final VoidCallback onTap;

  const _SheetAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
    this.disabled = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.forum;
    final fg = (color ?? t.text).withOpacity(disabled ? 0.55 : 1.0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: _Pressable(
        disabled: disabled,
        radius: BorderRadius.circular(18),
        onTap: disabled ? null : onTap,
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: t.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: disabled ? t.stroke.withOpacity(0.65) : t.stroke,
            ),
          ),
          child: Row(
            children: [
              Container(
                height: 34,
                width: 34,
                decoration: BoxDecoration(
                  color: disabled ? t.chipBg : t.primarySoft,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: disabled ? t.stroke : t.primaryStroke,
                  ),
                ),
                child: Icon(
                  icon,
                  color: disabled ? t.iconSoft : t.primary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(fontWeight: FontWeight.w800, color: fg),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: disabled ? t.iconSoft.withOpacity(0.6) : t.iconSoft,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkeletonList extends StatelessWidget {
  const _SkeletonList();

  @override
  Widget build(BuildContext context) {
    Widget skel() => Container(
      height: 160,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.70),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _ForumTheme.outline),
      ),
    );

    return Column(children: [skel(), skel(), skel()]);
  }
}

class _EmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final String cta;
  final VoidCallback onTap;

  const _EmptyState({
    required this.title,
    required this.subtitle,
    required this.cta,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _Card(
      radius: 22,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(
              color: _ForumTheme.text2,
              fontWeight: FontWeight.w600,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          _Pressable(
            onTap: onTap,
            child: Container(
              height: 42,
              decoration: BoxDecoration(
                color: _ForumTheme.accent,
                borderRadius: BorderRadius.circular(21),
                boxShadow: [
                  BoxShadow(
                    color: _ForumTheme.accent.withOpacity(0.25),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  cta,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum _CreateAction { post, group }

class _CreateActionSheet extends StatelessWidget {
  const _CreateActionSheet();

  @override
  Widget build(BuildContext context) {
    return _SheetShell(
      title: "Créer",
      children: [
        _SheetAction(
          icon: Icons.edit_outlined,
          label: "Publier un message",
          color: _ForumTheme.text,
          onTap: () => Navigator.pop(context, _CreateAction.post),
        ),
        _SheetAction(
          icon: Icons.group_add_outlined,
          label: "Créer un groupe",
          color: _ForumTheme.text,
          onTap: () => Navigator.pop(context, _CreateAction.group),
        ),
      ],
    );
  }
}

class _Comment {
  final String id;
  final String postId;
  final String authorId;
  final String content;
  final DateTime createdAt;
  final String? parentId;

  final String username;
  final String role;
  final int avatarIndex;

  const _Comment({
    required this.id,
    required this.postId,
    required this.authorId,
    required this.content,
    required this.createdAt,
    required this.parentId,
    required this.username,
    required this.role,
    required this.avatarIndex,
  });

  factory _Comment.fromRow(Map<String, dynamic> r) {
    final p = r['user_profiles'] as Map<String, dynamic>?;
    return _Comment(
      id: r['id'].toString(),
      postId: r['post_id'].toString(),
      authorId: r['author_id'].toString(),
      content: (r['content'] as String?) ?? '',
      createdAt:
          DateTime.tryParse((r['created_at'] as String?) ?? '') ??
          DateTime.now(),
      parentId: r['parent_id']?.toString(),
      username: (p?['username'] as String?) ?? 'Utilisateur',
      role: (p?['role'] as String?)?.toLowerCase() ?? 'active',
      avatarIndex: (p?['avatar_index'] as int?) ?? 1,
    );
  }
}

class ForumInboxPage extends StatefulWidget {
  const ForumInboxPage({super.key});

  @override
  State<ForumInboxPage> createState() => _ForumInboxPageState();
}

class _ForumInboxPageState extends State<ForumInboxPage> {
  final _sb = Supabase.instance.client;

  bool _loading = true;
  String? _err;

  List<_InboxRoom> _rooms = [];

  @override
  void initState() {
    super.initState();
    _loadInbox();
  }

  Future<void> _loadInbox() async {
    setState(() {
      _loading = true;
      _err = null;
    });

    try {
      final me = _sb.auth.currentUser;
      if (me == null) throw Exception("Not authenticated");

      final membershipRows = await _sb
          .from('forum_room_members')
          .select('room_id')
          .eq('user_id', me.id);

      final roomIds = membershipRows
          .map((e) => e['room_id'].toString())
          .toList();

      if (roomIds.isEmpty) {
        if (!mounted) return;
        setState(() => _rooms = []);
        return;
      }

      final roomRows = await _sb
          .from('forum_rooms')
          .select('id, title, is_group, created_at')
          .inFilter('id', roomIds)
          .order('created_at', ascending: false);

      final result = <_InboxRoom>[];
      for (final r in roomRows) {
        final rid = r['id'].toString();

        final lastMsg = await _sb
            .from('forum_messages_exam_gpx')
            .select('content, created_at, sender_id')
            .eq('room_id', rid)
            .order('created_at', ascending: false)
            .limit(1)
            .maybeSingle();

        result.add(
          _InboxRoom(
            id: rid,
            title: (r['title'] as String?)?.trim(),
            isGroup: (r['is_group'] as bool?) ?? false,
            lastMessage: (lastMsg?['content'] as String?)?.trim(),
            lastAt: DateTime.tryParse(
              (lastMsg?['created_at'] as String?) ?? '',
            ),
          ),
        );
      }

      if (!mounted) return;
      setState(() => _rooms = result);
    } catch (e) {
      if (!mounted) return;
      setState(() => _err = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _openRoom(_InboxRoom room) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            ForumChatPage(conversationId: room.id, title: room.displayTitle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.forum;

    return Scaffold(
      backgroundColor: t.bgTop,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        foregroundColor: t.text,
        title: Text(
          "Messages",
          style: TextStyle(fontWeight: FontWeight.w900, color: t.text),
        ),
        iconTheme: IconThemeData(color: t.icon),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: t.backgroundGradient),
        child: RefreshIndicator(
          color: t.primary,
          backgroundColor: t.surface,
          onRefresh: _loadInbox,
          child: _loading
              ? Center(child: CircularProgressIndicator(color: t.primary))
              : (_err != null)
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    const SizedBox(height: 28),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          _err!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: t.danger,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : _rooms.isEmpty
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [SizedBox(height: 60), _InboxEmptyState()],
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 22),
                  itemCount: _rooms.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    final room = _rooms[i];
                    return _InboxRoomTile(
                      room: room,
                      onTap: () => _openRoom(room),
                    );
                  },
                ),
        ),
      ),
    );
  }
}

class _InboxRoom {
  final String id;
  final String? title;
  final bool isGroup;
  final String? lastMessage;
  final DateTime? lastAt;

  _InboxRoom({
    required this.id,
    required this.title,
    required this.isGroup,
    required this.lastMessage,
    required this.lastAt,
  });

  String get displayTitle {
    final t = (title ?? '').trim();
    if (t.isNotEmpty) return t;
    return isGroup ? "Groupe" : "Discussion";
  }
}

class _InboxEmptyState extends StatelessWidget {
  const _InboxEmptyState();

  @override
  Widget build(BuildContext context) {
    final t = context.forum;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Column(
          children: [
            Container(
              height: 74,
              width: 74,
              decoration: BoxDecoration(
                color: t.primarySoft,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: t.stroke),
                boxShadow: t.cardShadow,
              ),
              child: Icon(
                Icons.mark_email_unread_rounded,
                size: 32,
                color: t.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Vous n’avez aucun message",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 18,
                color: t.text,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Démarrez une discussion depuis un commentaire ou créez un groupe.\nTout apparaîtra ici, comme sur Telegram.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: t.textSoft,
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InboxRoomTile extends StatelessWidget {
  final _InboxRoom room;
  final VoidCallback onTap;

  const _InboxRoomTile({required this.room, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = context.forum;

    return _Card(
      radius: 20,
      padding: const EdgeInsets.all(14),
      child: _Pressable(
        radius: BorderRadius.circular(20),
        onTap: onTap,
        child: Row(
          children: [
            Container(
              height: 46,
              width: 46,
              decoration: BoxDecoration(
                color: room.isGroup ? t.primarySoft : t.surface2,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: t.stroke),
              ),
              child: Icon(
                room.isGroup ? Icons.group_rounded : Icons.chat_bubble_rounded,
                color: t.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    room.displayTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 14.5,
                      color: t.text,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    (room.lastMessage == null || room.lastMessage!.isEmpty)
                        ? (room.isGroup
                              ? "Aucun message dans ce groupe"
                              : "Aucun message pour l’instant")
                        : room.lastMessage!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: t.textSoft,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Icon(Icons.chevron_right_rounded, color: t.iconSoft),
          ],
        ),
      ),
    );
  }
}

class ForumChatPage extends StatefulWidget {
  final String conversationId;
  final String title;

  const ForumChatPage({
    super.key,
    required this.conversationId,
    required this.title,
  });

  @override
  State<ForumChatPage> createState() => _ForumChatPageState();
}

class _ForumChatPageState extends State<ForumChatPage> {
  final _sb = Supabase.instance.client;
  final _ctrl = TextEditingController();

  bool _loading = true;
  String? _err;
  List<Map<String, dynamic>> _msgs = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _err = null;
    });

    try {
      final rows = await _sb
          .from('forum_messages_exam_gpx')
          .select('id, sender_id, body, created_at')
          .eq('conversation_id', widget.conversationId)
          .order('created_at', ascending: true);

      setState(() => _msgs = List<Map<String, dynamic>>.from(rows));
    } catch (e) {
      setState(() => _err = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _send() async {
    final me = _sb.auth.currentUser;
    if (me == null) return;

    final body = _ctrl.text.trim();
    if (body.isEmpty) return;

    _ctrl.clear();

    setState(() {
      _msgs.add({
        'id': 'temp_${DateTime.now().millisecondsSinceEpoch}',
        'sender_id': me.id,
        'body': body,
        'created_at': DateTime.now().toIso8601String(),
      });
    });

    try {
      await _sb.from('forum_messages_exam_gpx').insert({
        'conversation_id': widget.conversationId,
        'sender_id': me.id,
        'body': body,
        'created_at': DateTime.now().toUtc().toIso8601String(),
      });
    } catch (e) {
      await _load();
      setState(() => _err = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final me = _sb.auth.currentUser;

    return Scaffold(
      backgroundColor: _ForumTheme.bgTop,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.white,
        foregroundColor: _ForumTheme.text,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _err != null
                ? Center(
                    child: Text(
                      _err!,
                      style: const TextStyle(color: _ForumTheme.danger),
                    ),
                  )
                : (_msgs.isEmpty)
                ? const Center(
                    child: Text(
                      "Aucun message pour le moment.\nEnvoyez le premier pour démarrer la conversation.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _ForumTheme.text2,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _msgs.length,
                    itemBuilder: (_, i) {
                      final m = _msgs[i];
                      final mine = me != null && m['sender_id'] == me.id;

                      return Align(
                        alignment: mine
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: mine ? _ForumTheme.accentSoft : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: _ForumTheme.outline),
                          ),
                          child: Text(
                            (m['body'] as String?) ?? '',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: _ForumTheme.outline)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _ctrl,
                    decoration: const InputDecoration(
                      hintText: "Écrivez un message…",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                _Pressable(
                  onTap: _send,
                  child: Container(
                    height: 44,
                    width: 44,
                    decoration: BoxDecoration(
                      color: _ForumTheme.accent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.send_rounded, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentsSheet extends StatefulWidget {
  final _Post post;
  final _Profile me;
  final SupabaseClient supabase;
  final bool isMuted;

  final bool isMod;
  final Future<void> Function(String userId, String username) onSendMessage;
  final Future<void> Function(String commentId) onDeleteComment;
  final Future<void> Function(String commentId, String reason) onReportComment;

  const _CommentsSheet({
    required this.post,
    required this.me,
    required this.supabase,
    required this.isMuted,
    required this.isMod,
    required this.onSendMessage,
    required this.onDeleteComment,
    required this.onReportComment,
    super.key,
  });

  @override
  State<_CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<_CommentsSheet> {
  final TextEditingController _ctrl = TextEditingController();

  bool _loading = true;
  bool _sending = false;
  String? _err;

  List<Map<String, dynamic>> _comments = <Map<String, dynamic>>[];

  String? _replyToCommentId;
  String? _replyToLabel;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _err = null;
    });

    try {
      final rows = await widget.supabase
          .from('forum_post_comments_exam_gpx')
          .select('''
            id,
            post_id,
            parent_id,
            author_id,
            content,
            created_at,
            is_deleted,
            user_profiles (
              username,
              avatar_index
            )
          ''')
          .eq('post_id', widget.post.id)
          .eq('is_deleted', false)
          .order('created_at', ascending: true);

      final list = rows
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();

      if (!mounted) return;
      setState(() => _comments = list);
    } catch (e) {
      if (!mounted) return;
      setState(() => _err = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _send() async {
    if (widget.isMuted || _sending) return;

    final msg = _ctrl.text.trim();
    if (msg.isEmpty) return;

    setState(() => _sending = true);

    try {
      await widget.supabase.from('forum_post_comments_exam_gpx').insert({
        'post_id': widget.post.id,
        'parent_id': _replyToCommentId,
        'author_id': widget.me.uid,
        'content': msg,
        'is_deleted': false,
        'created_at': DateTime.now().toUtc().toIso8601String(),
      });

      _ctrl.clear();
      setState(() {
        _replyToCommentId = null;
        _replyToLabel = null;
      });

      await _load();
    } catch (e) {
      if (!mounted) return;
      AppNotifier.error(context, title: "Erreur", message: e.toString());
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _openMenuForComment({
    required String commentId,
    required String authorId,
    required String authorUsername,
  }) async {
    // 🔥 Ici tu gardes TON menu actuel si tu l’as déjà.
    // Je laisse une version minimaliste compatible.
    final t = ForumTheme.of(context, skin: ForumSkin.examGPX);

    final action = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _Card(
        radius: 22,
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Options",
              style: TextStyle(color: t.text, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.message_rounded, color: t.icon),
              title: Text("Message privé", style: TextStyle(color: t.text)),
              onTap: () => Navigator.pop(context, "dm"),
            ),
            ListTile(
              leading: Icon(Icons.flag_rounded, color: t.danger),
              title: Text("Signaler", style: TextStyle(color: t.text)),
              onTap: () => Navigator.pop(context, "report"),
            ),
            if (widget.isMod)
              ListTile(
                leading: Icon(Icons.delete_rounded, color: t.danger),
                title: Text("Supprimer", style: TextStyle(color: t.text)),
                onTap: () => Navigator.pop(context, "delete"),
              ),
          ],
        ),
      ),
    );

    if (action == null) return;

    if (action == "dm") {
      await widget.onSendMessage(authorId, authorUsername);
      return;
    }

    if (action == "delete") {
      await widget.onDeleteComment(commentId);
      await _load();
      return;
    }

    if (action == "report") {
      final reason = await _askReason();
      if (reason == null) return;
      await widget.onReportComment(commentId, reason);
      return;
    }
  }

  Future<String?> _askReason() async {
    final t = ForumTheme.of(context, skin: ForumSkin.examGPX);
    final ctrl = TextEditingController();

    final res = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        final inset = MediaQuery.of(context).viewInsets.bottom;
        return Padding(
          padding: EdgeInsets.only(bottom: inset),
          child: _Card(
            radius: 22,
            padding: const EdgeInsets.all(14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Motif du signalement",
                  style: TextStyle(color: t.text, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 10),
                _Card(
                  radius: 18,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: TextField(
                    controller: ctrl,
                    maxLines: 3,
                    style: TextStyle(color: t.text),
                    decoration: InputDecoration(
                      hintText: "Explique brièvement…",
                      hintStyle: TextStyle(color: t.textMuted),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Annuler"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: t.primary,
                          foregroundColor: t.textOnPrimary,
                        ),
                        onPressed: () =>
                            Navigator.pop(context, ctrl.text.trim()),
                        child: const Text("Envoyer"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    final r = res?.trim();
    if (r == null || r.isEmpty) return null;
    return r;
  }

  @override
  Widget build(BuildContext context) {
    final t = ForumTheme.of(context, skin: ForumSkin.examGPX);
    final inset = MediaQuery.of(context).viewInsets.bottom;

    final top = _comments.where((c) => c['parent_id'] == null).toList();

    final repliesByParent = <String, List<Map<String, dynamic>>>{};
    for (final c in _comments.where((c) => c['parent_id'] != null)) {
      final pid = c['parent_id'].toString();
      (repliesByParent[pid] ??= []).add(c);
    }

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Container(
        color: Colors.transparent,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.82,
                padding: EdgeInsets.fromLTRB(16, 14, 16, 12 + inset),
                decoration: BoxDecoration(
                  color: t.sheetBg.withOpacity(t.isDark ? 0.92 : 0.98),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(26),
                  ),
                  border: Border.all(color: t.stroke),
                ),
                child: Column(
                  children: [
                    Container(
                      height: 4,
                      width: 44,
                      decoration: BoxDecoration(
                        color: t.divider,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Text(
                          "Commentaires",
                          style: TextStyle(
                            color: t.text,
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        _Pressable(
                          radius: BorderRadius.circular(14),
                          onTap: () => Navigator.pop(context),
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Icon(Icons.close_rounded, color: t.icon),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    if (widget.isMuted)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: t.danger.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: t.danger.withOpacity(0.22)),
                        ),
                        child: Text(
                          "Commentaires désactivés pendant le mute.",
                          style: TextStyle(
                            color: t.danger,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),

                    const SizedBox(height: 10),

                    Expanded(
                      child: _loading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: t.primary,
                              ),
                            )
                          : (_err != null)
                          ? Center(
                              child: Text(
                                _err!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: t.danger,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            )
                          : (top.isEmpty)
                          ? Center(
                              child: Text(
                                "Aucun commentaire.\nLance la discussion 👇",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: t.textSoft,
                                  fontWeight: FontWeight.w900,
                                  height: 1.25,
                                ),
                              ),
                            )
                          : ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: top.length,
                              itemBuilder: (_, i) {
                                final c = top[i];

                                final id = c['id'].toString();
                                final authorId = c['author_id'].toString();

                                final profile =
                                    (c['user_profiles']
                                        as Map<String, dynamic>?) ??
                                    {};
                                final uname =
                                    (profile['username'] as String?) ??
                                    "Utilisateur";
                                final avatar =
                                    (profile['avatar_index'] as int?) ?? 1;

                                final replies = repliesByParent[id] ?? [];

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _CommentTile(
                                        username: uname,
                                        avatarIndex: avatar,
                                        content:
                                            (c['content'] as String?) ?? '',
                                        onReply: () {
                                          setState(() {
                                            _replyToCommentId = id;
                                            _replyToLabel = uname;
                                          });
                                        },
                                        onMore: () => _openMenuForComment(
                                          commentId: id,
                                          authorId: authorId,
                                          authorUsername: uname,
                                        ),
                                      ),
                                      if (replies.isNotEmpty)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 34,
                                            top: 8,
                                          ),
                                          child: Column(
                                            children: replies.map((r) {
                                              final rid = r['id'].toString();
                                              final rAuthorId = r['author_id']
                                                  .toString();

                                              final rp =
                                                  (r['user_profiles']
                                                      as Map<
                                                        String,
                                                        dynamic
                                                      >?) ??
                                                  {};
                                              final rName =
                                                  (rp['username'] as String?) ??
                                                  "Utilisateur";
                                              final rAvatar =
                                                  (rp['avatar_index']
                                                      as int?) ??
                                                  1;

                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                  bottom: 8,
                                                ),
                                                child: _CommentTile(
                                                  isReply: true,
                                                  username: rName,
                                                  avatarIndex: rAvatar,
                                                  content:
                                                      (r['content']
                                                          as String?) ??
                                                      '',
                                                  onReply: () {
                                                    setState(() {
                                                      _replyToCommentId = id;
                                                      _replyToLabel = rName;
                                                    });
                                                  },
                                                  onMore: () =>
                                                      _openMenuForComment(
                                                        commentId: rid,
                                                        authorId: rAuthorId,
                                                        authorUsername: rName,
                                                      ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),

                    const SizedBox(height: 10),

                    if (_replyToLabel != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: t.primarySoft,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: t.stroke),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Réponse à $_replyToLabel",
                                style: TextStyle(
                                  color: t.text,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            _Pressable(
                              radius: BorderRadius.circular(12),
                              onTap: () => setState(() {
                                _replyToCommentId = null;
                                _replyToLabel = null;
                              }),
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Icon(
                                  Icons.close_rounded,
                                  color: t.icon,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: t.inputBg,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: t.inputStroke),
                            ),
                            child: TextField(
                              controller: _ctrl,
                              enabled: !widget.isMuted && !_sending,
                              style: TextStyle(
                                color: t.text,
                                fontWeight: FontWeight.w800,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: widget.isMuted
                                    ? "Commentaires désactivés"
                                    : "Écrire un commentaire…",
                                hintStyle: TextStyle(
                                  color: t.textMuted,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        _Pressable(
                          radius: BorderRadius.circular(16),
                          onTap: (widget.isMuted || _sending) ? null : _send,
                          disabled: (widget.isMuted || _sending),
                          child: Container(
                            height: 48,
                            width: 48,
                            decoration: BoxDecoration(
                              color: (widget.isMuted || _sending)
                                  ? t.divider
                                  : t.primary,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              Icons.send_rounded,
                              color: t.textOnPrimary.withOpacity(
                                (widget.isMuted || _sending) ? 0.7 : 1,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MessagesInboxPage extends StatefulWidget {
  const _MessagesInboxPage();

  @override
  State<_MessagesInboxPage> createState() => _MessagesInboxPageState();
}

class _MessagesInboxPageState extends State<_MessagesInboxPage> {
  final _sb = Supabase.instance.client;

  bool _loading = true;
  String? _err;
  List<Map<String, dynamic>> _rooms = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _err = null;
    });

    try {
      final me = _sb.auth.currentUser!.id;

      final rows = await _sb
          .from('forum_room_members')
          .select('room_id, forum_rooms (id, title, is_group, created_at)')
          .eq('user_id', me)
          .order('joined_at', ascending: false);

      setState(() {
        _rooms = List<Map<String, dynamic>>.from(rows);
      });
    } catch (e) {
      setState(() => _err = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _ForumTheme.bgTop,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: _ForumTheme.text),
        title: const Text(
          "Messages",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: _ForumTheme.text,
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : (_err != null)
          ? Center(
              child: Text(
                _err!,
                style: const TextStyle(
                  color: _ForumTheme.danger,
                  fontWeight: FontWeight.w800,
                ),
              ),
            )
          : (_rooms.isEmpty)
          ? const Center(
              child: Text(
                "Aucun message pour le moment.\nCommence une discussion depuis le forum.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _ForumTheme.text2,
                  fontWeight: FontWeight.w900,
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _rooms.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final r =
                    _rooms[i]['forum_rooms'] as Map<String, dynamic>? ?? {};
                final title = (r['title'] as String?)?.trim();
                final isGroup = (r['is_group'] as bool?) ?? false;

                return _Card(
                  radius: 18,
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: _ForumTheme.accentSoft,
                        child: Icon(
                          isGroup ? Icons.groups_rounded : Icons.person_rounded,
                          color: _ForumTheme.accent,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          (title != null && title.isNotEmpty)
                              ? title
                              : (isGroup ? "Groupe" : "Discussion"),
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            color: _ForumTheme.text,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: _ForumTheme.text2,
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class _CreateGroupSheet extends StatefulWidget {
  final SupabaseClient supabase;
  final VoidCallback onCreated;

  const _CreateGroupSheet({
    required this.supabase,
    required this.onCreated,
    super.key,
  });

  @override
  State<_CreateGroupSheet> createState() => _CreateGroupSheetState();
}

class _CreateGroupSheetState extends State<_CreateGroupSheet> {
  final _titleCtrl = TextEditingController();

  bool _saving = false;
  String? _err;

  // TODO: à brancher avec un vrai picker
  final List<String> _selectedUserIds = [];

  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    final me = widget.supabase.auth.currentUser;
    if (me == null) return;

    final title = _titleCtrl.text.trim();
    if (title.isEmpty) {
      setState(() => _err = "Le nom du groupe est requis.");
      return;
    }
    if (_selectedUserIds.isEmpty) {
      setState(() => _err = "Ajoute au moins 1 membre.");
      return;
    }

    setState(() {
      _saving = true;
      _err = null;
    });

    try {
      final members = <String>{..._selectedUserIds, me.id}.toList();

      final room = await widget.supabase
          .from('forum_rooms')
          .insert({
            'created_by': me.id,
            'title': title,
            'is_group': true,
            'created_at': DateTime.now().toUtc().toIso8601String(),
          })
          .select()
          .single();

      final roomId = room['id'].toString();

      final rows = members
          .map(
            (uid) => {
              'room_id': roomId,
              'user_id': uid,
              'joined_at': DateTime.now().toUtc().toIso8601String(), // ✅
            },
          )
          .toList();

      await widget.supabase.from('forum_room_members').insert(rows);

      if (!mounted) return;
      widget.onCreated();
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() => _err = e.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = ForumTheme.of(context, skin: ForumSkin.examGPX);
    final inset = MediaQuery.of(context).viewInsets.bottom;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Container(
        color: Colors.transparent,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                padding: EdgeInsets.fromLTRB(16, 12, 16, 14 + inset),
                decoration: BoxDecoration(
                  color: t.sheetBg.withOpacity(t.isDark ? 0.92 : 0.98),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                  border: Border.all(color: t.stroke),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 4,
                      width: 44,
                      decoration: BoxDecoration(
                        color: t.divider,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Text(
                          "Nouveau groupe",
                          style: TextStyle(
                            color: t.text,
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        _Pressable(
                          onTap: _saving ? null : () => Navigator.pop(context),
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Icon(Icons.close_rounded, color: t.icon),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    _Card(
                      radius: 20,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.group_rounded, color: t.primary),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _titleCtrl,
                              enabled: !_saving,
                              style: TextStyle(
                                color: t.text,
                                fontWeight: FontWeight.w800,
                              ),
                              decoration: InputDecoration(
                                hintText: "Nom du groupe",
                                hintStyle: TextStyle(
                                  color: t.textMuted,
                                  fontWeight: FontWeight.w700,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    _Pressable(
                      disabled: _saving,
                      radius: BorderRadius.circular(20),
                      onTap: () {
                        // TODO: ouvre un picker
                        setState(() {
                          _err = "Sélection des membres à brancher.";
                        });
                      },
                      child: _Card(
                        radius: 20,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.group_add_rounded, color: t.primary),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "Sélection des membres (à brancher)",
                                style: TextStyle(
                                  color: t.text,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Container(
                              height: 26,
                              width: 26,
                              decoration: BoxDecoration(
                                color: t.primarySoft,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: t.primaryStroke),
                              ),
                              child: Icon(
                                Icons.add_rounded,
                                size: 18,
                                color: t.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    if (_err != null) ...[
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: t.danger.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: t.danger.withOpacity(0.22)),
                        ),
                        child: Text(
                          _err!,
                          style: TextStyle(
                            color: t.danger,
                            fontWeight: FontWeight.w800,
                            fontSize: 12.5,
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _saving ? null : _create,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: t.primary,
                          foregroundColor: t.textOnPrimary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: _saving
                            ? SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.4,
                                  color: t.textOnPrimary,
                                ),
                              )
                            : const Text(
                                "Créer le groupe",
                                style: TextStyle(fontWeight: FontWeight.w900),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PostDetailPage extends StatefulWidget {
  final _Post post;

  /// callbacks venant de ta page feed (_ForumEspaceExamGPXPageState)
  final VoidCallback onToggleLike;
  final VoidCallback onOpenComments;
  final VoidCallback onOpenPostMenu;

  /// si tu veux autoriser d’afficher le listing (true)
  final bool showInlineComments;

  const _PostDetailPage({
    required this.post,
    required this.onToggleLike,
    required this.onOpenComments,
    required this.onOpenPostMenu,
    this.showInlineComments = true,
  });

  @override
  State<_PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<_PostDetailPage> {
  final SupabaseClient _sb = Supabase.instance.client;

  bool _loading = true;
  String? _err;

  late _Post _post;

  List<Map<String, dynamic>> _comments = <Map<String, dynamic>>[];

  @override
  void initState() {
    super.initState();
    _post = widget.post;
    _loadAll();
  }

  Future<void> _loadAll() async {
    setState(() {
      _loading = true;
      _err = null;
    });

    try {
      // 1) Refresh du post (likes/comments)
      final myId = _sb.auth.currentUser?.id ?? '';

      final rows = await _sb
          .from('forum_posts_exam_gpx')
          .select('''
            id,
            author_id,
            username,
            title,
            content,
            image_url,
            created_at,
            is_deleted,
            user_profiles ( role, avatar_index ),
            forum_post_likes ( user_id ),
            forum_post_comments_exam_gpx ( id )
          ''')
          .eq('id', _post.id)
          .limit(1);

      if (rows.isNotEmpty) {
        final p = _Post.fromRow(rows.first, myUserId: myId);
        _post = p;
      }

      // 2) Load comments
      await _loadComments();
    } catch (e) {
      _err = e.toString();
    } finally {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  Future<void> _loadComments() async {
    final rows = await _sb
        .from('forum_post_comments_exam_gpx')
        .select('''
          id,
          post_id,
          author_id,
          content,
          parent_id,
          created_at,
          is_deleted,
          user_profiles ( username, role, avatar_index )
        ''')
        .eq('post_id', _post.id)
        .order('created_at', ascending: true);

    final list = List<Map<String, dynamic>>.from(rows);

    // ✅ on masque les soft-delete
    final visible = list
        .where((c) => (c['is_deleted'] as bool?) != true)
        .toList();

    if (!mounted) return;
    setState(() => _comments = visible);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _ForumTheme.bgTop,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          "Publication",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: _ForumTheme.text,
          ),
        ),
        iconTheme: const IconThemeData(color: _ForumTheme.text),
      ),
      body: RefreshIndicator(
        onRefresh: _loadAll,
        child: ListView(
          padding: const EdgeInsets.all(16),
          physics: const BouncingScrollPhysics(),
          children: [
            if (_loading)
              const Padding(
                padding: EdgeInsets.only(top: 40),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_err != null)
              _Card(
                radius: 22,
                padding: const EdgeInsets.all(14),
                child: Text(
                  _err!,
                  style: const TextStyle(
                    color: _ForumTheme.danger,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              )
            else ...[
              _Card(
                radius: 22,
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _PostHeader(
                      username: _post.username,
                      time: _prettyTime(_post.createdAt),
                      role: _post.authorRole,
                      avatarIndex: _post.avatarIndex,
                      onMore: widget.onOpenPostMenu,
                    ),
                    const SizedBox(height: 10),

                    // title
                    Text(
                      _post.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        height: 1.25,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // body
                    Text(
                      _post.content,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        height: 1.45,
                        fontSize: 15,
                      ),
                    ),

                    if (_post.imageUrl != null) ...[
                      const SizedBox(height: 12),
                      _PostImage(url: _post.imageUrl!),
                    ],

                    const SizedBox(height: 12),

                    // ✅ Facebook-like actions
                    PostActionsRow(
                      likeCount: _post.likeCount,
                      commentCount: _post.commentCount,
                      liked: _post.likedByMe,
                      onLike: () async {
                        widget.onToggleLike();
                        await _loadAll();
                      },
                      onComments: () async {
                        widget.onOpenComments();
                        await _loadAll();
                      },
                      showLabels: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              if (widget.showInlineComments) ...[
                _Card(
                  radius: 22,
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Commentaires",
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 14.5,
                            ),
                          ),
                          const Spacer(),
                          _Pressable(
                            onTap: () async {
                              widget.onOpenComments();
                              await _loadAll();
                            },
                            child: const Text(
                              "Ouvrir",
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                color: _ForumTheme.accent,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      if (_comments.isEmpty)
                        const Text(
                          "Aucun commentaire pour le moment.",
                          style: TextStyle(
                            color: _ForumTheme.text2,
                            fontWeight: FontWeight.w800,
                          ),
                        )
                      else
                        _buildInlineCommentTree(),
                    ],
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInlineCommentTree() {
    final top = _comments.where((c) => c['parent_id'] == null).toList();
    final repliesByParent = <String, List<Map<String, dynamic>>>{};

    for (final c in _comments.where((c) => c['parent_id'] != null)) {
      final pid = c['parent_id'].toString();
      (repliesByParent[pid] ??= []).add(c);
    }

    return Column(
      children: [
        for (final c in top) ...[
          _buildOneComment(c, repliesByParent),
          const SizedBox(height: 10),
        ],
      ],
    );
  }

  Widget _buildOneComment(
    Map<String, dynamic> c,
    Map<String, List<Map<String, dynamic>>> repliesByParent,
  ) {
    final id = c['id'].toString();
    final profile = (c['user_profiles'] as Map<String, dynamic>?) ?? {};
    final uname = (profile['username'] as String?) ?? "Utilisateur";
    final avatar = (profile['avatar_index'] as int?) ?? 1;

    final replies = repliesByParent[id] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CommentTile(
          username: uname,
          avatarIndex: avatar,
          content: (c['content'] as String?) ?? '',
          onReply: () {
            // ici tu peux ouvrir directement la sheet et pré-sélectionner le reply (si tu veux)
            widget.onOpenComments();
          },
          onMore: () {
            // pour le menu commentaire, ton _CommentsSheet gère déjà mieux le delete/report/message
            widget.onOpenComments();
          },
        ),
        if (replies.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 34, top: 8),
            child: Column(
              children: [
                for (final r in replies) ...[
                  _CommentTile(
                    username:
                        ((r['user_profiles']
                                as Map<String, dynamic>?)?['username']
                            as String?) ??
                        "Utilisateur",
                    avatarIndex:
                        ((r['user_profiles']
                                as Map<String, dynamic>?)?['avatar_index']
                            as int?) ??
                        1,
                    content: (r['content'] as String?) ?? '',
                    isReply: true,
                    onReply: () => widget.onOpenComments(),
                    onMore: () => widget.onOpenComments(),
                  ),
                  const SizedBox(height: 8),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

class _PostHeader extends StatelessWidget {
  final String username;
  final String time;
  final String role;
  final int avatarIndex;
  final VoidCallback onMore;

  const _PostHeader({
    required this.username,
    required this.time,
    required this.role,
    required this.avatarIndex,
    required this.onMore,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.forum;

    final Color badgeColor = switch (role.trim().toLowerCase()) {
      'admin' => t.danger,
      'moderator' => t.warning,
      _ => t.primary,
    };

    return Row(
      children: [
        ForumAvatar(index: avatarIndex),
        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      username,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.leagueSpartan(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.2,
                        // ✅ Fix pseudo illisible en dark
                        color: t.text,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(Icons.verified_rounded, size: 16, color: badgeColor),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                time,
                style: TextStyle(
                  fontSize: 11,
                  color: t.textSoft,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),

        // ✅ Fix "3 points" : en dark => icône flat, sans bulle
        // ✅ en light => on garde un petit bouton discret
        _Pressable(
          radius: BorderRadius.circular(14),
          onTap: onMore,
          child: t.isDark
              ? Padding(
                  padding: const EdgeInsets.all(6),
                  child: Icon(
                    Icons.more_horiz_rounded,
                    size: 20,
                    color: t.iconSoft,
                  ),
                )
              : Container(
                  height: 34,
                  width: 34,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F7FF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black.withOpacity(0.08)),
                  ),
                  child: const Icon(Icons.more_horiz_rounded, size: 20),
                ),
        ),
      ],
    );
  }
}

class PostActionsRow extends StatelessWidget {
  final int likeCount;
  final int commentCount;
  final bool liked;
  final VoidCallback onLike;
  final VoidCallback onComments;

  /// Si true : affiche “J’aime / Commenter” au lieu de juste les chiffres
  final bool showLabels;

  const PostActionsRow({
    required this.likeCount,
    required this.commentCount,
    required this.liked,
    required this.onLike,
    required this.onComments,
    this.showLabels = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.forum;

    final likeText = showLabels ? "J’aime ($likeCount)" : likeCount.toString();
    final commentText = showLabels
        ? "Commenter ($commentCount)"
        : commentCount.toString();

    Widget action({
      required IconData icon,
      required String text,
      required VoidCallback onTap,
      Color? iconColor,
    }) {
      return _Pressable(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, size: 18, color: iconColor ?? t.iconSoft),
            const SizedBox(width: 6),
            Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 12.5,
                color: t.textSoft,
              ),
            ),
          ],
        ),
      );
    }

    return Row(
      children: [
        action(
          icon: liked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          text: likeText,
          onTap: onLike,
          iconColor: liked ? t.danger : t.iconSoft,
        ),
        const SizedBox(width: 18),
        action(
          icon: Icons.mode_comment_outlined,
          text: commentText,
          onTap: onComments,
        ),
      ],
    );
  }
}

class _CommentTile extends StatelessWidget {
  final String username;
  final int avatarIndex;
  final String content;
  final bool isReply;

  final VoidCallback onReply;
  final VoidCallback onMore;

  const _CommentTile({
    required this.username,
    required this.avatarIndex,
    required this.content,
    required this.onReply,
    required this.onMore,
    this.isReply = false,
  });

  @override
  Widget build(BuildContext context) {
    final radius = isReply ? 14.0 : 16.0;
    final size = isReply ? 30.0 : 34.0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: radius,
          backgroundColor: const Color(0xFFEFF4FF),
          child: ClipOval(
            child: Image.asset(
              'assets/icon_profile/$avatarIndex.png',
              width: size,
              height: size,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 10),

        Expanded(
          child: Container(
            padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _ForumTheme.outline),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        username,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          color: _ForumTheme.text,
                          fontSize: 13.5,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _Pressable(
                      onTap: onMore,
                      child: const Padding(
                        padding: EdgeInsets.all(6.0),
                        child: Icon(
                          Icons.more_horiz_rounded,
                          size: 18,
                          color: _ForumTheme.text2,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                    color: Color(0xFF334155),
                    fontSize: 13.5,
                  ),
                ),
                const SizedBox(height: 10),

                Row(
                  children: [
                    _Pressable(
                      onTap: onReply,
                      child: const Text(
                        "Répondre",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: _ForumTheme.accent,
                          fontSize: 12.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CommentMenuSheet extends StatelessWidget {
  final bool canDelete;
  const _CommentMenuSheet({required this.canDelete});

  @override
  Widget build(BuildContext context) {
    return _SheetShell(
      title: "Options",
      children: [
        _SheetAction(
          icon: Icons.mail_outline_rounded,
          label: "Envoyer un message",
          color: _ForumTheme.text,
          onTap: () => Navigator.pop(context, _CommentMenuAction.message),
        ),
        _SheetAction(
          icon: Icons.flag_outlined,
          label: "Signaler",
          color: _ForumTheme.danger,
          onTap: () => Navigator.pop(context, _CommentMenuAction.report),
        ),
        if (canDelete)
          _SheetAction(
            icon: Icons.delete_outline,
            label: "Supprimer",
            color: _ForumTheme.danger,
            onTap: () => Navigator.pop(context, _CommentMenuAction.delete),
          ),
      ],
    );
  }
}

enum _CommentMenuAction { message, report, delete }

extension _FirstChar on Characters {
  String? get firstOrNull => isEmpty ? null : characterAt(0).toString();
}

ForumTheme forumT(BuildContext context) {
  final mode = AppSettingsController.I.themeMode.value;
  final isDark =
      (mode == ThemeMode.dark) ||
      (mode == ThemeMode.system &&
          MediaQuery.of(context).platformBrightness == Brightness.dark);

  return isDark
      ? ForumTheme.dark(ForumSkin.examGPX)
      : ForumTheme.light(ForumSkin.examGPX);
}
