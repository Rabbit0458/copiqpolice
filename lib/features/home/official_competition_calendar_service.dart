import 'package:supabase_flutter/supabase_flutter.dart';

class OfficialCompetitionEvent {
  const OfficialCompetitionEvent({
    required this.id,
    required this.track,
    required this.session,
    required this.type,
    required this.dateText,
    required this.sourceUrl,
    this.region,
    this.startsOn,
    this.endsOn,
  });

  final String id;
  final String track;
  final String session;
  final String type;
  final String dateText;
  final String sourceUrl;
  final String? region;
  final DateTime? startsOn;
  final DateTime? endsOn;

  factory OfficialCompetitionEvent.fromJson(Map<String, dynamic> json) {
    return OfficialCompetitionEvent(
      id: json['id'].toString(),
      track: json['track'].toString(),
      session: json['session_label'].toString(),
      type: json['event_type'].toString(),
      dateText: json['date_text'].toString(),
      sourceUrl: json['source_url'].toString(),
      region: json['region_label']?.toString(),
      startsOn: DateTime.tryParse(json['starts_on']?.toString() ?? ''),
      endsOn: DateTime.tryParse(json['ends_on']?.toString() ?? ''),
    );
  }

  String get typeLabel => switch (type) {
    'registration' => 'Inscriptions',
    'written' => 'Épreuves écrites',
    'sport' => 'Épreuves sportives',
    'oral' => 'Épreuves orales',
    'result' => 'Résultats',
    _ => 'Échéance',
  };
}

class OfficialCompetitionCalendarService {
  OfficialCompetitionCalendarService({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  Future<List<OfficialCompetitionEvent>> load(String track) async {
    final rows = await _client
        .from('official_competition_events')
        .select()
        .eq('track', track)
        .eq('is_active', true)
        .order('starts_on', ascending: true, nullsFirst: false)
        .order('session_label');
    return (rows as List)
        .cast<Map<String, dynamic>>()
        .map(OfficialCompetitionEvent.fromJson)
        .toList(growable: false);
  }
}
