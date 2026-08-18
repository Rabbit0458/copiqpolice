import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PVPvSaisinePersonneInconnuePage extends StatefulWidget {
  const PVPvSaisinePersonneInconnuePage({super.key});

  static const String routeName =
      '/gpx/pv_apj20/plainte/pv_saisine_personne_inconnue';

  @override
  State<PVPvSaisinePersonneInconnuePage> createState() =>
      _PVPvSaisinePersonneInconnuePageState();
}

class _PVPvSaisinePersonneInconnuePageState
    extends State<PVPvSaisinePersonneInconnuePage> {
  static const Color _lawRed = Color(0xFFE53935);

  @override
  void initState() {
    super.initState();
    // ✅ Plein écran
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    // ✅ Restaure l'affichage normal
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardDef = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardSteps = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardDecl = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardDocs = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);

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
      body: SafeArea(
        top: true,
        bottom: true,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            // ✅ Header custom (sans AppBar)
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: Icon(Icons.arrow_back_ios_new_rounded, color: textMain),
                  tooltip: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                    "f00001",
                    'Retour',
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    "Plainte",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.fustat(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      color: textMain,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              ScolariteText.value(
                "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                "f00002",
                "PV de saisine — personne inconnue",
              ),
              style: GoogleFonts.fustat(
                fontWeight: FontWeight.w900,
                fontSize: 22,
                height: 1.15,
                color: textMain,
              ),
            ),
            const SizedBox(height: 10),

            // ✅ Élément légal en haut
            _ConditionCard(
              title: ScolariteText.value(
                "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                "f00003",
                "I — Élément légal",
              ),
              cardColor: cardLegal,
              accent: accentBlue,
              titleColor: textMain,
              children: [
                _Paragraph.rich([
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                      "f00004",
                      "Les officiers et agents de police judiciaire sont tenus de recevoir les plaintes, y compris si le service est territorialement incompétent (transmission si besoin). — ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                      "f00005",
                      "article 15-3 du Code de procédure pénale",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ]),
                SizedBox(height: 10),
                _Paragraph.rich([
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                      "f00006",
                      "Le plaignant est informé des droits des victimes lors du dépôt de plainte. — ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                      "f00007",
                      "article 10-2 du Code de procédure pénale",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ]),
                SizedBox(height: 10),
                _Paragraph.rich([
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                      "f00008",
                      "Le dépôt de plainte donne lieu à un procès-verbal, à la délivrance immédiate d’un récépissé, et, si la victime le demande, à une copie du PV. — ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                      "f00009",
                      "article 15-3 alinéa 2 du Code de procédure pénale",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ]),
                SizedBox(height: 10),
                _NotaBox(
                  bodySpans: [
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                            "f00010",
                            "Cadre juridique à annoncer : enquête de flagrance ou enquête préliminaire. ",
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                            "f00011",
                            "On vise « articles 53 et suivants » ou « articles 75 et suivants » du CPP selon le cas.",
                          ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                _Paragraph.rich([
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                      "f00012",
                      "Dommages-intérêts (si demande) : ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                      "f00013",
                      "article 420-1 du Code de procédure pénale",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                      "f00014",
                      " (se conformer aux consignes du parquet local le cas échéant).",
                    ),
                  ),
                ]),
              ],
            ),

            const SizedBox(height: 14),

            // Définition
            _ConditionCard(
              title: ScolariteText.value(
                "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                "f00015",
                "Définition",
              ),
              cardColor: cardDef,
              accent: accentGrey,
              titleColor: textMain,
              children: [
                _Paragraph(
                  ScolariteText.value(
                        "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                        "f00016",
                        "La plainte « contre auteur inconnu » est utilisée lorsque la victime ne peut pas identifier l’auteur. ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                        "f00017",
                        "Le PV doit être structuré et exploitable : il organise le récit, précise les éléments utiles (H.L.M.), ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                        "f00018",
                        "et oriente immédiatement les premières diligences.",
                      ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Canevas structure PV (contre inconnu)
            _ConditionCard(
              title: ScolariteText.value(
                "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                "f00019",
                "II — Canevas (PV de saisine — auteur inconnu)",
              ),
              cardColor: cardSteps,
              accent: accentGreen,
              titleColor: textMain,
              children: [
                _SubTitle(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                    "f00020",
                    "1) Lieu de rédaction",
                  ),
                ),
                _BulletPoint(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                    "f00021",
                    "Service, domicile, hôpital… L’APJ peut recevoir la plainte ailleurs qu’au service.",
                  ),
                ),

                SizedBox(height: 10),

                _SubTitle(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                    "f00022",
                    "2) Instructions",
                  ),
                ),
                _BulletPoint(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                    "f00023",
                    "En PV de saisine : agir sur « instructions permanentes du chef de service ».",
                  ),
                ),

                SizedBox(height: 10),

                _SubTitle(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                    "f00024",
                    "3) Réception du déclarant",
                  ),
                ),
                _BulletPoint(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                    "f00025",
                    "Si la victime vient avec un interprète : mentionner ses coordonnées.",
                  ),
                ),
                _BulletPoint(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                    "f00026",
                    "Selon gravité / qualité victime-auteur : aviser immédiatement l’OPJ (avant toute rédaction si nécessaire).",
                  ),
                ),
                _BulletPoint(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                    "f00027",
                    "Faire une description succincte des circonstances pour annoncer la rubrique suivante.",
                  ),
                ),

                SizedBox(height: 10),

                _SubTitle(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                    "f00028",
                    "4) Cadre juridique",
                  ),
                ),
                _BulletPoint(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                    "f00029",
                    "Situer l’enquête : flagrance (articles 53 et s.) ou préliminaire (articles 75 et s.) du CPP.",
                  ),
                ),

                SizedBox(height: 10),

                _SubTitle(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                    "f00030",
                    "5) Droits des victimes",
                  ),
                ),
                _Paragraph.rich([
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                      "f00031",
                      "Informer le plaignant — ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                      "f00032",
                      "article 10-2 du Code de procédure pénale",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ]),
                SizedBox(height: 8),
                _NotaBox(
                  bodySpans: [
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                        "f00033",
                        "Si demande de dommages-intérêts : appliquer les consignes du parquet local.",
                      ),
                    ),
                    TextSpan(text: " "),
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                        "f00034",
                        "(article 420-1 du Code de procédure pénale)",
                      ),
                      style: TextStyle(
                        color: _lawRed,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    TextSpan(text: "."),
                  ],
                ),

                SizedBox(height: 10),

                _SubTitle(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                    "f00035",
                    "6) Identité",
                  ),
                ),
                _BulletPoint(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                    "f00036",
                    "Petite identité relevée lors de la création du CRI ; le rappel NOM + Prénom suffit dans le PV.",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Déclarations / Signalement / Reconnaissance
            _ConditionCard(
              title: ScolariteText.value(
                "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                "f00037",
                "III — Déclarations & exploitabilité",
              ),
              cardColor: cardDecl,
              accent: accentPink,
              titleColor: textMain,
              children: [
                _SubTitle(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                    "f00038",
                    "Déroulé des faits (H.L.M.)",
                  ),
                ),
                _BulletPoint(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                    "f00039",
                    "Heure – Lieu – Motif : description précise, en première personne (« je… »).",
                  ),
                ),
                _BulletPoint(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                    "f00040",
                    "Récit libre d’abord (déclarations spontanées), puis questions ouvertes (sans suggérer).",
                  ),
                ),
                SizedBox(height: 12),
                _SubTitle(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                    "f00041",
                    "Signalement (auteur inconnu)",
                  ),
                ),
                _BulletPoint(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                    "f00042",
                    "Sexe, âge apparent, taille, corpulence, cheveux, yeux, signes distinctifs, tenue vestimentaire…",
                  ),
                ),
                _BulletPoint(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                    "f00043",
                    "Tous renseignements utiles doivent apparaître clairement (mode opératoire, direction de fuite, véhicule, etc.).",
                  ),
                ),
                SizedBox(height: 12),
                _SubTitle("Reconnaissance"),
                _BulletPoint(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                    "f00044",
                    "Reconnaissance possible : sur photographies et/ou présentation derrière une glace sans tain, selon procédure.",
                  ),
                ),
                SizedBox(height: 12),
                _NotaBox(
                  title: "Important",
                  bodySpans: [
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                            "f00045",
                            "Certaines infractions sont conditionnées par un dépôt de plainte (ex. diffamation). ",
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                            "f00046",
                            "Toujours vérifier si la qualification nécessite la plainte pour déclencher les suites.",
                          ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Documents / Demande de copie / Clôture / Annexes / Remises / Avis OPJ + Images
            _ConditionCard(
              title: ScolariteText.value(
                "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                "f00047",
                "IV — Finalisation, annexes & canevas (images)",
              ),
              cardColor: cardDocs,
              accent: accentAmber,
              titleColor: textMain,
              children: [
                _SubTitle(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                    "f00048",
                    "Documents remis",
                  ),
                ),
                _BulletPoint(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                    "f00049",
                    "Certificats médicaux, chèques, factures, messages, captures… tout ce qui se rapporte à l’affaire.",
                  ),
                ),
                _BulletPoint(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                    "f00050",
                    "Tout document remis doit être annexé au PV (numérotation conseillée).",
                  ),
                ),
                SizedBox(height: 10),

                _SubTitle(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                    "f00051",
                    "Demande de copie",
                  ),
                ),
                _Paragraph.rich([
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                      "f00052",
                      "Copie du PV si la victime le demande — ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                      "f00053",
                      "article 15-3 alinéa 2 du Code de procédure pénale",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ]),
                SizedBox(height: 10),

                _SubTitle(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                    "f00054",
                    "Énonciation terminale (clôture)",
                  ),
                ),
                _BulletPoint(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                    "f00055",
                    "Mentionner la lecture faite par la personne ; si impossible : lecture faite par l’APJ (ex : ne sait pas lire).",
                  ),
                ),
                _BulletPoint(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                    "f00056",
                    "Signature sous l’énonciation terminale. Si interprète : lecture par son truchement + signature interprète.",
                  ),
                ),
                _BulletPoint(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                    "f00057",
                    "Heure de fin d’audition : facultative.",
                  ),
                ),
                SizedBox(height: 10),

                _SubTitle(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                    "f00058",
                    "Remises & avis OPJ",
                  ),
                ),
                _BulletPoint(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                    "f00059",
                    "Remettre : formulaire droits des victimes + récépissé + copie du PV si demandée.",
                  ),
                ),
                _BulletPoint(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                    "f00060",
                    "Avis OPJ : l’APJ avise l’OPJ des faits contenus dans la plainte.",
                  ),
                ),

                SizedBox(height: 14),

                _SubTitle(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                    "f00061",
                    "Canevas visuel — auteur inconnu (anonyme)",
                  ),
                ),
                _Paragraph(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                    "f00062",
                    "Tap sur l’image pour ouvrir en plein écran (zoom + rotation).",
                  ),
                ),
                SizedBox(height: 10),
                _ZoomRotateImage(
                  assetPath: 'assets/images/pv_canva_plainte_recto_anonyme.png',
                ),
                SizedBox(height: 12),
                _ZoomRotateImage(
                  assetPath: 'assets/images/pv_canva_plainte_verso_anonyme.png',
                ),

                SizedBox(height: 14),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ZoomRotateImage extends StatefulWidget {
  const _ZoomRotateImage({required this.assetPath});

  final String assetPath;

  @override
  State<_ZoomRotateImage> createState() => _ZoomRotateImageState();
}

