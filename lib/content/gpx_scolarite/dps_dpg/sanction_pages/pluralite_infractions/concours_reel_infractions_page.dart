import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConcoursReelInfractionsPage extends StatelessWidget {
  const ConcoursReelInfractionsPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/sanction_pages/pluralite_infractions/concours_reel_infractions';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : Colors.white;
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    final Color card = isDark
        ? const Color(0xFF2F2F2F)
        : const Color(0xFFF7F7FB);
    final Color card2 = isDark
        ? const Color(0xFF30323A)
        : const Color(0xFFF3F7FF);

    final Color accent = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF0D47A1);

    final Color lawRed = isDark
        ? const Color(0xFFFF6B6B)
        : const Color(0xFFD32F2F);

    TextSpan law(String s) => TextSpan(
      text: s,
      style: TextStyle(color: lawRed, fontWeight: FontWeight.w900),
    );
    TextSpan t(String s) => TextSpan(text: s);

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
          'La sanction',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
        children: [
          // ===================== TITRE (UNE SEULE FOIS) =====================
          Text(
            "Le concours réel d’infractions",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 22,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 12),

          // ===================== INTRO =====================
          _ConditionCard(
            title: "Cadre général",
            cardColor: card2,
            accent: accent,
            titleColor: titleColor,
            children: [
              const _Paragraph(
                "Le chapitre II du titre III du code pénal (Livre I), consacré au régime des peines, "
                "comporte une sous-section « des peines applicables en cas de concours d’infractions ».",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                t("Le Code pénal pose la définition suivante : "),
                law("article 132-2 du Code pénal"),
                t(
                  " : « Il y a concours d’infractions lorsqu’une infraction est commise par une personne avant que celle-ci ait été définitivement condamnée pour une autre infraction. »",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // ===================== CHAPITRE 1 =====================
          _ConditionCard(
            title: "Chapitre 1 — Notions",
            cardColor: card,
            accent: accent,
            titleColor: titleColor,
            children: [
              const _Paragraph(
                "Le concours réel correspond à la situation dans laquelle se trouve un individu "
                "qui commet plusieurs infractions non séparées par une condamnation définitive.",
              ),
              const SizedBox(height: 10),

              const _SubTitle("1.1 — Les hypothèses de concours réel"),
              const SizedBox(height: 4),
              const _BulletPoint(
                text:
                    "Un individu commet une infraction (ex. vol), puis avant que le jugement ne devienne définitif, il commet un nouveau vol : la première décision étant encore susceptible de voies de recours, il y a concours réel.",
              ),
              const _BulletPoint(
                text:
                    "Une personne commet successivement plusieurs infractions : elles sont découvertes et poursuivies en même temps ou séparément (ex. interpellation pour « vol à la roulotte » + aveux d’une dizaine de vols la même nuit).",
              ),
              const _BulletPoint(
                text:
                    "Une personne commet plusieurs infractions quasi concomitantes (ex. outrage, rébellion, puis violences sur les forces de l’ordre).",
              ),

              const SizedBox(height: 12),

              const _SubTitle("1.2 — La solution légale"),
              const SizedBox(height: 4),
              _Paragraph.rich([
                t("Ancien principe (confusion des peines) : "),
                law("article 5 de l’ancien Code pénal"),
                t(" (« la peine la plus forte est seule prononcée »)."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                t(
                  "Aujourd’hui, en cas de concours poursuivi dans une même procédure : ",
                ),
                law("article 132-3 du Code pénal"),
                t(
                  " → chacune des peines encourues peut être prononcée, mais si plusieurs peines de même nature sont encourues, une seule peine est prononcée dans la limite du maximum légal le plus élevé.",
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                t("En cas de procédures distinctes : "),
                law("article 132-4 du Code pénal"),
                t(
                  " → exécution cumulative dans la limite du maximum légal le plus élevé, avec possibilité d’ordonner une confusion totale ou partielle des peines de même nature.",
                ),
              ]),
              const SizedBox(height: 10),
              const _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Le principe général est le non-cumul, mais il est atténué (selon la nature des peines et la manière dont les poursuites sont conduites).",
                  ),
                ],
              ),

              const SizedBox(height: 12),

              const _SubTitle("1.3 — Les conflits de qualifications"),
              const _Paragraph(
                "En poursuites concomitantes, il peut exister un conflit de qualifications lorsque les faits peuvent constituer "
                "des infractions distinctes réprimées par des textes différents (on parle aussi de « concours idéal »). "
                "Avant de raisonner en concours réel, il faut donc résoudre ces conflits.",
              ),
              const SizedBox(height: 10),

              const _SubTitle(
                "1.3.2 — Principe : interdiction du cumul de qualifications pour les mêmes faits",
              ),
              const SizedBox(height: 6),
              const _Paragraph(
                "Ce principe vise les hypothèses où un fait (ou des faits identiques) est en cause. "
                "Si les faits incriminés sont distincts, le cumul peut être possible même s’ils sont indissociables.",
              ),
              const SizedBox(height: 10),

              const _SubTitle("1.3.2.1 — Qualifications incompatibles"),
              const _Paragraph(
                "Une même situation ne peut recevoir plusieurs qualifications lorsqu’elles sont incompatibles "
                "(exclusives l’une de l’autre) : constituer l’une empêche de constituer l’autre.",
              ),
              const SizedBox(height: 6),
              const _IntroBullet(
                text:
                    "Exemples : recel et infraction d’origine ; meurtre et homicide involontaire ; délit de fuite et dégradations volontaires…",
              ),

              const SizedBox(height: 12),

              const _SubTitle("1.3.2.2 — Règle du « non bis in idem »"),
              const _Paragraph(
                "« Pas deux fois pour la même chose » : un même fait autrement qualifié ne peut pas donner lieu à plusieurs déclarations de culpabilité.",
              ),
              const SizedBox(height: 8),

              const _SubTitle("• Qualifications absorbantes"),
              const _Paragraph(
                "L’une des qualifications correspond à un élément constitutif ou à une circonstance aggravante de l’autre.",
              ),
              const _IntroBullet(
                text:
                    "Exemples : viol commis par violence + violences volontaires ; vol avec violence + violences volontaires.",
              ),

              const SizedBox(height: 10),

              const _SubTitle("• Qualifications générales et spéciales"),
              const _Paragraph(
                "La qualification spéciale incrimine une modalité particulière de l’action répréhensible visée par l’infraction générale.",
              ),
              const SizedBox(height: 6),
              _IntroBullet(
                text:
                    "Exemples : assassinat / empoisonnement ; usage illicite de stupéfiants (art. L. 3421-1 CSP) et détention (art. 222-37 CP) si les substances sont exclusivement destinées à la consommation ; recel et certaines infractions de circulation de fausse monnaie.",
              ),

              const SizedBox(height: 12),

              const _SubTitle("1.3.3 — Exemples de cumuls possibles"),
              const SizedBox(height: 6),

              _NotaBox(
                title: "Accident avec plusieurs victimes",
                bodySpans: [
                  t(
                    "Un même accident causant des dommages différents à plusieurs victimes peut permettre un cumul de poursuites, par exemple :\n",
                  ),
                  t("• homicide involontaire par conducteur VTM : "),
                  law("article 221-6-1 du Code pénal"),
                  t(" (si une victime décède)\n"),
                  t(
                    "• atteintes involontaires avec ITT ≤ 3 mois par conducteur VTM : ",
                  ),
                  law("article 222-20-1 du Code pénal"),
                  t(" (si une autre victime est blessée)\n\n"),
                  t(
                    "Le cumul est possible car les qualifications ne sont pas incompatibles et leurs éléments constitutifs sont distincts.",
                  ),
                ],
              ),

              const SizedBox(height: 10),

              _NotaBox(
                title: "Escroquerie et faux",
                bodySpans: [
                  t(
                    "En produisant de faux documents (attestations notariales, certificat, etc.) pour tromper et obtenir une vente, l’auteur peut être poursuivi cumulativement pour :\n",
                  ),
                  t("• faux et usage de faux : "),
                  law("article 441-1 du Code pénal"),
                  t("\n• escroquerie : "),
                  law("article 313-1 du Code pénal"),
                  t(
                    "\n\nCes infractions ne sont pas incompatibles et aucune n’est l’élément constitutif ou la circonstance aggravante de l’autre.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ===================== CHAPITRE 2 =====================
          _ConditionCard(
            title: "Chapitre 2 — Domaine d’application",
            cardColor: card2,
            accent: accent,
            titleColor: titleColor,
            children: [
              const _SubTitle("2.1 — Principe d’application générale"),
              const _Paragraph(
                "La règle du non-cumul des peines a vocation générale.",
              ),
              const SizedBox(height: 10),

              const _SubTitle("2.2 — Atténuations du principe"),
              const SizedBox(height: 6),

              _Paragraph.rich([
                t("• Exclusion des contraventions : "),
                law("article 132-7 du Code pénal"),
                t(" → les amendes pour contravention se cumulent entre elles."),
              ]),
              const SizedBox(height: 8),

              const _Paragraph(
                "• Exclusion des sanctions non pénales : la jurisprudence écarte la règle du non-cumul lorsqu’il y a concours entre une peine et une sanction disciplinaire. "
                "Les amendes fiscales se cumulent avec les peines de droit commun. La contrainte judiciaire (voie forcée d’exécution) est prononcée cumulativement.",
              ),

              const SizedBox(height: 10),

              _Paragraph.rich([
                t(
                  "• Exclusion de certaines peines en raison de leur nature : ",
                ),
                law("article 132-5 du Code pénal"),
                t(
                  " → les peines privatives de liberté sont de même nature : elles ne se cumulent que dans la limite du maximum de la peine la plus forte.",
                ),
              ]),
              const SizedBox(height: 8),

              const _BulletPoint(
                text:
                    "Si plusieurs peines de nature différente sont encourues (ex. emprisonnement + amende), une peine de chaque nature peut être prononcée.",
              ),
              const _BulletPoint(
                text:
                    "Les peines complémentaires prévues pour chacune des infractions en concours réel peuvent se cumuler (ex. confiscation, interdiction de séjour, interdictions de droits, etc.).",
              ),

              const SizedBox(height: 12),

              const _SubTitle("2.2.4 — Exclusions spéciales"),
              const SizedBox(height: 6),
              _BulletPoint(
                text:
                    "Évasion : peines cumulatives. (${_redInline(context, isDark, "article 434-31 du Code pénal")})",
              ),
              _BulletPoint(
                text:
                    "Rébellion de prisonniers : peine cumulée avec celle subie. (${_redInline(context, isDark, "article 433-9 du Code pénal")})",
              ),
              _BulletPoint(
                text:
                    "Usurpation d’identité : cumul avec l’infraction à l’occasion de laquelle elle est commise. (${_redInline(context, isDark, "article 434-23 du Code pénal")})",
              ),
              _BulletPoint(
                text:
                    "Organisation frauduleuse d’insolvabilité : possibilité de non-confusion. (${_redInline(context, isDark, "article 314-8 alinéa 2 du Code pénal")})",
              ),
              _BulletPoint(
                text:
                    "Refus d’obtempérer : cumul avec les infractions commises à l’occasion de la conduite. (${_redInline(context, isDark, "article L. 233-1 II du Code de la route")})",
              ),
              _BulletPoint(
                text:
                    "Infractions graves commises en détention : cumul sans confusion possible. (${_redInline(context, isDark, "article 132-6-1 du Code pénal")} — infractions ${_redInline(context, isDark, "articles 706-73 et 706-73-1 du Code de procédure pénale")})",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ===================== CHAPITRE 3 =====================
          _ConditionCard(
            title: "Chapitre 3 — Mise en œuvre de la règle",
            cardColor: card,
            accent: accent,
            titleColor: titleColor,
            children: [
              _Paragraph.rich([
                t(
                  "Lorsque plusieurs infractions sont commises et se trouvent en concours, le juge peut prononcer toutes les peines encourues : ",
                ),
                law("article 132-3 du Code pénal"),
                t(
                  ". En cas de poursuite unique, une seule peine de même nature peut être prononcée dans la limite du maximum légal le plus élevé.",
                ),
              ]),
              const SizedBox(height: 10),

              const _SubTitle("3.1 — En cas de poursuite unique"),
              const _Paragraph(
                "Toutes les infractions en concours donnent lieu à des poursuites devant une juridiction unique. "
                "Chaque infraction est examinée et une décision est rendue sur la culpabilité pour chacune.",
              ),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Cumul possible des peines de nature différente (ex. emprisonnement + amende).",
              ),
              const _BulletPoint(
                text:
                    "Si les peines encourues sont de même nature : une peine principale unique, plafonnée au maximum légal de l’infraction la plus grave.",
              ),
              const SizedBox(height: 10),

              _NotaBox(
                title: "Exemple",
                bodySpans: [
                  t(
                    "Vol + escroquerie : la peine d’emprisonnement prononcée ne peut dépasser le maximum légal le plus élevé (ex. 5 ans si c’est le plafond le plus haut applicable dans le dossier).",
                  ),
                ],
              ),

              const SizedBox(height: 12),

              const _SubTitle("3.2 — En cas de pluralité de poursuites"),
              const _Paragraph(
                "C’est le cas lorsque les infractions relèvent de juridictions différentes ou n’ont pas été découvertes en même temps. "
                "La règle du non-cumul s’applique, avec la possibilité (dans certaines limites) de confusion des peines.",
              ),
              const SizedBox(height: 10),

              const _SubTitle("3.2.1 — Principe de la confusion des peines"),
              const _Paragraph(
                "Lorsque les peines sont de même nature : elles se cumulent dans la limite du maximum légal le plus élevé. "
                "Si le cumul dépasse le maximum légal, la confusion est obligatoire. Si le cumul reste en dessous, la confusion est une possibilité laissée au juge (totale ou partielle).",
              ),
              const SizedBox(height: 8),
              const _BulletPoint(
                text: "Les peines perpétuelles se confondent entre elles.",
              ),
              const _BulletPoint(
                text:
                    "Si les peines sont de nature différente : elles peuvent s’exécuter cumulativement (le Code pénal ne tranche pas explicitement, la jurisprudence a un rôle).",
              ),

              const SizedBox(height: 12),

              const _SubTitle("3.2.2 — Effets de la confusion"),
              const _Paragraph(
                "La confusion ne fait pas disparaître l’existence des peines : les condamnations subsistent. "
                "L’exécution de la peine la plus forte entraîne celle des peines les plus faibles, toutes étant censées s’exécuter en même temps.",
              ),

              const SizedBox(height: 12),

              const _SubTitle("3.2.3 — Procédure de la confusion"),
              _Paragraph.rich([
                t("Textes : "),
                law("article 132-4 du Code pénal"),
                t(" et "),
                law("article 710-1 du Code de procédure pénale"),
                t("."),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "La juridiction saisie de la 2ᵉ infraction, informée du passé judiciaire, peut prononcer la confusion.",
              ),
              const _BulletPoint(
                text:
                    "Si la juridiction ne s’est pas prononcée : le condamné (ou selon les cas le responsable de l’établissement) peut saisir le procureur de la République par requête.",
              ),
              const _BulletPoint(
                text:
                    "La demande peut être formée après que les condamnations sont définitives ; elle est portée devant le tribunal correctionnel, avec possibilité d’appel devant la chambre des appels correctionnels.",
              ),
              const _BulletPoint(
                text:
                    "Compétence : tribunal(s) ayant prononcé les peines, ou siège d’une juridiction ayant prononcé les peines ; la juridiction du lieu de détention peut aussi être compétente.",
              ),
            ],
          ),

          const SizedBox(height: 22),
        ],
      ),
    );
  }

  // Petit helper: on évite RichText dans les bullets pour rester clean,
  // mais on “marque” quand même les références. (Le rouge est géré ailleurs dans les paragraphes.)
  static String _redInline(BuildContext context, bool isDark, String s) => s;
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
