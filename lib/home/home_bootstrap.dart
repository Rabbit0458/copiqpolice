// lib/home/home_bootstrap.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Types publics
import 'package:copiqpolice/home/home_page.dart'
    show UserMode, UserModeController, UserTrack, UserTrackController;

// Homes
import 'package:copiqpolice/home/home_page_gpx_school.dart'
    show HomePageGpxSchool;
import 'package:copiqpolice/home/home_page_gpx_exam.dart' show HomePageGpxExam;
import 'package:copiqpolice/home/home_page_pa_exam.dart' show HomePagePaExam;
import 'package:copiqpolice/home/home_page_pa_school.dart'
    show HomePagePaSchool;

// ✅ Programme PA du jour (NON sauvegardé)
import 'package:copiqpolice/onboarding/pa_school.dart'
    show PaSchoolArt, PaSchoolProgram;
import 'package:copiqpolice/onboarding/gpx_school.dart'
    show GpxSchoolArt, GpxSchoolProgram;

class HomeBootstrap extends StatefulWidget {
  static const routeName = '/home-bootstrap';
  const HomeBootstrap({super.key});

  @override
  State<HomeBootstrap> createState() => _HomeBootstrapState();
}

class _HomeBootstrapState extends State<HomeBootstrap> {
  bool _didRoute = false;

  // Local keys (uniquement mode + track)
  static const _kUserMode = 'user_mode'; // school | exam
  static const _kSelectedTrack = 'selected_track'; // gpx | pa | reserve

  @override
  void initState() {
    super.initState();
    Future.microtask(_decideAndRoute);
  }

  // ----------------- Helpers -----------------

  String _norm(String? s) => (s ?? '').trim().toLowerCase();
  bool _isValidMode(String? m) => m == 'school' || m == 'exam';
  bool _isValidTrack(String? t) => t == 'gpx' || t == 'pa' || t == 'reserve';

  Future<SharedPreferences> get _sp async => SharedPreferences.getInstance();

  // ----------------- Main decision -----------------

  Future<void> _decideAndRoute() async {
    if (_didRoute) return;
    _didRoute = true;

    // 1) Local first
    String? modeLocal;
    String? trackLocal;

    try {
      final sp = await _sp;
      final m = _norm(sp.getString(_kUserMode));
      final t = _norm(sp.getString(_kSelectedTrack));

      if (_isValidMode(m)) modeLocal = m;
      if (_isValidTrack(t)) trackLocal = t;

      debugPrint('[Bootstrap] Local → mode=$modeLocal, track=$trackLocal');
    } catch (e) {
      debugPrint('[Bootstrap] SharedPreferences read failed: $e');
    }

    // 2) DB (source de vérité)
    String? modeDb;
    String? trackDb;

    try {
      final sb = Supabase.instance.client;
      final user = sb.auth.currentUser;

      if (user != null) {
        final row = await sb
            .from('user_profiles')
            .select('user_mode, user_track')
            .eq('user_id', user.id)
            .maybeSingle();

        if (row != null) {
          final m = _norm(row['user_mode'] as String?);
          final t = _norm(row['user_track'] as String?);

          if (_isValidMode(m)) modeDb = m;
          if (_isValidTrack(t)) trackDb = t;
        }
      }
    } catch (e) {
      debugPrint('[Bootstrap] Supabase read failed: $e');
    }

    final mode = modeDb ?? modeLocal;
    final track = trackDb ?? trackLocal;

    debugPrint('[Bootstrap] Décision → mode=$mode, track=$track');

    if (!mounted) return;
    final nav = Navigator.of(context);

    // 3) Missing info -> pickers
    if (!_isValidMode(mode)) {
      nav.pushNamedAndRemoveUntil('/mode_picker', (_) => false);
      return;
    }
    if (!_isValidTrack(track)) {
      nav.pushNamedAndRemoveUntil('/grade_picker', (_) => false);
      return;
    }

    final decidedMode = mode!;
    final decidedTrack = track!;

    // 4) Persist (cohérence) — uniquement mode + track
    try {
      final sp = await _sp;
      await sp.setString(_kUserMode, decidedMode);
      await sp.setString(_kSelectedTrack, decidedTrack);
    } catch (_) {}

    if (!mounted) return;

    // 5) Reserve
    if (decidedTrack == 'reserve') {
      nav.pushNamedAndRemoveUntil('/reserve', (_) => false);
      _syncControllersLater(decidedMode, decidedTrack);
      return;
    }

    // 6) GPX
    if (decidedTrack == 'gpx') {
      // GPX EXAM
      if (decidedMode == 'exam') {
        nav.pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const HomePageGpxExam()),
          (_) => false,
        );
        _syncControllersLater(decidedMode, decidedTrack);
        return;
      }

      // ✅ GPX SCHOOL : choix OBLIGATOIRE à chaque démarrage (NON sauvegardé)
      final picked = await nav.push<GpxSchoolProgram>(
        MaterialPageRoute(builder: (_) => const GpxSchoolArt()),
      );

      if (picked == null) {
        await _resetBootStatus();
        return;
      }

      // ✅ FIX : on applique le programme choisi à la Home GPX
      HomePageGpxSchool.program = picked;

      nav.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomePageGpxSchool()),
        (_) => false,
      );

      _syncControllersLater(decidedMode, decidedTrack);
      return;
    }

    // 7) PA
    if (decidedTrack == 'pa') {
      // PA EXAM
      if (decidedMode == 'exam') {
        nav.pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const HomePagePaExam()),
          (_) => false,
        );
        _syncControllersLater(decidedMode, decidedTrack);
        return;
      }

      // ✅ PA SCHOOL : choix OBLIGATOIRE à chaque démarrage (NON sauvegardé)
      final picked = await nav.push<PaSchoolProgram>(
        MaterialPageRoute(builder: (_) => const PaSchoolArt()),
      );

      if (!mounted) return;

      if (picked == null) {
        // l’utilisateur a “back” → on le renvoie au choix grade
        nav.pushNamedAndRemoveUntil('/grade_picker', (_) => false);
        return;
      }

      // Injecte le choix dans la home PA School
      HomePagePaSchool.program = picked;

      nav.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomePagePaSchool()),
        (_) => false,
      );
      _syncControllersLater(decidedMode, decidedTrack);
      return;
    }

    // Fallback
    nav.pushNamedAndRemoveUntil('/home', (_) => false);
    _syncControllersLater(decidedMode, decidedTrack);
  }

  // ----------------- Controllers sync -----------------

  void _syncControllersLater(String mode, String track) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await UserModeController.I.setMode(
          mode == 'school' ? UserMode.school : UserMode.exam,
        );
      } catch (_) {}

      try {
        final t = switch (track) {
          'pa' => UserTrack.pa,
          'gpx' => UserTrack.gpx,
          'reserve' => UserTrack.gpx, // garde ton mapping actuel
          _ => UserTrack.gpx,
        };
        await UserTrackController.I.setTrack(t);
      } catch (_) {}

      debugPrint('[Bootstrap] Controllers synced → mode=$mode, track=$track');
    });
  }

  // ----------------- UI -----------------

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bonjour 👋',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Chargement de ton espace…',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 42,
                    width: 42,
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: .06),
                          blurRadius: 10,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.sync_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2.6,
                  valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _resetBootStatus() async {
    _didRoute = false;
    if (!mounted) return;
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil('/grade_picker', (_) => false);
  }
}
