import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaPlansOrsecPage extends StatelessWidget {
  const PaPlansOrsecPage({super.key});

  static const String routeName = '/pa/dps_dpg/policier_intervention/autres/plans-orsec';

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
          "Intervention — Autres",
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
            "Les plans ORSEC",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Définition / objectif
          _ConditionCard(
            title: "Définition & objectif",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le dispositif ORSEC (Organisation de la Réponse de SEcurité Civile) organise, en cas de situation d’urgence particulière, "
                "la mobilisation, la mise en œuvre et la coordination des actions de toutes les personnes publiques ou privées concourant à "
                "la protection générale de la population.\n\n"
                "Il vise à créer et entretenir un réseau d’acteurs, et à développer des habitudes de travail en commun "
                "(services de l’État, collectivités, associations, entreprises, gestionnaires de réseaux…).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut (référence générale)
          _ConditionCard(
            title: "I — Élément légal",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph.rich([
                TextSpan(text: "Le cadre général est fixé par le "),
                TextSpan(
                  text: "Code de la sécurité intérieure",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : mesures de protection générale de la population, organisation des secours et gestion des crises.",
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "ORSEC est une organisation. Le plan est complété par une fonctionnalité (ex. secours à de nombreuses victimes, hébergement) "
                        "ou par un risque (inondation, cyclone, accident ferroviaire…).",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Principes d’organisation
          _ConditionCard(
            title: "II — Principes d’organisation ORSEC",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _SubTitle("L’ORSEC repose sur :"),
              _BulletPoint(
                text:
                    "Le recensement et l’analyse préalable des risques et des conséquences des menaces.",
              ),
              _BulletPoint(
                text:
                    "Un dispositif opérationnel unique de gestion d’évènement majeur pour la protection des populations.",
              ),
              _BulletPoint(
                text:
                    "Une phase de préparation (exercices et entraînements réguliers) pour faire travailler les acteurs ensemble.",
              ),
              SizedBox(height: 12),
              _SubTitle("Déclinaison territoriale"),
              _BulletPoint(text: "Niveau départemental."),
              _BulletPoint(text: "Niveau zone de défense."),
              _BulletPoint(text: "Niveau zones maritimes."),
            ],
          ),

          const SizedBox(height: 14),

          // Direction unique / DOS
          _ConditionCard(
            title: "III — Direction des opérations de secours (DOS)",
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Tous les moyens publics et privés sont coordonnés par une direction unique : la direction des opérations de secours (DOS). "
                "Elle repose le plus souvent sur le maire.\n\n"
                "Toutefois, le préfet prend la direction des opérations de secours dans certains cas, notamment lorsque les conséquences dépassent "
                "les limites et les capacités d’une commune. Dans ce cas, le maire reste chargé des mesures de soutien à sa population.",
              ),
              SizedBox(height: 12),
              _SubTitle("Repères pratiques (tendance)"),
              _BulletPoint(
                text: "Accident simple / intervention courante : DOS = Maire.",
              ),
              _BulletPoint(
                text: "Accident important : DOS = Maire (moyens renforcés).",
              ),
              _BulletPoint(
                text:
                    "Accident avec nombreuses victimes / pollution / spéléo… : DOS = Préfet.",
              ),
              _BulletPoint(
                text:
                    "Situations majeures (tempête majeure, pandémie, inondation majeure, nucléaire…) : DOS = Préfet.",
              ),
              SizedBox(height: 12),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "À Paris et dans les départements de la petite couronne, le préfet de police assure en permanence la direction des opérations de secours.\n"
                        "En mer, le préfet maritime assure la DOS et commande le dispositif ORSEC maritime.\n"
                        "Si l’évènement dépasse un département : le préfet de zone de défense peut prendre la DOS.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Noyau dur / missions / outils
          _ConditionCard(
            title: "IV — Acteurs & “boîte à outils” opérationnelle",
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _SubTitle("Noyau dur d’acteurs (département)"),
              _Paragraph(
                "Le préfet rassemble un noyau dur : SDIS, services sanitaires et sociaux, police/gendarmerie, collectivités, "
                "services techniques, délégué militaire départemental, associations agréées de sécurité civile… "
                "Ce noyau est complété par d’autres intervenants selon la nature de l’évènement.",
              ),
              SizedBox(height: 12),
              _SubTitle("Missions de base communes"),
              _BulletPoint(
                text:
                    "Organisation des acteurs publics/privés concourant à la protection générale de la population.",
              ),
              _BulletPoint(text: "Commandement."),
              _BulletPoint(
                text:
                    "Communication de crise : alerte, information des populations et des élus.",
              ),
              _BulletPoint(
                text:
                    "Veille et alerte en toutes circonstances des acteurs du dispositif.",
              ),
              SizedBox(height: 12),
              _SubTitle("Modes d’action (exemples)"),
              _BulletPoint(text: "Secours à de nombreuses victimes."),
              _BulletPoint(text: "Évacuation des populations."),
              _BulletPoint(
                text: "Hébergement / ravitaillement / soutien / réconfort.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // PPI
          _ConditionCard(
            title: "V — Plan particulier d’intervention (PPI)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Les PPI sont réalisés pour faire face à un risque lié à des installations fixes pouvant avoir des conséquences sur la population.\n\n"
                "Le PPI est élaboré par le préfet : il prépare, selon les risques identifiés, les mesures de protection, la mobilisation "
                "et la coordination de l’ensemble des acteurs concernés.",
              ),
              SizedBox(height: 12),
              _SubTitle("Sites/risques concernés (exemples)"),
              _BulletPoint(
                text:
                    "Installations nucléaires de base (réacteur, usine de traitement…).",
              ),
              _BulletPoint(
                text:
                    "Installations classées SEVESO (raffineries, dépôts pétroliers…).",
              ),
              _BulletPoint(
                text: "Certains aménagements hydrauliques (barrages…).",
              ),
              _BulletPoint(
                text:
                    "Stockages souterrains (gaz naturel, produits chimiques industriels…).",
              ),
              _BulletPoint(
                text:
                    "Infrastructures transport marchandises dangereuses (ports, sites ferroviaires/routiers…).",
              ),
              _BulletPoint(
                text:
                    "Établissements utilisant des micro-organismes hautement pathogènes.",
              ),
              _BulletPoint(text: "Autres sites à risque…"),
              SizedBox(height: 12),
              _SubTitle("Construction du plan"),
              _Paragraph(
                "Le PPI est établi à partir de scénarios d’accidents identifiés par l’exploitant et contrôlés par l’État. "
                "Le scénario le plus défavorable délimite la zone d’application (communes/populations concernées).",
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    "Consultation : maires, exploitant, population de la zone d’application.",
              ),
              _BulletPoint(
                text:
                    "Après approbation : diffusion d’une brochure d’information à la population concernée.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // PCS
          _ConditionCard(
            title: "VI — Plan communal de sauvegarde (PCS)",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le PCS (créé par la loi de modernisation de la sécurité civile de 2004) fournit au maire un outil pour gérer un évènement de sécurité civile. "
                "Il complète le plan ORSEC de protection générale des populations.\n\n"
                "Le PCS organise les secours au niveau communal : alerte, information, protection et soutien de la population.",
              ),
              SizedBox(height: 12),
              _SubTitle("Obligation / recommandation"),
              _BulletPoint(
                text:
                    "Obligatoire dans les communes soumises à des risques majeurs, comprises dans le champ d’un PPI, ou dotées d’un PPRN.",
              ),
              _BulletPoint(
                text:
                    "Conseillé pour toutes les communes (même hors obligation).",
              ),
              SizedBox(height: 12),
              _SubTitle("Méthode"),
              _BulletPoint(
                text:
                    "Recensement et analyse des risques à l’échelle de la commune.",
              ),
              _BulletPoint(
                text:
                    "Document opérationnel : organisation communale de gestion des situations d’urgence.",
              ),
              _BulletPoint(
                text:
                    "Acteurs identifiés, formés et entraînés, adapté aux moyens de la commune.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Le PCS est mis à jour périodiquement. Son délai de révision ne peut excéder 5 ans.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Résumé rapide
          _ConditionCard(
            title: "En résumé (check-list)",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _IntroBullet(
                text:
                    "ORSEC = organisation globale de réponse de sécurité civile (acteurs + coordination).",
              ),
              _IntroBullet(
                text:
                    "DOS = direction unique (souvent maire ; préfet si dépassement communal / cas définis).",
              ),
              _IntroBullet(
                text:
                    "Noyau dur départemental + renforts selon situation (boîte à outils).",
              ),
              _IntroBullet(
                text:
                    "PPI = risques liés à installations fixes (pilotage préfet, scénarios, zone d’application).",
              ),
              _IntroBullet(
                text:
                    "PCS = organisation communale sous autorité du maire (obligatoire si risques majeurs / PPI / PPRN ; révision ≤ 5 ans).",
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
