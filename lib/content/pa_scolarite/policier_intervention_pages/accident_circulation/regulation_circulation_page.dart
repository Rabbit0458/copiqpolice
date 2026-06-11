import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaRegulationCirculationPage extends StatelessWidget {
  const PaRegulationCirculationPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/policier_intervention/accident-circulation/regulation-circulation';

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
    final Color cardI = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardII = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardIII = isDark
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
          "Accident de circulation",
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
            "La régulation de la circulation",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // ✅ Élément légal en haut (articles en rouge)
          _ConditionCard(
            title: "Base légale",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Les fonctionnaires de la Police nationale et les policiers adjoints placés sous leur commandement ont le pouvoir de régler la circulation — ",
                ),
                TextSpan(
                  text: "article R. 130-10 du Code de la route",
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
                      "Les indications données par ces agents prévalent sur toutes signalisations, feux de signalisation ou règles de circulation — ",
                ),
                TextSpan(
                  text: "article R. 411-28 du Code de la route",
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

          // Définition / objectifs
          _ConditionCard(
            title: "Objectif",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "La régulation de la circulation permet de faciliter l’écoulement du trafic en assurant une progression régulière des véhicules. "
                "Elle peut être mise en œuvre sur les lieux d’un accident, lors d’un contrôle routier, ou à l’occasion de difficultés ponctuelles de circulation.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // I — Sécurité du policier
          _ConditionCard(
            title: "I — La sécurité du policier en régulation",
            cardColor: cardI,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _SubTitle("A) Comportement de l’automobiliste"),
              _Paragraph(
                "La fatigue, la monotonie de la conduite, les troubles de santé, les soucis, et l’absorption d’alcool "
                "sont des causes fréquentes de baisse de vigilance. Sur des trajets courts ou habituels (domicile-travail), "
                "l’automobiliste peut ne pas voir le policier sur la voie publique.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "La conduite est aussi une activité très automatisée : la vigilance diminue, l’estimation du risque baisse, "
                "et le conducteur fait moins attention aux signaux.",
              ),
              SizedBox(height: 14),

              _SubTitle("B) Attitude du policier"),
              _Paragraph(
                "Pour assurer sa sécurité, le policier doit éviter d’être trop statique. Il adopte une attitude dynamique, "
                "avec des signaux énergiques et précis, et utilise si nécessaire le sifflet pour capter l’attention.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Certaines missions demandent une attention soutenue, notamment aux « points-écoles » (forte présence de piétons/enfants) et la nuit (visibilité réduite, éblouissement).",
                  ),
                ],
              ),
              SizedBox(height: 14),

              _SubTitle("C) Moyens techniques à mettre en œuvre"),
              _Paragraph(
                "Le policier qui régule la circulation doit répondre à deux objectifs :",
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    "Il doit VOIR : se placer à l’endroit le plus favorable pour observer l’ensemble des usagers (ex. milieu de l’intersection), anticiper les difficultés et intervenir selon la situation.",
              ),
              _BulletPoint(
                text:
                    "Il doit ÊTRE VU : utiliser les équipements adaptés (sifflet, gants blancs, tenues réfléchissantes, bâtons lumineux…).",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Il doit s’équiper des protections individuelles avant de descendre du véhicule.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // II — Poste de régulation
          _ConditionCard(
            title: "II — Le poste de régulation",
            cardColor: cardII,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le poste est souvent installé à une intersection à forte circulation. Il peut aussi être mis en place "
                "sur un rétrécissement temporaire, en réalisant une alternance de passage.",
              ),
              SizedBox(height: 12),
              _SubTitle("Principes de base"),
              _BulletPoint(
                text:
                    "Être visible : équipement adapté (vêtements réfléchissants, bâtons lumineux la nuit, etc.).",
              ),
              _BulletPoint(
                text:
                    "Port des gants blancs : facilite la compréhension des signaux par les usagers.",
              ),
              _BulletPoint(
                text:
                    "Se placer en sécurité : ne pas gêner la progression des véhicules.",
              ),
              _BulletPoint(
                text:
                    "Adopter une attitude dynamique et énergique, sans raideur excessive.",
              ),
              SizedBox(height: 12),

              _SubTitle("Rôle possible : aide-régulateur"),
              _IntroBullet(text: "Surveiller le trafic"),
              _IntroBullet(text: "Intervenir sur les infractions"),
              _IntroBullet(text: "Renseigner le public"),
              _IntroBullet(
                text:
                    "Arrêter la circulation d’une file sur ordre du régulateur",
              ),
              SizedBox(height: 14),

              _SubTitle("Mission : priorités & efficacité"),
              _Paragraph(
                "Les priorités de passage se font de manière alternée. Il convient toutefois d’assurer une priorité "
                "à l’axe supportant le plus de circulation, tout en évitant des attentes trop longues sur les voies moins desservies.",
              ),
              SizedBox(height: 10),

              _NotaBox(
                title: "Durée des cycles",
                bodySpans: [
                  TextSpan(
                    text:
                        "Quand la circulation est dense, adopter un cycle de passage assez long afin de résorber alternativement chacune des files.",
                  ),
                ],
              ),
              SizedBox(height: 10),

              _NotaBox(
                title: "Dégagement d’une intersection",
                bodySpans: [
                  TextSpan(
                    text:
                        "Donner la priorité à tout conducteur voulant tourner à gauche s’il crée un obstacle au milieu du carrefour. "
                        "Interdire de s’engager dans l’aire d’une intersection sans possibilité de poursuivre sa route.",
                  ),
                ],
              ),
              SizedBox(height: 10),

              _NotaBox(
                title: "Choix du véhicule à arrêter",
                bodySpans: [
                  TextSpan(
                    text:
                        "Éviter de couper la circulation sur un poids lourd ou un véhicule peu rapide : sa faible accélération "
                        "augmente le temps mort et ralentit la progression des autres usagers. Le conducteur doit être prévenu suffisamment tôt "
                        "pour que la décélération de la file soit progressive.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // III — Signalisation manuelle
          _ConditionCard(
            title: "III — La signalisation manuelle",
            cardColor: cardIII,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Les gestes réglementaires exécutés par les agents habilités prévalent sur toute signalisation/feux/règles — ",
                ),
                TextSpan(
                  text: "article R. 411-28 du Code de la route",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                "Les signaux manuels s’exécutent sans rigidité, mais avec énergie et précision.",
              ),
              SizedBox(height: 14),

              _SubTitle("Signaux de passage — « feu vert »"),
              _Paragraph(
                "L’agent ouvre la voie à un ou plusieurs véhicules en se plaçant parallèlement à leur axe de marche, "
                "bras tendus horizontalement et latéralement.",
              ),
              SizedBox(height: 14),

              _SubTitle("Signal préparatoire d’arrêt — « feu orange »"),
              _Paragraph(
                "Le bras droit ou gauche est levé verticalement, légèrement en avant de la tête ; "
                "la main dans le prolongement de l’avant-bras, doigts tendus et joints. "
                "L’autre bras reste le long du corps lorsque le geste d’arrêt sur un véhicule repéré n’est pas nécessaire.",
              ),
              SizedBox(height: 14),

              _SubTitle("Arrêt — « feu rouge »"),
              _Paragraph(
                "L’agent ferme la voie à un ou plusieurs véhicules en se plaçant perpendiculairement à leur axe de marche, "
                "bras tendus horizontalement et latéralement (ou un seul bras tendu).",
              ),
              SizedBox(height: 14),

              _SubTitle("Gestes complémentaires (si nécessaire)"),
              _BulletPoint(text: "PASSEZ (sur mouvement direct)."),
              _BulletPoint(text: "ACCÉLÉREZ."),
              _BulletPoint(text: "RALENTISSEZ."),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Ces gestes doivent rester simples, lisibles et immédiatement compréhensibles par les usagers.",
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
