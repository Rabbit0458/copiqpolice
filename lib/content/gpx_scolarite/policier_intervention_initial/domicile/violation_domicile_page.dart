import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ViolationDomicilePage extends StatelessWidget {
  const ViolationDomicilePage({super.key});

  static const String routeName =
      '/gpx/intervention/domicile/violation-domicile';

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
          "Domicile",
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
            "La violation de domicile",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // ✅ Élément légal en haut (articles en rouge)
          _ConditionCard(
            title: "I — Élément légal (textes d’incrimination)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: "Article 226-4 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : définit et réprime la violation de domicile commise par un particulier (introduction ou maintien).",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 432-8 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : prévoit et réprime l’introduction (ou la tentative) dans le domicile d’autrui contre le gré de l’habitant, lorsqu’elle est commise par une personne dépositaire de l’autorité publique / chargée d’une mission de service public, hors les cas prévus par la loi.",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Notion de domicile
          _ConditionCard(
            title: "II — La notion de domicile",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Le domicile est l’endroit où une personne a le droit de se dire chez elle, qu’elle y habite ou non, quel que soit le titre juridique d’occupation et l’affectation des locaux. ",
                ),
                TextSpan(
                  text: "Article 226-4 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "La protection vise aussi bien le domicile « légal » que la résidence, un lieu de séjour occasionnel, "
                "et peut concerner un lieu occupé à titre de propriétaire ou d’occupant précaire, à condition que le lieu protège l’intimité.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "La notion peut s’étendre à des logements inoccupés contenant des meubles (ex. table, chaises, lit, canapé, électroménager…).",
              ),
              const SizedBox(height: 12),
              _NotaBox(
                bodySpans: const [
                  TextSpan(
                    text:
                        "Jurisprudence : la chambre criminelle développe aussi l’idée de « lieu normalement clos » : un lieu non constitutif d’un domicile n’est pas pour autant libre d’accès pour l’agent, s’il est normalement clos et protège une sphère privée.",
                  ),
                ],
              ),
              const SizedBox(height: 14),

              const _SubTitle("Exemples : constituent un domicile"),
              const _IntroBullet(text: "Appartement loué."),
              const _IntroBullet(
                text:
                    "Maison de campagne / vacances, demeure temporairement inoccupée.",
              ),
              const _IntroBullet(
                text:
                    "Dépendances prolongeant l’habitation (débarras, garage, balcon/terrasse, remise…), dans l’enceinte ou à proximité immédiate.",
              ),
              const _IntroBullet(
                text: "Box fermé non attenant / garage en parking souterrain.",
              ),
              const _IntroBullet(
                text: "Logement occupé sans titre mais pacifiquement.",
              ),
              const _IntroBullet(text: "Chambre d’hôtel."),
              const _IntroBullet(
                text:
                    "Locaux professionnels : protégés sauf lorsqu’ils sont ouverts au public pendant les heures d’ouverture.",
              ),
              const _IntroBullet(
                text: "Véhicule réellement aménagé pour l’habitation.",
              ),
              const _IntroBullet(text: "Caravane, roulotte, tente."),
              const _IntroBullet(
                text: "Yacht/voilier/péniche (navire habitable).",
              ),

              const SizedBox(height: 14),

              const _SubTitle("Exemples : ne constituent pas un domicile"),
              const _IntroBullet(
                text: "Logement vide de meubles entre deux locations.",
              ),
              const _IntroBullet(
                text: "Immeuble en construction, immeuble neuf jamais occupé.",
              ),
              const _IntroBullet(text: "Immeuble en cours de démolition."),
              const _IntroBullet(text: "Véhicule non aménagé."),
            ],
          ),

          const SizedBox(height: 14),

          // Violation de domicile - Particulier
          _ConditionCard(
            title: "III — Violation de domicile par un particulier",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: "Article 226-4 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : l’introduction (ou le maintien) dans le domicile d’autrui, par manœuvres/menaces/voies de fait/contrainte, hors les cas où la loi le permet, est punie de ",
                ),
                const TextSpan(
                  text: "3 ans d’emprisonnement et 45 000 € d’amende",
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 12),

              const _SubTitle("A) Élément matériel"),
              const _Paragraph(
                "Deux comportements sont réprimés :\n"
                "• L’introduction frauduleuse dans le domicile d’autrui.\n"
                "• Le maintien dans le domicile d’autrui après une introduction réalisée dans ces conditions.",
              ),
              const SizedBox(height: 10),

              _NotaBox(
                title: "Introduction",
                bodySpans: [
                  const TextSpan(
                    text: "Entrer illicitement dans un domicile, ",
                  ),
                  const TextSpan(text: "à l’aide de "),
                  const TextSpan(
                    text: "manœuvres, menaces, voies de fait ou contrainte",
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  const TextSpan(
                    text:
                        " (ruse, violences, escalade, fausses clés, effraction…), ",
                  ),
                  const TextSpan(text: "en dehors des cas prévus par la loi "),
                  const TextSpan(text: "et contre le gré de l’occupant."),
                ],
              ),
              const SizedBox(height: 10),

              _NotaBox(
                title: "Maintien",
                bodySpans: const [
                  TextSpan(
                    text:
                        "Rester dans le domicile d’autrui après une introduction réalisée par manœuvres/menaces/voies de fait/contrainte. "
                        "Le maintien n’exige pas en lui-même de nouvelles manœuvres : il suffit qu’il fasse suite à l’introduction initiale.",
                  ),
                ],
              ),
              const SizedBox(height: 12),

              const _SubTitle("B) Hors les cas où la loi le permet"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Exemples cités : obligation de porter secours / empêcher la commission d’un crime ou délit contre une personne — ",
                ),
                TextSpan(
                  text: "article 223-6 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 12),

              const _SubTitle("C) Élément moral"),
              const _Paragraph(
                "L’auteur doit avoir :\n"
                "• conscience de commettre un acte illicite ;\n"
                "• la volonté de pénétrer ou de se maintenir dans le domicile d’autrui malgré l’opposition de l’occupant, ou à son insu.",
              ),
              const SizedBox(height: 12),

              _NotaBox(
                bodySpans: const [
                  TextSpan(
                    text:
                        "Infraction continue : la violation de domicile permet d’agir dans le cadre d’une enquête de flagrance tant que l’occupation illicite perdure.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes (nota racisme etc)
          _ConditionCard(
            title: "IV — Circonstances aggravantes (NOTA)",
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Lorsque le délit est commis pour des raisons liées au racisme, à la xénophobie, à la religion, "
                "au sexisme, à l’orientation sexuelle ou à l’identité de genre, le maximum de la peine privative de liberté encourue est relevé.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Conformément aux "),
                TextSpan(
                  text: "articles 132-76 et 132-77 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité (particulier)
          _ConditionCard(
            title: "V — Répression (particulier)",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              const _SubTitle("Peines — infraction simple"),
              _Paragraph.rich([
                const TextSpan(text: "Peines : "),
                const TextSpan(
                  text: "3 ans d’emprisonnement et 45 000 € d’amende. — ",
                ),
                TextSpan(
                  text: "article 226-4 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),
              const SizedBox(height: 12),

              const _SubTitle("Tentative & complicité"),
              const _BulletPoint(text: "Tentative : OUI."),
              const _BulletPoint(text: "Complicité : OUI."),
            ],
          ),

          const SizedBox(height: 14),

          // Violation de domicile - Fonctionnaire (DAP / MSP)
          _ConditionCard(
            title: "VI — Violation de domicile par un « fonctionnaire »",
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Le terme « fonctionnaire » est entendu largement : personne dépositaire de l’autorité publique "
                "(ex. policier actif, policier adjoint) ou chargée d’une mission de service public (ex. sapeur-pompier), "
                "agissant dans l’exercice ou à l’occasion de l’exercice de ses fonctions/mission.",
              ),
              const SizedBox(height: 12),

              const _SubTitle("A) Élément matériel"),
              const _BulletPoint(
                text:
                    "Introduction (ou tentative d’introduction) dans le domicile d’autrui : le simple franchissement du seuil peut suffire.",
              ),
              const _BulletPoint(
                text:
                    "Commis par une personne dépositaire de l’autorité publique ou chargée d’une mission de service public.",
              ),
              const _BulletPoint(
                text:
                    "Contre le gré de l’habitant et hors les cas prévus par la loi.",
              ),
              const SizedBox(height: 12),

              const _SubTitle("B) Élément moral"),
              const _Paragraph(
                "L’auteur doit avoir :\n"
                "• conscience d’agir en dehors des cas prévus par la loi ;\n"
                "• volonté de pénétrer dans le domicile malgré l’opposition de l’occupant.",
              ),
              const SizedBox(height: 12),

              const _SubTitle("C) Répression"),
              _Paragraph.rich([
                const TextSpan(text: "Peines : "),
                const TextSpan(
                  text: "2 ans d’emprisonnement et 30 000 € d’amende. — ",
                ),
                TextSpan(
                  text: "article 432-8 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "NOTA : si le délit est commis pour des raisons liées au racisme/xénophobie/religion/sexisme/orientation sexuelle/identité de genre, le maximum encouru est relevé selon ",
                  ),
                  TextSpan(
                    text: "les articles 132-76 et 132-77 du Code pénal",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 12),

              const _SubTitle("Tentative & complicité"),
              const _BulletPoint(text: "Tentative : OUI."),
              const _BulletPoint(text: "Complicité : OUI."),
            ],
          ),

          const SizedBox(height: 14),

          // Cas où le policier peut pénétrer (péril/urgence + missions)
          _ConditionCard(
            title: "VII — Cas d’introduction légale dans un domicile",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Les dispositions permettant l’introduction dans un domicile reposent soit sur l’obligation de porter secours, "
                "soit sur la nécessité d’exercer les missions de police.",
              ),
              const SizedBox(height: 14),

              const _SubTitle(
                "A) Cas possibles de jour comme de nuit (péril / urgence)",
              ),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "1) Réclamation depuis l’intérieur (appel au secours) — ",
                ),
                TextSpan(
                  text: "article 59 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : cris/hurlements… l’introduction peut être justifiée même si l’appel s’avère fantaisiste.",
                ),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "2) Maison atteinte ou menacée par un incendie ou une inondation : la réclamation de l’intérieur n’est pas nécessaire ; "
                "le péril peut être ignoré des occupants.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "3) Assistance à personne en péril — "),
                TextSpan(
                  text: "article 223-6 alinéa 2 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : indices laissant croire à un péril grave dans un domicile (appel sans réponse, odeur suspecte, absence anormale d’une personne seule…).",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "4) Police administrative (danger imminent + certificat médical) — ",
                ),
                TextSpan(
                  text: "article L. 3213-2 du Code de la santé publique",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : intervention possible de nuit, notamment pour conduite en milieu psychiatrique (soins sans consentement) dans les conditions prévues.",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "5) Visites domiciliaires / perquisitions / saisies en flagrance sur autorisation JLD — ",
                ),
                TextSpan(
                  text: "articles 59-1 et 706-89 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : possible en dehors des heures prévues à l’article 59 CPP, sur ordonnance spécialement motivée (à la requête du procureur).",
                ),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "6) État de nécessité : pénétrer pour faire cesser un danger actuel ou imminent (ex. fuite de gaz, alarme intempestive causant un trouble intolérable…).",
              ),

              const SizedBox(height: 14),

              const _SubTitle(
                "B) Cas uniquement pendant les heures légales (6h → 21h)",
              ),
              _Paragraph.rich([
                const TextSpan(
                  text: "Les heures légales sont fixées entre 6h et 21h — ",
                ),
                TextSpan(
                  text: "article 59 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              const _IntroBullet(
                text:
                    "1) Exécution d’un mandat d’amener, d’arrêt, de recherche : visite des lieux uniquement pour appréhender la personne visée, au dernier domicile connu.",
              ),
              const _IntroBullet(
                text: "2) Exécution des décisions portant condamnation.",
              ),
              _IntroBullet(
                text:
                    "3) Exécution d’une contrainte judiciaire — art. 749 et suivants et D. 13-4° CPP.",
              ),
              const SizedBox(height: 10),

              _NotaBox(
                title: "Perquisition en enquête préliminaire",
                bodySpans: [
                  const TextSpan(text: "Régime — "),
                  TextSpan(
                    text: "articles 75 et 76 du Code de procédure pénale",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(
                    text:
                        " : pénétration soumise à l’autorisation préalable et écrite de la personne chez laquelle l’opération a lieu. "
                        "En cas de crime ou délit puni d’au moins 3 ans, l’OPJ (uniquement) peut, sur autorisation du JLD, effectuer une perquisition sans assentiment.",
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Les opérations commencées avant 21h peuvent se poursuivre après cette heure.",
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
