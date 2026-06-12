// lib/pa/dps_dpg/cadres_juridiques/controle_identite/controle_identite_chap1_introduction_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaConntroleIdentiteIntroductionGpxSchool extends StatelessWidget {
  const PaConntroleIdentiteIntroductionGpxSchool({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/controle_identite/chapitre1/introduction';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF222222).withValues(alpha: .70);

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
          'Chapitre 1 — Introduction',
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
          // ===================== TITRE PAGE ================================
          Text(
            'Le contrôle d’identité : principes généraux',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Place du contrôle, du relevé et de la vérification d’identité dans les opérations de '
            'police, entre protection des libertés individuelles et nécessité de rechercher les '
            'infractions et de prévenir les atteintes à l’ordre public.',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 18),

          // ===================== BLOC 1 — LOGIQUE GÉNÉRALE =================
          const _SubTitle(
            '1. Un équilibre entre libertés et maintien de l’ordre',
          ),

          const _Paragraph(
            'Les contrôles, les relevés et les vérifications d’identité font partie des opérations '
            'de police tendant à établir l’identité d’une personne. Ils doivent être mis en œuvre '
            'dans le respect d’un équilibre permanent : d’un côté l’exercice des libertés '
            'individuelles, dont l’autorité judiciaire est gardienne, de l’autre la nécessité de '
            'rechercher les infractions et de prévenir les atteintes à l’ordre public.',
          ),
          const SizedBox(height: 10),

          const _IntroBullet(
            text:
                'Le contrôle d’identité n’est jamais une fin en soi : il s’inscrit dans une mission '
                'de prévention, de constatation des infractions ou de protection de l’ordre public.',
          ),
          const _IntroBullet(
            text:
                'Officiers de police judiciaire et agents de police judiciaire doivent en permanence '
                'adapter leurs pratiques pour concilier efficacité opérationnelle et garanties '
                'accordées aux personnes contrôlées.',
          ),
          const SizedBox(height: 18),

          // ========== BLOC 2 — BASE LÉGALE ================================
          const _SubTitle(
            '2. Base légale du contrôle, du relevé et de la vérification',
          ),

          _Paragraph.rich([
            const TextSpan(
              text:
                  'Les conditions juridiques de mise en œuvre de ces opérations, ainsi que leurs '
                  'modalités pratiques d’application, sont prévues par le code de procédure pénale, '
                  'notamment aux ',
            ),
            TextSpan(
              text: 'articles 78-1 à 78-7 du code de procédure pénale',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: isDarkColor(context)
                    ? const Color(0xFFFF5252)
                    : const Color(0xFFD32F2F),
              ),
            ),
            const TextSpan(
              text:
                  '. Ces articles définissent le cadre juridique du contrôle d’identité, du relevé '
                  'd’identité et de la vérification d’identité.',
            ),
          ]),
          const SizedBox(height: 10),

          const _Paragraph.rich([
            TextSpan(
              text:
                  'Ces dispositions sont complétées par celles contenues dans le code de l’entrée '
                  'et du séjour des étrangers et du droit d’asile, qui imposent aux ressortissants '
                  'étrangers de présenter, à la suite d’un contrôle d’identité, les pièces ou '
                  'documents sous le couvert desquels ils sont autorisés à circuler ou à séjourner '
                  'en France. L’officier de police judiciaire doit donc connaître ces règles pour '
                  'adapter son contrôle en présence d’une personne étrangère.',
            ),
          ]),
          const SizedBox(height: 18),

          // ========== BLOC 3 — DÉFINITION DU CONTRÔLE D’IDENTITÉ ==========
          const _SubTitle('3. Définition du contrôle d’identité'),

          const _Paragraph(
            'Le contrôle d’identité est l’opération par laquelle une personne est invitée à '
            'justifier sur le champ de son identité. Il s’agit de la première étape de l’ensemble '
            'des opérations visant à établir l’identité d’un individu.',
          ),
          const SizedBox(height: 10),

          const _Paragraph(
            'Il doit être distingué de la vérification d’identité, qui constitue une deuxième phase '
            'dans l’établissement de l’identité. La vérification intervient lorsque les documents '
            'présentés sont insuffisants, contestés, ou lorsque la personne ne peut ou ne veut pas '
            'justifier de son identité dans le cadre du contrôle initial.',
          ),
          const SizedBox(height: 18),

          // ========== BLOC 4 — SYNTHÈSE PÉDAGOGIQUE =======================
          const _SubTitle('4. À retenir pour la suite du chapitre'),

          const _IntroBullet(
            text:
                'Trois opérations sont à distinguer : le contrôle d’identité, le relevé d’identité et '
                'la vérification d’identité, chacune avec ses conditions propres.',
          ),
          const _IntroBullet(
            text:
                'Le cadre juridique principal se trouve dans les articles 78-1 à 78-7 du code de '
                'procédure pénale, complétés pour les étrangers par le code de l’entrée et du '
                'séjour des étrangers et du droit d’asile.',
          ),
          const _IntroBullet(
            text:
                'Le contrôle d’identité est un acte de police encadré, qui doit toujours respecter '
                'les libertés individuelles et être justifié par la finalité de prévention ou de '
                'recherche d’infractions.',
          ),
        ],
      ),
    );
  }

  // Petit helper interne pour récupérer le thème (utile au TextSpan rouge)
  static bool isDarkColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
}

///////////////////////////////////////////////////////////////////////////////
///                   TES WIDGETS PERSONNALISÉS EXACTS                    ///
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
  const _NotaBox({required this.bodySpans});

  final List<TextSpan> bodySpans;
  final String title = 'NOTA';

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
