import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Accueil très bref réservé aux sessions restaurées au lancement.
///
/// Cet écran n'est volontairement pas une route publique : le bootstrap de
/// l'application est le seul endroit autorisé à l'afficher. Une connexion ou
/// une inscription réalisée pendant que l'application est ouverte rejoint
/// directement le sélecteur de mode.
class ReturningUserWelcome extends StatefulWidget {
  const ReturningUserWelcome({
    super.key,
    required this.onComplete,
    this.visibleDuration = const Duration(seconds: 5),
  });

  final VoidCallback onComplete;
  final Duration visibleDuration;

  @override
  State<ReturningUserWelcome> createState() => _ReturningUserWelcomeState();
}

class _ReturningUserWelcomeState extends State<ReturningUserWelcome>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _opacity;
  late final Animation<double> _scale;
  late final Animation<double> _successScale;
  String? _firstName;
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
      reverseDuration: const Duration(milliseconds: 600),
    );
    _opacity = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    _scale = Tween<double>(begin: .98, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _successScale = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(.42, 1, curve: Curves.easeOutBack),
      ),
    );

    unawaited(_loadFirstName());
    WidgetsBinding.instance.addPostFrameCallback((_) => _runSequence());
  }

  Future<void> _loadFirstName() async {
    final client = Supabase.instance.client;
    final user = client.auth.currentUser;
    if (user == null) return;

    String? name;
    try {
      final profile = await client
          .from('user_profiles')
          .select('first_name, username')
          .eq('user_id', user.id)
          .maybeSingle()
          .timeout(const Duration(milliseconds: 650));
      name = _firstUsefulName(profile?['first_name'], profile?['username']);
    } catch (_) {
      // Le message doit rester instantané même hors connexion.
    }

    name ??= _firstUsefulName(
      user.userMetadata?['first_name'] ?? user.userMetadata?['given_name'],
      user.userMetadata?['username'] ?? user.userMetadata?['full_name'],
    );
    if (mounted && name != null) setState(() => _firstName = name);
  }

  String? _firstUsefulName(dynamic firstName, dynamic username) {
    for (final candidate in [firstName, username]) {
      final value = candidate?.toString().trim() ?? '';
      if (value.isNotEmpty) return value.split(RegExp(r'\s+')).first;
    }
    return null;
  }

  Future<void> _runSequence() async {
    final reducedMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (reducedMotion) {
      _animationController.value = 1;
    } else {
      await _animationController.forward();
    }

    await Future<void>.delayed(widget.visibleDuration);
    if (!mounted || _completed) return;

    if (!reducedMotion) await _animationController.reverse();
    if (!mounted || _completed) return;
    _completed = true;
    widget.onComplete();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isDark ? const Color(0xFF06111F) : Colors.white;
    final foreground = isDark ? Colors.white : const Color(0xFF171A20);
    final subtitle = isDark ? const Color(0xFFD7DCE8) : const Color(0xFF5F6472);
    final greeting = _firstName == null
        ? 'Nous sommes ravis de vous revoir'
        : 'Nous sommes ravis de vous revoir, $_firstName';

    return Scaffold(
      backgroundColor: background,
      body: Semantics(
        label:
            '$greeting. Votre profil a bien été récupéré. Merci de faire partie de COP’IQ.',
        readOnly: true,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDark
                  ? const [Color(0xFF06111F), Color(0xFF0B1B33)]
                  : const [Colors.white, Color(0xFFF4F7FF)],
            ),
          ),
          child: Center(
            child: FadeTransition(
              opacity: _opacity,
              child: ScaleTransition(
                scale: _scale,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 190,
                        height: 190,
                        child: Image.network(
                          'https://nuoonagnkhbeeymtvrcn.supabase.co/storage/v1/object/public/assets/logo_gris.png',
                          fit: BoxFit.contain,
                          semanticLabel: "Logo COP'IQ",
                          errorBuilder: (_, __, ___) => Image.asset(
                            'assets/images/logo.png',
                            fit: BoxFit.contain,
                            semanticLabel: "Logo COP'IQ",
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      Text(
                        greeting,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.instrumentSans(
                          color: foreground,
                          fontSize: 27,
                          height: 1.18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Votre espace est prêt.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.instrumentSans(
                          color: subtitle,
                          fontSize: 15,
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ScaleTransition(
                        scale: _successScale,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(14, 10, 18, 10),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF0B2D25)
                                : const Color(0xFFECFDF3),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: isDark
                                  ? const Color(0xFF1E7A5C)
                                  : const Color(0xFFB7E9D1),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF16A36A),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check_rounded,
                                  color: Colors.white,
                                  size: 21,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Flexible(
                                child: Text(
                                  'Profil récupéré avec succès',
                                  style: GoogleFonts.instrumentSans(
                                    color: isDark
                                        ? const Color(0xFFA7F3D0)
                                        : const Color(0xFF176B4D),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        "Merci de faire partie de l'aventure COP'IQ.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.instrumentSans(
                          color: subtitle,
                          fontSize: 14,
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
