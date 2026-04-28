import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PlanVigipiratePage extends StatelessWidget {
  const PlanVigipiratePage({super.key});

  static const String routeName = '/gpx/intervention/autres/plan-vigipirate';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardIntro = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardPillars = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardActors = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardLevels = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardTable = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);

    final Color accentBlue = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color accentGreen = isDark
        ? const Color(0xFF66BB6A)
        : const Color(0xFF2E7D32);
    final Color accentPink = isDark
        ? const Color(0xFFF48FB1)
        : const Color(0xFFC2185B);
    final Color accentAmber = isDark
        ? const Color(0xFFFFCA28)
        : const Color(0xFFF9A825);
    final Color accentGrey = isDark ? Colors.white70 : const Color(0xFF616161);

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
          "Police en intervention",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
        children: [
          Text(
            "Le plan Vigipirate",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Mis à jour le 15/06/2025",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w700,
              fontSize: 13.5,
              color: isDark ? Colors.white70 : const Color(0xFF616161),
            ),
          ),
          const SizedBox(height: 12),

          // ✅ Élément légal en haut (le texte ne donne pas d’article précis CP/CPP/CSI)
          _ConditionCard(
            title: "Cadre légal (à compléter)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _NotaBox(
                title: "IMPORTANT",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Le texte fourni décrit le plan Vigipirate (plan gouvernemental relevant du Premier ministre) "
                        "mais ne mentionne pas d’articles précis (CP/CPP/CSI). "
                        "Si tu veux un article en rouge ici, envoie-moi la référence exacte et je l’intègre (ex. ",
                  ),
                  TextSpan(
                    text: "Article 123 du Code de procédure pénale",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: ")."),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Intro
          _ConditionCard(
            title: "Introduction",
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le plan Vigipirate est un plan gouvernemental qui relève du Premier ministre. "
                "Outil central de lutte contre le terrorisme, son dispositif permanent de vigilance, de prévention et de protection "
                "associe l’ensemble des acteurs du pays : collectivités territoriales, opérateurs susceptibles de concourir à la protection "
                "et à la vigilance, ainsi que les citoyens.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Il est alimenté par les services de renseignement et repose sur un socle permanent "
                "s’appliquant aux grands domaines d’activité de la société (transports, santé, réseaux d’énergie, alimentation, etc.).",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "En cas d’évolution de la menace terroriste et des vulnérabilités, des mesures additionnelles adaptatives "
                "peuvent être activées, mobilisant les différents acteurs concernés.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // I - Principes & objectifs
          _ConditionCard(
            title: "I — Principes & objectifs",
            cardColor: cardPillars,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _SubTitle("Les 3 piliers"),
              _IntroBullet(
                text:
                    "Vigilance : liée à la connaissance de la menace terroriste et à sa juste prise en compte afin d’ajuster les comportements et les mesures de protection.",
              ),
              _IntroBullet(
                text:
                    "Prévention : s’appuie sur la sensibilisation des agents de l’État, des opérateurs et des citoyens, la connaissance du dispositif national et la préparation des moyens de protection et de réponse.",
              ),
              _IntroBullet(
                text:
                    "Protection : repose sur un éventail de mesures adaptables en permanence pour réduire les vulnérabilités sans contraintes disproportionnées sur la vie économique et sociale.",
              ),
              SizedBox(height: 12),
              _SubTitle("Les 3 démarches de mise en œuvre"),
              _BulletPoint(
                text:
                    "Évaluer la menace terroriste en France et à l’encontre des ressortissants/intérêts français à l’étranger.",
              ),
              _BulletPoint(
                text:
                    "Connaître les vulnérabilités des principales cibles potentielles afin de les réduire et limiter préventivement les effets d’une attaque.",
              ),
              _BulletPoint(
                text:
                    "Adapter la posture Vigipirate en déterminant un dispositif de sécurité répondant au niveau de risque.",
              ),
              SizedBox(height: 12),
              _SubTitle("Les 3 grands objectifs"),
              _BulletPoint(
                text:
                    "Développer une culture de la sécurité au sein de la société.",
              ),
              _BulletPoint(
                text: "Créer des niveaux mieux adaptés à la menace.",
              ),
              _BulletPoint(
                text:
                    "Mettre en œuvre de nouvelles mesures découlant des dernières évolutions législatives.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // II - Acteurs
          _ConditionCard(
            title: "II — Acteurs de la sécurité nationale",
            cardColor: cardActors,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _SubTitle("L’État"),
              _Paragraph(
                "Le Premier ministre décide la mise en œuvre des dispositions et mesures prévues par le plan. "
                "Le ministre de l’Intérieur veille à la bonne exécution opérationnelle sur l’ensemble du territoire. "
                "Chaque ministre met en œuvre les consignes appropriées dans son domaine.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Au niveau local, les préfets de département, sous la coordination des préfets de zone de défense et de sécurité, "
                "veillent à l’information des acteurs publics/privés et à la cohérence de la mise en œuvre des mesures dans les territoires.",
              ),
              SizedBox(height: 12),
              _SubTitle("Collectivités territoriales"),
              _Paragraph(
                "Elles agissent pour la protection de leurs installations, infrastructures et réseaux, la continuité des services publics, "
                "la protection de leurs agents, et la sécurité des rassemblements culturels, sportifs ou festifs.",
              ),
              SizedBox(height: 12),
              _SubTitle("Entreprises"),
              _Paragraph(
                "Toutes les entreprises publiques et privées doivent veiller à leur propre sécurité et, éventuellement, "
                "à celle des personnes qu’elles accueillent.",
              ),
              SizedBox(height: 12),
              _SubTitle("Citoyens"),
              _Paragraph(
                "Par un comportement responsable, chaque citoyen contribue à la vigilance, à la prévention et à la protection "
                "de la collectivité contre les menaces terroristes. Le plan public Vigipirate familiarise les citoyens avec "
                "les comportements à adopter.",
              ),
              SizedBox(height: 12),
              _SubTitle("Acteurs à l’étranger"),
              _Paragraph(
                "À l’étranger, la sécurité des ressortissants français relève d’abord de l’État où ils se trouvent. "
                "Néanmoins, tout opérateur ou entreprise a l’obligation d’assurer la sécurité de ses employés.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // III - Niveaux d'alerte
          _ConditionCard(
            title: "III — Les 3 niveaux d’alerte",
            cardColor: cardLevels,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _SubTitle("1) Vigilance"),
              _Paragraph(
                "Correspond à la posture permanente de sécurité. "
                "Peut être renforcé temporairement, géographiquement et sectoriellement pour faire face à une menace particulière "
                "ou une vulnérabilité ponctuelle.",
              ),
              SizedBox(height: 10),
              _SubTitle("2) Sécurité renforcée — Risque attentat"),
              _Paragraph(
                "Traduit la réponse de l’État à un niveau élevé de menace terroriste. "
                "Peut concerner l’ensemble du territoire ou être ciblé sur une zone géographique ou un secteur d’activité. "
                "N’a pas de limite de temps définie.",
              ),
              SizedBox(height: 10),
              _SubTitle("3) Urgence attentat"),
              _Paragraph(
                "Déclenche un état de vigilance et de protection maximal : "
                "soit en cas de menace d’attaque terroriste documentée et imminente, "
                "soit immédiatement après un attentat.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // IV - Tableau récap
          _ConditionCard(
            title: "IV — Tableau récapitulatif (synthèse)",
            cardColor: cardTable,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _SubTitle("Vigilance"),
              _BulletPoint(text: "Principe : posture permanente de sécurité."),
              _BulletPoint(
                text: "Conditions : valable en tout lieu et en tout temps.",
              ),
              _BulletPoint(
                text:
                    "Mesures : mise en œuvre de la totalité des mesures permanentes.",
              ),
              SizedBox(height: 12),
              _SubTitle("Sécurité renforcée — Risque attentat"),
              _BulletPoint(
                text:
                    "Principe : réponse à un niveau élevé de menace terroriste.",
              ),
              _BulletPoint(
                text:
                    "Conditions : peut concerner tout le territoire ou une zone/secteur ciblé, sans limite de temps définie.",
              ),
              _BulletPoint(
                text:
                    "Mesures : renforcement des mesures permanentes + activation de mesures additionnelles.",
              ),
              SizedBox(height: 12),
              _SubTitle("Urgence attentat"),
              _BulletPoint(
                text:
                    "Principe : posture maximale de vigilance et de protection.",
              ),
              _BulletPoint(
                text:
                    "Conditions : menace documentée et imminente ou suite immédiate d’un attentat.",
              ),
              _BulletPoint(
                text:
                    "Mesures : activation des mesures les plus contraignantes et mobilisation maximale des acteurs.",
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
