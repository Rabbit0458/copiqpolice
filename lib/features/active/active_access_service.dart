import 'package:supabase_flutter/supabase_flutter.dart';

Set<String> activeFavoriteNodeIdsFromEvents(
  Iterable<Map<String, dynamic>> events,
) {
  final latest = <String, String>{};
  for (final event in events) {
    final nodeId = event['node_id']?.toString();
    final type = event['event_type']?.toString();
    if (nodeId != null &&
        !latest.containsKey(nodeId) &&
        (type == 'favorite_added' || type == 'favorite_removed')) {
      latest[nodeId] = type ?? '';
    }
  }
  return latest.entries
      .where((entry) => entry.value == 'favorite_added')
      .map((entry) => entry.key)
      .toSet();
}

class ActiveModeConfig {
  const ActiveModeConfig({
    required this.enabled,
    required this.available,
    required this.ownerPreviewActive,
    required this.revision,
    required this.disableMessage,
    required this.countdownSeconds,
  });

  final bool enabled;
  final bool available;
  final bool ownerPreviewActive;
  final int revision;
  final String disableMessage;
  final int countdownSeconds;

  factory ActiveModeConfig.fromJson(Map<String, dynamic> json) {
    final enabled = json['enabled'] == true;
    return ActiveModeConfig(
      enabled: enabled,
      available: json['available'] == true || enabled,
      ownerPreviewActive: json['owner_preview_active'] == true,
      revision: (json['revision'] as num?)?.toInt() ?? 1,
      disableMessage:
          json['disable_message']?.toString() ??
          'Une mise à jour doit être appliquée sur ce module.',
      countdownSeconds: (json['countdown_seconds'] as num?)?.toInt() ?? 30,
    );
  }
}

class ActiveContentNode {
  const ActiveContentNode({
    required this.id,
    required this.type,
    required this.title,
    required this.sortOrder,
    required this.content,
    this.parentId,
    this.subtitle,
    this.imageUrl,
    this.icon,
  });

  final String id;
  final String? parentId;
  final String type;
  final String title;
  final String? subtitle;
  final String? imageUrl;
  final String? icon;
  final int sortOrder;
  final List<Map<String, dynamic>> content;

  bool get isCourse => type == 'course';

  static String? _imageUrl(dynamic value) {
    final candidate = value?.toString().trim() ?? '';
    if (candidate.isEmpty) return null;
    final uri = Uri.tryParse(candidate);
    if (uri == null || !uri.hasAuthority) return null;
    if (uri.scheme != 'https' && uri.scheme != 'http') return null;
    return candidate;
  }

  factory ActiveContentNode.fromJson(Map<String, dynamic> json) {
    final raw = json['published_content'];
    return ActiveContentNode(
      id: json['id'].toString(),
      parentId: json['parent_id']?.toString(),
      type: json['node_type']?.toString() ?? 'category',
      title: json['title']?.toString() ?? '',
      subtitle: json['subtitle']?.toString(),
      imageUrl: _imageUrl(json['image_url']),
      icon: json['icon']?.toString(),
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      content: raw is List
          ? raw.map((e) => Map<String, dynamic>.from(e as Map)).toList()
          : const [],
    );
  }
}

class ActiveAccessStatus {
  const ActiveAccessStatus({
    required this.status,
    required this.granted,
    this.verificationVersion,
    this.grantedAt,
    this.revokedAt,
    this.cooldownUntil,
  });

  final String status;
  final bool granted;
  final int? verificationVersion;
  final DateTime? grantedAt;
  final DateTime? revokedAt;
  final DateTime? cooldownUntil;

  bool get coolingDown =>
      cooldownUntil != null && cooldownUntil!.isAfter(DateTime.now());

  factory ActiveAccessStatus.fromJson(Map<String, dynamic> json) {
    DateTime? date(dynamic value) =>
        value == null ? null : DateTime.tryParse(value.toString())?.toLocal();
    return ActiveAccessStatus(
      status: json['status']?.toString() ?? 'pending',
      granted: json['granted'] == true,
      verificationVersion:
          (json['verification_version'] as num?)?.toInt() ??
          (json['version'] as num?)?.toInt(),
      grantedAt: date(json['granted_at']),
      revokedAt: date(json['revoked_at']),
      cooldownUntil: date(json['cooldown_until']),
    );
  }
}

