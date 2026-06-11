import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ===================================================================
///  COP'IQ — LIBERTÉ D’ALLER ET VENIR
///
///  - Valeur constitutionnelle de la liberté d’aller et venir
///  - Liberté de mouvement (nationaux, étrangers, personnes vulnérables)
///  - Régime du séjour des étrangers (conditions, cartes, fin du séjour)
///  - Police de la circulation (stationnement, circulation, permis)
///  - Sanctions et retrait du permis de conduire
/// ===================================================================
class PaLiberteAllerVenirDetailPage extends StatelessWidget {
  const PaLiberteAllerVenirDetailPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/libertes_publiques/individuelles/liberte_aller_venir_detail';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    final Color background = isDark ? const Color(0xFF121212) : Colors.white;
    final Color cardColor = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF7F7F7);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF5D4037);
    final Color textColor = isDark ? Colors.white70 : const Color(0xFF424242);
    final Color accentColor = isDark
        ? const Color(0xFF1976D2)
        : const Color(0xFF1565C0);
    final Color referenceColor = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    const dangerColor = Color(0xFFFF3B30);

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
          'La liberté d’aller et venir',
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
            'I. La liberté d’aller et venir\n'
            '(mouvement, séjour, circulation)',
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
                  'La liberté d’aller et venir est un principe de valeur constitutionnelle, '
                  'dégagé par le Conseil constitutionnel (décision du 12 janvier 1977 notamment). '
                  'Elle constitue l’un des aspects essentiels de la liberté individuelle et du droit au respect de la vie privée. '
                  'Cette liberté recouvre plusieurs dimensions : le ',
            ),
            TextSpan(
              text: 'mouvement',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: referenceColor,
              ),
            ),
            const TextSpan(text: ', le '),
            TextSpan(
              text: 'séjour',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: referenceColor,
              ),
            ),
            const TextSpan(text: ' et la '),
            TextSpan(
              text: 'circulation',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: referenceColor,
              ),
            ),
            const TextSpan(
              text:
                  ' sur le territoire. Chacune de ces dimensions peut faire l’objet de restrictions encadrées par la loi, '
                  'pour des motifs d’ordre public ou de sécurité publique.',
            ),
          ]),
          const SizedBox(height: 12),
          const _NotaBox(
            title: 'Triptyque à retenir',
            bodySpans: [
              TextSpan(
                text:
                    'L’étude de la liberté d’aller et venir se fait en pratique à travers trois régimes juridiques :\n',
              ),
              TextSpan(
                text:
                    '• la liberté de mouvement (déplacements, présence sur le territoire) ;\n'
                    '• le régime du séjour, surtout pour les étrangers ;\n'
                    '• la police de la circulation et du stationnement, qui encadre l’usage des voies publiques.\n\n',
              ),
              TextSpan(
                text:
                    'Les atteintes portées à ces libertés doivent toujours être prévues par la loi, nécessaires, '
                    'adaptées et proportionnées à l’objectif poursuivi.',
              ),
            ],
          ),
          const SizedBox(height: 22),

          // =====================================================
          // CHAPITRE 1 — LIBERTÉ DE MOUVEMENT
          // =====================================================
          _HypoCard(
            title: 'Chapitre 1 — La liberté de mouvement',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              const _Paragraph(
                'La liberté de mouvement des personnes physiques correspond à la faculté de se déplacer et '
                'de résider où l’on souhaite sur le territoire. Elle est, en principe, libre pour les nationaux, '
                'mais peut être encadrée pour les étrangers (conditions d’entrée et de séjour).',
              ),
              const SizedBox(height: 10),

              // ----------------- 1.1 Nationaux français -----------------
              Text(
                '1.1 – Les nationaux français',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              const _Paragraph.rich([
                TextSpan(
                  text:
                      'Pour les citoyens français, la liberté de mouvement est la règle. Elle se rattache aux articles 2, 4 et 13 de la '
                      'Déclaration des droits de l’homme et du citoyen de 1789 (liberté, sûreté et droit de circuler). '
                      'Le Conseil constitutionnel reconnaît que les restrictions apportées à cette liberté doivent être justifiées par des exigences '
                      'd’ordre public, notamment dans les régimes d’exception (état de siège, état d’urgence). ',
                ),
                TextSpan(
                  text: 'L’interdiction de séjour',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: dangerColor,
                  ),
                ),
                TextSpan(
                  text:
                      ' ou certaines mesures de contrôle judiciaire peuvent limiter temporairement les déplacements, '
                      'mais elles doivent être prévues par la loi et placées sous contrôle du juge.',
                ),
              ]),
              const SizedBox(height: 10),

              // ----------------- 1.2 Les étrangers -----------------
              Text(
                '1.2 – Les étrangers',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'À la différence des nationaux, la liberté de mouvement des étrangers est subordonnée à des conditions d’entrée '
                      'et de séjour fixées par le ',
                ),
                TextSpan(
                  text:
                      'Code de l’entrée et du séjour des étrangers et du droit d’asile (C.E.S.E.D.A.)',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                const TextSpan(
                  text:
                      '. L’administration peut refuser l’accès au territoire, limiter la durée du séjour ou imposer certaines formalités '
                      '(visa, titre de séjour, obligations de pointage…), sous le contrôle du juge administratif et, dans certains cas, du juge judiciaire.',
                ),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'L’entrée sur le territoire français est en principe conditionnée à la présentation de documents (passeport, visa, justification de ressources, etc.).',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Le séjour au-delà d’une certaine durée nécessite la détention d’un titre ou d’une carte de séjour valide.',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Les mesures d’éloignement (OQTF, expulsions) peuvent limiter de manière radicale la liberté de mouvement de l’étranger.',
                ),
              ]),
              const SizedBox(height: 12),

              // ----------------- 1.2.2 Régime applicable aux réfugiés & ressortissants UE -----------------
              Text(
                '1.2.1 – Réfugiés et protection internationale',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              const _Paragraph(
                'Les réfugiés bénéficiant de la protection internationale ont le droit de résider régulièrement sur le territoire français. '
                'Les titres qui leur sont délivrés (carte de résident, titre de séjour pluriannuel) leur permettent une liberté de mouvement '
                'équivalente à celle des autres étrangers en situation régulière, sous réserve des mêmes limites d’ordre public.',
              ),
              const SizedBox(height: 8),
              Text(
                '1.2.2 – Ressortissants des États membres de l’Union européenne',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Les citoyens des États membres de l’Union européenne bénéficient du ',
                ),
                TextSpan(
                  text: 'droit à la libre circulation et au libre séjour',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                const TextSpan(
                  text:
                      ' sur le territoire des autres États membres, sous réserve de ne pas devenir une charge déraisonnable pour le système social '
                      'et de ne pas constituer une menace grave pour l’ordre public. Des mesures d’éloignement peuvent être prises, mais elles doivent être '
                      'strictement justifiées et proportionnées (directive 2004/38/CE).',
                ),
              ]),
              const SizedBox(height: 12),

              // ----------------- 1.3 Personnes itinérantes / vulnérables -----------------
              Text(
                '1.3 – Les personnes itinérantes et vulnérables',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              const _Paragraph(
                'Certaines catégories de personnes se caractérisent par une mobilité accrue ou l’absence de domicile fixe. '
                'La réglementation tente de concilier leur liberté d’aller et venir avec les nécessités d’ordre public et de gestion des espaces publics.',
              ),
              const SizedBox(height: 6),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Les commerçants ambulants : soumis à la détention d’une carte permettant l’exercice d’une activité commerciale ambulante, '
                      'délivrée après vérification d’identité et immatriculation aux registres compétents. Ils doivent pouvoir présenter plusieurs documents '
                      '(carte professionnelle, pièce d’identité, autorisation de stationnement…).',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Les personnes sans résidence ni domicile fixe (S.R.D.F.) : ce sont les personnes ne pratiquant pas d’activité ambulante, '
                      'mais dépourvues de résidence stable. La loi reconnaît un « droit à la domiciliation » auprès de structures sociales agréées, '
                      'condition indispensable pour l’accès à certains droits (prestations sociales, inscription sur les listes électorales, etc.).',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Les gens du voyage : ils sont soumis à des règles particulières de stationnement des résidences mobiles (schémas départementaux d’accueil, '
                      'aires d’accueil aménagées, procédures d’évacuation en cas de stationnement illicite). L’objectif est de garantir un équilibre entre '
                      'leur liberté de circulation et la protection de l’ordre public local.',
                ),
              ]),
              const SizedBox(height: 10),
              const _NotaBox(
                title: 'Équilibre à trouver',
                bodySpans: [
                  TextSpan(
                    text:
                        'Pour les personnes itinérantes, les mesures de police (interdictions de stationnement, évacuations, contrôles) '
                        'ne doivent jamais avoir pour effet de priver la liberté d’aller et venir de tout contenu. '
                        'Le Conseil d’État contrôle la proportionnalité de ces mesures au regard des troubles effectivement constatés.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // =====================================================
          // CHAPITRE 2 — LE SÉJOUR
          // =====================================================
          _HypoCard(
            title: 'Chapitre 2 — Le séjour',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              const _Paragraph(
                'Le national français peut séjourner librement sur l’ensemble du territoire, sauf mesures exceptionnelles '
                '(interdiction de séjour, assignation à résidence dans le cadre de l’état d’urgence, etc.). '
                'Pour les étrangers, le séjour est encadré par le C.E.S.E.D.A. et suppose la détention d’un titre. '
                'La durée et la stabilité du séjour déterminent le type de carte octroyée.',
              ),
              const SizedBox(height: 12),

              // ----------------- 2.1 Conditions de séjour -----------------
              Text(
                '2.1 – Les conditions de séjour des étrangers',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              const _Paragraph(
                'Les étrangers majeurs qui souhaitent rester plus de trois mois doivent être titulaires d’un document de séjour : '
                'carte de séjour temporaire, pluriannuelle, carte de résident, ou cartes spécifiques (étudiant, salarié, retraité, etc.).',
              ),
              const SizedBox(height: 8),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Carte de séjour temporaire : accordée pour une durée limitée (souvent un an), renouvelable, pour divers motifs (études, travail, vie privée et familiale…).',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Carte de séjour pluriannuelle (art. L. 411-4 C.E.S.E.D.A.) : délivrée après un premier séjour régulier, '
                      'pour une durée maximale de quatre ans, lorsque l’étranger remplit les conditions de stabilité et d’intégration.',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Carte de résident (art. L. 411-3 et s.) : délivrée en principe après plusieurs années de séjour régulier et une intégration suffisante, '
                      'pour dix ans renouvelables. Elle confère une stabilité forte au titulaire.',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Cartes spécifiques : carte « retraité », cartes pour les mineurs devenus majeurs, cartes pour motifs médicaux, etc., '
                      'chacune répondant à des conditions strictes prévues par la loi.',
                ),
              ]),
              const SizedBox(height: 10),

              Text(
                '2.1.2 – Liberté de séjour des ressortissants de l’Union européenne',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              const _Paragraph(
                'Les ressortissants de l’Union européenne peuvent séjourner en France plus de trois mois s’ils exercent une activité '
                'professionnelle, disposent de ressources suffisantes ou sont étudiants. Une carte de séjour n’est pas obligatoire, mais '
                'un enregistrement peut être exigé. Des mesures de retrait du droit au séjour peuvent être décidées en cas de menace grave '
                'pour l’ordre public, sous le contrôle du juge.',
              ),
              const SizedBox(height: 12),

              // ----------------- 2.2 Fin du séjour : OQTF, expulsion, extradition -----------------
              Text(
                '2.2 – La fin du séjour : OQTF, expulsion, extradition',
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
                      'Lorsque les conditions de séjour ne sont plus remplies ou que l’étranger représente une menace grave, '
                      'l’administration peut mettre fin à son séjour par différents mécanismes : ',
                  style: GoogleFonts.fustat(fontSize: 14, height: 1.4),
                ),
                const TextSpan(
                  text:
                      'obligation de quitter le territoire français (O.Q.T.F.), mesures d’expulsion ou extradition.',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: dangerColor,
                  ),
                ),
              ]),
              const SizedBox(height: 8),

              Text(
                '2.2.1 – L’obligation de quitter le territoire français (O.Q.T.F.)',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              const _Paragraph(
                'L’O.Q.T.F. est une mesure administrative d’éloignement, prise par le préfet, lorsqu’un étranger se maintient '
                'irrégulièrement sur le territoire (absence ou retrait de titre de séjour, menace à l’ordre public, etc.). '
                'Un délai de départ volontaire d’en principe 30 jours peut être accordé, sauf risque de fuite ou menace grave. '
                'La décision peut être contestée devant le juge administratif, mais elle peut, à défaut d’exécution volontaire, '
                'être mise en œuvre d’office.',
              ),
              const SizedBox(height: 8),

              Text(
                '2.2.2 – L’expulsion',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              const _Paragraph(
                'L’expulsion est une mesure plus grave, visant un étranger dont la présence constitue une menace grave pour l’ordre public '
                'ou la sécurité de l’État. Elle est décidée, en principe, par le ministre de l’Intérieur, après avis d’une commission '
                'd’expulsion. Dans les cas d’urgence absolue, la procédure peut être allégée. Certaines catégories (mineurs, étrangers '
                'présentant des attaches familiales fortes en France) bénéficient d’une protection renforcée.',
              ),
              const SizedBox(height: 8),

              Text(
                '2.2.3 – L’extradition',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              const _Paragraph(
                'L’extradition consiste à remettre une personne à un État étranger qui la recherche pour l’exécution d’une peine ou '
                'la poursuite d’infractions. En France, elle est autorisée par décret du Premier ministre après avis de la chambre de '
                'l’instruction. Les procédures d’extradition sont encadrées par les conventions internationales et ne peuvent conduire '
                'à livrer une personne susceptible d’encourir la peine de mort ou des traitements inhumains.',
              ),
              const SizedBox(height: 10),
              const _NotaBox(
                title: 'Contrôle juridictionnel',
                bodySpans: [
                  TextSpan(
                    text:
                        'Les mesures d’éloignement (O.Q.T.F., expulsion, extradition) portent une atteinte particulièrement forte à la liberté d’aller et venir. '
                        'Elles font donc l’objet d’un contrôle strict du juge administratif ou judiciaire, qui vérifie la réalité des motifs invoqués, '
                        'le respect de la vie privée et familiale, et la proportionnalité de la mesure.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // =====================================================
          // CHAPITRE 3 — POLICE DE LA CIRCULATION
          // =====================================================
          _HypoCard(
            title: 'Chapitre 3 — Police de la circulation',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              const _Paragraph(
                'La liberté d’aller et venir implique de pouvoir se déplacer sur les voies ouvertes à la circulation. '
                'La police de la circulation et du stationnement cherche à concilier ce principe avec la sécurité routière, '
                'la fluidité des déplacements et la protection de l’environnement urbain.',
              ),
              const SizedBox(height: 10),

              // 3.1 Stationnement
              Text(
                '3.1 – La réglementation du stationnement',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              const _Paragraph(
                'Le stationnement sur la voie publique est libre, mais peut être limité dans le temps ou dans l’espace pour assurer la rotation des véhicules '
                'et la sécurité. Certaines restrictions visent spécifiquement le camping ou le stationnement prolongé des résidences mobiles '
                '(camping-cars, caravanes, gens du voyage).',
              ),
              const SizedBox(height: 6),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Stationnement automobile : limitation de durée, zones payantes, zones bleues, stationnement gênant ou dangereux (infractions au code de la route).',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Camping et stationnement des gens du voyage : obligations pour les communes de prévoir des aires d’accueil ; '
                      'possibilité pour le maire ou le préfet de prendre des arrêtés interdisant le stationnement en dehors de ces aires, '
                      'avec procédures d’évacuation en cas d’occupation illicite.',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Procédure d’évacuation : mise en demeure de quitter les lieux, possibilité de saisir le juge pour autoriser l’évacuation forcée '
                      'si l’occupation porte gravement atteinte à l’ordre public, à la sécurité ou à la salubrité.',
                ),
              ]),
              const SizedBox(height: 12),

              // 3.2 Circulation automobile
              Text(
                '3.2 – La réglementation de la circulation automobile',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              const _Paragraph(
                'La circulation automobile est encadrée par le Code de la route et divers textes spéciaux. '
                'Les autorités compétentes (État, préfets, maires) peuvent limiter ou organiser la circulation '
                '(sens de circulation, zones piétonnes, limitations de vitesse, interdictions temporaires).',
              ),
              const SizedBox(height: 6),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Principe d’égalité devant l’usage de la voie publique : toute restriction doit reposer sur un motif d’intérêt général '
                      'et s’appliquer de manière non discriminatoire.',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Mesures de sécurité : limitations de vitesse, obligations d’équipement du véhicule (ceintures, sièges enfants, etc.), '
                      'règles de priorité, interdictions de circulation en cas de pollution ou de conditions météorologiques extrêmes.',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Régimes particuliers : transport de matières dangereuses, convois exceptionnels, manifestations sportives sur la voie publique, '
                      'pour lesquels des autorisations et itinéraires spécifiques sont imposés.',
                ),
              ]),
              const SizedBox(height: 12),

              // 3.3 Permis de conduire
              Text(
                '3.3 – Le permis de conduire',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Le permis de conduire est la clé d’accès à la liberté de circuler en véhicule motorisé, mais il constitue aussi un ',
                ),
                TextSpan(
                  text: 'instrument de police administrative',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                const TextSpan(
                  text:
                      ' permettant de sanctionner les comportements dangereux. Il peut être suspendu, retiré ou non délivré en cas d’infractions graves.',
                ),
              ]),
              const SizedBox(height: 8),

              Text(
                '3.3.1 – Rétention et suspension administrative par le préfet',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              const _Paragraph(
                'En cas d’infraction grave (conduite sous l’empire d’un état alcoolique, usage de stupéfiants, grand excès de vitesse, '
                'refus d’obtempérer, accident mortel ou ayant entraîné des blessures graves…), les forces de l’ordre peuvent retenir '
                'immédiatement le permis de conduire. Le préfet peut ensuite décider d’une suspension administrative pour une durée '
                'déterminée (souvent plusieurs mois).',
              ),
              const SizedBox(height: 6),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'La durée de suspension peut être portée à un an notamment en cas : d’atteinte involontaire à la vie, '
                      'd’atteinte involontaire à l’intégrité de la personne entraînant une incapacité totale de travail, '
                      'de refus d’obtempérer dans certaines conditions, de conduite sous l’empire d’un état alcoolique ou après usage de stupéfiants, '
                      'de refus de se soumettre aux vérifications, ou de délit de fuite.',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'La mesure peut également viser l’accompagnateur d’un élève conducteur lorsque les règles relatives à l’alcool ou aux stupéfiants ne sont pas respectées.',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Le préfet peut enfin interdire la délivrance du permis à une personne qui n’en est pas titulaire '
                      'mais a commis une infraction punie de suspension de permis (art. L. 224-7 du Code de la route).',
                ),
              ]),
              const SizedBox(height: 10),

              Text(
                '3.3.2 – Suspension, annulation et interdiction par le tribunal',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Indépendamment des pouvoirs du préfet, la juridiction pénale peut prononcer la suspension, l’annulation ou l’interdiction '
                      'de délivrance du permis de conduire. Il peut s’agir : ',
                ),
                TextSpan(
                  text:
                      'd’une peine principale, d’une peine complémentaire ou d’une peine alternative',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 6),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Peine principale : le Code pénal prévoit, pour certaines infractions, une suspension ou l’interdiction de conduire à la place de l’emprisonnement.',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Peine complémentaire : elle s’ajoute à la peine principale (emprisonnement, amende). Le juge doit la prononcer expressément s’il souhaite l’appliquer (art. 132-17 C.P.).',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Peine alternative (art. 131-6 C.P.) : la suspension du permis peut se substituer à la peine de prison, '
                      'pour une durée pouvant atteindre plusieurs années ; pour les contraventions de 5ᵉ classe, elle peut remplacer l’amende (art. 131-14 C.P.).',
                ),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                'Ces sanctions ont un impact direct sur la liberté d’aller et venir du conducteur, mais sont légitimées par l’objectif de sécurité routière. '
                'Elles sont strictement encadrées et motivées par les juridictions, sous le contrôle des voies de recours.',
              ),
            ],
          ),

          const SizedBox(height: 26),

          // ====================== SYNTHÈSE FINALE ======================
          _HypoCard(
            title:
                'Synthèse : lire la liberté d’aller et venir dans son ensemble',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: const [
              _Paragraph(
                'La liberté d’aller et venir irrigue une grande partie du droit public et du droit pénal : mouvements des personnes, '
                'séjour des étrangers, circulation routière, stationnement, délivrance et retrait du permis de conduire. '
                'Pour le policier, elle constitue à la fois une liberté à respecter et un cadre à connaître pour appliquer correctement les textes.',
              ),
              SizedBox(height: 8),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      'Toujours vérifier sur quel aspect on intervient : mouvement, séjour ou circulation (et permis).',
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      'S’assurer que la mesure envisagée (contrôle, rétention, éloignement, retrait de permis, évacuation…) est prévue par un texte, '
                      'nécessaire au regard des circonstances et strictement proportionnée au but recherché.',
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      'Garder en tête que toute atteinte excessive ou injustifiée à la liberté d’aller et venir pourra être sanctionnée par les juridictions, '
                      'et engager la responsabilité de l’État.',
                ),
              ]),
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
        margin: const EdgeInsets.only(bottom: 4),
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
        : const Color(0xFF1F1F1F).withValues(alpha: .92);

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
  const _BulletPoint.rich(this.spans);

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
  const _ExempleBox({required this.bodySpans});

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
    final Color titleColor = isDark ? Colors.white : const Color(0xFF5D4037);

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
