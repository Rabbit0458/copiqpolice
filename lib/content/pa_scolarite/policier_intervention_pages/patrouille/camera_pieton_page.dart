import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaCameraPietonPage extends StatelessWidget {
  const PaCameraPietonPage({super.key});

  static const String routeName = '/pa/dps_dpg/policier_intervention/patrouille/camera-pieton';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    final Color cardDef = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardUse = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardData = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardProc = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);

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
          "Patrouille",
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
            "La caméra piéton",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          _ConditionCard(
            title: "Définition & finalités",
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Dans l’exercice des missions de prévention des atteintes à l’ordre public, de protection de la sécurité "
                      "des personnes et des biens, ainsi que dans les missions de police judiciaire, les agents de la police nationale "
                      "peuvent procéder, au moyen de caméras individuelles, à un enregistrement audiovisuel de leurs interventions (",
                ),
                TextSpan(
                  text: "article L. 241-1 du Code de la sécurité intérieure",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: ")."),
              ]),
              SizedBox(height: 12),
              _SubTitle("Objectifs principaux"),
              _IntroBullet(
                text: "Prévenir les incidents au cours des interventions.",
              ),
              _IntroBullet(
                text:
                    "Constater des infractions et collecter les preuves nécessaires à la poursuite de leurs auteurs.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Les enregistrements peuvent aussi être utilisés à des fins de formation et de pédagogie (sous conditions, notamment d’anonymisation).",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: "I — Base légale",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text: "Article L. 241-1 du Code de la sécurité intérieure",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : autorise l’enregistrement audiovisuel des interventions via caméras individuelles, dans les missions prévues.",
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Les données issues des caméras sont traitées dans un cadre réglementaire précisé notamment par ",
                ),
                TextSpan(
                  text:
                      "les articles R. 241-2 à R. 241-5 du Code de la sécurité intérieure",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "II — Modalités d’utilisation",
            cardColor: cardUse,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _SubTitle("A) Agents concernés"),
              _Paragraph(
                "Dans la police nationale, peuvent porter une caméra piéton :",
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: "Les personnels actifs (uniforme ou tenue civile*).",
              ),
              _BulletPoint(text: "Les policiers adjoints."),
              _BulletPoint(text: "Les réservistes."),
              SizedBox(height: 8),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "En tenue civile, l’agent doit porter des insignes extérieurs et apparents de sa qualité (ex : brassard).",
                  ),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle("B) Lieux concernés"),
              _Paragraph(
                "Les personnels régulièrement équipés peuvent utiliser la caméra en tous lieux "
                "(publics ou privés, y compris domiciles et lieux assimilés).",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Dans un domicile, l’enregistrement doit se limiter au strict périmètre de l’intervention "
                "et aux personnes concernées.",
              ),
              SizedBox(height: 10),

              _SubTitle("Information des personnes filmées"),
              _Paragraph(
                "Le déclenchement fait l’objet d’une information préalable des personnes filmées. "
                "Si les circonstances font obstacle à cette information préalable, elle est faite à l’issue de l’intervention "
                "(sauf si l’obstacle persiste).",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Exemple d’obstacle : état d’ébriété empêchant la compréhension de l’information. Référence : ",
                  ),
                  TextSpan(
                    text: "Cass. crim., 2 mai 2024",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Le consentement des personnes filmées n’est pas requis. Une opposition ne fait pas obstacle "
                "à la poursuite de l’enregistrement. Les personnes bénéficient d’un droit d’accès pouvant être exercé via la CNIL.",
              ),

              SizedBox(height: 14),

              _SubTitle("C) Conditions d’utilisation"),
              _BulletPoint(
                text:
                    "Seule une caméra en dotation administrative, portée de façon apparente, peut être utilisée.",
              ),
              _BulletPoint(
                text:
                    "La mise en service (mode pré-enregistrement) nécessite l’identification préalable de l’agent porteur (RIO ou carte agent selon le modèle).",
              ),
              _BulletPoint(
                text:
                    "En cas d’incident ou de risque d’incident (circonstances / comportement), l’agent active le mode “enregistrement” puis le désactive en fin d’intervention.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Les 30 secondes précédant le déclenchement sont sauvegardées (pré-enregistrement).",
                  ),
                ],
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    "Si la sécurité des agents (risque immédiat) ou la sécurité des biens/personnes est menacée, les images peuvent être transmises en temps réel au poste de commandement et aux personnels engagés.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "III — Traitement des données",
            cardColor: cardData,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _SubTitle("A) Données et informations enregistrées"),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Les catégories de données enregistrées sont prévues par ",
                ),
                TextSpan(
                  text: "l’article R. 241-2 du Code de la sécurité intérieure",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " :"),
              ]),
              SizedBox(height: 10),
              _BulletPoint(text: "Images et sons captés par la caméra."),
              _BulletPoint(
                text: "Jour et plages horaires d’enregistrement.",
              ),
              _BulletPoint(
                text: "Identification de l’agent porteur de la caméra.",
              ),
              _BulletPoint(text: "Lieu de collecte des données."),
              _BulletPoint(text: "Identification de la caméra."),
              _BulletPoint(
                text:
                    "Identification des personnels utilisateurs du logiciel d’exploitation.",
              ),
              _BulletPoint(
                text:
                    "Motif d’export du fichier vidéo, nom de l’agent et du service demandeurs, numéro de la procédure.",
              ),

              SizedBox(height: 14),

              _SubTitle("B) Stockage & conservation"),
              _Paragraph.rich([
                TextSpan(text: "Règles prévues notamment par "),
                TextSpan(
                  text:
                      "les articles R. 241-3, R. 241-4 du Code de la sécurité intérieure",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " :"),
              ]),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    "En fin de vacation, les données sont transférées sur un support informatique sécurisé et automatiquement effacées de la caméra.",
              ),
              _BulletPoint(
                text:
                    "Hors procédure (judiciaire/administrative/disciplinaire), les données sont conservées pendant un mois.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "IV — Consultation & destinataires",
            cardColor: cardProc,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Les règles de consultation/accès sont prévues notamment par ",
                ),
                TextSpan(
                  text:
                      "les articles R. 241-3, R. 241-3-1 et R. 241-5 du Code de la sécurité intérieure",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 12),

              _SubTitle("Accès (gestionnaires)"),
              _BulletPoint(
                text:
                    "Les chefs de service et les agents qu’ils désignent peuvent accéder à tout ou partie des données.",
              ),
              _BulletPoint(
                text:
                    "Ils peuvent extraire les données pour les besoins exclusifs d’une procédure judiciaire, administrative ou disciplinaire, ou pour une action de formation/pédagogie.",
              ),

              SizedBox(height: 14),

              _SubTitle("Destinataires possibles (selon le cadre)"),
              _BulletPoint(
                text: "Inspection générale de la police nationale (I.G.P.N.).",
              ),
              _BulletPoint(
                text:
                    "Autorité hiérarchique participant au pouvoir disciplinaire.",
              ),
              _BulletPoint(
                text: "Agents chargés de la formation des personnels.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Les enregistrements utilisés à des fins pédagogiques et de formation sont anonymisés.",
                  ),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle("Accès par l’agent après l’intervention"),
              _Paragraph(
                "Dans le cadre d’une procédure judiciaire ou d’une intervention, les agents équipés peuvent accéder directement "
                "après l’intervention (après transfert sur support sécurisé) aux enregistrements auxquels ils ont procédé afin de faciliter :",
              ),
              SizedBox(height: 10),
              _BulletPoint(text: "La recherche d’auteurs d’infractions."),
              _BulletPoint(
                text: "La prévention d’atteintes imminentes à l’ordre public.",
              ),
              _BulletPoint(text: "Le secours aux personnes."),
              _BulletPoint(
                text:
                    "L’établissement fidèle des faits lors des comptes rendus d’intervention.",
              ),

              SizedBox(height: 14),

              _SubTitle("Traçabilité"),
              _Paragraph(
                "Toutes les opérations de collecte, modification, consultation, communication et effacement sont enregistrées "
                "et conservées pendant trois ans.",
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
  const _NotaBox({required this.bodySpans});

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
