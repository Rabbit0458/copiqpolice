import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LdCasPresumesPage extends StatelessWidget {
  const LdCasPresumesPage({super.key});

  static const String routeName =
      '/gpx/generalites/legitime-defense/cas-presumes';

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
        ? const Color(0xFF8E24AA)
        : const Color(0xFF6A1B9A);
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
          'Cas présumés de légitime défense',
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
            'III. Cas présumés de légitime défense\n(Article 122-6 du Code pénal)',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'La loi prévoit des situations dans lesquelles la personne qui accomplit '
            'l’acte est présumée avoir agi en état de légitime défense. '
            'Il s’agit d’une présomption simple : elle peut être renversée par la preuve contraire.',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              height: 1.4,
              color: textColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Deux grands cas sont visés par l’article 122-6 du Code pénal :',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              height: 1.3,
              color: textColor,
            ),
          ),
          const SizedBox(height: 6),

          _BulletPoint.rich([
            const TextSpan(
              text:
                  'La défense de nuit contre l’entrée frauduleuse dans un lieu d’habitation ;',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ]),
          _BulletPoint.rich([
            const TextSpan(
              text:
                  'La défense contre les auteurs de vols ou de pillages exécutés avec violence.',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ]),

          const SizedBox(height: 20),

          // ============================================
          // 1 — PREMIER CAS : LA DÉFENSE DE NUIT
          // ============================================
          _HypoCard(
            title: '1. Défense de nuit contre l’entrée dans un lieu habité',
            cardColor: card,
            accent: accent,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph(
                'Est présumé avoir agi en état de légitime défense celui qui, '
                'pour repousser, DE NUIT, l’entrée dans un lieu habité, accomplit un acte de défense.',
              ),
              const SizedBox(height: 10),

              _BulletPoint.rich([
                TextSpan(
                  text: 'DE NUIT',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: redAccent,
                  ),
                ),
                const TextSpan(
                  text:
                      ' : l’intervalle de temps est compris entre le coucher et le lever du soleil. '
                      'La présomption ne joue pas de jour.',
                ),
              ]),
              _BulletPoint.rich([
                const TextSpan(
                  text: 'Lieu visé : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const TextSpan(
                  text:
                      'un lieu habité (maison ou appartement occupé). Les dépendances '
                      'ou locaux purement professionnels peuvent poser davantage de difficultés.',
                ),
              ]),
              _BulletPoint.rich([
                const TextSpan(
                  text: 'Modalités d’entrée : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text: 'EFFRACTION, VIOLENCE ou RUSE.',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: redAccent,
                  ),
                ),
                const TextSpan(
                  text:
                      ' L’entrée doit donc être obtenue par un procédé irrégulier ou agressif.',
                ),
              ]),

              const SizedBox(height: 10),

              const _ExempleBox(
                title: 'Exemple',
                bodySpans: [
                  TextSpan(
                    text:
                        'De nuit, un individu fracture la porte d’un appartement occupé. '
                        'L’occupant repousse l’intrus en lui portant un coup pour le faire sortir. '
                        'La loi présume alors la légitime défense, sous réserve de l’absence '
                        'de disproportion manifeste dans la riposte.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 22),

          // ============================================
          // 2 — DEUXIÈME CAS : VOLS / PILLAGES VIOLENTS
          // ============================================
          _HypoCard(
            title:
                '2. Défense contre les vols ou pillages exécutés avec violence',
            cardColor: card,
            accent: accent,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph(
                'Est également présumé avoir agi en état de légitime défense celui qui, '
                'pour se défendre, de jour comme de nuit, contre les auteurs de certains '
                'vols ou pillages exécutés avec violence, accomplit un acte de défense.',
              ),
              const SizedBox(height: 10),

              _BulletPoint.rich([
                TextSpan(
                  text: 'VOLS',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: redAccent,
                  ),
                ),
                const TextSpan(text: ' ou '),
                TextSpan(
                  text: 'PILLAGES',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: redAccent,
                  ),
                ),
                const TextSpan(
                  text:
                      ' : il doit s’agir d’atteintes graves aux biens, généralement commises '
                      'en groupe ou dans un contexte de trouble important à l’ordre public.',
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: 'VIOLENCE',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: redAccent,
                  ),
                ),
                const TextSpan(
                  text:
                      ' : les vols ou pillages doivent être exécutés avec violences '
                      '(coups, sévices, agressions physiques). La simple présence de menaces '
                      'ou l’intimidation peuvent ne pas suffire pour bénéficier de la présomption.',
                ),
              ]),
              _BulletPoint.rich([
                const TextSpan(
                  text: 'Moment de l’acte de défense : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const TextSpan(
                  text:
                      'l’acte doit intervenir pour se défendre contre les auteurs, '
                      'pendant l’attaque ou dans son immédiate continuité.',
                ),
              ]),

              const SizedBox(height: 10),

              const _ExempleBox(
                title: 'Exemple',
                bodySpans: [
                  TextSpan(
                    text:
                        'Lors d’un pillage de magasin avec coups et violences sur le personnel, '
                        'un agent de sécurité repousse un agresseur en utilisant un moyen de défense '
                        'proportionné. Il bénéficie de la présomption de légitime défense, sous réserve '
                        'des vérifications du juge.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 22),

          // ============================================
          // BLOC PRÉSOMPTION
          // ============================================
          const _NotaBox(
            title: 'Présomption simple',
            bodySpans: [
              TextSpan(
                text:
                    'Dans ces deux hypothèses, la personne est présumée avoir agi en état '
                    'de légitime défense. Il s’agit toutefois d’une ',
              ),
              TextSpan(
                text: 'présomption simple',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              TextSpan(
                text:
                    ' : le ministère public ou la partie civile peuvent apporter la preuve '
                    'contraire (par exemple en démontrant une riposte manifestement '
                    'disproportionnée ou un détournement de la situation).',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// ------------------------------------------------------------------
/// CARTE
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
/// PARAGRAPHE
/// ------------------------------------------------------------------
class _Paragraph extends StatelessWidget {
  const _Paragraph(this.text) : spans = null;

  const _Paragraph.rich(this.spans) : text = null;

  final String? text;
  final List<TextSpan>? spans;

  @override
  Widget build(BuildContext context) {
    final isRich = spans != null;
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
/// PUCE
/// ------------------------------------------------------------------
class _BulletPoint extends StatelessWidget {
  final List<InlineSpan> spans;

  const _BulletPoint.rich(this.spans, {super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color color = isDark ? Colors.white70 : const Color(0xFF1F1F1F);

    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: TextStyle(fontSize: 15, height: 1.4, color: color)),
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
        ? const Color(0xFFAB47BC)
        : const Color(0xFF8E24AA);
    final Color bgColor = isDark
        ? const Color(0xFF1A1021)
        : const Color(0xFFF3E5F5);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF4A148C);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(isDark ? .70 : .95),
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
                    : const Color(0xFF311B3F).withOpacity(.95),
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
/// BLOC NOTA
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
