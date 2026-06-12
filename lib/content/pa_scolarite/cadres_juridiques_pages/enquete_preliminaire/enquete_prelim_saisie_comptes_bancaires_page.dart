import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaEnquetePrelimSaisieComptesBancairesPage extends StatelessWidget {
  const PaEnquetePrelimSaisieComptesBancairesPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/enquete_preliminaire/actes/saisie_comptes_bancaires';

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
        : const Color(0xFF1F1F1F).withValues(alpha: .90);
    final Color accent = isDark
? const Color(0xFF81C784)
: const Color(0xFF2E7D32);

    // Couleur spécifique pour les articles de loi (CPP / CP / CSI…)
    final Color lawColor = isDark
        ? const Color(0xFF90CAF9)
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
          'Saisie des comptes bancaires',
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
          // ---------------- TITRE GLOBAL ----------------
          Text(
            'La saisie des comptes bancaires',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 8),

          // ---------------- INTRO -----------------------
          Text(
            'Dans le cadre de l’enquête préliminaire, la saisie des comptes bancaires '
            's’inscrit dans la logique de la confiscation de certains biens ou droits '
            'mobiliers incorporels. Elle permet de préserver rapidement des sommes d’argent, '
            'y compris sous forme d’actifs numériques, afin d’éviter leur disparition '
            'avant l’issue de la procédure.',
            textAlign: TextAlign.justify,
            style: GoogleFonts.fustat(
              fontSize: 14,
              height: 1.4,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),

          const SizedBox(height: 20),

          // =====================================================
          // A. CADRE JURIDIQUE ET CONDITIONS
          // =====================================================
          _ConditionCard(
            title: 'A. Cadre juridique de la saisie des comptes bancaires',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              const _Paragraph.rich([
                TextSpan(
                  text:
                      'La saisie des sommes inscrites sur un compte bancaire ou sur un compte '
                      'd’actifs numériques intervient dans le cadre de la procédure de '
                      'confiscation de certains biens ou droits mobiliers incorporels, lorsque :\n',
                ),
              ]),
              const SizedBox(height: 6),
              const _BulletPoint(
                text:
                    'La peine de confiscation est prévue par les textes applicables ;',
              ),
              const _BulletPoint(
                text:
                    'Ou lorsque l’infraction visée est un crime ou un délit puni d’une peine '
                    'd’emprisonnement supérieure à un an.',
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Dans ce cadre, l’officier de police judiciaire peut saisir les sommes : ',
                ),
                const TextSpan(
                  text:
                      'versées sur un compte de dépôt, un compte de paiement ou un compte '
                      'd’actifs numériques (jetons, crypto-actifs) mentionnés à l’',
                ),
                TextSpan(
                  text: 'article L. 54-10-1 du Code monétaire et financier',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: lawColor,
                  ),
                ),
                const TextSpan(text: ', conformément aux dispositions de l’'),
                TextSpan(
                  text: 'article 706-154 du Code de procédure pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: lawColor,
                  ),
                ),
                const TextSpan(text: '.'),
              ]),
            ],
          ),

          const SizedBox(height: 20),

          // =====================================================
          // B. AUTORISATION ET RÉACTIVITÉ DE LA MESURE
          // =====================================================
          _ConditionCard(
            title: 'B. Autorisation par le procureur de la République',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'L’autorisation de procéder à la saisie des comptes bancaires est délivrée ',
                ),
                TextSpan(
                  text: 'par tout moyen par le procureur de la République',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: lawColor,
                  ),
                ),
                const TextSpan(
                  text:
                      '. Cette possibilité donnée au parquet de valider rapidement la mesure '
                      'permet une réactivité maximale et limite le risque de transfert ou de '
                      'dissimulation des fonds avant leur blocage effectif.',
                ),
              ]),
              const SizedBox(height: 10),
              const _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        'La saisie a un caractère conservatoire : elle ne préjuge pas de la décision '
                        'finale de confiscation, mais elle garantit que les sommes resteront '
                        'disponibles pour une éventuelle exécution ultérieure de la peine.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // =====================================================
          // C. CONTRÔLE PAR LE JUGE DES LIBERTÉS ET DE LA DÉTENTION
          // =====================================================
          _ConditionCard(
            title:
                'C. Contrôle du juge des libertés et de la détention (J.L.D.)',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Le contrôle juridictionnel de la saisie est assuré par le juge des libertés '
                      'et de la détention. Saisi par le procureur de la République, le J.L.D. doit se '
                      'prononcer par ',
                ),
                TextSpan(
                  text: 'ordonnance motivée',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ' sur le maintien ou la mainlevée de la saisie dans un délai de dix jours '
                      'à compter de sa réalisation, et ce, même si la juridiction de jugement est déjà saisie.',
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                'Ce contrôle garantit le respect des droits de la défense et du droit de propriété, '
                'tout en préservant l’efficacité des investigations financières et de la future '
                'exécution de la peine de confiscation.',
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

  final String title = 'NOTA';
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
