import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrganisationPoliceNationalePage extends StatelessWidget {
  const OrganisationPoliceNationalePage({super.key});

  static const String routeName =
      '/pa/institution/organisation_pn/organisation';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
    final Color cardIntro = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardMain = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardA = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardB = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardC = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardD = isDark
        ? const Color(0xFF1F2A33)
        : const Color(0xFFEFF7FF);

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
          "Organisation",
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
            "L’organisation & Direction de la Police nationale",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Vue d’ensemble
          _ConditionCard(
            title: "Vue d’ensemble",
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "La Police nationale comporte trois grandes entités au sein desquelles les agents peuvent exercer leurs missions :",
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text: "D.G.P.N. — Direction générale de la Police nationale",
              ),
              _BulletPoint(
                text: "D.G.S.I. — Direction générale de la Sécurité intérieure",
              ),
              _BulletPoint(text: "P.P. — Préfecture de police de Paris"),
            ],
          ),

          const SizedBox(height: 14),

          // I — DGPN
          _ConditionCard(
            title: "I — D.G.P.N. : Direction générale de la Police nationale",
            cardColor: cardMain,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le directeur général de la Police nationale, assisté d’un directeur général adjoint, dirige les activités des directions et services rattachés à la Direction générale de la Police nationale.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Liste structurée DGPN
          _ConditionCard(
            title: "Directions et services rattachés",
            cardColor: cardA,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _SubTitle("A) Direction de gestion et de soutien"),
              _BulletPoint(
                text:
                    "D.R.H.F.S. — Direction des ressources humaines, des finances et des soutiens de la Police nationale",
              ),
              SizedBox(height: 12),

              _SubTitle("B) Directions et services actifs"),
              _BulletPoint(
                text: "I.G.P.N. — Inspection générale de la Police nationale",
              ),
              _BulletPoint(
                text: "D.N.P.J. — Direction nationale de la Police judiciaire",
              ),
              _BulletPoint(
                text: "D.N.S.P. — Direction nationale de la Sécurité publique",
              ),
              _BulletPoint(
                text:
                    "D.N.P.A.F. — Direction nationale de la Police aux frontières",
              ),
              _BulletPoint(
                text:
                    "D.N.R.T. — Direction nationale du Renseignement territorial",
              ),
              _BulletPoint(
                text:
                    "D.C.C.R.S. — Direction centrale des Compagnies républicaines de sécurité",
              ),
              _BulletPoint(text: "A.D.P. — Académie de Police"),
              _BulletPoint(text: "S.D.L.P. — Service de la protection"),
              _BulletPoint(
                text: "S.N.P.S. — Service national de Police scientifique",
              ),
              _BulletPoint(
                text:
                    "R.A.I.D. — Unité de Recherche, d’assistance, d’intervention et de dissuasion",
              ),
              SizedBox(height: 12),

              _SubTitle("C) Services nationaux rattachés"),
              _BulletPoint(
                text:
                    "S.N.E.A.S. — Service national des enquêtes administratives de sécurité",
              ),
              _BulletPoint(
                text:
                    "S.N.E.A.V. — Service national des enquêtes d’autorisation de voyage",
              ),
              SizedBox(height: 12),

              _SubTitle(
                "D) Services mutualisés (avec la Gendarmerie nationale)",
              ),
              _BulletPoint(
                text:
                    "D.C.I.S. — Direction de la coopération internationale de sécurité",
              ),
              _BulletPoint(
                text:
                    "A.N.F.S.I. — Agence du numérique des forces de sécurité intérieure",
              ),
              _BulletPoint(
                text:
                    "S.S.M.S.I. — Service statistique ministériel de la sécurité intérieure",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // NOTA 1
          _ConditionCard(
            title: "NOTA 1 — Services spécialisés rattachés",
            cardColor: cardC,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "D’autres services spécialisés sont également directement rattachés à la Direction générale de la Police nationale, notamment :",
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    "S.I.C.O.P. — Service d’information et de communication de la Police nationale",
              ),
              _BulletPoint(text: "D.A.V. — Délégation aux victimes"),
              _BulletPoint(
                text: "S.H.P.N. — Service historique de la Police nationale",
              ),
              _BulletPoint(
                text: "A.N.D.V. — Agence nationale des données de voyages",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // NOTA 2
          _ConditionCard(
            title: "NOTA 2 — Directions Territoriales de la Police Nationale",
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "En Guadeloupe, à la Martinique, à la Réunion, en Polynésie française, en Guyane, à Mayotte et en Nouvelle-Calédonie, "
                "les Directions Territoriales de la Police Nationale (D.T.P.N.) se substituent aux directions de la Police nationale.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Direction de police unique, la D.T.P.N. exerce les missions des services déconcentrés ou délocalisés de la Police nationale "
                "(Police judiciaire, Police aux frontières, Sécurité publique, Renseignement territorial, Recrutement et formation, antenne R.A.I.D. "
                "en Nouvelle-Calédonie, Guadeloupe et Réunion) dans son ressort territorial de compétence.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // A — DRHFS
          _ConditionCard(
            title:
                "A — D.R.H.F.S. : Direction des ressources humaines, des finances et des soutiens de la Police nationale",
            cardColor: cardA,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Sans préjudice des compétences de la direction des ressources humaines et de la direction de l’évaluation de la performance, de l’achat, des finances "
                "et de l’immobilier du ministère de l’Intérieur, la Direction des ressources humaines, des finances et des soutiens définit les principes de gestion des personnels, "
                "prépare les textes législatifs et réglementaires intéressant les différentes catégories de personnels et assure l’organisation des carrières "
                "et le développement des parcours individualisés.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Elle est responsable du recrutement des personnels contractuels pour les services de la Police nationale, à l’exception de la Direction générale de la Sécurité intérieure "
                "qui exerce cette compétence pour son compte propre.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Elle définit et met en œuvre les politiques d’accompagnement et de prévention des risques professionnels. "
                "Elle conduit la politique ministérielle d’action sociale du logement et de l’enfance pour l’ensemble des personnels du ministère.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Elle participe à l’élaboration et à l’exécution du budget concernant la Police nationale, propose la répartition des moyens financiers entre les services de police "
                "et s’assure de leur bonne utilisation.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Elle participe au suivi des affaires juridiques et des contentieux concernant la Police nationale et est associée à la définition des règles et au suivi "
                "de la mise en œuvre de la protection fonctionnelle au profit des agents.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Elle est chargée de la politique d’innovation et de l’évaluation de la performance de l’administration générale de la Police nationale. "
                "Elle définit et met en œuvre la réglementation liée au temps de travail.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // B — IGPN
          _ConditionCard(
            title: "B — I.G.P.N. : Inspection générale de la Police nationale",
            cardColor: cardB,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "L’Inspection générale de la Police nationale exerce une mission de contrôle sur les directions et services de la Direction générale de la Police nationale, "
                "de la Préfecture de police et de la Direction générale de la Sécurité intérieure.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Elle exerce également des missions d’enquêtes administratives et judiciaires, d’inspection, d’évaluation et d’audit interne, d’analyse, de conseil "
                "et de maîtrise des risques.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "L’Inspection générale de la Police nationale a une compétence nationale.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // C — DNPJ
          _ConditionCard(
            title: "C — D.N.P.J. : Direction nationale de la Police judiciaire",
            cardColor: cardD,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "La Direction nationale de la Police judiciaire concourt à l’exercice des missions de police judiciaire sur l’ensemble du territoire national "
                "et contribue à la prévention et à la répression de toute forme de criminalité et de délinquance, y compris ses formes spécialisées, organisées ou transnationales.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Elle définit les objectifs et anime l’action des services de police exerçant une mission de police judiciaire relevant de sa filière, "
                "sans préjudice des compétences des autres directions et services exerçant une mission de police judiciaire.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Elle administre les organes de la coopération internationale policière mentionnés à ",
                ),
                const TextSpan(
                  text: "l’article D. 8-2 du Code de procédure pénale",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(
                  text:
                      ", et coordonne l’action des centres de coopération policière et douanière.",
                ),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "Elle exerce des missions de police administrative, notamment dans le cadre du contrôle et de la surveillance de l’exploitation des jeux d’argent et de hasard autorisés.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // D — DNSP
          _ConditionCard(
            title: "D — D.N.S.P. : Direction nationale de la Sécurité publique",
            cardColor: cardA,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Sous réserve des compétences du préfet de police et de dispositions particulières, la Direction nationale de la Sécurité publique définit les objectifs "
                "et anime l’action des services de police en matière de sécurité et d’ordre publics dans les communes où la police est étatisée.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Elle contribue à la lutte contre toutes les formes de délinquance, à la sécurité du quotidien et à la protection des personnes, des biens et des institutions. "
                "Elle veille particulièrement aux missions de police-secours, à l’accueil du public et des victimes et favorise le lien entre la police et la population.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Au titre de ses missions de protection de l’espace public, elle est en charge de la sécurité routière et participe à la sécurisation des transports en commun. "
                "Elle assure la coordination nationale de l’action de l’ensemble des intervenants qui y contribuent.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // E — DNPAF
          _ConditionCard(
            title:
                "E — D.N.P.A.F. : Direction nationale de la Police aux frontières",
            cardColor: cardB,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "La Direction nationale de la Police aux frontières définit les objectifs et anime l’action des services chargés de veiller au respect des normes "
                "encadrant le contrôle et la surveillance des frontières terrestres, maritimes et aériennes, en métropole et en outre-mer.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Elle est chargée du respect de la réglementation relative à la lutte contre l’immigration irrégulière. Elle est chef de file, pour la Police nationale, "
                "en matière de traitement procédural des étrangers en situation irrégulière et apporte son soutien aux autres directions nationales.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Elle centralise les informations relatives aux flux et risques migratoires, en établit une analyse et la diffuse à des fins opérationnelles.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Elle assure la mise en œuvre et le suivi de la chaîne de traitement de l’éloignement des étrangers en situation irrégulière "
                "et la gestion opérationnelle des centres de rétention administrative.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Elle organise et coordonne le recrutement et le déploiement des agents du contingent français mis à disposition de l’agence européenne de garde-frontières "
                "et de garde-côtes, dont elle est le point de contact national.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Elle participe à l’élaboration des normes relatives à la sûreté des moyens et infrastructures de transports internationaux et contrôle leur mise en œuvre.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Elle est chargée de la définition des doctrines et du respect de la réglementation encadrant l’emploi des moyens aériens et maritimes de la Police nationale, "
                "et assure la coordination de ces moyens.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // F — DCCRS
          _ConditionCard(
            title:
                "F — D.C.C.R.S. : Direction centrale des Compagnies républicaines de sécurité",
            cardColor: cardC,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "La Direction centrale des Compagnies républicaines de sécurité est spécialisée dans le maintien et le rétablissement de l’ordre public sur l’ensemble du territoire. "
                "Elle a autorité sur les Compagnies républicaines de sécurité et est chargée de leur organisation, de leur contrôle, de la formation de leur personnel "
                "et de la mise en œuvre des effectifs en fonction des missions.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Les Compagnies républicaines de sécurité sont des unités mobiles spécialisées : maintien et rétablissement de l’ordre public, protection des personnes et des biens, "
                "surveillance sur les voies de communication et renfort aux autres services de police.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Elles peuvent porter aide et assistance aux populations en cas de sinistre grave ou de calamité publique.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Elles ne peuvent être employées à des gardes statiques que sur ordre du ministre chargé de l’Intérieur ; ces gardes ne peuvent en aucun cas être permanentes.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // G — DNRT
          _ConditionCard(
            title:
                "G — D.N.R.T. : Direction nationale du Renseignement territorial",
            cardColor: cardD,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Sur l’ensemble du territoire national, à l’exception de Paris et des départements des Hauts-de-Seine, de la Seine-Saint-Denis et du Val-de-Marne, "
                "la Direction nationale du Renseignement territorial est chargée de la recherche, de la centralisation et de l’analyse des renseignements destinés à informer "
                "le Gouvernement et les représentants de l’État dans les domaines institutionnel, économique et social ainsi que dans tous les domaines susceptibles "
                "d’intéresser l’ordre public, notamment les phénomènes de violence.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Elle définit les objectifs et anime l’action des services chargés du renseignement territorial. "
                "Elle contribue à la prévention du terrorisme, en lien avec les services compétents, et agit en coordination avec la Gendarmerie nationale.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // H — ADP
          _ConditionCard(
            title: "H — A.D.P. : Académie de Police",
            cardColor: cardA,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "L’Académie de Police est la direction chargée du recrutement et de la formation de la Police nationale. "
                "Elle est responsable de la formation professionnelle initiale et tout au long de la vie des personnels de la Police nationale.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Elle pilote la stratégie nationale de formation, élabore le programme annuel, assure l’unité, la cohérence et l’ouverture de la formation. "
                "Elle exerce la tutelle de l’École nationale supérieure de police.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Elle organise le recrutement de l’ensemble des personnels actifs, techniques et scientifiques de la Police nationale, à l’exception des personnels contractuels.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Elle est chargée des études et de la recherche de la Police nationale.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // I — SDLP
          _ConditionCard(
            title: "I — S.D.L.P. : Service de la protection",
            cardColor: cardB,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le Service de la protection assure, au profit de personnes françaises ou étrangères, des missions de protection rapprochée et d’accompagnement de sécurité.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Il met en œuvre les mesures nécessaires à la sécurité du Président de la République et contribue à l’organisation et à la sécurité des visites "
                "de hautes personnalités, des événements et manifestations de grande ampleur.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Il assure la surveillance et la protection des bâtiments et emprises de l’administration centrale du ministère de l’Intérieur, "
                "sans préjudice des compétences du haut fonctionnaire de défense.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Il met à disposition des moyens automobiles et est responsable de l’organisation des services d’honneur du ministère de l’Intérieur.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // J — SNPS
          _ConditionCard(
            title: "J — S.N.P.S. : Service national de Police scientifique",
            cardColor: cardC,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _SubTitle("Missions"),
              _BulletPoint(
                text:
                    "Définir, coordonner, mettre en œuvre et évaluer la politique de police scientifique sur le territoire national.",
              ),
              _BulletPoint(
                text:
                    "Réaliser les examens, constatations, expertises, recherches et analyses d’ordre scientifique demandés par l’autorité judiciaire ou les services de police judiciaire.",
              ),
              _BulletPoint(
                text:
                    "Définir et mettre en œuvre le recrutement et la formation initiale et continue des personnels en police scientifique, en lien avec l’Académie de Police.",
              ),
              _BulletPoint(
                text:
                    "Développer et promouvoir les procédés et méthodes en police scientifique et assurer la représentation de la Police nationale.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // K — RAID
          _ConditionCard(
            title:
                "K — R.A.I.D. : Unité de Recherche, d’assistance, d’intervention et de dissuasion",
            cardColor: cardD,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le R.A.I.D. contribue, dans l’ensemble du territoire de la République, à la lutte contre toutes les formes de criminalité. "
                "Il prête assistance aux services de police et intervient notamment :",
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    "Lors de troubles graves à l’ordre public nécessitant des techniques et moyens spécifiques.",
              ),
              _BulletPoint(
                text:
                    "Dans la prévention et la répression de la criminalité organisée et du terrorisme.",
              ),
              _BulletPoint(
                text:
                    "En assistance au Service de la protection dans ses missions.",
              ),
              _BulletPoint(
                text:
                    "En mettant à disposition des matériels spécialisés servis par le personnel de l’unité.",
              ),
              _BulletPoint(
                text:
                    "En contribuant à l’instruction des personnels en lutte antiterroriste, en lien avec l’Académie de Police.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Il participe à des études, essais de techniques et matériels d’intervention, et à la formation de fonctionnaires de police ou de services dans le cadre de ses activités.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // L — ANFSI
          _ConditionCard(
            title:
                "L — A.N.F.S.I. : Agence du numérique des forces de sécurité intérieure",
            cardColor: cardA,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Cette agence est chargée du développement, de la mise en œuvre et de la sécurité des systèmes d’information, des équipements numériques "
                "et des applications au profit des forces de sécurité intérieure.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Elle pilote les infrastructures, terminaux et équipements périphériques à destination des services et unités, des personnels de la Gendarmerie nationale "
                "et des agents de la Police nationale.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Elle conçoit et conduit les projets relatifs aux systèmes d’information, de communication et de commandement. "
                "Elle assure, lorsque cela est pertinent, la convergence des outils numériques des deux forces.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // M — SNEAS
          _ConditionCard(
            title:
                "M — S.N.E.A.S. : Service national des enquêtes administratives de sécurité",
            cardColor: cardB,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le Service national des enquêtes administratives de sécurité réalise des enquêtes administratives destinées à vérifier que le comportement "
                "de personnes physiques ou morales n’est pas incompatible avec certaines autorisations, au regard de la prévention du terrorisme et des atteintes "
                "à la sécurité et à l’ordre public ainsi qu’à la sûreté de l’État.",
              ),
              SizedBox(height: 10),
              _BulletPoint(text: "Autorisation d’accès à des sites sensibles"),
              _BulletPoint(text: "Exercice de missions ou fonctions sensibles"),
              _BulletPoint(
                text:
                    "Utilisation de matériels ou produits présentant un caractère dangereux",
              ),
              _BulletPoint(
                text:
                    "Délivrance, renouvellement ou maintien d’un titre ou d’une autorisation de séjour",
              ),
              _BulletPoint(text: "Acquisition de la nationalité française"),
              _BulletPoint(
                text: "Délivrance ou maintien de la protection internationale",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // N — SNEAV
          _ConditionCard(
            title:
                "N — S.N.E.A.V. : Service national des enquêtes d’autorisation de voyage",
            cardColor: cardC,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Le Service national des enquêtes d’autorisation de voyage examine les demandes d’autorisation de voyage lorsque le traitement automatisé a abouti "
                "à une réponse positive et que l’unité centrale du système européen d’information et d’autorisation concernant les voyages a engagé le traitement manuel. "
                "Il prend ensuite une décision à leur sujet.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title:
                    "Système européen d’information et d’autorisation concernant les voyages",
                bodySpans: const [
                  TextSpan(
                    text:
                        "Ce système vise certains ressortissants de pays tiers exemptés de visa afin d’évaluer un risque en matière de sécurité, d’immigration illégale "
                        "ou de risque épidémique élevé. — ",
                  ),
                  TextSpan(
                    text: "Règlement (UE) 2018/1240 du 12 septembre 2018",
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

          // O — DCIS
          _ConditionCard(
            title:
                "O — D.C.I.S. : Direction de la coopération internationale de sécurité",
            cardColor: cardD,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "La Direction de la coopération internationale de sécurité concourt à la politique étrangère de la France et à la continuité entre sécurité intérieure "
                "et sécurité extérieure.",
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text: "Dirige le réseau des attachés de sécurité intérieure.",
              ),
              _BulletPoint(
                text:
                    "Coordonne et facilite les coopérations opérationnelles, techniques et institutionnelles de la Police et de la Gendarmerie.",
              ),
              _BulletPoint(
                text:
                    "Met en œuvre des coopérations techniques (sécurité civile, sécurité routière, immigration et asile).",
              ),
              _BulletPoint(
                text:
                    "Contribue à l’élaboration des positions françaises auprès des instances européennes et internationales.",
              ),
              _BulletPoint(
                text:
                    "Élabore des projets sur financement européen et international en conformité avec les priorités stratégiques du ministère de l’Intérieur.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // P — SSMSI
          _ConditionCard(
            title:
                "P — S.S.M.S.I. : Service statistique ministériel de la sécurité intérieure",
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le Service statistique ministériel de la sécurité intérieure produit la statistique publique dans les domaines de la sécurité intérieure. "
                "Il élabore, diffuse et publie l’information, les enquêtes et les études statistiques.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Il rassemble, analyse et valorise les données statistiques utiles pour piloter et évaluer les politiques de sécurité. "
                "Il contribue à l’étude des évolutions statistiques de l’ensemble du processus pénal : faits constatés, décisions de justice, exécution des peines, sanctions et récidive.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Il constitue l’autorité nationale pour la production des statistiques européennes dans les domaines de la sécurité intérieure.",
              ),
            ],
          ),

          const SizedBox(height: 12),

          _Paragraph.rich([
            const TextSpan(text: "Document : "),
            TextSpan(
              text: "mis à jour le 15/06/2025.",
              style: const TextStyle(
                color: _lawRed,
                fontWeight: FontWeight.w900,
              ),
            ),
          ]),
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
