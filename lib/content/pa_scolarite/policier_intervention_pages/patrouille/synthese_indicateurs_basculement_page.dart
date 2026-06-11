import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaSyntheseIndicateursBasculementPage extends StatelessWidget {
  const PaSyntheseIndicateursBasculementPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/policier_intervention/patrouille/synthese-indicateurs-basculement';

  static const Color _lawRed = Color(
    0xFFE53935,
  ); // (garde la constante, même si non utilisée ici)

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards
    final Color cardRef = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardRuptures = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardEnv = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardDiscours = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardIdentitaire = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardJud = isDark
        ? const Color(0xFF2A2A2A)
        : const Color(0xFFF6F6F6);

    final Color accentGrey = isDark ? Colors.white70 : const Color(0xFF616161);
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
            "Synthèse — indicateurs de basculement",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          _ConditionCard(
            title: "Référence & lecture",
            cardColor: cardRef,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Tableau de synthèse des indicateurs de basculement — extrait de la mallette pédagogique "
                "EN019 (janvier 2017), reprise « Le policier en intervention » (mise à jour 15/06/2025).\n\n"
                "⚠️ Ce tableau sert au repérage de signaux (faibles/forts) et à l’analyse de situation : "
                "il ne remplace pas l’évaluation professionnelle, ni les procédures internes, ni le discernement.",
              ),
              SizedBox(height: 8),
              _SubTitle("Rappel simple"),
              _IntroBullet(
                text:
                    "Un indicateur isolé ne suffit pas : c’est l’accumulation, la cohérence et l’évolution dans le temps qui comptent.",
              ),
              _IntroBullet(
                text:
                    "Distinguer signaux faibles (changements progressifs, ambigus) et signaux forts (ruptures nettes, comportements structurés).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "1 — Ruptures",
            cardColor: cardRuptures,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _SubTitle(
                "Comportement de rupture avec l’environnement habituel",
              ),
              _Paragraph(
                "Ce domaine regroupe les modifications soudaines ou persistantes du quotidien, des liens et des habitudes.",
              ),
              SizedBox(height: 10),

              _SubTitle("Signaux forts (exemples)"),
              _BulletPoint(
                text:
                    "Rejet brutal des habitudes quotidiennes, rupture avec la famille, éloignement des proches.",
              ),
              _BulletPoint(
                text:
                    "Rupture avec les anciens amis, modification nette des centres d’intérêts.",
              ),
              _BulletPoint(
                text: "Absences prolongées et inexpliquées du domicile.",
              ),
              _BulletPoint(
                text: "Clivage exacerbé entre les hommes et les femmes.",
              ),
              _BulletPoint(text: "Intérêt soudain pour les armes."),

              SizedBox(height: 12),
              _SubTitle("Signaux faibles (exemples)"),
              _BulletPoint(
                text: "Rupture avec l’école / déscolarisation soudaine.",
              ),
              _BulletPoint(
                text:
                    "Modification des humeurs (exaltation, fuite dans l’imaginaire/virtualité, indifférence, perte des affects).",
              ),
              _BulletPoint(
                text:
                    "Privations de soins conventionnels, manque d’hygiène important, négligence extrême des conditions de vie/santé.",
              ),
              _BulletPoint(
                text:
                    "Investissements financiers disproportionnés dans un domaine exclusif (y compris financement d’actions humanitaires/caritatifs orientées).",
              ),
              _BulletPoint(text: "Privation de sommeil et de repos."),
              _BulletPoint(text: "Incitation à un régime alimentaire carencé."),

              SizedBox(height: 12),
              _SubTitle("Changement d’apparence (physique/vestimentaire)"),
              _BulletPoint(
                text:
                    "Modification soudaine et jugée non cohérente par l’entourage (volonté de dissimulation, signes d’affichage très marqués).",
              ),

              SizedBox(height: 12),
              _SubTitle("Pratique hyper ritualisée"),
              _BulletPoint(
                text:
                    "Participation à des groupes/cercle de réflexion radicaux et/ou conférences de prédicateurs extrémistes.",
              ),
              _BulletPoint(
                text:
                    "Agressivité ou hostilité justifiée par un motif religieux.",
              ),
              SizedBox(height: 10),
              _SubTitle("Signaux faibles associés"),
              _BulletPoint(
                text:
                    "Interdits étendus à l’entourage, obsession autour des rituels.",
              ),
              _BulletPoint(
                text:
                    "Changement de décoration au domicile (réorganisation ascétique, retrait de photos/représentations humaines).",
              ),
              _BulletPoint(
                text:
                    "Incidents lors de contrôles/accès (refus de se soumettre à certaines mesures), mimétisme culturel/identitaire.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "2 — Environnement personnel",
            cardColor: cardEnv,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _SubTitle("Image paternelle / parentale défaillante"),
              _BulletPoint(
                text:
                    "Absence ou rejet du père ; placement en protection de l’enfance / famille d’accueil ; recherche d’identité dégradée.",
              ),

              SizedBox(height: 12),
              _SubTitle("Environnement familial fragilisé"),
              _BulletPoint(
                text: "Immersion dans une famille radicalisée (signal fort).",
              ),
              _BulletPoint(
                text:
                    "Traumatismes personnels ou dont l’individu a été témoin (violences, incestes, agressions sexuelles).",
              ),
              _BulletPoint(
                text:
                    "Suivi psychiatrique d’un des parents ; repli sur soi ; fragilités relationnelles.",
              ),

              SizedBox(height: 12),
              _SubTitle("Environnement social"),
              _BulletPoint(
                text: "Fragilité sociale ; difficulté d’intégration.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "3 — Traits, discours & réseaux",
            cardColor: cardDiscours,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _SubTitle("Traits de personnalité"),
              _BulletPoint(
                text:
                    "Dépendance à une personne/un groupe/à des sites internet (signal fort).",
              ),
              SizedBox(height: 8),
              _Paragraph(
                "Signaux faibles souvent cités : immaturité, instabilité, fragilités narcissiques, intolérance à la frustration, "
                "pauvreté/absence d’affects, hypersensibilité, dogmatisme, refus du compromis, quête de réparation/reconnaissance, "
                "antécédents psychiatriques ou troubles du comportement, recherche affective, anesthésie affective, imperméabilité à la critique, "
                "provocation / besoin d’être vu.",
              ),

              SizedBox(height: 12),
              _SubTitle("Réseaux relationnels"),
              _BulletPoint(
                text:
                    "Contact avec des réseaux réputés pour leur radicalisme (signal fort).",
              ),

              SizedBox(height: 12),
              _SubTitle("Théories complotistes / conspirationnistes"),
              _BulletPoint(
                text:
                    "Allusions à la fin des temps / apocalypse ; vision binaire et manichéenne du monde (signal fort).",
              ),
              _BulletPoint(
                text:
                    "Double discours, admiration/vénération d’auteurs d’actes terroristes (signal fort).",
              ),
              SizedBox(height: 10),
              _SubTitle("Signaux faibles associés"),
              _BulletPoint(
                text:
                    "Allusions complotistes ; changement de vocabulaire et de sémantique employés.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "4 — Changements identitaires & prosélytisme",
            cardColor: cardIdentitaire,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _SubTitle("Changements de comportements identitaires"),
              _SubTitle("Signaux forts (exemples)"),
              _BulletPoint(
                text:
                    "Menace de l’État français ; soutien explicite à des groupes djihadistes ; hostilité à l’Occident.",
              ),
              _BulletPoint(
                text:
                    "Discours antisémites ; dénonciation véhémente de ceux qui ne partagent pas la foi.",
              ),
              _BulletPoint(
                text:
                    "Totalitarisme ; absence d’expression autonome (auto-récitation / discours instrumentalisé).",
              ),
              _BulletPoint(
                text:
                    "Distinction « bons / mauvais » croyants ; logique de rejet radical.",
              ),
              SizedBox(height: 10),
              _SubTitle("Signaux faibles (exemples)"),
              _BulletPoint(
                text:
                    "Propos associaux ; remise en cause de l’autorité ; rejet de la vie en collectivité.",
              ),
              _BulletPoint(
                text:
                    "Contestation du système démocratique ; critique de l’État ; attitude discriminatoire envers les femmes.",
              ),
              _BulletPoint(
                text: "Changement de sémantique, discours stéréotypé.",
              ),

              SizedBox(height: 12),
              _SubTitle("Prosélytisme"),
              _SubTitle("Signaux forts (exemples)"),
              _BulletPoint(
                text:
                    "Activité visant à radicaliser l’entourage / recrutement.",
              ),
              _BulletPoint(
                text:
                    "Incitation au départ vers une zone de conflit / à l’action violente.",
              ),
              _BulletPoint(
                text:
                    "Conversion tenue secrète vis-à-vis des parents (mineurs).",
              ),
              SizedBox(height: 10),
              _SubTitle("Signaux faibles (exemples)"),
              _BulletPoint(
                text: "Cas de prosélytisme à l’école ; conversion soudaine.",
              ),

              SizedBox(height: 12),
              _SubTitle("Usage des réseaux virtuels (techniques ou humains)"),
              _SubTitle("Signaux forts (exemples)"),
              _BulletPoint(
                text: "Changements réguliers de puces téléphoniques.",
              ),
              _BulletPoint(
                text:
                    "Fréquentation de sites/réseaux sociaux à caractère radical ou extrémiste.",
              ),
              _BulletPoint(
                text:
                    "Fréquentation de lieux/personnes défavorablement connus (parcours radical, criminel ou terroriste).",
              ),
              SizedBox(height: 10),
              _SubTitle("Signaux faibles (exemples)"),
              _BulletPoint(
                text:
                    "Comptes ouverts sous nouvelles identités (double compte).",
              ),
              _BulletPoint(
                text:
                    "Communications compulsives (sms, courriels, réseaux) ; usage excessif intense jour/nuit.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "5 — Judiciaire & détention",
            cardColor: cardJud,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _SubTitle("Stratégies de dissimulation / duplicité"),
              _SubTitle("Signaux forts (exemples)"),
              _BulletPoint(
                text:
                    "Découverte de cartes d’itinéraires / brochures de voyage vers zones de passage ; historique de consultations de sites radicaux.",
              ),
              _BulletPoint(
                text:
                    "Recours à des itinéraires de sécurité pour déjouer une surveillance.",
              ),
              SizedBox(height: 10),
              _SubTitle("Signaux faibles (exemples)"),
              _BulletPoint(
                text:
                    "Voyages touristiques ou projets humanitaires vers zones de transit ; attitude conformiste ; double discours.",
              ),

              SizedBox(height: 12),
              _SubTitle("Condamnation / incarcération"),
              _BulletPoint(
                text:
                    "Incarcération pour des faits de terrorisme ; écrou pour des faits de terrorisme (signaux forts).",
              ),

              SizedBox(height: 12),
              _SubTitle("Antécédents / signalements (milieu pénitentiaire)"),
              _BulletPoint(
                text:
                    "Signalement par cellules renseignement / services partenaires ; classement DPS ; antécédents de violences graves ; séjour en zone de conflit (signaux forts).",
              ),
              SizedBox(height: 10),
              _SubTitle("Signal faible"),
              _BulletPoint(
                text:
                    "Commission de certaines infractions d’appropriation (acquisition de moyens pour partir en zone de conflit).",
              ),

              SizedBox(height: 12),
              _SubTitle("Comportement en détention (signaux faibles)"),
              _BulletPoint(
                text:
                    "Nie les faits, conteste l’incarcération ; influence/tentative d’influence ; pratique sportive intensive.",
              ),

              SizedBox(height: 12),
              _NotaBox(
                title: "Nota",
                bodySpans: [
                  TextSpan(
                    text:
                        "Cette synthèse est un support de repérage. Toute situation doit être appréciée avec discernement, "
                        "en évitant les conclusions hâtives : on documente, on recoupe, on contextualise, puis on applique la doctrine/chaîne interne.",
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
