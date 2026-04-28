import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AgressionArmeeCrapuleuxPage extends StatelessWidget {
  const AgressionArmeeCrapuleuxPage({super.key});

  static const String routeName =
      '/gpx/intervention/autres/agression-armee-crapuleux';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
    final Color cardIntro = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardMro = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardDont = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardDo = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardPost = isDark
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
          "Pratiques pro en intervention",
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
            "Intervention face à une agression armée\nà caractère crapuleux",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Réf. vS.01-2016",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w700,
              fontSize: 13.5,
              color: isDark ? Colors.white70 : const Color(0xFF616161),
            ),
          ),
          const SizedBox(height: 12),

          // ✅ Élément légal en haut (le texte fourni ne donne pas d’article précis)
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
                        "Ton document décrit une doctrine/méthode d’intervention mais ne mentionne pas d’articles précis (CP/CPP/CSI). "
                        "Ajoute ici les articles/références internes que tu veux afficher : je les formaterai en rouge (ex. ",
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

          // Introduction
          _ConditionCard(
            title: "Introduction",
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "L’intervention des forces de police dans le contexte particulièrement dangereux d’une agression armée, "
                "sur réquisition ou de manière inopinée, exige la mise en œuvre de précautions particulières.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Comme pour toute intervention, le policier prépare et réalise son action selon la méthode de raisonnement "
                "opérationnel (MRO).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // MRO
          _ConditionCard(
            title: "Méthode de raisonnement opérationnel (MRO)",
            cardColor: cardMro,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _SubTitle("Les 3 phases chronologiques"),
              _BulletPoint(
                text: "Analyse de la situation : « Que se passe-t-il ? »",
              ),
              _BulletPoint(
                text:
                    "Cadre juridique : « Quel est le cadre légal de l’intervention ? »",
              ),
              _BulletPoint(
                text: "Tactique d’action : « Comment intervenir ? »",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Objectifs suite à levée de doute confirmée
          _ConditionCard(
            title: "Objectifs après confirmation (levée de doute)",
            cardColor: cardMro,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "La levée de doute ayant permis de confirmer une agression armée à caractère crapuleux en cours, "
                "les mesures prises visent à favoriser la prise de renseignements et à prendre les premières mesures de sécurité.",
              ),
              SizedBox(height: 12),
              _SubTitle("Les renseignements servent principalement à :"),
              _IntroBullet(
                text:
                    "Évaluer en temps réel, le plus précisément possible, la dangerosité du (des) auteur(s) et les risques pour les tiers.",
              ),
              _IntroBullet(
                text:
                    "Favoriser une interpellation ultérieure du (des) mis en cause dans des conditions optimales de sécurité.",
              ),
              _IntroBullet(text: "Faciliter l’enquête judiciaire."),
            ],
          ),

          const SizedBox(height: 14),

          // Ce qu'il ne faut pas faire
          _ConditionCard(
            title: "Ce qu’il ne faut pas faire",
            cardColor: cardDont,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _BulletPoint(text: "Tenter de pénétrer dans l’établissement."),
              _BulletPoint(
                text:
                    "Chercher à bloquer le(s) agresseur(s) à l’intérieur, au risque de provoquer une prise d’otages ou un affrontement armé.",
              ),
              _BulletPoint(
                text:
                    "Provoquer l’interpellation du ou des auteur(s) à leur sortie afin d’éviter un affrontement armé sur la voie publique.",
              ),
              _BulletPoint(
                text:
                    "Faire obstacle au départ d’un véhicule dans lequel les auteurs prendraient place pour s’enfuir.",
              ),
              _BulletPoint(
                text:
                    "Faire usage des armes à feu sur un véhicule pour faire cesser la fuite, sauf cas de légitime défense.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Ce qu'il est préconisé de faire
          _ConditionCard(
            title: "Ce qu’il est préconisé de faire",
            cardColor: cardDo,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _BulletPoint(text: "Solliciter du renfort."),
              _BulletPoint(
                text:
                    "Solliciter la présence sur les lieux de l’OPJ territorialement compétent.",
              ),
              _BulletPoint(
                text:
                    "Dans la mesure du possible, interdire toute approche ou passage devant l’établissement depuis le poste d’observation.",
              ),
              SizedBox(height: 10),
              _SubTitle("Alerte CIC immédiate en cas de fuite / sortie"),
              _Paragraph(
                "Aviser instantanément le CIC afin de communiquer les premières informations relatives à :",
              ),
              SizedBox(height: 8),
              _IntroBullet(text: "Leur nombre."),
              _IntroBullet(text: "Leur description physique."),
              _IntroBullet(text: "Leur tenue vestimentaire."),
              _IntroBullet(
                text:
                    "La présence d’arme(s) (nombre, description générique : arme de poing, arme d’épaule, fusil, grenade, etc.).",
              ),
              _IntroBullet(text: "La présence supposée ou avérée d’otage(s)."),
              _IntroBullet(text: "La direction de fuite."),
              _IntroBullet(text: "Le moyen de locomotion utilisé."),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    "Le cas échéant, changer ou multiplier les postes d’observation pour se soustraire à un risque ou favoriser la prise de renseignements.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Différer interpellation
          _ConditionCard(
            title: "Principe tactique — différer l’interpellation",
            cardColor: cardMro,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Différer l’interpellation permet aux services d’investigation, assistés de groupes spécialisés, "
                "d’appréhender les auteurs dans de meilleures conditions de lieu et de temps, avec des risques évalués et contrôlés.",
              ),
              const SizedBox(height: 12),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Objectif : privilégier le renseignement, éviter l’affrontement immédiat et préparer une interpellation "
                        "dans un cadre maîtrisé.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Intervention dans l’établissement (exceptionnel)
          _ConditionCard(
            title: "Intervention dans l’établissement (exceptionnel)",
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "L’intervention des policiers dans l’établissement peut exceptionnellement être envisagée, notamment lorsque :",
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    "Les circonstances liées à la protection des personnes l’exigent.",
              ),
              _BulletPoint(
                text:
                    "Les renseignements disponibles, l’équipement des policiers et leur nombre le permettent.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Dans certaines circonstances et sur instructions de l’autorité désignée, des brigades spécialisées, "
                "entraînées et connaissant l’affaire en cours peuvent également intervenir.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Confrontation inopinée
          _ConditionCard(
            title: "La confrontation inopinée",
            cardColor: cardDont,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Les policiers peuvent être confrontés de manière inopinée à un ou plusieurs auteurs d’une agression armée en cours, "
                "ne permettant pas la mise en œuvre préalable de tous les principes de la levée de doute.",
              ),
              SizedBox(height: 10),
              _SubTitle("Priorité"),
              _Paragraph("Se soustraire à une possible confrontation armée."),
              SizedBox(height: 10),
              _Paragraph(
                "Dès que possible, les policiers chercheront à se poster afin d’appliquer le protocole d’intervention propre à ce type d’évènement.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Dispositions post-événementielles
          _ConditionCard(
            title: "Dispositions post-événementielles",
            cardColor: cardPost,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Après le départ des auteurs, se rendre sur place et prendre les mesures suivantes :",
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    "Sécuriser les lieux (s’assurer de l’absence d’autre(s) auteur(s) sur les lieux).",
              ),
              _BulletPoint(
                text:
                    "Porter secours aux victimes et, le cas échéant, aviser les sapeurs-pompiers.",
              ),
              _BulletPoint(
                text:
                    "Relever les identités des victimes et des témoins et les maintenir sur les lieux jusqu’à l’arrivée de l’OPJ.",
              ),
              _BulletPoint(
                text:
                    "Préserver les traces et indices, notamment d’origine papillaire et/ou biologique (mouchoir, mégot, etc.).",
              ),
              _BulletPoint(
                text:
                    "Prendre les renseignements sur la commission des faits (coups de feu, nombre d’auteurs, mode opératoire précis, etc.).",
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
