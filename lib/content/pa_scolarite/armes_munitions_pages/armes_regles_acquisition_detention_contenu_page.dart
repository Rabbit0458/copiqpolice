import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaArmesReglesAcquisitionDetentionPage extends StatelessWidget {
  const PaArmesReglesAcquisitionDetentionPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/armes_munitions_pages/armes_regles_acquisition_detention';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardA = isDark
        ? const Color(0xFF2A1D1D)
        : const Color(0xFFFFF2F2);
    final Color cardB = isDark
        ? const Color(0xFF1D2330)
        : const Color(0xFFF3F7FF);
    final Color cardC = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardMinor = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardProc = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);

    final Color accentBlue = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color accentRed = isDark
        ? const Color(0xFFEF9A9A)
        : const Color(0xFFD32F2F);
    final Color accentGreen = isDark
        ? const Color(0xFF66BB6A)
        : const Color(0xFF2E7D32);
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
          "Armes & munitions",
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
            "Les règles d’acquisition et de détention",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // ✅ Fondement juridique en haut (élément légal)
          _ConditionCard(
            title: "Fondement juridique (à connaître)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Les catégories d’armes sont définies par leur régime juridique ",
                ),
                TextSpan(text: "d’acquisition et de détention : "),
                TextSpan(
                  text: "article L. 311-2 du C.S.I.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _SubTitle("Catégories (vue d’ensemble)"),
              _IntroBullet(
                text:
                    "Catégorie A : matériels de guerre et armes interdits (principe).",
              ),
              _IntroBullet(
                text: "Catégorie B : armes soumises à autorisation.",
              ),
              _IntroBullet(
                text: "Catégorie C : armes soumises à déclaration.",
              ),
              _IntroBullet(
                text:
                    "Catégorie D : acquisition et détention libres (sous conditions).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // I — Catégorie A
          _ConditionCard(
            title: "I — Armes de catégorie A : interdiction (principe)",
            cardColor: cardA,
            accent: accentRed,
            titleColor: textMain,
            children: [
              const _Paragraph.rich([
                TextSpan(
                  text:
                      "L’acquisition et la détention des armes de catégorie A sont interdites. ",
                ),
                TextSpan(
                  text: "Toutefois, des autorisations peuvent être délivrées ",
                ),
                TextSpan(text: "pour ce type d’armement : "),
                TextSpan(
                  text: "art. L. 312-2 du C.S.I.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              const SizedBox(height: 12),

              const _SubTitle("Cas d’autorisations (exemples encadrés)"),
              _Paragraph.rich([
                TextSpan(
                  text: "Fonctionnaires et agents publics ",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : const Color(0xFF050505),
                  ),
                ),
                const TextSpan(text: "— "),
                const TextSpan(
                  text: "art. R. 312-23 al. 1 du C.S.I.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : certains ministères/administrations peuvent acquérir et détenir des matériels/armes/munitions "
                      "de toute catégorie pour remise aux agents dans l’exercice des fonctions.",
                ),
              ]),
              const SizedBox(height: 10),

              _Paragraph.rich([
                TextSpan(
                  text: "Spectacles ",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : const Color(0xFF050505),
                  ),
                ),
                const TextSpan(text: "— "),
                const TextSpan(
                  text: "art. R. 312-26 du C.S.I.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : location d’armes à des productions (films/spectacles) et autorisation de détention d’armes "
                      "de spectacles (cat. A) + possible détention de munitions inertes/à blanc.",
                ),
              ]),
              const SizedBox(height: 10),

              _Paragraph.rich([
                TextSpan(
                  text: "Collectivités, musées, collections ",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : const Color(0xFF050505),
                  ),
                ),
                const TextSpan(text: "— "),
                const TextSpan(
                  text: "art. R. 312-27 du C.S.I.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : autorisations possibles sous réserves (musées, services de l’État, collectivités, organismes culturels/historiques, "
                      "collections, établissements d’enseignement, etc.).",
                ),
              ]),
              const SizedBox(height: 10),

              _Paragraph.rich([
                TextSpan(
                  text: "Essais industriels ",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : const Color(0xFF050505),
                  ),
                ),
                const TextSpan(text: "— "),
                const TextSpan(
                  text: "art. R. 312-30 du C.S.I.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : entreprises pouvant tester/faire des essais de résistance avec ces matériels.",
                ),
              ]),
              const SizedBox(height: 10),

              _Paragraph.rich([
                TextSpan(
                  text: "Experts judiciaires ",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : const Color(0xFF050505),
                  ),
                ),
                const TextSpan(text: "— "),
                const TextSpan(
                  text: "art. R. 312-31 du C.S.I.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : autorisation possible (besoins exclusifs de l’activité) ; l’autorisation porte sur un seul exemplaire "
                      "défini (marque, modèle, calibre, mode de tir).",
                ),
              ]),
              const SizedBox(height: 10),

              _Paragraph.rich([
                TextSpan(
                  text: "Tir sportif (cas particuliers) ",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : const Color(0xFF050505),
                  ),
                ),
                const TextSpan(text: "— "),
                const TextSpan(
                  text: "art. R. 312-39-1 et R. 312-40 du C.S.I.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : autorisations possibles dans certaines conditions (fédération délégataire, associations agréées, personnes majeures, "
                      "tireurs sélectionnés mineurs pour compétitions internationales).",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // II — Catégorie B
          _ConditionCard(
            title: "II — Armes de catégorie B : autorisation",
            cardColor: cardB,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              const _Paragraph.rich([
                TextSpan(
                  text:
                      "L’autorisation d’acquisition et de détention est prévue par ",
                ),
                TextSpan(
                  text: "l’article R. 312-21 du C.S.I.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " et est accordée pour "),
                TextSpan(text: "5 ans renouvelable : "),
                TextSpan(
                  text: "art. R. 312-13 du C.S.I.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),

              const _SubTitle("Délais clés (très importants)"),
              const _Paragraph.rich([
                TextSpan(
                  text: "Décision du préfet notifiée dans un délai de ",
                ),
                TextSpan(
                  text: "15 jours",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(text: ". Ensuite, le bénéficiaire dispose de "),
                TextSpan(
                  text: "6 mois",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      " pour acquérir l’arme ; passé ce délai l’autorisation devient ",
                ),
                TextSpan(
                  text: "caduque",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " : "),
                TextSpan(
                  text: "art. R. 312-12 du C.S.I.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              const _Paragraph.rich([
                TextSpan(
                  text:
                      "Le renouvellement doit être demandé au plus tard trois mois avant l’expiration ; "
                      "un récépissé est délivré : ",
                ),
                TextSpan(
                  text: "art. R. 312-14 du C.S.I.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              const _Paragraph.rich([
                TextSpan(text: "Le silence pendant trois mois vaut "),
                TextSpan(
                  text: "rejet",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " : "),
                TextSpan(
                  text: "art. R. 312-10-1 du C.S.I.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              const SizedBox(height: 12),

              const _SubTitle("Bénéficiaires / cas fréquents cités au cours"),
              _Paragraph.rich([
                TextSpan(
                  text: "Fonctionnaires et agents publics ",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : const Color(0xFF050505),
                  ),
                ),
                const TextSpan(text: "— références : "),
                const TextSpan(
                  text: "art. R. 312-23, R. 312-23-1 et R. 312-24 du C.S.I.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Organisations internationales ",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : const Color(0xFF050505),
                  ),
                ),
                const TextSpan(text: "— "),
                const TextSpan(
                  text: "art. R. 312-25-1 du C.S.I.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Spectacles ",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : const Color(0xFF050505),
                  ),
                ),
                const TextSpan(text: "— "),
                const TextSpan(
                  text: "art. R. 312-26 du C.S.I.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Collectivités, musées, collections ",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : const Color(0xFF050505),
                  ),
                ),
                const TextSpan(text: "— "),
                const TextSpan(
                  text: "art. R. 312-27 du C.S.I.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Essais industriels ",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : const Color(0xFF050505),
                  ),
                ),
                const TextSpan(text: "— "),
                const TextSpan(
                  text: "art. R. 312-30 du C.S.I.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Experts judiciaires ",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : const Color(0xFF050505),
                  ),
                ),
                const TextSpan(text: "— "),
                const TextSpan(
                  text: "art. R. 312-31 et R. 312-34 du C.S.I.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 12),

              const _SubTitle(
                "Activités privées de sécurité (extraits du cours)",
              ),
              const _Paragraph.rich([
                TextSpan(
                  text: "• Surveillance armée (risque exceptionnel) : ",
                ),
                TextSpan(
                  text: "art. R. 613-3 II du C.S.I.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              const SizedBox(height: 6),
              const _Paragraph.rich([
                TextSpan(text: "• Transport de fonds (convoyeurs) : "),
                TextSpan(
                  text: "art. R. 613-41 du C.S.I.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              const SizedBox(height: 6),
              const _Paragraph.rich([
                TextSpan(text: "• Protection physique des personnes : "),
                TextSpan(
                  text: "art. R. 613-3 V du C.S.I.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " (arrêté du ministre de l’intérieur, 1 an renouvelable).",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Personnes exposées à des risques sérieux du fait de leur activité ",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : const Color(0xFF050505),
                  ),
                ),
                const TextSpan(text: "— "),
                const TextSpan(
                  text: "art. R. 312-39 du C.S.I.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : autorisation possible pour acquérir/détenir certaines armes sur le lieu d’exercice (et parfois une seconde arme au domicile/résidence secondaire).",
                ),
              ]),
              const SizedBox(height: 12),

              const _SubTitle("Tir sportif — point “police nationale” (cours)"),
              const _Paragraph.rich([
                TextSpan(text: "Référence spécifique : "),
                TextSpan(
                  text: "art. R. 411-3-1 du C.S.I.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text: " (avec obligations, arrêté du 17 septembre 2024).",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // III — Refus d'autorisation
          _ConditionCard(
            title: "III — Refus d’autorisation (cat. A ou B)",
            cardColor: cardProc,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text:
                      "L’autorisation n’est pas accordée lorsque le demandeur remplit l’une des conditions listées par ",
                ),
                TextSpan(
                  text: "l’article R. 312-21 du C.S.I.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " (extraits clés ci-dessous)."),
              ]),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    "Inscription au FINIADA (personnes interdites d’acquisition/détention d’armes).",
              ),
              _Paragraph.rich([
                TextSpan(text: "Référence : "),
                TextSpan(
                  text: "art. L. 312-16 du C.S.I.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    "Condamnations pour certaines infractions (bulletin n°2 ou équivalent).",
              ),
              _Paragraph.rich([
                TextSpan(text: "Référence : "),
                TextSpan(
                  text: "art. L. 312-3 (1°) du C.S.I.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    "Comportement incompatible révélé par enquête administrative (consultations possibles de traitements de données).",
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    "Mesure de protection juridique, soins psychiatriques sans consentement, ou état incompatible.",
              ),
              _Paragraph.rich([
                TextSpan(text: "Références : "),
                TextSpan(
                  text: "art. 425 du code civil",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " ; "),
                TextSpan(
                  text: "art. 706-135 du code de procédure pénale",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " ; "),
                TextSpan(
                  text:
                      "art. L. 3212-1 à L. 3213-11 du code de la santé publique",
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
                        "Interdiction administrative possible si le comportement laisse craindre une utilisation dangereuse : ",
                  ),
                  TextSpan(
                    text: "L. 312-3-1 du C.S.I.",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ". "),
                  TextSpan(
                    text:
                        "Interdiction également en cas d’ordonnance de protection : ",
                  ),
                  TextSpan(
                    text: "art. L. 312-3-2 du C.S.I.",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),
              SizedBox(height: 12),
              _NotaBox(
                title: "NOTA (retrait)",
                bodySpans: [
                  TextSpan(
                    text:
                        "Les autorisations peuvent être retirées pour des raisons d’ordre public ou de sécurité des personnes : ",
                  ),
                  TextSpan(
                    text: "art. L. 312-11 du C.S.I.",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: " et "),
                  TextSpan(
                    text: "art. L. 312-7 du C.S.I.",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // IV — Catégories C et D
          _ConditionCard(
            title: "IV — Armes de catégories C et D",
            cardColor: cardC,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _SubTitle("Catégorie C : déclaration"),
              _Paragraph(
                "L’acquisition des armes et éléments d’armes de catégorie C est subordonnée à une procédure de déclaration. "
                "La détention est autorisée si l’arme a été déclarée et acquise légalement.",
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(text: "Conditions de présentation (cours) — "),
                TextSpan(
                  text: "art. L. 312-4-1 du C.S.I.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " :"),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: "Certificat médical de moins d’un mois ;",
              ),
              _BulletPoint(
                text:
                    "Permis de chasser + validation annuelle (ou année précédente) ; ou",
              ),
              _BulletPoint(
                text: "Licence de tir en cours de validité ; ou",
              ),
              _BulletPoint(text: "Carte de collectionneur d’armes."),
              SizedBox(height: 12),

              _SubTitle("Catégorie D : libre (principe)"),
              _Paragraph(
                "Les personnes majeures peuvent acquérir et détenir librement les armes et leurs éléments de catégorie D "
                "(dans le respect des règles applicables).",
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Rappel : interdiction d’acquisition/détention d’armes de toutes catégories en cas d’ordonnance de protection : ",
                ),
                TextSpan(
                  text: "art. L. 312-3-2 du C.S.I.",
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

          // V — Mineurs
          _ConditionCard(
            title: "V — Régime applicable aux mineurs",
            cardColor: cardMinor,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Principe : l’acquisition et la détention par les mineurs sont interdites : ",
                ),
                TextSpan(
                  text: "art. L. 312-1 du C.S.I.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(text: "Exceptions prévues par "),
                TextSpan(
                  text: "l’article R. 312-52 du C.S.I.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " sous condition d’autorisation parentale (sauf si la personne est inscrite au FINIADA). "
                      "L’acquisition doit être réalisée par la personne exerçant l’autorité parentale.",
                ),
              ]),
              SizedBox(height: 12),

              _SubTitle("Exceptions (repères à connaître)"),
              _Paragraph.rich([
                TextSpan(text: "• Mineurs de plus de 9 ans : "),
                TextSpan(
                  text: "catégorie D (h) et (h bis)",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " avec licence de tir."),
              ]),
              SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(text: "• Mineurs de plus de 12 ans : "),
                TextSpan(
                  text: "catégorie C",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      " avec licence de tir. Utilisation possible des lanceurs de paintball (cat. D h) sur terrains déclarés : ",
                ),
                TextSpan(
                  text: "art. R. 312-52 al. 5 du C.S.I.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 6),
              _Paragraph(
                "• Mineurs de plus de 16 ans : catégorie C possible avec permis de chasser ; "
                "détention possible d’armes historiques et de collection de catégorie D (selon cas).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // VI — Dessaisissement
          _ConditionCard(
            title: "VI — Dessaisissement de l’arme",
            cardColor: cardProc,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph.rich([
                TextSpan(text: "Dispositions générales : "),
                TextSpan(
                  text: "art. R. 312-17 du C.S.I.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _SubTitle("Cas de dessaisissement (délais)"),
              _BulletPoint(
                text:
                    "Autorisation expirée sans demande de renouvellement : dessaisissement/neutralisation sous 3 mois.",
              ),
              _BulletPoint(
                text:
                    "Autorisation nulle de plein droit : dessaisissement/neutralisation sous 3 mois.",
              ),
              SizedBox(height: 10),
              _SubTitle("Refus de conservation"),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Arme cat. A ou B trouvée ou reçue par succession et non conservée : dessaisissement sans déclaration préalable via compte individualisé : ",
                ),
                TextSpan(
                  text: "art. R. 312-51-1 du C.S.I.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Même logique pour une arme/élément/munitions cat. C : ",
                ),
                TextSpan(
                  text: "art. R. 312-55-1 du C.S.I.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 12),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Cas particulier (ordre public / sécurité des personnes) : le préfet peut ordonner le dessaisissement : ",
                ),
                TextSpan(
                  text: "art. L. 312-11 du C.S.I.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text: " (procédure contradictoire sauf urgence).",
                ),
              ]),
              SizedBox(height: 12),
              _SubTitle("Moyens de dessaisissement"),
              _Paragraph.rich([
                TextSpan(text: "Modalités : "),
                TextSpan(
                  text: "art. R. 312-74 du C.S.I.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " — exemples : vente (armurier/particulier autorisé), destruction, remise à l’État, dépôt chez un armurier désigné.",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // VII — Mise en possession
          _ConditionCard(
            title: "VII — Mise en possession (arme trouvée / succession)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _SubTitle("Arme de catégorie A ou B"),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Toute personne qui souhaite conserver une arme/élément/munitions de cat. A ou B trouvés ou reçus par succession "
                      "déclare la mise en possession sans délai via le compte individualisé : ",
                ),
                TextSpan(
                  text: "art. R. 312-51 du C.S.I.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                "Elle dispose d’un délai de 12 mois pour remplir les conditions d’autorisation ou se mettre en conformité (quotas). "
                "Pendant ce délai, dépôt auprès d’un professionnel autorisé ; à défaut, le préfet peut ordonner le dessaisissement.",
              ),
              SizedBox(height: 12),

              _SubTitle("Arme de catégorie C"),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Mise en possession d’une arme/élément cat. C (trouvée/succession) : se conformer aux règles de déclaration, notamment via le compte individualisé : ",
                ),
                TextSpan(
                  text: "art. R. 312-55 du C.S.I.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _BulletPoint(text: "Déclaration sans délai ;"),
              _BulletPoint(
                text: "Certificat médical de moins d’un mois ;",
              ),
              _BulletPoint(
                text:
                    "À défaut, dessaisissement possible selon les modalités prévues (ex. art. R. 312-74 et R. 312-75 C.S.I.).",
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
