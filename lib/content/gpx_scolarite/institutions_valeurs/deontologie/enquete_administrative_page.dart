import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EnqueteAdministrativePage extends StatelessWidget {
  const EnqueteAdministrativePage({super.key});

  static const String routeName =
      '/gpx/institution/deontologie/enquete_administrative';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardMat = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
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
          "Déontologie",
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
            "L’enquête administrative",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Définition / contexte
          _ConditionCard(
            title: "Définition",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Dans l’exercice de leurs missions, les fonctionnaires de la Police nationale sont soumis "
                "à des obligations issues du statut général de la fonction publique, du statut spécial, "
                "du code de déontologie et de la jurisprudence du Conseil d’État.\n\n"
                "Lorsque l’administration a connaissance de comportements susceptibles de constituer "
                "un manquement professionnel et/ou déontologique, une enquête administrative est ouverte.\n\n"
                "Elle constitue une phase d’investigation préalable à d’éventuelles poursuites disciplinaires : "
                "elle vise à circonstancier les faits, matérialiser les griefs, caractériser le manquement, "
                "et vérifier l’absence de cause d’exonération.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Références à connaître (en haut, en rouge)
          _ConditionCard(
            title: "Références (séparation admin / judiciaire)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Obligation de différencier enquête administrative et enquête judiciaire : ",
                ),
                TextSpan(
                  text: "note DGPN/PN/CAB n°2012-6371 du 22 octobre 2012",
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
                        "Même si certaines modalités peuvent se ressembler en pratique, leurs cadres juridiques et finalités sont distincts.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // I — Ouverture
          _ConditionCard(
            title: "I — Ouverture de l’enquête administrative",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "L’enquête administrative a pour objectif d’établir l’existence d’un manquement professionnel "
                "et/ou déontologique. Elle est initiée par l’autorité hiérarchique, même si le pouvoir disciplinaire "
                "appartient à l’autorité de nomination.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // II — Manquement + saisine
          _ConditionCard(
            title: "II — Manquement & saisine",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Notion de manquement"),
              const _Paragraph(
                "Aucun texte législatif ou réglementaire ne donne de définition légale du manquement "
                "déontologique ou professionnel.\n\n"
                "Selon l’IGPN (guide pratique de l’enquête administrative pré-disciplinaire), "
                "il s’agit de la violation d’un devoir, d’une obligation professionnelle ou d’une instruction, "
                "par omission ou commission, dans l’exercice ou hors l’exercice des fonctions, "
                "appréciée au regard de la qualité de policier.",
              ),
              const SizedBox(height: 12),
              const _SubTitle(
                "B) Saisine : comment l’administration est informée",
              ),
              const _Paragraph(
                "Le déclenchement est subordonné à la connaissance par l’administration d’un comportement "
                "susceptible de constituer un manquement.\n\n"
                "L’administration peut être avisée par de nombreux moyens :",
              ),
              const SizedBox(height: 8),
              const _IntroBullet(text: "Dénonciations (courriers, courriels)."),
              const _IntroBullet(text: "Remise de vidéos, supports audios."),
              const _IntroBullet(
                text: "Surveillance / signalements sur les réseaux sociaux.",
              ),
              const _IntroBullet(
                text: "Dysfonctionnements constatés par la hiérarchie.",
              ),
              const _IntroBullet(text: "Révélations de l’autorité judiciaire."),
              const _IntroBullet(
                text:
                    "Intervention du Défenseur des droits, autorités indépendantes…",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Sujets
          _ConditionCard(
            title: "Sujets de l’enquête administrative",
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _SubTitle("A) Sujets actifs"),
              _IntroBullet(
                text:
                    "Ceux qui procèdent aux actes d’enquête (autorités habilitées, chefs de service, adjoints, services dédiés, services centraux…).",
              ),
              SizedBox(height: 12),
              _SubTitle("B) Sujets influents : le procureur de la République"),
              _Paragraph(
                "Le procureur relève de l’enquête judiciaire. Toutefois, la commission d’une infraction "
                "par un agent (en service ou hors service) caractérise souvent également un manquement "
                "déontologique ou professionnel, ce qui peut enrichir l’analyse administrative.",
              ),
              SizedBox(height: 12),
              _SubTitle("C) Sujets passifs"),
              _IntroBullet(
                text:
                    "Ceux sur lesquels s’exerce l’enquête (agents concernés).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // III — Séparation
          _ConditionCard(
            title:
                "III — Séparation : enquête administrative / enquête judiciaire",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _SubTitle("Pourquoi c’est différent ?"),
              _BulletPoint(
                text:
                    "L’enquête judiciaire est strictement encadrée (formalisme, nullités, prescriptions).",
              ),
              _BulletPoint(
                text:
                    "Les droits de la personne mise en cause y sont la contrepartie des pouvoirs de contrainte et d’investigation intrusifs.",
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    "L’enquête administrative n’est pas coercitive : pas de contrainte, pas de pouvoirs coercitifs.",
              ),
              _BulletPoint(
                text:
                    "Les finalités sont différentes : pénal (infraction) vs disciplinaire (manquement).",
              ),
              SizedBox(height: 12),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Un fonctionnaire participant à l’enquête pénale contre un agent ne peut pas réaliser l’audition administrative de celui-ci, et inversement.",
                  ),
                ],
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Néanmoins, les deux enquêtes peuvent coexister sur les mêmes faits : "
                "ils seront qualifiés d’infractions pénales en judiciaire et de manquements en administratif.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // IV — Actes
          _ConditionCard(
            title: "IV — Actes de l’enquête administrative",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "L’enquête administrative est conduite à charge et à décharge. "
                "Elle vise à éclairer l’autorité disciplinaire dans sa prise de décision. "
                "Elle comprend une large palette d’actes d’investigation.",
              ),
              const SizedBox(height: 10),
              const _SubTitle("1) Actes possibles"),
              const _BulletPoint(
                text:
                    "Acte de saisine : détaillé, reprenant les éléments motivant l’ouverture.",
              ),
              const _BulletPoint(
                text:
                    "Actes d’enquête variés : constatations, télégramme, MCI, rapports, fiches d’activités, notes de service, comptes rendus, rapports administratifs…",
              ),
              const _BulletPoint(text: "Convocations."),
              const _BulletPoint(text: "Auditions."),
              const _BulletPoint(text: "Acte de clôture."),
              const _BulletPoint(text: "Rapport de synthèse."),
              const _BulletPoint(text: "Notification des conclusions."),
              const SizedBox(height: 12),

              const _SubTitle("2) Convocations"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Délai raisonnable + mention sommaire des faits (référence : ",
                ),
                TextSpan(
                  text: "note PN/CAB n°2012-6567/D du 22 octobre 2012",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: ")."),
              ]),
              const SizedBox(height: 12),

              const _SubTitle("3) Auditions : règles clés"),
              const _BulletPoint(
                text:
                    "L’agent peut être assisté de la personne de son choix, à condition qu’elle n’ait pas de lien hiérarchique avec l’autorité enquêtrice.",
              ),
              const _BulletPoint(
                text:
                    "L’assistant n’intervient pas pendant l’audition ; il peut uniquement produire des observations écrites annexées au PV.",
              ),
              const SizedBox(height: 8),
              const _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Il n’existe pas de droit au silence en audition administrative : refuser de répondre peut être assimilé à un refus de rendre compte et constituer une faute.",
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "L’audition n’a pas de durée légale maximale. Si elle est longue, des temps de repos "
                "(pause méridienne, etc.) doivent être respectés afin d’éviter toute assimilation à une contrainte.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // V — Clôture
          _ConditionCard(
            title: "V — Clôture de l’enquête",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "L’enquête se termine lorsqu’il n’apparaît plus nécessaire d’effectuer des actes ou recherches : "
                "le service enquêteur estime disposer de tous les éléments utiles à la décision.",
              ),
              SizedBox(height: 12),
              _SubTitle("Deux questions clés à l’issue"),
              _BulletPoint(
                text:
                    "1) L’enquête prouve-t-elle l’existence d’un manquement professionnel ou d’une faute déontologique ?",
              ),
              _BulletPoint(
                text:
                    "2) Même si la responsabilité est engagée, est-il opportun d’engager des poursuites disciplinaires ?",
              ),
              SizedBox(height: 12),
              _SubTitle("Notification"),
              _Paragraph(
                "Le chef de service de l’agent mis en cause notifie les conclusions par procès-verbal administratif.",
              ),
              SizedBox(height: 12),
              _SubTitle("Issues possibles"),
              _BulletPoint(text: "Classement du dossier."),
              _BulletPoint(
                text:
                    "Ouverture d’une procédure disciplinaire si une sanction apparaît nécessaire.",
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
