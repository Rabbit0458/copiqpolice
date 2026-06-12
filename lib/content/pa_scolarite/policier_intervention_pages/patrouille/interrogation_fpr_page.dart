import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaInterrogationFprPage extends StatelessWidget {
  const PaInterrogationFprPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/policier_intervention/patrouille/interrogation-fpr';

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
    final Color cardCat = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardProc = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardEx = isDark
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
            "L’interrogation du F.P.R.",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          _ConditionCard(
            title: "Définition & finalité",
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le fichier des personnes recherchées (F.P.R.) a pour finalité de faciliter les recherches "
                "et les contrôles effectués par les policiers et les autres agents habilités, dans le cadre "
                "de missions de police judiciaire ou administrative.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ “Élément légal” en haut
          _ConditionCard(
            title: "I — Base légale",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Les décisions judiciaires donnant lieu à inscription sont notamment prévues par ",
                ),
                TextSpan(
                  text: "l’article 230-19 du Code de procédure pénale",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Le policier doit respecter les finalités du fichier et interroger dans le cadre légal, notamment via CHEOPS NG (rappel : ",
                ),
                TextSpan(
                  text: "article R. 434-21 du Code de la sécurité intérieure",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: ")."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "II — Personnes inscrites au F.P.R.",
            cardColor: cardCat,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Sont inscrites dans le F.P.R. les personnes faisant l’objet :",
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    "De décisions judiciaires mentionnées à l’article 230-19 du CPP (mandat de recherche, interdiction de paraître, interdiction du territoire, inscription FIJAIT…), y compris celles ordonnées par un autre État de l’UE.",
              ),
              _BulletPoint(
                text:
                    "D’une recherche pour les besoins d’une enquête de police judiciaire.",
              ),
              _BulletPoint(
                text:
                    "De certaines décisions administratives ou situations particulières (opposition de sortie du territoire, malades mentaux à placer d’office, reconduite frontière non exécutée, interdiction de stade, mineurs en fugue, non-restitution d’un permis de conduire invalidé…).",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Important : l’existence d’une inscription ne signifie pas automatiquement interpellation. La conduite à tenir dépend de la catégorie et du numéro associés.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "III — Catégories de recherche",
            cardColor: cardProc,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Les mesures de recherche sont regroupées en 21 catégories. On trouve une ou deux lettres "
                "indiquant la catégorie (ex : AL, E, G, IT, M, PJ, S…).",
              ),
              SizedBox(height: 10),
              _SubTitle("Exemples de catégories"),
              _BulletPoint(text: "AL : aliénés."),
              _BulletPoint(text: "E : étrangers."),
              _BulletPoint(
                text:
                    "G : mesures administratives concernant les permis de conduire.",
              ),
              _BulletPoint(
                text: "IT : interdictions judiciaires du territoire.",
              ),
              _BulletPoint(text: "M : mineurs en fugue."),
              _BulletPoint(text: "PJ : recherches de police judiciaire."),
              _BulletPoint(text: "S : sûreté de l’État."),
              SizedBox(height: 10),
              _Paragraph(
                "Chaque catégorie est associée à un numéro correspondant à une instruction à exécuter. "
                "Les conduites à tenir varient selon les situations et n’autorisent pas nécessairement la coercition.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "IV — Exemples de conduites à tenir",
            cardColor: cardEx,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _SubTitle("PJ 01 — Recherche d’adresse"),
              _Paragraph(
                "Conduite à tenir : ne pas interpeller l’intéressé, ni attirer son attention sur la recherche, "
                "mais rechercher sa résidence et la faire connaître d’urgence au service demandeur.",
              ),
              SizedBox(height: 12),

              _SubTitle(
                "AL 01 — Internés administratifs en état d’évasion",
              ),
              _Paragraph(
                "Conduite à tenir : appréhender l’intéressé, prendre toutes les mesures de sécurité utiles "
                "et aviser d’urgence le service demandeur (qui donnera les indications et instructions).",
              ),
              SizedBox(height: 12),

              _SubTitle("J 55 — Mandat d’arrêt européen"),
              _Paragraph(
                "Conduite à tenir : procéder à l’arrestation de l’intéressé.",
              ),
              SizedBox(height: 12),

              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Le passage au fichier doit toujours s’effectuer à distance de la personne contrôlée. En cas de réponse positive, le CIC notifiera la conduite à tenir. ",
                  ),
                  TextSpan(
                    text:
                        "Le service à l’origine de l’ordre de recherche doit également être contacté afin de confirmer la validité de la fiche.",
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
  const _NotaBox({required this.bodySpans});

  final List<TextSpan> bodySpans;
  final String title = 'NOTA';

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
