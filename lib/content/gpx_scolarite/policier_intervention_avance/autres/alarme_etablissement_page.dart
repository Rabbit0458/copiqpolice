import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AlarmeEtablissementPage extends StatelessWidget {
  const AlarmeEtablissementPage({super.key});

  static const String routeName =
      '/gpx/intervention/autres/alarme-etablissement';

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
    final Color cardProc = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardDanger = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardTact = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardSynth = isDark
        ? const Color(0xFF1F2B34)
        : const Color(0xFFEFF7FF);

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
            "Alarme — établissement financier ou commercial",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          _ConditionCard(
            title: "Principe",
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Les interventions sur alarme dans un établissement à caractère financier ou commercial "
                "doivent être conduites avec la plus grande prudence. Ce sont des missions à haut risque : "
                "on applique des règles strictes pour éviter tout risque inutile, pour les policiers comme pour les tiers.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément “légal” en haut : pas d’articles CP/CPP/CSI cités dans ton texte
          _ConditionCard(
            title: "Références",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Le support fourni ne cite pas d’articles de loi (CP/CPP/CSI). Je n’invente rien : "
                "si tu veux une base juridique affichée en rouge en haut, envoie-moi les références exactes.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(text: "Mention opérationnelle : "),
                  const TextSpan(
                    text:
                        "mise en place d’un dispositif de quadrillage et de bouclage du secteur conformément à la ",
                  ),
                  TextSpan(
                    text: "note PN/CAB/N° 0273 du 09 février 1995",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: " (prises d’otages)."),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "1 — Procédure d’alarme (avant toute action)",
            cardColor: cardProc,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _SubTitle("Actions immédiates"),
              _BulletPoint(
                text:
                    "Procéder à un contre-appel téléphonique (sans considérer cela comme une garantie totale).",
              ),
              _BulletPoint(
                text:
                    "Dépêcher un équipage en tenue, armé et équipé, et le tenir informé du résultat des vérifications.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Quel que soit le nombre de déclenchements intempestifs, considérer l’intervention comme une mission à haut risque.",
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "2 — Approche des lieux (règles de base)",
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _SubTitle("Approche discrète"),
              _BulletPoint(
                text:
                    "Arriver discrètement et ne pas stationner devant l’établissement.",
              ),
              _BulletPoint(
                text:
                    "Ne jamais utiliser les avertisseurs sonores et lumineux pour l’approche.",
              ),
              SizedBox(height: 10),
              _SubTitle("Observation extérieure"),
              _BulletPoint(
                text:
                    "Observer entrées/sorties, comportement de la clientèle et du personnel, ambiance des abords immédiats.",
              ),
              SizedBox(height: 10),
              _SubTitle("Au moindre doute"),
              _BulletPoint(
                text:
                    "Aviser le C.I.C, éviter d’être repéré, se mettre en protection/observation/attente.",
              ),
              _BulletPoint(
                text:
                    "Écarter discrètement passants et curieux, donner un maximum d’informations au C.I.C.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "La pénétration dans les locaux ne peut se faire éventuellement que sur ordre du C.I.C, après levée de doute suffisante.",
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Les vérifications administratives (compteur / alarme injustifiée) ne sont pas urgentes : elles peuvent être faites ultérieurement.",
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "3 — Agression armée suspectée ou confirmée",
            cardColor: cardDanger,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _SubTitle("Ce qu’il ne faut pas faire"),
              _BulletPoint(
                text:
                    "Ne jamais passer devant l’établissement avec un véhicule sérigraphié, ni en uniforme dans un véhicule banalisé.",
              ),
              _BulletPoint(
                text:
                    "Ne jamais effectuer une approche avec avertisseurs sonores et lumineux.",
              ),
              _BulletPoint(
                text:
                    "Ne jamais traverser la rue dans l’alignement de l’établissement (guetteur probable).",
              ),
              _BulletPoint(
                text: "Ne jamais tenter de pénétrer dans l’établissement.",
              ),
              _BulletPoint(
                text:
                    "Ne jamais chercher à bloquer les agresseurs à l’intérieur, ni provoquer un affrontement.",
              ),
              _BulletPoint(
                text:
                    "Ne jamais faire courir de risques démesurés aux tiers et aux policiers.",
              ),
              _BulletPoint(
                text:
                    "Ne jamais tirer des coups de feu d’intimidation (inefficaces, dangereux, mal interprétés).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "4 — Dispositif préconisé (tactique & CIC)",
            cardColor: cardTact,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _SubTitle("Préparation & consignes"),
              _BulletPoint(
                text:
                    "S’équiper des matériels individuels et collectifs de protection.",
              ),
              _BulletPoint(
                text:
                    "Agir selon les instructions précises du C.I.C en restant en écoute permanente.",
              ),
              SizedBox(height: 10),
              _SubTitle("Approche & placement"),
              _BulletPoint(
                text:
                    "Approche discrète, du même côté que l’établissement, dans le sens de la circulation.",
              ),
              _BulletPoint(
                text:
                    "Garer le véhicule en zone masquée, moteur en fonctionnement ; conducteur prêt à faire mouvement.",
              ),
              _BulletPoint(
                text:
                    "Mettre en place rapidement un dispositif d’observation, de protection et d’intervention ultérieure.",
              ),
              SizedBox(height: 10),
              _SubTitle("Guetteur & observation"),
              _BulletPoint(
                text:
                    "Envoyer discrètement un observateur pour repérer un éventuel guetteur à pied ou en véhicule.",
              ),
              _BulletPoint(
                text:
                    "Si guetteur repéré : rendre compte immédiatement au C.I.C (position, description, véhicule).",
              ),
              SizedBox(height: 10),
              _SubTitle("Si agression confirmée"),
              _BulletPoint(
                text:
                    "Interdire toute approche ou passage devant l’établissement aux passants/curieux.",
              ),
              _BulletPoint(
                text:
                    "En cas de fuite : ne pas intervenir ; “photographier” mentalement et communiquer immédiatement (nombre, signalement, direction, véhicules).",
              ),
              _BulletPoint(
                text:
                    "Si armement visible : le signaler et le décrire. Informer le C.I.C en permanence (itinéraire, progression, attitude).",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Une intervention sur place ne peut être effectuée que sur ordre de l’autorité supérieure, quand les conditions de sûreté et d’opportunité sont réunies.",
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Avant toute intervention : définir le rôle de chacun, appliquer les principes de progression/pénétration et ceux de l’interpellation.",
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "5 — Arrivée fortuite d’une patrouille sur une agression",
            cardColor: cardSynth,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Hypothèse fréquente : une patrouille en mission de surveillance peut être témoin involontaire d’une agression en cours.",
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    "Après précautions de sécurité : rendre compte en situant exactement les faits.",
              ),
              _BulletPoint(
                text:
                    "Observer les malfaiteurs, leur dispositif éventuel, les moyens utilisés, sans attirer leur attention.",
              ),
              _BulletPoint(
                text:
                    "Communiquer rapidement et clairement au fil de l’évolution le maximum de renseignements au C.I.C.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Le C.I.C apprécie la situation, achemine les renforts et dirige les opérations.",
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "6 — Alerte par témoins ou victime",
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _SubTitle("Réception de l’information"),
              _BulletPoint(
                text:
                    "Recueillir au plus vite le maximum de renseignements et obtenir les coordonnées du correspondant.",
              ),
              _BulletPoint(
                text:
                    "Même sans certitude : il existe une probabilité d’agression en cours → mesures adaptées.",
              ),
              SizedBox(height: 10),
              _SubTitle("Prudence renforcée"),
              _BulletPoint(
                text:
                    "Manque de précision (auteurs, moyens, complices) = prudence accrue.",
              ),
              _BulletPoint(
                text:
                    "Le témoin/victime peut être sous émotion, peur, chantage : les infos peuvent être incomplètes.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "L’observation est particulièrement importante : les éléments peuvent apparaître au cours de la phase d’observation.",
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "7 — Alerte par télésurveillance (levée de doute)",
            cardColor: cardProc,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "La télésurveillance permet une “levée de doute” (écoute / vidéo) par une centrale de réception avant l’alerte police, "
                "souvent plus fiable qu’une liaison filaire.",
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    "Contre-appeler la centrale de réception pour contrôler la réalité de l’alarme.",
              ),
              _BulletPoint(
                text:
                    "Les indications de la centrale peuvent suffire à déclencher l’action police, même si l’alarme filaire ne s’est pas manifestée.",
              ),
              _BulletPoint(
                text:
                    "Dispositif comparable à une alerte témoin/victime : prudence maximale.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "L’avis aux services spécialisés n’empêche pas les mesures préparatoires et conservatoires (observation, intervention ultérieure).",
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "Commentaires — Premières mesures (check-list)",
            cardColor: cardDanger,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _IntroBullet(
                text: "Écarter toute personne de la zone dangereuse.",
              ),
              _IntroBullet(
                text:
                    "Recueillir les premiers renseignements (nombre d’auteurs, personnalité, etc.).",
              ),
              _IntroBullet(
                text: "S’organiser selon l’arrivée progressive des renforts.",
              ),
              _IntroBullet(text: "Garder son sang-froid."),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "En aucun cas, les premiers policiers sur les lieux, insuffisamment renseignés et équipés, ne doivent intervenir “à chaud” dans les lieux. Action réservée aux services spécialisés (ex. RAID…).",
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Ne pas interpeller sur l’instant n’est pas un échec : les renseignements transmis peuvent permettre des interpellations ultérieures, mieux préparées, sans risque inutile.",
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Informer immédiatement le C.I.C dès les premières informations obtenues.",
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "En résumé",
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _IntroBullet(
                text:
                    "Approche discrète + observation extérieure : priorité à la sécurité.",
              ),
              _IntroBullet(
                text:
                    "C.I.C informé en continu : il dirige, valide et déclenche l’intervention.",
              ),
              _IntroBullet(
                text:
                    "Pas d’entrée dans les lieux sans ordre et sans conditions de sûreté réunies.",
              ),
              _IntroBullet(
                text:
                    "Mission à haut risque : on privilégie le renseignement utile et la protection des tiers.",
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
