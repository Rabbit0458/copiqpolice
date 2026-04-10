import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ControleTechniquePage extends StatelessWidget {
  const ControleTechniquePage({super.key});

  static const String routeName =
      '/gpx/memento_circulation/controle_routier/controle_technique';

  static const Color _lawRed = Color(0xFFE53935);

  TextSpan _lawSpan(String text) => TextSpan(
    text: text,
    style: const TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
  );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardCadre = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardCalendrier = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardConsequences = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardInfra = isDark
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
          "Contrôle routier",
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
            "Le contrôle technique",
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
            cardColor: cardInfra,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Les véhicules concernés sont soumis à des contrôles techniques destinés à vérifier leur bon état "
                "de marche et d’entretien. Ils doivent être réalisés dans un centre agréé, à l’initiative du propriétaire.",
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
            children: [
              _Paragraph.rich([
                _lawSpan("R. 323-22 du Code de la route"),
                const TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Véhicules légers
          _ConditionCard(
            title: "II — Véhicules légers (VL)",
            cardColor: cardCadre,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Catégories concernées"),
              const _Paragraph(
                "Sont visées :\n"
                "• Voitures particulières (VP)\n"
                "• Camionnettes (CTTE)\n"
                "Identifiables sur le certificat d’immatriculation (rubrique genre J1).\n\n"
                "Sont exclues : celles immatriculées dans la série diplomatique.",
              ),
              const SizedBox(height: 10),
              const _SubTitle("B) Exclusions (réglementations spécifiques)"),
              const _Paragraph(
                "Sont exclus de ce régime, notamment :\n"
                "• Véhicules de dépannage\n"
                "• Véhicules (-10 places, conducteur compris) affectés au transport public de personnes\n"
                "• Véhicules de transports sanitaires\n"
                "• Véhicules utilisés pour l’enseignement de la conduite\n"
                "• Taxis et VTC (y compris véhicules de collection utilisés comme VTC)\n"
                "• Véhicules de collection",
              ),
              const SizedBox(height: 12),
              const _SubTitle("C) Périodicité (VL)"),
              _Paragraph.rich([
                const TextSpan(text: "Voir "),
                TextSpan(
                  text: "NATINF 12522",
                  style: GoogleFonts.fustat(fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: " / "),
                TextSpan(
                  text: "NATINF 12523",
                  style: GoogleFonts.fustat(fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "1er contrôle : au plus tard dans les 6 mois précédant le 4e anniversaire de la 1re mise en circulation.",
              ),
              const _BulletPoint(
                text: "Ensuite : renouvellement tous les 2 ans.",
              ),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Avant toute mutation d’un véhicule mis en circulation depuis plus de 4 ans : contrôle dans les 6 mois précédant la demande du nouveau certificat d’immatriculation (",
                ),
                TextSpan(
                  text: "NATINF 5678",
                  style: GoogleFonts.fustat(fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: ")."),
              ]),
              const SizedBox(height: 12),
              const _SubTitle("D) Contrôle des émissions polluantes (CTTE)"),
              _Paragraph.rich([
                const TextSpan(text: "Voir "),
                TextSpan(
                  text: "NATINF 12523",
                  style: GoogleFonts.fustat(fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              const _Paragraph(
                "Les camionnettes (CTTE) doivent faire l’objet d’une visite complémentaire « émissions polluantes » "
                "dans les 2 mois précédant l’expiration du délai d’un an après chaque contrôle technique.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // 2/3 roues & quadricycles (catégorie L)
          _ConditionCard(
            title: "III — 2/3 roues & quadricycles (catégorie L)",
            cardColor: cardCalendrier,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Les véhicules motorisés à deux ou trois roues et les quadricycles à moteur relèvent de la catégorie L au sens de ",
                ),
                _lawSpan("R. 311-1 du Code de la route"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              const _SubTitle("A) Repérage (exemples)"),
              const _Paragraph(
                "Ils sont identifiables sur le certificat d’immatriculation (rubriques J).\n\n"
                "Exemples (catégories) :\n"
                "• L1e : cyclomoteur ≤ 50 cm³\n"
                "• L2e : cyclomoteur à 3 roues\n"
                "• L3e : motocyclette (≤ 125 cm³ / > 125 cm³…)\n"
                "• L4e : side-car\n"
                "• L5e : tricycle à moteur\n"
                "• L6e : quadricycle léger à moteur (quad ≤ 4 kW, VSP/voiturette, etc.)",
              ),
              const SizedBox(height: 12),
              const _SubTitle("B) Périodicité"),
              const _BulletPoint(
                text:
                    "1er contrôle : au plus tard dans les 6 mois précédant le 5e anniversaire de la 1re mise en circulation.",
              ),
              const _BulletPoint(
                text: "Ensuite : renouvellement tous les 3 ans.",
              ),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Avant toute mutation d’un véhicule mis en circulation depuis plus de 5 ans : contrôle dans les 6 mois précédant la demande du nouveau certificat d’immatriculation.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Calendrier (mise en place)
          _ConditionCard(
            title: "IV — Calendrier de mise en place (2/3 roues & quad.)",
            cardColor: cardCadre,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(text: "Pour info : art. 43 de l’arrêté du "),
                TextSpan(
                  text: "23/10/2023",
                  style: GoogleFonts.fustat(fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: " et "),
                _lawSpan("R. 323-7 du Code de la route"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              const _SubTitle("Repères pratiques"),
              const _IntroBullet(
                text:
                    "Avant le 01/01/2017 avec anniversaire avant le 15 avril : 1re visite entre le 15/04/2024 et le 14/08/2024.",
              ),
              const _IntroBullet(
                text:
                    "Avant le 01/01/2017 (cas général) : 1re visite au plus tard le 31/12/2024.",
              ),
              const _IntroBullet(
                text:
                    "Entre 01/01/2017 et 31/12/2019 : 1re visite au plus tard en 2025.",
              ),
              const _IntroBullet(
                text:
                    "Entre 01/01/2020 et 31/12/2021 : 1re visite au plus tard en 2026.",
              ),
              const _IntroBullet(
                text:
                    "Entre 01/01/2022 et 25/10/2023 : dans les 6 mois précédant le 5e anniversaire (au plus tôt 01/07/2026).",
              ),
              const SizedBox(height: 12),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Les motos utilisées dans le cadre de compétitions sportives et appartenant à une personne titulaire d’une licence délivrée par une fédération sportive ne sont pas concernées par la mise en place de ce contrôle technique.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Conséquences
          _ConditionCard(
            title: "V — Conséquences du contrôle technique",
            cardColor: cardConsequences,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "À l’issue du contrôle, un procès-verbal est établi (un exemplaire est remis). "
                "Il liste les défauts constatés et peut imposer une contre-visite dans un délai maximal de 2 mois.",
              ),
              const SizedBox(height: 10),
              const _SubTitle("A) Contre-visite obligatoire si…"),
              const _BulletPoint(
                text:
                    "Défaillance majeure : susceptible de compromettre la sécurité, d’avoir une incidence négative sur l’environnement, ou de mettre en danger les autres usagers.",
              ),
              const _BulletPoint(
                text:
                    "Défaillance critique : danger direct et immédiat pour la sécurité routière ou incidence grave sur l’environnement.",
              ),
              const SizedBox(height: 12),
              const _SubTitle("B) Timbre apposé sur le certificat"),
              const _Paragraph(
                "Le contrôleur appose un timbre indiquant :\n"
                "• A : résultat favorable\n"
                "• S : résultat défavorable (défaillance majeure)\n"
                "• R : résultat défavorable (défaillance critique)\n\n"
                "Le timbre mentionne aussi la date limite de validité et l’immatriculation.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "La mention « report de la visite » peut figurer sur le PV si l’état du véhicule ne permet pas la vérification des points de contrôle "
                        "(accès impossible à des éléments d’identification/sécurité, installations hors service, etc.).",
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Si la contre-visite n’est pas effectuée dans les 2 mois, un nouveau contrôle est requis (",
                ),
                TextSpan(
                  text: "NATINF 12522",
                  style: GoogleFonts.fustat(fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: " / "),
                TextSpan(
                  text: "NATINF 12523",
                  style: GoogleFonts.fustat(fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: ")."),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "Lorsque aucune contre-visite n’est prescrite, une vignette est apposée en bas à droite du pare-brise "
                "avec notamment la date limite de validité.\n\n"
                "La non-apposition de la vignette sur le pare-brise ne constitue pas une infraction.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Infractions / NATINF
          _ConditionCard(
            title: "VI — Infractions (NATINF) & bases légales",
            cardColor: cardInfra,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              const _SubTitle("Maintien en circulation sans contrôle"),
              _Paragraph.rich([
                TextSpan(
                  text: "NATINF 12522",
                  style: GoogleFonts.fustat(fontWeight: FontWeight.w900),
                ),
                const TextSpan(
                  text:
                      " — Maintien en circulation de voiture particulière sans contrôle technique périodique (base : ",
                ),
                _lawSpan("R. 323-1"),
                const TextSpan(text: ", "),
                _lawSpan("R. 323-6"),
                const TextSpan(text: " et "),
                _lawSpan("R. 323-22 du Code de la route"),
                const TextSpan(text: ")."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: "NATINF 12523",
                  style: GoogleFonts.fustat(fontWeight: FontWeight.w900),
                ),
                const TextSpan(
                  text:
                      " — Maintien en circulation de camionnette (≤ 3,5 t) sans contrôle technique périodique (base : ",
                ),
                _lawSpan("R. 323-1"),
                const TextSpan(text: ", "),
                _lawSpan("R. 323-6"),
                const TextSpan(text: " et "),
                _lawSpan("R. 323-22 du Code de la route"),
                const TextSpan(text: ")."),
              ]),
              const SizedBox(height: 12),
              const _SubTitle("Vente / mutation"),
              _Paragraph.rich([
                TextSpan(
                  text: "NATINF 5678",
                  style: GoogleFonts.fustat(fontWeight: FontWeight.w900),
                ),
                const TextSpan(
                  text:
                      " — Vente d’un véhicule de plus de 4 ans sans remise du rapport de contrôle à l’acheteur professionnel (bases : ",
                ),
                _lawSpan("R. 323-1 du Code de la route"),
                const TextSpan(text: ", "),
                _lawSpan("D. 78-993 du 04/10/1978"),
                const TextSpan(text: ", "),
                _lawSpan("L. 412-1 du Code de la consommation"),
                const TextSpan(text: ", "),
                _lawSpan("R. 451-1 du Code de la consommation"),
                const TextSpan(text: ")."),
              ]),
              const SizedBox(height: 12),
              _NotaBox(
                title: "Mesures",
                bodySpans: [
                  const TextSpan(
                    text:
                        "AF min. 4e classe. DIA et dépistages stupéfiants facultatifs. Immobilisation possible "
                        "(fiche de circulation provisoire valable 7 jours). MEF possible si véhicule non présenté au CT "
                        "ou réparations prescrites non exécutées. PVO possible (5e classe).",
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