class _ZoomRotateImageState extends State<_ZoomRotateImage> {
  int _quarterTurns = 0;

  void _rotateLeft() => setState(() => _quarterTurns = (_quarterTurns - 1) % 4);
  void _rotateRight() =>
      setState(() => _quarterTurns = (_quarterTurns + 1) % 4);
  void _reset() => setState(() => _quarterTurns = 0);

  void _openFullScreenViewer(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, __, ___) {
          return _FullScreenImageViewer(assetPath: widget.assetPath);
        },
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color border = isDark
        ? Colors.white.withValues(alpha: .18)
        : Colors.black.withValues(alpha: .10);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.black.withValues(alpha: .18)
                  : Colors.black12,
              border: Border(bottom: BorderSide(color: border, width: 1)),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: _rotateLeft,
                  tooltip: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                    "f00063",
                    'Tourner à gauche',
                  ),
                  icon: const Icon(Icons.rotate_left_rounded),
                ),
                IconButton(
                  onPressed: _rotateRight,
                  tooltip: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                    "f00064",
                    'Tourner à droite',
                  ),
                  icon: const Icon(Icons.rotate_right_rounded),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: _reset,
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                      "f00065",
                      "Réinitialiser",
                    ),
                    style: GoogleFonts.fustat(fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _openFullScreenViewer(context),
            child: AspectRatio(
              aspectRatio: 4 / 3,
              child: InteractiveViewer(
                minScale: 1,
                maxScale: 6,
                child: Center(
                  child: RotatedBox(
                    quarterTurns: _quarterTurns,
                    child: Image.asset(widget.assetPath, fit: BoxFit.contain),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FullScreenImageViewer extends StatefulWidget {
  const _FullScreenImageViewer({required this.assetPath});

  final String assetPath;

  @override
  State<_FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<_FullScreenImageViewer> {
  int _quarterTurns = 0;

  void _rotateLeft() => setState(() => _quarterTurns = (_quarterTurns - 1) % 4);
  void _rotateRight() =>
      setState(() => _quarterTurns = (_quarterTurns + 1) % 4);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.92),
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                minScale: 1,
                maxScale: 10,
                panEnabled: true,
                child: RotatedBox(
                  quarterTurns: _quarterTurns,
                  child: Image.asset(widget.assetPath, fit: BoxFit.contain),
                ),
              ),
            ),
            Positioned(
              top: 8,
              left: 8,
              right: 8,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.close_rounded, color: Colors.white),
                    tooltip: "Fermer",
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: _rotateLeft,
                    icon: const Icon(
                      Icons.rotate_left_rounded,
                      color: Colors.white,
                    ),
                    tooltip: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                      "f00066",
                      "Tourner à gauche",
                    ),
                  ),
                  IconButton(
                    onPressed: _rotateRight,
                    icon: const Icon(
                      Icons.rotate_right_rounded,
                      color: Colors.white,
                    ),
                    tooltip: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                      "f00067",
                      "Tourner à droite",
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 18,
              left: 18,
              right: 18,
              child: Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart",
                  "f00068",
                  "Pince pour zoomer • Glisse pour déplacer • Boutons pour tourner",
                ),
                textAlign: TextAlign.center,
                style: GoogleFonts.fustat(
                  color: isDark ? Colors.white70 : Colors.white70,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
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
