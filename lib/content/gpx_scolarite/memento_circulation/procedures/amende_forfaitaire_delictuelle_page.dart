import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class AmendeForfaitaireDelictuellePage extends StatelessWidget {
  const AmendeForfaitaireDelictuellePage({super.key});

  static const String routeName =
      '/gpx/memento_circulation/procedures/amende_forfaitaire_delictuelle';

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
    final Color cardCadre = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardInfra = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardExclu = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardMontants = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardPaiement = isDark
        ? const Color(0xFF1E2630)
        : const Color(0xFFF3F6FA);

    final Color accentBlue = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color accentGrey = isDark ? Colors.white70 : const Color(0xFF616161);
    final Color accentGreen = isDark
        ? const Color(0xFF66BB6A)
        : const Color(0xFF2E7D32);
    final Color accentAmber = isDark
        ? const Color(0xFFFFCA28)
        : const Color(0xFFF9A825);
    final Color accentPink = isDark
        ? const Color(0xFFF48FB1)
        : const Color(0xFFC2185B);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textMain),
          tooltip: ScolariteText.value(
            "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
            "f00002",
            "Procédures — circulation",
          ),
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
            ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
              "f00003",
              "L’amende forfaitaire délictuelle (A.F.D.)",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
              "f00004",
              "I — Élément légal",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
                    "f00005",
                    "Articles L. 221-2 et L. 324-2 du Code de la route",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " ; "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
                    "f00006",
                    "articles 495-17 à 495-25 du Code de procédure pénale",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " ; "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
                    "f00007",
                    "articles D. 45-3 à D. 45-21 du Code de procédure pénale",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " ; "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
                    "f00008",
                    "articles A. 36-14 à A. 36-18 du Code de procédure pénale",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
                      "f00009",
                      "Les A.P.J.A. ne sont pas habilités à constater les délits par procès-verbal.",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Cadre + info au contrevenant
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
              "f00010",
              "II — Cadre & information du contrevenant",
            ),
            cardColor: cardCadre,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
                      "f00011",
                      "Les délits concernés sont constatés par procès-verbal électronique (PVe). ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
                      "f00012",
                      "Au moment de la verbalisation, l’intéressé doit être avisé (mention inscrite dans le PVe) :",
                    ),
              ),
              SizedBox(height: 8),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
                  "f00013",
                  "Qu’il recevra par lettre simple à son domicile : avis d’amende forfaitaire, notice de paiement et formulaire de requête en exonération.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
                  "f00014",
                  "Qu’il peut payer immédiatement l’A.F.D. minorée entre les mains de l’agent verbalisateur.",
                ),
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
                    "f00015",
                    "Référence paiement immédiat : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
                    "f00016",
                    "article A. 37-27-6 du Code de procédure pénale",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Délits concernés
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
              "f00017",
              "III — Délits concernés (A.F.D.)",
            ),
            cardColor: cardInfra,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
                  "f00018",
                  "Délits pouvant donner lieu à A.F.D.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
                  "f00019",
                  "Conduite d’un véhicule sans permis (Natinf 7536).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
                  "f00020",
                  "Conduite avec un permis d’une catégorie n’autorisant pas la conduite du véhicule (Natinf 22872).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
                  "f00021",
                  "Conduite d’un véhicule terrestre à moteur sans assurance (Natinf 6163).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
                  "f00022",
                  "Entrave à la circulation des véhicules sur une voie publique (Natinf 2271).",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Exclusions / impossibilité AFD
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
              "f00023",
              "IV — Cas d’exclusion (A.F.D. impossible)",
            ),
            cardColor: cardExclu,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
                  "f00024",
                  "L’A.F.D. ne peut pas être mise en œuvre si l’auteur des faits :",
                ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
                  "f00025",
                  "N’est pas formellement identifié.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
                  "f00026",
                  "Est mineur.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
                  "f00027",
                  "Présente une difficulté de compréhension (pas dans un état normal, ne maîtrise pas la langue française, discernement altéré, majeur protégé).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
                  "f00028",
                  "Est en état de récidive légale (même délit ou délit assimilé).",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "TAJ",
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
                      "f00029",
                      "La consultation préalable du traitement des antécédents judiciaires (T.A.J.) est impérative.",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
                    "f00030",
                    "Récidive (délai 5 ans) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
                    "f00031",
                    "article 132-10 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
                    "f00032",
                    " — sauf délits ayant déjà fait l’objet d’une A.F.D. (une succession d’A.F.D. pour le même délit est possible).",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
                    "f00033",
                    "Délits assimilés : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
                    "f00034",
                    "article 132-16-2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
                    "f00035",
                    " (exemples listés ci-dessous).",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
                  "f00036",
                  "Défaut de permis de conduire : L. 221-2 C. route.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
                  "f00037",
                  "CEEA / CEI / refus de se soumettre aux vérifications : L. 234-1 C. route.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
                  "f00038",
                  "Conduite après usage de stupéfiants / refus de vérifications : L. 235-1 C. route.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
                  "f00039",
                  "Délit de grande vitesse : L. 413-1 C. route.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
                  "f00040",
                  "Refus d’obtempérer (y compris aggravé) : L. 233-1 et L. 233-1-1 C. route.",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
                  "f00041",
                  "Autres situations excluant l’A.F.D.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
                  "f00042",
                  "Si le délit n’est pas constaté sur les lieux du contrôle et en présence du conducteur (ex : constaté après enquête suite à non présentation / non justification).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
                  "f00043",
                  "En cas de commission de plusieurs infractions dont l’une au moins ne peut donner lieu à amende forfaitaire.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
                  "f00044",
                  "En cas de commission simultanée des délits de défaut d’assurance et de défaut de permis de conduire.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Montants
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
              "f00045",
              "V — Montant de l’amende",
            ),
            cardColor: cardMontants,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
                    "f00046",
                    "Références : L. 221-2 IV et L. 324-2 IV du Code de la route",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              const SizedBox(height: 12),
              _AfdAmountTable(isDark: isDark),
              const SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
                  "f00047",
                  "Assurance — majoration FGAO",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
                      "f00048",
                      "Pour le délit de circulation sans assurance : majoration de 50% au profit du fonds de garantie des assurances obligatoires de dommages (FGAO). Références : ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
                      "f00049",
                      "article D. 45-5 du Code de procédure pénale",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: " et "),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
                      "f00050",
                      "article L. 211-27 du Code des assurances",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ". "),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
                      "f00051",
                      "Montants portés à 600 € (minorée), 750 € (ordinaire) et 1 500 € (majorée).",
                    ),
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Paiement / contestation
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
              "f00052",
              "VI — Paiement ou contestation de l’A.F.D.",
            ),
            cardColor: cardPaiement,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
                  "f00053",
                  "Les délais de paiement / contestation et les modalités de paiement sont identiques à ceux de l’amende forfaitaire contraventionnelle.",
                ),
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
                    "f00054",
                    "Références : article D. 45-8 du Code de procédure pénale",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
                    "f00055",
                    "article R. 49-3 du Code de procédure pénale",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 12),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
                  "f00056",
                  "Les conditions de recevabilité (requête en exonération / réclamation), ainsi que les modalités de consignation (hors cas d’exonération) sont précisées dans les documents reçus (formulaire / avis d’amende majorée).",
                ),
              ),
              SizedBox(height: 12),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
                  "f00057",
                  "Dispense de consignation",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
                      "f00058",
                      "L’auteur de la requête (ou réclamation) est dispensé du paiement de la consignation s’il adresse :",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
                  "f00059",
                  "Une photocopie du permis de conduire en cours de validité à la date de constatation des faits.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
                  "f00060",
                  "Une photocopie d’une attestation d’assurance en cours de validité à la date de constatation des faits.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
                  "f00061",
                  "Le récépissé de dépôt de plainte pour usurpation d’identité.",
                ),
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
                    "f00062",
                    "Usurpation d’identité : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
                    "f00063",
                    "article 434-23 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 12),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
                    "f00064",
                    "Mis à jour le ",
                  ),
                ),
                TextSpan(
                  text: "15/06/2025",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
            ],
          ),
        ],
      ),
    );
  }
}

