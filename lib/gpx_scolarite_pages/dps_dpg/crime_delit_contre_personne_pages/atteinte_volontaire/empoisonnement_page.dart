import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmpoisonnementPage extends StatelessWidget {
  const EmpoisonnementPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/crime_delit_contre_personne_pages/atteintes_volontaires_vie/empoisonnement';

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
          "Atteintes volontaires à la vie",
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
            "L’empoisonnement",
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
                "Le fait d’attenter à la vie d’autrui par l’emploi ou l’administration de substances de nature à entraîner la mort "
                "est un empoisonnement et constitue une infraction.",
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
                  text: "Article 221-5 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " : définit et réprime l’empoisonnement."),
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
              const _SubTitle("A) Un acte d’emploi ou d’administration"),
              const _Paragraph(
                "L’empoisonnement est une infraction de commission : un acte positif est nécessaire. "
                "Une simple abstention ne suffit pas.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Le mode d’administration est indifférent : piqûre, absorption, imprégnation, inhalation, respiration, "
                "radiation, relation sexuelle, etc.",
              ),
              const SizedBox(height: 12),

              const _SubTitle("B) Administration vs emploi"),
              const _Paragraph(
                "• L’administration vise l’action de faire prendre le produit : faire ingurgiter/boire, injecter, inoculer…\n"
                "• L’emploi se situe en amont : actes de préparation (mélanger le poison à un plat, mettre le plat à disposition, etc.).",
              ),
              const SizedBox(height: 12),

              const _SubTitle("C) Acte unique ou répété"),
              const _Paragraph(
                "L’administration peut être unique ou répétée dans le temps. "
                "Même si chaque absorption isolée est insuffisante, l’ensemble des administrations peut constituer un fait unique.",
              ),
              const SizedBox(height: 12),

              const _SubTitle("D) Remise directe ou indirecte"),
              const _Paragraph(
                "Le mode peut être :\n"
                "• Direct (l’auteur administre lui-même)\n"
                "• Indirect (remise via un tiers de bonne foi)\n"
                "• Par la victime elle-même si elle a été trompée.",
              ),
              const SizedBox(height: 14),

              const _SubTitle("E) Sur la personne d’autrui"),
              const _Paragraph(
                "• La victime doit être une personne humaine (pas un animal).\n"
                "• La victime doit être vivante : l’acte sur un cadavre relève de l’infraction impossible (assimilée à la tentative).\n"
                "• La victime doit être distincte de l’auteur (le suicide n’est pas incriminé).\n"
                "• La victime peut être déterminée ou indéterminée : l’infraction existe même si l’auteur ne sait pas précisément qui sera atteint.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Jurisprudence : produit mortifère jeté dans un puits alimentant en eau potable un grand nombre de personnes ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 5 février 1958)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 14),

              const _SubTitle("F) Substances de nature à entraîner la mort"),
              const _Paragraph(
                "La substance doit être de nature mortifère : appréciation au cas par cas (poison végétal/animal/minéral, virus, gaz toxique, etc.).\n"
                "Elle « peut » entraîner la mort, sans devoir nécessairement la provoquer.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Jurisprudence : l’arséniate de plomb dans l’eau de boisson, de nature à provoquer une intoxication lente pouvant aboutir à la mort ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 5 février 1958)",
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
                "Le caractère mortifère s’apprécie aussi selon l’usage (mélanges, doses anormales/trop nombreuses) "
                "ou une sensibilité particulière connue de l’auteur.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Jurisprudence : l’administration en connaissance de cause de produits associés peut constituer l’élément matériel de l’empoisonnement ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 8 juin 1993)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 12),

              const _SubTitle(
                "G) Indifférence du résultat (infraction formelle)",
              ),
              const _Paragraph(
                "L’empoisonnement est une infraction formelle : le crime est réalisé du seul fait de l’administration "
                "de la substance mortifère, quelles qu’en soient les suites.",
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
              const _SubTitle("A) Connaissance de la nature mortelle"),
              const _Paragraph(
                "Si l’auteur ignore le caractère mortifère de la substance, il ne peut pas y avoir empoisonnement.",
              ),
              const SizedBox(height: 12),
              const _SubTitle("B) Intention de donner la mort"),
              const _Paragraph(
                "La seule connaissance du caractère mortifère ne suffit pas : il faut établir l’intention de donner la mort.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Jurisprudence : le crime d’empoisonnement ne peut être caractérisé que si l’auteur a agi avec l’intention de donner la mort ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 18 juin 2003)",
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

          // Circonstances aggravantes
          _ConditionCard(
            title: "IV — Circonstances aggravantes",
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: "Articles 221-2, 221-3 et 221-4 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : les circonstances aggravantes applicables à l’empoisonnement sont celles prévues pour le meurtre (crime concomitant, objectif de faciliter un délit / assurer l’impunité, préméditation/guet-apens, mineur de 15 ans, vulnérabilité, dépositaire de l’autorité publique, enseignant/transport/service public/santé, témoin/victime/partie civile, bande organisée, conjoint/concubin/PACS, refus de mariage/union, ivresse manifeste/stupéfiants, etc.).",
                ),
              ]),
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
                const TextSpan(text: "Empoisonnement (simple) : "),
                const TextSpan(
                  text:
                      "30 ans de réclusion criminelle + période de sûreté. — ",
                ),
                TextSpan(
                  text: "article 221-5 alinéa 2 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Empoisonnement aggravé : "),
                const TextSpan(
                  text:
                      "réclusion criminelle à perpétuité + période de sûreté. — ",
                ),
                TextSpan(
                  text: "article 221-5 alinéa 3 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),
              const SizedBox(height: 12),

              const _SubTitle("Personnes morales"),
              _Paragraph.rich([
                const TextSpan(text: "Peines prévues par "),
                TextSpan(
                  text: "l’article 221-5-2 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("Tentative"),
              const _BulletPoint(text: "Tentative : OUI."),
              const SizedBox(height: 6),
              const _Paragraph(
                "La frontière entre tentative et crime consommé se situe au moment où la substance est introduite dans l’organisme "
                "(absorption/pénétration). Avant, il s’agit d’un commencement d’exécution ; après, le crime est consommé quel qu’en soit le résultat.\n\n"
                "Le commencement d’exécution est retenu dès lors que le poison est présenté à la victime ou mis à sa disposition. "
                "Les actes trop éloignés sont de simples actes préparatoires (parfois punissables : conspiration, achat/fabrication, mélange aux aliments…).",
              ),

              const SizedBox(height: 12),

              const _SubTitle("Complicité"),
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
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("Provocation à commettre un empoisonnement"),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 221-5-1 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : incrimine l’instigation (offres/promesses/dons/avantages) afin qu’une personne commette un empoisonnement, "
                      "y compris hors du territoire national, lorsque le crime n’a été ni commis ni tenté (infraction distincte).",
                ),
              ]),
              const SizedBox(height: 10),

              const _SubTitle("Exemption / réduction de peine"),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 221-5-3 alinéa 1 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : exemption si, ayant averti l’autorité administrative ou judiciaire, l’auteur a permis d’éviter la mort de la victime.",
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 221-5-3 alinéa 3 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : réduction des deux tiers si l’avertissement permet d’éviter la mort ou d’identifier d’autres auteurs/complices ; "
                      "si perpétuité encourue, ramenée à 15 ans.",
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
