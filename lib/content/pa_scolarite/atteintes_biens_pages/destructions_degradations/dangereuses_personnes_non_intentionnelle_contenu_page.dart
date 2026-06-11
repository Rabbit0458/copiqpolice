import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaDestructionsDangereusesPersonnesNonIntentionnellePage
    extends StatelessWidget {
  const PaDestructionsDangereusesPersonnesNonIntentionnellePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/atteintes_biens/destructions_degradations/dangereuses_personnes_non_intentionnelle';

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
          "Destructions, dégradations",
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
            "Les destructions, dégradations et détériorations dangereuses pour les personnes (infraction non intentionnelle)",
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
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "La destruction, la dégradation ou la détérioration involontaire d’un bien appartenant à autrui "
                "par l’effet d’une explosion ou d’un incendie provoqués par manquement à une obligation de prudence "
                "ou de sécurité imposée par la loi ou le règlement, constitue une infraction.",
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
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text: "Article 322-5 alinéa 1 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : définit et réprime les destructions, dégradations ou détériorations involontaires et dangereuses pour les personnes.",
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
            children: const [
              _SubTitle(
                "A) Un manquement à une obligation de prudence ou de sécurité",
              ),
              _Paragraph(
                "Le « règlement » s’entend des actes des autorités administratives à caractère général et impersonnel. "
                "L’inobservation d’une obligation textuelle se suffit à elle-même : il n’est pas nécessaire de se référer "
                "aux devoirs généraux de prudence et de diligence.\n"
                "Les magistrats doivent pouvoir préciser la source et la nature exacte de l’obligation violée.",
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Cass. crim., 18 juin 2002",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : la source et la nature de l’obligation doivent être précisément identifiées.",
                ),
              ]),
              SizedBox(height: 12),
              _Paragraph(
                "Dans tous les cas, on reproche à l’auteur de ne pas avoir pris les précautions nécessaires : "
                "s’il avait respecté l’obligation de prudence/sécurité, le dommage n’aurait pas été causé.",
              ),

              SizedBox(height: 14),

              _SubTitle(
                "B) Une atteinte matérielle mettant en danger les personnes",
              ),
              _Paragraph(
                "L’ensemble des moyens doit être de nature à mettre en danger les personnes.",
              ),
              SizedBox(height: 10),

              _SubTitle("1) L’effet d’une explosion"),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 322-5 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " vise l’effet d’une explosion pouvant résulter d’un acte involontaire "
                      "(ex. infraction au code de la route entraînant le choc avec un camion-citerne, "
                      "inobservation d’un règlement en fumant dans un dépôt de carburant ou une station-service…).",
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle("2) L’incendie"),
              _Paragraph(
                "L’incendie consiste à allumer un feu (combustion rapide et brutale). "
                "Le commencement d’exécution s’étend des premiers actes révélant l’intention coupable "
                "jusqu’au moment de l’embrasement du bien.\n"
                "L’incendie se distingue du simple feu par ses conséquences : il se propage, n’est pas maîtrisé "
                "et représente un danger pour les personnes. Pour cette raison, la qualification de l’article 322-5 "
                "est retenue plutôt que celle de 322-1.",
              ),

              SizedBox(height: 14),

              _SubTitle("C) Sur un bien appartenant à autrui"),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 322-5 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " protège très largement les biens (immeubles, forêts, meubles, registres, documents, véhicules…). "
                      "Le bien endommagé ou détruit doit appartenir à une autre personne que l’auteur.",
                ),
              ]),

              SizedBox(height: 14),

              _SubTitle("D) Entraînant un dommage"),
              _Paragraph(
                "Le texte vise trois résultats : destruction, dégradation, détérioration.",
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    "Destruction : acte le plus grave, le bien devient impropre à l’usage (totale ou partielle).",
              ),
              _BulletPoint(
                text:
                    "Dégradation : diminution des qualités du bien, sans le rendre inutilisable.",
              ),
              _BulletPoint(
                text:
                    "Détérioration : perte de valeur mais bien réparable et encore apte à son rôle.",
              ),

              SizedBox(height: 14),

              _SubTitle("E) Un lien de causalité"),
              _Paragraph(
                "Le manquement doit avoir concouru au dommage. La causalité n’a pas à être immédiate : "
                "le fait peut engendrer un dommage qui s’aggrave ensuite.\n"
                "La loi distingue la causalité directe et la causalité indirecte.",
              ),
              SizedBox(height: 10),

              _SubTitle("• Causalité indirecte"),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 121-3 alinéa 4 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : sont auteurs indirects ceux qui, sans être directement à l’origine du dommage, ont créé ou contribué à créer "
                      "la situation ayant permis sa réalisation, ou n’ont pas pris les mesures permettant de l’éviter.",
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                "Ils ne sont pas à l’origine du dommage lui-même, mais à l’origine de la situation dangereuse "
                "ou de l’absence de mesures de prévention.",
              ),

              SizedBox(height: 12),

              _SubTitle("• Causalité directe"),
              _Paragraph(
                "La circulaire d’application du 11 octobre 2000 parle de causalité immédiate. "
                "Le lien est direct lorsque l’imprudence ou la négligence reprochée est la cause unique/exclusive, "
                "ou la cause immédiate/déterminante du dommage.",
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
            children: const [
              _SubTitle(
                "Agir en méconnaissant une exigence légale ou réglementaire",
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Il ne s’agit pas de n’importe quelle faute : l’auteur omet de respecter une obligation précise, "
                      "imposée par une loi ou un règlement, tendant à exiger le respect de normes de prudence ou de sécurité. "
                      "Cette méconnaissance fonde l’élément moral de l’infraction prévue par ",
                ),
                TextSpan(
                  text: "l’article 322-5 alinéa 1 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 12),
              _SubTitle("Forme aggravée"),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 322-5 alinéa 2 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : l’auteur méconnaît volontairement les exigences légales ou réglementaires, en toute connaissance des risques. "
                      "Il choisit de ne pas respecter les précautions et prend volontairement le risque de causer le dommage.",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes
          _ConditionCard(
            title: "IV — Circonstances aggravantes",
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "La répression diffère selon que l’incendie intervient dans les conditions des alinéas 1 ou 2 de l’article 322-5.",
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 322-5 alinéa 2 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : violation manifestement délibérée d’une obligation particulière de sécurité ou de prudence prévue par la loi ou le règlement.",
                ),
              ]),
              SizedBox(height: 12),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 322-5 alinéas 3 à 6 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " :"),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    "Incendie de bois, forêts, landes, maquis, plantations ou reboisements d’autrui.",
              ),
              _BulletPoint(
                text:
                    "Conditions exposant les personnes à un dommage corporel ou créant un dommage irréversible à l’environnement.",
              ),
              _BulletPoint(text: "ITT d’au moins 8 jours pour autrui."),
              _BulletPoint(text: "Mort d’une ou plusieurs personnes."),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité
          _ConditionCard(
            title: "V — Répression",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _SubTitle("Peines encourues — personnes physiques"),
              _Paragraph.rich([
                TextSpan(text: "Base : "),
                TextSpan(
                  text: "1 an d’emprisonnement et 15 000 € d’amende — ",
                ),
                TextSpan(
                  text: "article 322-5 alinéa 1 du Code pénal",
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
                  text: "Aggravée (violation manifestement délibérée) : ",
                ),
                TextSpan(
                  text: "2 ans d’emprisonnement et 30 000 € d’amende — ",
                ),
                TextSpan(
                  text: "article 322-5 alinéa 2 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                title: "Nota",
                bodySpans: [
                  TextSpan(
                    text:
                        "Les alinéas 3 à 6 augmentent les peines selon la nature de l’incendie (forêts/bois…), "
                        "le danger ou le résultat (exposition, ITT ≥ 8 jours, décès), et selon que l’on se situe sur le régime de l’alinéa 1 ou de l’alinéa 2.",
                  ),
                ],
              ),

              SizedBox(height: 12),

              _SubTitle("Personnes morales"),
              _Paragraph.rich([
                TextSpan(text: "Peines prévues par "),
                TextSpan(
                  text: "l’article 322-17 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 12),

              _SubTitle("Tentative & complicité"),
              _BulletPoint(text: "Tentative : NON."),
              _BulletPoint(text: "Complicité : NON."),
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
