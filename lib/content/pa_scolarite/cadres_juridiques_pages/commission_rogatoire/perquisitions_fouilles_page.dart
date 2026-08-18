import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaPerquisitionsFouillesPage extends StatelessWidget {
  const PaPerquisitionsFouillesPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/commission_rogatoire/perquisitions_fouilles';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF262626) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withValues(alpha: .88);

    final Color cardBlue = isDark
        ? const Color(0xFF0D1B2A)
        : const Color(0xFFE3F2FD);
    const cardBlueAccent = Color(0xFF1565C0);

    final Color cardTeal = isDark
        ? const Color(0xFF00363A)
        : const Color(0xFFE0F2F1);
    const cardTealAccent = Color(0xFF00695C);

    const Color articleRed = Color(0xFFD32F2F);

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
            "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
            "f00002",
            'Perquisitions et fouilles',
          ),
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 17.5,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        children: [
          // ================================================================
          // TITRE PRINCIPAL
          // ================================================================
          Text(
            ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
              "f00003",
              '3.3 — Les perquisitions et les fouilles',
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 8),

          // Phrase d'intro avec les articles 92 et s. en rouge
          RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              style: GoogleFonts.fustat(
                fontWeight: FontWeight.w500,
                fontSize: 13.5,
                height: 1.35,
                color: textSoft,
              ),
              children: [
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                    "f00004",
                    'Perquisitions dans le cadre de l’information judiciaire (',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                    "f00005",
                    'articles 92 et suivants du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                        "f00006",
                        ') et règles applicables aux fouilles corporelles ou de véhicule ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                        "f00007",
                        'sur commission rogatoire.',
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          _IntroBullet(
            text:
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                  "f00008",
                  'Les perquisitions sur commission rogatoire obéissent, pour l’essentiel, ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                  "f00009",
                  'aux mêmes règles que celles prévues pour l’enquête de flagrant délit.',
                ),
          ),
          _IntroBullet(
            text:
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                  "f00010",
                  'Les fouilles corporelles et de véhicule suivent, en grande partie, les ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                  "f00011",
                  'règles applicables dans le cadre juridique du flagrant délit.',
                ),
          ),
          const SizedBox(height: 20),

          // ================================================================
          // 3.3.1 — LES PERQUISITIONS
          // ================================================================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
              "f00012",
              '3.3.1 — Les perquisitions',
            ),
            cardColor: cardBlue,
            accent: cardBlueAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: [
              // Paragraphe avec "articles 92 et suivants"
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                        "f00013",
                        'Les perquisitions réalisées dans le cadre de l’information judiciaire ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                        "f00014",
                        'sont régies par les ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                    "f00015",
                    'articles 92 et suivants du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                        "f00016",
                        '. Elles peuvent être accomplies par le juge d’instruction ou, ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                        "f00017",
                        'par délégation, par un officier de police judiciaire agissant ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                        "f00018",
                        'sur commission rogatoire.',
                      ),
                ),
              ]),
              SizedBox(height: 12),

              // 3.3.1.1 Règles générales
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                  "f00019",
                  '3.3.1.1 — Les règles générales',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00020",
                      'Les règles relatives aux perquisitions sont, pour l’essentiel, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00021",
                      'communes aux cadres juridiques du flagrant délit et de la commission ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00022",
                      'rogatoire. On retrouve notamment :',
                    ),
              ),
              SizedBox(height: 6),

              // Ici je laisse les puces telles quelles (texte simple) : si tu veux
              // aussi les articles en rouge dans les puces, on pourra faire une
              // version rich de _BulletPoint, mais ça touche tous tes écrans.
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00023",
                      'les lieux dont l’accès est soumis à un régime particulier : ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00024",
                      'ambassades, domiciles des agents diplomatiques, Parlement, locaux ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00025",
                      'universitaires, établissements militaires, etc. ;',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00026",
                      'les lieux relevant de la compétence exclusive d’un magistrat en ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00027",
                      'matière d’instruction : cabinet ou domicile d’un avocat, d’un ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00028",
                      'médecin, d’un notaire, d’un huissier ; locaux d’une entreprise de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00029",
                      'presse ou de communication audiovisuelle, domicile d’un ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00030",
                      'journaliste ; lieux couverts par le secret de la défense ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00031",
                      'nationale ; locaux d’une juridiction ou domicile d’une personne ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00032",
                      'exerçant des fonctions juridictionnelles (articles 56-1 à 56-5 et ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00033",
                      '96 alinéa 4 du Code de procédure pénale) ;',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00034",
                      'les lieux où la perquisition est possible : domicile des personnes ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00035",
                      'paraissant avoir participé au crime ou détenir des pièces, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00036",
                      'informations ou objets relatifs aux faits en cas de flagrant délit, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00037",
                      'ou tous lieux où peuvent se trouver des objets, données ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00038",
                      'informatiques ou biens dont la confiscation est prévue, lorsque la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00039",
                      'perquisition est réalisée sur commission rogatoire (articles 56 et ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00040",
                      '94 du Code de procédure pénale) ;',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00041",
                      'le respect des heures légales de perquisition (article 59 du Code ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00042",
                      'de procédure pénale) et les exceptions à ce principe, notamment :',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00043",
                      'les perquisitions en matière de criminalité organisée ou de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00044",
                      'trafic de stupéfiants, réalisées selon des régimes spécifiques ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00045",
                      'prévus par le Code de procédure pénale ;',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00046",
                      'les perquisitions en cas de crime flagrant contre les personnes, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00047",
                      'autorisées par le juge d’instruction dans les conditions prévues ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00048",
                      'par l’article 59-1 du Code de procédure pénale, en cas de risque ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00049",
                      'd’atteinte à la vie ou à l’intégrité physique, de disparition des ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00050",
                      'preuves ou indices, ou de nécessité d’interpeller la personne ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00051",
                      'pour prévenir une nouvelle atteinte (article 97-2 Code de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00052",
                      'procédure pénale).',
                    ),
              ),
              SizedBox(height: 16),

              // 3.3.1.2 Règles spécifiques en information
              _SubTitle(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00053",
                      '3.3.1.2 — Les règles spécifiques aux perquisitions effectuées ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00054",
                      'en matière d’information',
                    ),
              ),
              SizedBox(height: 6),

              // 3.3.1.2.1 Compétence OPJ
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                  "f00055",
                  '3.3.1.2.1 — La compétence de l’officier de police judiciaire',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00056",
                      'L’officier de police judiciaire (OPJ) ne peut effectuer une perquisition ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00057",
                      'en matière d’information judiciaire que si cet acte lui a été ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00058",
                      'délégué par commission rogatoire, générale ou spéciale. Il agit alors ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00059",
                      'dans les limites fixées par le magistrat instructeur.',
                    ),
              ),
              SizedBox(height: 10),

              // 3.3.1.2.2 Compétence APJ
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                  "f00060",
                  '3.3.1.2.2 — La compétence de l’agent de police judiciaire',
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                    "f00061",
                    'L’article 97-1 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                        "f00062",
                        ' prévoit que les officiers de police judiciaire, ou sous leur ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                        "f00063",
                        'contrôle les agents de police judiciaire, peuvent recourir, ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                        "f00064",
                        'pour les nécessités de l’enquête, aux opérations visées à ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                    "f00065",
                    'l’article 57-1.',
                  ),
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ]),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00066",
                      'Ils peuvent ainsi, au cours d’une perquisition, accéder à des données ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00067",
                      'informatiques stockées sur des serveurs distants et requérir toute ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00068",
                      'personne susceptible de connaître les mesures de protection de ces ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00069",
                      'données, ou susceptible de fournir les informations permettant d’y ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00070",
                      'accéder.',
                    ),
              ),
              SizedBox(height: 10),

              // 3.3.1.2.3 Présences requises
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                  "f00071",
                  '3.3.1.2.3 — Les présences requises lors de la perquisition',
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                    "f00072",
                    'Les articles 95 et 96 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                        "f00073",
                        ' distinguent la perquisition au domicile de la personne mise en ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                        "f00074",
                        'examen et celle réalisée au domicile d’un tiers. Certaines ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                        "f00075",
                        'situations particulières sont également prévues.',
                      ),
                ),
              ]),
              SizedBox(height: 8),

              // 3.3.1.2.3.1 Domicile de la personne mise en examen
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                  "f00076",
                  '3.3.1.2.3.1 — La perquisition au domicile de la personne mise en examen',
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                    "f00077",
                    'L’article 95 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                        "f00078",
                        ' impose au juge d’instruction ou à l’officier de police ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                        "f00079",
                        'judiciaire délégué de respecter les dispositions des ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                    "f00080",
                    'articles 57 et 59',
                  ),
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                    "f00081",
                    ', applicables en matière de crimes et délits flagrants.',
                  ),
                ),
              ]),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00082",
                      'La perquisition doit, en principe, être réalisée en présence de la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00083",
                      'personne mise en examen. En cas d’impossibilité, elle peut se tenir ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00084",
                      'en présence d’un représentant désigné par cette personne ou, à ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00085",
                      'défaut, en présence de deux témoins requis par l’officier de police ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00086",
                      'judiciaire et ne relevant pas de son autorité administrative.',
                    ),
              ),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00087",
                      'Si la personne mise en examen est détenue, la perquisition est ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00088",
                      'effectuée à son domicile en sa présence, après extraction de la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00089",
                      'maison d’arrêt décidée par le juge d’instruction. En cas ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00090",
                      'd’impossibilité d’y assister, dûment constatée par le juge, la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00091",
                      'perquisition se déroule en présence d’un représentant désigné ; à ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00092",
                      'défaut, en présence de deux témoins requis par l’officier de police ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00093",
                      'judiciaire.',
                    ),
              ),
              SizedBox(height: 10),

              // 3.3.1.2.3.2 Personne sous CJ / ARSE avec interdiction d'armes
              _SubTitle(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00094",
                      '3.3.1.2.3.2 — La perquisition au domicile d’une personne placée ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00095",
                      'sous contrôle judiciaire ou assignée à résidence avec surveillance ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00096",
                      'électronique et soumise à une interdiction de détenir une arme',
                    ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                    "f00097",
                    'Article 141-5 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                        "f00098",
                        ' autorise les services de police et les unités de gendarmerie à ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                        "f00099",
                        'réaliser une perquisition au domicile d’une telle personne ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                        "f00100",
                        'lorsqu’il existe des indices graves ou concordants laissant ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                        "f00101",
                        'présumer la présence d’armes. Cette opération se déroule selon ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                        "f00102",
                        'les modalités prévues par les ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                    "f00103",
                    'articles 56 à 58 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                        "f00104",
                        ' et avec l’accord préalable ou sur les instructions du juge ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                        "f00105",
                        'd’instruction.',
                      ),
                ),
              ]),
              SizedBox(height: 10),

              // 3.3.1.2.3.3 Domicile d’un tiers
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                  "f00106",
                  '3.3.1.2.3.3 — La perquisition au domicile d’un tiers',
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                    "f00107",
                    'Article 96 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                        "f00108",
                        ' vise le domicile « autre que celui de la personne mise en ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                        "f00109",
                        'examen ». Il peut s’agir du domicile d’un témoin, de la partie ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                        "f00110",
                        'civile, d’un témoin assisté ou de toute personne à l’encontre de ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                        "f00111",
                        'laquelle il existe des indices graves et concordants de ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                        "f00112",
                        'participation aux faits.',
                      ),
                ),
              ]),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00113",
                      'Le tiers au domicile duquel la perquisition se déroule est invité à y ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00114",
                      'assister. En cas d’absence ou de refus, l’opération se fait en ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00115",
                      'présence de deux de ses parents ou alliés, s’ils sont présents sur ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00116",
                      'les lieux. À défaut, la perquisition se déroule en présence de deux ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00117",
                      'témoins.',
                    ),
              ),
              SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                        "f00118",
                        'Lorsque la perquisition a lieu hors du domicile de la personne ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                        "f00119",
                        'mise en examen, le juge d’instruction ou l’officier de police ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                        "f00120",
                        'judiciaire délégué se conforme aux ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                    "f00121",
                    'articles 56 et 56-1 à 56-5 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                        "f00122",
                        '. Ces dispositions imposent le respect des formalités relatives ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                        "f00123",
                        'aux perquisitions, y compris la possibilité, prévue par ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                        "f00124",
                        'l’article 56, de retenir sur place, le temps nécessaire, les ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                        "f00125",
                        'personnes présentes lorsqu’elles sont susceptibles de fournir ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                        "f00126",
                        'des renseignements utiles.',
                      ),
                ),
              ]),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00127",
                      'Même lorsque le texte renvoie principalement à la perquisition au ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00128",
                      'domicile de la personne mise en examen, le procès-verbal d’une ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00129",
                      'perquisition au domicile d’un tiers doit être établi immédiatement ou ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00130",
                      'dans les plus brefs délais, signé par les personnes ayant assisté à ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00131",
                      'l’opération. En cas de refus, cette circonstance est mentionnée au ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00132",
                      'procès-verbal.',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 22),

          // ================================================================
          // 3.3.2 — LES FOUILLES
          // ================================================================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
              "f00133",
              '3.3.2 — Les fouilles',
            ),
            cardColor: cardTeal,
            accent: cardTealAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF004D40),
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00134",
                      'Les règles relatives aux fouilles corporelles ou aux fouilles de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00135",
                      'véhicule effectuées sur commission rogatoire sont, en principe, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00136",
                      'semblables à celles applicables dans le cadre juridique du flagrant ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00137",
                      'délit.',
                    ),
              ),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00138",
                      'L’officier de police judiciaire doit donc respecter les conditions de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00139",
                      'légalité et de proportionnalité des fouilles, tenir compte du statut ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00140",
                      'de la personne (témoin, personne mise en cause, personne gardée à ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00141",
                      'vue) et consigner précisément les opérations réalisées dans le ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00142",
                      'procès-verbal, en veillant au respect de la dignité et des droits de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
                      "f00143",
                      'la personne fouillée.',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 26),
        ],
      ),
    );
  }
}

