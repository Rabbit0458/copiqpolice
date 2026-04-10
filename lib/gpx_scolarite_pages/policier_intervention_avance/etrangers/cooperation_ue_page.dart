import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CooperationUEPage extends StatelessWidget {
  const CooperationUEPage({super.key});

  static const String routeName = '/gpx/intervention/etrangers/cooperation-ue';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardPolice = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardServices = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardJud = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardInfo = isDark
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
          "Étrangers",
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
            "Coopération policière et judiciaire au sein de l’Union européenne",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          _ConditionCard(
            title: "Pourquoi c’est essentiel ?",
            cardColor: cardInfo,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "La création de l’espace Schengen (libre circulation) a nécessité un renforcement "
                "de la coopération policière et judiciaire entre États membres, afin de préserver la sécurité.",
              ),
              SizedBox(height: 10),
              _IntroBullet(
                text:
                    "Objectif : échanger rapidement des informations, coordonner les actions, et soutenir les enquêtes transfrontalières.",
              ),
              _IntroBullet(
                text:
                    "Principe : coopération organisée et encadrée, avec des canaux dédiés et des conditions strictes.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Cadre en haut (sans inventer d’articles)
          _ConditionCard(
            title: "Cadre (à retenir)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "La coopération repose sur des mécanismes transfrontaliers encadrés, "
                "notamment dans l’espace Schengen et au sein de l’UE, pour permettre :",
              ),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "l’observation transfrontalière (filature au-delà de la frontière, sans interpellation).",
              ),
              const _BulletPoint(
                text:
                    "la poursuite transfrontalière (continuer une poursuite dans un État voisin, sous conditions strictes).",
              ),
              const _BulletPoint(
                text:
                    "l’échange d’informations via des services dédiés (SCCOPOL, PCC, UCAP/Prüm, N-SIS II…).",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Ici, on retient surtout les définitions, les conditions et les canaux (qui contacter / comment faire).",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // I — COOP POLICIÈRE
          _ConditionCard(
            title: "I — Coopération policière",
            cardColor: cardPolice,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _SubTitle("A) Droit d’observation transfrontalière"),
              _Paragraph(
                "Il permet à un enquêteur de continuer, sous certaines conditions, une filature sur le territoire "
                "d’un État voisin membre de l’espace Schengen, sans interpellation possible.",
              ),
              SizedBox(height: 12),

              _SubTitle("1) Observation dite « ordinaire »"),
              _Paragraph(
                "Elle intervient dans le cadre d’une enquête judiciaire. La personne observée doit être présumée "
                "avoir participé (ou être susceptible de commettre) un fait puni d’une peine. "
                "Peuvent aussi être observées des personnes susceptibles de conduire à l’identification de l’intéressé.",
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    "Condition clé : autorisation préalable de l’État requis.",
              ),
              SizedBox(height: 8),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Pour les agents français : demande transmise via la ",
                  ),
                  TextSpan(
                    text: "S.C.C.O.P.O.L.",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),
              SizedBox(height: 12),

              _SubTitle("2) Observation « en urgence »"),
              _Paragraph(
                "Lorsque l’autorisation préalable ne peut pas être demandée pour des raisons particulièrement urgentes, "
                "l’agent peut continuer l’observation au-delà de la frontière pour certaines infractions graves "
                "(liste limitative : meurtre, viol, trafic de stupéfiants, vol aggravé, etc.).",
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    "Obligation : franchissement immédiatement porté à la connaissance de l’autorité centrale du pays concerné.",
              ),
              _BulletPoint(
                text:
                    "Puis : autorisation donnée a posteriori par cette autorité centrale.",
              ),
              SizedBox(height: 12),

              _SubTitle("B) Droit de poursuite transfrontalière"),
              _Paragraph(
                "Il permet à des policiers (O.P.J. ou A.P.J.) poursuivant une personne prise en flagrant délit "
                "d’une infraction grave (liste limitative), ou se trouvant en état d’arrestation provisoire / purgeant une peine, "
                "de continuer la poursuite sur le territoire d’un État voisin membre de l’espace Schengen.",
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    "Pas d’autorisation préalable en principe, mais conditions très strictes et modalités précises.",
              ),
              _BulletPoint(
                text:
                    "Dès le franchissement : alerter sans délai les autorités compétentes de l’État concerné.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "À retenir : c’est proche du droit d’observation, mais dans un contexte de poursuite immédiate.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Services de coopération
          _ConditionCard(
            title: "C) Services de coopération policière (France)",
            cardColor: cardServices,
            accent: accentPink,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Au sein de la D.N.P.J., la direction des relations internationales coordonne la coopération policière opérationnelle. "
                "Elle s’appuie sur plusieurs structures.",
              ),
              const SizedBox(height: 12),

              const _SubTitle("1) S.C.C.O.P.O.L."),
              const _Paragraph(
                "La Section Centrale de Coopération Opérationnelle de Police administre des organes de coopération internationale, "
                "dont notamment :",
              ),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Le B.C.N. France d’Interpol : coopération policière internationale (organisation mondiale).",
              ),
              const _BulletPoint(
                text:
                    "L’unité nationale Europol : lutte contre la criminalité organisée et le terrorisme, analyse et regroupements.",
              ),

              const SizedBox(height: 12),

              const _SubTitle("2) P.C.C. — Point de Contact Central"),
              const _Paragraph(
                "Il centralise les demandes nationales de coopération au sein de la SCCOPOL. "
                "Il vérifie la légalité, effectue les premiers recoupements et choisit le canal le plus adapté.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Astuce terrain : le PCC = la « tour de contrôle » qui oriente la demande sur le bon circuit.",
                  ),
                ],
              ),

              const SizedBox(height: 12),

              const _SubTitle("3) U.C.A.P. (Prüm)"),
              const _Paragraph(
                "L’unité de coordination et d’assistance Prüm traite les échanges d’informations consécutifs à un « hit » "
                "lors des comparaisons automatisées d’ADN ou d’empreintes digitales entre pays de l’UE.",
              ),

              const SizedBox(height: 12),

              const _SubTitle("4) Office N-SIS II"),
              const _Paragraph(
                "Il assure le bon fonctionnement et la sécurité du système N-SIS II (interface nationale du SIS).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // II — COOP JUDICIAIRE
          _ConditionCard(
            title: "II — Coopération judiciaire",
            cardColor: cardJud,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _SubTitle("A) Entraide judiciaire"),
              _Paragraph(
                "Une demande d’entraide judiciaire est adressée à une autorité étrangère pour exécuter un ou plusieurs actes judiciaires, "
                "dans le but de réprimer une infraction existante.",
              ),
              SizedBox(height: 12),

              _SubTitle("B) Équipes communes d’enquête (ECE)"),
              _Paragraph(
                "Des équipes communes d’enquête, regroupant plusieurs États membres, peuvent être créées en France "
                "dans le cadre d’une procédure judiciaire existante, notamment pour une enquête pénale complexe.",
              ),
              SizedBox(height: 12),

              _SubTitle(
                "C) C.C.P.D. — Centres de Coopération Policière et Douanière",
              ),
              _Paragraph(
                "Les CCPD rassemblent dans une même structure des agents de sécurité de la zone frontalière des États partenaires. "
                "Pour la France : Police nationale, Gendarmerie nationale et Douane y sont représentées.",
              ),
              SizedBox(height: 8),
              _BulletPoint(text: "Rôle : échange d’informations."),
              _BulletPoint(text: "Limite : aucun pouvoir opérationnel."),
              SizedBox(height: 12),

              _SubTitle("D) Commissariats européens"),
              _Paragraph(
                "Ils consistent en un renfort d’agents des États membres au profit des services de sécurité publique "
                "dans des lieux particulièrement fréquentés par des ressortissants européens, lors d’évènements ponctuels "
                "ou pendant les périodes touristiques.",
              ),
              SizedBox(height: 8),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Des policiers français peuvent aussi être désignés pour renforcer les forces de police ou de gendarmerie d’autres États.",
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
