import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaArmesReglesPortTransportPage extends StatelessWidget {
  const PaArmesReglesPortTransportPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/armes_munitions_pages/armes_regles_port_transport';

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
    final Color cardRules = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardCases = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardAgents = isDark
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
          "Armes & munitions",
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
            "Les règles de port et de transport",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Définition (claire)
          _ConditionCard(
            title: "Définitions (port / transport)",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text: "Article R. 311-1 du C.S.I. (III-10° et 13°)",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : introduit la définition réglementaire du port et du transport des armes.",
                ),
              ]),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    "Port d’arme : avoir une arme sur soi, utilisable immédiatement.",
              ),
              _BulletPoint(
                text:
                    "Transport d’arme : déplacer une arme en l’ayant auprès de soi, inutilisable immédiatement.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "En principe, il n’existe pas d’autorisation administrative générale de port/transport pour les particuliers. "
                        "Exceptions : autorisations ministérielles de port d’arme.",
                  ),
                  TextSpan(text: " "),
                  TextSpan(
                    text: "Articles R. 315-5 et R. 315-6 du C.S.I.",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Base légale (règles générales)
          _ConditionCard(
            title: "Base légale & logique générale",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph.rich([
                TextSpan(text: "Sur la base de "),
                TextSpan(
                  text: "l’article L. 315-1 du C.S.I.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: ", "),
                TextSpan(
                  text: "l’article R. 315-1 du C.S.I.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " précise les règles générales d’interdiction de port ou de transport selon la catégorie (donc selon la dangerosité).",
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                "Idée clé : plus la catégorie est dangereuse, plus l’interdiction est stricte et les exceptions sont encadrées.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Règles par catégories (A/B puis C/D)
          _ConditionCard(
            title: "Règles selon la catégorie",
            cardColor: cardRules,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _SubTitle("I — Catégories A et B"),
              _BulletPoint(
                text:
                    "Interdiction du port des armes, éléments d’armes et munitions.",
              ),
              _BulletPoint(
                text:
                    "Transport : interdit sauf motif légitime (et/ou exceptions prévues par les textes).",
              ),
              SizedBox(height: 12),
              _SubTitle("II — Catégories C et D"),
              _BulletPoint(
                text:
                    "Interdiction, sans motif légitime, du port et du transport des armes, éléments d’armes et munitions.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Important : pour les couteaux (catégorie D), le port/transport peut être admis s’il existe un motif légitime.",
                  ),
                ],
              ),
              SizedBox(height: 10),
              _Paragraph(
                "La légitimité dépend de l’activité réelle : le couteau doit présenter des caractéristiques cohérentes avec l’usage (travail, activité, déplacement…). "
                "Elle s’apprécie au cas par cas, à partir des faits et, si nécessaire, des titres détenus.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Le transport peut être professionnel (ex. artisan) ou non professionnel (ex. tireur sportif qui se rend à son club).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Cas particuliers (chasse / tir sportif / reconstitutions / collectionneurs)
          _ConditionCard(
            title: "Règles particulières (activités encadrées)",
            cardColor: cardCases,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Afin de concilier sécurité publique et pratiques autorisées, des règles spécifiques existent, notamment pour la chasse, le tir sportif et les reconstitutions historiques : ",
                ),
                TextSpan(
                  text: "articles R. 315-2 et R. 315-3 du C.S.I.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 12),

              _SubTitle("III — Concernant la chasse"),
              _Paragraph(
                "Le permis de chasser, accompagné d’un titre français de validation de l’année en cours, vaut titre de port légitime "
                "pour les armes/éléments/munitions de catégorie C ainsi que pour certaines armes de catégorie D (utilisation en action de chasse ou activité liée).",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Pour ces mêmes armes/éléments/munitions, le permis de chasser vaut aussi titre de transport : dans ce cas, la validation de l’année en cours n’est pas nécessaire.",
              ),

              SizedBox(height: 14),

              _SubTitle("IV — Concernant le tir sportif"),
              _Paragraph(
                "La licence de tir en cours de validité vaut titre de transport légitime des armes, éléments d’armes, systèmes d’alimentation et munitions "
                "des catégories A, B et C, ainsi que des armes/éléments/munitions de catégorie D utilisés dans la pratique du sport relevant de la fédération.",
              ),

              SizedBox(height: 14),

              _SubTitle("V — Les collectionneurs"),
              _Paragraph(
                "La carte de collectionneur vaut titre de transport légitime des armes de catégorie C, pour les activités liées à :",
              ),
              SizedBox(height: 8),
              _IntroBullet(
                text: "Exposition dans un musée ouvert au public.",
              ),
              _IntroBullet(text: "Conservation."),
              _IntroBullet(text: "Connaissance / étude des armes."),
            ],
          ),

          const SizedBox(height: 14),

          // Agents publics + cas PN/GN + douanes/pénitentiaire + ERP + PA/ réserve
          _ConditionCard(
            title: "Agents publics (règles & cas usuels)",
            cardColor: cardAgents,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _SubTitle(
                "VI — Fonctionnaires / agents chargés d’une mission de police",
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Ils peuvent être autorisés à porter, dans l’exercice ou à l’occasion de leurs fonctions, certaines armes et munitions détenues régulièrement : ",
                ),
                TextSpan(
                  text: "article R. 315-8 du C.S.I.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),

              _Paragraph.rich([
                TextSpan(
                  text:
                      "Concernant les militaires (officiers / sous-officiers), le port s’effectue selon leurs règlements particuliers : ",
                ),
                TextSpan(
                  text: "article R. 315-9 du C.S.I.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),

              _Paragraph.rich([
                TextSpan(
                  text:
                      "Douanes et administration pénitentiaire : transport/port/usage des armes remises par l’administration : ",
                ),
                TextSpan(
                  text: "article R. 315-10 du C.S.I.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 14),

              _SubTitle("Accès à un ERP hors service (PN / GN)"),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Un fonctionnaire de police nationale ou un gendarme d’active peut accéder à un ERP hors service en étant porteur de son arme : ",
                ),
                TextSpan(
                  text: "article R. 315-11 du C.S.I.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _Paragraph("Conditions essentielles (à retenir) :"),
              SizedBox(height: 8),
              _IntroBullet(
                text:
                    "Être à jour de la formation continue (emploi des armes).",
              ),
              _IntroBullet(text: "Ne jamais se séparer de l’arme."),
              _IntroBullet(
                text:
                    "Avant un contrôle d’accès : justifier sa qualité (carte pro + brassard d’identification).",
              ),
              _IntroBullet(text: "Arme portée de façon non visible."),

              SizedBox(height: 14),

              _SubTitle(
                "Policiers adjoints / réservistes : autorisations possibles",
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Si la mission le requiert, ils peuvent être autorisés à porter certaines armes et systèmes d’alimentation : ",
                ),
                TextSpan(
                  text: "articles R. 411-7 et R. 411-29 du C.S.I.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                "Ils peuvent également être autorisés (selon mission) au port/transport de certains équipements : grenades de désencerclement, "
                "grenades lacrymogènes, armes à impulsion électrique, aérosols lacrymogènes/incapacitants, bâtons de défense, etc.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Réservistes retraités : possibilité de port/transport du LBD 40 mm et munitions si habilitation à jour lors de l’intégration, "
                        "sur autorisation du chef de service — ",
                  ),
                  TextSpan(
                    text: "article R. 411-29 du C.S.I.",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Activités privées + risques exceptionnels + étrangers
          _ConditionCard(
            title:
                "Autorisations exceptionnelles (privé / risques / étrangers)",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _SubTitle("VII — Activités privées de sécurité"),
              _Paragraph(
                "Le personnel d’entreprises pouvant être amené à assurer la sécurité des biens ou le gardiennage peut, lorsque la mission le justifie, "
                "être autorisé à porter des armes et munitions à l’extérieur des bâtiments/locaux.",
              ),
              SizedBox(height: 8),
              _Paragraph(
                "Autorisation délivrée par le préfet du département où se situent les lieux à surveiller ; révocable à tout moment.",
              ),

              SizedBox(height: 14),

              _SubTitle(
                "VIII — Personnes exposées à des risques exceptionnels",
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Le ministre de l’Intérieur peut autoriser, par arrêté, une personne exposée à des risques exceptionnels d’atteinte à sa vie "
                      "à porter et transporter une arme de poing : ",
                ),
                TextSpan(
                  text: "article R. 312-39 du C.S.I.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Munitions correspondantes : limite de 50 cartouches par arme — ",
                ),
                TextSpan(
                  text: "article R. 312-47 1° du C.S.I.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Possibilité de port sur le lieu d’activité professionnelle — ",
                ),
                TextSpan(
                  text: "article R. 315-5-1 du C.S.I.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 14),

              _SubTitle("IX — Personnes étrangères séjournant en France"),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Le ministre de l’Intérieur peut autoriser, par arrêté, certains agents/personnalités étrangers et leurs agents de sécurité, "
                      "ainsi que des personnes exerçant des fonctions diplomatiques/internationales, à détenir/porter/transporter une arme de poing : ",
                ),
                TextSpan(
                  text: "article R. 315-6 du C.S.I.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: "Munitions : limite de 50 cartouches par arme — ",
                ),
                TextSpan(
                  text: "article R. 312-47 1° du C.S.I.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                "Peut aussi porter deux armes parmi certaines catégories : matraque/bâton télescopique (cat. D a) ou aérosol lacrymogène/incapacitant (cat. D b).",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "La durée de l’autorisation est limitée (mission/séjour/fonctions). Dans certains cas : durée maximale d’un an, renouvelable. "
                "À titre exceptionnel, le transport de plusieurs armes de poing et munitions par une même personne assurant la sécurité peut être autorisé.",
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
        : const Color(0xFF1F1F1F).withValues(alpha: .92);

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
                    : const Color(0xFF1F1F1F).withValues(alpha: .92),
              ),
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
        color: bgColor.withValues(alpha: isDark ? .7 : .95),
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
