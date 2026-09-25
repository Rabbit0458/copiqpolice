// lib/home/user_page.dart
// Page de gestion utilisateur modernisée
// Style cohérent avec mode_picker.dart & home_page.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:copiqpolice/core/widgets/app_notifier.dart';
import 'package:copiqpolice/core/services/user_context_service.dart';
import 'package:copiqpolice/features/onboarding/onboarding_screen.dart';

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
    HapticFeedback.mediumImpact();
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: .68),
      barrierLabel: 'Fermer la confirmation de suppression',
      constraints: const BoxConstraints(maxWidth: 620),
      builder: (sheetContext) => _DeleteAccountConfirmationSheet(
        isFinalStep: false,
        onCancel: () => Navigator.pop(sheetContext, false),
        onConfirm: () => Navigator.pop(sheetContext, true),
      ),
    );
    if (confirmed == true && mounted) await _confirmDeleteAccountFinal();
  }

  Future<void> _confirmDeleteAccountFinal() async {
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: .72),
      barrierLabel: 'Fermer la dernière confirmation de suppression',
      constraints: const BoxConstraints(maxWidth: 620),
      builder: (sheetContext) => _DeleteAccountConfirmationSheet(
        isFinalStep: true,
        onCancel: () => Navigator.pop(sheetContext, false),
        onConfirm: () => Navigator.pop(sheetContext, true),
      ),
    );
    if (confirmed == true && mounted) await _deleteAccountCascade();
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
      // La session peut avoir expiré (app restée ouverte longtemps) : on force
      // un rafraîchissement AVANT d'appeler l'edge function. On passe le
      // token retourné directement dans le header — sans ça, on a vu en prod
      // un 401 pile au moment du refresh (rotation du refresh token) car
      // functions.invoke() peut lire une session pas encore synchronisée.
      String accessToken;
      try {
        final authResponse = await _sb.auth.refreshSession();
        final token = authResponse.session?.accessToken;
        if (token == null) {
          throw Exception('Session absente après rafraîchissement.');
        }
        accessToken = token;
      } on AuthException catch (e) {
        throw Exception(
          'Session expirée — reconnecte-toi puis réessaie. (${e.message})',
        );
      }

      final res = await _sb.functions.invoke(
        'delete-user-cascade',
        body: {'user_id': user.id},
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      final ok =
          res.status == 200 && (res.data is Map && res.data['ok'] == true);
      if (!ok) {
        final serverError = (res.data is Map) ? res.data['error'] : null;
        throw Exception(
          serverError?.toString() ?? 'Edge Function error ${res.status}',
        );
      }
    } catch (e, st) {
      errorMsg = e.toString();
      // ignore: avoid_print
      debugPrint('[DELETE-ACCOUNT] échec : $e\n$st');
    } finally {
      if (mounted) Navigator.of(context).pop();
    }

    if (!mounted) {
      _deleting = false;
      return;
    }

    if (errorMsg != null) {
      // La suppression a échoué : on NE déconnecte PAS l'utilisateur — son
      // compte et ses données sont toujours intacts (la RPC purge_user est
      // transactionnelle et n'efface auth.users qu'après son succès complet).
      AppNotifier.error(
        context,
        title: 'Suppression impossible',
        message:
            'Une erreur est survenue, ton compte n’a pas été supprimé. '
            'Réessaie plus tard ou contacte le support.\n\n$errorMsg',
      );
      _deleting = false;
      return;
    }

    // Succès : nettoyage complet de l'état local avant de rediriger.
    try {
      final sp = await SharedPreferences.getInstance();
      await sp.clear();
    } catch (_) {}
    try {
      await UserContextService.I.clear();
    } catch (_) {}
    try {
      await _sb.auth.signOut();
    } catch (_) {}

    AppNotifier.success(context, title: 'Compte supprimé');

    _deleting = false;
    _goSignUp();
  }

  void _goOnboarding() {
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      (_) => false,
    );
  }

  /// Après une suppression de compte réussie, direct vers la création de
  /// compte (pas l'onboarding marketing) : c'est ce que l'utilisateur veut
  /// faire ensuite.
  void _goSignUp() {
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/signup', (_) => false);
  }

  String _currentJourneyLabel() {
    final contextService = UserContextService.I;
    final mode = contextService.mode;
    final track = contextService.track;
    if (mode == UserModes.active) {
      return 'Espace actif · Gardien de la paix';
    }
    final modeLabel = switch (mode) {
      UserModes.school => 'Scolarité',
      UserModes.exam => 'Concours',
      _ => 'Parcours à personnaliser',
    };
    if (mode == null) return modeLabel;
    final trackLabel = switch (track) {
      UserTracks.pa => 'Policier adjoint',
      UserTracks.gpx => 'Gardien de la paix',
      _ => null,
    };
    return trackLabel == null ? modeLabel : '$modeLabel · $trackLabel';
  }

  Future<void> _confirmChangeJourney() async {
    HapticFeedback.selectionClick();
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: .62),
      barrierLabel: 'Fermer la confirmation de changement de parcours',
      constraints: const BoxConstraints(maxWidth: 620),
      builder: (sheetContext) => _JourneyConfirmationSheet(
        currentJourney: _currentJourneyLabel(),
        onCancel: () => Navigator.pop(sheetContext, false),
        onConfirm: () => Navigator.pop(sheetContext, true),
      ),
    );
    if (confirmed != true || !mounted) return;
    Navigator.of(context).pushNamed('/mode_picker');
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
          _JourneyCard(
            currentJourney: _currentJourneyLabel(),
            onTap: _confirmChangeJourney,
          ),
          const SizedBox(height: 16),
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

