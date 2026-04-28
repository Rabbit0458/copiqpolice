import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ===================================================================
///  COP'IQ — LE RÉGIME DES MANIFESTATIONS
///
///  - Définition et principe général
///  - Chapitre 1 : La réglementation de la manifestation
///       1.1 Déclaration préalable
///       1.2 Interdiction d’une manifestation
///  - Chapitre 2 : Les sanctions applicables
///       2.1 Non-respect de la déclaration ou de l’interdiction
///       2.2 Infractions commises lors d’une manifestation
///       2.3 Peines complémentaires
///       2.4 Mesures préventives
///  - Chapitre 3 : Réparation des dommages causés
/// ===================================================================
class RegimeManifestationsPage extends StatelessWidget {
  const RegimeManifestationsPage({super.key});

  static const String routeName =
      '/gpx/generalites/libertes_publiques/collectives/regime_manifestations';

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
        ? const Color(0xFF1976D2)
        : const Color(0xFF1565C0);
    final Color referenceColor = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);

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
          'Le régime des manifestations',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: titleColor,
          ),
        ),
      ),

      // ===================== CONTENU =====================
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        physics: const BouncingScrollPhysics(),
        children: [
          // ================= TITRE + INTRO =================
          Text(
            'Le régime juridique des manifestations\n'
            '(articles L.211-1 et s. du Code de la sécurité intérieure)',
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
                  'La manifestation est un mode collectif d’exercice de la liberté d’expression. '
                  'Il n’existe pas de définition unique dans les textes, mais on désigne généralement '
                  'par manifestation toute occupation momentanée de la voie publique par un rassemblement '
                  'statique ou mobile (cortège), à caractère revendicatif, festif ou protestataire. ',
            ),
            TextSpan(
              text:
                  'Cette liberté est reconnue comme principe à valeur constitutionnelle, mais elle doit se concilier avec la sauvegarde de l’ordre public.',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: referenceColor,
              ),
            ),
          ]),
          const SizedBox(height: 8),
          _Paragraph(
            'Dans un régime démocratique, le droit de manifester est admis, mais encadré : '
            'déclaration préalable, pouvoir d’interdiction en cas de risque grave pour l’ordre public, '
            'responsabilité pénale des organisateurs et des participants en cas d’infractions.',
          ),
          const SizedBox(height: 16),
          _NotaBox(
            title: 'Référence centrale',
            bodySpans: [
              TextSpan(
                text:
                    'Le régime des manifestations sur la voie publique est organisé principalement par les '
                    'articles L.211-1 à L.211-10 du Code de la sécurité intérieure (C.S.I.), complétés par '
                    'de nombreuses dispositions du Code pénal et du Code de procédure pénale.',
              ),
            ],
          ),
          const SizedBox(height: 22),

          // =====================================================
          // CHAPITRE 1 — RÉGLEMENTATION
          // =====================================================
          Text(
            'Chapitre 1 — La réglementation de la manifestation',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 17,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 14),

          // ------------------ 1.1 DÉCLARATION ------------------
          _HypoCard(
            title: '1.1  La déclaration préalable',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'L’article L.211-1 du C.S.I. pose le principe : « Sont soumis à l’obligation d’une déclaration préalable '
                      'tous cortèges, défilés et rassemblements de personnes sur la voie publique », ',
                ),
                TextSpan(
                  text:
                      'à l’exception notamment des manifestations traditionnelles à caractère folklorique ou religieux.',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: referenceColor,
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph(
                'La déclaration permet à l’autorité de police d’évaluer le risque de troubles à l’ordre public et '
                'd’adapter le dispositif (itinéraire, forces engagées, restrictions éventuelles).',
              ),
              const SizedBox(height: 12),

              Text(
                '→ Lieu de la déclaration',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'À Paris : la déclaration est déposée à la préfecture de police.',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Dans les villes où la police est étatisée : la déclaration est faite à la préfecture ou à la sous-préfecture.',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Dans les autres communes : la déclaration est déposée à la mairie. '
                      'Si la manifestation traverse plusieurs communes, chacune des mairies concernées doit être saisie.',
                ),
              ]),
              const SizedBox(height: 10),

              Text(
                '→ Délai à respecter',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'La déclaration doit parvenir au moins trois jours francs avant la manifestation et au plus quinze jours francs avant la date prévue.',
                ),
              ]),
              const SizedBox(height: 10),

              Text(
                '→ Contenu de la déclaration',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Identité des organisateurs (noms, prénoms, domiciles) avec au minimum un signataire.',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Objet de la manifestation (revendications, thème, nature).',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Lieu du rassemblement, date, heure de départ, durée approximative et, le cas échéant, itinéraire détaillé.',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Signature des organisateurs ; un récépissé de déclaration doit être délivré immédiatement.',
                ),
              ]),
              const SizedBox(height: 12),

              const _NotaBox(
                title: 'Rigueur accrue en période exceptionnelle',
                bodySpans: [
                  TextSpan(
                    text:
                        'En cas d’état de siège, d’état d’urgence ou de mise en œuvre de l’article 16 de la Constitution, '
                        'les pouvoirs de police peuvent être très largement renforcés : interdictions générales, '
                        'couvre-feux, restrictions de circulation, etc.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ------------------ 1.2 INTERDICTION ------------------
          _HypoCard(
            title: '1.2  L’interdiction d’une manifestation',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'L’article L.211-4 du C.S.I. permet à l’autorité investie des pouvoirs de police '
                      '(préfet, ou maire dans certaines communes) d’interdire une manifestation déclarée ',
                ),
                TextSpan(
                  text:
                      'lorsqu’elle est de nature à troubler gravement l’ordre public et qu’aucune autre mesure moins restrictive ne permet d’éviter le trouble.',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: referenceColor,
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph(
                'L’interdiction prend la forme d’un arrêté motivé, notifié aux organisateurs par un officier de police judiciaire '
                'ou par tout autre agent mandaté. Si la notification individuelle est impossible, la décision est rendue publique « par tous moyens ». ',
              ),
              const SizedBox(height: 10),

              Text(
                'Contrôle préfectoral et contentieux',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Lorsque l’interdiction est décidée par le maire dans une zone de police non étatisée, '
                      'l’arrêté doit être transmis au préfet dans les 24 heures.',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Si le préfet estime que l’interdiction n’est pas justifiée, il peut saisir le tribunal administratif '
                      'et demander la suspension de l’arrêté par la procédure du sursis à exécution.',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'À l’inverse, si le maire refuse d’interdire une manifestation alors que les troubles sont manifestement prévisibles, '
                      'le préfet peut se substituer à lui et prendre lui-même l’arrêté d’interdiction.',
                ),
              ]),
              const SizedBox(height: 10),

              Text(
                'Conditions de légalité de l’interdiction',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Existence d’un danger réel de troubles graves à l’ordre public directement liés à la manifestation projetée.',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Absence d’un autre moyen efficace (modification du parcours, horaires, renforcement du dispositif policier…) pour maintenir l’ordre public.',
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph(
                'L’arrêté d’interdiction peut faire l’objet d’un recours en référé devant le tribunal administratif, '
                'qui vérifie la réalité du risque, la nécessité et la proportionnalité de la mesure.',
              ),
            ],
          ),

          const SizedBox(height: 26),

          // =====================================================
          // CHAPITRE 2 — SANCTIONS
          // =====================================================
          Text(
            'Chapitre 2 — Les sanctions applicables',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 17,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 14),

          // ------------------ 2.1 NON-RESPECT DECLARATION --------
          _HypoCard(
            title:
                '2.1  Non-respect de la déclaration préalable\n     ou de l’interdiction de manifester',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              Text(
                '2.1.1  Article 431-9 du Code pénal',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Est puni de 6 mois d’emprisonnement et 7 500 € d’amende le fait :',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'd’avoir organisé une manifestation sur la voie publique n’ayant pas fait l’objet d’une déclaration préalable ;',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'd’avoir organisé une manifestation sur la voie publique malgré une interdiction régulièrement notifiée ;',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'd’avoir présenté une déclaration incomplète ou inexacte destinée à tromper l’autorité sur l’objet ou les conditions de la manifestation.',
                ),
              ]),
              const SizedBox(height: 10),
              Text(
                '2.1.2  Article R.644-4 du Code pénal',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'La participation à une manifestation interdite sur le fondement de l’article L.211-4 du C.S.I. '
                      'est punie de l’amende prévue pour les contraventions de 4ᵉ classe.',
                ),
              ]),
              const SizedBox(height: 8),
              _NotaBox(
                title: 'Contrôles d’identité',
                bodySpans: [
                  TextSpan(
                    text:
                        'Sur le fondement de l’article 78-2 alinéa 8 du Code de procédure pénale, des contrôles d’identité peuvent être réalisés '
                        'aux abords des manifestations pour prévenir les atteintes aux personnes et aux biens, '
                        'notamment en cas de risque avéré de violences.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ------------------ 2.2 INFRACTIONS LORS MANIF --------
          _HypoCard(
            title:
                '2.2  Infractions pouvant être retenues\n     lors d’une manifestation',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              Text(
                '2.2.1  Port d’arme (article 431-10 C.P.)',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Le fait de participer à une manifestation ou à une réunion publique en étant porteur d’une arme '
                      'constitue un délit puni de 3 ans d’emprisonnement et 45 000 € d’amende.',
                ),
              ]),
              const SizedBox(height: 12),

              Text(
                '2.2.2  Dissimulation illicite du visage (article 431-9-1 C.P.)',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph(
                'Est puni d’un an d’emprisonnement et de 15 000 € d’amende le fait, sans motif légitime, '
                'de dissimuler volontairement tout ou partie de son visage lors d’une manifestation sur la voie publique '
                'ou à ses abords immédiats, dans des circonstances faisant craindre des atteintes à l’ordre public et '
                'en vue d’échapper à son identification.',
              ),
              const SizedBox(height: 6),
              _Paragraph(
                'Une contravention de 5ᵉ classe (art. R.645-14 C.P.) sanctionne des faits proches lorsque l’atteinte à l’ordre public est moins grave. '
                'L’infraction n’est pas constituée quand la dissimulation répond à un usage légitime (ex. carnaval traditionnel).',
              ),
              const SizedBox(height: 12),

              Text(
                '2.2.3  Outrage public à l’hymne national ou au drapeau tricolore (article 433-5-1 C.P.)',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Le fait d’outrager publiquement l’hymne national ou le drapeau tricolore est puni de 7 500 € d’amende ; '
                      'lorsque l’outrage est commis en réunion, la peine peut être portée à 6 mois d’emprisonnement et 7 500 € d’amende.',
                ),
              ]),
            ],
          ),

          const SizedBox(height: 24),

          // ------------------ 2.3 PEINES COMPLÉMENTAIRES --------
          _HypoCard(
            title:
                '2.3  Peines complémentaires\n     relatives aux manifestations',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              Text(
                '2.3.1  Interdiction de manifester (article 131-32-1 C.P.)',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph(
                'Le juge peut prononcer, en peine complémentaire, une interdiction de participer à des manifestations sur la voie publique '
                'pour une durée maximale de 3 ans lorsque certains délits ont été commis à cette occasion (violences, destructions, '
                'dégradations, infractions prévues aux articles 431-9, 431-9-1, 431-10 C.P., etc.).',
              ),
              const SizedBox(height: 10),

              Text(
                '2.3.2  Interdiction de droits civiques, civils et de famille',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Pour certains délits commis lors de manifestations, le juge peut également prononcer des interdictions '
                      'de droits civiques (droit de vote, d’éligibilité…), des interdictions professionnelles ou de séjour.',
                ),
              ]),
              const SizedBox(height: 10),

              Text(
                '2.3.3  Interdiction du territoire français (article L.211-14 C.S.I.)',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'À l’encontre d’un étranger condamné pour certaines infractions commises lors de manifestations, '
                      'le juge peut prononcer une interdiction du territoire français pour une durée pouvant aller jusqu’à 3 ans ou plus, '
                      'selon la gravité des faits.',
                ),
              ]),
            ],
          ),

          const SizedBox(height: 24),

          // ------------------ 2.4 MESURES PRÉVENTIVES --------
          _HypoCard(
            title: '2.4  Mesures préventives autour des manifestations',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              Text(
                '2.4.1  Interdiction de porter tout objet pouvant constituer une arme',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph(
                'L’article L.211-3 C.S.I. permet, lorsqu’il existe des risques sérieux de troubles graves à l’ordre public, '
                'd’interdire temporairement, dans un périmètre déterminé (lieux de la manifestation et abords), '
                'le port et le transport, sans motif légitime, d’objets pouvant constituer une arme par destination.',
              ),
              const SizedBox(height: 12),

              Text(
                '2.4.2  Contrôle des personnes',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph(
                'Pour prévenir les atteintes à la sécurité des personnes et des biens, l’O.P.J. peut, '
                'sous le contrôle du procureur de la République, mettre en œuvre des contrôles aux abords '
                'des manifestations (articles 78-2 et 78-2-3 C.P.P.), dans des zones et pour une durée limités.',
              ),
              const SizedBox(height: 12),

              Text(
                '2.4.3  Réquisitions pour fouilles de bagages / visites de véhicules',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph(
                'L’article 78-2-5 C.P.P. autorise le procureur de la République à délivrer des réquisitions '
                'permettant de contrôler les bagages et les véhicules situés sur les lieux d’une manifestation ou à ses abords immédiats, '
                'afin de rechercher les infractions, notamment le port d’armes lors d’une réunion publique.',
              ),
              const SizedBox(height: 12),

              Text(
                '2.4.4  Détention ou transport de substances ou produits explosifs',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph(
                'L’article 322-11-1 C.P. réprime la détention ou le transport de substances ou produits '
                'incendiaires ou explosifs destinés à préparer des atteintes graves aux personnes ou aux biens '
                'à l’occasion d’une manifestation. La peine peut aller jusqu’à 7 ans d’emprisonnement et 100 000 € d’amende, '
                'aggravée en cas de bande organisée ou de régime particulier.',
              ),
            ],
          ),

          const SizedBox(height: 26),

          // =====================================================
          // CHAPITRE 3 — RÉPARATION
          // =====================================================
          Text(
            'Chapitre 3 — Réparation des dommages causés\nau cours des manifestations',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 17,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 14),

          _HypoCard(
            title: 'Responsabilité de l’État (article L.211-10 C.S.I.)',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'L’article L.211-10 du C.S.I. prévoit que l’État est civilement responsable des dégâts et dommages '
                      'résultant des crimes et délits commis à force ouverte ou par violence lors des manifestations ou rassemblements, '
                      'armés ou non armés, qu’ils visent les personnes ou les biens. ',
                ),
                TextSpan(
                  text: 'Il s’agit d’une responsabilité de plein droit.',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph(
                'Les victimes peuvent demander réparation devant la juridiction civile. '
                'L’État peut ensuite exercer une action récursoire contre les auteurs identifiés des infractions. '
                'La commune peut également être mise en cause lorsque sa responsabilité propre est engagée.',
              ),
              const SizedBox(height: 10),
              const _NotaBox(
                title: 'Intérêt opérationnel pour les forces de l’ordre',
                bodySpans: [
                  TextSpan(
                    text:
                        'Chaque fois que des dégradations importantes sont commises lors d’une manifestation, '
                        'la qualité des constatations (photographies, vidéos, auditions, procès-verbaux détaillés) est déterminante '
                        'pour permettre à l’État d’engager une action récursoire contre les auteurs et de limiter le coût pour la collectivité.',
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
/// BLOC EXEMPLE (non utilisé ici mais dispo si tu veux en rajouter)
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
