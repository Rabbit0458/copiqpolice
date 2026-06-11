import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaGPXSchoolResponsabilitePenaleCompliciteCoactionPage
    extends StatelessWidget {
  const PaGPXSchoolResponsabilitePenaleCompliciteCoactionPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/droit_penal_general/responsabilite_penale/complicite_coaction';

  // --- Helpers: mise en rouge des articles / codes ---
  TextSpan _red(String s) => TextSpan(
    text: s,
    style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w800),
  );

  TextSpan _t(String s) => TextSpan(text: s);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF121212) : const Color(0xFFF7F7FB);
    final Color textMain = isDark ? Colors.white : const Color(0xFF0B0B0B);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF0B0B0B).withValues(alpha: .72);

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
          'La complicité et la coaction',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 16.5,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 26),
        children: [
          // ========================= INTRO =========================
          Text(
            'La complicité et la coaction',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 22,
              height: 1.05,
              color: textMain,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Comprendre qui est auteur, coauteur, complice — et dans quelles conditions la '
            'participation est punissable.',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 18),

          // ========================= DÉFINITIONS =========================
          _ConditionCard(
            title: 'Auteur, coauteurs, complices',
            cardColor: isDark
                ? const Color(0xFF1A2430)
                : const Color(0xFFE3F2FD),
            accent: const Color(0xFF1565C0),
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: const [
              _Paragraph(
                "L'auteur de l'infraction est celui qui commet personnellement, dans les "
                "conditions prévues par le texte d’incrimination, les actes prévus et réprimés "
                "par ce texte.",
              ),
              SizedBox(height: 8),
              _Paragraph(
                "L'infraction peut être le fait de plusieurs personnes qui seront selon les cas "
                "coauteurs, ou auteurs et complices.",
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ========================= CHAPITRE 1 : COACTION =========================
          _ConditionCard(
            title: 'Chapitre 1 — Les conditions de la coaction',
            cardColor: isDark
                ? const Color(0xFF20302E)
                : const Color(0xFFE0F2F1),
            accent: const Color(0xFF00897B),
            titleColor: isDark ? Colors.white : const Color(0xFF004D40),
            children: const [
              _SubTitle('1.1 — Le principe'),
              _Paragraph(
                "Si plusieurs personnes participent à égalité à la réalisation de l’infraction, "
                "elles sont coauteurs : elles sont toutes auteur principal de l’infraction car "
                "chacune a personnellement commis les éléments matériel et moral "
                "pénalement sanctionnés par la loi.",
              ),
              SizedBox(height: 12),
              _SubTitle('1.2 — Difficulté d’application'),
              _Paragraph(
                "Il peut être parfois difficile de déterminer avec précision le rôle exact joué "
                "par chaque participant, notamment dans le cas d’une infraction collective.",
              ),
            ],
          ),

          const SizedBox(height: 12),

          _ConditionCard(
            title: 'Coaction : approche jurisprudentielle',
            cardColor: isDark
                ? const Color(0xFF221C2A)
                : const Color(0xFFF3E5F5),
            accent: const Color(0xFF7B1FA2),
            titleColor: isDark ? Colors.white : const Color(0xFF4A148C),
            children: [
              _Paragraph.rich([
                _t(
                  "La jurisprudence qualifie de coauteurs l’ensemble des membres du groupe "
                  "ayant participé à l’infraction. Ainsi, en matière de violences, si plusieurs "
                  "individus y ont participé, ils sont qualifiés de coauteurs (Cass. crim. 1er oct. 1984).\n\n"
                  "Il arrive que des coauteurs soient considérés comme des complices : c’est la théorie "
                  "de la complicité corespective. Ce procédé a perdu beaucoup d’intérêt car aujourd’hui "
                  "le complice est puni comme auteur.\n\n"
                  "La jurisprudence a tendance à considérer comme coauteurs ceux qui participent "
                  "à la commission de l’infraction, même s’ils n’ont pas réalisé directement "
                  "l’élément matériel.\n"
                  "Exemple : celui qui fait le guet pendant l’exécution d’un vol.",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 16),

          // ========================= CHAPITRE 2 : COMPLICITÉ =========================
          _ConditionCard(
            title: 'Chapitre 2 — Les conditions de la complicité',
            cardColor: isDark
                ? const Color(0xFF2A1A1A)
                : const Color(0xFFFFEBEE),
            accent: const Color(0xFFC62828),
            titleColor: isDark ? Colors.white : const Color(0xFFB71C1C),
            children: [
              _Paragraph.rich([
                _t(
                  "La complicité consiste en l’entente momentanée entre deux ou plusieurs personnes "
                  "dans le but d’accomplir une infraction déterminée. Le complice est celui qui aide "
                  "l’auteur dans la préparation ou l’exécution de l’infraction. Il participe "
                  "intentionnellement à la commission de l’infraction par la réalisation d’un acte matériel.\n\n"
                  "Elle est définie par ",
                ),
                _red("l’article 121-7 du Code pénal"),
                _t(". "),
                _t(
                  "Le Code pénal assimile le complice à l’auteur au niveau de la répression (",
                ),
                _red("article 121-6 du Code pénal"),
                _t(")."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // ---- 2.1 Conditions relatives au fait principal ----
          _ConditionCard(
            title: '2.1 — Conditions relatives au fait principal',
            cardColor: isDark
                ? const Color(0xFF1E2A1F)
                : const Color(0xFFE8F5E9),
            accent: const Color(0xFF2E7D32),
            titleColor: isDark ? Colors.white : const Color(0xFF1B5E20),
            children: const [
              _Paragraph(
                "L’acte de complicité n’est pas punissable en tant que tel. Il doit se rattacher "
                "à un fait principal punissable : c’est une criminalité d’emprunt.",
              ),
            ],
          ),

          const SizedBox(height: 12),

          _ConditionCard(
            title:
                '2.1.1 — Existence d’une infraction (fait principal punissable)',
            cardColor: isDark
                ? const Color(0xFF1A2333)
                : const Color(0xFFE8EAF6),
            accent: const Color(0xFF3F51B5),
            titleColor: isDark ? Colors.white : const Color(0xFF1A237E),
            children: const [
              _SubTitle('2.1.1.1 — Principe'),
              _Paragraph(
                "La complicité suppose l’existence d’un fait prévu et réprimé par les textes. "
                "Si le fait principal échappe pour une raison quelconque à la loi pénale, "
                "le complice ne pourra être puni.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: 'Exemple',
                bodySpans: [
                  TextSpan(
                    text:
                        "Le suicide n’est pas incriminé en droit français : celui qui en favorise "
                        "l’accomplissement ne sera pas poursuivi comme complice, mais éventuellement "
                        "sur la base d’un délit distinct (ex. provocation au suicide).",
                  ),
                ],
              ),
              SizedBox(height: 10),
              _Paragraph(
                "La complicité de tentative est punissable. En revanche, si l’auteur principal "
                "n’a effectué que des actes préparatoires ou s’est désisté volontairement, "
                "le complice ne peut être poursuivi : « la tentative de complicité » "
                "n’est pas punissable.",
              ),
              SizedBox(height: 10),
              _SubTitle(
                'Cas où la complicité ne pourra pas être retenue',
              ),
              _BulletPoint(
                text:
                    "Lorsque le fait principal est justifié par la légitime défense, l’ordre de la loi "
                    "ou le commandement de l’autorité légitime.",
              ),
              _BulletPoint(
                text:
                    "Si le fait principal n’est plus punissable suite à prescription de l’action publique "
                    "ou en cas d’amnistie.",
              ),
            ],
          ),

          const SizedBox(height: 12),

          _ConditionCard(
            title: '2.1.1.2 — La répression de l’acte principal importe peu',
            cardColor: isDark
                ? const Color(0xFF2B2B1A)
                : const Color(0xFFFFF8E1),
            accent: const Color(0xFFF9A825),
            titleColor: isDark ? Colors.white : const Color(0xFF5D4037),
            children: const [
              _Paragraph(
                "Le complice peut être poursuivi même si l’auteur principal n’est pas puni, "
                "notamment lorsque :",
              ),
              _IntroBullet(text: "L’auteur est en fuite ou inconnu."),
              _IntroBullet(text: "L’auteur est décédé."),
              _IntroBullet(
                text:
                    "L’auteur bénéficie d’une cause d’irresponsabilité (trouble neuro-psychique, minorité) "
                    "ou d’une exemption légale de peine.",
              ),
            ],
          ),

          const SizedBox(height: 12),

          _ConditionCard(
            title: '2.1.2 — Un fait principal qualifié crime ou délit',
            cardColor: isDark
                ? const Color(0xFF1E2D2D)
                : const Color(0xFFE0F7FA),
            accent: const Color(0xFF00838F),
            titleColor: isDark ? Colors.white : const Color(0xFF006064),
            children: [
              _Paragraph.rich([
                _t("Selon "),
                _red("l’article 121-7 du Code pénal"),
                _t(
                  ", tous les crimes et délits sont en principe susceptibles de complicité.",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 12),

          _ConditionCard(
            title: '2.1.3 — En matière de contraventions',
            cardColor: isDark
                ? const Color(0xFF231F2A)
                : const Color(0xFFF3E5F5),
            accent: const Color(0xFF8E24AA),
            titleColor: isDark ? Colors.white : const Color(0xFF4A148C),
            children: [
              _Paragraph.rich([
                _t(
                  "La complicité par provocation ou instructions est systématiquement réprimée (",
                ),
                _red("article R. 610-2 du Code pénal"),
                _t(")."),
              ]),
              const SizedBox(height: 8),
              const _Paragraph(
                "La complicité par aide ou assistance n’est réprimée que si un texte le prévoit expressément.",
              ),
              const SizedBox(height: 8),
              const _NotaBox(
                title: 'Exemples',
                bodySpans: [
                  TextSpan(
                    text:
                        "Article R. 623-2 du Code pénal : aide/assistance aux auteurs de tapages injurieux ou nocturnes.\n"
                        "Article R. 624-1 du Code pénal : complicité de violences légères.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ---- 2.2 Participation au fait principal ----
          _ConditionCard(
            title: '2.2 — La participation au fait principal',
            cardColor: isDark
                ? const Color(0xFF1B263B)
                : const Color(0xFFE8EAF6),
            accent: const Color(0xFF303F9F),
            titleColor: isDark ? Colors.white : const Color(0xFF1A237E),
            children: [
              const _SubTitle('2.2.1 — Participation matérielle'),
              _Paragraph.rich([
                _t("Les actes de participation sont énumérés par "),
                _red("l’article 121-7 du Code pénal"),
                _t("."),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Les actes doivent être positifs : l’abstention ne peut pas constituer un acte de complicité "
                    "(le simple spectateur n’est pas complice).",
              ),
              const _BulletPoint(
                text:
                    "Les actes doivent être antérieurs ou concomitants : il n’existe pas de complicité postérieure "
                    "à l’infraction.",
              ),
            ],
          ),

          const SizedBox(height: 12),

          _ConditionCard(
            title:
                '2.2.1.2 — Les actes de complicité (Article 121-7 du Code pénal)',
            cardColor: isDark
                ? const Color(0xFF2A1E12)
                : const Color(0xFFFFF3E0),
            accent: const Color(0xFFEF6C00),
            titleColor: isDark ? Colors.white : const Color(0xFFE65100),
            children: const [
              _SubTitle('A) La provocation'),
              _BulletPoint(
                text:
                    "La provocation doit être accompagnée de don, promesse, ordre, menace, abus d’autorité ou de pouvoir. "
                    "Le simple conseil ne suffit pas.",
              ),
              _BulletPoint(
                text:
                    "Elle doit être individuelle (adressée à une personne déterminée).",
              ),
              _BulletPoint(
                text:
                    "Elle doit être suivie d’effets : l’infraction doit être réalisée ou au moins tentée.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: 'Exemple',
                bodySpans: [
                  TextSpan(
                    text:
                        "Provocation aux délits de trafic ou d’usage de stupéfiants : Article L. 3421-4 du Code de la santé publique.",
                  ),
                ],
              ),
              SizedBox(height: 12),
              _SubTitle('B) La fourniture d’instructions'),
              _Paragraph(
                "Il s’agit d’indications précises, données en connaissance de cause, de nature à faciliter "
                "l’exécution d’une infraction.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: 'Exemple',
                bodySpans: [
                  TextSpan(
                    text:
                        "Indiquer, en vue d’un cambriolage, les heures où une personne est absente de chez elle.",
                  ),
                ],
              ),
              SizedBox(height: 12),
              _SubTitle('C) L’aide ou l’assistance'),
              _Paragraph(
                "L’acte doit avoir facilité la préparation ou la consommation de l’infraction. "
                "Cela peut être la fourniture de moyens matériels ou un concours apporté à l’auteur "
                "au moment de la préparation ou de la réalisation.",
              ),
            ],
          ),

          const SizedBox(height: 12),

          _ConditionCard(
            title: '2.2.2 — L’intention de participer à l’infraction',
            cardColor: isDark
                ? const Color(0xFF102027)
                : const Color(0xFFE0F7FA),
            accent: const Color(0xFF00ACC1),
            titleColor: isDark ? Colors.white : const Color(0xFF006064),
            children: const [
              _Paragraph(
                "L’intention criminelle du complice doit réunir deux conditions :",
              ),
              _BulletPoint(
                text:
                    "Connaissance du caractère délictueux des actes envisagés ou réalisés par l’auteur.",
              ),
              _BulletPoint(
                text:
                    "Volonté de s’associer à l’acte délictueux : auteur et complice ont agi « ensemble et de concert » "
                    "en vue d’obtenir le résultat délictueux.",
              ),
            ],
          ),

          const SizedBox(height: 12),

          _ConditionCard(
            title: '2.2.3 — Cas particulier : le “happy slapping”',
            cardColor: isDark
                ? const Color(0xFF2E1A1A)
                : const Color(0xFFFFEBEE),
            accent: const Color(0xFFB71C1C),
            titleColor: isDark ? Colors.white : const Color(0xFFB71C1C),
            children: [
              _Paragraph.rich([
                _red("L’article 222-33-3, alinéa 1, du Code pénal"),
                _t(
                  " prévoit qu’est constitutif d’un acte de complicité des atteintes volontaires "
                  "à l’intégrité de la personne le fait d’enregistrer sciemment, par quelque moyen "
                  "que ce soit, des images relatives à la commission de ces infractions.",
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                _t("Sont visées notamment les atteintes prévues par "),
                _red(
                  "les articles 222-1 à 222-14-1 et 222-23 à 222-31 et 222-33 du Code pénal",
                ),
                _t("."),
              ]),
              const SizedBox(height: 8),
              const _NotaBox(
                title: 'Idée clé',
                bodySpans: [
                  TextSpan(
                    text:
                        "Le législateur assimile l’enregistrement à un cas de complicité : l’enregistrement doit être réalisé sciemment.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ========================= CHAPITRE 3 : RÉPRESSION =========================
          _ConditionCard(
            title: 'Chapitre 3 — La répression de la complicité',
            cardColor: isDark
                ? const Color(0xFF1A1F2A)
                : const Color(0xFFE8EAF6),
            accent: const Color(0xFF3949AB),
            titleColor: isDark ? Colors.white : const Color(0xFF1A237E),
            children: [
              _Paragraph.rich([
                _t("Selon "),
                _red("l’article 121-6 du Code pénal"),
                _t(", le complice est puni comme auteur."),
              ]),
              const SizedBox(height: 10),
              const _SubTitle('3.1 — Sens de la règle'),
              const _Paragraph(
                "Les peines encourues par l’auteur et le complice sont identiques, mais le juge "
                "n’a pas l’obligation de prononcer des peines identiques.",
              ),
              const SizedBox(height: 10),
              const _SubTitle('3.2 — Application de la règle'),
              const _Paragraph(
                "Le complice peut être puni plus sévèrement que l’auteur principal si des circonstances "
                "aggravantes lui sont personnelles, ou si l’auteur bénéficie de circonstances atténuantes. "
                "Inversement, la peine du complice peut aussi être inférieure selon les circonstances.",
              ),
            ],
          ),

          const SizedBox(height: 12),

          _ConditionCard(
            title: '3.2.1 — Circonstances personnelles à l’auteur',
            cardColor: isDark
                ? const Color(0xFF1E2D2D)
                : const Color(0xFFE0F7FA),
            accent: const Color(0xFF00838F),
            titleColor: isDark ? Colors.white : const Color(0xFF006064),
            children: const [
              _Paragraph(
                "Qu’elles aggravent ou atténuent la culpabilité de l’auteur, ces circonstances "
                "ne s’appliquent pas au complice.",
              ),
              SizedBox(height: 8),
              _NotaBox(
                title: 'Exemples',
                bodySpans: [
                  TextSpan(
                    text:
                        "Démence ou contrainte ; qualité de récidiviste de l’auteur principal.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          _ConditionCard(
            title: '3.2.2 — Circonstances réelles (liées à l’acte)',
            cardColor: isDark
                ? const Color(0xFF2A1E12)
                : const Color(0xFFFFF3E0),
            accent: const Color(0xFFEF6C00),
            titleColor: isDark ? Colors.white : const Color(0xFFE65100),
            children: const [
              _Paragraph(
                "Ce sont des circonstances de fait qui modifient la nature de l’infraction : "
                "elles aggravent ou atténuent la peine applicable au complice.",
              ),
              SizedBox(height: 8),
              _Paragraph(
                "Elles peuvent aggraver l’infraction (ex. réunion pour le vol). L’aggravation "
                "s’étend au complice même s’il ignorait l’existence de la circonstance.",
              ),
            ],
          ),

          const SizedBox(height: 12),

          _ConditionCard(
            title: '3.2.3 — Circonstances mixtes',
            cardColor: isDark
                ? const Color(0xFF221C2A)
                : const Color(0xFFF3E5F5),
            accent: const Color(0xFF7B1FA2),
            titleColor: isDark ? Colors.white : const Color(0xFF4A148C),
            children: [
              const _Paragraph(
                "Les circonstances mixtes concernent à la fois la personne et l’acte : elles procèdent "
                "de l’auteur et se répercutent sur l’acte en modifiant la nature de l’infraction "
                "(ex. fonctions, lien familial, préméditation).",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                _t(
                  "La question de leur applicabilité au complice a été tranchée par la Cour de cassation : ",
                ),
                _t(
                  "dans un arrêt n° 04-84.235 du 7 septembre 2005, elle a admis que ",
                ),
                _t(
                  "« sont applicables au complice des circonstances aggravantes liées à la qualité de l’auteur principal ».\n\n",
                ),
                _t("La formulation de "),
                _red("l’article 121-6 du Code pénal"),
                _t(
                  " semblait pourtant privilégier le caractère personnel de la circonstance.",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 16),

          // ========================= TABLEAU (en format lisible) =========================
          _ConditionCard(
            title: 'Tableau — La complicité (synthèse)',
            cardColor: isDark
                ? const Color(0xFF172027)
                : const Color(0xFFE1F5FE),
            accent: const Color(0xFF0277BD),
            titleColor: isDark ? Colors.white : const Color(0xFF01579B),
            children: [
              const _SubTitle('1) Un fait principal punissable'),
              const _BulletPoint(
                text:
                    'Existence d’une infraction commise par l’auteur principal.',
              ),
              const _BulletPoint(text: 'Crime ou délit (en principe).'),
              const _BulletPoint(
                text:
                    'Contravention : complicité par provocation/instructions ; et certaines contraventions prévues par des textes spéciaux.',
              ),
              const SizedBox(height: 10),
              const _SubTitle('2) Une participation à l’infraction'),
              _Paragraph.rich([
                _t("Actes positifs, antérieurs ou concomitants. "),
                _t("Référence : "),
                _red("Article 121-7 du Code pénal"),
                _t("."),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text: 'Provocation (don, promesse, menace, ordre, abus…).',
              ),
              const _BulletPoint(text: 'Fourniture d’instructions.'),
              const _BulletPoint(
                text: 'Aide ou assistance (moyens, concours).',
              ),
              const SizedBox(height: 10),
              const _SubTitle('3) Une intention criminelle'),
              const _BulletPoint(
                text: 'Connaissance du caractère délictueux du fait principal.',
              ),
              const _BulletPoint(
                text:
                    'Volonté de s’associer à l’acte délictueux (ensemble et de concert).',
              ),
            ],
          ),

          const SizedBox(height: 12),
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
