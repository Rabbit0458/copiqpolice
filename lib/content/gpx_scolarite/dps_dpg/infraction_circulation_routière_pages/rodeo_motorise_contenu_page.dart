import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RodeoMotorisePage extends StatelessWidget {
  const RodeoMotorisePage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/infraction_circulation_routière_pages/rodeo_motorise';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

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
          "Infraction circulation routière",
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
            "Le rodéo motorisé",
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
                "Le rodéo motorisé consiste, au moyen d’un véhicule terrestre à moteur, à adopter une conduite "
                "répétant de façon intentionnelle des manœuvres constituant des violations d’obligations "
                "particulières de sécurité ou de prudence prévues par le code de la route, "
                "dans des conditions qui compromettent la sécurité des usagers de la route "
                "ou qui troublent la tranquillité publique.",
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
                  text: "Article L. 236-1 du Code de la route",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text: " : définit et réprime le rodéo motorisé.",
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
              const _SubTitle("A) Conduite d’un véhicule terrestre à moteur"),
              const _Paragraph(
                "Tous les véhicules terrestres à moteur sont concernés, qu’ils soient ou non soumis à réception.",
              ),

              const SizedBox(height: 14),

              const _SubTitle(
                "B) Des manœuvres répétées constituant des violations d’obligations de sécurité ou de prudence",
              ),
              const _Paragraph(
                "Les violations doivent résulter d’obligations particulières de sécurité ou de prudence prévues "
                "par des dispositions législatives ou réglementaires du code de la route.\n"
                "Les faits peuvent être commis dans tous les lieux où le code de la route s’applique : voies ouvertes "
                "à la circulation publique, mais aussi certaines voies privées dès lors que l’accès est libre "
                "(aires de stationnement à usage public, voies privées desservant un lotissement, sortie d’un parking privé à usage public, "
                "cour d’une gare, etc.).",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: const [
                  TextSpan(
                    text:
                        "Une manœuvre dangereuse unique ne suffit pas : les violations doivent être répétées.",
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const _SubTitle("Exemples (illustrations)"),
              const _IntroBullet(
                text:
                    "Ne pas respecter l’arrêt imposé par plusieurs feux rouges fixes successifs.",
              ),
              const _IntroBullet(
                text:
                    "Circuler à plusieurs reprises sur la voie opposée au sens de circulation malgré une ligne blanche continue.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Ces violations, ainsi que leur caractère répété, doivent être relevés et décrits précisément "
                "pour caractériser l’infraction.",
              ),

              const SizedBox(height: 14),

              const _SubTitle(
                "C) Un danger pour la sécurité des usagers OU un trouble à la tranquillité publique",
              ),
              const _Paragraph(
                "Il n’est pas exigé que le comportement ait causé un risque immédiat de mort ou de blessure grave. "
                "Il suffit de caractériser la compromission de la sécurité des autres usagers.",
              ),
              const SizedBox(height: 10),
              const _SubTitle("Exemples"),
              const _IntroBullet(
                text:
                    "Véhicules arrivant en sens inverse, piétons à proximité immédiate.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Les usagers concernés peuvent être des tiers (piétons, conducteurs extérieurs) mais aussi "
                "d’autres conducteurs participant eux-mêmes au rodéo motorisé.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Le trouble à la tranquillité publique peut résulter de la nature des comportements relevés "
                "(nuisances sonores excessives, blocage de la circulation, etc.).",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: const [
                  TextSpan(
                    text:
                        "L’exploitation a posteriori d’images de vidéoprotection peut permettre de caractériser "
                        "les éléments constitutifs de l’infraction.",
                  ),
                ],
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
                "Violation manifestement délibérée et répétée d’obligations de sécurité/prudence",
              ),
              _Paragraph(
                "L’auteur doit agir intentionnellement : il adopte volontairement une conduite répétant des manœuvres "
                "prohibées par le code de la route.",
              ),
              SizedBox(height: 10),
              _SubTitle(
                "Conscience de compromettre la sécurité OU de troubler la tranquillité publique",
              ),
              _Paragraph(
                "L’auteur a conscience que ses manœuvres compromettent la sécurité des usagers de la route "
                "ou troublent la tranquillité publique.",
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
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: "Article L. 236-1 II du Code de la route",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " (1er degré) :"),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text: "Lorsque les faits sont commis en réunion.",
              ),

              const SizedBox(height: 12),

              _Paragraph.rich([
                TextSpan(
                  text: "Article L. 236-1 III du Code de la route",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " (2e degré) :"),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Usage de stupéfiants établi (analyse sanguine/salivaire) ou refus de se soumettre aux vérifications destinées à l’établir.",
              ),
              const _BulletPoint(
                text:
                    "État alcoolique caractérisé (taux légal sang/air expiré) ou refus de se soumettre aux vérifications destinées à l’établir.",
              ),
              const _BulletPoint(
                text:
                    "Absence du permis exigé, ou permis annulé / invalidé / suspendu / retenu.",
              ),

              const SizedBox(height: 12),

              _Paragraph.rich([
                TextSpan(
                  text: "Article L. 236-1 IV du Code de la route",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " (3e degré) :"),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Cumul d’au moins deux des circonstances aggravantes prévues au III.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité
          _ConditionCard(
            title: "V — Répression",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              const _SubTitle("Peines encourues (personnes physiques)"),

              _Paragraph.rich([
                const TextSpan(text: "Rodéo simple : "),
                const TextSpan(
                  text: "1 an d’emprisonnement et 15 000 € d’amende. — ",
                ),
                TextSpan(
                  text: "article L. 236-1 I du Code de la route",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),
              const SizedBox(height: 8),

              _Paragraph.rich([
                const TextSpan(text: "Aggravé (réunion) : "),
                const TextSpan(
                  text: "2 ans d’emprisonnement et 30 000 € d’amende. — ",
                ),
                TextSpan(
                  text: "article L. 236-1 II du Code de la route",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),
              const SizedBox(height: 8),

              _Paragraph.rich([
                const TextSpan(text: "Aggravé (une circonstance du III) : "),
                const TextSpan(
                  text: "3 ans d’emprisonnement et 45 000 € d’amende. — ",
                ),
                TextSpan(
                  text: "article L. 236-1 III du Code de la route",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),
              const SizedBox(height: 8),

              _Paragraph.rich([
                const TextSpan(
                  text: "Aggravé (au moins deux circonstances du III) : ",
                ),
                const TextSpan(
                  text: "5 ans d’emprisonnement et 75 000 € d’amende. — ",
                ),
                TextSpan(
                  text: "article L. 236-1 IV du Code de la route",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("Mesures sur le véhicule"),
              _Paragraph.rich([
                const TextSpan(text: "Confiscation obligatoire du véhicule : "),
                TextSpan(
                  text: "article L. 236-3 du Code de la route",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " (si la juridiction ne la prononce pas, elle doit motiver sa décision).",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text: "Immobilisation administrative et mise en fourrière : ",
                ),
                TextSpan(
                  text: "article L. 325-1-2 du Code de la route",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " (sans autorisation préalable du procureur, qui doit néanmoins être informé immédiatement par tout moyen).",
                ),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("Tentative & complicité"),
              const _BulletPoint(text: "Tentative : NON."),
              _Paragraph.rich([
                const TextSpan(text: "Complicité : OUI, conformément à "),
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

              const SizedBox(height: 12),

              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Infraction autonome : le fait d’inciter à participer à un rodéo, de l’organiser ou d’en faire la promotion est réprimé par ",
                  ),
                  TextSpan(
                    text: "l’article L. 236-2 du Code de la route",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
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