/// =====================================================================
///  WIDGETS UTILISÉS (identiques à tes autres pages)
/// =====================================================================

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

/// ------------------------------------------------------------------
/// TITRE DE SOUS-PARTIE
/// ------------------------------------------------------------------
class _SubTitle extends StatelessWidget {
  const _SubTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color color = isDark ? Colors.white : const Color(0xFF0D47A1);

    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: Text(
        text,
        style: GoogleFonts.fustat(
          fontWeight: FontWeight.w700,
          fontSize: 14.5,
          color: color,
        ),
      ),
    );
  }
}

/// ------------------------------------------------------------------
/// PARAGRAPHES SIMPLES OU RICHES
/// ------------------------------------------------------------------
/// ------------------------------------------------------------------
/// PARAGRAPHES SIMPLES OU RICHES
///  → Version avec détection automatique des articles de loi en rouge
/// ------------------------------------------------------------------
/// ------------------------------------------------------------------
/// PARAGRAPHES SIMPLES OU RICHES
///  → Version avec détection automatique des articles de loi en rouge
/// ------------------------------------------------------------------
/// ------------------------------------------------------------------
/// PARAGRAPHES SIMPLES OU RICHES
///  → Version avec détection automatique des articles de loi en rouge
/// ------------------------------------------------------------------
class _Paragraph extends StatelessWidget {
  const _Paragraph(this.text) : spans = null;

