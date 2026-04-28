import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MaltraitanceAnimalePage extends StatelessWidget {
  const MaltraitanceAnimalePage({super.key});

  static const String routeName = '/gpx/intervention/animal/maltraitance';

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
    final Color cardMat = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardMoral = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardAggr = isDark
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
          "Animal",
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
            "Lutte contre la maltraitance animale",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // ✅ Définition + principes
          _ConditionCard(
            title: "Définition & principes",
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Les animaux sont des êtres vivants doués de sensibilité : ",
                ),
                TextSpan(
                  text: "article 515-14 du Code civil",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Ils doivent être placés par leur propriétaire dans des conditions compatibles avec les impératifs biologiques de leur espèce : ",
                ),
                TextSpan(
                  text: "article L. 214-1 du CRPM",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 12),
              _NotaBox(
                title: "Organisation",
                bodySpans: const [
                  TextSpan(
                    text:
                        "Les OPJ/APJ recherchent et constatent les infractions (Code pénal / Code rural). "
                        "Un référent “maltraitance animale” est désigné dans chaque commissariat pour appui et conseil.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut (infraction “support” : sévices graves / cruauté)
          _ConditionCard(
            title: "I — Élément légal (référence centrale)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(text: "Sévices graves / actes de cruauté : "),
                TextSpan(
                  text: "article 521-1 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " (animal domestique, apprivoisé ou tenu en captivité).",
                ),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Non applicable aux courses de taureaux et combats de coqs lorsque qu’une tradition locale ininterrompue peut être invoquée/établie.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément matériel (pédagogique)
          _ConditionCard(
            title: "II — Élément matériel",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _SubTitle("A) L’animal visé"),
              _Paragraph(
                "L’infraction concerne un animal domestique, apprivoisé ou tenu en captivité.",
              ),
              SizedBox(height: 12),
              _SubTitle("B) Le comportement incriminé"),
              _Paragraph(
                "• Sévices graves : mauvais traitements d’une particulière gravité.\n"
                "• Actes de cruauté : agissements destinés à faire souffrir, ou violences particulièrement odieuses (caractère volontaire).",
              ),
              SizedBox(height: 12),
              _SubTitle(
                "C) Autres atteintes fréquentes (à qualifier selon les faits)",
              ),
              _Paragraph(
                "Selon la situation, d’autres qualifications peuvent s’ajouter :\n"
                "• Atteinte volontaire à la vie d’un animal\n"
                "• Atteinte involontaire à la vie ou à l’intégrité\n"
                "• Atteintes sexuelles\n"
                "• Abandon\n"
                "• Expériences/recherches illicites\n"
                "• Mauvais traitements (contraventions / délits selon les cas).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément moral
          _ConditionCard(
            title: "III — Élément moral",
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Les sévices graves et actes de cruauté supposent un comportement volontaire : "
                "la conscience de maltraiter / faire souffrir l’animal est à caractériser par les constatations "
                "(déclarations, contexte, traces, répétition, matériel, témoins, vidéos…).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Circonstances aggravantes (521-1)
          _ConditionCard(
            title: "IV — Circonstances aggravantes (sévices / cruauté)",
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(text: "Aggravations prévues par "),
                TextSpan(
                  text: "l’article 521-1 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " (selon les cas) :"),
              ]),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Animal détenu par un agent dans l’exercice d’une mission de service public.",
              ),
              const _BulletPoint(
                text: "Faits commis par le propriétaire ou le gardien.",
              ),
              const _BulletPoint(text: "Faits commis en présence d’un mineur."),
              const _BulletPoint(
                text: "Faits ayant entraîné la mort de l’animal.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Tentative & complicité (spécificités utiles)
          _ConditionCard(
            title: "V — Tentative & complicité (points clés)",
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _NotaBox(
                title: "Complicité (images)",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Enregistrer sciemment des images de sévices graves / actes de cruauté ou d’atteintes sexuelles sur un animal peut constituer un acte de complicité, "
                        "sauf si l’enregistrement vise un débat public d’intérêt général ou sert de preuve en justice : ",
                  ),
                  TextSpan(
                    text: "article 521-1-2 du Code pénal",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 12),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Diffusion sur internet de ces images : délit prévu par ",
                ),
                TextSpan(
                  text: "l’article 521-1-2 alinéa 2 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Panorama des infractions + références (super utile sur le terrain)
          _ConditionCard(
            title: "VI — Panorama des principales infractions",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _SubTitle("Atteintes à la vie"),
              _Paragraph.rich([
                const TextSpan(text: "Atteinte volontaire à la vie : "),
                TextSpan(
                  text: "article 522-1 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                const TextSpan(
                  text: "Atteinte involontaire (contravention) : ",
                ),
                TextSpan(
                  text: "article R. 653-1 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 12),

              const _SubTitle("Atteintes sexuelles / sollicitations"),
              _Paragraph.rich([
                const TextSpan(text: "Atteinte sexuelle sur animal : "),
                TextSpan(
                  text: "article 521-1-1 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                const TextSpan(text: "Proposition / sollicitation : "),
                TextSpan(
                  text: "article 521-1-3 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 12),

              const _SubTitle("Abandon"),
              _Paragraph.rich([
                const TextSpan(text: "Abandon volontaire : "),
                TextSpan(
                  text: "article 521-1 alinéa 13 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Abandon exposant à un risque immédiat/imminent de mort : ",
                ),
                TextSpan(
                  text: "article 521-1 alinéa 15 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 12),

              const _SubTitle("Expériences / recherches"),
              _Paragraph.rich([
                const TextSpan(
                  text: "Expériences/recherches sans prescriptions : ",
                ),
                TextSpan(
                  text: "article 521-2 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " (renvoi CRPM)."),
              ]),
              const SizedBox(height: 12),

              const _SubTitle("Mauvais traitements (contraventions / délits)"),
              _Paragraph.rich([
                const TextSpan(text: "Mauvais traitements (contravention) : "),
                TextSpan(
                  text: "article R. 654-1 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Manquements du gardien/détenteur (nourriture, soins, habitat…) : ",
                ),
                TextSpan(
                  text: "article R. 215-4 du CRPM",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                const TextSpan(
                  text: "Mauvais traitements par un professionnel : ",
                ),
                TextSpan(
                  text: "article L. 215-11 du CRPM",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Obligations détenteurs (chiens/chats/furets)
          _ConditionCard(
            title: "VII — Obligations (chiens, chats, furets)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "• Depuis le 01/10/2022, l’acquéreur d’un animal de compagnie doit signer un certificat d’engagement et de connaissance.\n"
                "• L’identification des chiens, chats et furets et l’inscription au fichier national sont obligatoires.\n"
                "• En cession : remise des documents (cession, identification, certificat vétérinaire selon cas).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Mesures de protection + saisies + CPP 99-1
          _ConditionCard(
            title: "VIII — Mesures de protection & intervention",
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              const _SubTitle("Pouvoirs CRPM (protection animale)"),
              const _BulletPoint(
                text:
                    "Accès aux locaux/installations où se trouvent des animaux (hors domiciles) entre 8h et 20h (ou si accès public/activité en cours).",
              ),
              const _BulletPoint(
                text:
                    "Ouverture et contrôle de véhicules professionnels transportant des animaux (jour/nuit) et, en cas de danger vital, ouverture de tout véhicule.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Sur instructions du procureur, dans l’attente d’une mesure judiciaire prévue par ",
                ),
                TextSpan(
                  text: "l’article 99-1 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      ", possibilité de saisie/retrait et de confier l’animal à un tiers (association/fondation…).",
                ),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Frais",
                bodySpans: const [
                  TextSpan(
                    text:
                        "Les frais de garde sont en principe à la charge du propriétaire/détenteur (sauf décision contraire du magistrat).",
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _Paragraph.rich([
                const TextSpan(
                  text: "En urgence, l’état de nécessité peut être invoqué : ",
                ),
                TextSpan(
                  text: "article 122-7 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " (ex. bris de vitre pour extraire un chien enfermé en plein soleil, propriétaire injoignable).",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Divagation
          _ConditionCard(
            title: "IX — Divagation (points terrain)",
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Il est interdit de laisser divaguer les animaux domestiques et les animaux sauvages apprivoisés ou tenus en captivité.\n\n"
                "Chien divagant (hors chasse/garde/protection troupeau) : plus sous surveillance, hors portée de voix/rappel, éloigné de plus de 100 m, ou abandonné.\n\n"
                "Chat divagant : non identifié à plus de 200 m des habitations, ou à plus de 1 000 m du domicile sans surveillance, ou propriétaire inconnu saisi sur la voie publique.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text: "Divagation d’un animal dangereux (contravention) : ",
                ),
                TextSpan(
                  text: "article R. 622-2 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                const TextSpan(text: "Amende forfaitaire possible : "),
                TextSpan(
                  text: "article R. 48-1 (7°) du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Partenaires (utile)
          _ConditionCard(
            title: "X — Partenaires utiles",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _BulletPoint(
                text:
                    "DDPP : services vétérinaires (surveillance sanitaire & protection animale).",
              ),
              _BulletPoint(
                text:
                    "SPA : enquêtes / appui (contacts selon circuits locaux).",
              ),
              _BulletPoint(
                text:
                    "Associations de protection animale (ex. fondations/associations reconnues) pour mise en dépôt.",
              ),
              _BulletPoint(
                text:
                    "30 millions d’amis / associations locales : signalements, orientations, dépôts.",
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
