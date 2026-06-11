import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaIdentificationDetectionProduitsSuspectsPage extends StatelessWidget {
  const PaIdentificationDetectionProduitsSuspectsPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/policier_intervention/autres/identification-detection-produits-suspects';

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
            "Identification & détection des produits stupéfiants",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Rappel / objectif
          _ConditionCard(
            title: "Objectif",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Cette fiche vise à donner des repères simples et opérationnels : vocabulaire, définitions, "
                "grandes familles de produits, présentations habituelles et principaux effets.\n\n"
                "⚠️ Ce contenu est informatif : il ne remplace pas les procédures, ni l’analyse scientifique.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: "I — Élément légal (référence)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text: "Les « substances vénéneuses » sont définies par : ",
                ),
                TextSpan(
                  text: "l’article L. 5132-1 du Code de la santé publique",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " (3 catégories : stupéfiants, psychotropes, listes I & II).",
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Les listes I et II sont mentionnées à : ",
                ),
                TextSpan(
                  text: "l’article L. 5132-6 du Code de la santé publique",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 12),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Quand d’autres articles (CP / CPP / CSI / CSP…) apparaissent dans tes supports, ils doivent être affichés en rouge, exactement comme ci-dessus.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Définitions
          _ConditionCard(
            title: "II — Quelques définitions (à connaître)",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _BulletPoint(
                text:
                    "Accoutumance : consommation répétée entraînant une dépendance psychique.",
              ),
              _BulletPoint(
                text:
                    "Dépendance : impossibilité de se passer d’un produit (physique et/ou psychique).",
              ),
              _BulletPoint(
                text:
                    "Dopage : utilisation de substances/procédés interdits pour augmenter artificiellement le rendement (souvent en contexte sportif).",
              ),
              _BulletPoint(
                text:
                    "Drogue : substance naturelle ou de synthèse agissant sur l’organisme (SNC) et modifiant conscience, sensations, comportement.",
              ),
              _BulletPoint(
                text:
                    "Hallucinogènes : substances provoquant altérations et/ou hallucinations sensorielles.",
              ),
              _BulletPoint(
                text:
                    "Psychotrope : molécules (souvent pharmacopée) présentant un risque important sur la santé.",
              ),
              _BulletPoint(
                text:
                    "Sevrage : arrêt du produit → symptômes psychologiques et physiologiques (« syndrome de sevrage »).",
              ),
              _BulletPoint(
                text:
                    "Stupéfiants : substances psychoactives dangereuses (certaines totalement prohibées : héroïne, cocaïne, cannabis…).",
              ),
              _BulletPoint(
                text:
                    "Surdose (overdose) : l’organisme ne tolère pas → risque vital rapide (respiration, rythme cardiaque, coma).",
              ),
              _BulletPoint(
                text:
                    "Tolérance : nécessité d’augmenter les doses pour obtenir le même effet.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Classification - naturelle
          _ConditionCard(
            title:
                "III — Classification : substances d’origine naturelle (repères)",
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _SubTitle(
                "Cannabis — herbe (kif, marijuana, chanvre indien, ganja, zamal…)",
              ),
              _BulletPoint(
                text:
                    "Aspect : feuilles/fleurs séchées, verdâtre à ocre, odeur poivrée.",
              ),
              _BulletPoint(
                text: "Conditionnement : enveloppes, doses ~ 5 à 10 g.",
              ),
              _BulletPoint(
                text:
                    "Effets : euphorie, troubles cognitifs (mémoire/perception), humeur, angoisse/panique, altération du jugement.",
              ),

              SizedBox(height: 12),

              _SubTitle("Cannabis — résine (shit, haschich)"),
              _BulletPoint(
                text:
                    "Aspect : morceaux/plaquettes/barrettes, brun pâle à noir, parfois vert/ocre, consistance molle à dure.",
              ),
              _BulletPoint(
                text:
                    "Conditionnement : barrettes 2 à 5 g (alu/adhésif), savonnettes/plaquettes 125 g à 1 kg.",
              ),
              _BulletPoint(
                text:
                    "Effets : proches cannabis ; risque d’angoisse/panique, réactions psychotiques, jugement altéré.",
              ),

              SizedBox(height: 12),

              _SubTitle("Huile de cannabis"),
              _BulletPoint(
                text:
                    "Aspect : liquide épais visqueux brun-vert à noirâtre, odeur âcre forte.",
              ),
              _BulletPoint(
                text:
                    "Conditionnement : petites fioles (au gramme) ou entre plastiques thermocollés.",
              ),
              _BulletPoint(
                text:
                    "Effets : effets psychoactifs marqués, altération jugement, nausées possibles.",
              ),

              SizedBox(height: 12),

              _SubTitle("Champignons hallucinogènes"),
              _BulletPoint(
                text: "Familles : psilocybes, conocybes, strophaires.",
              ),
              _BulletPoint(
                text: "Conditionnement : frais ou séchés (doses variables).",
              ),
              _BulletPoint(
                text:
                    "Effets : hallucinations/altérations sensorielles, anxiété possible, jugement altéré.",
              ),

              SizedBox(height: 12),

              _SubTitle("Opium"),
              _BulletPoint(
                text: "Aspect : pâte assez ferme brun/noir, odeur âcre.",
              ),
              _BulletPoint(
                text:
                    "Conditionnement : pains (250 g à 1 kg), boulettes, bâtonnets.",
              ),
              _BulletPoint(
                text:
                    "Effets : somnolence, abattement, myosis, constipation ; forte dépendance et risque surdosage.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Classification - (semi) synthèse / produits “classiques”
          _ConditionCard(
            title: "IV — Autres produits fréquemment rencontrés (repères)",
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _SubTitle("Morphine / héroïne"),
              _BulletPoint(
                text: "Morphine : alcaloïde extrait de l’opium (médical).",
              ),
              _BulletPoint(
                text: "Héroïne : produit de semi-synthèse (à partir morphine).",
              ),
              _BulletPoint(
                text:
                    "Présentation : poudre blanche à marron, odeur opium/vinaigre ; doses en boulettes/pailles/sachets.",
              ),
              _BulletPoint(
                text:
                    "Signes/effets : traces de piqûres, myosis, amaigrissement ; très forte dépendance, risque surdosage.",
              ),

              SizedBox(height: 12),

              _SubTitle("Cocaïne (chlorhydrate) / crack"),
              _BulletPoint(
                text:
                    "Cocaïne : poudre blanche cristalline (« neige »), mydriase, tachycardie, HTA, convulsions possibles.",
              ),
              _BulletPoint(
                text:
                    "Crack : forme solide destinée à être fumée (cailloux/rocs blanc à écru).",
              ),
              _BulletPoint(
                text:
                    "Effets : paranoïa, délires/anxiété, dépendance forte ; crack = effet bref et prises compulsives.",
              ),

              SizedBox(height: 12),

              _SubTitle("Rachacha (décoction de pavot)"),
              _BulletPoint(
                text:
                    "Aspect : pâte molle/visqueuse acajou, odeur de terre pourrie.",
              ),
              _BulletPoint(
                text:
                    "Effets : calmant/apaisant, modification conscience, nausées ; dépendance et risque cardio.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Synthèse
          _ConditionCard(
            title: "V — Substances de synthèse (repères)",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _SubTitle("Amphétamines / méthamphétamine"),
              _BulletPoint(
                text:
                    "Présentation : poudres (blanche/rose/jaune), cristaux, comprimés.",
              ),
              _BulletPoint(
                text:
                    "Effets : stimulation, euphorie, anorexie, vigilance augmentée ; dépendance psychique forte, risque surdosage.",
              ),
              _BulletPoint(
                text:
                    "Méthamphétamine : effets proches mais plus puissants/durables (jusqu’à 24 h).",
              ),

              SizedBox(height: 12),

              _SubTitle("Ecstasy (MDMA & dérivés)"),
              _BulletPoint(
                text:
                    "Présentation : comprimés souvent avec logos, parfois gélules/poudre.",
              ),
              _BulletPoint(
                text:
                    "Effets : stimulant + parfois hallucinogène, sensations chaleur/flottement, déshydratation ; risque surdosage.",
              ),

              SizedBox(height: 12),

              _SubTitle("LSD-25"),
              _BulletPoint(
                text:
                    "Dose efficace très faible → supports imprégnés (buvard, gélatine, pointe graphite…), plus rarement liquide/gélules.",
              ),
              _BulletPoint(
                text:
                    "Effets : hallucinations, perturbation de l’humeur et de la pensée, flash-back possible ; risque surdosage.",
              ),

              SizedBox(height: 12),

              _SubTitle("Colles / solvants"),
              _BulletPoint(
                text:
                    "Produits : dissolvants, détachants, diluants (acétone, toluène, benzène…).",
              ),
              _BulletPoint(
                text:
                    "Effets : euphorie/ivresse, confusion (illusions/hallucinations), toxicité importante ; risque coma/décès (respiratoire/cardio).",
              ),

              SizedBox(height: 12),

              _SubTitle("Poppers (dérivés du nitrite)"),
              _BulletPoint(
                text:
                    "Liquide jaunâtre, volatil et inflammable (petites bouteilles).",
              ),
              _BulletPoint(
                text:
                    "Effets : vasodilatation, tachycardie, vertiges, céphalées ; risque malaise.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Médicaments
          _ConditionCard(
            title: "VI — Médicaments détournés (repères)",
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _SubTitle("GHB"),
              _BulletPoint(
                text:
                    "Peut se présenter en poudre cristalline ou liquide incolore/jaune (« drogue du viol »).",
              ),
              _BulletPoint(
                text:
                    "Effets : sédatif, amnésie, vertiges, nausées ; risque dépression respiratoire.",
              ),

              SizedBox(height: 12),

              _SubTitle("Substitution aux opiacés (méthadone / buprénorphine)"),
              _BulletPoint(
                text:
                    "Méthadone : sirop (odeur vanillée), gélules/comprimés (emballage d’origine).",
              ),
              _BulletPoint(
                text: "Buprénorphine : comprimés (voie sublinguale).",
              ),
              _BulletPoint(
                text:
                    "Risques : dépendance/tolérance/surdosage ; détournement voie d’administration (complications).",
              ),

              SizedBox(height: 12),

              _SubTitle("Kétamine / tiletamine"),
              _BulletPoint(
                text:
                    "Anesthésiques (humain/vétérinaire). Présentation : liquide incolore ou poudre blanche/beige.",
              ),
              _BulletPoint(
                text:
                    "Effets : dissociation (extra-corporalité), visions psychédéliques, troubles neuro ; risque coma.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Vocabulaire
          _ConditionCard(
            title: "VII — Vocabulaire utilisé (argot / repères)",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _BulletPoint(text: "Acid / Acide : LSD-25."),
              _BulletPoint(
                text: "Amphes : amphétamines. — Speed : amphétamines.",
              ),
              _BulletPoint(text: "Bang : cannabis. — Boulette : haschich."),
              _BulletPoint(text: "Neige : cocaïne. — CC / Coke : cocaïne."),
              _BulletPoint(text: "Caillou / Galettes / Slam : crack."),
              _BulletPoint(text: "Képa : dose individuelle."),
              _BulletPoint(
                text: "OD : overdose (surdose). — Descente : fin des effets.",
              ),
              _BulletPoint(
                text: "Shoot / Fix : injection. — Shooteuse : seringue.",
              ),
              _BulletPoint(
                text: "Flash / Super-flash : plaisir intense à l’injection.",
              ),
              _BulletPoint(
                text: "Flash-back : retour d’effets (LSD) sans reprise.",
              ),
              _BulletPoint(text: "Trip : sous influence d’hallucinogène."),
              _BulletPoint(
                text: "Speed ball : mélange héroïne/cocaïne (ou amphétamines).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "En résumé (mémo rapide)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _IntroBullet(
                text:
                    "Connaître les définitions (dépendance, sevrage, surdose, tolérance).",
              ),
              _IntroBullet(
                text:
                    "Identifier les grandes familles : naturel / synthèse / médicaments détournés.",
              ),
              _IntroBullet(
                text:
                    "Retenir les présentations typiques (poudre, cailloux, buvards, fioles, comprimés, sachets…).",
              ),
              _IntroBullet(
                text:
                    "Savoir citer les repères légaux CSP en cas de question de classification.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Si tu ajoutes d’autres références (CP/CPP/CSI/CSP) dans cette page plus tard, mets uniquement la partie “Article … du …” en rouge.",
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