  const _Paragraph.rich(this.spans) : text = null;

  final String? text;
  final List<TextSpan>? spans;

  // RegExp simple pour détecter les références d’articles de loi
  // Exemples détectés :
  // "article 97", "art. 98", "articles 92 et suivants",
  // "article L. 54-10-1", etc.
  static final RegExp _lawRefRegex = RegExp(
    ScolariteText.value(
          "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
          "f00144",
          r'\b(?:art\.?|article|articles)\s+',
        ) +
        ScolariteText.value(
          "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
          "f00145",
          r'(?:[A-Z]\.\s*)?',
        ) +
        ScolariteText.value(
          "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
          "f00146",
          r'\d+(?:-\d+)*',
        ) +
        ScolariteText.value(
          "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart",
          "f00147",
          r'(?:\s+et\s+suivants)?',
        ), // "et suivants" (optionnel)
    caseSensitive: false,
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final Color color = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withValues(alpha: .92);

    // Style de base du paragraphe
    final TextStyle baseStyle = GoogleFonts.fustat(
      fontSize: 14,
      height: 1.4,
      fontWeight: FontWeight.w500,
      color: color,
    );

    // Si on a déjà des spans riches (_Paragraph.rich), on ne modifie pas
    if (spans != null) {
      return RichText(
        textAlign: TextAlign.justify,
        text: TextSpan(style: baseStyle, children: spans),
      );
    }

    final String content = text ?? '';

    // On cherche les articles de loi
    final matches = _lawRefRegex.allMatches(content).toList();

    // Pas de match → Text simple
    if (matches.isEmpty) {
      return Text(content, textAlign: TextAlign.justify, style: baseStyle);
    }

    // Sinon on découpe le texte et on colore les refs en rouge
    final List<TextSpan> finalSpans = [];
    int currentIndex = 0;

    for (final match in matches) {
      if (match.start > currentIndex) {
        finalSpans.add(
          TextSpan(text: content.substring(currentIndex, match.start)),
        );
      }

      // Partie “article de loi” en rouge
      finalSpans.add(
        TextSpan(
          text: content.substring(match.start, match.end),
          style: baseStyle.copyWith(
            color: Colors.red,
            fontWeight: FontWeight.w700,
          ),
        ),
      );

      currentIndex = match.end;
    }

    // Reste du texte après le dernier match
    if (currentIndex < content.length) {
      finalSpans.add(TextSpan(text: content.substring(currentIndex)));
    }

    return RichText(
      textAlign: TextAlign.justify,
      text: TextSpan(style: baseStyle, children: finalSpans),
    );
  }
}

