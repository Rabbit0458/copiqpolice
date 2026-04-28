import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PriseServiceAppelPage extends StatelessWidget {
  const PriseServiceAppelPage({super.key});

  static const String routeName = '/gpx/intervention/prise-service/appel';

  // Couleur dédiée aux articles de loi (si tu en ajoutes dans cette page)
  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette "propre + lisible" (comme ta template)
    final Color cardInfo = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardMat = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardRep = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);

    final Color accentBlue = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color accentGreen = isDark
        ? const Color(0xFF66BB6A)
        : const Color(0xFF2E7D32);
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
          "Prise de service",
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
            "L’appel",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 22,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          _ConditionCard(
            title: "Idée générale",
            cardColor: cardInfo,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Afin d’assurer la continuité du service, les gardiens de la paix et les policiers adjoints "
                "effectuent souvent leur mission par cycle de travail. Cette pratique du « roulement » impose "
                "un dispositif d’information de tout le personnel afin de maintenir l’efficacité du service.\n\n"
                "Ce dispositif se réalise à un moment privilégié : l’appel.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ “Élément légal” en haut : ici, pas d’article fourni -> on ne l’invente pas.
          _ConditionCard(
            title: "Référence (cadre)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Cette fiche décrit une pratique d’organisation interne du service (prise d’informations et transmission "
                "des consignes). Aucun article de loi précis n’est fourni dans ton contenu pour servir de fondement direct.\n\n"
                "➡️ Si tu veux, tu pourras ajouter ici les références exactes (CPP / CSI / déontologie / notes de service) "
                "et je te les mettrai en rouge automatiquement dans les TextSpan.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: 'IMPORTANT',
                bodySpans: [
                  const TextSpan(
                    text:
                        "Ne pas inventer de références : on n’affiche que les textes officiellement donnés dans ton cours / ta source.",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "Objectif de l’appel",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Effectué au moment de la prise de service par le chef de section ou de brigade, l’appel "
                "constitue le moment favorable qui doit permettre :\n"
                "• la circulation de l’information au sein du service ;\n"
                "• la prise des ordres des autorités supérieures.",
              ),
              SizedBox(height: 10),
              _SubTitle("En clair"),
              _Paragraph(
                "L’appel sert à aligner tout le monde : qui fait quoi, avec quelles consignes, avec quelles priorités, "
                "et avec quels points de vigilance à connaître avant de partir en mission.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "Présentation du policier",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le policier doit se présenter à l’heure prévue, en tenue d’uniforme (s’il est affecté dans un corps en tenue) "
                "et muni des équipements réglementaires.",
              ),
              SizedBox(height: 10),
              _SubTitle("À vérifier pour soi-même avant l’appel"),
              _BulletPoint(text: "Ponctualité (heure prévue)."),
              _BulletPoint(text: "Tenue conforme (détails corrects)."),
              _BulletPoint(
                text: "Équipements réglementaires présents et opérationnels.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "Rôle du chef d’unité pendant l’appel",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "À l’occasion de l’appel, le chef d’unité assure la mise en condition opérationnelle et la transmission "
                "des informations utiles au service.",
              ),
              SizedBox(height: 10),
              _SubTitle("Il/Elle :"),
              _IntroBullet(text: "procède à l’appel nominal ;"),
              _IntroBullet(
                text:
                    "effectue une inspection rapide et fait rectifier les détails de la tenue ;",
              ),
              _IntroBullet(
                text:
                    "s’assure que tous sont bien porteurs de leur arme, de leur gilet pare-balles et de leurs équipements réglementaires ;",
              ),
              _IntroBullet(
                text:
                    "donne lecture des ordres, instructions et télégrammes parvenus depuis la dernière prise de service ;",
              ),
              _IntroBullet(
                text:
                    "fait prendre en note sur le carnet ou le mémento de service les consignes particulières (recherches, fiches d’intervention) ;",
              ),
              _IntroBullet(
                text:
                    "indique à chacun le service à effectuer durant la vacation (et éventuellement les suivantes) et rappelle les consignes ;",
              ),
              _IntroBullet(
                text:
                    "prend en compte les demandes (congés, repos, candidature, …) et recueille les informations susceptibles d’intéresser le service.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "À retenir (pratique terrain)",
            cardColor: cardInfo,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              const _SubTitle("Bon réflexe"),
              const _Paragraph(
                "Arriver prêt : matériel OK, esprit dispo, et carnet/mémento accessible. "
                "Le but, c’est de repartir avec une consigne claire, comprise, et notée.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Pendant l’appel, note immédiatement les consignes particulières (recherches, fiches d’intervention). "
                        "Ça évite les oublis, et ça sécurise ton action en intervention.",
                  ),
                  const TextSpan(text: " "),
                  TextSpan(
                    text: "(mémento / carnet de service)",
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
