import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EtrangersGeneralitesPage extends StatelessWidget {
  const EtrangersGeneralitesPage({super.key});

  static const String routeName =
      '/gpx/pv_apj20/procedures_speciales/etrangers/generalites';

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
    final Color cardCond = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardModal = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardVigi = isDark
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

    TextSpan law(String t) => TextSpan(
      text: t,
      style: const TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
    );

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
          "Procédures spéciales",
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
            "Contrôle de la situation des étrangers",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Définition / principe
          _ConditionCard(
            title: "Principe",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Toute personne de nationalité étrangère doit pouvoir présenter aux forces de l’ordre les pièces ou documents l’autorisant à circuler ou séjourner en France — ",
                ),
                law("art. L. 812-1 du CESEDA"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Ce contrôle n’est possible que si des circonstances extérieures à la personne permettent d’en déduire sa qualité d’étranger — ",
                ),
                law("art. L. 812-2 du CESEDA"),
                const TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut (base juridique opérationnelle)
          _ConditionCard(
            title: "I — Base légale & conditions de déclenchement",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              const _SubTitle("Ce qu’il faut retenir"),
              const _Paragraph(
                "Le contrôle de la situation d’un étranger n’est jamais “automatique”.\n"
                "Il doit reposer sur des éléments objectifs d’extranéité et exclure toute discrimination.",
              ),
              const SizedBox(height: 12),
              _NotaBox(
                bodySpans: [
                  const TextSpan(text: "Fondement central : "),
                  law("art. L. 812-2 du CESEDA"),
                  const TextSpan(
                    text:
                        " (circonstances extérieures à la personne → qualité d’étranger).",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // I — Cas de contrôle
          _ConditionCard(
            title: "II — Cas de contrôle de régularité (circulation / séjour)",
            cardColor: cardCond,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Après un contrôle d’identité"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Lors d’un contrôle d’identité réalisé sur le fondement des articles ",
                ),
                law("78-1, 78-2, 78-2-1 et 78-2-2 du CPP"),
                const TextSpan(
                  text:
                      ", la personne doit justifier de son identité. Si le contrôle révèle une nationalité étrangère, elle peut être tenue de présenter les documents de circulation / séjour — ",
                ),
                law("art. L. 812-2 (2°) du CESEDA"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "La déduction de la nationalité doit reposer sur des critères objectifs excluant toute discrimination. La simple évocation “être né à l’étranger” sans précisions ne suffit pas.",
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const _SubTitle(
                "B) Qualité d’étranger apparente (sans contrôle d’identité préalable)",
              ),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Le contrôle peut être effectué directement si des éléments objectifs d’extranéité, extérieurs à la personne, permettent d’en déduire la qualité d’étranger — ",
                ),
                law("art. L. 812-2 (1°) du CESEDA"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "Exemples jurisprudentiels (liste non exhaustive) :\n"
                "• véhicule immatriculé à l’étranger ;\n"
                "• participation à une manifestation avec banderoles étrangères ;\n"
                "• tracts / affiches en langue étrangère ;\n"
                "• entrée/sortie d’un consulat/ambassade ;\n"
                "• document d’identité étranger en main ;\n"
                "• déclaration spontanée de sa qualité d’étranger, etc.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Sont à exclure : couleur de peau, langue parlée, tenue vestimentaire… (risque de discrimination).",
                  ),
                ],
                title: "VIGILANCE",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Durée : "),
                const TextSpan(
                  text: "pas de contrôle systématique",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: " et "),
                const TextSpan(
                  text: "maximum 6 heures consécutives dans un même lieu",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 14),
              const _SubTitle("C) Visite sommaire d’un véhicule"),
              _Paragraph.rich([
                const TextSpan(text: "Cadre : "),
                law("art. L. 812-3 et suivants du CESEDA"),
                const TextSpan(
                  text:
                      ". Compétence exclusive de l’OPJ (assisté éventuellement d’APJ/APJA).",
                ),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "Zones concernées (exemples) :\n"
                "• bande 20 km en deçà de la frontière terrestre Schengen ;\n"
                "• bande 20 km en deçà du littoral dans certains départements (arrêté) ;\n"
                "• rayon max 10 km autour de ports/aéroports (arrêté) ;\n"
                "• aires / péages autoroutiers liés à ces zones.",
              ),
              const SizedBox(height: 10),
              const _Paragraph("Mise en œuvre :"),
              const SizedBox(height: 6),
              const _BulletPoint(text: "Avec l’accord du conducteur, ou"),
              const _BulletPoint(
                text:
                    "À défaut, sur instructions du procureur de la République.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "But : vérifier le respect des obligations de détention, port et présentation des documents "
                "ou rechercher/constater les infractions relatives à l’entrée et au séjour des étrangers en France.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Immobilisation : "),
                const TextSpan(
                  text: "4 heures maximum",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                const TextSpan(
                  text:
                      " dans l’attente des instructions du procureur. Sans instructions à l’issue : libre de repartir.",
                ),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "La retenue ne s’applique pas au conducteur : il peut téléphoner librement (sauf procédure incidente). "
                        "Des dispositions similaires existent pour navires/engins flottants.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // II — Vérification du droit au séjour
          _ConditionCard(
            title: "III — Vérification du droit au séjour",
            cardColor: cardModal,
            accent: accentPink,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Entrée et documents"),
              const _Paragraph(
                "Pour entrer en France : passeport ou carte d’identité en cours de validité, visa éventuel…\n"
                "UE/EEE/Suisse : pas de visa, mais document d’identité valide.\n"
                "Certaines nationalités peuvent être dispensées de visa (références internes D.C.P.A.F).",
              ),
              const SizedBox(height: 12),
              const _SubTitle("B) Séjour au-delà de 3 mois"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Au-delà de 3 mois, l’étranger de plus de 18 ans doit détenir un document de séjour — ",
                ),
                law("art. L. 411-1 du CESEDA"),
                const TextSpan(
                  text:
                      " (visa long séjour, cartes de séjour, carte de résident, etc.).",
                ),
              ]),
              const SizedBox(height: 12),
              const _SubTitle("C) Mineurs étrangers"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Les mineurs étrangers résidant en France peuvent obtenir de plein droit un document de circulation (5 ans) sous conditions — ",
                ),
                law("art. L. 414-4 à L. 414-9 du CESEDA"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 12),
              const _SubTitle("D) Fraude à l’identité / usage frauduleux"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "L’utilisation par un porteur autre que le titulaire légitime d’un document authentique constitue une fraude à l’identité — ",
                ),
                law("art. 441-8 du Code pénal"),
                const TextSpan(
                  text:
                      ". Cela vise aussi l’usage frauduleux des titres de séjour et documents provisoires.",
                ),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Tous les titres de séjour sont sécurisés : un examen attentif peut révéler un faux ou au minimum des anomalies justifiant vérifications OPJ.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Retenue vérification droit au séjour
          _ConditionCard(
            title: "IV — Retenue pour vérification du droit au séjour",
            cardColor: cardVigi,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "La retenue intervient lorsque la personne n’a pas justifié de son droit à circuler ou séjourner par la présentation de pièces et documents — ",
                ),
                law("art. L. 813-1 du CESEDA"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "Nature : procédure administrative.\n"
                "Finalité : examens de situation administrative et/ou décisions administratives la concernant.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Durée maximale : "),
                const TextSpan(
                  text: "24 heures",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: " à compter du début du contrôle."),
              ]),
              const SizedBox(height: 12),
              const _SubTitle("Compétence & contrôle"),
              const _Paragraph(
                "Placement : compétence exclusive de l’OPJ, sous le contrôle du procureur de la République.",
              ),
              const SizedBox(height: 12),
              const _SubTitle("Droits de la personne"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "La personne bénéficie de droits : interprète, avocat, examen médical, avis à une personne de son choix, autorités consulaires…\n"
                      "Notification : motifs, durée max et droits dans une langue comprise, par OPJ (ou APJ sous contrôle) — ",
                ),
                law("art. L. 813-5 du CESEDA"),
                const TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Synthèse actionnable
          _ConditionCard(
            title: "Synthèse terrain (mémo rapide)",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _IntroBullet(
                text:
                    "Toujours rattacher l’acte à une base légale CESEDA (et CPP si contrôle d’identité).",
              ),
              _IntroBullet(
                text:
                    "Exclure tout critère discriminatoire : uniquement des éléments objectifs et extérieurs.",
              ),
              _IntroBullet(
                text:
                    "Visite sommaire véhicule : OPJ uniquement, accord conducteur ou instructions parquet, immobilisation max 4 h.",
              ),
              _IntroBullet(
                text:
                    "Retenue vérification séjour : administrative, max 24 h, droits notifiés (interprète/avocat/médecin/avis).",
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
