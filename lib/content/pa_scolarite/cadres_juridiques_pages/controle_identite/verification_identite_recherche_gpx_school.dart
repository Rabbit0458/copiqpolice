import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaVerificationIdentiteRechercheGpxSchool extends StatelessWidget {
  const PaVerificationIdentiteRechercheGpxSchool({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/controle_identite/chapitre3/recherche_identite';

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
          'Recherche de l’identité',
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
            '3.2 — La recherche de l’identité',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Moyens laissés à la personne contrôlée pour établir son identité, opérations de '
            'vérification possibles par l’officier de police judiciaire et recours aux moyens '
            'd’identité judiciaire en dernier ressort.',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 18),

          // ===================== CONTENU PRINCIPAL =========================
          _ConditionCard(
            title: '3.2 — La recherche de l’identité',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: const [
              // ---------- 3.2.1 Fourniture par tout moyen -------------------
              _SubTitle(
                'La fourniture, par tout moyen, des éléments permettant d’établir son identité',
              ),
              _Paragraph(
                'La personne contrôlée est libre de prouver son identité aussi bien par des moyens '
                'écrits (documents d’identité) que par des moyens oraux (témoignages). Toutefois, '
                'ces moyens doivent être suffisamment probants.',
              ),
              _Paragraph(
                'C’est notamment le cas des documents écrits comportant une photographie '
                '(permis de conduire, permis de chasser, passeport, carte d’étudiant, etc.) ou de '
                'toute pièce, même privée, dont l’authenticité est incontestable. Tout autre document '
                'dépourvu de photographie, tel qu’un certificat d’immatriculation de véhicule, ne '
                'constitue qu’un commencement de preuve.',
              ),

              SizedBox(height: 10),

              // ---------- 3.2.2 Opérations de vérification -----------------
              _SubTitle(
                'Mise en œuvre de certaines opérations de vérification (hors empreintes et photographies)',
              ),
              _Paragraph(
                'Les opérations de vérification se résument le plus souvent à accompagner la '
                'personne retenue jusqu’à son domicile pour qu’elle puisse y prendre un document '
                'justificatif, à s’assurer par téléphone de son identité auprès des services de police '
                'ou de gendarmerie compétents lorsqu’elle est domiciliée hors de la compétence '
                'territoriale de l’officier de police judiciaire, ou encore à vérifier qu’elle n’est pas '
                'recherchée par la justice.',
              ),
              _Paragraph(
                'Enfin, après avoir constaté sa totale impossibilité d’obtenir l’identité de la personne, '
                'l’officier de police judiciaire pourra recourir à la vérification technique par les moyens '
                'de l’identité judiciaire.',
              ),
              SizedBox(height: 8),
              _NotaBox(
                title: 'Jurisprudence',
                bodySpans: [
                  TextSpan(
                    text:
                        'Il se déduit des articles 76, 78-2 et 78-3 du code de procédure pénale et de l’article R. 434-16 '
                        'du code de la sécurité intérieure que la palpation de sécurité opérée sur une personne faisant '
                        'l’objet d’un contrôle d’identité n’autorise pas l’officier de police judiciaire à procéder, sans '
                        'l’assentiment de l’intéressé, à la fouille de sa sacoche, dès lors que cette palpation n’a pas '
                        'préalablement révélé l’existence d’un indice de la commission d’une infraction flagrante '
                        '(Cass. crim. n° 14-87.370 du 23 mars 2016).',
                  ),
                ],
              ),

              SizedBox(height: 12),

              // ---------- 3.2.3 Prise d’empreintes / photographies --------
              _SubTitle('La prise d’empreintes ou de photographies'),
              _Paragraph(
                'Cette procédure ne peut être utilisée qu’à deux conditions :',
              ),
              _BulletPoint(
                text:
                    'La personne interpellée maintient son refus de justifier de son identité ou fournit des éléments '
                    'd’identité manifestement inexacts.',
              ),
              _BulletPoint(
                text:
                    'La vérification technique est l’unique moyen d’établir l’identité de la personne.',
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Dans ce cadre, l’officier de police judiciaire doit solliciter l’autorisation d’un magistrat avant '
                      'la réalisation technique permettant d’établir l’identité (',
                ),
                TextSpan(
                  text: 'article 78-3, alinéa 4, du code de procédure pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFD32F2F),
                  ),
                ),
                TextSpan(
                  text:
                      '). Cette autorisation est donnée verbalement ou par écrit soit par le procureur de la '
                      'République (notamment en matière de police administrative), soit par le juge d’instruction '
                      '(uniquement dans le domaine de la police judiciaire).',
                ),
              ]),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'L’officier de police judiciaire doit enfin mentionner et spécialement motiver dans le procès-verbal '
                      'la vérification technique (prise d’empreintes digitales ou de photographies, ou les deux) conformément à l’',
                ),
                TextSpan(
                  text: 'article 78-3, alinéa 5, du code de procédure pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFD32F2F),
                  ),
                ),
                TextSpan(text: '.'),
              ]),

              SizedBox(height: 12),

              // ---------- 3.2.4 Délit de refus ----------------------------
              _SubTitle(
                'Le délit de refus de se prêter aux mesures d’identité judiciaire',
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'La personne qui refuse de se prêter aux prises d’empreintes digitales ou de photographies, '
                      'autorisées par le procureur de la République ou le juge d’instruction, commet un délit passible '
                      'd’une peine d’emprisonnement de 3 mois et d’une amende de 3 750 euros (',
                ),
                TextSpan(
                  text: 'article 78-5 du code de procédure pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFD32F2F),
                  ),
                ),
                TextSpan(text: ').'),
              ]),
              _Paragraph(
                'L’officier de police judiciaire peut, devant un refus persistant au terme du délai de rétention, '
                'constater le flagrant délit et placer son auteur en garde à vue dans le cadre de l’enquête diligentée '
                'pour cette infraction, notamment pour tenter d’établir, avec d’autres moyens, sa véritable identité.',
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
