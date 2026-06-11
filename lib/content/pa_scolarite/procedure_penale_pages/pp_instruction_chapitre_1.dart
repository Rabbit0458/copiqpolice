import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaPPInstructionCh1Page extends StatelessWidget {
  const PaPPInstructionCh1Page({super.key});

  static const String routeName =
      '/pa/dps_dpg/procedure_penale/pp_instruction_def';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF222222).withValues(alpha: .70);

    final Color cardLight = isDark
        ? const Color(0xFF424242)
        : const Color(0xFFF5F7FB);
    final Color cardAccent = isDark
        ? const Color(0xFF90CAF9)
        : const Color(0xFF1565C0);

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
          "Chapitre 1 – Caractères de l’instruction",
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 26),
        children: [
          // ====================== TITRE PRINCIPAL ===========================
          Text(
            "Chapitre 1 :\nCaractères de la procédure d’instruction",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 22,
              height: 1.2,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),

          Text(
            "L’instruction préparatoire conserve plusieurs traits inspirés du modèle inquisitoire : "
            "elle demeure écrite, secrète et longtemps non contradictoire. Ces caractères ont été "
            "atténués par les réformes successives de la procédure pénale, qui ont accru la place "
            "et les droits des parties.",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),

          const SizedBox(height: 20),

          // ====================== SECTION 1 : CARACTÈRE ÉCRIT ======================
          const _SubTitle("1.1 – Caractère écrit de la procédure"),

          _Paragraph.rich([
            const TextSpan(
              text:
                  "Selon le Code de procédure pénale, tous les actes de l’instruction et les décisions auxquelles ils donnent lieu "
                  "sont consignés dans un dossier unique. Le caractère écrit permet de conserver la trace des actes essentiels et "
                  "d’assurer un contrôle juridictionnel fiable. Ce principe est expressément prévu par ",
            ),
            TextSpan(
              text: "l’Article 81 alinéas 2 et 3 du Code de procédure pénale",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: Colors.red.shade700,
              ),
            ),
            const TextSpan(
              text:
                  ". Les copies ou photocopies du dossier peuvent être réalisées lorsque la transmission est nécessaire, "
                  "notamment pour les besoins de justice.",
            ),
          ]),

          const SizedBox(height: 10),

          const _Paragraph(
            "Ce caractère écrit demeure essentiel, mais s’atténue lors de l’audience devant la chambre de l’instruction, "
            "juridiction du second degré. Le procureur général et les avocats des parties y sont entendus dans un débat essentiellement oral.",
          ),

          const SizedBox(height: 22),

          // ====================== SECTION 2 : SECRET DE L'INSTRUCTION ======================
          const _SubTitle("1.2 – Caractère secret de l’instruction"),

          const _Paragraph.rich([
            TextSpan(
              text:
                  "Le secret de l’instruction constitue un principe fondamental rappelé par ",
            ),
            TextSpan(
              text: "l’Article 11 du Code de procédure pénale",
              style: TextStyle(fontWeight: FontWeight.w900, color: Colors.red),
            ),
            TextSpan(
              text:
                  ". Il garantit l’efficacité de l’enquête et protège la présomption d’innocence ainsi que les libertés individuelles. "
                  "Toute personne concourant à la procédure est tenue à ce secret.",
            ),
          ]),

          const SizedBox(height: 10),

          const _Paragraph.rich([
            TextSpan(
              text:
                  "Cependant, le secret peut être partiellement levé. Par exemple, selon ",
            ),
            TextSpan(
              text: "l’Article 11 alinéa 3 du Code de procédure pénale",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: Colors.redAccent,
              ),
            ),
            TextSpan(
              text:
                  ", le procureur de la République peut communiquer certains éléments afin d’éviter la propagation "
                  "de fausses informations ou pour répondre à un intérêt public impérieux.",
            ),
          ]),

          const SizedBox(height: 10),

          _Paragraph.rich([
            const TextSpan(
              text:
                  "De même, des éléments peuvent être communiqués à des organismes chargés d’enquêtes techniques ou scientifiques "
                  "afin de prévenir des accidents ou d’indemniser des victimes, conformément à ",
            ),
            TextSpan(
              text: "l’Article 11-1 du Code de procédure pénale",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: Colors.red.shade700,
              ),
            ),
            const TextSpan(
              text:
                  ". En revanche, l’instruction reste totalement secrète pour le public, y compris pour les journalistes.",
            ),
          ]),

          const SizedBox(height: 22),

          // ====================== SECTION 3 : NON CONTRADICTION ======================
          const _SubTitle(
            "1.3 – Caractère non contradictoire de l’instruction",
          ),

          const _Paragraph(
            "Traditionnellement, l’instruction est non contradictoire : les parties ne sont pas placées sur un pied d’égalité "
            "et la défense n’accède pas immédiatement au dossier. Ce caractère est cependant largement atténué aujourd’hui.",
          ),

          const _Paragraph(
            "La défense peut assister aux auditions, déposer des demandes d’actes, contester certaines décisions, "
            "former des requêtes en nullité ou demander la clôture de l’instruction. Les parties jouent désormais "
            "un rôle actif tout au long de la procédure.",
          ),

          const _Paragraph(
            "Ce formalisme renforcé permet de concilier la recherche de la vérité et la protection des libertés individuelles. "
            "Les formalités doivent être strictement respectées, sous peine de nullité.",
          ),

          const SizedBox(height: 20),

          const _NotaBox(
            title: "À RETENIR",
            bodySpans: [
              TextSpan(
                text:
                    "Les trois caractères historiques de l’instruction préparatoire (écrit, secret et non contradictoire) demeurent, "
                    "mais de façon atténuée. Les Articles 11, 11-1 et 81 du Code de procédure pénale sont essentiels pour comprendre "
                    "leurs applications modernes.",
              ),
            ],
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
//                   TES WIDGETS PERSONNALISÉS EXACTS                       ///
///////////////////////////////////////////////////////////////////////////////

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
        : const Color(0xFF1F1F1F).withValues(alpha: .92);

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
        : const Color(0xFF1F1F1F).withValues(alpha: .92);

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

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_rounded,
            size: 18,
            color: isDark ? const Color(0xFF64B5F6) : const Color(0xFF1565C0),
          ),
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
                    : const Color(0xFF1F1F1F).withValues(alpha: .92),
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
        color: bgColor.withValues(alpha: isDark ? .7 : .95),
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