class _JourneyCard extends StatelessWidget {
  const _JourneyCard({required this.currentJourney, required this.onTap});

  final String currentJourney;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final foreground = isDark ? Colors.white : const Color(0xFF101828);
    final border = isDark
        ? Colors.white.withValues(alpha: .1)
        : const Color(0xFFD8E4FF);

    return Semantics(
      button: true,
      label: 'Changer de parcours. Parcours actuel : $currentJourney',
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? const [Color(0xFF17213A), Color(0xFF101727)]
                  : const [Color(0xFFF7F9FF), Color(0xFFEAF1FF)],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: border),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2563EB).withValues(alpha: .09),
                blurRadius: 28,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF111D3D), Color(0xFF2563EB)],
                      ),
                      borderRadius: BorderRadius.circular(17),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2563EB).withValues(alpha: .24),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.route_rounded,
                      color: Colors.white,
                      size: 27,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF2563EB,
                            ).withValues(alpha: isDark ? .2 : .1),
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: const Text(
                            'MON PARCOURS',
                            style: TextStyle(
                              color: Color(0xFF2563EB),
                              fontSize: 10,
                              letterSpacing: .9,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          currentJourney,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: foreground,
                            fontSize: 16,
                            height: 1.15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Appuie pour modifier ton espace',
                          style: TextStyle(
                            color: isDark
                                ? Colors.white.withValues(alpha: .65)
                                : const Color(0xFF526077),
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: .08)
                          : Colors.white.withValues(alpha: .88),
                      shape: BoxShape.circle,
                      border: Border.all(color: border),
                    ),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      color: foreground,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _JourneyConfirmationSheet extends StatelessWidget {
  const _JourneyConfirmationSheet({
    required this.currentJourney,
    required this.onCancel,
    required this.onConfirm,
  });

  final String currentJourney;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surface = isDark ? const Color(0xFF111827) : Colors.white;
    final foreground = isDark ? Colors.white : const Color(0xFF101828);
    final muted = isDark
        ? Colors.white.withValues(alpha: .68)
        : const Color(0xFF526077);
    final softSurface = isDark
        ? Colors.white.withValues(alpha: .055)
        : const Color(0xFFF5F7FB);
    final border = isDark
        ? Colors.white.withValues(alpha: .09)
        : const Color(0xFFE5EAF2);

    return Material(
      color: surface,
      clipBehavior: Clip.antiAlias,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          24,
          12,
          24,
          20 + MediaQuery.paddingOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 42,
                height: 5,
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: .2)
                      : const Color(0xFFD4DAE4),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF111D3D), Color(0xFF2563EB)],
                    ),
                    borderRadius: BorderRadius.circular(19),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2563EB).withValues(alpha: .28),
                        blurRadius: 22,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.route_rounded,
                    color: Colors.white,
                    size: 29,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'PERSONNALISER MON ESPACE',
                        style: TextStyle(
                          color: Color(0xFF2563EB),
                          fontSize: 10.5,
                          letterSpacing: 1.05,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        'Changer de parcours',
                        style: TextStyle(
                          color: foreground,
                          fontSize: 25,
                          height: 1.05,
                          letterSpacing: -.4,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Text(
              'Tu vas choisir un nouvel espace puis ton grade. Ton parcours actuel reste actif tant que tu n’as pas terminé.',
              style: TextStyle(
                color: muted,
                fontSize: 16,
                height: 1.45,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: softSurface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(
                        0xFF2563EB,
                      ).withValues(alpha: isDark ? .2 : .1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.near_me_rounded,
                      color: Color(0xFF2563EB),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Parcours actuel',
                          style: TextStyle(
                            color: muted,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          currentJourney,
                          style: TextStyle(
                            color: foreground,
                            fontSize: 14,
                            height: 1.2,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Tout reste sauvegardé',
              style: TextStyle(
                color: foreground,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: const [
                Expanded(
                  child: _PreservedItem(
                    icon: Icons.trending_up_rounded,
                    label: 'Progression',
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _PreservedItem(
                    icon: Icons.favorite_rounded,
                    label: 'Favoris',
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _PreservedItem(
                    icon: Icons.history_rounded,
                    label: 'Historique',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Semantics(
              button: true,
              label: 'Choisir un nouveau parcours',
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton.icon(
                  onPressed: onConfirm,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF14213D),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 0,
                    textStyle: const TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  iconAlignment: IconAlignment.end,
                  icon: const Icon(Icons.arrow_forward_rounded, size: 21),
                  label: const Text('Choisir mon parcours'),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Semantics(
              button: true,
              label: 'Annuler le changement de parcours',
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: TextButton(
                  onPressed: onCancel,
                  style: TextButton.styleFrom(
                    foregroundColor: muted,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Garder mon parcours actuel',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PreservedItem extends StatelessWidget {
  const _PreservedItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      constraints: const BoxConstraints(minHeight: 70),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF16A36A).withValues(alpha: isDark ? .12 : .07),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFF16A36A).withValues(alpha: isDark ? .24 : .15),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFF16845B), size: 21),
          const SizedBox(height: 6),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isDark ? const Color(0xFF7DDEB6) : const Color(0xFF11684A),
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _DeleteAccountConfirmationSheet extends StatelessWidget {
  const _DeleteAccountConfirmationSheet({
    required this.isFinalStep,
    required this.onCancel,
    required this.onConfirm,
  });

  final bool isFinalStep;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surface = isDark ? const Color(0xFF151719) : Colors.white;
    final foreground = isDark ? Colors.white : const Color(0xFF21181A);
    final muted = isDark
        ? Colors.white.withValues(alpha: .68)
        : const Color(0xFF66585B);
    final danger = isFinalStep
        ? const Color(0xFFC62828)
        : const Color(0xFFE13D48);
    final softDanger = danger.withValues(alpha: isDark ? .13 : .07);
    final borderDanger = danger.withValues(alpha: isDark ? .28 : .16);

    return Material(
      color: surface,
      clipBehavior: Clip.antiAlias,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          24,
          12,
          24,
          20 + MediaQuery.paddingOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 42,
                height: 5,
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: .2)
                      : const Color(0xFFD9D2D4),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [const Color(0xFF7F1D1D), danger],
                    ),
                    borderRadius: BorderRadius.circular(19),
                    boxShadow: [
                      BoxShadow(
                        color: danger.withValues(alpha: .25),
                        blurRadius: 22,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(
                    isFinalStep
                        ? Icons.gpp_bad_rounded
                        : Icons.delete_outline_rounded,
                    color: Colors.white,
                    size: 29,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isFinalStep ? 'DERNIÈRE ÉTAPE' : 'ZONE SENSIBLE',
                        style: TextStyle(
                          color: danger,
                          fontSize: 10.5,
                          letterSpacing: 1.05,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        isFinalStep
                            ? 'Confirmer la suppression'
                            : 'Supprimer le compte ?',
                        style: TextStyle(
                          color: foreground,
                          fontSize: 25,
                          height: 1.05,
                          letterSpacing: -.4,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Text(
              isFinalStep
                  ? 'Après cette confirmation, ton compte et tes données ne pourront plus être récupérés.'
                  : 'La suppression efface définitivement ton profil et toutes les données associées à COP’IQ.',
              style: TextStyle(
                color: muted,
                fontSize: 16,
                height: 1.45,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: softDanger,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: borderDanger),
              ),
              child: isFinalStep
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: danger,
                          size: 23,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Cette action est immédiate, définitive et irréversible.',
                            style: TextStyle(
                              color: foreground,
                              fontSize: 14,
                              height: 1.35,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _DeletedDataRow(
                          icon: Icons.trending_up_rounded,
                          label: 'Progression et historique',
                          color: danger,
                        ),
                        const SizedBox(height: 11),
                        _DeletedDataRow(
                          icon: Icons.forum_outlined,
                          label: 'Messages et activité',
                          color: danger,
                        ),
                        const SizedBox(height: 11),
                        _DeletedDataRow(
                          icon: Icons.person_outline_rounded,
                          label: 'Profil et préférences',
                          color: danger,
                        ),
                      ],
                    ),
            ),
            if (!isFinalStep) ...[
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: .05)
                      : const Color(0xFFF6F7F9),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.credit_card_off_outlined,
                      color: muted,
                      size: 21,
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      child: Text(
                        'Un abonnement en cours doit être résilié séparément depuis « Abonnement ».',
                        style: TextStyle(
                          color: muted,
                          fontSize: 13,
                          height: 1.35,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            Semantics(
              button: true,
              label: isFinalStep
                  ? 'Supprimer définitivement mon compte'
                  : 'Continuer vers la dernière confirmation',
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton.icon(
                  onPressed: onConfirm,
                  style: FilledButton.styleFrom(
                    backgroundColor: danger,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 0,
                    textStyle: const TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  icon: Icon(
                    isFinalStep
                        ? Icons.delete_forever_rounded
                        : Icons.arrow_forward_rounded,
                    size: 21,
                  ),
                  label: Text(
                    isFinalStep ? 'Supprimer définitivement' : 'Continuer',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Semantics(
              button: true,
              label: 'Annuler la suppression du compte',
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: TextButton(
                  onPressed: onCancel,
                  style: TextButton.styleFrom(
                    foregroundColor: muted,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Conserver mon compte',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeletedDataRow extends StatelessWidget {
  const _DeletedDataRow({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: color.withValues(alpha: isDark ? .18 : .1),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF3A2E31),
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

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
