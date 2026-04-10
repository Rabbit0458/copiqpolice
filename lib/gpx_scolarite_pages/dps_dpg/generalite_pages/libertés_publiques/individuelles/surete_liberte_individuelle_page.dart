import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ===================================================================
///  COP'IQ — SÛRETÉ & LIBERTÉ INDIVIDUELLE
///
///  Plan général de la page :
///
///   CHAPITRE 1 — PROTECTION LÉGALE DE LA SÛRETÉ
///     1.1 Les mesures judiciaires privatives de liberté
///     1.2 Les mesures administratives privatives de liberté
///
///   CHAPITRE 2 — PROTECTION JUDICIAIRE DE LA SÛRETÉ
///
///   CHAPITRE 3 — SANCTIONS EN CAS D’ARRESTATION OU DE DÉTENTION ARBITRAIRE
///     3.1 Sanctions pénales
///     3.2 Sanctions civiles
///     3.3 Sanctions disciplinaires
///
///   CHAPITRE 4 — CONCLUSION : ÉQUILIBRE ENTRE ORDRE PUBLIC & LIBERTÉ
/// ===================================================================
class SureteLiberteIndividuellePage extends StatelessWidget {
  const SureteLiberteIndividuellePage({super.key});

  static const String routeName =
      '/gpx/generalites/libertes_publiques/individuelles/surete_liberte_individuelle';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    final Color background = isDark ? const Color(0xFF121212) : Colors.white;
    final Color cardColor = isDark
        ? const Color(0xFF1E1E1E)
        : const Color(0xFFF7F7F7);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF050505);
    final Color textColor = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withOpacity(.92);
    final Color accentColor = isDark
        ? const Color(0xFF6A1B9A)
        : const Color(0xFF6A1B9A);
    final Color referenceColor = isDark
        ? const Color(0xFFBA68C8)
        : const Color(0xFF6A1B9A);
    final Color dangerColor = const Color(0xFFFF3B30);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: titleColor),
        ),
        title: Text(
          'Sûreté & liberté individuelle',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: titleColor,
          ),
        ),
      ),

      // ===================== CONTENU =====================
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 26),
        physics: const BouncingScrollPhysics(),
        children: [
          // ================= TITRE + INTRO =================
          Text(
            'La sûreté : cœur de la liberté individuelle',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 6),
          _Paragraph.rich([
            const TextSpan(
              text:
                  'La liberté individuelle, ou sûreté, est la liberté de ne pas être arrêté, détenu ou contrôlé arbitrairement. '
                  'Elle garantit à chacun de pouvoir se déplacer et vivre sans craindre des mesures de privation de liberté décidées sans base légale. '
                  'Elle est considérée comme une liberté fondamentale : ',
            ),
            TextSpan(
              text:
                  '« la liberté fondamentale qui garantit toutes les autres »',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: referenceColor,
              ),
            ),
            const TextSpan(
              text:
                  '. Elle est affirmée par la Déclaration des Droits de l’Homme et du Citoyen de 1789 (articles 2, 7, 8 et 9), '
                  'par la Constitution de 1958, la Convention européenne des droits de l’homme et de nombreux textes internes.',
            ),
          ]),
          const SizedBox(height: 10),
          _NotaBox(
            title: 'Enjeu pratique pour les forces de l’ordre',
            bodySpans: [
              TextSpan(
                text:
                    'Toute mesure portant atteinte à la liberté d’une personne (contrôle, retenue, garde à vue, détention, hospitalisation sous contrainte, '
                    'rétention d’un étranger, etc.) doit reposer sur un texte précis, respecter une procédure encadrée et être strictement nécessaire. '
                    'À défaut, la mesure peut être qualifiée d’',
              ),
              TextSpan(
                text: 'arrestation ou détention arbitraire',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: dangerColor,
                ),
              ),
              const TextSpan(
                text:
                    ', engageant la responsabilité pénale, civile et disciplinaire de l’auteur.',
              ),
            ],
          ),
          const SizedBox(height: 22),

          // =====================================================
          // CHAPITRE 1 — PROTECTION LÉGALE DE LA SÛRETÉ
          // =====================================================
          _HypoCard(
            title:
                'Chapitre 1 — Protection légale de la sûreté :\n« Toute mesure privative de liberté est déterminée par la loi »',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'La sûreté repose sur un principe simple : toute atteinte à la liberté d’aller et venir, toute arrestation ou détention '
                      'doit être prévue, autorisée et encadrée ',
                ),
                TextSpan(
                  text: 'par la loi',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                const TextSpan(
                  text:
                      '. La police et la gendarmerie ne peuvent agir que dans ce cadre. '
                      'Le juge judiciaire et le juge administratif contrôlent ensuite la régularité des mesures.',
                ),
              ]),
              const SizedBox(height: 12),
              _Paragraph.rich([
                TextSpan(
                  text: 'Les grands principes protecteurs sont issus :\n',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'de la Déclaration des Droits de l’Homme et du Citoyen de 1789 (articles 7, 8, 9) : aucun homme ne peut être arrêté ou détenu '
                      'que dans les cas prévus par la loi et selon les formes qu’elle a prescrites ;',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'de la Constitution de 1958, notamment son article 66, qui confie à l’autorité judiciaire la garde de la liberté individuelle ;',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'de la Convention européenne des droits de l’homme (article 5), qui précise les cas limitatifs de privation de liberté et les garanties associées.',
                ),
              ]),
              const SizedBox(height: 12),
              const _NotaBox(
                title: 'Idée clé',
                bodySpans: [
                  TextSpan(
                    text:
                        'Toute privation de liberté est d’abord une question de texte. Pas de fondement légal clair = mesure arbitraire. '
                        'Le policier doit donc toujours pouvoir rattacher son action à un article du code (pénal, procédure pénale, sécurité intérieure, santé publique, CESEDA, etc.).',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 26),

          // =====================================================
          // 1.1 — MESURES JUDICIAIRES PRIVATIVES DE LIBERTÉ
          // =====================================================
          _HypoCard(
            title: '1.1 — Les mesures judiciaires privatives de liberté',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Les mesures judiciaires sont décidées ou contrôlées par l’autorité judiciaire (procureur, juge d’instruction, juge des libertés et de la détention, tribunal). '
                      'Elles répondent à des principes forts : ',
                ),
                TextSpan(
                  text:
                      'légalité des délits et des peines, non-rétroactivité, présomption d’innocence et droits de la défense',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 12),

              // 1.1.1 — Principes
              Text(
                '1.1.1 — Les principes régissant les mesures privatives de liberté',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: 'a) Principe de légalité des délits et des peines\n',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                const TextSpan(
                  text:
                      'Nul ne peut être condamné qu’en vertu d’un texte clair et précis définissant l’infraction et la peine encourue (article 8 DDHC). '
                      'La loi pénale doit être accessible et prévisible : toute incertitude profite à la personne poursuivie. '
                      'Ce principe fonde aussi l’exigence de motivation des décisions de privation de liberté.',
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'b) Principe de non-rétroactivité de la loi pénale plus sévère\n',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                const TextSpan(
                  text:
                      'Une loi pénale plus sévère ne peut s’appliquer aux faits commis avant son entrée en vigueur. '
                      'En revanche, une loi plus douce bénéficie à la personne poursuivie. '
                      'Ce principe protège contre le risque de durcissement arbitraire de la répression.',
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: 'c) Principe de présomption d’innocence\n',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                const TextSpan(
                  text:
                      'Toute personne est présumée innocente tant que sa culpabilité n’a pas été légalement établie (art. 9 DDHC, art. 6 CEDH). '
                      'Les mesures de privation de liberté avant jugement (garde à vue, détention provisoire, contrôle judiciaire…) sont des mesures d’exception, '
                      'strictement encadrées et justifiées par des nécessités précises : enquête, prévention de la fuite, protection des victimes, maintien de l’ordre public, etc.',
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: 'd) Garanties procédurales pénales\n',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                const TextSpan(
                  text:
                      'Les droits de la défense (droit à un avocat, information sur les droits, accès au dossier, débat contradictoire, contrôle par un juge indépendant) '
                      'sont au cœur de toute mesure privative de liberté décidée dans le cadre pénal.',
                ),
              ]),
              const SizedBox(height: 14),

              // 1.1.2 — Cas d’arrestation/détention prévus par la loi
              Text(
                '1.1.2 — Les cas d’arrestation et de détention prévus par la loi',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph(
                'Les textes prévoient de façon limitative les hypothèses dans lesquelles un individu peut être privé de liberté. '
                'On distingue notamment les mesures décidées par les policiers et celles décidées par les magistrats.',
              ),
              const SizedBox(height: 10),

              // a) par les policiers
              _Paragraph.rich([
                TextSpan(
                  text:
                      'a) Arrestation et détention décidées par les policiers\n',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'La garde à vue (articles 62-2 et suivants du C.P.P.), décidée par un O.P.J., avec contrôle du procureur et du juge des libertés et de la détention au-delà de certains délais ;',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'La retenue douanière (Code des douanes), destinée aux besoins de l’enquête en matière douanière ;',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'La retenue judiciaire des mineurs (textes spéciaux), plus protectrice et plus courte que la garde à vue classique ;',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'La vérification d’identité (articles 78-2 et 78-3 C.P.P.), mesure brève et strictement encadrée, qui ne peut se transformer en garde à vue déguisée.',
                ),
              ]),
              const SizedBox(height: 10),

              // b) par les magistrats
              _Paragraph.rich([
                TextSpan(
                  text:
                      'b) Arrestation et détention décidées par les magistrats\n',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Les mandats (d’amener, de dépôt, d’arrêt) délivrés par le juge d’instruction ou la juridiction de jugement ;',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'La détention provisoire, décidée par le juge des libertés et de la détention, sur saisine du juge d’instruction ou de la juridiction de jugement, dans des hypothèses graves et strictement motivées ;',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Les mesures de contrainte à l’égard des témoins défaillants (mandat de comparution, mandat d’arrêt d’un témoin qui se soustrait à la justice) ;',
                ),
              ]),
              const SizedBox(height: 10),

              // c) mesures de sûreté post-sentencielles
              _Paragraph.rich([
                TextSpan(
                  text:
                      'c) Les mesures de sûreté après condamnation ou déclaration d’irresponsabilité pénale\n',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                const TextSpan(
                  text:
                      'La loi prévoit, pour les personnes particulièrement dangereuses, des mesures de sûreté pouvant entraîner une nouvelle privation de liberté :',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'La rétention de sûreté, décidée par une juridiction spécialisée à l’issue de la peine, pour certaines infractions d’une gravité exceptionnelle ;',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Les mesures de sûreté prononcées en cas de déclaration d’irresponsabilité pénale pour cause de trouble mental, comme l’hospitalisation complète en établissement psychiatrique avec garanties renforcées pour la personne et les victimes.',
                ),
              ]),
            ],
          ),

          const SizedBox(height: 26),

          // =====================================================
          // 1.2 — MESURES ADMINISTRATIVES PRIVATIVES DE LIBERTÉ
          // =====================================================
          _HypoCard(
            title: '1.2 — Les mesures administratives privatives de liberté',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph(
                'Les mesures administratives sont décidées par l’autorité administrative (préfet, ministre, maire…) pour prévenir des atteintes graves '
                'à l’ordre public, à la sûreté de l’État ou à la sécurité des personnes. Elles restent des exceptions, soumises à la loi et au contrôle du juge.',
              ),
              const SizedBox(height: 12),

              // 1.2.1 Interdiction de paraître
              Text(
                '1.2.1 — Interdiction de paraître',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph(
                'L’interdiction de paraître est une mesure visant à empêcher une personne de se rendre dans certains lieux déterminés '
                '(périmètre d’une manifestation, abords d’un stade, quartier sensible, etc.) lorsqu’elle représente un risque sérieux de troubles à l’ordre public. '
                'La décision est écrite, motivée, notifiée à l’intéressé et limitée dans le temps. Le non-respect de l’interdiction est pénalement sanctionné.',
              ),
              const SizedBox(height: 12),

              // 1.2.2 Assignation à résidence / internement administratif
              Text(
                '1.2.2 — Assignation à résidence et internement administratif',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text: 'a) Assignation à résidence\n',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                const TextSpan(
                  text:
                      'L’assignation à résidence oblige une personne à demeurer dans un lieu déterminé, avec éventuellement des horaires de pointage, '
                      'des obligations de présentation et une interdiction de se déplacer au-delà d’un certain rayon. '
                      'Elle est utilisée notamment en période d’état d’urgence ou dans le cadre de la lutte contre le terrorisme, '
                      'mais aussi, sous d’autres formes, pour certains étrangers.',
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text: 'b) Internement administratif\n',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                const TextSpan(
                  text:
                      'Historiquement employées dans des périodes troubles (guerres, situation exceptionnelle), ces mesures permettent l’enfermement de personnes '
                      'représentant une menace grave pour la sécurité nationale, sans condamnation pénale. Elles sont aujourd’hui strictement encadrées '
                      'et font l’objet d’un contrôle renforcé du juge administratif et, parfois, du Conseil constitutionnel.',
                ),
              ]),
              const SizedBox(height: 12),

              // 1.2.3 Retenue administrative
              Text(
                '1.2.3 — La retenue administrative',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph(
                'Il existe plusieurs formes de retenue administrative, notamment dans le cadre des perquisitions administratives, des contrôles aux frontières '
                'ou de la lutte contre le terrorisme. Leur point commun : elles sont limitées à la durée strictement nécessaire aux vérifications, '
                'généralement quelques heures, sous contrôle du procureur de la République. Les droits de la personne retenue (information, avocat, médecin, '
                'contact avec un proche) doivent être respectés.',
              ),
              const SizedBox(height: 10),

              // 1.2.4 Soins psychiatriques sans consentement
              Text(
                '1.2.4 — Admissions en soins psychiatriques sans consentement',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph(
                'L’hospitalisation psychiatrique sans consentement constitue une privation grave de liberté. Elle intervient lorsque les troubles mentaux '
                'd’une personne rendent impossible son consentement ou font craindre un danger pour elle-même ou pour autrui. '
                'Le Code de la santé publique distingue plusieurs régimes :',
              ),
              const SizedBox(height: 6),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Admission à la demande d’un tiers (proche, représentant légal) avec certificats médicaux circonstanciés récents ;',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Admission sur décision du représentant de l’État (préfet) lorsqu’il existe un danger grave pour l’ordre public ou la sûreté des personnes ;',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Contrôle systématique du juge des libertés et de la détention dans des délais courts (12 jours, puis tous les 6 mois), '
                      'qui peut ordonner la mainlevée de la mesure.',
                ),
              ]),
              const SizedBox(height: 8),
              const _NotaBox(
                title: 'Point de vigilance',
                bodySpans: [
                  TextSpan(
                    text:
                        'Pour les policiers, la prise en charge d’une personne souffrant de troubles psychiatriques impose d’articuler impératif de sûreté et respect de la dignité. '
                        'La qualification juridique (hospitalisation libre, soins sans consentement, garde à vue, cellule de dégrisement…) doit être choisie en fonction de la situation réelle, '
                        'en lien avec le médecin et le parquet.',
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 1.2.5 et 1.2.6 – Mesures visant les étrangers
              Text(
                '1.2.5 — Placement en local de dégrisement',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph(
                'Une personne en état d’ivresse publique et manifeste peut être retenue, à titre de mesure de police administrative, dans un local de dégrisement '
                'le temps strictement nécessaire au rétablissement de ses facultés. Cette mesure vise à la protection de la personne et de l’ordre public. '
                'Elle n’a pas le caractère d’une sanction, mais toute violence ou dégradation commise pendant la retenue peut donner lieu à poursuites pénales.',
              ),
              const SizedBox(height: 12),
              Text(
                '1.2.6 — Mesures à l’encontre des étrangers (zone d’attente, assignation, rétention administrative)',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph(
                'Le Code de l’entrée et du séjour des étrangers et du droit d’asile (CESEDA) prévoit plusieurs régimes spécifiques de privation de liberté '
                'concernant les étrangers :',
              ),
              const SizedBox(height: 6),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Le placement en zone d’attente pour les étrangers non admis à entrer sur le territoire ou demandant l’asile à la frontière ;',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'L’assignation à résidence, lorsque la rétention n’est pas possible ou pas nécessaire, mais que l’éloignement doit rester réalisable ;',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'La rétention administrative dans un centre spécialisé, destinée à préparer l’éloignement du territoire (OQTF, expulsion, réadmission européenne, etc.).',
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'La durée de la rétention est strictement encadrée (durée initiale de 48 heures, prolongations possibles par le juge des libertés et de la détention, '
                      'dans la limite maximale fixée par la loi). À chaque étape, un juge contrôle la régularité de la mesure, l’effectivité des démarches d’éloignement '
                      'et la compatibilité avec le respect de la vie privée et familiale.',
                ),
              ]),
            ],
          ),

          const SizedBox(height: 26),

          // =====================================================
          // CHAPITRE 2 — PROTECTION JUDICIAIRE DE LA SÛRETÉ
          // =====================================================
          _HypoCard(
            title: 'Chapitre 2 — La protection judiciaire de la sûreté',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text:
                      'L’article 66 de la Constitution confie à l’autorité judiciaire le rôle de ',
                  style: const TextStyle(),
                ),
                TextSpan(
                  text: '« gardienne de la liberté individuelle »',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                const TextSpan(
                  text:
                      '. Concrètement, cela signifie que tout maintien en détention, toute mesure privative de liberté décidée par l’administration, '
                      'doit pouvoir être contrôlé par un juge judiciaire indépendant.',
                ),
              ]),
              const SizedBox(height: 10),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Le juge des libertés et de la détention (JLD) contrôle la garde à vue, la détention provisoire, les hospitalisations sans consentement, '
                      'la rétention administrative des étrangers, les perquisitions de nuit, etc. ;',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Les juridictions pénales peuvent sanctionner tout manquement aux règles protectrices de la liberté individuelle (nullité de procédure, '
                      'mise en liberté, dommages-intérêts, relaxe) ;',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Le juge administratif contrôle la légalité des mesures de police administrative (assignation à résidence, interdiction de paraître, '
                      'décisions préfectorales, etc.) et peut ordonner leur suspension en urgence (référé-liberté).',
                ),
              ]),
              const SizedBox(height: 10),
              const _NotaBox(
                title: 'Pour les policiers',
                bodySpans: [
                  TextSpan(
                    text:
                        'La qualité des procédures (mention précise de l’heure, des circonstances, des raisons de la mesure, information des droits, respect des délais) '
                        'conditionne la validation ultérieure par les juges. Un manquement de forme peut suffire à faire annuler une garde à vue, une perquisition, '
                        'ou une rétention. Le sérieux de la rédaction des procès-verbaux est donc une garantie directe de la liberté individuelle… et de la sécurité juridique des agents.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 26),

          // =====================================================
          // CHAPITRE 3 — SANCTIONS EN CAS D’ARRESTATION OU DE DÉTENTION ARBITRAIRE
          // =====================================================
          _HypoCard(
            title:
                'Chapitre 3 — Les sanctions en cas d’arrestation ou de détention arbitraire',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              Text(
                '3.1 — Les sanctions pénales',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'a) Infractions commises par un fonctionnaire agissant dans l’exercice de ses fonctions\n',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                const TextSpan(
                  text:
                      'Le Code pénal sanctionne sévèrement les arrestations ou détentions arbitraires décidées par une personne dépositaire de l’autorité publique :',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'ordonner ou accomplir une arrestation ou une détention arbitraire (article 432-4 C. pén.) ;',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'laisser se prolonger arbitrairement une détention (article 432-5 C. pén.) ;',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'porter ou laisser porter atteinte, en dehors des cas prévus par la loi, à la liberté individuelle d’une personne dont on a la garde ou la surveillance.',
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph(
                'Ces infractions sont punies de lourdes peines d’emprisonnement et d’amende, '
                'aggravées lorsque la victime est mineure, vulnérable ou lorsque la privation de liberté '
                's’accompagne de violences ou de traitements inhumains ou dégradants.',
              ),
              const SizedBox(height: 14),

              _Paragraph.rich([
                TextSpan(
                  text: '3.1.2 — Infraction dont l’auteur est un particulier\n',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                const TextSpan(
                  text:
                      'Un particulier peut lui aussi commettre une atteinte grave à la liberté individuelle. '
                      'Le Code pénal réprime notamment :',
                ),
              ]),
              const SizedBox(height: 6),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'l’arrestation, la détention ou la séquestration arbitraire d’une personne (article 224-1 C. pén.), '
                      'puni de peines pouvant aller jusqu’à 20 ans de réclusion criminelle en cas de circonstances aggravantes ;',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'les violences, menaces ou manœuvres destinées à contraindre quelqu’un à se déplacer ou à rester dans un lieu contre son gré.',
                ),
              ]),
              const SizedBox(height: 8),
              const _NotaBox(
                title: 'Idée clé',
                bodySpans: [
                  TextSpan(
                    text:
                        'L’arrestation ou la détention arbitraire n’est pas seulement une faute disciplinaire : c’est d’abord une infraction pénale, '
                        'susceptible de conduire son auteur devant la cour d’assises ou le tribunal correctionnel.',
                  ),
                ],
              ),

              const SizedBox(height: 22),

              Text(
                '3.2 — Les sanctions civiles (dommages-intérêts)',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Indépendamment des poursuites pénales, la victime peut obtenir réparation de son préjudice devant les juridictions civiles ou administratives. '
                      'La responsabilité de l’État peut être engagée sur le fondement de : ',
                ),
                TextSpan(
                  text: 'l’article 1240 du Code civil',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                const TextSpan(
                  text:
                      ' (faute d’un agent public) ou des textes spéciaux relatifs aux détentions provisoires injustifiées.',
                ),
              ]),
              const SizedBox(height: 6),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Réparation de la détention provisoire injustifiée (indemnisation spécifique après décision de non-lieu, relaxe ou acquittement) ;',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Indemnisation des atteintes à la vie privée, à la dignité, à l’intégrité physique, à la carrière professionnelle, etc. ;',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Possibilité, dans certains cas, de saisir la Cour européenne des droits de l’homme lorsque la privation de liberté méconnaît l’article 5 de la C.E.D.H.',
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph(
                'Ces actions permettent de compenser le préjudice subi (dommages-intérêts) même lorsque l’auteur de l’atteinte '
                'n’est pas personnellement condamné pénalement, dès lors que l’illégalité de la mesure est reconnue.',
              ),

              const SizedBox(height: 22),

              Text(
                '3.3 — Les sanctions disciplinaires',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Les fonctionnaires de police et de gendarmerie sont soumis à des règles déontologiques strictes. '
                      'Toute atteinte illégale à la liberté individuelle peut donner lieu à des sanctions disciplinaires indépendamment des poursuites pénales. '
                      'Le Code de déontologie de la police nationale et de la gendarmerie (',
                ),
                TextSpan(
                  text: 'article R. 434-17 du Code de la sécurité intérieure',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                const TextSpan(
                  text:
                      ') rappelle que « toute personne appréhendée doit être traitée avec dignité et ne subir aucune violence injustifiée ». ',
                ),
              ]),
              const SizedBox(height: 6),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'avertissement ou blâme pour un manquement léger aux règles de procédure ;',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'exclusion temporaire, rétrogradation ou mutation d’office en cas de faute grave ;',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'révocation (radiation des cadres) lorsqu’un agent se rend coupable d’atteintes particulièrement graves à la liberté individuelle ou à la dignité des personnes.',
                ),
              ]),
              const SizedBox(height: 8),
              const _NotaBox(
                title: 'Conséquence pratique',
                bodySpans: [
                  TextSpan(
                    text:
                        'Une seule mesure irrégulière peut donc avoir un triple impact pour l’agent : pénal, civil et disciplinaire. '
                        'La meilleure protection reste le respect strict des textes applicables et la rédaction rigoureuse des procès-verbaux.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 30),

          // =====================================================
          // CHAPITRE 4 — CONCLUSION
          // =====================================================
          _HypoCard(
            title:
                'Chapitre 4 — Conclusion : la sûreté, un équilibre entre ordre public et liberté individuelle',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph(
                'La sûreté n’est pas la négation de l’action de la police : elle en fixe le cadre. '
                'Elle rappelle que toute atteinte portée à la liberté d’une personne doit répondre à trois exigences cumulatives :',
              ),
              const SizedBox(height: 8),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'un fondement légal précis (texte clair, compétence de l’auteur de la décision) ;',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'le respect de la procédure (motivation, information des droits, délais, traçabilité dans les procès-verbaux) ;',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'la nécessité et la proportionnalité de la mesure au regard des objectifs poursuivis (enquête, protection des victimes, maintien de l’ordre public).',
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'L’article 66 de la Constitution confie à l’autorité judiciaire la garde de la liberté individuelle. '
                      'Mais, au quotidien, ce sont les forces de l’ordre qui, par leur pratique professionnelle, donnent une réalité concrète à ce principe. '
                      'Une intervention bien menée, clairement justifiée et correctement rédigée est à la fois : ',
                ),
                TextSpan(
                  text: 'efficace sur le plan opérationnel',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                const TextSpan(text: ' et '),
                TextSpan(
                  text: 'irréprochable sur le plan juridique',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 10),
              const _NotaBox(
                title: 'Réflexe opérationnel',
                bodySpans: [
                  TextSpan(
                    text:
                        'Avant toute mesure privative de liberté, le policier devrait systématiquement se poser trois questions : '
                        '1) Quel est le texte qui fonde ma décision ? 2) Ai-je respecté toutes les garanties de procédure ? '
                        '3) La mesure est-elle vraiment nécessaire et proportionnée ? '
                        'Si l’une de ces réponses est incertaine, il convient de réévaluer la décision avec le supérieur hiérarchique ou le parquet.',
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

/// ------------------------------------------------------------------
/// CARTE DE CONTENU (bloc structuré)
/// ------------------------------------------------------------------
class _HypoCard extends StatelessWidget {
  const _HypoCard({
    required this.title,
    required this.cardColor,
    required this.accent,
    required this.titleColor,
    required this.textColor,
    required this.children,
  });

  final String title;
  final Color cardColor;
  final Color accent;
  final Color titleColor;
  final Color textColor;
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

/// ------------------------------------------------------------------
/// PARAGRAPHES (texte simple ou riche)
/// ------------------------------------------------------------------
class _Paragraph extends StatelessWidget {
  const _Paragraph(this.text) : spans = null;
  const _Paragraph.rich(this.spans) : text = null;

  final String? text;
  final List<TextSpan>? spans;

  @override
  Widget build(BuildContext context) {
    final bool isRich = spans != null;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color color = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withOpacity(.92);

    if (!isRich) {
      return Text(
        text ?? '',
        textAlign: TextAlign.justify,
        style: GoogleFonts.fustat(
          fontSize: 14,
          height: 1.4,
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
          height: 1.4,
          fontWeight: FontWeight.w500,
          color: color,
        ),
        children: spans,
      ),
    );
  }
}

/// ------------------------------------------------------------------
/// PUCE (liste à points)
/// ------------------------------------------------------------------
class _BulletPoint extends StatelessWidget {
  const _BulletPoint.rich(this.spans, {super.key});

  final List<InlineSpan> spans;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color color = isDark ? Colors.white70 : const Color(0xFF1F1F1F);

    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: TextStyle(fontSize: 15, height: 1.4, color: color)),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: TextStyle(fontSize: 14, height: 1.35, color: color),
                children: spans,
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
  const _ExempleBox({required this.title, required this.bodySpans});

  final String title;
  final List<TextSpan> bodySpans;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
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
        color: bgColor.withOpacity(isDark ? .65 : .9),
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
                    : const Color(0xFF102027).withOpacity(.95),
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
/// BLOC NOTA / MISE EN GARDE
/// ------------------------------------------------------------------
class _NotaBox extends StatelessWidget {
  const _NotaBox({required this.bodySpans, this.title = 'NOTA'});

  final List<TextSpan> bodySpans;
  final String title;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
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
        color: bgColor.withOpacity(isDark ? .70 : .95),
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