class ActiveVerificationQuestion {
  const ActiveVerificationQuestion({
    required this.id,
    required this.position,
    required this.prompt,
    required this.version,
  });

  final int id;
  final int position;
  final String prompt;
  final int version;

  factory ActiveVerificationQuestion.fromJson(Map<String, dynamic> json) =>
      ActiveVerificationQuestion(
        id: (json['id'] as num).toInt(),
        position: (json['position'] as num).toInt(),
        prompt: json['prompt'].toString(),
        version: (json['version'] as num).toInt(),
      );
}

class ActiveVerificationResult {
  const ActiveVerificationResult({
    required this.passed,
    required this.score,
    required this.status,
    this.cooldownUntil,
  });

  final bool passed;
  final int score;
  final String status;
  final DateTime? cooldownUntil;

  factory ActiveVerificationResult.fromJson(Map<String, dynamic> json) =>
      ActiveVerificationResult(
        passed: json['passed'] == true,
        score: (json['score'] as num?)?.toInt() ?? 0,
        status: json['status']?.toString() ?? 'pending',
        cooldownUntil: json['cooldown_until'] == null
            ? null
            : DateTime.tryParse(json['cooldown_until'].toString())?.toLocal(),
      );
}

class ActiveAccessService {
  ActiveAccessService({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  Future<ActiveModeConfig> config() async {
    final data = await _client.rpc('active_mode_public_config');
    return ActiveModeConfig.fromJson(Map<String, dynamic>.from(data as Map));
  }

  Future<List<ActiveContentNode>> contentTree() async {
    final data = await _client.rpc('active_content_tree');
    return (data as List)
        .map(
          (row) =>
              ActiveContentNode.fromJson(Map<String, dynamic>.from(row as Map)),
        )
        .toList()
      ..sort((a, b) {
        final order = a.sortOrder.compareTo(b.sortOrder);
        return order == 0 ? a.title.compareTo(b.title) : order;
      });
  }

  Future<void> record(String nodeId, String eventType) => _client.rpc(
    'active_learning_record',
    params: {'p_node_id': nodeId, 'p_event_type': eventType},
  );

  Future<List<Map<String, dynamic>>> learningEvents() async {
    final rows = await _client
        .from('active_learning_events')
        .select('node_id,event_type,created_at')
        .order('created_at', ascending: false)
        .limit(500);
    return (rows as List)
        .map((row) => Map<String, dynamic>.from(row as Map))
        .toList(growable: false);
  }

  Future<Set<String>> favoriteNodeIds() async {
    // Les événements d'ouverture peuvent être très nombreux. Lire la liste
    // générale limitée à 500 faisait disparaître un favori ancien alors que
    // son cœur restait correctement activé sur la carte.
    final rows = await _client
        .from('active_learning_events')
        .select('node_id,event_type,created_at')
        .inFilter('event_type', const ['favorite_added', 'favorite_removed'])
        .order('created_at', ascending: false)
        .limit(2000);
    final events = (rows as List)
        .map((row) => Map<String, dynamic>.from(row as Map))
        .toList(growable: false);
    return activeFavoriteNodeIdsFromEvents(events);
  }

  Future<ActiveAccessStatus> status() async {
    final data = await _client.rpc('active_access_status');
    return ActiveAccessStatus.fromJson(Map<String, dynamic>.from(data as Map));
  }

  Future<List<ActiveVerificationQuestion>> questions() async {
    final data = await _client.rpc('active_verification_get_questions');
    return (data as List)
        .map(
          (row) => ActiveVerificationQuestion.fromJson(
            Map<String, dynamic>.from(row as Map),
          ),
        )
        .toList()
      ..sort((a, b) => a.position.compareTo(b.position));
  }

  Future<ActiveVerificationResult> submit(
    List<ActiveVerificationQuestion> questions,
    Map<int, String> answers,
  ) async {
    final payload = questions
        .map(
          (question) => {
            'question_id': question.id,
            'answer': answers[question.id]?.trim() ?? '',
          },
        )
        .toList();
    final data = await _client.rpc(
      'active_verification_submit',
      params: {'p_answers': payload},
    );
    return ActiveVerificationResult.fromJson(
      Map<String, dynamic>.from(data as Map),
    );
  }
}
