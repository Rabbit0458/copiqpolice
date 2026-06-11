import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaViolIncesteAgressionsAvertissementPage extends StatefulWidget {
  const PaViolIncesteAgressionsAvertissementPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/atteintes_personnes/viol_inceste_agressions/avertissement';

  @override
  State<PaViolIncesteAgressionsAvertissementPage> createState() =>
      _ViolIncesteAgressionsAvertissementPageState();
}

class _ViolIncesteAgressionsAvertissementPageState
    extends State<PaViolIncesteAgressionsAvertissementPage> {
  static const String _targetRoute =
      '/pa/dps_dpg/atteintes_personnes/viol_inceste_agressions';

  bool _accepted = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark ? Colors.white70 : const Color(0xFF222222).withValues(alpha: .70);

    final Color cardBg = isDark
        ? const Color(0xFF2E2E2E)
        : const Color(0xFFF7F7F9);
    final Color border = isDark
        ? Colors.white.withValues(alpha: .08)
        : Colors.black.withValues(alpha: .08);

    final Color warning = isDark
        ? const Color(0xFFFFCA28)
        : const Color(0xFFF9A825);
    final Color warningBg = isDark
        ? const Color(0xFF2A2412)
        : const Color(0xFFFFF8E1);

    final Color primary = isDark
        ? const Color(0xFF1565C0)
        : const Color(0xFF0D47A1);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textMain),
          tooltip: 'Retour',
        ),
        title: Text(
          "Avertissement",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 22),
          children: [
            // Hero / visuel
            Container(
              height: 210,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: border),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/viol_inceste_agressions.jpeg',
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: .20),
                          Colors.black.withValues(alpha: .72),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.18),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.warning_amber_rounded,
                                size: 16,
                                color: warning,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'CONTENU SENSIBLE',
                                style: GoogleFonts.fustat(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 12,
                                  color: Colors.white,
                                  letterSpacing: .4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "Viol, inceste & agressions sexuelles",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.fustat(
                            fontWeight: FontWeight.w900,
                            fontSize: 24,
                            height: 1.05,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Certaines personnes peuvent être heurtées par le contenu ou les illustrations.",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.fustat(
                            fontWeight: FontWeight.w500,
                            fontSize: 13.5,
                            height: 1.3,
                            color: Colors.white.withValues(alpha: .92),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Card principale d'avertissement
            Container(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? .20 : .08),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Avant de continuer",
                    style: GoogleFonts.fustat(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      color: textMain,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: warningBg.withValues(alpha: isDark ? .75 : 1),
                      borderRadius: BorderRadius.circular(14),
                      border: Border(
                        left: BorderSide(color: warning, width: 3),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: warning,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Cette section traite d’infractions sexuelles. Les documents sont à visée pédagogique et professionnelle. "
                            "Certaines images d’illustration peuvent heurter.",
                            style: GoogleFonts.fustat(
                              fontWeight: FontWeight.w600,
                              fontSize: 13.5,
                              height: 1.35,
                              color: isDark
                                  ? Colors.white70
                                  : const Color(0xFF3E2723),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    "Recommandations",
                    style: GoogleFonts.fustat(
                      fontWeight: FontWeight.w900,
                      fontSize: 15.5,
                      color: textMain,
                    ),
                  ),
                  const SizedBox(height: 8),

                  _Bullet(
                    text:
                        "Si vous êtes sensible à ce sujet, il est recommandé de ne pas poursuivre.",
                    textSoft: textSoft,
                  ),
                  _Bullet(
                    text:
                        "Si ce contenu ravive une expérience personnelle, interrompez la lecture et prenez soin de vous.",
                    textSoft: textSoft,
                  ),
                  _Bullet(
                    text:
                        "Objectif : compréhension juridique et préparation professionnelle.",
                    textSoft: textSoft,
                  ),

                  const SizedBox(height: 14),

                  // ✅ Checkbox d'acceptation
                  InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => setState(() => _accepted = !_accepted),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: border),
                        color: (isDark ? Colors.white : Colors.black)
                            .withValues(alpha: 0.03),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: _accepted,
                            onChanged: (v) =>
                                setState(() => _accepted = v ?? false),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            activeColor: primary,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                "Je comprends que cette section contient du contenu sensible et je souhaite continuer.",
                                style: GoogleFonts.fustat(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13.5,
                                  height: 1.25,
                                  color: textSoft,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).maybePop(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: BorderSide(
                              color: isDark ? Colors.white24 : Colors.black12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            "Ne pas continuer",
                            style: GoogleFonts.fustat(
                              fontWeight: FontWeight.w800,
                              fontSize: 14.5,
                              color: textMain,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _accepted
                              ? () => Navigator.of(
                                  context,
                                ).pushReplacementNamed(_targetRoute)
                              : null,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: primary,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor:
                                (isDark ? Colors.white : Colors.black)
                                    .withValues(alpha: .12),
                            disabledForegroundColor:
                                (isDark ? Colors.white : Colors.black)
                                    .withValues(alpha: .35),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            "Je comprends",
                            style: GoogleFonts.fustat(
                              fontWeight: FontWeight.w900,
                              fontSize: 14.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Center(
                    child: Text(
                      "Vous pouvez revenir en arrière à tout moment.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.fustat(
                        fontWeight: FontWeight.w600,
                        fontSize: 12.5,
                        height: 1.25,
                        color: textSoft,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet({required this.text, required this.textSoft});

  final String text;
  final Color textSoft;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color iconColor = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Icon(Icons.check_rounded, size: 18, color: iconColor),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.fustat(
                fontWeight: FontWeight.w600,
                fontSize: 13.5,
                height: 1.35,
                color: textSoft,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
