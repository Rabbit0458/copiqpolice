import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaPrimoSceneInfractionAmarisPage extends StatelessWidget {
  const PaPrimoSceneInfractionAmarisPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/policier_intervention/autres/primo-scene-infraction-amaris';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

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
          "AMARIS",
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
            "Primo-intervenant sur une scène d’infraction",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Définition / enjeux
          _ConditionCard(
            title: "De quoi s’agit-il ?",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Les premières mesures conservatoires prises dès l’arrivée sur les lieux d’un crime ou d’un délit "
                "jouent un rôle primordial pour la préservation des traces et indices.\n\n"
                "Elles sont essentielles pour la résolution de l’enquête et le déroulement d’un futur procès.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "Traces & indices (exemples)",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Les traces peuvent être visibles ou non détectables à l’œil nu : traces de pas, peinture, outils, "
                "impacts de balle, traces biologiques (sang, sperme, salive…), traces papillaires…\n\n"
                "Des objets peuvent constituer des indices : arme, douille/étui, balle, cagoule, gant, lettre, document d’identité…",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Une méthodologie rigoureuse de préservation doit être suivie : c’est le protocole d’intervention des premiers intervenants.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: "I — Élément légal (références)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text: "Article 54 du Code de procédure pénale",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : en cas de crime flagrant, l’OPJ avisé informe immédiatement le procureur, se transporte sans délai "
                      "sur le lieu, procède aux constatations utiles et veille à la conservation des indices et de tout ce qui peut "
                      "servir à la manifestation de la vérité (saisies, etc.).",
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Article D7 du Code de procédure pénale",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : les officiers et agents de police judiciaire veillent à la préservation de l’état des lieux et à la conservation "
                      "des traces/indices jusqu’aux opérations de police technique et scientifique.",
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Articles 55 alinéas 1 et 2 du Code de procédure pénale",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : il est interdit (amende contravention 4e classe) à toute personne non habilitée de modifier l’état des lieux "
                      "ou d’effectuer des prélèvements avant les premières opérations d’enquête judiciaire, sauf nécessité "
                      "(sécurité, salubrité publique, soins aux victimes).",
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 434-4 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : réprime le fait, pour faire obstacle à la manifestation de la vérité, de modifier l’état des lieux "
                      "(altération/falsification/effacement de traces, déplacement/suppression d’objets) ou de détruire/soustraire/receler/altérer "
                      "un document ou objet utile à la preuve (peines aggravées pour une personne concourant à la manifestation de la vérité).",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // “Ce qu’il faut savoir” structuré en 3 grands blocs
          _ConditionCard(
            title: "II — Visite de sécurité",
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Seule la nécessité absolue liée à la sûreté ou au secours justifie de pénétrer dans les lieux.\n\n"
                "La visite de sécurité vise à secourir une personne ou à s’assurer que toute menace est écartée.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Si possible, emprunter un cheminement unique, distinct de celui vraisemblablement suivi par le(s) auteur(s).",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "III — Préservation des lieux",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _BulletPoint(
                text:
                    "Évacuer / mettre à distance les personnes présentes (famille, curieux…), sans autoriser les témoins directs à quitter les lieux.",
              ),
              _BulletPoint(
                text:
                    "Ne rien toucher ni manipuler. Si déplacement nécessaire : gants + masque + matérialiser précisément l’emplacement d’origine (photo, marquage…).",
              ),
              _BulletPoint(
                text:
                    "Ne pas déplacer ni manipuler les armes/éléments balistiques sans autorisation PTS, sauf danger réel et immédiat.",
              ),
              _BulletPoint(
                text:
                    "Protéger les traces fragiles (intempéries : pas, pneumatiques…). Photographier ce qui peut disparaître rapidement.",
              ),
              _BulletPoint(
                text:
                    "Mettre en place un périmètre de sécurité (rubalise), interdit d’accès avant l’arrivée PTS.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "IV — Recueil des renseignements utiles",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Les fiches « premiers intervenants » doivent mentionner l’identité des personnes qui se sont succédées sur les lieux "
                "(y compris sapeurs-pompiers et SAMU).",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Toutes les modifications de la scène doivent être indiquées : porte forcée, gants/accessoires de soins laissés, "
                "évacuation de la victime, déplacement de mobilier/objet, fermeture arrivée de gaz, etc.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "V — Avis des personnes compétentes",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "L’OPJ et les agents formés à la PTS, habilités à gérer les scènes d’infraction, "
                "doivent être avisés dans les meilleurs délais.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression / tentative / complicité (adapté au thème, sans inventer d’autres articles)
          _ConditionCard(
            title: "VI — Répression, tentative & complicité (repères)",
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _SubTitle("Répression (altération de scène)"),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Le fait de faire obstacle à la manifestation de la vérité en modifiant les lieux est réprimé par ",
                ),
                TextSpan(
                  text: "l’article 434-4 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 12),
              _SubTitle("Tentative"),
              _Paragraph(
                "S’apprécie selon l’infraction retenue et les circonstances. En pratique : préserver, sécuriser, constater et rendre compte.",
              ),
              SizedBox(height: 12),
              _SubTitle("Complicité"),
              _Paragraph(
                "Peut être envisagée si un tiers aide ou facilite l’altération/destruction/soustraction d’indices ou d’objets utiles à la preuve.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Résumé “ultra clair”
          _ConditionCard(
            title: "En résumé",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _IntroBullet(
                text:
                    "Protéger les lieux = participer activement à la résolution d’une enquête.",
              ),
              _IntroBullet(
                text:
                    "Préserver au maximum jusqu’à l’arrivée des techniciens de la police scientifique.",
              ),
              _IntroBullet(
                text:
                    "Si une collecte technique est nécessaire : avis OPJ immédiat pour solliciter les personnels habilités.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Cette fiche n’impose pas de prescriptions exclusives : elle éclaire et aide à la réalisation des missions professionnelles.",
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
