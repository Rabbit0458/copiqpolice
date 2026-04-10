import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AtteintesInvolontairesConducteurVtmPage extends StatelessWidget {
  const AtteintesInvolontairesConducteurVtmPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_conducteur_vtm';

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
          "Atteintes involontaires",
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
            "Les atteintes involontaires à l’intégrité de la personne\ncommises par le conducteur d’un V.T.M.\n(I.T.T. ≤ 3 mois)",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20.5,
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
                "Le conducteur d’un véhicule terrestre à moteur qui, par maladresse, imprudence, "
                "inattention, négligence ou manquement à une obligation législative ou réglementaire "
                "de prudence ou de sécurité, cause à autrui une incapacité totale de travail (ITT) "
                "d’une durée inférieure ou égale à trois mois, constitue une infraction.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut (exigence)
          _ConditionCard(
            title: "I — Élément légal",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: "Article 222-20-1 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : prévoit et réprime les atteintes involontaires à l’intégrité de la personne "
                      "commises par le conducteur d’un véhicule terrestre à moteur (ITT ≤ 3 mois).",
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
              const _SubTitle("A) Un acte involontaire : la faute"),
              _Paragraph.rich([
                const TextSpan(text: "Le texte renvoie à "),
                TextSpan(
                  text: "l’article 222-19 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " (en référence à "),
                TextSpan(
                  text: "l’article 121-3 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      "), qui énumère cinq comportements fautifs : il s’agit d’une faute d’imprudence simple.",
                ),
              ]),
              const SizedBox(height: 10),

              const _SubTitle("1) La faute simple"),
              const _Paragraph("Deux grands cas :"),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "La maladresse, l’imprudence, l’inattention, la négligence : agir sans précautions ou ne pas se soucier des conséquences d’une abstention.",
              ),
              const _BulletPoint(
                text:
                    "Le manquement à une obligation particulière de prudence ou de sécurité imposée par la loi ou le règlement.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Ces fautes s’apprécient par comparaison avec le comportement qu’aurait dû adopter un individu "
                "normalement prudent, attentif, diligent (ou, selon les cas, le professionnel moyen/diligent).",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Les magistrats doivent pouvoir préciser la source et la nature exacte de l’obligation violée : ",
                  ),
                  TextSpan(
                    text: "Cass. crim., 18 juin 2002",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle("2) La faute caractérisée"),
              const _Paragraph(
                "Si la faute est en lien direct avec le dommage, une faute simple peut suffire. "
                "En revanche, si l’auteur a causé indirectement le dommage, il faut établir une faute "
                "d’une particulière gravité : la faute caractérisée (imprudence lourde), exposant autrui à "
                "un danger d’une particulière gravité, que l’auteur ne pouvait ignorer.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudences",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Remettre volontairement les clés à une victime alcoolisée et sans permis : ",
                  ),
                  TextSpan(
                    text: "Cass. crim., 14 décembre 2010",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: ".\n"),
                  const TextSpan(
                    text:
                        "Médecin du SAMU n’ayant pas posé les bonnes questions : ",
                  ),
                  TextSpan(
                    text: "Cass. crim., 2 décembre 2003",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle("B) Un lien de causalité"),
              const _Paragraph(
                "La faute doit avoir concouru au dommage. La causalité n’a pas besoin d’être immédiate : "
                "le dommage est pris en compte dans son dernier état.",
              ),
              const SizedBox(height: 10),

              const _SubTitle("1) Causalité indirecte (personnes physiques)"),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 121-3 alinéa 4 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : sont auteurs indirects ceux qui ont créé/contribué à créer la situation ayant permis le dommage "
                      "ou n’ont pas pris les mesures permettant de l’éviter.",
                ),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Exemple : loueur qui confie un scooter des mers à une personne sans permis requis : ",
                  ),
                  TextSpan(
                    text: "Cass. crim., 5 octobre 2004",
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
                title: "Jurisprudences (maire)",
                bodySpans: [
                  const TextSpan(
                    text: "Buse non fixée sur une aire de jeux communale : ",
                  ),
                  TextSpan(
                    text: "Cass. crim., 20 mars 2001",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: ".\n"),
                  const TextSpan(
                    text:
                        "Absence de réglementation des déplacements de dameuses sur piste de luge : ",
                  ),
                  TextSpan(
                    text: "Cass. crim., 18 mars 2003",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle("2) Causalité directe"),
              const _Paragraph(
                "La causalité directe vise l’auteur dont le comportement a été un paramètre déterminant dans la survenance du dommage. "
                "Le lien de causalité est direct lorsque l’imprudence/la négligence reprochée est la cause unique/exclusive ou la cause immédiate/déterminante.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Paramètre déterminant dans la survenance du dommage : ",
                  ),
                  TextSpan(
                    text: "Cass. crim., 25 septembre 2001",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle("C) Sur la personne d’autrui & un dommage"),
              const _BulletPoint(
                text: "La victime doit être une personne humaine vivante.",
              ),
              const SizedBox(height: 6),
              const _BulletPoint(
                text:
                    "Les atteintes peuvent être physiques ou psychiques (un choc émotionnel peut suffire).",
              ),
              const SizedBox(height: 6),
              const _BulletPoint(
                text:
                    "La victime doit avoir subi une ITT inférieure ou égale à trois mois.",
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
                "Les infractions non intentionnelles ne supposent pas d’intention de nuire. "
                "Toutefois, lorsqu’il existe une violation manifestement délibérée d’une obligation particulière "
                "de prudence ou de sécurité, il faut établir que l’auteur a adopté un comportement risqué en connaissance de cause "
                "(conscience du danger), sans vouloir pour autant la réalisation du résultat.",
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
              const _SubTitle("Deux degrés d’aggravation"),
              const _SubTitle("1) Premier degré"),
              const _Paragraph(
                "Constituent des circonstances aggravantes notamment :",
              ),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Violation manifestement délibérée d’une obligation particulière de prudence ou de sécurité prévue par la loi ou le règlement.",
              ),
              const _BulletPoint(
                text:
                    "État d’ivresse manifeste / état alcoolique caractérisé (ou refus de vérifications).",
              ),
              const _BulletPoint(
                text:
                    "Usage de stupéfiants (analyse sanguine/salivaire) ou refus de vérifications.",
              ),
              const _BulletPoint(
                text:
                    "Absence de permis exigé, permis annulé/invalidé/suspendu/retenu.",
              ),
              const _BulletPoint(
                text:
                    "Dépassement de la vitesse maximale autorisée égal ou supérieur à 50 km/h.",
              ),
              const _BulletPoint(
                text:
                    "Délit de fuite : ne pas s’arrêter après avoir causé/occasionné un accident pour échapper à la responsabilité.",
              ),
              const SizedBox(height: 12),

              const _SubTitle("2) Deuxième degré"),
              const _BulletPoint(
                text:
                    "Lorsque l’infraction a été commise avec deux (ou plus) des circonstances aggravantes ci-dessus.",
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
                  text: "2 ans d’emprisonnement et 30 000 € d’amende. — ",
                ),
                TextSpan(
                  text: "article 222-20-1 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Aggravée (1 circonstance) : "),
                const TextSpan(
                  text: "3 ans d’emprisonnement et 45 000 € d’amende. — ",
                ),
                TextSpan(
                  text: "article 222-20-1 alinéa 2 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Aggravée (2+ circonstances) : "),
                const TextSpan(
                  text: "5 ans d’emprisonnement et 75 000 € d’amende. — ",
                ),
                TextSpan(
                  text: "article 222-20-1 alinéa 9 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("Personnes morales"),
              _Paragraph.rich([
                const TextSpan(text: "Responsabilité pénale prévue par "),
                TextSpan(
                  text: "l’article 222-21 du Code pénal",
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
                        "Les personnes morales demeurent responsables pénalement des infractions non intentionnelles, "
                        "que le dommage soit direct ou indirect. Référence : ",
                  ),
                  TextSpan(
                    text: "Cass. crim., 24 octobre 2000",
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
              const _BulletPoint(text: "Tentative : NON (non envisagée)."),
              const _Paragraph(
                "Le résultat dommageable n’étant pas recherché par l’auteur, la tentative n’a pas vocation à s’appliquer.",
              ),
              const SizedBox(height: 8),
              const _BulletPoint(text: "Complicité : NON."),
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
