import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TemoignageGeneralitesPage extends StatelessWidget {
  const TemoignageGeneralitesPage({super.key});

  static const String routeName = '/gpx/pv_apj20/temoignage/generalites';

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
    final Color cardGeneral = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardMethod = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardHearing = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardProtect = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);

    final Color accentBlue = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color accentGrey = isDark ? Colors.white70 : const Color(0xFF616161);
    final Color accentGreen = isDark
        ? const Color(0xFF66BB6A)
        : const Color(0xFF2E7D32);
    final Color accentPink = isDark
        ? const Color(0xFFF48FB1)
        : const Color(0xFFC2185B);
    final Color accentAmber = isDark
        ? const Color(0xFFFFCA28)
        : const Color(0xFFF9A825);

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
          "Témoignage",
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
            "Le témoignage",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          _ConditionCard(
            title: "Définition & intérêt",
            cardColor: cardGeneral,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le témoignage constitue un des éléments essentiels de l’enquête policière. "
                "Il peut permettre de déterminer les circonstances de l’affaire, d’orienter les recherches, "
                "quelquefois d’identifier le ou les auteurs.\n\n"
                "Il reste toutefois un mode de preuve précaire.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Partie légale en haut (protection du témoin) : art. 62 / 78 / 706-57 / 706-58 CPP
          _ConditionCard(
            title: "Cadre légal — protection du témoin (à connaître)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(text: "Droit de ne pas être retenu — "),
                TextSpan(
                  text: "art. 62 C.P.P.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : le témoin est entendu sans contrainte ; retenue possible uniquement si nécessaire, "
                      "pour le temps strictement nécessaire, dans la limite de 4 heures (hors comparution libre informée).",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Droit de ne pas déposer — "),
                TextSpan(
                  text: "art. 78 C.P.P.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : les personnes convoquées sont tenues de comparaître, mais ne sont pas tenues de déposer ; "
                      "le refus doit être mentionné au procès-verbal.",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Domiciliation du témoin — "),
                TextSpan(
                  text: "art. 706-57 C.P.P.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : domiciliation possible au commissariat/brigade (sur autorisation PR/JI) ou sur le lieu de travail ; "
                      "registre dédié pour l’adresse personnelle.",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Anonymat — "),
                TextSpan(
                  text: "art. 706-58 C.P.P.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : possible sur autorisation du JLD si l’audition expose gravement le témoin (ou proches) "
                      "et si l’enquête porte sur un crime ou un délit puni d’au moins 3 ans d’emprisonnement.",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "I — Généralités",
            cardColor: cardGeneral,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Toute personne est tenue d’apporter son concours à la justice en vue de la manifestation de la vérité. "
                "Cependant, rares sont les témoins qui se présentent spontanément aux services de police.\n\n"
                "Dès la découverte de l’infraction, l’enquêteur doit les rechercher :",
              ),
              SizedBox(height: 8),
              _IntroBullet(
                text:
                    "en relevant l’identité des témoins présents sur les lieux de l’infraction ;",
              ),
              _IntroBullet(
                text:
                    "en effectuant une enquête de voisinage (le jour même ou les jours suivants) ;",
              ),
              _IntroBullet(text: "par un appel à la presse ;"),
              _IntroBullet(text: "par l’audition des proches."),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "II — L’enquête de voisinage",
            cardColor: cardMethod,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "L’enquête de voisinage est une technique de police judiciaire consistant à rechercher, "
                "près du lieu de l’infraction, des témoins susceptibles de faire progresser l’enquête "
                "en déterminant le déroulement des faits ou en apportant des éléments utiles "
                "(description de l’auteur, présence de personnes, de véhicule…).",
              ),
              SizedBox(height: 10),
              _SubTitle("Objectif : trouver tout témoin pertinent"),
              _BulletPoint(
                text:
                    "Témoin visuel : a vu la commission de l’infraction, l’itinéraire suivi par le ou les auteurs…",
              ),
              _BulletPoint(
                text:
                    "Témoin auditif : a entendu des informations utiles (bruits, cris, échanges, véhicules, etc.).",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "La zone d’enquête est variable : immeuble, quartier, axe de déplacement, parcours… "
                "Le choix appartient au directeur d’enquête.\n\n"
                "Méthode : porte-à-porte, questionnement des personnes présentes, notation des absents, "
                "convocation des témoins intéressants, retours sur place si nécessaire.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "III — L’audition du témoin",
            cardColor: cardHearing,
            accent: accentPink,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "La réception du témoignage doit être réalisée le plus tôt possible afin d’éviter "
                "que les souvenirs se modifient ou s’effacent.\n\n"
                "Le témoin doit être accueilli convenablement : adopter un comportement attentionné, "
                "le rassurer si besoin, et instaurer un climat de confiance.",
              ),
              const SizedBox(height: 10),
              const _SubTitle("Lieu possible de l’audition"),
              const _BulletPoint(text: "Sur les lieux de l’infraction."),
              const _BulletPoint(
                text:
                    "Dans les locaux de police (présentation spontanée ou convocation).",
              ),
              const _BulletPoint(
                text: "Au domicile du témoin ou tout autre lieu (hôpital…).",
              ),
              const SizedBox(height: 10),
              const _SubTitle("Déroulé recommandé"),
              const _Paragraph(
                "1) Récit spontané (libre évocation)\n"
                "Le témoin raconte sans être interrompu : cela permet de situer le témoin dans le temps et l’espace "
                "(date, heure, lieu, circonstances) et de décrire l’événement (vu, entendu, fait).\n\n"
                "2) Récit guidé\n"
                "L’enquêteur demande des précisions (imprécisions, oublis). Les questions doivent être ouvertes "
                "et ne jamais suggérer la réponse. L’enquêteur reste objectif et impartial.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: const [
                  TextSpan(
                    text:
                        "Les expressions du témoin doivent être reproduites telles quelles (guillemets). "
                        "Son opinion peut être mentionnée (ex. « je pense », « je crois », « je suis sûr que… »).",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "IV — Protection du témoin (synthèse pratique)",
            cardColor: cardProtect,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Ne pas être retenu"),
              _Paragraph.rich([
                const TextSpan(text: "Règle : audition sans contrainte — "),
                TextSpan(
                  text: "art. 62 C.P.P.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      ". Retenue possible uniquement si nécessaire, 4h max, sauf comparution libre informée.",
                ),
              ]),
              const SizedBox(height: 12),

              const _SubTitle("B) Ne pas déposer"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Comparution possible sous contrainte, mais pas obligation de déposer — ",
                ),
                TextSpan(
                  text: "art. 78 C.P.P.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text: ". En cas de refus, le mentionner expressément au PV.",
                ),
              ]),
              const SizedBox(height: 12),

              const _SubTitle("C) Domicile élu"),
              _Paragraph.rich([
                const TextSpan(
                  text: "Domiciliation possible (sécurité / travail) — ",
                ),
                TextSpan(
                  text: "art. 706-57 C.P.P.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      ". Adresse personnelle conservée sur registre dédié (papier ou numérique).",
                ),
              ]),
              const SizedBox(height: 12),

              const _SubTitle("D) Anonymat"),
              _Paragraph.rich([
                const TextSpan(text: "Anonymat sur autorisation JLD — "),
                TextSpan(
                  text: "art. 706-58 C.P.P.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " (crime/délit ≥ 3 ans + danger grave). PV anonyme non signé + PV distinct signé (identité/adresse) versé à part.",
                ),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: const [
                  TextSpan(
                    text:
                        "Point clé : la protection vise à garantir la sécurité du témoin tout en conservant la valeur probante "
                        "des déclarations et la traçabilité procédurale.",
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
