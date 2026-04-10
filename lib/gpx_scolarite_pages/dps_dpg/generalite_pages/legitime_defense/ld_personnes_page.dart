import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ===================================================================
///  COP'IQ — LA TENTATIVE INFRUCTUEUSE
///
///  IV. La tentative infructueuse
///   - Déf° générale
///   - 2 hypothèses : infraction manquée / infraction impossible
///   - Exemple visuel pour chacune
///   - Rappel : punie comme l’infraction tentée (art. 121-5 C. pén.)
/// ===================================================================
class LdPersonnesPage extends StatelessWidget {
  const LdPersonnesPage({super.key});

  static const String routeName = '/gpx/generalites/legitime-defense/personnes';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF121212) : Colors.white;
    final Color card = isDark
        ? const Color(0xFF1E1E1E)
        : const Color(0xFFF7F7F7);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF050505);
    final Color textColor = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withOpacity(.92);
    final Color accent = isDark
        ? const Color(0xFF4CAF50)
        : const Color(0xFF2E7D32);
    final Color redAccent = const Color(0xFFFF3B30);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: titleColor),
        ),
        title: Text(
          'La légitime défense – Personnes',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: titleColor,
          ),
        ),
      ),

      // ===================== CONTENU =====================
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        physics: const BouncingScrollPhysics(),
        children: [
          Text(
            'I. La légitime défense d’une personne\n(Article 122-5 du Code Pénal.)',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'N’est pas pénalement responsable la personne qui, face à une atteinte '
            'injustifiée envers elle-même ou autrui, réagit dans le même temps '
            'par un acte dicté par la nécessité de la défense, sauf disproportion '
            'entre les moyens employés et la gravité de l’atteinte.',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              height: 1.4,
              color: textColor,
            ),
          ),
          const SizedBox(height: 10),

          Text(
            'En pratique, la légitime défense repose sur deux blocs :',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              height: 1.3,
              color: textColor,
            ),
          ),
          const SizedBox(height: 6),

          // ===== BULLETS INTRO =====
          _BulletPoint.rich([
            TextSpan(
              text: 'Atteinte INJUSTIFIÉE, ACTUELLE et RÉELLE.',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ]),
          _BulletPoint.rich([
            TextSpan(
              text: 'Défense NÉCESSAIRE, SIMULTANÉE et PROPORTIONNÉE.',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ]),

          const SizedBox(height: 20),

          // ============================================
          // 1 — ATTEINTE SUBIE
          // ============================================
          _HypoCard(
            title: '1. L’atteinte subie',
            cardColor: card,
            accent: accent,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph(
                'Pour invoquer la légitime défense, la personne doit être confrontée '
                'à une atteinte clairement caractérisée. Trois conditions cumulatives sont exigées.',
              ),
              const SizedBox(height: 10),

              // ----- INJUSTIFIÉE -----
              _BulletPoint.rich([
                TextSpan(
                  text: 'INJUSTIFIÉE',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: redAccent,
                  ),
                ),
                const TextSpan(
                  text:
                      ' : sans motif légitime, contraire au droit. Aucun droit de riposte '
                      'contre une action régulière de police.',
                ),
              ]),

              // ----- ACTUELLE -----
              _BulletPoint.rich([
                TextSpan(
                  text: 'ACTUELLE',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: redAccent,
                  ),
                ),
                const TextSpan(
                  text:
                      ' : en cours ou imminente. Une attaque passée ne justifie pas '
                      'une riposte de vengeance.',
                ),
              ]),

              // ----- RÉELLE -----
              _BulletPoint.rich([
                TextSpan(
                  text: 'RÉELLE',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: redAccent,
                  ),
                ),
                const TextSpan(
                  text:
                      ' : l’atteinte doit exister objectivement. Une simple peur subjective '
                      'ne suffit pas.',
                ),
              ]),

              const SizedBox(height: 10),

              const _ExempleBox(
                title: 'Exemple',
                bodySpans: [
                  TextSpan(
                    text:
                        'Une personne est saisie violemment au cou en pleine rue. '
                        'L’attaque est injustifiée, actuelle et réelle : les conditions du premier '
                        'bloc sont réunies.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 22),

          // ============================================
          // 2 — ACTE DE DÉFENSE
          // ============================================
          _HypoCard(
            title: '2. L’acte de défense',
            cardColor: card,
            accent: accent,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph(
                'La riposte doit également respecter trois exigences cumulatives pour '
                'être couverte par la légitime défense.',
              ),
              const SizedBox(height: 10),

              // ----- NÉCESSAIRE -----
              _BulletPoint.rich([
                TextSpan(
                  text: 'NÉCESSAIRE',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: redAccent,
                  ),
                ),
                const TextSpan(
                  text:
                      ' : pas d’alternative raisonnable (fuite impossible, aide indisponible).',
                ),
              ]),

              // ----- SIMULTANÉE -----
              _BulletPoint.rich([
                TextSpan(
                  text: 'SIMULTANÉE',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: redAccent,
                  ),
                ),
                const TextSpan(
                  text:
                      ' : la défense doit intervenir au même moment que l’atteinte.',
                ),
              ]),

              // ----- PROPORTIONNÉE -----
              _BulletPoint.rich([
                TextSpan(
                  text: 'PROPORTIONNÉE',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: redAccent,
                  ),
                ),
                const TextSpan(
                  text:
                      ' : les moyens utilisés doivent rester adaptés à la gravité du danger.',
                ),
              ]),

              const SizedBox(height: 10),

              const _ExempleBox(
                title: 'Exemples',
                bodySpans: [
                  TextSpan(
                    text:
                        '• Une personne repousse un agresseur qui la frappe : une riposte mesurée peut être admise.\n',
                  ),
                  TextSpan(
                    text:
                        '• Tirer sur un agresseur légèrement armé ou déjà en fuite rompt la proportionnalité.',
                  ),
                ],
              ),
              const SizedBox(height: 10),

              const _NotaBox(
                title: 'À retenir',
                bodySpans: [
                  TextSpan(
                    text:
                        'Si les conditions sont remplies, la légitime défense efface '
                        'la responsabilité pénale. Les juges vérifient strictement la réalité '
                        'du danger et la proportion de la riposte.',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// ------------------------------------------------------------------
/// CARTE HYPOTHÈSE (manquée / impossible)
/// ------------------------------------------------------------------
class _HypoCard extends StatelessWidget {
  const _HypoCard({
    required this.title,
    required this.cardColor,
    required this.accent,
    required this.titleColor,
    required this.textColor,
    required this.children,
  });

  final String title;
  final Color cardColor;
  final Color accent;
  final Color titleColor;
  final Color textColor;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      header: true,
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: accent.withOpacity(.22), width: 0.8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.12),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.fustat(
                fontWeight: FontWeight.w800,
                fontSize: 16.5,
                color: titleColor,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

/// ------------------------------------------------------------------
/// PARAGRAPHES SIMPLES OU RICHES
/// ------------------------------------------------------------------
class _Paragraph extends StatelessWidget {
  const _Paragraph(this.text) : spans = null;

  const _Paragraph.rich(this.spans) : text = null;

  final String? text;
  final List<TextSpan>? spans;

  @override
  Widget build(BuildContext context) {
    final isRich = spans != null;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final Color color = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withOpacity(.92);

    if (!isRich) {
      return Text(
        text ?? '',
        textAlign: TextAlign.justify,
        style: GoogleFonts.fustat(
          fontSize: 14,
          height: 1.4,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      );
    }

    return RichText(
      textAlign: TextAlign.justify,
      text: TextSpan(
        style: GoogleFonts.fustat(
          fontSize: 14,
          height: 1.4,
          fontWeight: FontWeight.w500,
          color: color,
        ),
        children: spans,
      ),
    );
  }
}

/// ------------------------------------------------------------------
/// PUCE SIMPLE (liste des hypothèses en intro)
/// ------------------------------------------------------------------
class _BulletPoint extends StatelessWidget {
  final List<InlineSpan> spans;

  const _BulletPoint.rich(this.spans, {super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDark ? Colors.white70 : const Color(0xFF1F1F1F);

    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("• ", style: TextStyle(fontSize: 15, height: 1.4, color: color)),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: TextStyle(fontSize: 14, height: 1.35, color: color),
                children: spans,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ------------------------------------------------------------------
/// BLOC EXEMPLE
/// ------------------------------------------------------------------
class _ExempleBox extends StatelessWidget {
  const _ExempleBox({required this.title, required this.bodySpans});

  final String title;
  final List<TextSpan> bodySpans;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color borderColor = isDark
        ? const Color(0xFF42A5F5)
        : const Color(0xFF1E88E5);
    final Color bgColor = isDark
        ? const Color(0xFF0D1B26)
        : const Color(0xFFE3F2FD);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF0D47A1);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(isDark ? .65 : .9),
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: borderColor, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title :',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w800,
              fontSize: 13.5,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              style: GoogleFonts.fustat(
                fontSize: 13.5,
                height: 1.4,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? Colors.white70
                    : const Color(0xFF102027).withOpacity(.95),
              ),
              children: bodySpans,
            ),
          ),
        ],
      ),
    );
  }
}

/// ------------------------------------------------------------------
/// BLOC NOTA / SANCTION
/// ------------------------------------------------------------------
class _NotaBox extends StatelessWidget {
  const _NotaBox({required this.bodySpans, this.title = 'NOTA'});

  final List<TextSpan> bodySpans;
  final String title;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color borderColor = isDark
        ? const Color(0xFFFFCA28)
        : const Color(0xFFF9A825);
    final Color bgColor = isDark
        ? const Color(0xFF26200F)
        : const Color(0xFFFFF8E1);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF5D4037);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(isDark ? .70 : .95),
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: borderColor, width: 3)),
      ),
      child: RichText(
        textAlign: TextAlign.justify,
        text: TextSpan(
          style: GoogleFonts.fustat(
            fontSize: 13.5,
            height: 1.4,
            fontWeight: FontWeight.w500,
            color: isDark
                ? Colors.white70
                : const Color(0xFF3E2723).withOpacity(.95),
          ),
          children: [
            TextSpan(
              text: '$title : ',
              style: TextStyle(fontWeight: FontWeight.w900, color: titleColor),
            ),
            ...bodySpans,
          ],
        ),
      ),
    );
  }
}
