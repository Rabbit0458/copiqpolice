import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConditionTentativePage extends StatelessWidget {
  const ConditionTentativePage({super.key});

  static const String routeName =
      '/gpx/generalites/tentative/conditions_tentative';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final Color cardColor = isDark
        ? const Color(0xFF1E1E1E)
        : const Color(0xFFF7F7F7);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF050505);
    final Color textColor = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withOpacity(.90);
    final Color accent = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);

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
          'Conditions de la tentative',
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
          // En-tête
          Text(
            'Les conditions de la tentative',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Pour que la tentative soit retenue, deux conditions doivent être réunies :',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              height: 1.4,
              color: textColor,
            ),
          ),
          const SizedBox(height: 18),

          // Condition A (plus de label)
          _ConditionCard(
            title: 'I. Un commencement d’exécution',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            textColor: textColor,
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Il y a commencement d’exécution lorsque l’acte accompli tend directement au crime ou au délit ; ',
                ),
                TextSpan(
                  text:
                      'c\'est-à-dire lorsque l\'auteur est déjà en action du crime ou du délit tenté.',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ' Il n’existe plus aucun doute sur son intention d’aller jusqu’au bout de son forfait.',
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Dans le cas contraire, si l’acte accompli ne permet pas de déterminer de façon sûre que l’auteur est en ',
                ),
                TextSpan(
                  text: '« action du crime ou du délit »',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
                TextSpan(
                  text:
                      ', il s’agit alors d’un acte préparatoire non punissable.',
                ),
              ]),
              SizedBox(height: 12),
              _ExempleBox(
                title: 'Exemple',
                bodySpans: [
                  TextSpan(
                    text:
                        'Le fait d’acheter un pied de biche avec l’intention de commettre un vol avec effraction ne constitue qu’un acte préparatoire. ',
                  ),
                  TextSpan(
                    text:
                        'L’auteur peut, après l’achat, abandonner son projet délictuel ; ',
                  ),
                  TextSpan(
                    text:
                        'son acte (achat du pied de biche) n’a donc plus aucun lien direct avec l’infraction qu’il projetait de commettre.',
                  ),
                  TextSpan(text: '\n\n'),
                  TextSpan(
                    text:
                        'Mais si l’individu, après avoir fracturé une porte avec ce pied de biche, interrompt son action parce qu’il en est empêché (arrivée inopinée d’un tiers, etc.), ',
                  ),
                  TextSpan(
                    text:
                        'son acte est constitutif d’un commencement d’exécution.',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(
                    text:
                        ' S’il n’en avait pas été empêché, on est en droit de penser qu’il serait allé jusqu’au bout de son forfait, c’est-à-dire voler des objets.',
                  ),
                ],
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        'Les auteurs d’actes préparatoires peuvent être réprimés mais seulement à titre d’infractions distinctes ',
                  ),
                  TextSpan(
                    text:
                        '(par exemple : achat d’une arme de catégorie B avec intention de tuer ; abandon du projet : il y a infraction de détention d’arme prohibée).',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Condition B (plus de label)
          _ConditionCard(
            title: 'II. L’absence de désistement volontaire',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            textColor: textColor,
            children: const [
              _Paragraph(
                'Le désistement volontaire consiste à renoncer de sa propre volonté à la commission de l’infraction.',
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'En cas d’absence de désistement volontaire, la tentative est caractérisée lorsque la commission de l’infraction a été interrompue par une cause étrangère à la volonté de son auteur ',
                ),
                TextSpan(
                  text:
                      'après commencement d’exécution (dans l’exemple précédent : arrivée inopinée d’un tiers).',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ]),
            ],
          ),
        ],
      ),
    );
  }
}

/// ------------------------------------------------------------------
/// CARTE GLOBALE POUR CHAQUE CONDITION
/// ------------------------------------------------------------------
class _ConditionCard extends StatelessWidget {
  const _ConditionCard({
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
            // Titre simple, sans pastille / label
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
/// BLOC NOTA
/// ------------------------------------------------------------------
class _NotaBox extends StatelessWidget {
  const _NotaBox({required this.bodySpans});

  final List<TextSpan> bodySpans;

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
              text: 'NOTA : ',
              style: TextStyle(fontWeight: FontWeight.w900, color: titleColor),
            ),
            ...bodySpans,
          ],
        ),
      ),
    );
  }
}
