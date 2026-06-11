// lib/features/home/widgets/daily_reminder_tile.dart
//
// Tile à insérer dans `parametre_home.dart` pour activer/désactiver
// le rappel quotidien et choisir l'heure.
//
// Usage :
//   const DailyReminderTile()

import 'package:flutter/material.dart';

import 'package:copiqpolice/core/services/notifications_service.dart';

class DailyReminderTile extends StatefulWidget {
  const DailyReminderTile({super.key});

  @override
  State<DailyReminderTile> createState() => _DailyReminderTileState();
}

class _DailyReminderTileState extends State<DailyReminderTile> {
  bool _enabled = false;
  int _hour = 19;
  int _minute = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final cfg = await NotificationsService.I.getDailyReminderConfig();
    if (!mounted) return;
    setState(() {
      _enabled = cfg.enabled;
      _hour = cfg.hour;
      _minute = cfg.minute;
      _loading = false;
    });
  }

  Future<void> _toggle(bool v) async {
    if (v) {
      final ok = await NotificationsService.I.requestPermissions();
      if (!ok) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Permission notifications refusée. Active-la dans les réglages système.',
            ),
          ),
        );
        return;
      }
      await NotificationsService.I.scheduleDailyReminder(
        hour: _hour,
        minute: _minute,
      );
    } else {
      await NotificationsService.I.cancelDailyReminder();
    }
    if (!mounted) return;
    setState(() => _enabled = v);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _hour, minute: _minute),
    );
    if (picked == null) return;
    setState(() {
      _hour = picked.hour;
      _minute = picked.minute;
    });
    if (_enabled) {
      await NotificationsService.I.scheduleDailyReminder(
        hour: picked.hour,
        minute: picked.minute,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (_loading) {
      return const SizedBox(
        height: 56,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    String pad(int v) => v.toString().padLeft(2, '0');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: (isDark ? Colors.white : Colors.black).withValues(alpha: .08),
        ),
      ),
      child: Column(
        children: [
          SwitchListTile.adaptive(
            value: _enabled,
            onChanged: _toggle,
            title: const Text('Rappel quotidien'),
            subtitle: Text(
              _enabled
                  ? 'Activé à ${pad(_hour)}:${pad(_minute)}'
                  : 'Désactivé',
            ),
            secondary: const Icon(Icons.notifications_active_outlined),
          ),
          if (_enabled)
            ListTile(
              leading: const Icon(Icons.schedule_rounded),
              title: const Text('Heure du rappel'),
              trailing: Text(
                '${pad(_hour)}:${pad(_minute)}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              onTap: _pickTime,
            ),
        ],
      ),
    );
  }
}
