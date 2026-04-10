import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VolPage extends StatelessWidget {
  const VolPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/crime_delit_bien_pages/vol';

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
          "Atteintes aux biens",
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
            "Le vol",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // ✅ Élément légal en haut (exigence)
          _ConditionCard(
            title: "I — Élément légal",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: "Article 311-1 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : définit le vol (« la soustraction frauduleuse de la chose d’autrui »).",
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 311-3 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " : prévoit la répression du vol simple."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Cas assimilé : l’énergie — "),
                TextSpan(
                  text: "article 311-2 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Définition
          _ConditionCard(
            title: "Définition",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le vol est la soustraction frauduleuse de la chose d’autrui.",
              ),
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
              _NotaBox(
                title: "Principe",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Il y a vol lorsque la chose passe de la possession du légitime détenteur dans celle de l’auteur, "
                        "à l’insu et contre le gré du premier ; pour soustraire, il faut prendre, enlever, ravir — ",
                  ),
                  TextSpan(
                    text: "Cass. crim., 18 novembre 1837",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 12),

              const _SubTitle("A) La soustraction"),
              const _Paragraph(
                "La soustraction correspond au rapt de la chose : un déplacement matériel (prise de possession) "
                "réalisé à l’insu et/ou contre le gré du détenteur.",
              ),
              const SizedBox(height: 10),

              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Manifestation : intrusion et consommation du contenu d’un réfrigérateur — ",
                  ),
                  TextSpan(
                    text: "Cass. crim., 03 mars 1992",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Enlèvement de marchandises sans signer le bon de livraison — ",
                  ),
                  TextSpan(
                    text: "Cass. crim., 04 novembre 1977",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Soustraction de caddies avec poignées recouvertes pour masquer la marque de la victime — ",
                  ),
                  TextSpan(
                    text: "C.A. Nancy, 22 mars 1988",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle("B) La chose"),
              const _Paragraph(
                "La « chose » susceptible de vol est, en principe, une chose mobilière (déplaçable). "
                "La jurisprudence a néanmoins étendu le champ de l’incrimination.",
              ),
              const SizedBox(height: 10),

              const _SubTitle("1) Chose mobilière (corporelle)"),
              const _Paragraph(
                "Exemples : bijou, voiture, livre, animal, objet mobilier, voire parties du corps humain "
                "(organe, sang) ou cadavre (dans certains cas).",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  const TextSpan(text: "Vol d’un sanglier — "),
                  TextSpan(
                    text: "Cass. crim., 30 janvier 1992",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 12),

              const _SubTitle("2) Chose incorporelle : principe d’exclusion"),
              const _Paragraph(
                "Une prestation de services, par nature incorporelle, n’est pas susceptible d’appropriation "
                "au titre du vol (ex. communications téléphoniques).",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Communications téléphoniques : prestation de services non susceptible d’appropriation — ",
                  ),
                  TextSpan(
                    text: "Cass. crim., 12 décembre 1990",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 12),

              const _SubTitle("3) Immeuble devenu meuble"),
              const _Paragraph(
                "Dès qu’un élément est détaché du fonds auquel il adhérait (tuiles, pierres…), "
                "il devient meuble et peut être volé.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Prendre des pierres sur des propriétés voisines pour construire un mur — ",
                  ),
                  TextSpan(
                    text: "Cass. crim., 27 avril 1866",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 12),

              const _SubTitle("4) L’énergie (cas assimilé)"),
              _Paragraph.rich([
                const TextSpan(text: "Prévu par "),
                TextSpan(
                  text: "l’article 311-2 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : l’électricité peut être appréhendée et faire l’objet d’une soustraction.",
                ),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  const TextSpan(
                    text:
                        "L’électricité passe, par transmission matériellement constatable, de la possession de l’un à celle de l’autre — ",
                  ),
                  TextSpan(
                    text: "Cass. crim., 03 août 1992",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 12),

              const _SubTitle("5) L’information"),
              const _Paragraph(
                "Par principe, l’information est incorporelle. Toutefois, une information matérialisée sur un support "
                "peut être considérée comme mobilière et donc susceptible de vol (jurisprudence parfois discutée).",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  const TextSpan(text: "Fichiers informatiques — "),
                  TextSpan(
                    text: "Cass. crim., 04 mars 2008",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle("C) « D’autrui »"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "On ne vole qu’une chose ayant un propriétaire au moment de l’appréhension : ",
                ),
                TextSpan(
                  text: "Cass. crim., 30 janvier 1992",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "L’identité du propriétaire n’a pas à être connue pour caractériser le vol : ",
                ),
                TextSpan(
                  text: "Cass. crim., 25 octobre 2000",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "La preuve de la propriété relève souvent du civil (expertises, attestations, notoriété) : ",
                ),
                TextSpan(
                  text: "Cass. crim., 23 novembre 2004",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 12),
              const _SubTitle("Points classiques (à connaître)"),
              const _BulletPoint(
                text:
                    "Chose commune : le vol est possible si un indivisaire soustrait la chose (ex. succession indivise).",
              ),
              const _BulletPoint(
                text:
                    "Chose perdue : pas assimilée à l’abandon ; la conservation peut constituer un vol selon les circonstances.",
              ),
              const _BulletPoint(
                text:
                    "Épave : doit être déclarée (certaines épaves archéologiques appartiennent à l’État).",
              ),
              const _BulletPoint(
                text:
                    "Trésor : règles civiles (article 716 du Code civil : moitié inventeur / moitié propriétaire du terrain).",
              ),
              const _BulletPoint(
                text:
                    "Chose illicite (stupéfiants…) : la nature illicite est sans influence sur la qualification de vol.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  const TextSpan(text: "Succession indivise — "),
                  TextSpan(
                    text: "Cass. crim., 27 février 1996",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  const TextSpan(text: "Billet d’avion (chose perdue) — "),
                  TextSpan(
                    text: "Cass. crim., 19 décembre 1990",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Marchandise illicite : sans influence sur la qualification de vol — ",
                  ),
                  TextSpan(
                    text: "Cass. crim., 05 novembre 1985",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Choses mises à la poubelle : présumées abandonnées — ",
                  ),
                  TextSpan(
                    text: "Cass. crim., 15 décembre 2015",
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

          const SizedBox(height: 14),

          // Élément moral
          _ConditionCard(
            title: "III — Élément moral",
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "La soustraction n’est un vol que si elle est frauduleuse : l’infraction exige une intention coupable "
                "(constatée au moment des faits). Le mobile est indifférent.",
              ),
              const SizedBox(height: 12),

              const _SubTitle(
                "A) Conscience de soustraire une chose qui ne lui appartient pas",
              ),
              const _Paragraph(
                "L’auteur doit être conscient d’agir contre le gré et à l’insu du propriétaire. "
                "Le vol n’est pas retenu si l’auteur croyait de bonne foi que la chose était à lui "
                "ou qu’il était autorisé à la prendre.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Bonne foi possible (pratique ancienne) : défaut d’élément intentionnel — ",
                  ),
                  TextSpan(
                    text: "Cass. crim., 17 novembre 2015",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 12),

              const _SubTitle(
                "B) Volonté de se comporter (même momentanément) en maître de la chose",
              ),
              const _Paragraph(
                "L’intention frauduleuse réside dans la volonté de s’arroger les prérogatives du propriétaire. "
                "L’appropriation définitive n’est pas exigée : une soustraction temporaire suivie d’une restitution "
                "peut suffire si elle révèle la volonté de se comporter en propriétaire, même brièvement.",
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
            children: [
              const _Paragraph(
                "Les vols simples précédés, suivis ou accompagnés de circonstances particulières deviennent des vols aggravés. "
                "On distingue des aggravations délictuelles et criminelles, selon les circonstances (personnes, moyens, lieux…).",
              ),
              const SizedBox(height: 12),

              const _SubTitle("A) Vols aggravés délictuels"),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 311-4 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " (principales hypothèses) :"),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Réunion (plusieurs auteurs/complices) hors bande organisée.",
              ),
              const _BulletPoint(
                text:
                    "Auteur dépositaire de l’autorité publique / mission de service public (à l’occasion des fonctions).",
              ),
              const _BulletPoint(
                text:
                    "Prise indue de la qualité d’agent public / mission de service public.",
              ),
              const _BulletPoint(
                text:
                    "Violences n’ayant pas entraîné d’ITT (lien de connexité non exigé).",
              ),
              const _BulletPoint(
                text:
                    "Local d’habitation / lieu d’entrepôt de fonds, valeurs, marchandises ou matériels.",
              ),
              const _BulletPoint(
                text: "Transport collectif de voyageurs (véhicule ou accès).",
              ),
              const _BulletPoint(
                text: "Destruction / dégradation / détérioration.",
              ),
              const _BulletPoint(text: "Dissimulation volontaire du visage."),
              const _BulletPoint(
                text:
                    "Établissements d’enseignement (ou abords, entrées/sorties).",
              ),
              const _BulletPoint(
                text: "Destiné à alimenter le commerce illégal d’animaux.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "NOTA",
                bodySpans: [
                  const TextSpan(
                    text: "Vol suivi de violences (fuite/impunité) — ",
                  ),
                  TextSpan(
                    text: "article 311-11 du Code pénal",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 12),

              _Paragraph.rich([
                TextSpan(
                  text: "Article 311-4-1 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : majeur aidé par un ou plusieurs mineurs (cas particulier).",
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 311-4-2 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : biens culturels, archives privées classées, découvertes archéologiques, etc.",
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 311-5 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : ITT ≤ 8 jours / vulnérabilité / habitation-entrepôt avec ruse-effraction-escalade.",
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 311-6 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " : ITT > 8 jours."),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("B) Vols aggravés criminels"),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 311-7 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " : mutilation ou infirmité permanente."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 311-8 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : usage/menace d’une arme ou port d’une arme prohibée/soumise à autorisation.",
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 311-9 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : bande organisée (et combinaisons avec violences/arme).",
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 311-10 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " : mort / tortures / actes de barbarie."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité + immunité
          _ConditionCard(
            title: "V — Répression",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              const _SubTitle("Peines principales (repères)"),
              _Paragraph.rich([
                const TextSpan(text: "Vol simple : "),
                const TextSpan(
                  text: "3 ans d’emprisonnement et 45 000 € d’amende — ",
                ),
                TextSpan(
                  text: "article 311-3 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Vol aggravé (délit) : "),
                const TextSpan(
                  text:
                      "paliers possibles (5/7/10 ans + amendes) selon les articles ",
                ),
                TextSpan(
                  text: "311-4 à 311-6 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Vol aggravé (crime) : "),
                const TextSpan(
                  text:
                      "réclusion (15/20/30 ans ou perpétuité) selon les articles ",
                ),
                TextSpan(
                  text: "311-7 à 311-10 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("Personnes morales"),
              _Paragraph.rich([
                const TextSpan(text: "Peines prévues par "),
                TextSpan(
                  text: "l’article 311-16 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("Amende forfaitaire délictuelle (vol simple)"),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 311-3-1 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : possible sous conditions (notamment valeur ≤ 300 € et restitution/indemnisation). "
                      "Procédure d’amende forfaitaire : ",
                ),
                TextSpan(
                  text: "articles 495-17 à 495-25 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("Tentative & complicité"),
              _Paragraph.rich([
                const TextSpan(text: "Tentative : OUI — "),
                TextSpan(
                  text: "article 311-13 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " (punissable pour le vol simple, aggravé délictuel ou criminel).",
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text: "Complicité : OUI — application des règles générales (",
                ),
                TextSpan(
                  text: "articles 121-6 et 121-7 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: ")."),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("Immunité familiale"),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 311-12 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : pas de poursuites pénales pour le vol commis au préjudice de l’ascendant/descendant ou du conjoint "
                      "(sauf séparation de corps / résidence séparée autorisée).",
                ),
              ]),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Exceptions : objets/documents indispensables à la vie quotidienne (identité, titre de séjour, moyens de paiement, télécommunication…).",
              ),
              const _BulletPoint(
                text:
                    "Exceptions : auteur tuteur/curateur/mandataire spécial (sauvegarde), habilitation familiale, mandat de protection future.",
              ),
              const SizedBox(height: 10),

              const _SubTitle(
                "Exemption / réduction de peine (bande organisée)",
              ),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 311-9-1 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : exemption si l’alerte permet d’éviter l’infraction ; réduction des 2/3 si l’alerte permet de faire cesser "
                      "l’infraction / éviter des conséquences graves / identifier les autres auteurs ou complices.",
                ),
              ]),
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
