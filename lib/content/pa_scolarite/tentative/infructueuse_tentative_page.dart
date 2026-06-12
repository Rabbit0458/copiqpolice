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
class InfructueuseTentativePage extends StatelessWidget {
  const InfructueuseTentativePage({super.key});

  static const String routeName =
      '/gpx/generalites/tentative/infructueuse_tentative';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final Color cardColor = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF7F7F7);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF5D4037);
    final Color textColor = isDark ? Colors.white70 : const Color(0xFF424242);
    final Color accent = isDark ? const Color(0xFF64B5F6) : const Color(0xFF1565C0);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: titleColor),
          tooltip: 'Retour',
        ),
        title: Text(
          'La tentative infructueuse',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: titleColor,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        physics: const BouncingScrollPhysics(),
        children: [
          // En-tête général
          Text(
            'IV. La tentative infructueuse',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'La tentative est infructueuse quand l’auteur accomplit tous les actes '
            'd’exécution sans parvenir au résultat recherché.',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              height: 1.4,
              color: textColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Elle recouvre deux hypothèses :',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              height: 1.3,
              color: textColor,
            ),
          ),
          const SizedBox(height: 6),
          const _BulletPoint(text: 'l’infraction manquée ;'),
          const _BulletPoint(text: 'l’infraction impossible.'),

          const SizedBox(height: 18),

          // INFRACTION MANQUÉE
          _HypoCard(
            title: '1. L’infraction manquée',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            textColor: textColor,
            children: const [
              _Paragraph(
                'Elle suppose une exécution complète qui ne réussit pas.',
              ),
              SizedBox(height: 10),
              _ExempleBox(
                title: 'Exemple',
                bodySpans: [
                  TextSpan(
                    text:
                        'L’auteur tire un coup de feu en direction de la victime mais, du fait de sa maladresse, la rate : tous les actes d’exécution ont été accomplis, ',
                  ),
                  TextSpan(
                    text:
                        'mais le résultat (atteinte corporelle) ne se produit pas.',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(text: '\n\n'),
                  TextSpan(
                    text:
                        'On peut aussi citer l’auteur qui poignarde à plusieurs reprises une personne, '
                        'mais dont les blessures ne sont finalement pas mortelles grâce à une prise en charge médicale rapide.',
                  ),
                ],
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: 'Sanction',
                bodySpans: [
                  TextSpan(
                    text:
                        'L’infraction manquée est punie comme l’infraction tentée ',
                  ),
                  TextSpan(
                    text: '(art. 121-5 C. pén.).',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 18),

          // INFRACTION IMPOSSIBLE
          _HypoCard(
            title: '2. L’infraction impossible',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            textColor: textColor,
            children: const [
              _Paragraph.rich([
                TextSpan(text: 'L’auteur n’a pas obtenu de résultat. '),
                TextSpan(
                  text:
                      'Ce résultat ne pouvait pas exister en raison d’une impossibilité ',
                ),
                TextSpan(
                  text: 'ignorée de l’auteur au moment des faits.',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ]),
              SizedBox(height: 10),
              _ExempleBox(
                title: 'Exemples',
                bodySpans: [
                  TextSpan(
                    text:
                        '• Coup de feu tiré avec une arme chargée à blanc : l’auteur croit tuer, '
                        'mais les munitions ne peuvent pas provoquer le décès.\n',
                  ),
                  TextSpan(
                    text:
                        '• Auteur qui tire sur un cadavre en pensant viser une personne vivante.\n',
                  ),
                  TextSpan(
                    text:
                        '• Pickpocket qui plonge la main dans une poche… vide : l’objet visé n’a jamais été présent.',
                  ),
                ],
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: 'Sanction',
                bodySpans: [
                  TextSpan(
                    text:
                        'L’infraction impossible est punie comme l’infraction tentée, ',
                  ),
                  TextSpan(
                    text:
                        'dès lors qu’il y a eu commencement d’exécution de l’infraction projetée.',
                    style: TextStyle(fontWeight: FontWeight.w600),
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
          border: Border.all(color: accent.withValues(alpha: .22), width: 0.8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .12),
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
        : const Color(0xFF1F1F1F).withValues(alpha: .92);

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
  const _BulletPoint({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bulletColor = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color textColor = isDark ? Colors.white70 : const Color(0xFF424242);

    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Icon(
              Icons.arrow_right_rounded,
              size: 20,
              color: bulletColor,
            ),
          ),
          const SizedBox(width: 2),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.fustat(
                fontSize: 14,
                height: 1.3,
                fontWeight: FontWeight.w500,
                color: textColor,
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
  const _ExempleBox({required this.bodySpans, this.title = 'NOTA'});

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
    final Color titleColor = isDark ? Colors.white : const Color(0xFF5D4037);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: isDark ? .65 : .9),
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
                    : const Color(0xFF102027).withValues(alpha: .95),
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
  const _NotaBox({required this.bodySpans, this.title = 'Nota bene'});

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
        color: bgColor.withValues(alpha: isDark ? .70 : .95),
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
                : const Color(0xFF3E2723).withValues(alpha: .95),
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
