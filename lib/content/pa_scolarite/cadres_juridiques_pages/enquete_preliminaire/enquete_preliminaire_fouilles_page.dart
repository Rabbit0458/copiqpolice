import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class PaEnquetePreliminaireFouillesPage extends StatelessWidget {
  const PaEnquetePreliminaireFouillesPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/enquete_preliminaire/actes/fouilles';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final Color cardColor = isDark
? const Color(0xFF1E1E1E)
: const Color(0xFFF7F7F7);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF050505);
    final Color accent = isDark
? const Color(0xFF64B5F6)
: const Color(0xFF1565C0);

    // Couleur spéciale pour les références aux articles de loi (CPP / CP / CSI)
    final Color lawColor = isDark
        ? const Color(0xFFFFD54F)
        : const Color(0xFFD32F2F);

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
          'Les fouilles',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: titleColor,
          ),
        ),
      ),

      // ===================== CONTENU ============================
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        physics: const BouncingScrollPhysics(),
        children: [
          // ---------------------- TITRE --------------------------
          Text(
            '2.3.6 – Les fouilles en enquête préliminaire',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 8),

          // -------------------- INTRO ----------------------------
          const _Paragraph.rich([
            TextSpan(
              text:
                  'Les fouilles constituent des actes particulièrement intrusifs, destinés exclusivement à la recherche d’objets ou d’indices intéressant l’enquête, dans le cadre de l’établissement de la preuve. ',
            ),
            TextSpan(
              text:
                  'En enquête préliminaire, leur mise en œuvre est strictement encadrée afin de concilier efficacité des investigations et protection des libertés individuelles.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ]),
          const SizedBox(height: 10),

          const _IntroBullet(
            text:
                'Deux grandes catégories sont distinguées : la fouille intégrale de la personne gardée à vue et la fouille de véhicule.',
          ),
          const _IntroBullet(
            text:
                'La fouille intégrale est assimilée à une perquisition et suppose un formalisme renforcé.',
          ),
          const _IntroBullet(
            text:
                'La fouille de véhicule, bien que ne portant pas sur un domicile, est également assimilée à une perquisition en raison de l’atteinte portée à la vie privée.',
          ),

          const SizedBox(height: 22),

          // =======================================================
          // 2.3.6 – NOTION GÉNÉRALE
          // =======================================================
          _ConditionCard(
            title: '2.3.6 – Les fouilles',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: const [
              _Paragraph(
                'Les fouilles ont pour finalité la recherche d’objets ou d’indices intéressant l’enquête, dans le cadre de l’établissement de la preuve. '
                'Elles se distinguent des simples palpations de sécurité et des contrôles visuels, car elles impliquent une intrusion plus importante dans la sphère privée.',
              ),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'En enquête préliminaire, ces actes doivent toujours être justifiés par les nécessités de l’enquête et respecter les garanties prévues par le code de procédure pénale, '
                      'en particulier les dispositions relatives aux perquisitions et aux atteintes à la dignité de la personne.',
                ),
              ]),
            ],
          ),

          const SizedBox(height: 22),

          // =======================================================
          // 2.3.6.1 – LA FOUILLE INTÉGRALE
          // =======================================================
          _ConditionCard(
            title: '2.3.6.1 – La fouille intégrale',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'La fouille intégrale consiste exclusivement à la recherche d’objets ou d’indices intéressant l’enquête, dans le cadre de l’établissement de la preuve. Conformément aux dispositions de l’',
                ),
                TextSpan(
                  text: 'article 63-7 du Code de procédure pénale (C.P.P.)',
                  style: TextStyle(
                    color: lawColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(
                  text:
                      ', elle ne peut être pratiquée que sur une personne gardée à vue et réalisée pour les nécessités de l’enquête.',
                ),
              ]),
              const SizedBox(height: 10),

              const _SubTitle('Conditions de recours'),
              const _BulletPoint(
                text:
                    'La personne doit être placée en garde à vue au moment de la fouille.',
              ),
              const _BulletPoint(
                text:
                    'La fouille intégrale est décidée par un officier de police judiciaire (O.P.J.).',
              ),
              const _BulletPoint(
                text:
                    'Il ne peut y être recouru que si un autre moyen de détection moins intrusif (palpation ou moyen électronique) ne peut être mis en œuvre.',
              ),
              const SizedBox(height: 10),

              const _SubTitle('Assimilation à une perquisition'),
              const _Paragraph(
                'Étant assimilée à une perquisition, la fouille intégrale est soumise, dans le cadre d’une enquête préliminaire, '
                'à l’assentiment de la personne concernée, dans les formes et conditions identiques à l’autorisation prévue dans le cadre des perquisitions proprement dites.',
              ),
              const SizedBox(height: 6),
              const _Paragraph(
                'Le respect des heures légales applicables aux perquisitions ne s’applique pas en matière de fouilles de personnes : '
                'une fouille intégrale peut donc être réalisée de jour comme de nuit, dès lors que les autres conditions légales sont réunies.',
              ),
              const SizedBox(height: 10),

              const _SubTitle('Modalités pratiques'),
              const _BulletPoint(
                text:
                    'La fouille intégrale doit être réalisée dans un espace fermé, à l’abri des regards.',
              ),
              const _BulletPoint(
                text:
                    'Elle doit être effectuée par une personne du même sexe que l’individu faisant l’objet de la fouille.',
              ),
              const SizedBox(height: 8),

              const _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        'Le caractère particulièrement intrusif de la fouille intégrale impose de veiller au respect de la dignité de la personne gardée à vue, '
                        'en limitant l’acte à ce qui est strictement nécessaire à la recherche de la preuve.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 22),

          // =======================================================
          // 2.3.6.2 – LA FOUILLE DE VÉHICULE
          // =======================================================
          _ConditionCard(
            title: '2.3.6.2 – La fouille de véhicule',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              const _Paragraph(
                'La fouille de véhicule n’est pas une perquisition au sens strict, les véhicules ne constituant pas un domicile. '
                'Elle consiste néanmoins à rechercher, à l’intérieur d’un véhicule, des objets ou indices utiles à l’enquête.',
              ),
              const SizedBox(height: 8),

              const _SubTitle('Régime juridique'),
              const _BulletPoint(
                text:
                    'La fouille de véhicule n’est pas soumise au respect des heures légales.',
              ),
              const _BulletPoint(
                text:
                    'En enquête préliminaire, compte tenu du caractère non coercitif de cette procédure, la fouille est réalisée en présence de la personne trouvée en possession du véhicule.',
              ),
              const _BulletPoint(
                text:
                    'Elle suppose l’autorisation délivrée par cette personne, dans les formes et conditions identiques à l’autorisation prévue pour les perquisitions (assentiment exprès et écrit).',
              ),
              const SizedBox(height: 10),

              _ExempleBox(
                title: 'Jurisprudence – Assimilation à une perquisition',
                bodySpans: [
                  const TextSpan(
                    text:
                        'La jurisprudence considère qu’un véhicule, sauf s’il est spécialement aménagé à usage d’habitation et effectivement utilisé comme résidence, ne constitue pas un domicile. ',
                  ),
                  const TextSpan(
                    text:
                        'Cependant, la fouille d’un véhicule, par l’intrusion dans l’intimité de la vie privée qu’elle permet, est assimilable à une perquisition. ',
                  ),
                  const TextSpan(
                    text:
                        'Sauf si un texte l’autorise expressément, elle ne peut être effectuée qu’avec l’assentiment du propriétaire ou du conducteur du véhicule, recueilli dans les conditions prescrites par l’',
                  ),
                  TextSpan(
                    text: 'article 76 du Code de procédure pénale (C.P.P.) ',
                    style: TextStyle(
                      color: lawColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const TextSpan(
                    text: '(Cass. crim., 16 janv. 2024, n° 22-87.593).',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              const _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        'En pratique, l’assentiment doit être recueilli de manière claire, libre et éclairée, consigné par écrit dans la procédure, '
                        'et signé par la personne qui autorise la fouille du véhicule.',
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
    final Color color = isDark ? Colors.white : const Color(0xFF0D47A1);

    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: Text(
        text,
        style: GoogleFonts.fustat(
          fontWeight: FontWeight.w700,
          fontSize: 14.5,
          color: color,
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
    final Color bulletColor = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color textColor = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withValues(alpha: .92);

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Icon(Icons.check_rounded, size: 18, color: bulletColor),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.fustat(
                fontSize: 14,
                height: 1.35,
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

class _ExempleBox extends StatelessWidget {
  const _ExempleBox({required this.bodySpans});

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
