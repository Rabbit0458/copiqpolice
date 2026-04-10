import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReglesEmploiPaPage extends StatelessWidget {
  const ReglesEmploiPaPage({super.key});

  static const String routeName =
      '/pa/institution/organisation_pn/regles_emploi_pa';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    // ✅ NE PAS utiliser copyWith sur TextSpan
    TextSpan lawSpan(String text) {
      return TextSpan(
        text: text,
        style: const TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // ... le reste de ton code ne change pas

    // Palette cards (propre + lisible)
    final Color cardIntro = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardRules = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardWork = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardDisci = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);

    final Color accentGrey = isDark ? Colors.white70 : const Color(0xFF616161);
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
          "Règles d'emploi — Policier Adjoint",
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
            "Les règles d'emploi des policiers adjoints",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Intro
          _ConditionCard(
            title: "Principe général",
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Salarié de l’État, le Policier Adjoint (P.A.) doit accepter et respecter les obligations liées à son emploi. "
                "Il doit notamment respecter les prescriptions du code de déontologie de la Police nationale.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut (usage arme)
          _ConditionCard(
            title: "Élément légal — emploi de l'arme",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "L'arme ne peut être employée que dans le strict cadre de la loi : ",
                ),
                lawSpan("article L. 435-1 du Code de la sécurité intérieure"),
                const TextSpan(text: " ou "),
                lawSpan("article 122-5 du Code pénal"),
                const TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Uniforme
          _ConditionCard(
            title: "Uniforme",
            cardColor: cardRules,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le policier adjoint exerce sa fonction revêtu de sa tenue d’uniforme.\n\n"
                "Toutefois, il peut être autorisé par son chef de service à porter la tenue civile lorsque la nature des missions le justifie.\n\n"
                "Le policier adjoint est responsable de ses effets d’uniforme.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Arme
          _ConditionCard(
            title: "Port de l'arme",
            cardColor: cardRules,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _SubTitle("A) Aptitude au port et à l’emploi"),
              _Paragraph(
                "L’aptitude au port et à l’emploi de l’arme de service relève de la compétence exclusive de la structure de formation "
                "et ne peut pas être délivrée postérieurement à la formation initiale par le service d’affectation.\n\n"
                "Si le policier adjoint présente une inaptitude définitive au port de l’arme, il est mis fin à son contrat sans indemnité ni préavis.",
              ),
              SizedBox(height: 10),
              _SubTitle("B) Règles de gestion"),
              _BulletPoint(
                text:
                    "Si le P.A. est doté d’une arme individuelle, il la retire à chaque prise de service et la restitue à l’issue du service quotidien.",
              ),
              _BulletPoint(
                text:
                    "Le port de l’arme est strictement réservé au seul cadre du service et nécessite le port de la tenue d’uniforme.",
              ),
              SizedBox(height: 10),
              _SubTitle("C) Incident (vol / perte / détérioration)"),
              _BulletPoint(
                text:
                    "Tout vol, perte ou détérioration de l’arme ou des munitions doit être immédiatement signalé.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Carte pro
          _ConditionCard(
            title: "Carte professionnelle",
            cardColor: cardRules,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Le policier adjoint doit porter sa carte professionnelle lorsqu’il est en service.\n\n"
                "Elle ne peut être utilisée qu’à des fins professionnelles. "
                "En aucun cas elle ne peut être prêtée ou reproduite. "
                "Elle doit être restituée à la fin du contrat.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: const [
                  TextSpan(
                    text:
                        "Le prêt, l’utilisation frauduleuse, la perte ou le vol liés à une négligence ou à une malveillance engagent la responsabilité disciplinaire du policier adjoint.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Matériel / locaux / véhicules
          _ConditionCard(
            title: "Locaux, matériels et véhicules de service",
            cardColor: cardRules,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le policier adjoint doit prendre soin des locaux, matériels et véhicules de service dont il a l’usage.\n\n"
                "Il ne peut les utiliser que dans le cadre du service et uniquement à des fins professionnelles.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Tout manquement expose le policier adjoint à des sanctions disciplinaires.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Régime de travail
          _ConditionCard(
            title: "Régime de travail",
            cardColor: cardWork,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _BulletPoint(
                text:
                    "Le régime horaire du P.A. est celui de son service/unité d’appartenance (de jour comme de nuit).",
              ),
              _BulletPoint(
                text:
                    "En cas d’événements graves ou importants, il peut être appelé à servir en tout temps et en tout lieu.",
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text: "Le P.A. ne peut pas travailler à temps partiel.",
              ),
              _BulletPoint(text: "Il n’est pas soumis à l’astreinte."),
              _BulletPoint(
                text:
                    "La permanence n’est possible que sur la base du volontariat.",
              ),
              _BulletPoint(
                text:
                    "Il peut faire l’objet d’un rappel au service, mais le report de repos ne lui est pas applicable.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Conduite véhicules
          _ConditionCard(
            title: "Conduite des véhicules de service",
            cardColor: cardWork,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Il appartient au service d’emploi de déterminer les critères et aptitudes qu’un policier adjoint doit remplir "
                "pour se voir confier la conduite d’un véhicule administratif (selon le type de mission : support/logistique, police secours).\n\n"
                "En principe, tant que le P.A. est titulaire du permis pendant la période probatoire, la conduite se limite aux missions "
                "ne revêtant aucun caractère de dangerosité.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Accès fichiers
          _ConditionCard(
            title: "Accès aux fichiers de police",
            cardColor: cardWork,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Agent de police judiciaire adjoint servant dans la Police nationale, le P.A. a accès aux fichiers nécessaires "
                "à l’exécution de ses missions uniquement dans le cadre des besoins professionnels.\n\n"
                "Cet accès s’effectue dans le respect absolu du secret professionnel et de la discrétion professionnelle.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Changement affectation
          _ConditionCard(
            title: "Changement d’affectation",
            cardColor: cardDisci,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _SubTitle("Ce que le policier adjoint peut faire"),
              _BulletPoint(
                text:
                    "Occuper successivement plusieurs postes au sein d’une structure de la Police nationale.",
              ),
              _BulletPoint(
                text:
                    "Changer de service au sein d’un même département (un avenant est apporté à son contrat).",
              ),
              SizedBox(height: 10),
              _SubTitle("Changement de département / permutation"),
              _BulletPoint(
                text: "Lors du renouvellement du contrat (avec avenant).",
              ),
              _BulletPoint(
                text:
                    "À titre dérogatoire ou en raison de circonstances graves et exceptionnelles survenues après le recrutement.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Discipline + IGPN
          _ConditionCard(
            title: "Régime disciplinaire & suspension de fonctions",
            cardColor: cardDisci,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Les sanctions disciplinaires applicables aux policiers adjoints sont prises par le préfet du département d’affectation.\n\n"
                "Elles sont, par ordre de gravité croissant :",
              ),
              SizedBox(height: 10),
              _BulletPoint(text: "Avertissement"),
              _BulletPoint(text: "Blâme"),
              _BulletPoint(
                text:
                    "Exclusion temporaire de fonctions (durée maximale : 3 jours).",
              ),
              _BulletPoint(
                text: "Exclusion temporaire de fonctions (4 jours à 6 mois).",
              ),
              _BulletPoint(text: "Licenciement sans préavis ni indemnité."),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "À titre conservatoire et dans l’intérêt du service, un policier adjoint peut être suspendu de ses fonctions par arrêté du préfet.",
                  ),
                ],
              ),
              SizedBox(height: 12),
              _Paragraph(
                "Au-delà du contrôle hiérarchique, le policier adjoint est soumis, comme les autres personnels, au contrôle de son activité.\n\n"
                "L’I.G.P.N. veille au respect, par les policiers, des lois et règlements et du code de déontologie de la Police nationale, "
                "et effectue les enquêtes qui lui sont confiées.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "Note importante",
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Retiens un réflexe simple : tenue, matériel, fichiers, carte pro, arme… tout s’utilise uniquement pour le service et dans le cadre légal. "
                        "En cas de doute, tu demandes au chef de service.",
                  ),
                ],
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
