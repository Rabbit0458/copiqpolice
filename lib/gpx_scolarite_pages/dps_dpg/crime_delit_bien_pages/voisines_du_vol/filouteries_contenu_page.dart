import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FilouteriesPage extends StatelessWidget {
  const FilouteriesPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/crime_delit_bien_pages/voisines_du_vol/filouteries';

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
          "Infractions voisines du vol",
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
            "Les filouteries",
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
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "La filouterie est le fait, pour une personne qui sait être dans l’impossibilité absolue de payer "
                "ou qui est déterminée à ne pas payer, d’obtenir certains biens ou services auprès de professionnels "
                "(restauration, hôtellerie, carburant servi, transport en taxi/voiture de place).",
              ),
              SizedBox(height: 10),
              _IntroBullet(
                text:
                    "4 hypothèses limitatives : restaurant/café, hôtel (≤ 10 jours), carburant/lubrifiants servis, taxi/voiture de place.",
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
                  text: "Article 313-5 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : définit et réprime les filouteries (4 cas limitatifs).",
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
              const _Paragraph(
                "La filouterie consiste à obtenir, auprès de professionnels, certains biens ou services "
                "en se sachant dans l’impossibilité absolue de payer ou en étant déterminé à ne pas payer.\n"
                "Elle protège des professions où les usages ne permettent pas de vérifier la solvabilité "
                "ou d’exiger un paiement d’avance.",
              ),
              const SizedBox(height: 12),

              const _SubTitle(
                "A) Une condition préalable : impécuniosité absolue ou refus de payer",
              ),
              const SizedBox(height: 6),
              const _BulletPoint(
                text:
                    "Impossibilité absolue de payer : aucune ressource, aucun patrimoine, aucun moyen de paiement au moment des faits.",
              ),
              const _BulletPoint(
                text:
                    "Détermination à ne pas payer : l’auteur est solvable, mais décide de ne pas régler (souvent révélée par la fuite au moment de payer).",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "La notion d’« impossibilité absolue » est très exigeante : si le professionnel consent un crédit ou des délais de paiement, la répression est en principe exclue. ",
                  ),
                  TextSpan(
                    text:
                        "(ex. C.A. Paris, 22 février 1883 ; C.A. Paris, 9 avril 1986)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle("B) Une remise volontaire dans 4 cas limitatifs"),
              const _Paragraph(
                "La filouterie se distingue du vol (remise volontaire par la victime) et de l’escroquerie "
                "(pas de manœuvres frauduleuses déterminantes : la remise résulte du fonctionnement normal de la profession).",
              ),
              const SizedBox(height: 12),

              const _SubTitle(
                "1) Boissons ou aliments (établissement vendant boissons/aliments)",
              ),
              const _BulletPoint(
                text:
                    "L’auteur doit prendre l’initiative (passer commande, « se faire servir »).",
              ),
              const _BulletPoint(
                text:
                    "Uniquement boissons et aliments (exclut les autres marchandises).",
              ),
              const _BulletPoint(
                text:
                    "Établissement accessible au public dont l’activité principale est la vente de boissons/aliments (café, restaurant, brasserie, buvette…).",
              ),

              const SizedBox(height: 12),

              const _SubTitle(
                "2) Chambres d’hôtel (occupation effective ≤ 10 jours)",
              ),
              const _BulletPoint(
                text:
                    "Doit s’agir d’un établissement louant des chambres (hôtel, auberge…).",
              ),
              const _BulletPoint(
                text:
                    "La simple réservation ne suffit pas : il faut attribution + occupation effective (la chambre n’est plus attribuable à un autre client).",
              ),
              const _BulletPoint(
                text:
                    "Occupation n’ayant pas excédé 10 jours ; prestations annexes (téléphone, consommations…) non visées.",
              ),
              const SizedBox(height: 12),

              const _SubTitle(
                "3) Carburants ou lubrifiants (servis par un professionnel)",
              ),
              const _BulletPoint(
                text:
                    "La victime doit être un professionnel (exploitant de station-service).",
              ),
              const _BulletPoint(
                text:
                    "Condition clé : l’auteur doit « se faire servir » (si libre-service et remplissage par l’auteur, on bascule vers le vol).",
              ),
              const _BulletPoint(
                text:
                    "Produit versé dans le réservoir du véhicule (pas dans des jerrycans).",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Libre-service : pas de filouterie (remplissage par l’auteur), mais plutôt vol selon les cas. ",
                  ),
                  TextSpan(
                    text:
                        "(C.A. Rennes, 8 décembre 1980 ; C.A. Montpellier, 25 septembre 2008 ; Cass. crim., avis, 4 mai 2010)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 12),

              const _SubTitle("4) Taxi ou voiture de place"),
              const _BulletPoint(
                text: "Se faire transporter puis ne pas payer la course.",
              ),
              const _BulletPoint(
                text:
                    "Sont visés : taxis et voitures de place (transport privé loué sur la voie publique, paiement à l’arrivée).",
              ),
              const _BulletPoint(
                text:
                    "Sont exclus : transports en commun (train, métro, tram, bus…) où le paiement est en principe immédiat.",
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
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: "Article 313-5 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : l’élément moral repose sur l’une des deux situations suivantes :",
                ),
              ]),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Conscience de son impécuniosité : l’auteur sait que son impossibilité de payer est absolue.",
              ),
              const _BulletPoint(
                text:
                    "Volonté de ne pas payer : l’auteur est solvable mais refuse de régler (souvent établi par la fuite ou un motif manifestement fallacieux).",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "N’est pas punissable : l’oubli du moyen de paiement, la perte du portefeuille au moment de payer, "
                "ou la bonne foi liée à une mauvaise estimation de la somme due.",
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
            children: const [
              _BulletPoint(
                text: "Aucune circonstance aggravante prévue par le texte.",
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
              const _SubTitle("Peines encourues — personnes physiques"),
              _Paragraph.rich([
                const TextSpan(text: "Délit : "),
                const TextSpan(
                  text: "6 mois d’emprisonnement et 7 500 € d’amende. — ",
                ),
                TextSpan(
                  text: "article 313-5 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("Personnes morales"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Responsabilité pénale possible ; amende selon les modalités de ",
                ),
                TextSpan(
                  text: "l’article 131-38 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " (quintuple du montant prévu pour les personnes physiques).",
                ),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("Amende forfaitaire délictuelle"),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 313-5 alinéas 7 et 8 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : possibilité de recourir à la procédure d’amende forfaitaire délictuelle, prévue par ",
                ),
                TextSpan(
                  text:
                      "les articles 495-17 à 495-25 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: ", y compris en cas de récidive."),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("Tentative & complicité"),
              const _BulletPoint(
                text: "Tentative : NON (non prévue, donc non punissable).",
              ),
              const _BulletPoint(text: "Complicité : OUI."),
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
