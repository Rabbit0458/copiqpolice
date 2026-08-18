import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class NotificationGavDroitsApjPage extends StatelessWidget {
  const NotificationGavDroitsApjPage({super.key});

  static const String routeName =
      '/gpx/pv_apj20/gav_suspect_libre/notification_gav_droits_apj';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Cards
    final Color cardIntro = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardSteps = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardRights = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardProtected = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardClosure = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);

    // Accents
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
            "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
            "f00002",
            "Procès-verbal G.A.V.",
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
              "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
              "f00003",
              "Canevas de PV : notification du placement en garde à vue\net des droits par un A.P.J.",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Intro
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
              "f00004",
              "Objectif de la page",
            ),
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                      "f00005",
                      "Cette page te donne un canevas clair et opérationnel pour rédiger un procès-verbal de notification ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                      "f00006",
                      "du placement en garde à vue et des droits, lorsqu’il est réalisé par un A.P.J. sous le contrôle d’un O.P.J.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut (exigence)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
              "f00007",
              "I — Élément légal (visa des textes)",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                    "f00008",
                    "Visa obligatoire des articles ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                    "f00009",
                    "62-2 à 63-4-3 du Code de procédure pénale",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                    "f00010",
                    " relatifs à la décision de placement en garde à vue et aux droits de la personne.",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                      "f00011",
                      "Le PV doit rappeler expressément que la mesure a été décidée par un O.P.J. (même si l’A.P.J. notifie).",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Steps (structure PV)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
              "f00012",
              "II — Structure du procès-verbal (canevas)",
            ),
            cardColor: cardSteps,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                  "f00013",
                  "Voici les rubriques attendues dans un PV de notification du placement en garde à vue et des droits.",
                ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                  "f00014",
                  "1) Lieu de rédaction",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                  "f00015",
                  "Indiquer précisément le lieu où le procès-verbal est établi.",
                ),
              ),

              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                  "f00016",
                  "2) Cadre juridique",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                  "f00017",
                  "Situer l’action dans un cadre juridique clair : enquête de flagrance ou enquête préliminaire.",
                ),
              ),

              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                  "f00018",
                  "3) Visa des articles du C.P.P. relatifs à la G.A.V.",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                    "f00019",
                    "Viser les textes applicables, notamment ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                    "f00020",
                    "62-2 à 63-4-3 C.P.P.",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                  "f00021",
                  "4) Instructions",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                  "f00022",
                  "Rappeler clairement que la garde à vue a été décidée par un O.P.J. (instructions reçues / décision).",
                ),
              ),

              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                  "f00023",
                  "5) Identité (petite identité)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                  "f00024",
                  "Mentionner les éléments d’identité utiles de la personne faisant l’objet de la mesure.",
                ),
              ),

              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                  "f00025",
                  "6) Visa du ou des objectifs",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                    "f00026",
                    "La mesure doit être l’unique moyen de parvenir à au moins un objectif de l’",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                    "f00027",
                    "article 62-2 C.P.P.",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " :"),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                  "f00028",
                  "Permettre l’exécution des investigations impliquant la présence/participation de la personne.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                  "f00029",
                  "Garantir la présentation devant le procureur de la République (suite à l’enquête).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                  "f00030",
                  "Empêcher la modification des preuves/indices matériels.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                  "f00031",
                  "Empêcher des pressions sur témoins/victimes ainsi que leurs familles/proches.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                  "f00032",
                  "Empêcher la concertation avec coauteurs/complices.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                  "f00033",
                  "Garantir la mise en œuvre de mesures destinées à faire cesser l’infraction.",
                ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                  "f00034",
                  "7) Information (dans une langue comprise)",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                    "f00035",
                    "Conformément à ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                    "f00036",
                    "l’article 63-1 C.P.P.",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                    "f00037",
                    ", informer la personne :",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                  "f00038",
                  "De la qualification juridique des faits, de la date et du lieu présumés.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                  "f00039",
                  "De son placement en garde à vue, sur décision de l’O.P.J.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                  "f00040",
                  "De la durée de la mesure et des éventuelles prolongations.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                      "f00041",
                      "Si l’infraction est punie d’une peine d’emprisonnement inférieure à un an, la mention relative à la prolongation ne doit pas apparaître.",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Rights
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
              "f00042",
              "III — Notification des droits",
            ),
            cardColor: cardRights,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                    "f00043",
                    "Informer la personne des droits visés aux articles ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                    "f00044",
                    "63-1 à 63-4-2 du Code de procédure pénale",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                    "f00045",
                    ", et le cas échéant : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                    "f00046",
                    "706-112-1 C.P.P.",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                    "f00047",
                    " (mesure de protection juridique).",
                  ),
                ),
              ]),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                  "f00048",
                  "Droits à notifier (liste pédagogique)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                  "f00049",
                  "Lors des auditions : faire des déclarations, répondre aux questions, ou se taire (droit au silence).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                  "f00050",
                  "Être assisté par un interprète.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                  "f00051",
                  "Consulter certaines pièces de procédure (PV de notification, certificat médical, PV d’audition(s)).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                  "f00052",
                  "Présenter des observations au magistrat (en cas de prolongation) ou via PV d’audition communiqué avant décision.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                  "f00053",
                  "Se faire remettre un document énonçant ses droits.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Protected adult specifics
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
              "f00054",
              "IV — Majeur protégé",
            ),
            cardColor: cardProtected,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                      "f00055",
                      "Si la personne fait l’objet d’une mesure de protection juridique (tutelle, curatelle, sauvegarde de justice), ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                      "f00056",
                      "elle doit être informée des conséquences pratiques liées à cette situation.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                    "f00057",
                    "Référence : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                    "f00058",
                    "article 706-112-1 C.P.P.",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                  "f00059",
                  "À notifier en plus",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                  "f00060",
                  "Le tuteur/curateur/mandataire spécial sera également avisé de la mesure.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                  "f00061",
                  "Il pourra désigner un avocat (choisi ou commis d’office) si la personne ne l’a pas demandé.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                  "f00062",
                  "Il pourra solliciter un examen médical si la personne ne l’a pas demandé.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Requests collection
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
              "f00063",
              "V — Recueil des demandes",
            ),
            cardColor: cardSteps,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                  "f00064",
                  "Acter clairement les demandes formulées par la personne gardée à vue.",
                ),
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                  "f00065",
                  "Avis à la famille / à une personne désignée / à l’employeur / aux autorités consulaires.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                  "f00066",
                  "Droit de communiquer avec un tiers (famille, personne désignée, employeur, autorités consulaires, tuteur/curateur/mandataire).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                  "f00067",
                  "Droit d’être examiné par un médecin.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                  "f00068",
                  "Droit d’être assisté par un avocat.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Closing / mentions
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
              "f00069",
              "VI — Clôture & mentions indispensables",
            ),
            cardColor: cardClosure,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                  "f00070",
                  "Énonciation terminale (clôture)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                  "f00071",
                  "Terminer le PV par une clôture claire : date/heure, lecture faite, signatures (ou refus de signer mentionné).",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle("Mention"),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                      "f00072",
                      "La décision de placement en garde à vue figure, en procédure, avant le PV de notification. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                      "f00073",
                      "Le procureur de la République a été informé de cette mesure par l’O.P.J.",
                    ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                  "f00074",
                  "Avis O.P.J.",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                  "f00075",
                  "Faire apparaître l’avis à l’O.P.J. et la décision de placement en garde à vue dans la procédure (PV ou mention dans le PV d’interpellation).",
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Canva images
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
              "f00076",
              "Supports (CANVA)",
            ),
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
                  "f00077",
                  "Affichages des supports visuels du canevas (zoomables).",
                ),
              ),
              SizedBox(height: 12),
              ZoomableAssetImage(
                assetPath: 'assets/images/canva_gardeavue.png',
              ),
              SizedBox(height: 12),
              ZoomableAssetImage(
                assetPath: 'assets/images/canva_gardeavue_page2.png',
              ),
              SizedBox(height: 12),
              ZoomableAssetImage(
                assetPath: 'assets/images/canva_gardeavue_page3.png',
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color borderColor = isDark
        ? const Color(0xFFFFCA28)
        : const Color(0xFFF9A825);
    final Color bgColor = isDark
        ? const Color(0xFF26200F)
        : const Color(0xFFFFF8E1);

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
          children: [...bodySpans],
        ),
      ),
    );
  }
}

