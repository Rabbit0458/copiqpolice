import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HorsServiceAmarisPage extends StatelessWidget {
  const HorsServiceAmarisPage({super.key});

  static const String routeName =
      '/gpx/institution/deontologie/hors_service_amaris';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardMat = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardAggr = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardRep = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);

    final Color accentBlue = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color accentGreen = isDark
        ? const Color(0xFF66BB6A)
        : const Color(0xFF2E7D32);
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
          "Déontologie",
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
            "Policier hors service : dois-je intervenir et comment ?",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Contexte AMARIS
          _ConditionCard(
            title: "Mémo AMARIS — repères",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "L’obligation d’intervention, d’assistance et de protection d’un policier perdure au-delà du temps de travail. "
                "Elle va plus loin que la simple obligation d’assistance à personne en péril.\n\n"
                "Objectif : intervenir avec discernement, en garantissant la sécurité (la sienne et celle des tiers).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut (références + idée-force)
          _ConditionCard(
            title: "Référence & principe",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Le devoir d’intervenir hors service est prévu par les textes : ",
                ),
                TextSpan(
                  text: "Code de la sécurité intérieure (CSI)",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: ", "),
                TextSpan(
                  text: "Règlement général d’emploi (RGEPN)",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Hors service, intervenir ne veut pas dire « se mettre en danger » : l’obligation d’agir s’exerce avec discernement et adaptation au contexte.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Quand suis-je obligé d’intervenir ?
          _ConditionCard(
            title: "Quand suis-je obligé d’intervenir ?",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _SubTitle("Situations typiques"),
              _BulletPoint(text: "Quand des personnes sont en péril."),
              _BulletPoint(
                text:
                    "Quand des infractions sont commises contre des personnes ou des biens.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Le devoir d’intervenir s’exerce de sa propre initiative ou si vous êtes requis : "
                "porter aide à toute personne en danger et faire cesser (ou contribuer à faire cesser) les infractions.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Comment intervenir ?
          _ConditionCard(
            title: "Comment intervenir (concrètement) ?",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _SubTitle("Deux options, selon le contexte"),
              _IntroBullet(
                text:
                    "Intervenir personnellement (action directe), si c’est pertinent et sécurisé.",
              ),
              _IntroBullet(
                text:
                    "Solliciter une patrouille / des renforts et/ou les secours.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Vous adaptez votre réponse à l’urgence, au contexte et aux moyens dont vous disposez. "
                "Hors service, vous n’avez pas le même soutien humain et logistique qu’en service (et vous pouvez être avec votre famille).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Sécurité / discernement
          _ConditionCard(
            title: "Sécurité & discernement",
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _SubTitle("Règle d’or"),
              _Paragraph(
                "L’obligation d’agir ne signifie pas prendre un risque inconsidéré. "
                "Hors service, plus encore qu’en service, l’intervention doit rester proportionnée et réaliste.",
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    "J’évalue la situation (danger immédiat, nombre d’auteurs, armes, environnement, présence de proches…).",
              ),
              _BulletPoint(
                text:
                    "Je choisis l’action la plus utile et la plus sûre, au vu de l’urgence et du contexte.",
              ),
              _BulletPoint(
                text:
                    "Si je ne peux pas agir directement, je fais intervenir ceux qui le peuvent (forces / secours).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Si je n’interviens pas moi-même : procédure
          _ConditionCard(
            title: "Si je n’interviens pas moi-même",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _SubTitle("Je déclenche l’intervention"),
              _BulletPoint(text: "J’appelle le 17."),
              _BulletPoint(
                text:
                    "Je décline ma qualité (policier) et je donne un maximum de renseignements.",
              ),
              _BulletPoint(
                text:
                    "Je décris précisément ce que j’ai observé (faits, lieux, descriptions, direction de fuite, danger…).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // En présence d’autres services intervenants
          _ConditionCard(
            title: "Si d’autres services interviennent",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _SubTitle("Éviter la confusion"),
              _BulletPoint(
                text: "Je m’identifie au plus vite et/ou je suis identifiable.",
              ),
              _BulletPoint(
                text: "Je me mets à disposition des effectifs intervenants.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Arme / carte / brassard / RIO
          _ConditionCard(
            title: "Règles générales de sécurité",
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Intervenir hors service, c’est aussi respecter les règles générales de sécurité.",
              ),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Si je porte mon arme : je détiens en permanence ma carte professionnelle.",
              ),
              const _BulletPoint(
                text:
                    "Je détiens un brassard Police supportant mon numéro RIO.",
              ),
              const _BulletPoint(
                text:
                    "J’applique les mêmes règles générales de sécurité que lorsque je suis en service.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Point clé : être identifiable et ne pas créer de confusion lors de l’arrivée des effectifs.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Résumé “mémo”
          _ConditionCard(
            title: "En résumé",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _BulletPoint(
                text:
                    "Intervenir, c’est signaler une infraction commise ou se commettant.",
              ),
              _BulletPoint(
                text:
                    "C’est agir directement ou solliciter une patrouille et/ou les secours.",
              ),
              _BulletPoint(
                text:
                    "Hors service, intervenir ne veut pas dire prendre des risques inconsidérés.",
              ),
              _BulletPoint(
                text:
                    "J’interviens avec discernement : que puis-je faire de mieux, au vu de l’urgence et du contexte ?",
              ),
              _BulletPoint(
                text:
                    "Si nécessaire : je reste à disposition des effectifs locaux et je rends compte à ma hiérarchie.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Attention fiche
          _ConditionCard(
            title: "Attention",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _NotaBox(
                title: "INFORMATION",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Cette fiche ne comporte pas de prescriptions contraignantes ou exclusives : elle apporte un éclairage et une aide dans l’accomplissement des activités professionnelles.",
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Source : fiches AMARIS (mise à jour "),
                TextSpan(
                  text: "13/03/2025",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: ")."),
              ]),
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
