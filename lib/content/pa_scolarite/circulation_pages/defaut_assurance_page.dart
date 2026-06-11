import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaDefautAssurancePage extends StatelessWidget {
  const PaDefautAssurancePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/socle_initial/circulation/defaut_assurance';

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
        ? const Color(0xFF1E1F22)
        : const Color(0xFFF2F2F2);
    final Color cardConst = isDark
        ? const Color(0xFF202734)
        : const Color(0xFFF3F7FF);

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
    final Color accentIndigo = isDark
        ? const Color(0xFF90CAF9)
        : const Color(0xFF3949AB);

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
          "Infractions circulation routière",
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
            "Le défaut d’assurance",
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
                "Le fait, y compris par négligence, de mettre ou de maintenir en circulation un véhicule terrestre "
                "à moteur ainsi que ses remorques ou semi-remorques sans être couvert par une assurance garantissant "
                "sa responsabilité civile conformément aux dispositions de l’article L. 211-1 du code des assurances, "
                "constitue une infraction.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal EN HAUT
          _ConditionCard(
            title: "I — Élément légal",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text: "Article L. 324-2 I du Code de la route",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text: " : définit et réprime le défaut d’assurance.",
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
              _SubTitle(
                "A) Véhicules concernés par l’obligation de s’assurer",
              ),
              _Paragraph(
                "Toute personne dont la responsabilité peut être engagée en raison de la mise en circulation "
                "d’un véhicule à moteur ainsi que ses remorques ou semi-remorques doit s’assurer. "
                "Il s’agit de couvrir les atteintes éventuelles aux personnes et aux biens, en raison des dommages "
                "subis par des tiers.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Un contrat d’assurance doit être souscrit auprès d’une entreprise d’assurance agréée dans ce domaine.",
              ),
              SizedBox(height: 14),

              _SubTitle("B) Un défaut d’assurance"),
              _Paragraph(
                "Le défaut d’assurance peut être constitué dès que le véhicule est stationné sur la voie publique "
                "ou sur un parking privé dès lors que celui-ci est accessible à la circulation publique.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Il est également constitué lorsque le contrat était résilié au moment des faits. Enfin, l’infraction "
                "est constituée lorsque l’assurance n’est pas ou n’est plus valable, sachant que le défaut de paiement "
                "d’une prime n’entraîne pas immédiatement la suspension ou la résiliation d’un contrat d’assurance.",
              ),
              SizedBox(height: 12),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "La charge de la preuve de la souscription d’une assurance repose sur le souscripteur, "
                        "qui peut la justifier par tout moyen.",
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
              _SubTitle("Conduire en sachant que le véhicule n’est pas assuré"),
              _Paragraph(
                "L’auteur agit intentionnellement et en toute connaissance de cause. "
                "Cependant, il est parfois retenu que la négligence peut suffire.",
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

          // Répression + tentative/complicité (pédagogique & clean)
          _ConditionCard(
            title: "V — Répression",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _SubTitle("Peines encourues"),
              _Paragraph.rich([
                TextSpan(text: "Qualification : "),
                TextSpan(text: "délit. "),
                TextSpan(text: "— Amende : "),
                TextSpan(text: "3 750 €"),
                TextSpan(text: ". — "),
                TextSpan(
                  text: "Article L. 324-2 I du Code de la route",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 12),
              _NotaBox(
                title: "ATTENTION",
                bodySpans: [
                  TextSpan(
                    text:
                        "Ce délit, non sanctionné d’une peine d’emprisonnement, interdit l’application du cadre "
                        "juridique de flagrance et la prise d’une mesure de garde à vue.",
                  ),
                ],
              ),
              SizedBox(height: 12),
              _SubTitle("Tentative & complicité"),
              _BulletPoint(text: "Tentative : NON."),
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
                TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Constatation / AFD (bien structuré)
          _ConditionCard(
            title: "VI — Constatation de l’infraction",
            cardColor: cardConst,
            accent: accentIndigo,
            titleColor: textMain,
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text:
                      "L’action publique peut être éteinte par le paiement d’une amende forfaitaire délictuelle "
                      "fixée par la loi dans les conditions prévues à ",
                ),
                TextSpan(
                  text: "l’article D. 45-3 du Code de procédure pénale",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text: ". Elle peut être applicable au défaut d’assurance.",
                ),
              ]),
              SizedBox(height: 12),
              _SubTitle("Procès-verbal électronique"),
              _Paragraph(
                "L’infraction doit être constatée par un procès-verbal électronique dressé au moyen "
                "d’un appareil sécurisé (terminaux Néo).",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Cette procédure doit être limitée aux cas ne laissant aucun doute sur la caractérisation "
                        "de l’infraction et ne nécessitant pas d’investigations complémentaires.",
                  ),
                ],
              ),
              SizedBox(height: 14),
              _Paragraph.rich([
                TextSpan(text: "Par contre, "),
                TextSpan(
                  text: "l’article 495-17 du Code de procédure pénale",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " dispose que la procédure d’amende forfaitaire délictuelle n’est pas applicable :",
                ),
              ]),
              SizedBox(height: 10),
              _BulletPoint(
                text: "Si le délit a été commis par un mineur.",
              ),
              _BulletPoint(
                text:
                    "Si le délit a été commis en état de récidive légale (mention TAJ pour le même délit ou un délit assimilé), sauf dispositions contraires.",
              ),
              _BulletPoint(
                text:
                    "Si plusieurs infractions, dont l’une au moins ne peut donner lieu à une amende forfaitaire, ont été constatées simultanément.",
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
