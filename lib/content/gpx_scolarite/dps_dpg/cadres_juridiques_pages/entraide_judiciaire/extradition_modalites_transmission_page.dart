import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class ExtraditionModalitesTransmissionPage extends StatelessWidget {
  const ExtraditionModalitesTransmissionPage({super.key});

  static const String routeName =
      '/gpx/cadres_juridiques/entraide_judiciaire/extradition_modalites_transmission';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FB);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color cardColor = isDark
        ? const Color(0xFF1E222A)
        : const Color(0xFFFFFFFF);
    final Color accent = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF0D1B2A);

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
            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
            "f00002",
            'Modalités de transmission\net schémas procéduraux',
          ),
          textAlign: TextAlign.center,
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
        children: [
          Text(
            ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
              "f00003",
              'Extradition & mandat d’arrêt européen',
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                  "f00004",
                  'Synthèse des schémas de transmission des demandes d’extradition ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                  "f00005",
                  '(procédure de droit commun et procédure simplifiée) ainsi que de ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                  "f00006",
                  'l’exécution du mandat d’arrêt européen par la France.',
                ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.4,
              color: isDark
                  ? Colors.white70
                  : const Color(0xFF1F1F1F).withValues(alpha: .80),
            ),
          ),
          const SizedBox(height: 18),

          // ===================== 1. FRANCE ÉTAT REQUÉRANT ==================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
              "f00007",
              'Modalités de transmission de la demande d’extradition — France État requérant',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                  "f00008",
                  'Chaîne de transmission en procédure de droit commun',
                ),
              ),
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00009",
                      'Le procureur de la République compétent établit la demande ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00010",
                      'd’extradition sur la base d’un titre exécutoire (décision de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00011",
                      'condamnation ou mandat d’arrêt).',
                    ),
              ),
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00012",
                      'La demande est transmise au procureur général, qui émet un avis ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00013",
                      'sur l’opportunité de la démarche et la régularité du dossier.',
                    ),
              ),
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00014",
                      'Lorsque l’État requis ne fait pas partie de l’Union européenne, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00015",
                      'la demande passe par la Chancellerie avant d’être adressée ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00016",
                      'au ministre des Affaires étrangères.',
                    ),
              ),
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00017",
                      'Le ministre des Affaires étrangères transmet la demande à l’État requis, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00018",
                      'qui se prononce sur un accord ou un refus d’extradition.',
                    ),
              ),
              SizedBox(height: 8),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                  "f00019",
                  'Particularité lorsque l’État requis est membre de l’Union européenne',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00020",
                      'Si l’État requis est membre de l’Union européenne mais que la procédure ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00021",
                      'du mandat d’arrêt européen n’est pas applicable, le procureur général peut, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00022",
                      'après avis, transmettre plus directement le dossier au ministre des Affaires ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00023",
                      'étrangères, afin de réduire les délais de circulation de la demande.',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ===================== 2. FRANCE ÉTAT REQUIS (DROIT COMMUN) ======
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
              "f00024",
              'Procédure d’extradition de droit commun — France État requis',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                  "f00025",
                  'Acheminement de la demande vers l’autorité judiciaire',
                ),
              ),
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00026",
                      'L’État requérant adresse la demande d’extradition au ministère des ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00027",
                      'Affaires étrangères français.',
                    ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                  "f00028",
                  'Le ministère des Affaires étrangères transmet la demande au garde des Sceaux.',
                ),
              ),
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00029",
                      'Le garde des Sceaux la renvoie ensuite au procureur général territorialement ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00030",
                      'compétent, après vérification de la régularité formelle de la requête.',
                    ),
              ),
              const SizedBox(height: 8),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                  "f00031",
                  'Intervention du procureur général',
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                        "f00032",
                        'Le procureur général territorialement compétent fait procéder à ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                        "f00033",
                        'l’arrestation de la personne recherchée. L’agent chargé de l’exécution ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                        "f00034",
                        'ne peut s’introduire dans le domicile d’un citoyen qu’entre 6 heures ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                        "f00035",
                        'et 21 heures, conformément à l’',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                    "f00036",
                    'article 134 alinéa 1 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(text: '.'),
              ]),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                        "f00037",
                        'La personne interpellée bénéficie des droits attachés à la garde à vue, ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                        "f00038",
                        'prévus aux ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                    "f00039",
                    'articles 63-1 à 63-7 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                        "f00040",
                        ' (information sur les droits, possibilité de prévenir un proche, ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                        "f00041",
                        'd’être examinée par un médecin, etc.).',
                      ),
                ),
              ]),
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00042",
                      'La personne doit être déférée au procureur général dans les 48 heures ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00043",
                      'suivant son arrestation.',
                    ),
              ),
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00044",
                      'Après vérification de son identité, le procureur général l’informe, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00045",
                      'dans une langue qu’elle comprend, de l’existence et du contenu de la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00046",
                      'demande d’extradition, ainsi que de sa faculté de consentir ou non à ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00047",
                      'son extradition et des conséquences juridiques de ce choix.',
                    ),
              ),
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00048",
                      'Si le procureur général décide de ne pas laisser la personne en liberté, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00049",
                      'il la présente au premier président de la cour d’appel ou au magistrat ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00050",
                      'du siège désigné par lui, qui peut ordonner l’écrou extraditionnel, un ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00051",
                      'contrôle judiciaire ou une assignation à résidence sous surveillance ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00052",
                      'électronique.',
                    ),
              ),
              const SizedBox(height: 8),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                  "f00053",
                  'Rôle de la chambre de l’instruction',
                ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00054",
                      'En cas de consentement de la personne à son extradition : comparution ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00055",
                      'devant la chambre de l’instruction dans un délai de 5 jours à compter ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00056",
                      'de sa présentation au procureur général ; la chambre constate le ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00057",
                      'consentement et en donne acte dans les 7 jours.',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00058",
                      'En cas de refus de consentir : comparution devant la chambre de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00059",
                      'l’instruction dans un délai de 10 jours ; la chambre rend un avis motivé ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00060",
                      'sur la demande d’extradition dans un délai d’un mois, avis susceptible ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00061",
                      'd’un pourvoi en cassation sur la forme.',
                    ),
              ),
              const SizedBox(height: 8),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                  "f00062",
                  'Effets de la décision',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00063",
                      'Si la chambre de l’instruction rend un avis défavorable, l’extradition ne ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00064",
                      'peut pas être accordée et la personne est remise en liberté si elle n’est pas ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00065",
                      'détenue pour une autre cause. Dans les autres cas, l’extradition est autorisée ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00066",
                      'par décret du Premier ministre, pris sur rapport du ministre de la Justice.',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ===================== 3. PROCÉDURE SIMPLIFIÉE ===================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
              "f00067",
              'Procédure d’extradition — forme simplifiée entre États membres de l’Union européenne',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                  "f00068",
                  'Champ d’application',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00069",
                      'La procédure simplifiée d’extradition est réservée aux demandes émanant ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00070",
                      'd’un État partie à la Convention du 10 mars 1995 relative à la procédure ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00071",
                      'simplifiée d’extradition entre États membres de l’Union européenne, lorsque ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00072",
                      'la procédure du mandat d’arrêt européen n’est pas applicable.',
                    ),
              ),
              SizedBox(height: 8),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                  "f00073",
                  'Chaîne procédurale',
                ),
              ),
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00074",
                      'L’État requérant adresse sa demande au garde des Sceaux, sans intervenir ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00075",
                      'du ministère des Affaires étrangères lorsque la convention le permet.',
                    ),
              ),
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00076",
                      'Le garde des Sceaux transmet la demande au procureur général ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00077",
                      'territorialement compétent.',
                    ),
              ),
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00078",
                      'Le procureur général met en œuvre les mêmes étapes que dans la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00079",
                      'procédure de droit commun : arrestation, présentation dans les 48 heures, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00080",
                      'notification du titre, informations sur la faculté de consentir ou non, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00081",
                      'et éventuel placement sous écrou extraditionnel ou mesures de contrôle.',
                    ),
              ),
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00082",
                      'L’affaire est ensuite portée devant la chambre de l’instruction, qui ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00083",
                      'statue sur la base du consentement ou non de la personne recherchée.',
                    ),
              ),
              SizedBox(height: 8),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                  "f00084",
                  'Spécificités de la procédure simplifiée',
                ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00085",
                      'Si la personne consent à son extradition, la chambre de l’instruction lui ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00086",
                      'donne acte de ce consentement dans un délai de 7 jours à compter de sa ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00087",
                      'comparution.',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00088",
                      'Si la personne ne consent pas, la chambre de l’instruction dispose d’un ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00089",
                      'délai d’un mois pour rendre un avis motivé, comme en droit commun.',
                    ),
              ),
              SizedBox(height: 6),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                  "f00090",
                  'Spécificité essentielle',
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                          "f00091",
                          'Lorsque les conditions légales sont réunies, la chambre de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                          "f00092",
                          'l’instruction accorde directement l’extradition : il n’y a plus de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                          "f00093",
                          'décret d’extradition. La remise de l’intéressé à l’État requérant ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                          "f00094",
                          'doit intervenir dans un délai de 20 jours à compter de la ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                          "f00095",
                          'notification de la décision à cet État ; passé ce délai, la mise en ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                          "f00096",
                          'liberté de la personne doit être ordonnée si elle se trouve encore ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                          "f00097",
                          'sur le territoire français.',
                        ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ===================== 4. EXÉCUTION DU MAE — SCHÉMA ===============
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
              "f00098",
              'Exécution du mandat d’arrêt européen par la France — schéma synthétique',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                  "f00099",
                  'Diffusion et appréhension de la personne recherchée',
                ),
              ),
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00100",
                      'Le mandat d’arrêt européen est diffusé : soit directement au procureur ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00101",
                      'général territorialement compétent si la personne se trouve dans un ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00102",
                      'lieu connu, soit via les systèmes de signalement (Système d’information ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00103",
                      'Schengen, INTERPOL) lorsqu’elle n’est pas localisée.',
                    ),
              ),
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00104",
                      'Lorsqu’elle est repérée, la personne est appréhendée puis conduite ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00105",
                      'dans les 48 heures devant le procureur général.',
                    ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                    "f00106",
                    'Durant ce délai, elle bénéficie des droits prévus aux ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                    "f00107",
                    'articles 63-1 à 63-7 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 8),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                  "f00108",
                  'Rôle du procureur général et de la chambre de l’instruction',
                ),
              ),
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00109",
                      'Le procureur général notifie le mandat d’arrêt européen à la personne, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00110",
                      'l’informe de ses droits, de la possibilité de consentir ou de s’opposer ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00111",
                      'à sa remise et des conséquences juridiques de ce choix.',
                    ),
              ),
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00112",
                      'Sauf décision contraire du premier président de la cour d’appel, la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00113",
                      'personne est incarcérée à la maison d’arrêt afin de garantir sa ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00114",
                      'présence aux actes de la procédure.',
                    ),
              ),
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00115",
                      'La chambre de l’instruction est saisie dans les 5 jours de la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00116",
                      'présentation de la personne au procureur général.',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00117",
                      'Si la personne consent à sa remise : la chambre de l’instruction statue ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00118",
                      'dans un délai de 7 jours ; la décision est irrévocable et la règle de la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00119",
                      'spécialité peut être levée si la personne y renonce.',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00120",
                      'Si la personne ne consent pas : la chambre de l’instruction statue dans ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00121",
                      'un délai de 20 jours ; la décision peut faire l’objet d’un pourvoi en ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                      "f00122",
                      'cassation.',
                    ),
              ),
              const SizedBox(height: 6),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                  "f00123",
                  'Remise de la personne',
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                        "f00124",
                        'Lorsque la chambre de l’instruction rend un arrêt autorisant la remise, ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                        "f00125",
                        'le procureur général prend les mesures nécessaires afin d’organiser le ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                        "f00126",
                        'transfert de la personne vers l’État d’émission. Cette remise intervient, ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                        "f00127",
                        'en principe, dans un délai de 10 jours suivant la date à laquelle la ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                        "f00128",
                        'décision de remise est devenue définitive, conformément à l’',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                    "f00129",
                    'article 695-37 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                        "f00130",
                        '. La remise peut être différée pour des motifs humanitaires ou lorsque ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                        "f00131",
                        'la personne doit encore exécuter une peine en France pour d’autres ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart",
                        "f00132",
                        'faits que ceux visés par le mandat d’arrêt européen.',
                      ),
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
