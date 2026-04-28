import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ControleIdentiteGeneralitesPage extends StatelessWidget {
  const ControleIdentiteGeneralitesPage({super.key});

  static const String routeName = '/gpx/pv_apj20/controle_identite/generalites';

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
    final Color cardCadre = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardCas = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardVerif = isDark
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
          "Contrôles d’identité",
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
            "Généralités — cadre, cas et vérifications",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Définition / rappel déontologique
          _ConditionCard(
            title: "Définition & principe de dignité",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Le contrôle d’identité est l’opération par laquelle une personne est invitée à justifier "
                "sur-le-champ de son identité.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Rappel",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Le contrôle se déroule sans qu’il soit porté atteinte à la dignité de la personne qui en fait l’objet — ",
                  ),
                  TextSpan(
                    text: "art. R. 434-16 du C.S.I.",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut (base juridique)
          _ConditionCard(
            title: "I — Base légale",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: "Article 78-1 du C.P.P.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : toute personne sur le territoire national doit accepter de se prêter à un contrôle d’identité réalisé dans les conditions légales.",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 78-2 du C.P.P.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : fixe les principaux régimes du contrôle d’identité (judiciaire, réquisitions, préventif, zone frontière…).",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Cadre général
          _ConditionCard(
            title: "II — Cadre général du contrôle d’identité",
            cardColor: cardCadre,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Personnes concernées"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Toute personne se trouvant sur le territoire national doit accepter de se prêter à un contrôle d’identité effectué légalement — ",
                ),
                TextSpan(
                  text: "art. 78-1 du C.P.P.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 12),

              const _SubTitle("B) Autorités habilitées"),
              const _Paragraph(
                "Seuls certains personnels peuvent procéder à des contrôles d’identité, selon le cadre juridique.",
              ),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Dans les cas prévus par le C.P.P. : O.P.J. et, sur leur ordre et sous leur responsabilité, A.P.J. et certains A.P.J. adjoints.",
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Certains cas spécifiques (ex. cadres prévus par les articles 78-2-2 et 78-2-4) concernent aussi des A.P.J. adjoints listés par le C.P.P. — références dans ",
                ),
                TextSpan(
                  text: "l’art. 21-1° ter (C.P.P.)",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 12),

              const _SubTitle("C) Moyens de preuve de l’identité"),
              _Paragraph.rich([
                const TextSpan(
                  text: "La personne peut justifier de son identité ",
                ),
                TextSpan(
                  text: "par tout moyen",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : const Color(0xFF0D47A1),
                  ),
                ),
                const TextSpan(text: " — "),
                TextSpan(
                  text: "art. 78-2 (C.P.P.)",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),

              const _SubTitle("• Documents officiels probants"),
              const _IntroBullet(
                text:
                    "Documents officiels avec photographie et délivrance après procédure d’identification (CNI, passeport, permis de conduire…).",
              ),

              const SizedBox(height: 10),
              const _SubTitle("• Autres documents (commencement de preuve)"),
              const _IntroBullet(
                text:
                    "Ex. carte d’électeur, certificat d’immatriculation, livret de famille… À apprécier selon les circonstances.",
              ),

              const SizedBox(height: 12),
              const _SubTitle("D) Recours à des témoignages"),
              const _Paragraph(
                "En cas de document non probant, ou en l’absence de pièce d’identité, la confirmation peut être obtenue "
                "au moyen de témoignages concomitants au contrôle. Cette pratique reste à l’appréciation des policiers.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Cas dans lesquels on peut contrôler (structure claire)
          _ConditionCard(
            title: "III — Cas de contrôle d’identité",
            cardColor: cardCas,
            accent: accentPink,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Contrôles relevant de la police judiciaire"),
              _Paragraph.rich([
                const TextSpan(text: "Référence principale : "),
                TextSpan(
                  text: "art. 78-2 (alinéas 1 à 7) du C.P.P.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),

              const _SubTitle("1) À l’initiative des policiers"),
              _Paragraph.rich([
                const TextSpan(text: "Raisons plausibles de soupçonner ("),
                TextSpan(
                  text: "art. 78-2 (alinéas 2 à 6) du C.P.P.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: ") :"),
              ]),
              const SizedBox(height: 8),
              _BulletPoint(
                text:
                    "Qu’elle a commis ou tenté de commettre une infraction (crime, délit ou contravention) — art. 78-2 al. 2.",
              ),
              _BulletPoint(
                text:
                    "Qu’elle se prépare à commettre un crime ou un délit — art. 78-2 al. 3 (ex. comportement anormal, fuite, changements brusques…).",
              ),
              _BulletPoint(
                text:
                    "Qu’elle est susceptible de fournir des renseignements utiles à l’enquête en cas de crime ou délit — art. 78-2 al. 4 (contraventions exclues).",
              ),
              _BulletPoint(
                text:
                    "Qu’elle a violé des obligations/interdictions (contrôle judiciaire, ARSE, peine/mesure suivie) — art. 78-2 al. 5.",
              ),
              _BulletPoint(
                text:
                    "Qu’elle fait l’objet de recherches ordonnées par une autorité judiciaire — art. 78-2 al. 6.",
              ),

              const SizedBox(height: 12),

              const _SubTitle("2) Sur réquisitions du procureur"),
              _Paragraph.rich([
                TextSpan(
                  text: "Art. 78-2 al. 7 du C.P.P.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : réquisitions écrites précisant les infractions à rechercher, les lieux et la période. "
                      "Le contrôle vise toute personne présente dans le périmètre défini.",
                ),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Le fait que le contrôle révèle d’autres infractions que celles visées dans les réquisitions ",
                  ),
                  TextSpan(
                    text: "n’est pas une cause de nullité",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white : const Color(0xFF0D47A1),
                    ),
                  ),
                  const TextSpan(text: " — "),
                  TextSpan(
                    text: "art. 78-2 al. 7 (C.P.P.)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle("B) Contrôles d’identité préventifs"),
              _Paragraph.rich([
                TextSpan(
                  text: "Art. 78-2 al. 8 du C.P.P.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : l’identité de toute personne peut être contrôlée pour prévenir une atteinte à l’ordre public, "
                      "notamment à la sécurité des personnes et des biens.",
                ),
              ]),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Vise toute personne présente sur le lieu où le contrôle est mis en œuvre.",
              ),
              const _BulletPoint(
                text:
                    "Le contrôle n’est pas strictement lié au comportement : il doit reposer sur des éléments objectifs de menace.",
              ),
              const SizedBox(height: 10),
              const _SubTitle("Conditions usuelles"),
              const _IntroBullet(
                text:
                    "Lieu : public ou ouvert au public (gare, bar, salle de spectacle, galerie marchande…).",
              ),
              const _IntroBullet(
                text:
                    "Temps : circonstances particulières (alertes, grands rassemblements…). La simple “zone propice” ne suffit pas.",
              ),

              const SizedBox(height: 14),

              const _SubTitle("C) Contrôles en zone frontière"),
              _Paragraph.rich([
                TextSpan(
                  text: "Art. 78-2 al. 9 à 17 du C.P.P.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : vérification du respect des obligations de détention, port et présentation de titres dans certaines zones (Schengen, ports/aéroports/gares, trains transnationaux, etc.).",
                ),
              ]),
              const SizedBox(height: 10),
              const _IntroBullet(
                text:
                    "Objectif : prévention/recherche d’infractions liées à la criminalité transfrontalière.",
              ),
              const _IntroBullet(
                text:
                    "Caractère : non permanent (durée limitée) et aléatoire (non systématique).",
              ),

              const SizedBox(height: 14),

              const _SubTitle("D) Contrôles dans des locaux professionnels"),
              _Paragraph.rich([
                TextSpan(
                  text: "Art. 78-2-1 du C.P.P.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : sur réquisitions écrites du procureur (durée max 1 mois), pour vérifier notamment le travail dissimulé. "
                      "Visent les personnes occupées dans l’entreprise (locaux à usage exclusivement professionnel).",
                ),
              ]),

              const SizedBox(height: 14),

              const _SubTitle(
                "E) Visites de véhicules & inspection/fouille de bagages",
              ),
              _Paragraph.rich([
                const TextSpan(text: "Cadre principal : "),
                TextSpan(
                  text: "art. 78-2-2 à 78-2-5 du C.P.P.",
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
                    "Sur réquisitions du procureur : contrôles + assistance OPJ pour visites véhicules et inspection/fouille bagages (selon cadres légaux).",
              ),
              const _IntroBullet(
                text:
                    "Crime/délit flagrant : assistance OPJ pour visite de véhicules (contrôle ID et bagages non prévus par ce cadre précis).",
              ),
              const _IntroBullet(
                text:
                    "Prévention d’une atteinte grave : visite véhicule / inspection ou fouille bagages avec accord, sinon sur instructions du procureur (immobilisation/rétention max 30 min selon cas).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Vérification d'identité + situation
          _ConditionCard(
            title: "IV — Vérifications (identité & situation)",
            cardColor: cardVerif,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Vérification d’identité"),
              _Paragraph.rich([
                TextSpan(
                  text: "Art. 78-3 du C.P.P.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : si la personne refuse ou ne peut justifier de son identité, elle peut être retenue sur place "
                      "ou conduite au local pour vérification, et doit être présentée à un O.P.J.",
                ),
              ]),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Durée maximale : 4 heures (responsabilité exclusive de l’O.P.J.).",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Droits possibles notifiés par un O.P.J. (ou A.P.J. sous contrôle d’un O.P.J.) : aviser le procureur, prévenir un proche, etc. — ",
                  ),
                  TextSpan(
                    text: "art. 78-3 (C.P.P.)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle("B) Vérification de situation"),
              _Paragraph.rich([
                TextSpan(
                  text: "Art. 78-3-1 du C.P.P.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : lorsqu’un contrôle/vérification révèle des raisons sérieuses de penser que le comportement peut être lié à des activités terroristes, "
                      "une retenue peut être décidée même en présence d’un justificatif d’identité.",
                ),
              ]),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Responsabilité exclusive de l’O.P.J., sur place ou au local.",
              ),
              const _BulletPoint(
                text:
                    "Durée maximale : 4 heures, limitée au temps nécessaire (consultation fichiers, contacts services, etc.).",
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
