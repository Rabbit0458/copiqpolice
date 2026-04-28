import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AmendeForfaitaireDelictuellePage extends StatelessWidget {
  const AmendeForfaitaireDelictuellePage({super.key});

  static const String routeName =
      '/gpx/memento_circulation/procedures/amende_forfaitaire_delictuelle';

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
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardInfra = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardExclu = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardMontants = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardPaiement = isDark
        ? const Color(0xFF1E2630)
        : const Color(0xFFF3F6FA);

    final Color accentBlue = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color accentGrey = isDark ? Colors.white70 : const Color(0xFF616161);
    final Color accentGreen = isDark
        ? const Color(0xFF66BB6A)
        : const Color(0xFF2E7D32);
    final Color accentAmber = isDark
        ? const Color(0xFFFFCA28)
        : const Color(0xFFF9A825);
    final Color accentPink = isDark
        ? const Color(0xFFF48FB1)
        : const Color(0xFFC2185B);

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
          "Procédures — circulation",
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
            "L’amende forfaitaire délictuelle (A.F.D.)",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
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
                  text: "Articles L. 221-2 et L. 324-2 du Code de la route",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " ; "),
                TextSpan(
                  text: "articles 495-17 à 495-25 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " ; "),
                TextSpan(
                  text:
                      "articles D. 45-3 à D. 45-21 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " ; "),
                TextSpan(
                  text:
                      "articles A. 36-14 à A. 36-18 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: const [
                  TextSpan(
                    text:
                        "Les A.P.J.A. ne sont pas habilités à constater les délits par procès-verbal.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Cadre + info au contrevenant
          _ConditionCard(
            title: "II — Cadre & information du contrevenant",
            cardColor: cardCadre,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Les délits concernés sont constatés par procès-verbal électronique (PVe). "
                "Au moment de la verbalisation, l’intéressé doit être avisé (mention inscrite dans le PVe) :",
              ),
              const SizedBox(height: 8),
              const _IntroBullet(
                text:
                    "Qu’il recevra par lettre simple à son domicile : avis d’amende forfaitaire, notice de paiement et formulaire de requête en exonération.",
              ),
              const _IntroBullet(
                text:
                    "Qu’il peut payer immédiatement l’A.F.D. minorée entre les mains de l’agent verbalisateur.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Référence paiement immédiat : "),
                TextSpan(
                  text: "article A. 37-27-6 du Code de procédure pénale",
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

          // Délits concernés
          _ConditionCard(
            title: "III — Délits concernés (A.F.D.)",
            cardColor: cardInfra,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _SubTitle("Délits pouvant donner lieu à A.F.D."),
              _BulletPoint(
                text: "Conduite d’un véhicule sans permis (Natinf 7536).",
              ),
              _BulletPoint(
                text:
                    "Conduite avec un permis d’une catégorie n’autorisant pas la conduite du véhicule (Natinf 22872).",
              ),
              _BulletPoint(
                text:
                    "Conduite d’un véhicule terrestre à moteur sans assurance (Natinf 6163).",
              ),
              _BulletPoint(
                text:
                    "Entrave à la circulation des véhicules sur une voie publique (Natinf 2271).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Exclusions / impossibilité AFD
          _ConditionCard(
            title: "IV — Cas d’exclusion (A.F.D. impossible)",
            cardColor: cardExclu,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "L’A.F.D. ne peut pas être mise en œuvre si l’auteur des faits :",
              ),
              const SizedBox(height: 8),
              const _BulletPoint(text: "N’est pas formellement identifié."),
              const _BulletPoint(text: "Est mineur."),
              const _BulletPoint(
                text:
                    "Présente une difficulté de compréhension (pas dans un état normal, ne maîtrise pas la langue française, discernement altéré, majeur protégé).",
              ),
              const _BulletPoint(
                text:
                    "Est en état de récidive légale (même délit ou délit assimilé).",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "TAJ",
                bodySpans: const [
                  TextSpan(
                    text:
                        "La consultation préalable du traitement des antécédents judiciaires (T.A.J.) est impérative.",
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _Paragraph.rich([
                const TextSpan(text: "Récidive (délai 5 ans) : "),
                TextSpan(
                  text: "article 132-10 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " — sauf délits ayant déjà fait l’objet d’une A.F.D. (une succession d’A.F.D. pour le même délit est possible).",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Délits assimilés : "),
                TextSpan(
                  text: "article 132-16-2 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " (exemples listés ci-dessous)."),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text: "Défaut de permis de conduire : L. 221-2 C. route.",
              ),
              const _BulletPoint(
                text:
                    "CEEA / CEI / refus de se soumettre aux vérifications : L. 234-1 C. route.",
              ),
              const _BulletPoint(
                text:
                    "Conduite après usage de stupéfiants / refus de vérifications : L. 235-1 C. route.",
              ),
              const _BulletPoint(
                text: "Délit de grande vitesse : L. 413-1 C. route.",
              ),
              const _BulletPoint(
                text:
                    "Refus d’obtempérer (y compris aggravé) : L. 233-1 et L. 233-1-1 C. route.",
              ),
              const SizedBox(height: 12),
              const _SubTitle("Autres situations excluant l’A.F.D."),
              const _BulletPoint(
                text:
                    "Si le délit n’est pas constaté sur les lieux du contrôle et en présence du conducteur (ex : constaté après enquête suite à non présentation / non justification).",
              ),
              const _BulletPoint(
                text:
                    "En cas de commission de plusieurs infractions dont l’une au moins ne peut donner lieu à amende forfaitaire.",
              ),
              const _BulletPoint(
                text:
                    "En cas de commission simultanée des délits de défaut d’assurance et de défaut de permis de conduire.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Montants
          _ConditionCard(
            title: "V — Montant de l’amende",
            cardColor: cardMontants,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Références : L. 221-2 IV et L. 324-2 IV du Code de la route",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 12),
              _AfdAmountTable(isDark: isDark),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Assurance — majoration FGAO",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Pour le délit de circulation sans assurance : majoration de 50% au profit du fonds de garantie des assurances obligatoires de dommages (FGAO). Références : ",
                  ),
                  TextSpan(
                    text: "article D. 45-5 du Code de procédure pénale",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: " et "),
                  TextSpan(
                    text: "article L. 211-27 du Code des assurances",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: ". "),
                  const TextSpan(
                    text:
                        "Montants portés à 600 € (minorée), 750 € (ordinaire) et 1 500 € (majorée).",
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Paiement / contestation
          _ConditionCard(
            title: "VI — Paiement ou contestation de l’A.F.D.",
            cardColor: cardPaiement,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Les délais de paiement / contestation et les modalités de paiement sont identiques à ceux de l’amende forfaitaire contraventionnelle.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Références : article D. 45-8 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " et "),
                TextSpan(
                  text: "article R. 49-3 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 12),
              const _Paragraph(
                "Les conditions de recevabilité (requête en exonération / réclamation), ainsi que les modalités de consignation (hors cas d’exonération) sont précisées dans les documents reçus (formulaire / avis d’amende majorée).",
              ),
              const SizedBox(height: 12),
              _NotaBox(
                title: "Dispense de consignation",
                bodySpans: [
                  const TextSpan(
                    text:
                        "L’auteur de la requête (ou réclamation) est dispensé du paiement de la consignation s’il adresse :",
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Une photocopie du permis de conduire en cours de validité à la date de constatation des faits.",
              ),
              const _BulletPoint(
                text:
                    "Une photocopie d’une attestation d’assurance en cours de validité à la date de constatation des faits.",
              ),
              _BulletPoint(
                text:
                    "Le récépissé de dépôt de plainte pour usurpation d’identité.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Usurpation d’identité : "),
                TextSpan(
                  text: "article 434-23 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 12),
              _Paragraph.rich([
                const TextSpan(text: "Mis à jour le "),
                const TextSpan(
                  text: "15/06/2025",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: "."),
              ]),
            ],
          ),
        ],
      ),
    );
  }
}

class _AfdAmountTable extends StatelessWidget {
  const _AfdAmountTable({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final Color headerBg = isDark
        ? const Color(0xFF1A1A1A)
        : const Color(0xFFF1F1F1);
    final Color rowBg = isDark ? const Color(0xFF151515) : Colors.white;
    final Color border = isDark ? Colors.white12 : Colors.black12;
    final Color text = isDark ? Colors.white : const Color(0xFF111111);
    final Color subText = isDark ? Colors.white70 : const Color(0xFF444444);

    Widget headerCell(
      String t, {
      int flex = 2,
      TextAlign align = TextAlign.left,
    }) {
      return Expanded(
        flex: flex,
        child: Text(
          t,
          textAlign: align,
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 13.5,
            color: text,
          ),
        ),
      );
    }

    Widget cell(
      String t, {
      int flex = 2,
      TextAlign align = TextAlign.left,
      bool strong = false,
    }) {
      return Expanded(
        flex: flex,
        child: Text(
          t,
          textAlign: align,
          style: GoogleFonts.fustat(
            fontWeight: strong ? FontWeight.w900 : FontWeight.w700,
            fontSize: 13.5,
            color: subText,
          ),
        ),
      );
    }

    Widget row({
      required String delit,
      required String minoree,
      required String ordinaire,
      required String majoree,
    }) {
      return Container(
        decoration: BoxDecoration(
          color: rowBg,
          border: Border(top: BorderSide(color: border)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            cell(delit, flex: 5, strong: true),
            cell(minoree, flex: 2, align: TextAlign.right),
            cell(ordinaire, flex: 2, align: TextAlign.right),
            cell(majoree, flex: 2, align: TextAlign.right),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: headerBg,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Row(
              children: [
                headerCell("Délit", flex: 5),
                headerCell("Minorée", flex: 2, align: TextAlign.right),
                headerCell("Ordinaire", flex: 2, align: TextAlign.right),
                headerCell("Majorée", flex: 2, align: TextAlign.right),
              ],
            ),
          ),
          row(
            delit:
                "Conduite d’un véhicule sans permis OU avec permis d’une catégorie non autorisée",
            minoree: "640 €",
            ordinaire: "800 €",
            majoree: "1 600 €",
          ),
          row(
            delit: "Circulation d’un véhicule à moteur sans assurance",
            minoree: "400 €*",
            ordinaire: "500 €*",
            majoree: "1 000 €*",
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
