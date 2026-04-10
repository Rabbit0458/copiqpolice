import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AtteinteSecretProfessionnelPage extends StatelessWidget {
  const AtteinteSecretProfessionnelPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
    final Color cardDef = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
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
          "Atteinte à la personnalité",
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
            "L’atteinte au secret professionnel",
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
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "La révélation d’une information à caractère secret par une personne qui en est dépositaire "
                "soit par état ou par profession, soit en raison d’une fonction ou d’une mission temporaire, "
                "constitue une infraction.",
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
                TextSpan(
                  text: "Article 226-13 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : définit et réprime l’atteinte au secret professionnel.",
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
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: "L’article 226-13 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " incrimine la révélation d’une information à caractère secret par une personne qui en est dépositaire. "
                      "Ce délit protège la confiance nécessaire à l’exercice de certaines professions ou fonctions, mais aussi "
                      "l’intérêt des particuliers.",
                ),
              ]),
              const SizedBox(height: 14),

              const _SubTitle("A) Une personne dépositaire d’un secret"),
              _Paragraph.rich([
                TextSpan(
                  text: "L’article 226-13 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " vise la personne dépositaire « soit par son état ou sa profession, soit en raison d’une fonction ou d’une mission temporaire ». "
                      "Cette formule évite une énumération trop longue (médecin, pharmacien, policier, magistrat, greffier, avocat, banquier, expert-comptable, etc.).",
                ),
              ]),
              const SizedBox(height: 12),
              const _Paragraph(
                "En l’absence de texte spécial, les juges apprécient au cas par cas si une personne est tenue au secret professionnel.",
              ),
              const SizedBox(height: 12),
              const _Paragraph(
                "Le dépositaire n’est pas seulement un confident : c’est celui qui a appris des données à caractère confidentiel, "
                "de quelque manière que ce soit, à l’occasion de son état, profession, fonction ou mission.",
              ),

              const SizedBox(height: 14),

              const _SubTitle("• Dépositaire en raison de son état"),
              const _Paragraph(
                "L’« état » renvoie à une situation de fait ou de droit et à un statut juridique professionnel. "
                "Exemples : ministre du culte, étudiants/élèves en formation vers une profession soumise au secret "
                "(ex. élèves orthophonistes, masseurs-kinésithérapeutes, etc.).",
              ),

              const SizedBox(height: 12),

              const _SubTitle("• Dépositaire en raison de sa profession"),
              const _Paragraph(
                "La profession est l’activité habituellement exercée pour subvenir à ses besoins. Certaines professions, "
                "par leurs règles, astreignent leurs membres au secret (professions médicales, avocats, professions financières/commerciales, "
                "policiers, magistrats, etc.).",
              ),

              const SizedBox(height: 12),

              const _SubTitle("• Dépositaire en raison de sa fonction"),
              const _Paragraph(
                "La fonction est une charge et l’activité qu’elle occasionne. Le secret s’applique aux destinataires d’informations "
                "en raison de leurs fonctions (catégorie interprétée par la jurisprudence : agents de la fonction publique, services divers, etc.).",
              ),

              const SizedBox(height: 12),

              const _SubTitle(
                "• Dépositaire en raison d’une mission temporaire",
              ),
              const _Paragraph(
                "La mission temporaire vise une tâche ponctuelle confiée : jurés, membres assesseurs, experts, etc. "
                "Il faut que l’intéressé ait accès à des informations confidentielles ou destinées à l’être.",
              ),

              const SizedBox(height: 14),

              const _SubTitle("B) Un secret"),
              const _Paragraph(
                "Le secret peut être une confidence, une situation, une formule, ou plus largement toute information "
                "dont le dépositaire a connaissance à l’occasion de sa profession/fonction.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "La Cour de cassation étend la notion à tout ce que la personne tenue au secret a pu constater, découvrir "
                "ou déduire personnellement dans l’exercice de ses missions.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Le caractère secret de l’information ne s’éteint pas avec le décès de la personne concernée.",
              ),

              const SizedBox(height: 14),

              const _SubTitle("C) Un acte de révélation"),
              const _Paragraph(
                "La forme de la révélation importe peu : elle peut être orale, écrite, ou résulter de la transmission d’un document "
                "couvert par le secret.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Le délit est constitué dès que l’information est communiquée à une seule personne, même si elle est elle-même soumise "
                "au secret professionnel.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Si l’information a déjà été rendue publique, l’infraction peut quand même être retenue contre le dépositaire "
                "qui la confirme ou l’infirme.",
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
              _SubTitle("Conscience de révéler un secret"),
              _Paragraph(
                "L’infraction est intentionnelle : l’auteur a conscience de révéler une information secrète dont il est dépositaire, "
                "et la révélation est volontaire.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "L’intention de nuire n’est pas requise : le mobile importe peu.",
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
              _Paragraph("Aucune circonstance aggravante prévue."),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité + NOTA 226-14
          _ConditionCard(
            title: "V — Répression",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              const _SubTitle("Peines encourues — personnes physiques"),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 226-13 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : 1 an d’emprisonnement et 15 000€ d'amende (peine principale) et délit constitué par la révélation d’un secret.",
                ),
              ]),
              const SizedBox(height: 12),

              const _SubTitle("Personnes morales"),
              _Paragraph.rich([
                const TextSpan(text: "Responsabilité pénale prévue par "),
                TextSpan(
                  text: "l’article 121-2 du Code pénal",
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
                  text: "Peines complémentaires possibles (notamment) via ",
                ),
                TextSpan(
                  text: "l’article 226-12 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : affichage/diffusion de la décision, interdiction définitive ou temporaire d’exercer une activité sociale ou professionnelle.",
                ),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("Tentative & complicité"),
              const _BulletPoint(
                text: "Tentative : NON (non prévue / non punissable).",
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                const TextSpan(text: "Complicité : OUI — conformément à "),
                TextSpan(
                  text: "l’article 121-6 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " et "),
                TextSpan(
                  text: "l’article 121-7 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "Elle suppose un des faits constitutifs de complicité prévus par la loi : aide et assistance, provocation ou instructions données.",
              ),

              const SizedBox(height: 14),

              _NotaBox(
                title: "Exception (article 226-14 C.P.)",
                bodySpans: [
                  const TextSpan(
                    text:
                        "L’article 226-14 du Code pénal prévoit des cas où l’article 226-13 n’est pas applicable, notamment :\n"
                        "• Signalement aux autorités (judiciaires, médicales ou administratives) de maltraitances, privations ou sévices "
                        "infligés à un mineur ou à une personne vulnérable.\n"
                        "• Signalement par un professionnel de santé, avec l’accord de la victime (ou sans accord si mineur/personne vulnérable), "
                        "au procureur ou aux cellules compétentes pour les mineurs en danger.\n"
                        "• Signalement au procureur de faits de sujétion psychologique/physique (au sens de l’article 223-15-3 C.P.) "
                        "avec accord de la victime (ou sans accord si mineur/personne vulnérable), sous conditions.\n"
                        "• Signalement de violences au sein du couple mettant la vie de la victime majeure en danger immédiat, lorsque la victime "
                        "n’est pas en mesure de se protéger en raison de l’emprise (le professionnel doit s’efforcer d’obtenir l’accord, et informer la victime en cas d’impossibilité).\n"
                        "• Information du préfet (ou du préfet de police à Paris) par des professionnels de santé/action sociale du caractère dangereux "
                        "d’une personne détenant une arme ou ayant manifesté l’intention d’en acquérir une.\n"
                        "• Signalement par un vétérinaire de sévices graves, acte de cruauté ou atteinte sexuelle sur un animal.\n\n"
                        "Le signalement effectué dans ces conditions ne peut engager la responsabilité civile, pénale ou disciplinaire de son auteur, "
                        "sauf s’il est établi qu’il n’a pas agi de bonne foi.",
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
