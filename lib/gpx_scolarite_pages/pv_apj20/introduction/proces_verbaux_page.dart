import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PVProcesVerbauxPage extends StatelessWidget {
  const PVProcesVerbauxPage({super.key});

  static const String routeName = '/gpx/pv_apj20/introduction/proces_verbaux';

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
    final Color cardDef = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardValue = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardRedac = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardStruct = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);

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
          "PV — APJ 20",
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
            "Les procès-verbaux",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 22,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: "I — Élément légal",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: "Article 429 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : encadre la valeur probante du procès-verbal, qui n’est reconnue que s’il est régulier en la forme, établi par un auteur compétent, dans l’exercice de ses fonctions, et sur une matière de sa compétence (faits vus, entendus ou constatés personnellement).",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Définition
          _ConditionCard(
            title: "Définition",
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le procès-verbal est un acte écrit, rédigé et signé par un magistrat, un officier ou un agent de police judiciaire, agissant conformément aux règles de leur compétence, et dans le cadre d’une mission de police judiciaire.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Valeur des PV (articles 430, 431, 433)
          _ConditionCard(
            title: "II — La valeur des procès-verbaux",
            cardColor: cardValue,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _NotaBox(
                title: "Principe",
                bodySpans: [
                  const TextSpan(text: "Sauf disposition contraire, "),
                  TextSpan(
                    text:
                        "les procès-verbaux et rapports constatant les délits",
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  const TextSpan(
                    text: " ne valent qu’à titre de simples renseignements — ",
                  ),
                  TextSpan(
                    text: "article 430 du Code de procédure pénale",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 12),

              const _SubTitle("A) PV valant simples renseignements"),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 430 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : en enquête de flagrance (sauf loi spéciale), en enquête préliminaire ou en exécution d’une commission rogatoire, les PV n’apportent pas de valeur probante aux faits relatés : ils jouent un rôle d’information.",
                ),
              ]),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Conséquence : le juge apprécie librement, le PV informe mais ne « prouve » pas à lui seul.",
              ),

              const SizedBox(height: 14),

              const _SubTitle("B) PV valant jusqu’à preuve contraire"),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 431 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : une disposition expresse de la loi peut conférer au PV une force probante renforcée. La preuve contraire ne peut alors être apportée que par écrit ou par témoins (ex. : dispositions spéciales, comme certains domaines du droit du travail).",
                ),
              ]),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Règle d’or : le rédacteur relate uniquement ce qu’il a personnellement vu, entendu ou constaté.",
              ),

              const SizedBox(height: 14),

              const _SubTitle("C) PV valant jusqu’à inscription de faux"),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 433 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : certaines matières, prévues par des lois spéciales, donnent lieu à des PV faisant foi jusqu’à inscription de faux (souvent rédigés par des agents spécialisés : douanes, ONF, etc.).",
                ),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Autorité",
                bodySpans: [
                  const TextSpan(
                    text:
                        "L’autorité de ces PV est très forte : le juge est lié tant que les conditions légales sont réunies (infraction constituée, compétence de l’agent, absence de prescription/amnestie, absence de vice de forme).",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Principes de rédaction
          _ConditionCard(
            title: "III — Les principes de rédaction",
            cardColor: cardRedac,
            accent: accentPink,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Principes"),
              const _BulletPoint(
                text:
                    "Simultanéité : le PV doit être rédigé « sur-le-champ » ou dès que possible (perquisition, constatations, audition…).",
              ),
              const SizedBox(height: 6),
              const _BulletPoint(
                text:
                    "Spécificité : traditionnellement, un PV par opération de police judiciaire.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Article D.11 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : autorise, en flagrance ou en préliminaire, à relater dans un seul PV les opérations effectuées au cours d’une même enquête (procédure simplifiée : vol à l’étalage, vente à la sauvette, usage de stupéfiants, etc.).",
                ),
              ]),
              const SizedBox(height: 12),

              const _BulletPoint(
                text:
                    "Unicité du rédacteur : l’en-tête comporte l’identité du rédacteur (ou R.I.O. selon conditions), grade, service et qualité CPP.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Références : "),
                TextSpan(
                  text: "articles D.9 et D.10 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),

              const _BulletPoint(
                text:
                    "Copie : une copie du PV doit toujours être établie et jointe à l’original destiné au magistrat.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 19 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " : impose la copie jointe à l’original."),
              ]),

              const SizedBox(height: 14),

              const _SubTitle("B) Protection du rédacteur & assistants"),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 15-3 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : le rédacteur d’un PV de plainte (OPJ/APJ) peut s’identifier par son numéro d’immatriculation administrative (R.I.O.) sans autorisation préalable.",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 15-4 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : tout agent de la police nationale peut s’identifier par son R.I.O. dans les actes qu’il rédige ou dans lesquels il est cité comme assistant, sans faire apparaître nom et prénom (sous réserve des conditions légales et, dans certains cas, d’une autorisation).",
                ),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                title: "But",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Cette protection vise les situations où la révélation de l’identité est susceptible de mettre en danger la vie ou l’intégrité physique de l’agent ou de ses proches, compte tenu des conditions d’exercice ou de la nature des faits constatés.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Structure & techniques
          _ConditionCard(
            title: "IV — Structure & techniques de rédaction",
            cardColor: cardStruct,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Chaque feuillet du procès-verbal doit être écrit et signé par son rédacteur. Seule la langue française doit être utilisée. Le procès-verbal peut être manuscrit ou dactylographié.",
              ),
              const SizedBox(height: 12),

              const _SubTitle("Les 6 parties du procès-verbal"),
              const _BulletPoint(text: "1) Le titre (« PROCÈS-VERBAL »)."),
              const _BulletPoint(text: "2) L’incipit."),
              const _BulletPoint(text: "3) Le corps du procès-verbal."),
              const _BulletPoint(text: "4) L’énonciation terminale (clôture)."),
              const _BulletPoint(text: "5) La marge."),
              const _BulletPoint(text: "6) Les mentions et annexes."),

              const SizedBox(height: 14),

              const _SubTitle("2) L’incipit : contenu attendu"),
              const _BulletPoint(text: "Date et heure en toutes lettres."),
              const _BulletPoint(
                text:
                    "Identité du rédacteur : nom/prénom ou R.I.O., grade, qualité, service, résidence.",
              ),
              const _BulletPoint(text: "Lieu de rédaction."),
              const _BulletPoint(
                text:
                    "Fait / pièce ouvrant la procédure ou motivant l’opération.",
              ),
              const _BulletPoint(text: "Cadre juridique de l’action de PJ."),
              const _BulletPoint(
                text:
                    "Personnes présentes (assistants, civilement responsable, etc.).",
              ),
              const _BulletPoint(
                text:
                    "Identité de la personne objet de l’opération (sauf impossibilité).",
              ),
              const _BulletPoint(text: "Avis aux autorités."),

              const SizedBox(height: 10),

              _Paragraph.rich([
                const TextSpan(text: "Références R.I.O. : "),
                TextSpan(
                  text: "articles 15-3 et 15-4 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 14),

              const _SubTitle("3) Le corps : règles pratiques"),
              const _BulletPoint(
                text:
                    "Relater uniquement ce qui est personnellement vu, constaté ou entendu.",
              ),
              const _BulletPoint(
                text:
                    "Temps : présent de l’indicatif ; style : première personne du pluriel.",
              ),
              const _BulletPoint(
                text:
                    "Objectivité : reflet fidèle des déclarations enregistrées et des faits constatés.",
              ),
              const _BulletPoint(
                text:
                    "Questions/Réponses : si utile, inscrire le texte exact des questions et enregistrer la réponse.",
              ),

              const SizedBox(height: 12),

              _Paragraph.rich([
                TextSpan(
                  text: "Article 107 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : les PV doivent être établis sans interligne, sans rature ni surcharge. Chaque rature/renvoi doit être approuvé en marge. Les blancs peuvent être comblés par des pointillés.",
                ),
              ]),

              const SizedBox(height: 12),

              _NotaBox(
                title: "NOTA",
                bodySpans: [
                  const TextSpan(
                    text:
                        "L’utilisation du L.R.P. permet, en principe, d’éviter ratures et renvois en modifiant le texte directement à l’écran, avec l’accord du déclarant avant impression.",
                  ),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle("4) Clôture (énonciation terminale)"),
              const _BulletPoint(
                text:
                    "Signatures : rédacteur + assistants mentionnés + déclarant.",
              ),
              const _BulletPoint(
                text:
                    "Heure de fin : facultative pour la plainte ; mentionnée dans les autres actes mettant en cause un suspect.",
              ),
              const _BulletPoint(
                text:
                    "Adapter la formule de clôture : interprète, refus/impossibilité de lecture ou de signature, etc.",
              ),

              const SizedBox(height: 14),

              const _SubTitle("5) La marge : pagination & mentions"),
              const _BulletPoint(
                text:
                    "Pagination : seul le recto est utilisé ; pour les feuillets suivants, documents sans en-tête.",
              ),
              const _BulletPoint(
                text:
                    "Rappels en tête : objet de l’acte, n° du registre / n° d’ordre, numéro de feuillet (suite).",
              ),
              const _BulletPoint(
                text:
                    "Mentions marginales : N° procédure, cote des PV (1, 2, 3…), affaire (contre X / contre personne dénommée), objet (plainte, audition, perquisition…).",
              ),

              const SizedBox(height: 14),

              const _SubTitle("6) Mentions & annexes"),
              const _Paragraph(
                "Elles indiquent une diligence accessoire en rapport direct avec le PV et la jonction d’un document ou d’une pièce (remise par une personne ou jugée nécessaire à l’enquête).",
              ),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "À placer en marge après la clôture, sous la rubrique « MENTION » ou « ANNEXE ».",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "Conclusion",
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Outre les principes applicables à tous les procès-verbaux, chaque type de procès-verbal de la procédure de police judiciaire obéit à des règles particulières, qui seront abordées dans l’étude des différents actes.",
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
