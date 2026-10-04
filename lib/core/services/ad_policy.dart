/// Public display policy. A missing/invalid configuration disables ads.
class AdPolicy {
  final bool enabled;
  final int intervalMinutes;
  final DateTime? startsAt;
  final DateTime? endsAt;
  const AdPolicy({
    this.enabled = false,
    this.intervalMinutes = 20,
    this.startsAt,
    this.endsAt,
  });

  factory AdPolicy.fromJson(Map<String, dynamic> data) {
    final minutes = data['ads_interval_minutes'];
    DateTime? parse(dynamic value) =>
        value == null ? null : DateTime.parse(value as String).toUtc();
    if (minutes is! int || minutes < 5 || minutes > 1440) {
      throw const FormatException('Invalid ad interval');
    }
    final start = parse(data['ads_starts_at']);
    final end = parse(data['ads_ends_at']);
    if (start != null && end != null && !end.isAfter(start)) {
      throw const FormatException('Invalid ad dates');
    }
    return AdPolicy(
      enabled: data['ads_enabled'] == true,
      intervalMinutes: minutes,
      startsAt: start,
      endsAt: end,
    );
  }

  bool activeAt(DateTime now) =>
      enabled &&
      (startsAt == null || !now.isBefore(startsAt!)) &&
      (endsAt == null || now.isBefore(endsAt!));

  bool canShowInterstitial(DateTime now, DateTime? lastShown) =>
      activeAt(now) &&
      (lastShown == null ||
          now.difference(lastShown) >= Duration(minutes: intervalMinutes));
}
