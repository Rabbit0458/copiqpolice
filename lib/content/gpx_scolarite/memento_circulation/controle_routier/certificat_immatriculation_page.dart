import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class CertificatImmatriculationPage extends StatelessWidget {
  const CertificatImmatriculationPage({super.key});

  static const String routeName =
      '/gpx/memento_circulation/controle_routier/certificat_immatriculation';

  static const Color _lawRed = Color(0xFFE53935);

  TextSpan _lawSpan(String text) => TextSpan(
    text: text,
    style: const TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
  );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardRules = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardUseCases = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardProvisoire = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardInfra = isDark
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
          tooltip: ScolariteText.value(
            "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
            "f00002",
            "Contrôle routier",
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
              "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
              "f00003",
              "Les certificats d’immatriculation",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Définition / idée générale
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
              "f00004",
              "Définition",
            ),
            cardColor: cardInfra,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00005",
                      "La procédure d’immatriculation donne lieu à la délivrance d’un certificat d’immatriculation ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00006",
                      "comportant un numéro à reporter sur la ou les plaques. Certains véhicules et remorques sont soumis ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00007",
                      "à immatriculation, selon leur nature et leur PTAC.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
              "f00008",
              "I — Élément légal",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                    "f00009",
                    "R. 322-1",
                  ),
                ),
                const TextSpan(text: " à "),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                    "f00010",
                    "R. 322-8 du Code de la route",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Champ d’application
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
              "f00011",
              "II — Véhicules concernés",
            ),
            cardColor: cardRules,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00012",
                      "Doivent être immatriculés :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00013",
                      "• Les véhicules à moteur (sauf cyclomobiles légers et engins de déplacement personnel motorisés) ;\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00014",
                      "• Les remorques de PTAC > 500 kg ;\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00015",
                      "• Les semi-remorques (sauf véhicules/appareils agricoles remorqués de PTAC < 1,5 t).",
                    ),
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                    "f00016",
                    "Le numéro d’immatriculation doit être reporté sur la ou les plaques. ",
                  ),
                ),
                const TextSpan(text: "("),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                    "f00017",
                    "NATINF 7543",
                  ),
                  style: GoogleFonts.fustat(fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: ")"),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00018",
                      "Depuis le ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00019",
                      "15 avril 2009",
                    ),
                    style: GoogleFonts.fustat(fontWeight: FontWeight.w900),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00020",
                      ", le certificat délivré à tout véhicule mis en circulation pour la première fois comporte un numéro attribué à titre définitif.",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00021",
                      "Les certificats délivrés avant le 15 avril 2009 (« carte grise ») restent valables : ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00022",
                      "les véhicules concernés peuvent continuer à circuler avec ce document et les plaques correspondantes.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Séries / numérotation
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
              "f00023",
              "III — Séries et format d’immatriculation",
            ),
            cardColor: cardUseCases,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00024",
                      "Il existe deux séries d’immatriculation :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00025",
                      "• Série normale\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00026",
                      "• Série diplomatique",
                    ),
              ),
              const SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                  "f00027",
                  "A) Série normale",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00028",
                      "Le numéro attribué à titre définitif se compose de trois blocs :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00029",
                      "• 2 lettres – 3 chiffres – 2 lettres (séparés par des tirets)\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00030",
                      "Exemple : AA-111-AA",
                    ),
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                  "f00031",
                  "NOTA 1",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                          "f00032",
                          "Jusqu’au 30 juin 2015, le numéro définitif des cyclomoteurs était composé de 1 à 2 lettres, ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                          "f00033",
                          "2 à 3 chiffres, 1 lettre, avec un espace entre les blocs (ex : A 11 A, ZZ 999 Z).",
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                  "f00034",
                  "NOTA 2",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                          "f00035",
                          "Les lettres I, O et U ne sont pas utilisées (confusion avec 1, 0 et V). ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                          "f00036",
                          "L’association « SS » est interdite conformément aux dispositions du ",
                        ),
                  ),
                  _lawSpan(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00037",
                      "Code pénal",
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                  "f00038",
                  "B) Usages particuliers (série normale)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                  "f00039",
                  "Administration civile de l’État.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                  "f00040",
                  "Véhicule militaire.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                  "f00041",
                  "Véhicule agricole : numéro d’exploitation attribué par le ministre de l’intérieur.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                  "f00042",
                  "Véhicule de démonstration : comporte une date de fin de validité de l’usage.",
                ),
              ),
              const SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                  "f00043",
                  "C) Détention du certificat à bord",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00044",
                      "Le titulaire du certificat (ou son préposé) doit être à bord du véhicule. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00045",
                      "Pour les motocyclettes et cyclomoteurs, il peut être présent sur ou à bord d’un véhicule suiveur.\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00046",
                      "En cas de prêt du véhicule, le bénéficiaire doit présenter une attestation nominative de mise à disposition ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00047",
                      "(validité limitée à 10 jours maximum).",
                    ),
              ),
              const SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                  "f00048",
                  "D) Mentions d’usage : collection / transit / zones franches",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00049",
                      "• Véhicule de collection : intérêt historique, construit ou immatriculé pour la première fois il y a au moins 30 ans, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00050",
                      "non produit, maintenu dans son état d’origine. Usage personnel, sans restriction géographique.\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00051",
                      "• Véhicule en transit temporaire : véhicules privés acquis neufs en France (exonération droits/TVA) destinés à l’exportation ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00052",
                      "par des résidents hors UE en séjour temporaire. Validité : 6 mois, prorogeable une fois.\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00053",
                      "• Véhicule importé en transit : véhicules de personnes bénéficiant d’exonérations douanières/fiscales ; durée fixée par les douanes.\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00054",
                      "• Véhicule zone franche (Pays de Gex / Haute-Savoie) : marques étrangères, exemption de droits de douane ; ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00055",
                      "validité cesse dès que le propriétaire est domicilié hors zone.",
                    ),
              ),
              const SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                  "f00056",
                  "E) Série diplomatique",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00057",
                      "Pour les véhicules de statut diplomatique ou assimilé, le certificat comporte :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00058",
                      "• Un numéro définitivement assigné ;\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00059",
                      "• Un numéro spécifique lié au statut.",
                    ),
              ),
              const SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                  "f00060",
                  "CMD / CD : missions diplomatiques ou organisations internationales (ex : 100 CMD 20, 500 CD 100, U 300 CD 20).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                  "f00061",
                  "C : fonctionnaires du corps consulaire (ex : 105 C 1.75).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                  "f00062",
                  "K : fonctionnaires internationaux (ex : 105 K 100, U 305 K 10).",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Certificats provisoires
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
              "f00063",
              "IV — Certificats provisoires d’immatriculation",
            ),
            cardColor: cardProvisoire,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(text: "Voir "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                    "f00064",
                    "NATINF 6234",
                  ),
                  style: GoogleFonts.fustat(fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                  "f00065",
                  "A) CPI",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00066",
                      "Le certificat provisoire d’immatriculation (CPI) est un document sécurisé indiquant notamment ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00067",
                      "le numéro définitif. Il permet de circuler pendant 1 mois.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00068",
                      "• 8 mois : véhicules de location courte durée\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00069",
                      "• 3 mois : véhicule en attente d’immatriculation diplomatique",
                    ),
              ),
              const SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                  "f00070",
                  "B) CPI WW",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00071",
                      "Délivrable notamment pour : véhicules neufs vendus, véhicules importés (dossier incomplet/en cours), ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00072",
                      "véhicules exportés, véhicules d’occasion destinés à l’exportation, engins agricoles neufs.\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00073",
                      "Identique au CPI sauf :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00074",
                      "• numéro WW-111-AA\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00075",
                      "• validité : 2 mois prorogeable une fois (3 mois si engins agricoles).",
                    ),
              ),
              const SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                  "f00076",
                  "C) Certificat W garage",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00077",
                      "Permet à un véhicule utilisé par un professionnel de l’automobile, à des fins professionnelles, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00078",
                      "de circuler à titre provisoire sur le territoire national.\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00079",
                      "Délivré pour l’année civile en cours, sous forme d’un CI définitif avec la mention « certificat W garage » ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00080",
                      "et le millésime. Numéro : W-111-AA.\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00081",
                      "La circulation simultanée de plusieurs véhicules sous couvert du même numéro W garage est interdite.",
                    ),
              ),
              const SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                  "f00082",
                  "D) Certificat WW DPTC",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00083",
                      "Permet à un véhicule relevant d’une expérimentation de conduite à délégation partielle ou totale ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00084",
                      "de circuler sur les voies publiques.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00085",
                      "Durée maximale de l’autorisation : 2 ans.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Formalités (pédagogique + structuré)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
              "f00086",
              "V — Formalités administratives",
            ),
            cardColor: cardRules,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                  "f00087",
                  "A) Changement de propriétaire (vente / cession)",
                ),
              ),
              _Paragraph.rich([
                const TextSpan(text: "Voir "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                    "f00088",
                    "NATINF 28690",
                  ),
                  style: GoogleFonts.fustat(fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00089",
                      "L’ancien propriétaire doit notamment remettre à l’acquéreur :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00090",
                      "• Le certificat de cession (ou code de cession / cession électronique) ;\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00091",
                      "• Le certificat d’immatriculation avec mention « vendu le… » ou « cédé le… », date + signature, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00092",
                      "et coupon détachable (sauf cession à professionnel) ;\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00093",
                      "• Un certificat de situation administrative (< 15 jours) ;\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00094",
                      "• Le contrôle technique (< 6 mois) si véhicule > 4 ans.",
                    ),
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                    "f00095",
                    "Dans les 15 jours, le vendeur déclare la cession (récépissé délivré) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                    "f00096",
                    "NATINF 6237",
                  ),
                  style: GoogleFonts.fustat(fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                    "f00097",
                    "Dans le délai d’un mois, l’acquéreur demande un CI à son nom : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                    "f00098",
                    "NATINF 7544",
                  ),
                  style: GoogleFonts.fustat(fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 12),
              _NotaBox(
                title: "Pratique",
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                          "f00099",
                          "La circulation sous couvert du coupon détachable ou du CPI est possible pendant 1 mois. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                          "f00100",
                          "Dès l’obtention du CPI, la revente du véhicule est possible.",
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                  "f00101",
                  "B) Changement de domicile",
                ),
              ),
              _Paragraph.rich([
                const TextSpan(text: "Voir "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                    "f00102",
                    "NATINF 6224",
                  ),
                  style: GoogleFonts.fustat(fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00103",
                      "Le certificat portant l’ancienne adresse est valable 1 mois.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00104",
                      "• 1 à 3 déclarations : envoi d’une étiquette autocollante à apposer.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00105",
                      "• 4e déclaration : délivrance d’un nouveau certificat.",
                    ),
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "NOTA",
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                          "f00106",
                          "La notion de domicile est unique (lieu du principal établissement). Les résidences peuvent être multiples. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                          "f00107",
                          "Références : ",
                        ),
                  ),
                  _lawSpan(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00108",
                      "articles 102 à 111 du Code civil",
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                  "f00109",
                  "C) Cession pour destruction",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00110",
                      "La vente/cession pour destruction (sauf cession à un assureur) se fait auprès d’un démolisseur/broyeur agréé.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00111",
                      "Le propriétaire remet le CI avec mention « vendu/cédé le … pour destruction » + signature.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00112",
                      "Le professionnel remet une copie de déclaration d’achat pour destruction et informe le ministre de l’intérieur.",
                    ),
              ),
              const SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                  "f00113",
                  "D) Perte ou vol : duplicata",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00114",
                      "Après déclaration de perte/vol, le propriétaire demande un duplicata.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00115",
                      "Le récépissé de déclaration de perte/vol est valable 1 mois.",
                    ),
              ),
              const SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                  "f00116",
                  "E) Transformation notable",
                ),
              ),
              _Paragraph.rich([
                const TextSpan(text: "Voir "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                    "f00117",
                    "NATINF 6241",
                  ),
                  style: GoogleFonts.fustat(fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00118",
                      "Tout véhicule ayant subi des transformations notables modifiant les caractéristiques du CI ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00119",
                      "doit faire l’objet d’une nouvelle réception, et le propriétaire doit demander un nouveau CI ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00120",
                      "dans le mois suivant la transformation (ex : camionnette aménagée en transport de personnes).",
                    ),
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "NOTA",
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                          "f00121",
                          "Certains engins de compétition/loisirs non destinés à circuler (ex : pocket-bike) ne sont pas soumis à réception ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                          "f00122",
                          "et ne peuvent pas recevoir de certificat d’immatriculation : interdits de circulation sur voie publique/lieux ouverts.",
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Infractions / NATINF
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
              "f00123",
              "VI — Infractions (NATINF) & bases légales",
            ),
            cardColor: cardInfra,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                  "f00124",
                  "Infractions principales",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                    "f00125",
                    "NATINF 7543",
                  ),
                  style: GoogleFonts.fustat(fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                    "f00126",
                    " — Mise en circulation sans certificat d’immatriculation (base : ",
                  ),
                ),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                    "f00127",
                    "R. 322-1 du Code de la route",
                  ),
                ),
                const TextSpan(text: ")."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                    "f00128",
                    "NATINF 6234",
                  ),
                  style: GoogleFonts.fustat(fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                    "f00129",
                    " — Utilisation non conforme d’un certificat provisoire / titre provisoire (base : ",
                  ),
                ),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                    "f00130",
                    "R. 322-3 du Code de la route",
                  ),
                ),
                const TextSpan(text: ")."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                    "f00131",
                    "NATINF 7544",
                  ),
                  style: GoogleFonts.fustat(fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                    "f00132",
                    " — Maintien en circulation après cession sans CI au nom du nouveau propriétaire (base : ",
                  ),
                ),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                    "f00133",
                    "R. 322-5 du Code de la route",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                    "f00134",
                    ") — AF min. 4e classe, immobilisation possible.",
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                    "f00135",
                    "NATINF 6237",
                  ),
                  style: GoogleFonts.fustat(fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                    "f00136",
                    " — Non-déclaration de cession dans les 15 jours (base : ",
                  ),
                ),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                    "f00137",
                    "R. 322-4 du Code de la route",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                    "f00138",
                    ") — AF min. 4e classe.",
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                    "f00139",
                    "NATINF 6224",
                  ),
                  style: GoogleFonts.fustat(fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                    "f00140",
                    " — Non-déclaration de changement de domicile dans le mois (base : ",
                  ),
                ),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                    "f00141",
                    "R. 322-7 du Code de la route",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                    "f00142",
                    ") — AF min. 4e classe.",
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                    "f00143",
                    "NATINF 6241",
                  ),
                  style: GoogleFonts.fustat(fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                    "f00144",
                    " — Non-déclaration de transformation dans le mois (base : ",
                  ),
                ),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                    "f00145",
                    "R. 322-8 du Code de la route",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                    "f00146",
                    ") — AF min. 4e classe.",
                  ),
                ),
              ]),
              const SizedBox(height: 12),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                  "f00147",
                  "Attention",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                      "f00148",
                      "NATINF 28690",
                    ),
                    style: GoogleFonts.fustat(fontWeight: FontWeight.w900),
                  ),
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                          "f00149",
                          " : déclaration mensongère certifiant la cession (y compris destruction). ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart",
                          "f00150",
                          "Les A.P.J.A. ne sont pas habilités à constater les délits par procès-verbal.",
                        ),
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
