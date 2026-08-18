import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class CharteAccueilPublicVictimesPage extends StatelessWidget {
  const CharteAccueilPublicVictimesPage({super.key});

  static const String routeName = '/gpx/institution/accueil_public/charte';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
    final Color cardIntro = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardPrincipes = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardVictimes = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardPlaintes = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardDisparition = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardInfoSuivi = isDark
        ? const Color(0xFF202633)
        : const Color(0xFFF3F6FF);
    final Color cardFichiers = isDark
        ? const Color(0xFF26200F)
        : const Color(0xFFFFF3E0);

    final Color accentBlue = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color accentGreen = isDark
        ? const Color(0xFF66BB6A)
        : const Color(0xFF2E7D32);
    final Color accentAmber = isDark
        ? const Color(0xFFFFCA28)
        : const Color(0xFFF9A825);
    final Color accentPink = isDark
        ? const Color(0xFFF48FB1)
        : const Color(0xFFC2185B);
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
            "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
            "f00002",
            "Accueil du public",
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
              "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
              "f00003",
              "Charte de l’accueil du public\net de l’assistance aux victimes",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          _ConditionCard(
            title: "Objectif",
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                      "f00004",
                      "Cette charte fixe les engagements de la police nationale et de la gendarmerie nationale ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                      "f00005",
                      "en matière d’accueil : disponibilité, écoute, respect, prise en compte des demandes et ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                      "f00006",
                      "assistance aux victimes.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Article 1 + 3 (priorité + comportement)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
              "f00007",
              "Priorité d’accueil & comportement",
            ),
            cardColor: cardPrincipes,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(text: "• "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                    "f00008",
                    "Article 1",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                        "f00009",
                        " — L’accueil du public est une priorité majeure : qualité de la réception (sur place/téléphone), ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                        "f00010",
                        "disponibilité, réduction des délais d’attente et satisfaction des demandes.",
                      ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(text: "• "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                    "f00011",
                    "Article 3",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                        "f00012",
                        " — Politesse, retenue, correction : pas de familiarité, pas de propos désobligeants, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                        "f00013",
                        "discernement, calme, sang-froid et patience. Les missions au contact du public sont ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                        "f00014",
                        "assurées en uniforme (ou tenue de ville correcte si autorisé).",
                      ),
                ),
              ]),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                  "f00015",
                  "Concrètement (attendus sur le terrain)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                  "f00016",
                  "Être disponible et accueillant, y compris au téléphone.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                  "f00017",
                  "Donner une réponse adaptée en temps réel, ou expliquer clairement le délai.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                  "f00018",
                  "Rester impartial et objectif, même en situation émotionnelle.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Article 2 + 5 (écoute + prise en compte + plaintes)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
              "f00019",
              "Écoute, prise en compte & plaintes",
            ),
            cardColor: cardPlaintes,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(text: "• "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                    "f00020",
                    "Article 2",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                        "f00021",
                        " — Chaque citoyen a le droit d’être écouté à tout moment, assisté et secouru. ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                        "f00022",
                        "Toute demande (renseignement, aide, assistance, plainte) est prise en considération, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                        "f00023",
                        "quel que soit le mode d’expression, l’urgence ou la gravité.",
                      ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(text: "• "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                    "f00024",
                    "Article 5",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                        "f00025",
                        " — Les services sont tenus de recevoir les plaintes déposées par les victimes d’infractions pénales, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                        "f00026",
                        "y compris si le service n’est pas territorialement compétent. ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                        "f00027",
                        "Le service recevant la plainte veille aux enregistrements et diffusions utiles (recherche des auteurs/bien dérobés).",
                      ),
                ),
              ]),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                  "f00028",
                  "À retenir",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                  "f00029",
                  "Une plainte doit être reçue même hors compétence territoriale (accueil + recueil + transmission).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                  "f00030",
                  "La demande doit être prise au sérieux, même si elle paraît confuse, incomplète ou très émotionnelle.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Article 4 (victimes : accueil privilégié)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
              "f00031",
              "Assistance aux victimes",
            ),
            cardColor: cardVictimes,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                    "f00032",
                    "Article 4",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                        "f00033",
                        " — Les victimes d’infractions pénales bénéficient d’un accueil privilégié : ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                        "f00034",
                        "écoute, information sur leurs droits, accompagnement dans les démarches et, si besoin, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                        "f00035",
                        "orientation vers un organisme d’aide (soutien psychologique / aide matérielle).",
                      ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                      "f00036",
                      "Quelles que soient les circonstances, les policiers et gendarmes veillent à préserver la dignité, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                      "f00037",
                      "l’intimité et la pudeur des victimes. Une attention renforcée est portée aux personnes les plus vulnérables.",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                  "f00038",
                  "Mesures attendues",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                  "f00039",
                  "Préserver l’intimité (lieu, posture, discrétion).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                  "f00040",
                  "Adapter le langage, expliquer les étapes et rassurer.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                  "f00041",
                  "Orienter vers les dispositifs d’aide si nécessaire.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Article 6 (disparition)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
              "f00042",
              "Signalement de disparition",
            ),
            cardColor: cardDisparition,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                    "f00043",
                    "Article 6",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                        "f00044",
                        " — Toute disparition fait l’objet d’une attention particulière et d’un traitement immédiat ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                        "f00045",
                        "(mineur ou majeur). Le signalement est pris en compte sans délai et donne lieu aux opérations ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                        "f00046",
                        "et diffusions de recherche nécessaires. Le requérant est tenu informé de l’évolution.",
                      ),
                ),
              ]),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                  "f00047",
                  "Réflexe opérationnel",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                  "f00048",
                  "Prendre le signalement au sérieux immédiatement.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                  "f00049",
                  "Engager sans délai les recherches/diffusions nécessaires.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                  "f00050",
                  "Informer régulièrement le requérant.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Article 7 (informer le plaignant)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
              "f00051",
              "Information & suivi du plaignant",
            ),
            cardColor: cardInfoSuivi,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                    "f00052",
                    "Article 7",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                        "f00053",
                        " — Les services veillent à informer le plaignant des actes entrepris à la suite de sa déposition ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                        "f00054",
                        "et de leurs résultats. Ils s’assurent que le fait incriminé ou la situation dénoncée ne s’est pas renouvelé.",
                      ),
                ),
              ]),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                  "f00055",
                  "Bonnes pratiques",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                  "f00056",
                  "Expliquer ce qui est fait, et pourquoi (transparence).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                  "f00057",
                  "Donner une info utile sur les suites (dans la limite du cadre légal).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                  "f00058",
                  "Vérifier la non-réitération quand c’est pertinent.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Article 8 (fichiers PJ + droits CNIL)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
              "f00059",
              "Enregistrements, fichiers & droits des victimes",
            ),
            cardColor: cardFichiers,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                    "f00060",
                    "Article 8",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                        "f00061",
                        " — Dans le seul but d’identifier les auteurs d’infractions, des informations relatives aux victimes ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                        "f00062",
                        "peuvent être enregistrées dans certains fichiers de police judiciaire.",
                      ),
                ),
              ]),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                  "f00063",
                  "Droits de la victime",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                  "f00064",
                  "Obtenir communication des données la concernant.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                  "f00065",
                  "Demander rectification ou suppression en cas d’erreur.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                  "f00066",
                  "Procédure (rappel)",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                          "f00067",
                          "Ces droits s’exercent indirectement auprès de la Commission Nationale de l’Informatique et des Libertés (CNIL). ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                          "f00068",
                          "Le procureur de la République territorialement compétent peut être saisi. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                          "f00069",
                          "Une notice détaillant les modalités pratiques est remise sur simple demande.",
                        ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                      "f00070",
                      "En cas de condamnation définitive de l’auteur, la victime peut aussi s’opposer à la conservation ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart",
                      "f00071",
                      "des informations la concernant, selon les modalités indiquées dans la notice remise.",
                    ),
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
