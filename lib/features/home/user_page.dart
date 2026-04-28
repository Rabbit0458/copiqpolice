// lib/home/user_page.dart
// Page de gestion utilisateur modernisée
// Style cohérent avec mode_picker.dart & home_page.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:copiqpolice/core/widgets/app_notifier.dart';
import 'package:copiqpolice/features/onboarding/onboarding_screen.dart';
import 'package:copiqpolice/features/home/home_page.dart' show UserMode;

/// Mini style util partagé
class _T {
  static const ink = Color(0xFF212529);
  static BoxShadow get shadow => BoxShadow(
    color: Colors.black.withValues(alpha: .08),
    blurRadius: 20,
    offset: const Offset(0, 10),
  );
}

Color _muted(BuildContext context, [double a = .72]) {
  final base =
      Theme.of(context).textTheme.bodySmall?.color ??
      (Theme.of(context).brightness == Brightness.dark ? Colors.white : _T.ink);
  return base.withValues(alpha: a);
}

class UserPage extends StatefulWidget {
  const UserPage({super.key});
  static const routeName = '/user';

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> with WidgetsBindingObserver {
  final _sb = Supabase.instance.client;
  bool _loading = true;
  bool _deleting = false;
  Timer? _exclusiveTimer;

  static const _kLastExclusiveEnforce = 'last_exclusive_enforce_ms';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _sb.auth.onAuthStateChange.listen((e) {
      if (!mounted) return;
      if (e.event == AuthChangeEvent.signedOut) {
        AppNotifier.info(
          context,
          title: 'Déconnexion',
          message: 'Votre session a été fermée.',
        );
        _goOnboarding();
      }
    });

    _bootstrap();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _exclusiveTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _enforceSingleDeviceExclusive();
    }
  }

  Future<void> _bootstrap() async {
    try {
      final user = _sb.auth.currentUser;
      if (user == null) {
        _goOnboarding();
        return;
      }

      await _enforceSingleDeviceExclusive();

      _exclusiveTimer?.cancel();
      _exclusiveTimer = Timer.periodic(
        const Duration(minutes: 7),
        (_) => _enforceSingleDeviceExclusive(),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _enforceSingleDeviceExclusive() async {
    final user = _sb.auth.currentUser;
    if (user == null) return;

    try {
      final sp = await SharedPreferences.getInstance();
      final now = DateTime.now().millisecondsSinceEpoch;
      final last = sp.getInt(_kLastExclusiveEnforce) ?? 0;
      if (now - last < 60000) return;

      await _sb.auth.signOut(scope: SignOutScope.others);
      await sp.setInt(_kLastExclusiveEnforce, now);
    } catch (_) {}
  }

  // -------------------------------------------------------

  Future<void> _confirmDeleteAccount() async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer le compte ?'),
        content: const Text(
          'Cette action est définitive et supprimera vos données.\n'
          'Vous serez déconnecté et redirigé vers l’onboarding.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _deleteAccountCascade();
            },
            child: const Text(
              'Supprimer',
              style: TextStyle(color: Color(0xFFE53935)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAccountCascade() async {
    if (_deleting) return;
    _deleting = true;
    HapticFeedback.selectionClick();

    final user = _sb.auth.currentUser;
    if (user == null) {
      _deleting = false;
      _goOnboarding();
      return;
    }

    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );
    }

    String? errorMsg;

    try {
      final res = await _sb.functions.invoke(
        'delete-user-cascade',
        body: {'user_id': user.id},
      );

      final ok =
          res.status == 200 && (res.data is Map && res.data['ok'] == true);
      if (!ok) throw Exception('Edge Function error ${res.status}');
    } catch (e) {
      try {
        await _sb.from('user_profiles').delete().eq('user_id', user.id);
        try {
          await _sb.rpc('purge_user', params: {'uid': user.id});
        } catch (_) {}
        errorMsg = 'Suppression partielle côté client : $e';
      } catch (e2) {
        errorMsg = 'Suppression échouée : $e2';
      }
    } finally {
      if (mounted) Navigator.of(context).pop();
    }

    try {
      await _sb.auth.signOut();
    } catch (_) {}

    if (!mounted) {
      _deleting = false;
      return;
    }

    if (errorMsg == null) {
      AppNotifier.success(context, title: 'Compte supprimé');
    } else {
      AppNotifier.error(context, title: 'Avertissement', message: errorMsg);
    }

    _deleting = false;
    _goOnboarding();
  }

  void _goOnboarding() {
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      (_) => false,
    );
  }

  // -------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Mon compte'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          _InfoCard(
            icon: Icons.devices_other_outlined,
            title: 'Sessions actives',
            subtitle:
                'Un seul appareil par compte. Les autres appareils seront déconnectés.',
            buttonText: 'Forcer',
            buttonIcon: Icons.link_off_rounded,
            onTap: () async {
              await _enforceSingleDeviceExclusive();
              if (!mounted) return;
              AppNotifier.success(
                context,
                title: 'Exclusivité appliquée',
                message: 'Les autres appareils ont été déconnectés.',
              );
            },
          ),
          const SizedBox(height: 16),
          _InfoCard(
            icon: Icons.delete_forever_rounded,
            title: 'Supprimer mon compte',
            subtitle: 'Action irréversible. Vos données seront supprimées.',
            iconColor: const Color(0xFFE53935),
            textColor: const Color(0xFFE53935),
            onTap: _deleting ? null : _confirmDeleteAccount,
          ),
          const SizedBox(height: 28),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            onPressed: () async {
              await _sb.auth.signOut();
              if (!mounted) return;
              AppNotifier.success(
                context,
                title: 'Déconnexion réussie',
                message: 'Vous avez été redirigé(e).',
              );
              _goOnboarding();
            },
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Déconnexion'),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------
// UI Components
// -------------------------------------------------------

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? buttonText;
  final IconData? buttonIcon;
  final Color? iconColor;
  final Color? textColor;
  final VoidCallback? onTap;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.buttonText,
    this.buttonIcon,
    this.iconColor,
    this.textColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [_T.shadow],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color:
                  (isDark
                          ? Colors.white.withValues(alpha: .08)
                          : Colors.black.withValues(alpha: .06))
                      .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor ?? _T.ink, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: textColor ?? (isDark ? Colors.white : _T.ink),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: _muted(context, .75),
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          if (buttonText != null)
            FilledButton.tonalIcon(
              onPressed: onTap,
              icon: Icon(buttonIcon ?? Icons.settings),
              label: Text(buttonText!),
            )
          else if (onTap != null)
            IconButton(
              icon: const Icon(Icons.chevron_right_rounded),
              onPressed: onTap,
            ),
        ],
      ),
    );
  }
}
