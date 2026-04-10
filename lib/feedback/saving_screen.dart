// lib/feedback/saving_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../home/home_page.dart';

class SavingScreen extends StatefulWidget {
  static const routeName = '/saving';
  const SavingScreen({super.key, required this.payload});
  final Map<String, dynamic> payload;

  @override
  State<SavingScreen> createState() => _SavingScreenState();
}

class _SavingScreenState extends State<SavingScreen>
    with SingleTickerProviderStateMixin {
  bool _done = false;
  String _msg = "Sauvegarde de vos résultats…";
  String? _error;

  @override
  void initState() {
    super.initState();
    _run();
  }

  /// --- NOUVEAU : garantit qu'on a un utilisateur authentifié ---
  Future<User?> _getUserOrSignIn() async {
    final supa = Supabase.instance.client;

    // 0) Déjà connecté ?
    var user = supa.auth.currentUser ?? supa.auth.currentSession?.user;
    if (user != null) return user;

    // 1) Essayer de restaurer un éventuel token persistant
    try {
      await supa.auth.refreshSession();
    } catch (_) {}
    user = supa.auth.currentUser ?? supa.auth.currentSession?.user;
    if (user != null) return user;

    // 2) Écouter l'auth pendant qu'on ouvre l'écran de login
    final completer = Completer<User?>();
    late final StreamSubscription sub;
    sub = supa.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      final session = data.session;
      if (session?.user != null &&
          (event == AuthChangeEvent.signedIn ||
              event == AuthChangeEvent.tokenRefreshed)) {
        if (!completer.isCompleted) completer.complete(session!.user);
        sub.cancel();
      }
    });

    // 3) Ouvrir ta page d’auth (à adapter au nom de ta route)
    //    -> si elle pop un bool, on s'en sert, sinon l'event signedIn suffira.
    await Navigator.of(context).pushNamed('/home');

    // 4) Attendre au plus 20s un éventuel signedIn
    final waited = await completer.future.timeout(
      const Duration(seconds: 20),
      onTimeout: () => null,
    );
    await sub.cancel();

    // 5) Dernière chance
    return waited ?? supa.auth.currentUser ?? supa.auth.currentSession?.user;
  }

  Future<void> _run() async {
    try {
      final supa = Supabase.instance.client;

      // --- ICI on exige une session ---
      final user = await _getUserOrSignIn();
      if (user == null) {
        setState(() {
          _error =
              "Session introuvable. Connecte-toi puis appuie sur Réessayer.";
          _done = false;
        });
        return;
      }

      // 2) Extraire/fiabiliser le payload (inchangé)
      final rawTotal = widget.payload['total_score'];
      final rawMax = widget.payload['max_score'];
      if (rawTotal == null || rawMax == null) {
        throw 'Payload incomplet: total_score/max_score manquants.';
      }
      final double totalScore = (rawTotal as num).toDouble();
      final double maxScore = (rawMax as num).toDouble();

      double scorePct;
      final rawPct = widget.payload['score_pct'];
      if (rawPct != null) {
        scorePct = (rawPct as num).toDouble();
      } else {
        scorePct = maxScore == 0 ? 0 : (totalScore / maxScore) * 100.0;
      }

      final List<Map<String, dynamic>> answers =
          (widget.payload['answers'] as List?)?.cast<Map<String, dynamic>>() ??
          const [];

      // 3) Insert placement_results
      final inserted = await supa
          .from('placement_results')
          .insert({
            'user_id': user.id,
            'email': user.email, // selon ton provider, peut être null
            'total_score': totalScore,
            'max_score': maxScore,
            'score_pct': scorePct,
          })
          .select('id')
          .single();

      final String resultId = inserted['id'] as String;

      // 4) Insert bulk placement_answers
      if (answers.isNotEmpty) {
        final rows = answers.map((a) {
          final qid = a['question_id'] ?? a['id'];
          final domain = a['domain'] ?? a['domain_sql'] ?? a['domain_value'];
          final sel =
              a['selected_index'] ?? a['selectedIndex'] ?? a['selected'];
          final corr = a['correct_index'] ?? a['correctIndex'] ?? a['correct'];

          return {
            'result_id': resultId,
            'user_id': user.id,
            'question_id': qid,
            'domain': domain,
            'selected_index': sel,
            'correct_index': corr,
          };
        }).toList();

        await supa.from('placement_answers').insert(rows);
      }

      // 5) Succès + transition
      setState(() {
        _done = true;
        _msg = "Terminé !";
        _error = null;
      });
      await Future.delayed(const Duration(milliseconds: 700));
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(_homeTransition(), (_) => false);
    } catch (e) {
      String msg = "Sauvegarde impossible pour le moment.";
      final s = e.toString();
      if (s.contains('Row level security') || s.contains('RLS')) {
        msg =
            "Accès refusé (RLS). Vérifie les policies (user_id = auth.uid()).";
      } else if (s.contains('invalid input value for enum') ||
          s.contains('domain')) {
        msg =
            "Valeur de domaine invalide ('francais', 'logique', 'deontologie', 'histoire', 'sport').";
      } else if (s.contains('Payload incomplet')) {
        msg = "Payload incomplet (total_score / max_score).";
      }
      setState(() {
        _error = msg;
        _done = false;
      });
      // ignore: avoid_print
      print("[SavingScreen] Insert error: $e");
    }
  }

  // 1) Toujours retourner une Route
  Route _homeTransition() {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => const HomePage(),
      transitionDuration: const Duration(milliseconds: 450),
      transitionsBuilder: (_, anim, __, child) {
        final fade = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
        final slide = Tween<Offset>(
          begin: const Offset(0, .03),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOutCubic)).animate(anim);

        return FadeTransition(
          opacity: fade,
          child: SlideTransition(
            position: slide,
            child: ScaleTransition(
              scale: Tween<double>(begin: .98, end: 1.0).animate(fade),
              child: child,
            ),
          ),
        );
      },
    );
  }

  // 2) Toujours retourner un Widget
  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF000932);
    return Scaffold(
      backgroundColor: bg,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              child: _error != null
                  ? Container(
                      key: const ValueKey('err'),
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF3B30).withValues(alpha: .16),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFFF3B30).withValues(alpha: .8),
                          width: 3,
                        ),
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        color: Color(0xFFFF3B30),
                        size: 40,
                      ),
                    )
                  : _done
                  ? Container(
                      key: const ValueKey('ok'),
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        color: const Color(0xFF27C93F).withValues(alpha: .16),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF27C93F).withValues(alpha: .8),
                          width: 3,
                        ),
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Color(0xFF27C93F),
                        size: 44,
                      ),
                    )
                  : const SizedBox(
                      key: ValueKey('load'),
                      width: 88,
                      height: 88,
                      child: CircularProgressIndicator(strokeWidth: 6),
                    ),
            ),
            const SizedBox(height: 16),
            Text(
              _error ?? _msg,
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _error = null;
                        _msg = "Nouvelle tentative…";
                      });
                      _run();
                    },
                    child: const Text("Réessayer"),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
