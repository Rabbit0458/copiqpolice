import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LeveeDouteAgressionArmeePage extends StatelessWidget {
  const LeveeDouteAgressionArmeePage({super.key});

  static const String routeName =
      '/gpx/intervention/autres/levee-doute-agression-armee';

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
    final Color cardNota = isDark
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
            "Levée de doute lors d’agressions armées",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Réf. vS.08-2018 — Mise à jour : 15/06/2025",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w700,
              fontSize: 13.5,
              color: isDark ? Colors.white70 : const Color(0xFF616161),
            ),
          ),
          const SizedBox(height: 12),

          // ✅ Élément légal en haut (pédagogique, sans inventer d’article)
          _ConditionCard(
            title: "Cadre légal (à compléter selon réquisition / mission)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _NotaBox(
                title: "IMPORTANT",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Le document fourni décrit une méthode opérationnelle. "
                        "Aucun article précis (CP/CPP/CSI) n’est indiqué dans ton texte. "
                        "Ajoute ici les articles internes/notes de service ou références juridiques que tu utilises, "
                        "et je les mettrai en rouge automatiquement.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // 1 - Introduction
          _ConditionCard(
            title: "1 — Introduction",
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "L’intervention des forces de sécurité intérieure, d’initiative ou sur réquisition, "
                "à la suite de détonations ou de signalements de personnes armées, nécessite la mise en œuvre "
                "de précautions particulières.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Dans les établissements à caractère financier ou commercial, la réquisition peut être transmise "
                "via des systèmes d’alarme reliés à des sociétés de gardiennage, de vidéo-protection, ou parfois "
                "directement au service de police le plus proche par un système de communication adapté.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Ces alarmes peuvent être déclenchées volontairement ou de façon intempestive "
                "(fausse manœuvre, coupure de courant, dysfonctionnement du réseau téléphonique, etc.).",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Dans tous les cas, afin de s’assurer de la réalité et de la nature de l’évènement, "
                "les policiers procèdent à une « levée de doute ».",
              ),
              SizedBox(height: 10),
              _SubTitle("La levée de doute peut être effectuée :"),
              _IntroBullet(
                text:
                    "Par l’exploitation de systèmes de communication (sonores et/ou vidéo).",
              ),
              _IntroBullet(
                text: "Par l’envoi d’une ou plusieurs patrouilles de police.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Ce type d’intervention doit impérativement conduire les policiers à faire preuve "
                "d’une grande vigilance et d’une extrême prudence.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // 2 - Définition / objectif
          _ConditionCard(
            title: "2 — La levée de doute (objectif)",
            cardColor: cardMro,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "La levée de doute consiste au recueil d’informations ou à des observations permettant "
                "de confirmer si les policiers sont en présence (ou non) d’une agression armée, "
                "dont le caractère peut être crapuleux ou meurtrier.",
              ),
              SizedBox(height: 12),
              _Paragraph(
                "Pour répondre de manière adaptée aux problématiques liées à la situation et à son évolution, "
                "l’intervention impose de préparer et réaliser l’action selon la méthode de raisonnement opérationnel (MRO).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // MRO (3 phases)
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

          // Discrétion + principes généraux
          _ConditionCard(
            title: "Principes généraux",
            cardColor: cardNota,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Le recueil d’informations participant à la levée de doute nécessite une grande discrétion. "
                "Les policiers en civil peuvent, en la matière, être plus adaptés à la discrétion souhaitée.",
              ),
              const SizedBox(height: 12),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Pour le bon déroulement de l’intervention, il est indispensable de prendre en compte "
                        "les paramètres de sécurité, d’observation, de coordination et de protection balistique.",
                  ),
                ],
              ),
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
              _BulletPoint(
                text:
                    "Passer devant l’établissement avec un véhicule sérigraphié ou banalisé.",
              ),
              _BulletPoint(
                text:
                    "Stationner le véhicule de police à proximité immédiate du lieu d’intervention.",
              ),
              _BulletPoint(
                text:
                    "Approcher les lieux en utilisant les avertisseurs sonores et/ou lumineux.",
              ),
              _BulletPoint(
                text:
                    "Traverser une rue dans l’alignement de l’établissement (présence possible d’un guetteur).",
              ),
              _BulletPoint(
                text:
                    "S’il s’agit d’un établissement, tenter d’y pénétrer (principe : éviter l’entrée).",
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
              _BulletPoint(
                text:
                    "S’équiper des matériels de protection individuels et collectifs.",
              ),
              _BulletPoint(
                text: "Contrôler le personnel, l’armement, le matériel (PAM).",
              ),
              SizedBox(height: 12),
              _SubTitle("Se poster (installer un point d’observation)"),
              _Paragraph(
                "Se poster, c’est s’installer en un point du terrain permettant d’agir efficacement selon les objectifs ci-dessous :",
              ),
            ],
          ),

          const SizedBox(height: 12),

          // V I T A L (Voir / Invisible / Tirer / Abrité / Liaison)
          _ConditionCard(
            title: "Objectifs du dispositif de poste (V.I.T.A.L.)",
            cardColor: cardDo,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _SubTitle("Voir"),
              _Paragraph(
                "Mettre en place un dispositif d’observation permettant :\n"
                "• de signaler toute présence suspecte de véhicules ou de personnes susceptibles d’assurer le guet ;\n"
                "• d’observer les entrées/sorties, les mouvements de panique ;\n"
                "• de déterminer l’ambiance générale (ex. si VMA en cours : la clientèle ne sort pas librement).",
              ),
              SizedBox(height: 10),
              _SubTitle("Invisible (sans être vu)"),
              _Paragraph("Limiter le risque d’être décelé par les agresseurs."),
              SizedBox(height: 10),
              _SubTitle("Tirer"),
              _Paragraph(
                "Être en mesure de riposter instantanément par l’usage des armes.",
              ),
              SizedBox(height: 10),
              _SubTitle("Abrité"),
              _Paragraph(
                "Se positionner dans un endroit assurant une protection balistique réelle.",
              ),
              SizedBox(height: 10),
              _SubTitle("Liaison"),
              _Paragraph(
                "Maintenir un contact permanent au sein du dispositif policier et avec le CIC.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Exception : intervention dans l’établissement
          _ConditionCard(
            title: "Intervention dans l’établissement (exceptionnel)",
            cardColor: cardNota,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "L’intervention des policiers dans l’établissement peut exceptionnellement être envisagée, "
                "notamment lorsque les circonstances liées à la protection des personnes l’exigent, "
                "et que les renseignements, l’équipement et le nombre de policiers le permettent.",
              ),
              const SizedBox(height: 12),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Dans certains cas, des brigades spécialisées connaissant une affaire en cours peuvent également intervenir.",
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