class _AfdAmountTable extends StatelessWidget {
  const _AfdAmountTable({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final Color headerBg = isDark
        ? const Color(0xFF1A1A1A)
        : const Color(0xFFF1F1F1);
    final Color rowBg = isDark ? const Color(0xFF151515) : Colors.white;
    final Color border = isDark ? Colors.white12 : Colors.black12;
    final Color text = isDark ? Colors.white : const Color(0xFF111111);
    final Color subText = isDark ? Colors.white70 : const Color(0xFF444444);

    Widget headerCell(
      String t, {
      int flex = 2,
      TextAlign align = TextAlign.left,
    }) {
      return Expanded(
        flex: flex,
        child: Text(
          t,
          textAlign: align,
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 13.5,
            color: text,
          ),
        ),
      );
    }

    Widget cell(
      String t, {
      int flex = 2,
      TextAlign align = TextAlign.left,
      bool strong = false,
    }) {
      return Expanded(
        flex: flex,
        child: Text(
          t,
          textAlign: align,
          style: GoogleFonts.fustat(
            fontWeight: strong ? FontWeight.w900 : FontWeight.w700,
            fontSize: 13.5,
            color: subText,
          ),
        ),
      );
    }

    Widget row({
      required String delit,
      required String minoree,
      required String ordinaire,
      required String majoree,
    }) {
      return Container(
        decoration: BoxDecoration(
          color: rowBg,
          border: Border(top: BorderSide(color: border)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            cell(delit, flex: 5, strong: true),
            cell(minoree, flex: 2, align: TextAlign.right),
            cell(ordinaire, flex: 2, align: TextAlign.right),
            cell(majoree, flex: 2, align: TextAlign.right),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: headerBg,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Row(
              children: [
                headerCell(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
                    "f00065",
                    "Délit",
                  ),
                  flex: 5,
                ),
                headerCell(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
                    "f00066",
                    "Minorée",
                  ),
                  flex: 2,
                  align: TextAlign.right,
                ),
                headerCell("Ordinaire", flex: 2, align: TextAlign.right),
                headerCell(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
                    "f00067",
                    "Majorée",
                  ),
                  flex: 2,
                  align: TextAlign.right,
                ),
              ],
            ),
          ),
          row(
            delit: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
              "f00068",
              "Conduite d’un véhicule sans permis OU avec permis d’une catégorie non autorisée",
            ),
            minoree: "640 €",
            ordinaire: "800 €",
            majoree: "1 600 €",
          ),
          row(
            delit: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart",
              "f00069",
              "Circulation d’un véhicule à moteur sans assurance",
            ),
            minoree: "400 €*",
            ordinaire: "500 €*",
            majoree: "1 000 €*",
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