/// ------------------------------------------------------------------
/// PUCE D’INTRO
/// ------------------------------------------------------------------
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

/// ------------------------------------------------------------------
/// PUCE CLASSIQUE
/// ------------------------------------------------------------------
class _BulletPoint extends StatelessWidget {
  const _BulletPoint({required this.text});

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
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Icon(Icons.check_rounded, size: 18, color: bulletColor),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.fustat(
                fontSize: 14,
                height: 1.35,
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

/// ------------------------------------------------------------------
/// BLOC EXEMPLE
/// ------------------------------------------------------------------
class _ExempleBox extends StatelessWidget {
  const _ExempleBox({required this.bodySpans});

  final String title = 'NOTA';
  final List<TextSpan> bodySpans;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color borderColor = isDark
        ? const Color(0xFF42A5F5)
        : const Color(0xFF1E88E5);
    final Color bgColor = isDark
        ? const Color(0xFF0D1B26)
        : const Color(0xFFE3F2FD);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF0D47A1);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: isDark ? .65 : .9),
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: borderColor, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title :',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w800,
              fontSize: 13.5,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              style: GoogleFonts.fustat(
                fontSize: 13.5,
                height: 1.4,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? Colors.white70
                    : const Color(0xFF102027).withValues(alpha: .95),
              ),
              children: bodySpans,
            ),
          ),
        ],
      ),
    );
  }
}

/// ------------------------------------------------------------------
/// BLOC NOTA / INFO / SANCTION
/// ------------------------------------------------------------------
class _NotaBox extends StatelessWidget {
  const _NotaBox({required this.bodySpans});

  final List<TextSpan> bodySpans;
  final String title = 'NOTA';

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
        color: bgColor.withValues(alpha: isDark ? .70 : .95),
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: borderColor, width: 3)),
      ),
      child: RichText(
        textAlign: TextAlign.justify,
        text: TextSpan(
          style: GoogleFonts.fustat(
            fontSize: 13.5,
            height: 1.4,
            fontWeight: FontWeight.w500,
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
