import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaProxenetismeHotelierPage extends StatelessWidget {
  const PaProxenetismeHotelierPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/atteintes_personnes/dignite_personne/proxenetisme_hotelier';

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
          "Atteintes à la dignité",
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
            "Le proxénétisme hôtelier",
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
                "Constitue une infraction le fait, par quiconque, agissant directement ou par personne interposée, "
                "de faciliter habituellement ou sciemment l’exercice de la prostitution par la fourniture de locaux "
                "ou de moyens (établissement, local privé, emplacement, véhicule).",
              ),
              SizedBox(height: 10),
              _IntroBullet(
                text:
                    "1° Détenir, gérer, exploiter, diriger, faire fonctionner, financer ou contribuer à financer un établissement de prostitution.",
              ),
              _IntroBullet(
                text:
                    "2° Détenir/ gérer/ exploiter… un établissement ouvert ou utilisé par le public, et accepter ou tolérer habituellement la prostitution dans l’établissement (ou annexes) ou la recherche de clients.",
              ),
              _IntroBullet(
                text:
                    "3° Vendre ou tenir à disposition des locaux/ emplacements non utilisés par le public, en sachant qu’ils serviront à la prostitution.",
              ),
              _IntroBullet(
                text:
                    "4° Vendre, louer ou tenir à disposition des véhicules, en sachant qu’ils serviront à la prostitution.",
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
                  text: "Article 225-10 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: " : définit et réprime le proxénétisme hôtelier.",
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
              _Paragraph(
                "Le texte sanctionne des comportements qui concourent à faciliter l’exercice de la prostitution par la fourniture de locaux "
                "et distingue quatre infractions autonomes.",
              ),
              SizedBox(height: 12),

              _SubTitle(
                "A) 1° — Tenue d’un établissement de prostitution",
              ),
              _Paragraph(
                "Objectif : empêcher la reconstitution de maisons de prostitution (fermeture historique par la loi « Marthe Richard » du 13 avril 1946). "
                "L’infraction vise la participation à l’exploitation d’un établissement de prostitution.",
              ),
              SizedBox(height: 10),
              _SubTitle("1) Une participation à l’exploitation"),
              _Paragraph(
                "L’exploitation est entendue très largement : détenir, gérer, exploiter, diriger, faire fonctionner, financer ou contribuer à financer, "
                "directement ou par personne interposée.",
              ),
              SizedBox(height: 8),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: "Jurisprudence : définition large de l’exploitation ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 14 mai 1968)",
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
                "La participation peut être un acte personnel de gestion (propriétaire, locataire, détenteur…), "
                "ou l’exercice d’un pouvoir d’autorité/contrôle (diriger, faire fonctionner). Elle peut aussi résulter d’un financement "
                "(apport de fonds, porteurs de parts/actions — parfois via prête-nom).",
              ),
              SizedBox(height: 12),
              _SubTitle("2) Une reconstitution clandestine à établir"),
              _Paragraph(
                "Pour que l’infraction soit constituée, il faut établir que les comportements visés ont tendu à la reconstitution d’un établissement clandestin.",
              ),
              SizedBox(height: 8),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Un établissement de prostitution peut être un local directement destiné à la prostitution, même si cette destination n’est pas exclusive ou permanente, "
                        "accueillant prostituées et clients venus de l’extérieur ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 01 février 1956)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),
              SizedBox(height: 8),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "La présence d’une seule prostituée pendant plusieurs jours peut suffire. En revanche, l’infraction n’est pas constituée lorsque seule la tenancière se prostitue ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 17 janvier 1963)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle(
                "B) 2° — Tolérance habituelle de la prostitution",
              ),
              _Paragraph(
                "Cette incrimination vise les mêmes exploitants que le 1°. Trois conditions doivent être réunies.",
              ),
              SizedBox(height: 10),
              _SubTitle(
                "1) Un établissement ouvert au public ou utilisé par le public",
              ),
              _Paragraph(
                "Il s’agit de tout lieu que le public peut fréquenter à raison de sa destination (hôtel, restaurant, dancing, lieux de spectacles…), "
                "ainsi que leurs annexes. L’exploitation doit relever du droit privé (particuliers).",
              ),
              SizedBox(height: 10),
              _SubTitle("2) Un caractère habituel"),
              _Paragraph(
                "L’habitude est un élément essentiel : plusieurs faits de prostitution doivent avoir été réalisés dans l’établissement "
                "(par une ou plusieurs personnes). Il n’est pas nécessaire que la prostitution soit l’activité habituelle de la personne (peut être occasionnelle).",
              ),
              SizedBox(height: 8),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Le délit n’est pas constitué si les faits se limitent à une seule journée ",
                  ),
                  TextSpan(
                    text: "(C.A. Grenoble, 15 mai 1996)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),
              SizedBox(height: 10),
              _SubTitle("3) Acceptation ou tolérance"),
              _Paragraph(
                "L’exploitant doit avoir accepté (consenti) ou toléré (ne pas empêcher) la pratique de la prostitution dans les lieux qu’il gère, "
                "ainsi que les annexes. Il doit avoir eu connaissance des faits : la simple présence de prostituées ne suffit pas.",
              ),

              SizedBox(height: 14),

              _SubTitle(
                "C) 3° — Vente ou mise à disposition de locaux/ emplacements privés",
              ),
              _Paragraph.rich([
                TextSpan(text: "Le texte vise expressément "),
                TextSpan(
                  text:
                      "« des locaux ou emplacements non utilisés par le public »",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      " : propriétés privées (maisons, appartements, studios…), ou locaux non accessibles au public.",
                ),
              ]),
              SizedBox(height: 10),
              _SubTitle("Vente"),
              _Paragraph(
                "Le propriétaire vend son bien en ayant connaissance, au moment de la transaction, de la nature de l’activité qui y sera exercée.",
              ),
              SizedBox(height: 10),
              _SubTitle("Mise à disposition"),
              _Paragraph(
                "Peut être le propriétaire, locataire, sous-locataire, occupant sans titre… Il suffit qu’il puisse utiliser les lieux assez longtemps pour les mettre à disposition. "
                "Le caractère habituel n’est pas requis : la mise à disposition peut être occasionnelle, le délit est constitué.",
              ),

              SizedBox(height: 14),

              _SubTitle(
                "D) 4° — Vente, location ou mise à disposition de véhicules",
              ),
              _Paragraph(
                "Concerne exclusivement la vente, la location ou la mise à disposition de véhicules en vue de l’exercice de la prostitution "
                "(voiture, camping-car, fourgon, etc.). L’auteur doit savoir que le véhicule servira à la prostitution.",
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
                "L’intention coupable est exigée : l’auteur agit en toute connaissance de cause. "
                "Il sait qu’il facilite la prostitution (reconstitution clandestine, acceptation/tolérance habituelle, "
                "vente/location/mise à disposition de locaux ou de véhicules en vue de la prostitution).",
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
            children: const [_Paragraph("Aucune.")],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité + exemption
          _ConditionCard(
            title: "V — Répression",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _SubTitle("Peines encourues — personnes physiques"),
              _Paragraph.rich([
                TextSpan(text: "Délit : "),
                TextSpan(
                  text: "10 ans d’emprisonnement et 750 000 € d’amende — ",
                ),
                TextSpan(
                  text: "article 225-10 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _Paragraph(
                "Une période de sûreté est applicable pour les infractions prévues aux 1° et 2°.",
              ),

              SizedBox(height: 12),

              _SubTitle("Personnes morales"),
              _Paragraph.rich([
                TextSpan(text: "Responsabilité pénale prévue par "),
                TextSpan(
                  text: "l’article 225-12 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " ; amende selon "),
                TextSpan(
                  text: "l’article 131-38 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " + peines prévues par "),
                TextSpan(
                  text: "l’article 131-39 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: ", ainsi que "),
                TextSpan(
                  text: "les articles 225-24 et 225-25 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      " (confiscations, dissolution, interdictions professionnelles, etc.).",
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle("Tentative & complicité"),
              _Paragraph.rich([
                TextSpan(text: "Tentative : OUI — "),
                TextSpan(
                  text: "article 225-11 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              _Paragraph.rich([
                TextSpan(text: "Complicité : OUI — "),
                TextSpan(
                  text: "articles 121-6 et 121-7 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: " (aide/assistance, provocation, instructions).",
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle("Exemption & réduction de peine"),
              _Paragraph.rich([
                TextSpan(text: "Exemption de peine : OUI — "),
                TextSpan(
                  text: "article 225-11-1 alinéa 1 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      " (avertir l’autorité administrative ou judiciaire et permettre d’éviter la réalisation de l’infraction).",
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(text: "Réduction de peine : OUI — "),
                TextSpan(
                  text: "article 225-11-1 alinéa 2 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      " (peine réduite des deux tiers si l’auteur/complice avertit l’autorité et permet de faire cesser l’infraction, d’éviter un préjudice irréversible, "
                      "ou d’identifier les autres auteurs/complices).",
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                title: "À retenir",
                bodySpans: [
                  TextSpan(
                    text:
                        "La loi distingue :\n"
                        "• l’exemption : dénonciation au stade de la tentative + action permettant d’éviter l’infraction.\n"
                        "• la réduction : dénonciation après commission pour faire cesser les faits, éviter un dommage irréversible, ou identifier les autres auteurs/complices.",
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