class ZoomableAssetImage extends StatelessWidget {
  const ZoomableAssetImage({
    super.key,
    required this.assetPath,
    this.heroTag,
    this.borderRadius = 16,
    this.initialScale = 1.0,
    this.maxScale = 5.0,
    this.backgroundColor,
  });

  final String assetPath;

  /// Si tu veux un Hero personnalisé. Sinon, on utilise assetPath.
  final Object? heroTag;

  final double borderRadius;
  final double initialScale;
  final double maxScale;

  /// Couleur de fond dans le viewer plein écran (sinon auto selon thème)
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color cardBg = isDark
        ? const Color(0xFF1F1F1F)
        : const Color(0xFFFFFFFF);
    final Color border = isDark
        ? Colors.white.withValues(alpha: .08)
        : Colors.black.withValues(alpha: .06);

    final tag = heroTag ?? assetPath;

    return GestureDetector(
      onTap: () => _openViewer(context, tag),
      child: Semantics(
        button: true,
        label: ScolariteText.value(
          "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart",
          "f00078",
          'Ouvrir l’image en plein écran',
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(color: border, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? .35 : .10),
                  blurRadius: 16,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Hero(
              tag: tag,
              child: InteractiveViewer(
                minScale: 1.0,
                maxScale: maxScale,
                panEnabled: false,
                scaleEnabled: false,
                child: Image.asset(
                  assetPath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (_, __, ___) => _errorBox(context),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _errorBox(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(14),
      color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF3F3F3),
      child: Row(
        children: [
          Icon(
            Icons.broken_image_rounded,
            color: isDark ? Colors.white70 : Colors.black54,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "Image introuvable :\n$assetPath",
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openViewer(BuildContext context, Object tag) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bg = backgroundColor ?? (isDark ? Colors.black : Colors.white);

    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.black.withValues(alpha: .55),
        pageBuilder: (_, __, ___) => _ZoomViewerPage(
          assetPath: assetPath,
          heroTag: tag,
          background: bg,
          initialScale: initialScale,
          maxScale: maxScale,
        ),
        transitionsBuilder: (_, animation, __, child) {
          final curve = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );
          return FadeTransition(opacity: curve, child: child);
        },
      ),
    );
  }
}

class _ZoomViewerPage extends StatelessWidget {
  const _ZoomViewerPage({
    required this.assetPath,
    required this.heroTag,
    required this.background,
    required this.initialScale,
    required this.maxScale,
  });

  final String assetPath;
  final Object heroTag;
  final Color background;
  final double initialScale;
  final double maxScale;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color iconColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: background.withValues(alpha: .98),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: () => Navigator.of(context).maybePop(),
                child: Center(
                  child: Hero(
                    tag: heroTag,
                    child: InteractiveViewer(
                      minScale: 0.9,
                      maxScale: maxScale,
                      panEnabled: true,
                      scaleEnabled: true,
                      child: Image.asset(
                        assetPath,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => _fullscreenError(context),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Bouton fermer (top-right)
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: Icon(Icons.close_rounded, color: iconColor),
                tooltip: "Fermer",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fullscreenError(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F1F1F) : const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            Icons.broken_image_rounded,
            color: isDark ? Colors.white70 : Colors.black54,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Impossible de charger : $assetPath",
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black54,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
