import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaMenacesEnversDepositaireAutoritePage extends StatelessWidget {
  const PaMenacesEnversDepositaireAutoritePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/atteintes_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite';

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
          "Atteintes à l’administration",
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
            "Les menaces de crime ou délit envers une personne dépositaire de l’autorité publique, chargée d’une mission de service public, ou assimilée",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20.5,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Définition (pédagogique + synthétique)
          _ConditionCard(
            title: "Définition",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "L’infraction consiste à proférer la menace de commettre un crime ou un délit contre les personnes "
                "ou les biens, à l’encontre d’une victime spécialement protégée (D.A.P., agent de service public, "
                "professionnel de santé, enseignant, agent de transport, agent de sécurité privée, etc.), "
                "dans les conditions prévues par la loi (qualité apparente ou connue, lien avec les fonctions).",
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
                  text: "Article 433-3 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : définit et réprime les menaces visant certaines personnes en raison de leurs fonctions.",
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "À noter : des menaces adressées à certaines personnes dans le but d’entraver l’action de la justice "
                        "peuvent relever d’incriminations spécifiques (",
                  ),
                  TextSpan(
                    text: "articles 434-5, 434-8 et 434-15 du Code pénal",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ")."),
                ],
              ),
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
                "A) Une menace de commettre un crime ou un délit",
              ),
              _Paragraph(
                "La menace doit annoncer la commission prochaine d’un crime ou d’un délit contre les personnes ou les biens. "
                "Si la menace vise un bien, elle peut consister en l’annonce d’un mal susceptible d’être qualifié de destruction, "
                "dégradation ou détérioration.",
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    "La menace est punissable même si elle n’a pas été réitérée ni matérialisée.",
              ),

              SizedBox(height: 14),

              _SubTitle("B) Un destinataire déterminé par la loi"),
              _Paragraph(
                "La loi énumère limitativement les victimes protégées. On peut les regrouper en 4 grands blocs :",
              ),
              SizedBox(height: 10),

              _SubTitle(
                "1) Mandat électif / dépositaire de l’autorité publique / assimilés",
              ),
              _Paragraph(
                "Sont notamment visés : personnes investies d’un mandat électif public, magistrats, jurés, avocats, "
                "officiers publics ou ministériels, militaires de la gendarmerie nationale, fonctionnaires de la police nationale, "
                "douanes, inspection du travail, administration pénitentiaire, ainsi que toute autre personne dépositaire de l’autorité publique.",
              ),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 433-3 alinéa 1 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text: " : liste des personnes concernées (alinéa principal).",
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                "2) Mission de service public (enseignants, santé, transport…)",
              ),
              _Paragraph(
                "Sont concernés notamment : agent d’un exploitant de réseau de transport public de voyageurs, "
                "enseignant et personnels des établissements scolaires, ainsi que les professionnels de santé, "
                "lorsque la qualité est apparente ou connue.",
              ),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 433-3 alinéa 2 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : extension à certaines professions de service public/santé.",
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle("3) Activités privées de sécurité"),
              _Paragraph(
                "Sont visées les personnes exerçant une activité privée de sécurité (surveillance/gardiennage, "
                "protection de l’intégrité physique, transport de fonds/objets de valeur, sécurité dans les transports, etc.).",
              ),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Articles L.611-1 et L.621-1 du Code de la sécurité intérieure",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " : domaines concernés (renvoi légal)."),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 433-3 alinéa 3 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text: " : protection pénale pour ces activités.",
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle("4) Proches de la victime protégée"),
              _Paragraph(
                "Sont également protégés : le conjoint, les ascendants, les descendants en ligne directe, "
                "ou toute personne vivant habituellement au domicile, lorsque les menaces sont proférées "
                "en raison des fonctions exercées par la personne protégée.",
              ),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 433-3 alinéa 4 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text: " : extension aux proches en raison des fonctions.",
                ),
              ]),

              SizedBox(height: 14),

              _SubTitle("C) Une menace motivée par les fonctions"),
              _Paragraph(
                "Le lien avec les fonctions est indispensable :\n"
                "• pour les personnes de l’alinéa 1 : menace dans l’exercice ou du fait de l’exercice des fonctions ;\n"
                "• pour les personnes des alinéas 2 et 3 : menace dans l’exercice des fonctions ;\n"
                "• pour les proches (alinéa 4) : menace en raison des fonctions exercées par la personne protégée.",
              ),

              SizedBox(height: 12),

              _SubTitle("D) Qualité de la victime apparente ou connue"),
              _Paragraph(
                "La qualité de la victime doit être apparente ou connue de l’auteur, qui agit en raison de cette qualité.",
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
              _Paragraph(
                "L’auteur doit vouloir porter atteinte (ou intimider) la victime — ou ses proches — en raison des fonctions protégées. "
                "Il a conscience du trouble créé par les menaces dans l’esprit de la victime.",
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    "Peu importe que l’auteur ait eu l’intention de mettre sa menace à exécution ou qu’il en ait eu les moyens.",
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
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text: "Article 433-3 alinéa 5 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : lorsque la menace est une menace de mort ou une menace d’atteinte aux biens dangereuse pour les personnes.",
                ),
              ]),
              SizedBox(height: 12),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 433-3 alinéa 6 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : lorsqu’il est fait usage de menaces/violences/actes d’intimidation pour obtenir que la personne accomplisse "
                      "ou s’abstienne d’accomplir un acte de sa fonction/mission/mandat (ou facilité par celle-ci), ou pour la faire abuser "
                      "de son autorité (vraie ou supposée) afin d’obtenir d’une autorité/administration des distinctions, emplois, marchés ou "
                      "toute décision favorable.",
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Ces dispositions ne s’appliquent pas aux menaces/violences/actes d’intimidation prévus par ",
                  ),
                  TextSpan(
                    text: "l’article 433-3-1 du Code pénal",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression
          _ConditionCard(
            title: "V — Répression",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _SubTitle("Peines encourues — personnes physiques"),
              _Paragraph.rich([
                TextSpan(text: "Qualification simple : "),
                TextSpan(
                  text: "3 ans d’emprisonnement et 45 000 € d’amende. — ",
                ),
                TextSpan(
                  text: "article 433-3 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(text: "Aggravée (mort / biens dangereux) : "),
                TextSpan(
                  text: "5 ans d’emprisonnement et 75 000 € d’amende. — ",
                ),
                TextSpan(
                  text: "article 433-3 alinéa 5 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: "Aggravée (intimidation pour obtenir un acte) : ",
                ),
                TextSpan(
                  text: "10 ans d’emprisonnement et 150 000 € d’amende. — ",
                ),
                TextSpan(
                  text: "article 433-3 alinéa 6 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle("Personnes morales"),
              _Paragraph(
                "Les personnes morales peuvent être reconnues pénalement responsables (conditions du droit commun).",
              ),

              SizedBox(height: 12),

              _SubTitle("Tentative & complicité"),
              _BulletPoint(text: "Tentative : NON (non punissable)."),
              _Paragraph.rich([
                TextSpan(text: "Complicité : OUI, conformément à "),
                TextSpan(
                  text: "l’article 121-6 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: "l’article 121-7 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " (aide et assistance, provocation ou instructions données).",
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
