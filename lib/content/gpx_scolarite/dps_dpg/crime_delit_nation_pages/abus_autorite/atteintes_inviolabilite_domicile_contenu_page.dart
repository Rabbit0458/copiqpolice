import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AtteintesInviolabiliteDomicilePage extends StatelessWidget {
  const AtteintesInviolabiliteDomicilePage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/crime_delit_nation_pages/abus_autorite_particuliers/atteintes_inviolabilite_domicile';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette (lisible + propre)
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
          "Abus d’autorité",
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
            "Les atteintes à l’inviolabilité du domicile",
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
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Constitue une atteinte à l’inviolabilité du domicile le fait, par une personne dépositaire "
                "de l’autorité ou chargée d’une mission de service public, agissant dans l’exercice ou à "
                "l’occasion de l’exercice de ses fonctions ou de sa mission, de s’introduire ou de tenter "
                "de s’introduire dans le domicile d’autrui contre le gré de celui-ci, hors les cas prévus par la loi.",
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
                  text: "Article 432-8 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text: " : l’infraction est prévue et réprimée par ce texte.",
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
              const _SubTitle("A) Un auteur qualifié"),

              const _SubTitle(
                "1) Une personne dépositaire de l’autorité publique",
              ),
              const _Paragraph(
                "Est dépositaire de l’autorité publique celui qui dispose d’un pouvoir de décision "
                "fondé sur une parcelle d’autorité publique que lui confèrent ses fonctions (fonctionnaire, "
                "militaire, magistrat, officier public ou ministériel, etc.).",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Sont notamment concernés : policiers, gendarmes, douaniers, huissiers de justice, "
                "commissaires-priseurs, fonctionnaires des eaux et forêts.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Les responsables des exécutifs locaux (maires, présidents d’intercommunalités, "
                "conseils départementaux et régionaux), ainsi que certains adjoints et conseillers municipaux "
                "délégués, peuvent aussi avoir cette qualité.",
              ),

              const SizedBox(height: 14),

              const _SubTitle(
                "2) Une personne chargée d’une mission de service public",
              ),
              const _Paragraph(
                "Est chargée d’une mission de service public la personne qui accomplit, à titre temporaire "
                "ou permanent, volontairement ou sur réquisition, un service public quelconque : elle "
                "participe à une mission d’intérêt général sans pouvoir de décision ou de commandement.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Les élus locaux qui ne détiennent aucune prérogative de puissance publique par délégation, "
                "ainsi que les parlementaires, peuvent relever de cette catégorie.",
              ),

              const SizedBox(height: 14),

              const _SubTitle(
                "B) Agissant dans l’exercice ou à l’occasion des fonctions / mission",
              ),
              const _Paragraph(
                "L’auteur doit avoir abusé de sa qualité pour pénétrer au domicile. Il doit agir dans le cadre "
                "de ses attributions : sont exclues les intrusions motivées par des raisons personnelles.",
              ),

              const SizedBox(height: 14),

              const _SubTitle("C) Un domicile"),
              const _Paragraph(
                "Le domicile est le lieu où une personne, qu’elle y habite ou non, a le droit de se dire chez elle, "
                "quel que soit le titre juridique d’occupation et l’affectation des locaux. L’idée centrale : "
                "le lieu protège l’intimité.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Cela vise : domicile légal, résidence, lieu de séjour occasionnel, occupation précaire. "
                "La notion peut s’étendre à un logement inoccupé contenant des meubles, si ces éléments "
                "traduisent une occupation effective (ex. table, chaises, lit, canapé, électroménager). "
                "À l’inverse, une simple bicyclette ou un carton de livres ne suffit pas.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Le domicile comprend aussi une habitation avec ses dépendances (caves, terrasses, etc.). "
                        "Cours/jardins/parcs peuvent être assimilés au domicile s’ils sont clos et attenants. ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 26 septembre 1990)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 12),
              const _Paragraph(
                "La jurisprudence exige en pratique un lien étroit et immédiat : la dépendance doit être une annexe "
                "au domicile et se trouver à proximité de l’habitation.",
              ),

              const SizedBox(height: 14),

              const _SubTitle("D) Une introduction (ou tentative) illicite"),
              const _Paragraph(
                "L’acte incriminé est l’introduction ou la tentative d’introduction dans un domicile, quel que soit le moyen, "
                "même sans violence ni artifice. Le maintien dans le domicile n’est pas visé par ce texte.",
              ),
              const SizedBox(height: 12),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Exemple : en enquête préliminaire, l’O.P.J. ayant obtenu une autorisation écrite de perquisition "
                        "ne commet pas ce délit en refusant de quitter les lieux si la personne « retire » ensuite son autorisation "
                        "(dans certaines hypothèses analysées).",
                  ),
                ],
              ),
              const SizedBox(height: 12),

              const _SubTitle("Jurisprudences (illustrations)"),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Des policiers se rendent dans le hall d’un hôtel et demandent par téléphone à l’occupant d’une chambre "
                        "de les rejoindre : pas de pénétration dans un domicile. ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 06 avril 1993)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Des gendarmes se placent au seuil d’un garage ouvert par l’agent immobilier et photographient des véhicules "
                        "sans pénétrer : pas d’introduction dans un domicile. ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 29 mars 1994)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle("E) Contre le gré de l’occupant"),
              const _Paragraph(
                "L’infraction suppose une introduction contre le gré de l’occupant. Si l’agent pénètre avec le consentement, "
                "l’infraction n’est pas constituée.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Des agents entrent chez les parents d’un conducteur venant de causer un accident et présentant des signes d’ivresse, "
                        "avec l’accord des parents : délit non constitué. ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 28 juin 1990)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Attention : le consentement ne doit pas être vicié par des manœuvres ou « stratagèmes policiers ». ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 27 février 1996)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle("F) Hors les cas prévus par la loi"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Certains textes permettent de pénétrer dans le domicile au nom d’intérêts supérieurs : une introduction peut être régulière "
                      "si elle respecte strictement les conditions légales. ",
                ),
                TextSpan(
                  text: "(Cass. crim., 12 mai 1992)",
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
                        "Toute introduction en vue de constater une infraction peut constituer une visite domiciliaire irrégulière si opérée "
                        "hors les heures légales. ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 03 juin 1991)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "L’article 432-8 du Code pénal sanctionne le non-respect des conditions de fond des interventions, "
                "et non les actes accessoires qui peuvent accompagner l’intervention.",
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
            children: const [
              _SubTitle("A) Conscience de pénétrer irrégulièrement"),
              _Paragraph(
                "L’auteur doit avoir conscience de l’irrégularité de ses agissements : il sait qu’il pénètre (ou tente de pénétrer) "
                "dans le domicile d’autrui en dehors des conditions légales.",
              ),
              SizedBox(height: 12),
              _SubTitle("B) Volonté de passer outre le consentement"),
              _Paragraph(
                "Il doit exister la volonté de passer outre l’absence de consentement (ou l’opposition) de l’occupant.",
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
            children: const [
              _Paragraph(
                "Aucune circonstance aggravante n’est prévue pour cette infraction.",
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
                const TextSpan(text: "Délit — "),
                const TextSpan(
                  text: "2 ans d’emprisonnement et 30 000 € d’amende — ",
                ),
                TextSpan(
                  text: "article 432-8 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("Personnes morales"),
              const _Paragraph(
                "Les personnes morales peuvent être reconnues responsables pénalement (selon les règles générales de responsabilité).",
              ),

              const SizedBox(height: 12),

              const _SubTitle("Tentative & complicité"),
              _Paragraph.rich([
                const TextSpan(text: "Tentative : "),
                const TextSpan(
                  text: "OUI. ",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: "L’article 432-8 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " incrimine spécifiquement la tentative de violation de domicile par une personne dépositaire de l’autorité publique ou chargée d’une mission de service public.",
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Complicité : "),
                const TextSpan(
                  text: "OUI, ",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: "conformément aux "),
                TextSpan(
                  text: "articles 121-6",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " et "),
                TextSpan(
                  text: "121-7 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text: " (aide/assistance, provocation, instructions…).",
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
