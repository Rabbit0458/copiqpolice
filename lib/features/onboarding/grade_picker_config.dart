import 'package:supabase_flutter/supabase_flutter.dart';

class GradePickerConfig {
  const GradePickerConfig({
    required this.reserveEnabled,
    required this.revision,
  });

  final bool reserveEnabled;
  final int revision;

  factory GradePickerConfig.fromJson(Map<String, dynamic> json) {
    return GradePickerConfig(
      reserveEnabled: json['reserve_enabled'] == true,
      revision: (json['revision'] as num?)?.toInt() ?? 1,
    );
  }
}

class GradePickerConfigService {
  GradePickerConfigService({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  Future<GradePickerConfig> load() async {
    final data = await _client.rpc('grade_picker_public_config');
    return GradePickerConfig.fromJson(Map<String, dynamic>.from(data as Map));
  }
}
