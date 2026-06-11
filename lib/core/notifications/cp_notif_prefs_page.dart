// lib/core/notifications/cp_notif_prefs_page.dart
//
// Page de préférences notifications push — Cas Pratique COP'IQ.
//
// ─ Toggle par topic (NewCase / StreakRisk / AppealResult / Leaderboard)
// ─ Sélecteur de plage silencieuse (quiet hours)
// ─ Design dark/light : palette #1147D9 / #000B36, Montserrat
// ─ Accessible : Semantics sur chaque Toggle, contraste AA

import 'package:flutter/material.dart';
import 'cp_push_service.dart';

class CpNotifPrefsPage extends StatefulWidget {
  static const routeName = '/cp/notifications/prefs';

  const CpNotifPrefsPage({super.key});

  @override
  State<CpNotifPrefsPage> createState() => _CpNotifPrefsPageState();
}

class _CpNotifPrefsPageState extends State<CpNotifPrefsPage> {
  CpNotifPrefs get _prefs => CpPushService.I.prefs;

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final brand = isDark ? const Color(0xFF000B36) : const Color(0xFF1147D9);
    final surface = isDark ? const Color(0xFF0D1B4B) : Colors.white;
    final bg = isDark ? const Color(0xFF06102A) : const Color(0xFFF4F6FF);
    final onSurface =
        isDark ? Colors.white : const Color(0xFF1A2340);

    return StreamBuilder<CpNotifPrefs>(
      stream: CpPushService.I.prefsStream,
      initialData: _prefs,
      builder: (context, snap) {
        final p = snap.data ?? _prefs;
        return Scaffold(
          backgroundColor: bg,
          appBar: AppBar(
            backgroundColor: brand,
            foregroundColor: Colors.white,
            elevation: 0,
            title: const Text(
              'Notifications',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            children: [
              // ── Section Topics ──────────────────────────────────────────
              _SectionHeader(
                label: 'Types de notifications',
                isDark: isDark,
              ),
              const SizedBox(height: 8),
              _card(
                surface: surface,
                child: Column(
                  children: CpNotifTopic.values
                      .map((t) => _TopicTile(
                            topic: t,
                            enabled: p.isEnabled(t),
                            brand: brand,
                            onSurface: onSurface,
                            onToggle: (v) => CpPushService.I
                                .setTopicEnabled(t, v),
                          ))
                      .toList(),
                ),
              ),

              const SizedBox(height: 24),

              // ── Section Quiet Hours ──────────────────────────────────────
              _SectionHeader(
                label: 'Plage silencieuse',
                isDark: isDark,
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  'Les notifications reçues pendant cette période ne s\'affichent pas.',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                    color: onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ),
              _card(
                surface: surface,
                child: Column(
                  children: [
                    _QuietHourTile(
                      label: 'Début',
                      hour: p.quietStartHour,
                      brand: brand,
                      onSurface: onSurface,
                      onChanged: (h) => CpPushService.I.setQuietHours(
                        startHour: h,
                        endHour: p.quietEndHour,
                      ),
                    ),
                    Divider(height: 1, color: onSurface.withValues(alpha: 0.08)),
                    _QuietHourTile(
                      label: 'Fin',
                      hour: p.quietEndHour,
                      brand: brand,
                      onSurface: onSurface,
                      onChanged: (h) => CpPushService.I.setQuietHours(
                        startHour: p.quietStartHour,
                        endHour: h,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // ── Note légale ─────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  'Tes préférences sont synchronisées sur tous tes appareils. '
                  'Tu peux aussi désactiver toutes les notifications depuis les '
                  'réglages de ton téléphone.',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 11,
                    color: onSurface.withValues(alpha: 0.45),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _card({required Color surface, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

// ---------------------------------------------------------------------------
// Widgets internes
// ---------------------------------------------------------------------------

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label, required this.isDark});
  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 2),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w700,
          fontSize: 11,
          letterSpacing: 1.2,
          color: isDark
              ? Colors.white.withValues(alpha: 0.55)
              : const Color(0xFF1147D9).withValues(alpha: 0.7),
        ),
      ),
    );
  }
}

class _TopicTile extends StatelessWidget {
  const _TopicTile({
    required this.topic,
    required this.enabled,
    required this.brand,
    required this.onSurface,
    required this.onToggle,
  });

  final CpNotifTopic topic;
  final bool enabled;
  final Color brand;
  final Color onSurface;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${topic.label} : ${enabled ? "activé" : "désactivé"}',
      toggled: enabled,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            _topicIcon(),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    topic.label,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    topic.description,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      color: onSurface.withValues(alpha: 0.55),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Switch.adaptive(
              value: enabled,
              onChanged: onToggle,
              activeColor: brand,
            ),
          ],
        ),
      ),
    );
  }

  Widget _topicIcon() {
    final iconData = switch (topic) {
      CpNotifTopic.newCase => Icons.library_add_outlined,
      CpNotifTopic.streakRisk => Icons.local_fire_department_outlined,
      CpNotifTopic.appealResult => Icons.gavel_outlined,
      CpNotifTopic.leaderboard => Icons.emoji_events_outlined,
    };
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: brand.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(iconData, size: 20, color: brand),
    );
  }
}

class _QuietHourTile extends StatelessWidget {
  const _QuietHourTile({
    required this.label,
    required this.hour,
    required this.brand,
    required this.onSurface,
    required this.onChanged,
  });

  final String label;
  final int hour;
  final Color brand;
  final Color onSurface;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: onSurface,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => _pickHour(context),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: brand.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _formatHour(hour),
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: brand,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatHour(int h) =>
      '${h.toString().padLeft(2, '0')}h00';

  Future<void> _pickHour(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: hour, minute: 0),
      helpText: 'Heure $label',
      builder: (ctx, child) => MediaQuery(
        data: MediaQuery.of(ctx).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
    if (picked != null) {
      onChanged(picked.hour);
    }
  }
}
