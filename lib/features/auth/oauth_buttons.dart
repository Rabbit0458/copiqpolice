// ╔══════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Boutons de connexion par fournisseur externe                   ║
// ║                                                                          ║
// ║  Le bloc entier ne s'affiche que si au moins un fournisseur est activé   ║
// ║  (voir OAuthService). Tant que rien n'est configuré côté Supabase, il    ║
// ║  renvoie `SizedBox.shrink()` : les écrans de connexion et d'inscription  ║
// ║  restent strictement identiques à aujourd'hui.                            ║
// ║                                                                          ║
// ║  Les visuels respectent les chartes imposées :                            ║
// ║    • Apple — fond noir, logo blanc, libellé « Continuer avec Apple »     ║
// ║      (Human Interface Guidelines, section Sign in with Apple)             ║
// ║    • Google — fond blanc, bordure grise, logo quadrichrome                ║
// ║      (Google Identity Branding Guidelines)                                ║
// ╚══════════════════════════════════════════════════════════════════════════╝

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:copiqpolice/features/auth/oauth_service.dart';

class OAuthButtons extends StatefulWidget {
  const OAuthButtons({super.key, this.onStarted});

  /// Appelé dès qu'un parcours externe démarre : permet à l'écran parent
  /// d'afficher un indicateur de chargement.
  final VoidCallback? onStarted;

  @override
  State<OAuthButtons> createState() => _OAuthButtonsState();
}

class _OAuthButtonsState extends State<OAuthButtons> {
  AuthProviderKind? _busy;
  String? _error;

  Future<void> _run(AuthProviderKind kind) async {
    setState(() {
      _busy = kind;
      _error = null;
    });
    final res = await OAuthService.I.signIn(kind);
    if (!mounted) return;
    setState(() {
      _busy = null;
      _error = res.errorMessage;
    });
    if (res.started) widget.onStarted?.call();
  }

  @override
  Widget build(BuildContext context) {
    final svc = OAuthService.I;
    if (!svc.hasAnyProvider) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final divider = isDark ? Colors.white24 : const Color(0xFFD5DBE8);
    final faint = isDark ? Colors.white54 : const Color(0xFF94A3B8);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 22),
        Row(
          children: [
            Expanded(child: Divider(color: divider, thickness: 1)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'ou',
                style: GoogleFonts.instrumentSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: faint,
                ),
              ),
            ),
            Expanded(child: Divider(color: divider, thickness: 1)),
          ],
        ),
        const SizedBox(height: 18),

        if (svc.isEnabled(AuthProviderKind.apple)) ...[
          _AppleButton(
            busy: _busy == AuthProviderKind.apple,
            disabled: _busy != null,
            onTap: () => _run(AuthProviderKind.apple),
          ),
          const SizedBox(height: 10),
        ],

        if (svc.isEnabled(AuthProviderKind.google))
          _GoogleButton(
            busy: _busy == AuthProviderKind.google,
            disabled: _busy != null,
            isDark: isDark,
            onTap: () => _run(AuthProviderKind.google),
          ),

        if (_error != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFEF4444).withValues(alpha: .10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              _error!,
              textAlign: TextAlign.center,
              style: GoogleFonts.instrumentSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFEF4444),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// ─── Bouton Apple ───────────────────────────────────────────────────────────

class _AppleButton extends StatelessWidget {
  const _AppleButton({
    required this.busy,
    required this.disabled,
    required this.onTap,
  });

  final bool busy;
  final bool disabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: ElevatedButton(
        onPressed: disabled ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          disabledBackgroundColor: Colors.black.withValues(alpha: .5),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: busy
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.4,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.apple, color: Colors.white, size: 24),
                  const SizedBox(width: 10),
                  Text(
                    'Continuer avec Apple',
                    style: GoogleFonts.instrumentSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// ─── Bouton Google ──────────────────────────────────────────────────────────

class _GoogleButton extends StatelessWidget {
  const _GoogleButton({
    required this.busy,
    required this.disabled,
    required this.isDark,
    required this.onTap,
  });

  final bool busy;
  final bool disabled;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: OutlinedButton(
        onPressed: disabled ? null : onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: isDark ? const Color(0xFF1F1F1F) : Colors.white,
          side: BorderSide(
            color: isDark ? Colors.white24 : const Color(0xFFD5DBE8),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: busy
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: isDark ? Colors.white : Colors.black54,
                  strokeWidth: 2.4,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const _GoogleLogo(size: 20),
                  const SizedBox(width: 10),
                  Text(
                    'Continuer avec Google',
                    style: GoogleFonts.instrumentSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF1F1F1F),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// Logo Google dessiné en Flutter — évite d'embarquer un asset supplémentaire
/// et respecte les couleurs officielles de la charte.
class _GoogleLogo extends StatelessWidget {
  const _GoogleLogo({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _GoogleLogoPainter()),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  static const _blue = Color(0xFF4285F4);
  static const _red = Color(0xFFEA4335);
  static const _yellow = Color(0xFFFBBC05);
  static const _green = Color(0xFF34A853);

  @override
  void paint(Canvas canvas, Size size) {
    final r = size.width / 2;
    final c = Offset(r, r);
    final stroke = size.width * 0.22;
    final rect = Rect.fromCircle(center: c, radius: r - stroke / 2);

    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.butt;

    // Quatre arcs de 90°, dans l'ordre de la charte Google.
    canvas.drawArc(rect, -0.55, 1.15, false, p..color = _red);
    canvas.drawArc(rect, 0.60, 1.30, false, p..color = _yellow);
    canvas.drawArc(rect, 1.90, 1.25, false, p..color = _green);
    canvas.drawArc(rect, 3.15, 1.60, false, p..color = _blue);

    // Barre horizontale du « G ».
    final bar = Paint()..color = _blue;
    canvas.drawRect(
      Rect.fromLTWH(r, r - stroke / 2, r - stroke / 2, stroke),
      bar,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
