import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ImmobilisationPage extends StatelessWidget {
  const ImmobilisationPage({super.key});

  static const String routeName =
      '/gpx/memento_circulation/procedures/immobilisation';

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
    final Color cardDef = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardProc = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardPart = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardLevee = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardNatinf = isDark
        ? const Color(0xFF1A1A1A)
        : const Color(0xFFF6F7FB);

    final Color accentBlue = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color accentGrey = isDark ? Colors.white70 : const Color(0xFF616161);
    final Color accentGreen = isDark
        ? const Color(0xFF66BB6A)
        : const Color(0xFF2E7D32);
    final Color accentAmber = isDark
        ? const Color(0xFFFFCA28)
        : const Color(0xFFF9A825);
    final Color accentPink = isDark
        ? const Color(0xFFF48FB1)
        : const Color(0xFFC2185B);

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
          "Procédures — circulation",
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
            "L’immobilisation",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: "I — Élément légal",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: "Articles L. 325-1 à L. 325-13 du Code de la route",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " et "),
                TextSpan(
                  text: "articles R. 325-1 à R. 325-11 du Code de la route",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: const [
                  TextSpan(
                    text:
                        "L’immobilisation est une mesure administrative prévue par le Code de la route : "
                        "elle vise à empêcher un véhicule de circuler tant que la cause ayant motivé la mesure n’a pas cessé.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Définition
          _ConditionCard(
            title: "II — Définition (à retenir)",
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "L’immobilisation est l’obligation faite, par un O.P.J., un A.P.J. ou un A.P.J.A., au conducteur "
                "ou au propriétaire d’un véhicule, dans les cas prévus au Code de la route, de maintenir ce véhicule "
                "sur place ou à proximité du lieu de constatation de l’infraction, en se conformant aux règles relatives "
                "au stationnement.",
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    "Pendant toute la durée de l’immobilisation, le véhicule demeure sous la garde juridique de son propriétaire ou de son conducteur.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Procédure courante
          _ConditionCard(
            title: "III — Procédure courante",
            cardColor: cardProc,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _SubTitle("1) Où et comment immobiliser ?"),
              const _Paragraph(
                "L’immobilisation s’opère sur place ou à proximité du lieu de constatation, "
                "en respectant les règles relatives au stationnement.",
              ),
              const SizedBox(height: 12),
              const _SubTitle("2) Deux situations pratiques"),
              const _BulletPoint(
                text:
                    "Si l’infraction cesse en présence de l’agent : pas de fiche d’immobilisation, le véhicule peut repartir.",
              ),
              const _BulletPoint(
                text:
                    "Si l’infraction n’a pas cessé lorsque l’agent quitte le lieu : l’agent peut saisir l’O.P.J. territorialement compétent en lui remettant la fiche d’immobilisation et le certificat d’immatriculation (et, selon cas, les pièces administratives nécessaires à la circulation).",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: const [
                  TextSpan(
                    text:
                        "La suspension de l’autorisation de circuler liée à l’immobilisation est enregistrée au S.I.V. "
                        "et apparaît en consultation dans la rubrique « situation administrative ».",
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Dans tous les cas, "),
                const TextSpan(
                  text: "un double de la fiche d’immobilisation",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: " est remis au contrevenant."),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Cas particulier « barrière de dégel » : l’autorité saisie est ",
                ),
                const TextSpan(
                  text: "l’ingénieur des ponts et chaussées",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: " ou "),
                const TextSpan(
                  text: "le maire (voie communale)",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Procédures particulières
          _ConditionCard(
            title: "IV — Procédures particulières",
            cardColor: cardPart,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Remplacement du conducteur"),
              const _Paragraph(
                "L’immobilisation est levée dès qu’un conducteur qualifié (proposé par le conducteur, "
                "ou le cas échéant l’accompagnateur de l’élève conducteur ou le propriétaire) peut assurer la conduite, notamment si :",
              ),
              const SizedBox(height: 8),
              const _IntroBullet(
                text:
                    "Conducteur (ou accompagnateur) présumé en état d’ivresse / sous l’empire d’un état alcoolique.",
              ),
              const _IntroBullet(
                text: "Conducteur non titulaire du permis de conduire exigé.",
              ),
              const _IntroBullet(
                text:
                    "Conducteur en infraction à la réglementation sociale dans les transports routiers.",
              ),
              const _IntroBullet(
                text: "Pendant la durée de rétention du permis de conduire.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: const [
                  TextSpan(
                    text:
                        "À défaut de conducteur qualifié, les policiers peuvent prendre toute mesure pour placer le véhicule "
                        "en stationnement régulier (conduire le véhicule eux-mêmes ou faire appel à un conducteur qualifié).",
                  ),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle(
                "B) Fiche de circulation provisoire (valable 7 jours)",
              ),
              const _Paragraph(
                "Le verso de la fiche d’immobilisation peut tenir lieu de fiche de circulation provisoire valable 7 jours.",
              ),
              const SizedBox(height: 8),
              const _Paragraph(
                "Le Code de la route limite cette procédure aux infractions liées à :",
              ),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Contrôle technique : la fiche prescrit la présentation du véhicule dans le centre de contrôle technique choisi par le conducteur.",
              ),
              const _BulletPoint(
                text:
                    "Surteintage des vitres avant : la fiche prescrit la mise en conformité du véhicule.",
              ),
              const _BulletPoint(
                text:
                    "Chronotachygraphe / dispositif de limitation de vitesse (transports) : la fiche prescrit l’installation, la réparation ou la mise en conformité par un installateur agréé.",
              ),

              const SizedBox(height: 14),

              const _SubTitle("C) Immobilisation sur le lieu de réparation"),
              const _Paragraph(
                "Si l’infraction concerne l’état / l’équipement du véhicule et nécessite des réparations pour cesser :",
              ),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Le conducteur peut être autorisé à déplacer le véhicule en conditions de sécurité satisfaisantes (au besoin accompagné) vers le garage le plus proche.",
              ),
              const _BulletPoint(
                text:
                    "Ou à faire remorquer le véhicule, à ses frais, par un professionnel qualifié.",
              ),
              const SizedBox(height: 8),
              const _Paragraph(
                "L’immobilisation devient effective au lieu de réparation.",
              ),

              const SizedBox(height: 14),

              const _SubTitle("D) Véhicule en surcharge"),
              const _Paragraph(
                "L’agent verbalisateur peut prescrire la présentation du véhicule à une bascule proche en vue de sa pesée. "
                "L’immobilisation peut être prononcée si le poids réel excède de 5% le PTAC figurant sur le certificat d’immatriculation.",
              ),

              const SizedBox(height: 14),

              const _SubTitle(
                "E) Véhicule polluant / bruyant ou cyclomoteur débridé",
              ),
              const _Paragraph(
                "Si le véhicule paraît exagérément bruyant, non conforme aux émissions (fumées/gaz toxiques), "
                "ou si un cyclomoteur paraît débridé (vitesse/cylindrée/puissance) :",
              ),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Soit prescrire la présentation à un service de contrôle spécialisé (ex : brigade de contrôle technique).",
              ),
              const _BulletPoint(
                text:
                    "Soit établir une fiche de circulation provisoire autorisant la conduite vers un établissement choisi pour effectuer les réparations nécessaires.",
              ),

              const SizedBox(height: 14),

              const _SubTitle(
                "F) Transports de marchandises dangereuses (TMD)",
              ),
              const _Paragraph(
                "Toute décision d’immobilisation d’un transport de marchandises dangereuses doit être prise "
                "après avis d’agents spécialisés (sécurité civile, D.R.E.A.L.) lorsqu’une infraction est constatée, notamment :",
              ),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Circulation sur voies ou dates interdites par arrêté préfectoral.",
              ),
              const _BulletPoint(
                text:
                    "Non-respect de l’arrêté TMD ou de règles relatives aux visites techniques, certificat d’agrément, etc.",
              ),

              const SizedBox(height: 14),

              const _SubTitle(
                "G) Véhicule endommagé lors d’un accident (procédure dédiée)",
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Procédure « véhicule endommagé » : articles L. 327-4 et R. 327-1 à R. 327-6 du Code de la route",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _NotaBox(
                bodySpans: const [
                  TextSpan(
                    text:
                        "Les A.P.J.A. ne sont pas habilités à mettre en œuvre la procédure « véhicule endommagé ». "
                        "Elle vise à détecter et immobiliser un véhicule potentiellement dangereux à l’occasion d’un accident, "
                        "dans l’attente de la décision d’un expert.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Levée
          _ConditionCard(
            title: "V — Levée de l’immobilisation",
            cardColor: cardLevee,
            accent: accentPink,
            titleColor: textMain,
            children: [
              const _BulletPoint(
                text:
                    "L’immobilisation ne peut pas être maintenue après cessation de la circonstance qui l’a motivée.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Le véhicule peut circuler entre le lieu d’immobilisation et la résidence de l’autorité désignée "
                "pour lever la mesure, sous couvert du double de la fiche d’immobilisation.",
              ),
              const SizedBox(height: 12),
              const _SubTitle("Autorités pouvant lever la mesure"),
              const _BulletPoint(text: "L’agent qui l’a prescrite."),
              const _BulletPoint(
                text:
                    "L’O.P.J. (si une fiche d’immobilisation a été établie) — restitution du certificat d’immatriculation.",
              ),
              const _BulletPoint(
                text:
                    "L’ingénieur des ponts, des eaux et des forêts ou le maire (barrières de dégel).",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: const [
                  TextSpan(
                    text:
                        "La fin de la suspension de l’autorisation de circuler doit être enregistrée dans le S.I.V.",
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Si la cessation de l’infraction n’est pas justifiée dans un délai de 48 heures, l’O.P.J. peut transformer l’immobilisation en mise en fourrière.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // NATINF / infractions liées (table claire)
          _ConditionCard(
            title: "VI — Infractions fréquemment associées (repères NATINF)",
            cardColor: cardNatinf,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Repères issus du mémento (utile pour l’identification terrain).",
              ),
              SizedBox(height: 12),
              _NatinfTable(),
            ],
          ),

          const SizedBox(height: 12),
          _Paragraph.rich([
            const TextSpan(text: "Mis à jour le "),
            const TextSpan(
              text: "15/06/2025",
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
            const TextSpan(text: "."),
          ]),
        ],
      ),
    );
  }
}

class _NatinfTable extends StatelessWidget {
  const _NatinfTable();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color headerBg = isDark
        ? const Color(0xFF101010)
        : const Color(0xFFF0F0F0);
    final Color rowBg = isDark ? const Color(0xFF151515) : Colors.white;
    final Color border = isDark ? Colors.white12 : Colors.black12;
    final Color text = isDark ? Colors.white : const Color(0xFF111111);
    final Color subText = isDark ? Colors.white70 : const Color(0xFF444444);

    Widget headerCell(
      String t, {
      int flex = 3,
      TextAlign align = TextAlign.left,
    }) {
      return Expanded(
        flex: flex,
        child: Text(
          t,
          textAlign: align,
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 13.5,
            color: text,
          ),
        ),
      );
    }

    Widget cell(
      String t, {
      int flex = 3,
      TextAlign align = TextAlign.left,
      bool strong = false,
    }) {
      return Expanded(
        flex: flex,
        child: Text(
          t,
          textAlign: align,
          style: GoogleFonts.fustat(
            fontWeight: strong ? FontWeight.w900 : FontWeight.w700,
            fontSize: 13.5,
            color: subText,
          ),
        ),
      );
    }

    Widget row({
      required String natinf,
      required String intitule,
      required String ref,
    }) {
      return Container(
        decoration: BoxDecoration(
          color: rowBg,
          border: Border(top: BorderSide(color: border)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            cell(natinf, flex: 2, strong: true),
            const SizedBox(width: 8),
            cell(intitule, flex: 7),
            const SizedBox(width: 8),
            cell(ref, flex: 3, align: TextAlign.right),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: headerBg,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Row(
              children: [
                headerCell("NATINF", flex: 2),
                const SizedBox(width: 8),
                headerCell("Intitulé", flex: 7),
                const SizedBox(width: 8),
                headerCell("Référence", flex: 3, align: TextAlign.right),
              ],
            ),
          ),

          row(
            natinf: "6245",
            intitule: "Obstacle à une mesure d’immobilisation (délit)",
            ref: "L. 325-3-1 CR",
          ),
          row(
            natinf: "697",
            intitule:
                "Mise en circulation malgré immobilisation — PTAC ≤ 3,5 t (AF minorée 4e classe)",
            ref: "R. 325-2 CR",
          ),
          row(
            natinf: "21925",
            intitule:
                "Transport marchandises malgré immobilisation — PTAC > 3,5 t (PVO 5e classe)",
            ref: "R. 325-2 CR",
          ),
          row(
            natinf: "21926",
            intitule:
                "Transport en commun malgré immobilisation (PVO 5e classe)",
            ref: "R. 325-2 CR",
          ),
          row(
            natinf: "22746",
            intitule: "Refus de présenter à une bascule — PTAC ≤ 3,5 t",
            ref: "R. 325-8 CR",
          ),
          row(
            natinf: "22747",
            intitule: "Refus de présenter à une bascule — PTAC > 3,5 t",
            ref: "R. 325-8 CR",
          ),
          row(
            natinf: "22748",
            intitule: "Refus de présenter à une bascule — transport en commun",
            ref: "R. 325-8 CR",
          ),
          row(
            natinf: "6210",
            intitule:
                "Refus contrôle technique (bruit/émissions) — PTAC ≤ 3,5 t",
            ref: "R. 325-8 CR",
          ),
          row(
            natinf: "21937",
            intitule:
                "Refus contrôle technique (bruit/émissions) — PTAC > 3,5 t",
            ref: "R. 325-8 CR",
          ),
          row(
            natinf: "21938",
            intitule:
                "Refus contrôle technique (bruit/émissions) — transport en commun",
            ref: "R. 325-8 CR",
          ),
          row(
            natinf: "28029",
            intitule:
                "Refus de présenter un cyclomoteur (conformité vitesse/cylindrée/puissance)",
            ref: "R. 325-8 CR",
          ),
          row(
            natinf: "7548",
            intitule:
                "Maintien en circulation d’un véhicule endommagé malgré retrait conservatoire / interdiction",
            ref: "R. 327-5 CR",
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
