import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ViolationCorrespondancesVoieElectroniquePage extends StatelessWidget {
  const ViolationCorrespondancesVoieElectroniquePage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/crime_delit_contre_personne_pages/atteinte_personnalite/violation_correspondances_voie_electronique';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
    final Color cardDef = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardMat = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardMoral = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
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
          "Atteintes à la personnalité",
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
            "La violation des correspondances émises par la voie électronique",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Définition
          _ConditionCard(
            title: "Définition",
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le fait, commis de mauvaise foi, d’intercepter, de détourner, d’utiliser ou de divulguer des correspondances "
                "émises, transmises ou reçues par la voie électronique, ou de procéder à l’installation d’appareils de nature "
                "à permettre la réalisation de telles interceptions, constitue une infraction.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: "I — Élément légal",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: "Article 226-15 alinéa 2 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : définit la violation des correspondances émises par la voie électronique (commise par un particulier).",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 226-15 alinéa 1 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text: " : prévoit la répression de cette infraction.",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel
          _ConditionCard(
            title: "II — Élément matériel",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _SubTitle(
                "A) Des correspondances émises, transmises ou reçues par la voie électronique",
              ),
              const _Paragraph(
                "Le texte protège les correspondances « dématérialisées » (sans support tangible), "
                "par exemple : appels téléphoniques, courrier électronique, messages électroniques.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Il vise les correspondances en cours de transmission ou parvenues à destination mais non encore appréhendées "
                "par leur destinataire. Une fois la correspondance ouverte/prise de connaissance, elle perd ce régime spécifique "
                "et peut relever d’autres qualifications (ex. vol de données copiées, accès/maintien frauduleux dans un STAD).",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "DÉFINITION LÉGALE",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Le courrier électronique est défini comme « tout message, sous forme de texte, de voix, de son ou d’image, "
                        "envoyé par un réseau public de communications, stocké sur un serveur du réseau ou dans l’équipement terminal "
                        "du destinataire, jusqu’à ce que ce dernier le récupère ». — ",
                  ),
                  TextSpan(
                    text:
                        "article 1er de la loi n° 2004-575 du 21 juin 2004 (LCEN)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle("B) Un acte matériel d’atteinte"),
              const _Paragraph(
                "L’infraction est constituée par l’un des actes suivants : intercepter, détourner, utiliser, divulguer "
                "ou installer des appareils permettant ces atteintes.",
              ),
              const SizedBox(height: 10),

              const _SubTitle("1) Intercepter"),
              const _Paragraph(
                "Intercepter consiste à « prendre au passage » ce qui est destiné à autrui, pendant le cours de la transmission, "
                "au moyen d’un matériel quelconque. Il n’est pas nécessaire que l’auteur prenne connaissance du contenu pour que "
                "l’interception soit réprimée.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "JURISPRUDENCE",
                bodySpans: [
                  const TextSpan(
                    text:
                        "L’interception suppose la captation pendant la transmission (",
                  ),
                  TextSpan(
                    text: "Cass. crim., 14 avril 1999",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: ")."),
                ],
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "EXEMPLE",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Interception d’échanges radio entre différentes patrouilles de police (",
                  ),
                  TextSpan(
                    text: "C.A. Paris, 15 septembre 2005",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: ")."),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle("2) Détourner"),
              const _Paragraph(
                "Détourner consiste à modifier le cours de la transmission, notamment par l’installation d’un dispositif permettant "
                "une dérivation de la correspondance vers un point choisi par l’auteur. Le détournement peut viser des messages en attente "
                "d’être lus par le destinataire (ils ne sont plus « en cours de transmission », mais pas encore appréhendés).",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "JURISPRUDENCE",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Détournement retenu à l’encontre d’un employeur accédant aux courriers électroniques d’un salarié "
                        "avant que celui-ci en ait eu connaissance (",
                  ),
                  TextSpan(
                    text: "C.A. Pau, 24 novembre 2005",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: ")."),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle("3) Utiliser"),
              const _Paragraph(
                "Utiliser consiste à se servir de la correspondance comme si l’on en était le destinataire (ex. effacer un courriel "
                "dont on n’est pas destinataire, ou le transférer à un tiers, sans qualité pour en connaître).",
              ),

              const SizedBox(height: 14),

              const _SubTitle("4) Divulguer"),
              const _Paragraph(
                "Divulguer consiste à révéler à un tiers le contenu d’une correspondance qui ne vous est pas destinée. "
                "La divulgation peut faire suite à une interception (ex. faire écouter une conversation enregistrée, transmettre un courriel intercepté).",
              ),

              const SizedBox(height: 14),

              const _SubTitle(
                "5) Installer un dispositif permettant l’interception",
              ),
              const _Paragraph(
                "L’installation consiste à mettre en œuvre un dispositif (matériel ou logiciel) permettant d’intercepter, détourner, "
                "utiliser ou divulguer des correspondances émises par la voie électronique.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Même sans précision légale, la personne réalisant l’installation peut être considérée comme auteur de la violation "
                "du secret des correspondances, y compris si elle agit pour le compte d’un tiers qui recueille les informations interceptées.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Élément moral
          _ConditionCard(
            title: "III — Élément moral",
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "L’infraction suppose la mauvaise foi : l’auteur agit en toute connaissance de cause en violant le secret des correspondances.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "La Cour de cassation définit la « mauvaise foi » comme la connaissance que les correspondances ne lui étaient pas destinées (",
                ),
                TextSpan(
                  text: "Cass. crim., 15 mai 1990",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: ")."),
              ]),
              const SizedBox(height: 10),
              const _NotaBox(
                title: "IMPORTANT",
                bodySpans: [
                  TextSpan(
                    text:
                        "La méprise ou l’erreur ne permet pas de caractériser l’infraction faute d’intention coupable. "
                        "L’intention de nuire n’est pas exigée : le mobile importe peu.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes
          _ConditionCard(
            title: "IV — Circonstances aggravantes",
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: "Article 226-15 alinéa 3 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " :"),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Lorsque les faits sont commis par le conjoint, le concubin ou le partenaire lié à la victime par un pacte civil de solidarité (PACS).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité
          _ConditionCard(
            title: "V — Répression",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              const _SubTitle("Peines encourues — personnes physiques"),

              _Paragraph.rich([
                const TextSpan(text: "Qualification simple : "),
                const TextSpan(
                  text: "1 an d’emprisonnement et 45 000 € d’amende. — ",
                ),
                TextSpan(
                  text: "article 226-15 alinéa 2 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text: "Qualification aggravée (conjoint/concubin/PACS) : ",
                ),
                const TextSpan(
                  text: "2 ans d’emprisonnement et 60 000 € d’amende. — ",
                ),
                TextSpan(
                  text: "article 226-15 alinéa 3 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("Personnes morales"),
              _Paragraph.rich([
                const TextSpan(text: "Responsabilité pénale possible via "),
                TextSpan(
                  text: "l’article 121-2 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " (responsabilité généralisée depuis le 31 décembre 2005, notamment suite à l’article 54 de la loi n° 2004-204 du 9 mars 2004).",
                ),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("Tentative & complicité"),
              const _BulletPoint(text: "Tentative : NON (non punissable)."),
              _Paragraph.rich([
                const TextSpan(text: "Complicité : OUI, conformément à "),
                TextSpan(
                  text: "l’article 121-6 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " et "),
                TextSpan(
                  text: "l’article 121-7 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " (aide et assistance, provocation, instructions données).",
                ),
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
