// lib/gpx_scolarite_pages/cadres_juridiques/mort_inconnue/mort_inconnue_suites_enquete.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color _lawColor = Color(0xFFE53935);

class MortInconnueSuitesEnquetePage extends StatelessWidget {
  const MortInconnueSuitesEnquetePage({super.key});

  static const String routeName =
      '/gpx/cadres_juridiques/mort_inconnue/suites_enquete';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FB);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color accent = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color cardColor = isDark
        ? const Color(0xFF1E1E1E)
        : const Color(0xFFFFFFFF);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bg,
        centerTitle: true,
        leading: IconButton(
          tooltip: 'Retour',
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textMain),
        ),
        title: Text(
          'Mort de cause inconnue',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        children: [
          // ================================================================
          //                           TITRE
          // ================================================================
          Text(
            'Suites de l’enquête\n(article 74 du Code de procédure pénale)',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 22,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          _Paragraph.rich([
            const TextSpan(
              text: 'À l’issue des investigations menées en application de l’',
            ),
            TextSpan(
              text: 'article 74 du Code de procédure pénale',
              style: const TextStyle(
                color: _lawColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            const TextSpan(
              text:
                  ', le procureur de la République dispose de plusieurs options, '
                  'en fonction des résultats de l’enquête concernant les causes de la mort. '
                  'Trois grandes hypothèses sont classiquement envisagées.',
            ),
          ]),
          const SizedBox(height: 18),

          // ================================================================
          // 1. MORT NATURELLE OU VIOLENTE SANS TIERS RESPONSABLE
          // ================================================================
          _ConditionCard(
            title:
                '1. Mort naturelle ou violente sans responsabilité d’un tiers',
            cardColor: cardColor,
            accent: accent,
            titleColor: textMain,
            children: const [
              _SubTitle('Classement de la procédure et inhumation'),
              _Paragraph(
                'Lorsque l’enquête a permis d’établir que la mort, initialement suspecte, '
                'procède en réalité d’une cause naturelle ou d’une mort violente survenue '
                'dans des circonstances ne permettant pas d’envisager la responsabilité '
                'd’un tiers (suicide ou accident imputable à la seule imprudence de la victime), '
                'le cadre de l’',
              ),
            ],
          ),

          // On complète avec un paragraphe riche pour insérer la référence en rouge
          _Paragraph.rich([
            const TextSpan(
              text:
                  'Dans cette situation, le procureur de la République peut décider de ',
            ),
            const TextSpan(
              text: 'classer la procédure',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const TextSpan(
              text:
                  ' et d’autoriser l’inhumation du défunt. Aucune poursuite pénale n’est engagée, '
                  'faute d’infraction imputable à un tiers.',
            ),
          ]),
          const SizedBox(height: 16),

          // ================================================================
          // 2. DOUTES PERSISTANTS SUR LES CAUSES DE LA MORT
          // ================================================================
          _ConditionCard(
            title: '2. Doutes persistants sur les causes de la mort',
            cardColor: cardColor,
            accent: accent,
            titleColor: textMain,
            children: [
              const _SubTitle(
                'Information pour recherche des causes de la mort ou poursuite en préliminaire',
              ),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Lorsque l’enquête diligentée laisse subsister des doutes quant aux causes de la mort, '
                      'le procureur de la République dispose de plusieurs options :',
                ),
              ]),
              const SizedBox(height: 8),
              const _IntroBullet(
                text:
                    'Requérir l’ouverture d’une information pour recherche des causes de la mort.',
              ),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Dans ce cas, le juge d’instruction, saisi sur le fondement de l’',
                ),
                TextSpan(
                  text: 'article 80-4 du Code de procédure pénale',
                  style: const TextStyle(
                    color: _lawColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(
                  text:
                      ', pourra enquêter lui-même ou délivrer une commission rogatoire à un officier '
                      'de police judiciaire territorialement compétent, notamment celui qui a déjà enquêté '
                      'en vertu de l’article 74 du Code de procédure pénale.',
                ),
              ]),
              const SizedBox(height: 10),
              const _IntroBullet(
                text:
                    'Ordonner à l’officier ou à l’agent de police judiciaire ayant enquêté en vertu de l’article 74 du Code de procédure pénale '
                    'de poursuivre les investigations dans les formes de l’enquête préliminaire.',
              ),
              const _Paragraph(
                'Cette bascule en enquête préliminaire intervient à l’issue d’un délai de huit jours. '
                'Elle permet de poursuivre les vérifications dans un cadre procédural plus classique, '
                'tout en continuant à rechercher l’origine exacte du décès.',
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ================================================================
          // 3. CARACTÈRE CRIMINEL OU DÉLICTUEL ÉTABLI
          // ================================================================
          _ConditionCard(
            title: '3. Caractère criminel ou délictuel de l’événement établi',
            cardColor: cardColor,
            accent: accent,
            titleColor: textMain,
            children: [
              _SubTitle(
                'Basculer vers une enquête pénale classique ou une information judiciaire',
              ),
              const _Paragraph(
                'Lorsque l’enquête permet d’établir que la mort a une origine criminelle ou délictuel-le, '
                'la logique change : il ne s’agit plus seulement de rechercher les causes de la mort, '
                'mais d’enquêter sur une infraction pénale et d’en identifier l’auteur ou les coauteurs.',
              ),
              const SizedBox(height: 8),
              const _IntroBullet(
                text:
                    'Le procureur de la République peut autoriser l’officier ou l’agent de police judiciaire '
                    'à poursuivre ses investigations selon le mode du flagrant délit ou dans le cadre de l’enquête préliminaire, '
                    'en fonction des conditions de temps et de lieu et des indices relevés.',
              ),
              _IntroBullet(
                text:
                    'Le procureur de la République peut également ordonner l’ouverture d’une information judiciaire. '
                    'Dans ce cas, le juge d’instruction est saisi des faits et l’',
              ),
            ],
          ),

          _Paragraph.rich([
            const TextSpan(
              text:
                  'En cas d’ouverture d’une information, l’officier de police judiciaire ayant conduit les opérations en vertu de l’',
            ),
            TextSpan(
              text: 'article 74 du Code de procédure pénale',
              style: const TextStyle(
                color: _lawColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            const TextSpan(
              text:
                  ' est contraint de cesser ses investigations dans ce cadre. Il ne pourra intervenir que sur commission rogatoire '
                  'ou instructions spécifiques du juge d’instruction.',
            ),
          ]),
          const SizedBox(height: 18),

          // ================================================================
          // NOTA
          // ================================================================
          const _NotaBox(
            bodySpans: [
              TextSpan(
                text:
                    'Les suites de l’enquête menée sur le fondement de l’article 74 du Code de procédure pénale '
                    'conditionnent tout le reste de la procédure : simple classement avec autorisation d’inhumation, '
                    'ouverture d’une information pour recherche des causes de la mort, poursuite en enquête préliminaire, '
                    'ou encore bascule vers une enquête pour crime ou délit. Pour l’enquêteur, il est essentiel de comprendre '
                    'ces différentes issues afin d’adapter ses actes et ses comptes rendus au procureur de la République.',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
//                        WIDGETS PERSONNALISÉS
////////////////////////////////////////////////////////////////////////////////

class _ConditionCard extends StatelessWidget {
  const _ConditionCard({
    required this.title,
    required this.cardColor,
    required this.accent,
    required this.titleColor,
    required this.children,
  });

  final String title;
  final Color cardColor;
  final Color accent;
  final Color titleColor;
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

class _SubTitle extends StatelessWidget {
  const _SubTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 6),
      child: Text(
        text,
        style: GoogleFonts.fustat(
          fontWeight: FontWeight.w700,
          fontSize: 15.5,
          color: isDark ? Colors.white : const Color(0xFF0D47A1),
        ),
      ),
    );
  }
}

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
        text!,
        textAlign: TextAlign.justify,
        style: GoogleFonts.fustat(
          fontSize: 14,
          height: 1.45,
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
          height: 1.45,
          fontWeight: FontWeight.w500,
          color: color,
        ),
        children: spans!,
      ),
    );
  }
}

class _IntroBullet extends StatelessWidget {
  const _IntroBullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bulletColor = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color textColor = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withOpacity(.92);

    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Icon(
              Icons.arrow_right_rounded,
              size: 18,
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

class _BulletPoint extends StatelessWidget {
  const _BulletPoint({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color iconColor = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_rounded, size: 18, color: iconColor),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.fustat(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.35,
                color: isDark
                    ? Colors.white70
                    : const Color(0xFF1F1F1F).withOpacity(.92),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
        color: bgColor.withOpacity(isDark ? .7 : .95),
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: borderColor, width: 3)),
      ),
      child: RichText(
        textAlign: TextAlign.justify,
        text: TextSpan(
          style: GoogleFonts.fustat(
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
            height: 1.4,
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
