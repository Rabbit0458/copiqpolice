import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaVerificationIdentiteProcedureGpxSchool extends StatelessWidget {
  const PaVerificationIdentiteProcedureGpxSchool({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/controle_identite/chapitre3/obligations_legales_procedure';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF222222).withValues(alpha: .75);

    final Color cardColor = isDark
? const Color(0xFF1E1E1E)
: const Color(0xFFF5F7FF);
    final Color accent = isDark
? const Color(0xFF64B5F6)
: const Color(0xFF1565C0);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF0D47A1);

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
          'Obligations légales de procédure',
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
          // ===================== TITRE PRINCIPAL ===========================
          Text(
            '3.3 — Les obligations légales de procédure',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Garanties procédurales encadrant la vérification d’identité : rôle central de '
            'l’officier de police judiciaire, information de la personne retenue et contrôle '
            'exercé par le procureur de la République afin d’assurer la protection des libertés '
            'individuelles.',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 18),

          // ===================== CARTE CONTENU =============================
          _ConditionCard(
            title: '3.3 — Les obligations légales de procédure',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: const [
              // ---------- 3.3.1 Présentation immédiate ---------------------
              _SubTitle(
                'La présentation immédiate à l’officier de police judiciaire',
              ),
              _Paragraph(
                'Pour assurer la protection des libertés individuelles face à la vérification '
                'd’identité, le législateur a prévu un encadrement précis des formalités '
                'procédurales et un contrôle renforcé du procureur de la République.',
              ),
              _Paragraph(
                'Toute personne soumise à une vérification d’identité doit être présentée '
                'immédiatement à un officier de police judiciaire. En pratique, la personne a '
                'souvent été contrôlée par un agent de police judiciaire qui rend compte à '
                'l’officier de police judiciaire.',
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'S’il s’agit d’un mineur, celui-ci doit être assisté de son représentant légal, '
                      'sauf impossibilité (',
                ),
                TextSpan(
                  text: 'article 78-3, alinéa 2, du code de procédure pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFD32F2F),
                  ),
                ),
                TextSpan(
                  text:
                      '). En pratique, cette impossibilité est fréquente, puisque l’identité du '
                      'mineur n’est pas encore connue au moment du contrôle. L’agent apprécie '
                      'alors son âge à partir de son apparence, dans l’attente de l’établissement '
                      'de son identité réelle.',
                ),
              ]),

              SizedBox(height: 14),

              // ---------- 3.3.2 Information immédiate ----------------------
              _SubTitle('L’information immédiate de la personne retenue'),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Dès sa présentation à l’officier de police judiciaire, la personne qui fait '
                      'l’objet des vérifications doit être informée par celui-ci, ou sous son contrôle '
                      'par un agent de police judiciaire, de son droit de faire aviser le procureur de '
                      'la République de la vérification dont elle fait l’objet (',
                ),
                TextSpan(
                  text: 'article 78-3, alinéa 1, du code de procédure pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFD32F2F),
                  ),
                ),
                TextSpan(text: ').'),
              ]),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Par ailleurs, lorsque la mesure de garde à vue fait suite à une vérification '
                      'd’identité, la personne doit être aussitôt informée de son droit de faire aviser '
                      'le procureur de la République de la mesure dont elle fait l’objet (',
                ),
                TextSpan(
                  text: 'article 78-3, alinéa 10, du code de procédure pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFD32F2F),
                  ),
                ),
                TextSpan(
                  text:
                      '). Cet avis se cumule avec celui déjà prévu dans le cadre de la garde à vue '
                      'par l’',
                ),
                TextSpan(
                  text: 'article 63 du code de procédure pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFD32F2F),
                  ),
                ),
                TextSpan(
                  text:
                      ', de sorte qu’il n’est pas indispensable de le rappeler à nouveau dans le '
                      'procès-verbal de vérification, dès lors qu’il figure dans le procès-verbal de '
                      'garde à vue.',
                ),
              ]),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'S’il s’agit d’un mineur, le procureur de la République doit être obligatoirement '
                      'informé dès le début de la rétention, conformément à l’',
                ),
                TextSpan(
                  text: 'article 78-3, alinéa 2, du code de procédure pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFD32F2F),
                  ),
                ),
                TextSpan(text: '.'),
              ]),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'L’officier de police judiciaire ou l’agent de police judiciaire informe '
                      'également la personne soumise à vérification de son droit de prévenir à tout '
                      'moment sa famille ou toute personne de son choix (',
                ),
                TextSpan(
                  text: 'article 78-3, alinéa 1, du code de procédure pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFD32F2F),
                  ),
                ),
                TextSpan(
                  text:
                      '). Cette disposition permet à l’intéressé de choisir librement une personne '
                      'susceptible d’apporter des indications utiles sur son identité.',
                ),
              ]),
              _Paragraph(
                'Toutefois, cette faculté n’implique pas nécessairement un contact direct entre la '
                'personne retenue et la personne choisie : lorsque des circonstances particulières '
                'l’exigent, l’officier ou l’agent de police judiciaire peut procéder lui-même à cet avis. '
                'La communication légale se limite alors à informer que l’intéressé est retenu pour '
                'vérification d’identité, sans qu’il soit permis de tenir une véritable conversation.',
              ),

              SizedBox(height: 14),

              // ---------- 3.3.3 Contrôle du procureur ----------------------
              _SubTitle('Le contrôle du procureur de la République'),
              _Paragraph.rich([
                TextSpan(text: 'L’'),
                TextSpan(
                  text: 'article 78-1, alinéa 1, du code de procédure pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFD32F2F),
                  ),
                ),
                TextSpan(
                  text:
                      ' prévoit que l’ensemble des opérations relatives à l’établissement de '
                      'l’identité est placé sous le contrôle des autorités judiciaires mentionnées aux '
                      'articles 12 et 13 du même code, c’est-à-dire le procureur de la République, le '
                      'procureur général et la chambre de l’instruction.',
                ),
              ]),
              _Paragraph(
                'En pratique, c’est le procureur de la République qui dispose des moyens concrets '
                'd’exercer ce contrôle. Celui-ci intervient à deux niveaux :',
              ),

              _IntroBullet(text: 'Pendant la durée de la rétention :'),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Le procureur de la République veille au bon déroulement de la détention et '
                      'aux conditions d’utilisation des moyens de l’identité judiciaire. Il peut se rendre '
                      'dans les locaux de police, ordonner un examen médical, ou mettre fin à tout '
                      'moment à la détention (',
                ),
                TextSpan(
                  text: 'article 78-3, alinéa 3, du code de procédure pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFD32F2F),
                  ),
                ),
                TextSpan(text: ').'),
              ]),
              _Paragraph(
                'Pour sécuriser la procédure et prévenir tout risque de contestation ultérieure, '
                'l’officier de police judiciaire peut, après avis et accord du procureur de la '
                'République, requérir un médecin chargé de constater l’état physique de la '
                'personne retenue ou d’apprécier sa capacité à supporter la rétention.',
              ),

              _IntroBullet(text: 'À l’issue de la vérification :'),
              _Paragraph(
                'À la réception du procès-verbal de vérification établi obligatoirement par '
                'l’officier de police judiciaire, le procureur de la République exerce un contrôle '
                'essentiellement juridique sur la régularité de la mesure, le respect des délais, des '
                'droits de la personne et des textes applicables.',
              ),
            ],
          ),
        ],
      ),
    );
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
