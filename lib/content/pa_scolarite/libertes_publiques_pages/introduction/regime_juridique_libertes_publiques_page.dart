import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ===================================================================
///  COP'IQ — LIBERTÉS PUBLIQUES
///
///  LE RÉGIME JURIDIQUE / LA RÉGLEMENTATION
///  ET L’AMÉNAGEMENT DES LIBERTÉS PUBLIQUES
///
///  CHAPITRE 1 : LES AUTORITÉS RÉGLEMENTANT LES LIBERTÉS PUBLIQUES
///    - 1.1 Compétence de principe & rôle du législateur
///    - 1.2 Rôle du pouvoir exécutif : pouvoir réglementaire
///      • Réglementation en période normale
///      • Réglementation en période exceptionnelle
///        (état de siège, article 16, état d’urgence, état d’urgence sanitaire,
///         théorie des circonstances exceptionnelles, plan Vigipirate)
///
///  CHAPITRE 2 : LES MOYENS DE RÉGLEMENTATION
///    - 2.1 Le régime répressif
///    - 2.2 Le régime préventif
///      • Autorisation préalable
///      • Déclaration préalable
///      • Interdiction préalable
/// ===================================================================
class PaRegimeJuridiqueLibertesPubliquesPage extends StatelessWidget {
  const PaRegimeJuridiqueLibertesPubliquesPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/libertes_publiques/introduction/regime_juridique';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    final Color background = isDark ? const Color(0xFF121212) : Colors.white;
    final Color cardColor = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF7F7F7);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF5D4037);
    final Color textColor = isDark ? Colors.white70 : const Color(0xFF424242);
    final Color accentColor = isDark
        ? const Color(0xFF5E35B1)
        : const Color(0xFF4527A0);
    final Color referenceColor = isDark
        ? const Color(0xFF90CAF9)
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
          'Régime juridique des libertés',
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
            'Le régime juridique ou la réglementation\n'
            'et l’aménagement des libertés publiques',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 6),
          const _Paragraph.rich([
            TextSpan(
              text:
                  'Il ne peut exister de liberté publique absolue : sans règles, la liberté se transforme en anarchie. '
                  'Le droit encadre donc l’exercice des libertés pour concilier protection des droits et maintien de l’ordre public. '
                  'La Déclaration de 1789 admet d’ailleurs des limites à la liberté de chacun, à condition qu’elles ne portent pas atteinte '
                  'à l’exercice de cette même liberté par les autres individus.',
            ),
          ]),
          const SizedBox(height: 16),
          const _NotaBox(
            title: 'Idée directrice',
            bodySpans: [
              TextSpan(
                text:
                    'Réglementer une liberté publique ne signifie pas la supprimer. Il s’agit de fixer des bornes juridiques pour que la liberté demeure la règle, '
                    'et que la restriction reste l’exception, strictement justifiée par l’intérêt général.',
              ),
            ],
          ),
          const SizedBox(height: 24),

          // =====================================================
          // CHAPITRE 1 — LES AUTORITÉS RÉGLEMENTANT LES LIBERTÉS
          // =====================================================
          _HypoCard(
            title:
                'Chapitre 1 — Les autorités réglementant les libertés publiques',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              const _Paragraph(
                'Deux grands acteurs interviennent pour encadrer les libertés publiques : '
                'le législateur (compétence de principe) et le pouvoir exécutif (pouvoir réglementaire).',
              ),
              const SizedBox(height: 14),

              // ---------- 1.1 LÉGISLATEUR ----------
              Text(
                '1.1 – La compétence de principe et le rôle du législateur',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              const _Paragraph.rich([
                TextSpan(
                  text:
                      'Traditionnellement, la loi est l’outil principal pour fixer le régime des libertés publiques. '
                      'La Déclaration de 1789 rappelle que seule la loi peut poser les "bornes" à l’exercice des droits. '
                      'La Constitution de 1958 confie au Parlement le soin de déterminer les règles concernant les droits civiques '
                      'et les garanties fondamentales accordées aux citoyens pour leur exercice (article 34). ',
                ),
                TextSpan(
                  text:
                      'Le législateur dispose donc d’une compétence de principe ',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text:
                      'en matière de libertés publiques, sous réserve du respect de la hiérarchie des normes (Constitution, traités, lois…).',
                ),
              ]),
              const SizedBox(height: 10),
              const _Paragraph('Concrètement, la loi peut :'),
              const SizedBox(height: 6),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Créer de nouvelles libertés reconnues au niveau législatif ou constitutionnel (ex. droit au respect de la vie privée, liberté de recourir à l’IVG).',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Définir les modalités d’exercice permettant aux citoyens de jouir effectivement de leurs droits (conditions pratiques, procédures, garanties).',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Restreindre l’exercice de libertés, y compris constitutionnelles, pour concilier plusieurs exigences de valeur identique '
                      '(ex. droit de grève et continuité du service public).',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Supprimer une liberté préexistante, mais uniquement sous contrôle du Conseil constitutionnel et pour des raisons impérieuses.',
                ),
              ]),
              const SizedBox(height: 8),
              const _Paragraph.rich([
                TextSpan(
                  text:
                      'En revanche, le législateur ne peut revenir sur une liberté publique déjà acquise que dans deux cas : ',
                ),
                TextSpan(
                  text:
                      'soit parce qu’elle n’a jamais été légalement consacrée, ',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text:
                      'soit parce que sa remise en cause est indispensable pour atteindre un objectif de valeur constitutionnelle '
                      '(sécurité, ordre public, continuité du service, etc.).',
                ),
              ]),
              const SizedBox(height: 12),
              const _ExempleBox(
                title: 'Exemples de lois marquantes',
                bodySpans: [
                  TextSpan(
                    text:
                        '• Loi du 17 juillet 1970 : renforce la protection de la vie privée (atteintes illicites punies, droit au respect du domicile…).\n',
                  ),
                  TextSpan(
                    text:
                        '• Loi du 8 mars 2024 : consacre la liberté de recourir à l’interruption volontaire de grossesse dans le respect du cadre constitutionnel.',
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // ---------- 1.2 POUVOIR EXÉCUTIF ----------
              Text(
                '1.2 – Le rôle du pouvoir exécutif : le pouvoir réglementaire',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              const _Paragraph.rich([
                TextSpan(
                  text:
                      'Si la loi fixe les principes fondamentaux, le pouvoir exécutif (gouvernement, préfet, maire…) est chargé de mettre en œuvre, '
                      'par des règlements, l’aménagement concret des libertés. '
                      'Ce pouvoir réglementaire s’exerce principalement dans deux hypothèses : ',
                ),
              ]),
              const SizedBox(height: 6),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Compléter la loi lorsque celle-ci renvoie à un décret ou à un règlement pour préciser les conditions d’exercice de la liberté '
                      '(ex. partie réglementaire du code de la route).',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Prendre, au plan national ou local, les mesures nécessaires au maintien de l’ordre public, '
                      'en conciliant la sécurité collective avec l’exercice des libertés (circulation, manifestations, ouverture de lieux recevant du public…).',
                ),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                'Le pouvoir réglementaire peut donc restreindre l’exercice d’une liberté, mais à condition de respecter les principes de légalité, de nécessité et de proportionnalité. '
                'Son intensité varie selon que l’on se trouve en période normale ou en période exceptionnelle.',
              ),
            ],
          ),

          const SizedBox(height: 26),

          // =====================================================
          // 1.2.1 / 1.2.2 — PÉRIODE NORMALE & EXCEPTIONNELLE
          // =====================================================
          _HypoCard(
            title:
                '1.2.1 – Réglementation en période normale\n1.2.2 – Réglementation en période exceptionnelle',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              // ------- PÉRIODE NORMALE -------
              Text(
                'A. Exercices des pouvoirs en période normale',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              const _Paragraph(
                'En période ordinaire, la réglementation des libertés doit rester mesurée. '
                'Deux règles classiques gouvernent l’action de l’autorité administrative :',
              ),
              const SizedBox(height: 6),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'L’autorité ne peut interdire de manière générale et absolue l’exercice d’une liberté publique. '
                      'Toute interdiction doit être limitée dans le temps, l’espace et l’objet.',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Toute mesure d’interdiction doit être indispensable au maintien de l’ordre public, '
                      'et motivée par des circonstances précises et établies.',
                ),
              ]),
              const SizedBox(height: 8),
              const _Paragraph(
                'Plus une liberté est regardée comme fondamentale (liberté d’aller et venir, de réunion, d’expression…), '
                'plus le juge administratif contrôle strictement la proportionnalité des restrictions décidées par l’exécutif.',
              ),
              const SizedBox(height: 14),

              // ------- PÉRIODE EXCEPTIONNELLE -------
              Text(
                'B. Réglementation en période exceptionnelle',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              const _Paragraph.rich([
                TextSpan(
                  text:
                      'Lorsque la survie des institutions, l’indépendance de la Nation ou la sécurité intérieure sont gravement menacées, '
                      'le droit prévoit des régimes d’exception permettant un renforcement temporaire des pouvoirs de l’exécutif. '
                      'Ces régimes demeurent encadrés par la Constitution et contrôlés par le juge. ',
                ),
              ]),
              const SizedBox(height: 10),

              // -- ÉTAT DE SIÈGE --
              Text(
                '1) L’état de siège',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              const _Paragraph(
                'Issu d’une loi du XIXᵉ siècle et désormais prévu par la Constitution, l’état de siège est proclamé '
                'en cas de péril résultant d’une guerre étrangère ou d’une insurrection armée. '
                'Il entraîne le transfert de certaines compétences de police à l’autorité militaire et autorise des mesures restrictives importantes '
                '(perquisitions de nuit, contrôle des publications, interdiction de réunions…). Sa prolongation au-delà d’une certaine durée suppose l’intervention du Parlement.',
              ),
              const SizedBox(height: 10),

              // -- ARTICLE 16 (ÉTAT DE CRISE) --
              Text(
                '2) L’état de crise (article 16 de la Constitution)',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              const _Paragraph(
                'Lorsque les institutions de la République, l’indépendance de la Nation ou l’intégrité du territoire sont gravement et immédiatement menacées, '
                'et que le fonctionnement régulier des pouvoirs publics est interrompu, le Président de la République peut mettre en œuvre les pouvoirs exceptionnels prévus à l’article 16. '
                'Après consultation de plusieurs autorités (Premier ministre, présidents des Assemblées, Conseil constitutionnel), il concentre temporairement la plénitude des pouvoirs exécutifs et réglementaires, '
                'sous le contrôle du Conseil constitutionnel et de l’opinion publique.',
              ),
              const SizedBox(height: 10),

              // -- ÉTAT D’URGENCE --
              Text(
                '3) L’état d’urgence',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              const _Paragraph.rich([
                TextSpan(
                  text:
                      'Créé en 1955 et plusieurs fois modifié, ce régime permet de faire face à des situations de péril imminent résultant d’atteintes graves à l’ordre public '
                      'ou de calamités publiques. Il autorise notamment l’assignation à résidence, les perquisitions administratives, les interdictions de réunions ou de '
                      'manifestations, ainsi que des mesures renforcées de contrôle d’identité. ',
                ),
                TextSpan(
                  text:
                      'Les lois adoptées à la suite des attentats récents ont étendu ces prérogatives, notamment en matière de lutte antiterroriste.',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ]),
              const SizedBox(height: 10),

              // -- ÉTAT D’URGENCE SANITAIRE --
              Text(
                '4) L’état d’urgence sanitaire',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              const _Paragraph(
                'Institué pour faire face à la pandémie de Covid-19, ce régime permet au gouvernement de prendre des mesures exceptionnelles '
                'pour lutter contre une catastrophe sanitaire : restrictions de déplacements, fermetures d’établissements recevant du public, limitation des rassemblements, '
                'fixation de plafonds de prix pour certains produits, etc. Il illustre la manière dont l’exécutif peut, sous contrôle du Parlement et du juge, '
                'adapter l’étendue des libertés en fonction d’un risque sanitaire majeur.',
              ),
              const SizedBox(height: 10),

              // -- THÉORIE DES CIRCONSTANCES EXCEPTIONNELLES --
              Text(
                '5) La théorie des circonstances exceptionnelles',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              const _Paragraph(
                'Élaborée par la jurisprudence administrative, cette théorie permet au juge d’admettre que, dans des circonstances anormales '
                '(guerre, troubles graves, catastrophes…), l’administration puisse disposer de pouvoirs plus étendus que ceux prévus en temps normal, '
                'afin d’assurer la continuité du service public et la sauvegarde de l’ordre. '
                'En contrepartie, ces mesures restent contrôlées a posteriori par le juge, qui vérifie que les circonstances invoquées justifiaient réellement '
                'la restriction des libertés.',
              ),
              const SizedBox(height: 10),

              // -- PLAN VIGIPIRATE --
              Text(
                '6) Une mesure intermédiaire : le plan Vigipirate',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              const _Paragraph(
                'Le plan Vigipirate est un dispositif gouvernemental permanent, associant autorités civiles et militaires, visant à prévenir la menace terroriste. '
                'Il repose sur différents niveaux d’alerte et permet de déclencher, sans basculer dans un régime d’exception formel, '
                'un ensemble de mesures graduées de protection de la population et des infrastructures sensibles.',
              ),
              const SizedBox(height: 8),
              const _Paragraph(
                'Objectifs principaux : assurer en permanence une protection adaptée du territoire, développer la culture de vigilance de l’ensemble des acteurs, '
                'et permettre une réaction rapide et coordonnée en cas de menace identifiée.',
              ),
              const SizedBox(height: 8),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Niveau « vigilance » : renforcement ponctuel face à une menace localisée ou à une vulnérabilité particulière.',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Niveau « sécurité renforcée – risque attentat » : activation de mesures complémentaires pour une menace élevée.',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Niveau « urgence attentat » : déclenché après un attentat ou en cas de menace imminente liée à un groupe terroriste identifié.',
                ),
              ]),
              const SizedBox(height: 6),
              const _NotaBox(
                title: 'Attention',
                bodySpans: [
                  TextSpan(
                    text:
                        'Même en période exceptionnelle, les mesures prises restent soumises au contrôle du juge et doivent cesser dès que redevient possible un fonctionnement normal des institutions.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 26),

          // =====================================================
          // CHAPITRE 2 — MOYENS DE RÉGLEMENTATION
          // =====================================================
          _HypoCard(
            title:
                'Chapitre 2 — Les moyens de réglementation :\nL’aménagement des libertés publiques',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              const _Paragraph(
                'Aménager une liberté publique, c’est fixer les limites de son exercice. '
                'En régime démocratique, deux techniques se partagent cette fonction : le régime répressif et le régime préventif.',
              ),
              const SizedBox(height: 16),

              // ---------- 2.1 RÉGIME RÉPRESSIF ----------
              Text(
                '2.1 – Le régime répressif',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Contrairement à ce que son nom pourrait laisser penser, le régime répressif est en réalité le plus favorable aux libertés publiques. '
                      'Le principe est simple : ',
                ),
                TextSpan(
                  text:
                      'la liberté est la règle, la sanction n’intervient qu’en cas d’abus caractérisé.',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
              ]),
              const SizedBox(height: 6),
              const _Paragraph(
                'Abuse de sa liberté celui qui commet une infraction prévue par la loi (délit de presse, provocation à la haine, atteintes à la vie privée, etc.) '
                'ou qui trouble gravement l’ordre public. La sanction est alors prononcée par le juge, à l’issue d’une procédure contradictoire, '
                'sur le fondement des textes pénaux ou administratifs applicables.',
              ),
              const SizedBox(height: 10),
              const _NotaBox(
                title: 'Point clef',
                bodySpans: [
                  TextSpan(
                    text:
                        'Dans le régime répressif, l’autorité publique n’empêche pas a priori l’exercice de la liberté : le citoyen est libre d’agir, '
                        'mais il engage sa responsabilité s’il dépasse les limites fixées par la loi.',
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // ---------- 2.2 RÉGIME PRÉVENTIF ----------
              Text(
                '2.2 – Le régime préventif',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'À la différence du régime répressif, le régime préventif intervient en amont : il vise à éviter les troubles avant qu’ils ne se produisent. '
                      'Selon une formule classique, ',
                ),
                TextSpan(
                  text:
                      '« n’est permis que ce qui est autorisé expressément ou tacitement ».',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: referenceColor,
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              const _Paragraph(
                'Ce régime repose sur l’action du pouvoir exécutif, responsable de l’ordre public. '
                'Trois techniques principales sont utilisées : l’autorisation préalable, la déclaration préalable et l’interdiction préalable.',
              ),
              const SizedBox(height: 12),

              // ------ 2.2.1 Autorisation préalable ------
              Text(
                '2.2.1 – L’autorisation préalable',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              const _Paragraph(
                'Certaines activités ne peuvent être exercées que si l’autorité administrative a donné son accord à l’avance. '
                'À défaut d’autorisation, la liberté ne peut s’exercer licitement.',
              ),
              const SizedBox(height: 6),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Visa d’exploitation cinématographique délivré par le ministre de la Culture pour la diffusion d’un film ;',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(text: 'Permis de construire ;'),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Permis de conduire, soumis à des conditions de capacité et d’aptitude ;',
                ),
              ]),
              const SizedBox(height: 6),
              const _Paragraph(
                'L’administration peut disposer d’un pouvoir d’appréciation plus ou moins large. '
                'Le juge administratif contrôle que le refus d’autorisation repose sur des motifs légaux, proportionnés et exempts d’erreur manifeste.',
              ),
              const SizedBox(height: 12),

              // ------ 2.2.2 Déclaration préalable ------
              Text(
                '2.2.2 – La déclaration préalable',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              const _Paragraph(
                'Dans ce régime, la liberté peut s’exercer, mais son titulaire doit informer préalablement l’autorité administrative, '
                'qui enregistre la déclaration et peut éventuellement prendre des mesures d’encadrement.',
              ),
              const SizedBox(height: 6),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Déclaration en préfecture pour l’organisation d’une manifestation sur la voie publique ;',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Information de l’employeur pour l’exercice du droit de grève ;',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Déclaration auprès du parquet pour la création d’un journal ou d’une publication périodique.',
                ),
              ]),
              const SizedBox(height: 6),
              const _Paragraph.rich([
                TextSpan(
                  text:
                      'L’omission de la déclaration peut entraîner des sanctions pénales ou administratives. '
                      'Elle ne supprime pas la liberté en elle-même, mais expose celui qui l’exerce à un risque juridique accru. ',
                ),
              ]),
              const SizedBox(height: 12),

              // ------ 2.2.3 Interdiction préalable ------
              Text(
                '2.2.3 – L’interdiction préalable',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                  color: dangerColor,
                ),
              ),
              const SizedBox(height: 4),
              const _Paragraph.rich([
                TextSpan(
                  text:
                      'Technique la plus attentatoire aux libertés, l’interdiction préalable permet à l’autorité administrative de prohiber, avant qu’elle ne se réalise, '
                      'une activité jugée dangereuse pour l’ordre public. ',
                ),
                TextSpan(
                  text:
                      'Elle doit rester l’ultime recours, strictement encadré par le juge.',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ]),
              const SizedBox(height: 6),
              Text(
                'a) Au titre de polices spéciales',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              const _Paragraph(
                'Certains textes prévoient explicitement la possibilité d’interdire l’exercice d’une liberté particulière : '
                'interdiction de manifester sur la voie publique en cas de risque manifeste de troubles graves, dissolution d’associations représentant une menace pour l’ordre public, etc.',
              ),
              const SizedBox(height: 8),
              Text(
                'b) Au titre de la police générale',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              const _Paragraph(
                'En dehors de tout texte spécial, le maire ou le préfet peuvent interdire une manifestation ou une réunion lorsqu’il apparaît qu’aucune autre mesure '
                'ne permet de prévenir un trouble grave à l’ordre public. Dans les communes à police étatisée, le préfet détient seul ce pouvoir pour les manifestations.',
              ),
              const SizedBox(height: 8),
              const _Paragraph(
                'Le juge administratif contrôle : la compétence de l’auteur de la décision, la forme de l’acte, le but poursuivi, les motifs invoqués et l’examen complet des circonstances. '
                'Ce contrôle est particulièrement approfondi lorsque sont en cause des libertés fondamentales (réunion, association, circulation…).',
              ),
              const SizedBox(height: 10),
              const _ExempleBox(
                title: 'Arrêt Benjamin (Conseil d’État, 1933)',
                bodySpans: [
                  TextSpan(
                    text:
                        'Le maire de Nevers avait interdit une conférence littéraire, invoquant le risque de troubles lors d’une manifestation d’opposition. '
                        'Le Conseil d’État annule l’interdiction : il estime qu’il existait d’autres moyens moins radicaux pour assurer l’ordre public (mobilisation de forces de police), '
                        'sans empêcher la réunion elle-même. Cet arrêt consacre le principe selon lequel l’interdiction d’une liberté ne peut être décidée que si aucune mesure moins restrictive '
                        'n’est suffisante pour prévenir le trouble.',
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
  const _NotaBox({required this.bodySpans, this.title = 'Nota bene'});

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
