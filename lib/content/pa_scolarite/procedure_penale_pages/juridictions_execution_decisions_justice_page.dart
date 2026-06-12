import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaJuridictionsExecutionDecisionsJusticePage extends StatelessWidget {
  const PaJuridictionsExecutionDecisionsJusticePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/procedure_penale/juridictions_execution_decisions_justice';

  // Helpers pour articles en rouge
  TextSpan _cpp(String text) {
    return TextSpan(
      text: text,
      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
    );
  }

  TextSpan _cp(String text) {
    return TextSpan(
      text: text,
      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
    );
  }

  TextSpan _cr(String text) {
    return TextSpan(
      text: text,
      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
    );
  }

  TextSpan _autreCode(String text) {
    return TextSpan(
      text: text,
      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text("Exécution des décisions de justice")),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Version au 01/07/2025  © COPIQ',
                  style: GoogleFonts.fustat(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? Colors.white60
                        : const Color(0xFF424242).withValues(alpha: .85),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 14),

              ////////////////////////////////////////////////////////////
              /// INTRO GÉNÉRALE – EXÉCUTION DES DÉCISIONS DE JUSTICE
              ////////////////////////////////////////////////////////////
              _ConditionCard(
                title: "L'exécution des décisions de justice",
                cardColor: isDark
                    ? const Color(0xFF111820)
                    : const Color(0xFFE3F2FD),
                accent: const Color(0xFF1565C0),
                titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
                children: [
                  const _SubTitle('Introduction'),
                  const _Paragraph.rich([
                    TextSpan(
                      text:
                          "La loi n° 2019-222 du 23 mars 2019 de programmation 2018-2022 "
                          "et de réforme pour la justice a refondé le droit de la peine, "
                          "afin de rendre son application plus lisible et plus efficace, "
                          "en favorisant sa mise à exécution rapide dans le respect du "
                          "principe d'individualisation des peines.",
                    ),
                  ]),
                  const SizedBox(height: 6),
                  const _Paragraph.rich([
                    TextSpan(
                      text:
                          "La loi n° 2012-409 du 27 mars 2012 relative à l'exécution des "
                          "peines a apporté plusieurs dispositions de procédure pénale "
                          "visant à garantir l'effectivité de l'exécution des peines, "
                          "renforcer les dispositifs de prévention de la récidive et "
                          "améliorer la prise en charge des mineurs délinquants.",
                    ),
                  ]),
                  const SizedBox(height: 6),
                  const _Paragraph.rich([
                    TextSpan(
                      text:
                          "La loi portant adaptation de la justice aux évolutions de la "
                          "criminalité du 9 mars 2004 a apporté de nouvelles modifications "
                          "substantielles au droit de l'application des peines, "
                          "complétant la réforme entamée en 2000 et poursuivant le "
                          "mouvement de juridictionnalisation des peines, notamment par "
                          "l’abandon définitif de la notion de mesures d'administration "
                          "judiciaire.",
                    ),
                  ]),
                  const SizedBox(height: 10),
                  const _Paragraph.rich([
                    TextSpan(
                      text:
                          "Selon les termes de la loi, le procureur de la République "
                          "poursuit l'exécution des peines privatives de liberté et de "
                          "certaines peines de substitution ainsi que des peines "
                          "complémentaires. Mais l’exécution des peines relève de plus en "
                          "plus du juge de l'application des peines, qui gère notamment "
                          "les modalités d'application de la peine.",
                    ),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          "Le juge intervient de plus en plus dans l'exécution des "
                          "décisions de justice, par exemple pour le retrait de la "
                          "semi-liberté ou du placement à l'extérieur accordé par jugement (",
                    ),
                    _cpp("Article 723-2 du Code de procédure pénale"),
                    const TextSpan(text: ")."),
                  ]),
                  const SizedBox(height: 6),
                  const _Paragraph.rich([
                    TextSpan(
                      text:
                          "Pour les peines privatives de liberté, l'individualisation de la "
                          "peine doit permettre le retour progressif du condamné à la "
                          "liberté, mais également éviter une remise en liberté sans "
                          "aucune forme de suivi judiciaire.",
                    ),
                  ]),
                  const SizedBox(height: 6),
                  const _Paragraph.rich([
                    TextSpan(
                      text:
                          "Pour les peines pécuniaires, le législateur a prévu le système "
                          "de la contrainte judiciaire afin de garantir l'exécution des "
                          "amendes et autres condamnations pécuniaires.",
                    ),
                  ]),
                ],
              ),
              const SizedBox(height: 18),

              ////////////////////////////////////////////////
              /// CHAPITRE 1 – EXÉCUTION DES PEINES
              ////////////////////////////////////////////////
              _ConditionCard(
                title:
                    "Chapitre 1 : L'exécution des peines – principes généraux",
                cardColor: isDark
                    ? const Color(0xFF101318)
                    : const Color(0xFFE8EAF6),
                accent: const Color(0xFF1A237E),
                titleColor: isDark ? Colors.white : const Color(0xFF1A237E),
                children: [
                  const _SubTitle('1.1 - Les parties intervenantes'),
                  const _Paragraph.rich([
                    TextSpan(
                      text:
                          "L’Article 707-1 alinéa 1 du Code de procédure pénale dispose : "
                          "« Le ministère public et les parties poursuivent l'exécution de "
                          "la sentence, chacun en ce qui le concerne ».",
                    ),
                  ]),
                  const SizedBox(height: 8),

                  const _SubTitle('1.1.1 - La partie civile'),
                  const _Paragraph(
                    "La partie civile obtient en principe réparation sous la forme du "
                    "versement de dommages et intérêts, mais elle peut aussi bénéficier "
                    "d’autres formes de réparation (publication de la décision, remise en "
                    "état du bien, etc.).",
                  ),
                  const SizedBox(height: 6),
                  const _Paragraph(
                    "Elle a seule qualité pour faire exécuter les condamnations prononcées "
                    "à son profit par les voies civiles (saisies, mesures d’exécution sur "
                    "les biens du débiteur).",
                  ),
                  const SizedBox(height: 8),

                  const _SubTitle('1.1.2 - Les administrations'),
                  const _Paragraph(
                    "Certaines administrations représentant l’État poursuivent l’exécution "
                    "de certaines peines ou sanctions.",
                  ),
                  const SizedBox(height: 6),
                  const _BulletPoint(
                    text:
                        "Administration des impôts : recouvrement des amendes à caractère "
                        "fiscal et des confiscations ayant le caractère d’une peine et "
                        "d’une indemnité au profit du Trésor.",
                  ),
                  const _BulletPoint(
                    text:
                        "Administration des douanes : exécution des sanctions d’ordre "
                        "pécuniaire prononcées suite à des infractions douanières.",
                  ),
                  const SizedBox(height: 6),
                  const _Paragraph.rich([
                    TextSpan(
                      text:
                          "Elles disposent notamment d’un droit de transaction qu’elles "
                          "peuvent exercer avant ou après jugement.",
                    ),
                  ]),

                  const SizedBox(height: 8),
                  const _SubTitle('1.1.3 - Le ministère public'),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          "C’est au ministère public qu’il appartient essentiellement "
                          "d’assurer l’exécution des sanctions pénales. L’",
                    ),
                    _cpp("Article 707-1 du Code de procédure pénale"),
                    const TextSpan(
                      text:
                          " précise son rôle dans l’exécution des peines de toutes natures.",
                    ),
                  ]),
                  const SizedBox(height: 6),
                  const _Paragraph.rich([TextSpan(text: "Il : ")]),
                  const SizedBox(height: 4),
                  const _BulletPoint(
                    text:
                        "fait exécuter toutes les peines privatives de liberté ;",
                  ),
                  _BulletPoint.rich([
                    const TextSpan(
                      text:
                          "fait exécuter les peines prévues aux articles 131-1 à 131-49 du ",
                    ),
                    _cp("Code pénal"),
                    const TextSpan(
                      text:
                          " (peines principales, complémentaires et accessoires) ;",
                    ),
                  ]),
                  _BulletPoint.rich([
                    const TextSpan(
                      text:
                          "poursuit l’exécution des sanctions pécuniaires prononcées par "
                          "les autorités compétentes des États membres de l’Union "
                          "européenne (",
                    ),
                    _cpp("Article 707-1 alinéa 6 du Code de procédure pénale"),
                    const TextSpan(text: ")."),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          "Pour les peines pécuniaires, le recouvrement est assuré soit par "
                          "le comptable public compétent, soit par l’Agence de gestion et "
                          "de recouvrement des avoirs saisis et confisqués lorsque la "
                          "confiscation porte sur des biens meubles ou immeubles (",
                    ),
                    _cpp("Article 707-1 alinéa 2 du Code de procédure pénale"),
                    const TextSpan(text: ")."),
                  ]),
                  const SizedBox(height: 6),
                  const _Paragraph.rich([
                    TextSpan(
                      text:
                          "L’Article 709 du Code de procédure pénale prévoit que le "
                          "procureur de la République et le procureur général peuvent "
                          "requérir directement l’assistance de la force publique pour "
                          "assurer l’exécution des décisions de justice.",
                    ),
                  ]),
                ],
              ),
              const SizedBox(height: 18),

              ////////////////////////////////////////////////
              /// 1.2 – DÉCISION DÉFINITIVE
              ////////////////////////////////////////////////
              _ConditionCard(
                title: "1.2 - La décision doit être définitive",
                cardColor: isDark
                    ? const Color(0xFF12151C)
                    : const Color(0xFFE8F5E9),
                accent: const Color(0xFF2E7D32),
                titleColor: isDark ? Colors.white : const Color(0xFF1B5E20),
                children: [
                  _Paragraph.rich([
                    const TextSpan(text: "L’"),
                    _cpp("Article 708 alinéa 1 du Code de procédure pénale"),
                    const TextSpan(
                      text:
                          " dispose que l’exécution a lieu lorsque la décision est "
                          "devenue définitive.",
                    ),
                  ]),
                  const SizedBox(height: 8),
                  const _SubTitle('1.2.1 - Le délai d’opposition'),
                  const _Paragraph(
                    "Lorsque la décision est rendue par défaut, elle ne peut être mise à "
                    "exécution tant que court le délai d’opposition. Ce délai suspend "
                    "l’exécution de la peine.",
                  ),
                  const SizedBox(height: 8),
                  const _SubTitle("1.2.2 - Le délai d'appel"),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          "Le délai d’appel est de 10 jours à compter du prononcé de la "
                          "décision : ",
                    ),
                    _cpp("Article 380-9 du Code de procédure pénale"),
                    const TextSpan(text: " (cour d’assises), "),
                    _cpp("Article 498 du Code de procédure pénale"),
                    const TextSpan(text: " (tribunal correctionnel), "),
                    _cpp("Article 547 du Code de procédure pénale"),
                    const TextSpan(text: " (tribunal de police)."),
                  ]),
                  const SizedBox(height: 6),
                  const _Paragraph(
                    "Pendant le délai d’appel et durant l’instance d’appel, il est "
                    "généralement sursis à l’exécution, sauf exceptions (exécution "
                    "provisoire de certaines mesures, maintien en détention, etc.).",
                  ),
                  const SizedBox(height: 8),
                  const _SubTitle('1.2.3 - Le pourvoi en cassation'),
                  const _Paragraph(
                    "Le pourvoi en cassation n’est en principe pas suspensif, sauf dans "
                    "certains cas prévus par la loi. Il n’empêche donc pas "
                    "l’exécution de la décision sauf texte contraire.",
                  ),
                ],
              ),
              const SizedBox(height: 18),

              ////////////////////////////////////////////////
              /// 1.3 – PEINES PRIVATIVES DE LIBERTÉ
              ////////////////////////////////////////////////
              _ConditionCard(
                title: "1.3 - L'exécution des peines privatives de liberté",
                cardColor: isDark
                    ? const Color(0xFF15161F)
                    : const Color(0xFFFFF3E0),
                accent: const Color(0xFFEF6C00),
                titleColor: isDark ? Colors.white : const Color(0xFFE65100),
                children: [
                  const _SubTitle('1.3.1 - Le rôle du ministère public'),
                  const _Paragraph(
                    "Le ministère public doit faire exécuter les peines privatives de "
                    "liberté, qu’elles soient prononcées par le tribunal correctionnel ou "
                    "la cour d’assises.",
                  ),
                  const SizedBox(height: 6),
                  const _IntroBullet(
                    text:
                        "Lorsque la cour d’assises siège au niveau de la cour d’appel, "
                        "l’exécution est assurée par le parquet général.",
                  ),
                  const _IntroBullet(
                    text:
                        "Lorsque la cour d’assises siège dans les locaux du tribunal "
                        "judiciaire, c’est le parquet de ce tribunal qui assure "
                        "l’exécution.",
                  ),
                  const SizedBox(height: 8),
                  const _SubTitle('1.3.2 - Modalités pratiques'),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          "Le Code de procédure pénale ne fixe pas de délai précis pour "
                          "l’incarcération des condamnés, mais l’instruction générale pour "
                          "l’application du C.P.P. (",
                    ),
                    _autreCode(
                      "Article C 816 de l’instruction générale pour l’application du Code de procédure pénale",
                    ),
                    const TextSpan(
                      text:
                          ") prescrit que la peine d’emprisonnement doit être mise à "
                          "exécution dans un délai de 15 jours.",
                    ),
                  ]),
                  const SizedBox(height: 6),
                  const _Paragraph(
                    "Un extrait de la décision exécutoire est établi par le greffe puis "
                    "adressé à l’établissement pénitentiaire à l’appui de l’écrou.",
                  ),
                  const SizedBox(height: 6),
                  const _IntroBullet(
                    text:
                        "Si le condamné est déjà détenu, l’écrou est régularisé sur place.",
                  ),
                  const _IntroBullet(
                    text:
                        "S’il est libre, le parquet peut le faire convoquer pour une mise "
                        "à exécution ou délivrer un réquisitoire d’arrestation aux forces "
                        "de police ou de gendarmerie.",
                  ),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          "Les agents de la force publique peuvent être autorisés à "
                          "pénétrer au domicile d’une personne condamnée afin d’assurer "
                          "l’exécution d’une peine d’emprisonnement. Cette intrusion est "
                          "encadrée par l’",
                    ),
                    _cpp("Article 716-5 du Code de procédure pénale"),
                    const TextSpan(
                      text:
                          " et doit respecter les heures légales et les règles relatives à "
                          "la protection du domicile.",
                    ),
                  ]),
                ],
              ),
              const SizedBox(height: 18),

              ////////////////////////////////////////////////
              /// 1.4 – PEINES NON PRIVATIVES
              ////////////////////////////////////////////////
              _ConditionCard(
                title: "1.4 - L'exécution des peines non privatives de liberté",
                cardColor: isDark
                    ? const Color(0xFF17171F)
                    : const Color(0xFFE3F2FD),
                accent: const Color(0xFF1565C0),
                titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
                children: [
                  const _SubTitle(
                    '1.4.1 - Peines applicables aux personnes physiques',
                  ),
                  const _SubTitle('1.4.1.1 - Les amendes'),
                  const _Paragraph.rich([
                    TextSpan(
                      text:
                          "Les condamnations pécuniaires (amendes pénales, civiles ou "
                          "administratives, certaines condamnations fiscales, "
                          "confiscations, réparations, dommages et intérêts…) sont "
                          "exigibles dès que la décision les prononçant est devenue "
                          "exécutoire.",
                    ),
                  ]),
                  const SizedBox(height: 6),
                  const _Paragraph.rich([
                    TextSpan(
                      text:
                          "Le recouvrement des amendes est assuré par le comptable public "
                          "compétent au nom du procureur de la République. Les extraits de "
                          "jugement ou d’arrêt doivent être adressés au Trésorier principal "
                          "dans un délai de 35 jours (45 jours en cas de pourvoi en "
                          "cassation).",
                    ),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          "Le paiement de l’amende est toujours privilégié. Le défaut total "
                          "ou partiel de paiement peut entraîner l’incarcération du "
                          "condamné dans le cadre de la contrainte judiciaire (",
                    ),
                    _cpp("Article 707-1 du Code de procédure pénale"),
                    const TextSpan(text: ")."),
                  ]),
                  const SizedBox(height: 8),
                  const _SubTitle('1.4.1.2 - Les jours-amende'),
                  const _Paragraph.rich([
                    TextSpan(
                      text:
                          "Les jours-amende sont une peine pécuniaire particulière. "
                          "L’intéressé s’acquitte d’une somme journalière ; à défaut de "
                          "paiement, le juge de l’application des peines peut ordonner un "
                          "emprisonnement pour une durée égale au nombre de jours-amende "
                          "impayés.",
                    ),
                  ]),
                  const SizedBox(height: 8),
                  const _SubTitle('1.4.1.3 - Autres sanctions'),
                  const _SubTitle('1.4.1.3.1 - Les peines de substitution'),
                  _Paragraph.rich([
                    const TextSpan(
                      text: "Les peines de substitution prévues à l’",
                    ),
                    _cp("Article 131-6 du Code pénal"),
                    const TextSpan(
                      text:
                          " comprennent notamment la suspension ou l’annulation du permis "
                          "de conduire, l’interdiction de conduire certains véhicules, "
                          "l’interdiction de détenir ou porter une arme, la confiscation de "
                          "la chose qui a servi ou était destinée à commettre l’infraction, "
                          "etc.",
                    ),
                  ]),
                  const SizedBox(height: 6),
                  const _SubTitle(
                    '1.4.1.3.2 - Peines complémentaires pouvant se substituer',
                  ),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          "Il existe également des peines complémentaires prévues à divers "
                          "articles du ",
                    ),
                    _cp("Code pénal"),
                    const TextSpan(
                      text:
                          " : interdiction de droits civiques, civils et de famille, "
                          "interdiction d’exercer certaines fonctions, fermeture "
                          "d’établissement, affichage ou diffusion de la décision, etc.",
                    ),
                  ]),
                  const SizedBox(height: 6),
                  const _SubTitle(
                    '1.4.1.3.3 - La peine de sanction-réparation',
                  ),
                  _Paragraph.rich([
                    const TextSpan(text: "L’"),
                    _cp("Article 131-8-1 du Code pénal"),
                    const TextSpan(
                      text:
                          " dispose qu’en cas de délit, la juridiction peut prononcer, à la "
                          "place ou en même temps que la peine d’emprisonnement ou "
                          "d’amende, une peine de sanction-réparation. Elle consiste pour "
                          "le condamné à indemniser la victime (remise en état d’un bien, "
                          "versements, etc.).",
                    ),
                  ]),
                  const SizedBox(height: 8),
                  const _SubTitle(
                    '1.4.2 - Peines applicables aux personnes morales',
                  ),
                  const _Paragraph.rich([
                    TextSpan(
                      text:
                          "Les personnes morales peuvent être condamnées à des peines "
                          "d’amende et à diverses peines complémentaires. Le recouvrement "
                          "des amendes s’effectue comme pour les personnes physiques, "
                          "sauf pour la contrainte judiciaire qui ne leur est pas "
                          "applicable.",
                    ),
                  ]),
                ],
              ),
              const SizedBox(height: 18),

              ////////////////////////////////////////////////
              /// CHAPITRE 2 – CONTRAINTE JUDICIAIRE
              ////////////////////////////////////////////////
              _ConditionCard(
                title:
                    "Chapitre 2 : Garantie d’exécution – la contrainte judiciaire",
                cardColor: isDark
                    ? const Color(0xFF15151D)
                    : const Color(0xFFFFF8E1),
                accent: const Color(0xFFF9A825),
                titleColor: isDark ? Colors.white : const Color(0xFF5D4037),
                children: [
                  const _SubTitle('2.1 - Définition'),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          "La contrainte judiciaire est une voie d’exécution qui permet, "
                          "en cas d’inexécution volontaire d’une condamnation pécuniaire, "
                          "d’incarcérer le condamné pour une durée déterminée. Elle succède "
                          "à l’ancienne contrainte par corps. La loi du 9 mars 2004 a "
                          "consacré le rôle du juge de l’application des peines chargé "
                          "d’ordonner cette mesure (",
                    ),
                    _cpp("Article 749 du Code de procédure pénale"),
                    const TextSpan(text: ")."),
                  ]),
                  const SizedBox(height: 8),
                  const _SubTitle('2.2 - Conditions de mise en œuvre'),
                  const _BulletPoint(
                    text:
                        "Inexécution volontaire de la condamnation pécuniaire par le "
                        "condamné ;",
                  ),
                  const _BulletPoint(
                    text:
                        "Condamnation consistant en une peine d’amende prononcée pour un "
                        "crime ou un délit puni d’une peine d’emprisonnement ;",
                  ),
                  const _BulletPoint(
                    text:
                        "Ne s’applique pas lorsque seule une peine d’amende contraventionnelle est encourue.",
                  ),
                  const SizedBox(height: 8),
                  const _SubTitle('2.3 - Personnes soumises à la contrainte'),
                  const _Paragraph(
                    "La contrainte judiciaire ne peut s’exercer que contre le délinquant "
                    "dont la culpabilité a été judiciairement constatée (auteur, co-auteur "
                    "ou complice).",
                  ),
                  const SizedBox(height: 8),
                  const _SubTitle('2.4 - Causes d’exemption'),
                  _BulletPoint.rich([
                    const TextSpan(
                      text:
                          "Minorité pénale : la contrainte judiciaire ne peut être "
                          "prononcée contre les mineurs de moins de 18 ans (",
                    ),
                    _cpp("Article 751 du Code de procédure pénale"),
                    const TextSpan(text: ")."),
                  ]),
                  _BulletPoint.rich([
                    const TextSpan(
                      text:
                          "Personnes âgées : elle ne peut être exercée contre les débiteurs "
                          "âgés d’au moins 65 ans à l’époque des faits (",
                    ),
                    _cpp("Article 751 du Code de procédure pénale"),
                    const TextSpan(text: ")."),
                  ]),
                  _BulletPoint.rich([
                    const TextSpan(
                      text:
                          "Personnes insolvables : pas de contrainte judiciaire contre les "
                          "condamnés qui justifient par tout moyen de leur insolvabilité (",
                    ),
                    _cpp("Article 752 du Code de procédure pénale"),
                    const TextSpan(text: ")."),
                  ]),
                  _BulletPoint.rich([
                    const TextSpan(text: "Époux : l’"),
                    _cpp("Article 753 du Code de procédure pénale"),
                    const TextSpan(
                      text:
                          " interdit d’exercer simultanément la contrainte judiciaire "
                          "contre deux époux, même en cas de condamnations différentes.",
                    ),
                  ]),
                  const SizedBox(height: 8),
                  const _SubTitle('2.5 - Procédure (Article 754 du C.P.P.)'),
                  const _SubTitle('2.5.1 - Commandement'),
                  const _Paragraph(
                    "Avant toute incarcération, la partie poursuivante doit inviter une "
                    "dernière fois le débiteur à payer : un commandement de payer lui est "
                    "signifié sous peine de contrainte judiciaire.",
                  ),
                  const SizedBox(height: 6),
                  const _SubTitle('2.5.2 - Demande d’incarcération'),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          "Si, dans l’année de la signification du commandement, le "
                          "condamné n’a pas payé, le procureur de la République peut "
                          "requérir le juge de l’application des peines pour qu’il "
                          "prononce la contrainte judiciaire. La procédure se déroule en "
                          "débat contradictoire (",
                    ),
                    _cpp("Article 712-6 du Code de procédure pénale"),
                    const TextSpan(text: ")."),
                  ]),
                  const SizedBox(height: 6),
                  const _SubTitle('2.5.3 - Durée de la contrainte'),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          "La contrainte judiciaire est exclue lorsque le montant de "
                          "l’amende est inférieur à 2 000 €. Au-delà, la durée maximale "
                          "varie selon des tranches de montant (20 jours, 1 mois, 2 mois, "
                          "3 mois), avec un plafond fixé notamment par l’",
                    ),
                    _cpp("Article 750 du Code de procédure pénale"),
                    const TextSpan(text: "."),
                  ]),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          "En matière de trafic de stupéfiants, la durée maximale peut être "
                          "portée à un an (",
                    ),
                    _cpp("Article 706-31 alinéa 3 du Code de procédure pénale"),
                    const TextSpan(text: ")."),
                  ]),
                  const SizedBox(height: 6),
                  const _SubTitle('2.5.4 - Fin de la contrainte'),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          "La libération peut être anticipée si le débiteur s’acquitte de "
                          "sa dette, verse un acompte jugé suffisant ou fournit une "
                          "caution reconnue bonne et valable. Néanmoins, la dette "
                          "subsiste malgré l’exécution de la contrainte (",
                    ),
                    _cpp("Article 761-1 du Code de procédure pénale"),
                    const TextSpan(text: ")."),
                  ]),
                ],
              ),
              const SizedBox(height: 18),

              ////////////////////////////////////////////////
              /// CHAPITRE 3 – JURIDICTIONS D’APPLICATION DES PEINES
              ////////////////////////////////////////////////
              _ConditionCard(
                title:
                    "Chapitre 3 : Les juridictions de l'application des peines",
                cardColor: isDark
                    ? const Color(0xFF171822)
                    : const Color(0xFFE8EAF6),
                accent: const Color(0xFF1A237E),
                titleColor: isDark ? Colors.white : const Color(0xFF1A237E),
                children: [
                  const _Paragraph.rich([
                    TextSpan(
                      text:
                          "La loi n° 2000-516 du 15 juin 2000 a prévu la "
                          "juridictionnalisation des décisions du juge de l'application "
                          "des peines, notamment pour la semi-liberté, le placement à "
                          "l’extérieur, le fractionnement et la suspension des peines et "
                          "la libération conditionnelle. Toute décision d’octroi, "
                          "d’ajournement, de refus, de retrait ou de révocation de ces "
                          "mesures doit être prise après un débat contradictoire.",
                    ),
                  ]),
                  const SizedBox(height: 6),
                  const _Paragraph.rich([
                    TextSpan(
                      text:
                          "La loi n° 2004-204 du 9 mars 2004 a clarifié les règles "
                          "relatives à l’application des peines et renforcé la "
                          "juridictionnalisation des mesures de milieu ouvert.",
                    ),
                  ]),
                  const SizedBox(height: 10),

                  const _SubTitle(
                    '3.1 - Juridictions de l’application des peines du premier degré',
                  ),
                  const _SubTitle(
                    '3.1.1 - Le juge de l’application des peines',
                  ),
                  _Paragraph.rich([
                    const TextSpan(text: "L’"),
                    _cpp("Article 712-2 du Code de procédure pénale"),
                    const TextSpan(
                      text:
                          " prévoit que dans chaque tribunal judiciaire, un ou plusieurs "
                          "magistrats du siège exercent les fonctions de juge de "
                          "l’application des peines.",
                    ),
                  ]),
                  const SizedBox(height: 6),
                  const _Paragraph.rich([
                    TextSpan(
                      text:
                          "Le juge de l’application des peines (JAP) fixe les principales "
                          "modalités d’exécution des peines privatives ou restrictives de "
                          "liberté et en contrôle les conditions d’application.",
                    ),
                  ]),
                  const SizedBox(height: 6),
                  const _SubTitle('3.1.1.1 - Décisions en milieu fermé'),
                  const _Paragraph(
                    "En milieu fermé, le JAP intervient notamment pour : le placement à "
                    "l’extérieur, la semi-liberté, la suspension ou le fractionnement des "
                    "peines, la détention à domicile sous surveillance électronique, la "
                    "libération conditionnelle, après avis de la commission de "
                    "l’application des peines.",
                  ),
                  const SizedBox(height: 6),
                  const _SubTitle('3.1.1.2 - Décisions en milieu ouvert'),
                  _Paragraph.rich([
                    const TextSpan(text: "En milieu ouvert, l’"),
                    _cpp("Article 712-6 du Code de procédure pénale"),
                    const TextSpan(
                      text:
                          " précise que le JAP détermine les conditions d’exécution de la "
                          "peine en fonction de la situation du condamné (sursis "
                          "probatoire, travail d’intérêt général, suivi socio-judiciaire, "
                          "interdiction de séjour, etc.).",
                    ),
                  ]),
                  const SizedBox(height: 6),
                  const _SubTitle('3.1.1.3 - Pouvoirs du JAP'),
                  const _BulletPoint(
                    text:
                        "Peut ordonner la suspension d’une mesure (semi-liberté, placement "
                        "extérieur, détention à domicile sous surveillance électronique) "
                        "en cas de non-respect des obligations ;",
                  ),
                  _BulletPoint.rich([
                    const TextSpan(
                      text:
                          "Peut ordonner l’incarcération provisoire du condamné après avis "
                          "du procureur de la République dans certaines hypothèses (",
                    ),
                    _cpp("Article 712-19 du Code de procédure pénale"),
                    const TextSpan(text: ");"),
                  ]),
                  _BulletPoint.rich([
                    const TextSpan(
                      text:
                          "Peut révoquer ou retirer les mesures prises en application des ",
                    ),
                    _cpp("Articles 712-6 et 712-7 du Code de procédure pénale"),
                    const TextSpan(
                      text:
                          " lorsque le condamné ne respecte pas ses obligations (",
                    ),
                    _cpp("Article 712-20 du Code de procédure pénale"),
                    const TextSpan(text: ");"),
                  ]),
                  _BulletPoint.rich([
                    const TextSpan(
                      text:
                          "Peut informer la victime ou la partie civile de ses droits et "
                          "lui permettre de présenter des observations (",
                    ),
                    _cpp("Article 712-16-1 du Code de procédure pénale"),
                    const TextSpan(text: ")."),
                  ]),
                  const SizedBox(height: 8),

                  const _SubTitle(
                    '3.1.2 - Le tribunal de l’application des peines',
                  ),
                  _Paragraph.rich([
                    const TextSpan(text: "L’"),
                    _cpp("Article 712-3 du Code de procédure pénale"),
                    const TextSpan(
                      text:
                          " prévoit que dans le ressort de chaque cour d’appel est établi "
                          "un tribunal de l’application des peines (TAP).",
                    ),
                  ]),
                  const SizedBox(height: 6),
                  const _SubTitle('3.1.2.2 - Composition'),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          "Le TAP est composé d’un président et de deux assesseurs, "
                          "désignés parmi les juges de l’application des peines du ressort "
                          "de la cour d’appel (",
                    ),
                    _cpp("Article 712-10 alinéa 4 du Code de procédure pénale"),
                    const TextSpan(text: ")."),
                  ]),
                  const SizedBox(height: 6),
                  const _SubTitle('3.1.2.3 - Compétence'),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          "Le TAP est compétent pour les mesures qui ne relèvent pas du "
                          "JAP, en particulier pour les décisions relatives : au "
                          "relèvement de la période de sûreté, à la libération "
                          "conditionnelle des condamnés à des peines supérieures à 10 ans, "
                          "à certaines suspensions de peine (",
                    ),
                    _cpp("Article 712-11 du Code de procédure pénale"),
                    const TextSpan(text: ")."),
                  ]),
                  const SizedBox(height: 6),
                  const _SubTitle('3.1.2.4 - Pouvoirs et voies de recours'),
                  const _Paragraph(
                    "Les décisions du TAP sont exécutoires par provision. Lorsque "
                    "l’appel du ministère public est formé dans les 24 heures, il est "
                    "suspensif. Les décisions peuvent être attaquées par la voie de "
                    "l’appel par le condamné, le procureur de la République ou le "
                    "procureur général.",
                  ),
                  const SizedBox(height: 10),

                  const _SubTitle(
                    '3.2 - La chambre de l’application des peines',
                  ),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          "La chambre de l’application des peines de la cour d’appel est "
                          "compétente pour connaître des appels formés contre les décisions "
                          "du JAP et du TAP (",
                    ),
                    _cpp("Article 712-13 du Code de procédure pénale"),
                    const TextSpan(text: ")."),
                  ]),
                  const SizedBox(height: 6),
                  const _SubTitle('3.2.2 - Composition'),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          "Elle est composée d’un président et de deux conseillers. Pour "
                          "certains jugements (notamment ceux de l’",
                    ),
                    _cpp("Article 712-7 du Code de procédure pénale"),
                    const TextSpan(
                      text:
                          "), la chambre peut être complétée par un responsable d’une "
                          "association de réinsertion et un responsable d’une association "
                          "d’aide aux victimes.",
                    ),
                  ]),
                  const SizedBox(height: 6),
                  const _SubTitle('3.2.3 - Décisions'),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          "La chambre de l’application des peines statue par arrêt motivé "
                          "après débat contradictoire. Les arrêts peuvent faire l’objet, "
                          "dans les 5 jours de leur notification, d’un pourvoi en "
                          "cassation non suspensif (",
                    ),
                    _cpp("Article 712-15 du Code de procédure pénale"),
                    const TextSpan(text: ")."),
                  ]),
                ],
              ),

              const SizedBox(height: 24),
              Center(
                child: Text(
                  '© COPIQ - Tous droits réservés',
                  style: GoogleFonts.fustat(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white54 : const Color(0xFF757575),
                  ),
                ),
              ),
            ],
          ),
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
  const _BulletPoint({this.text, this.spans})
    : assert(
        text != null || spans != null,
        'Vous devez fournir soit text soit spans',
      ),
      assert(
        text == null || spans == null,
        'Impossible d’utiliser text et spans en même temps',
      );

  /// Texte simple
  final String? text;

  /// Version riche (spans) pour gérer les articles en rouge
  final List<TextSpan>? spans;

  /// Nouveau constructeur nommé : .rich()
  const _BulletPoint.rich(this.spans) : text = null;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color color = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withValues(alpha: .92);

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

          /// Si texte simple → Text()
          if (text != null)
            Expanded(
              child: Text(
                text!,
                style: GoogleFonts.fustat(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.35,
                  color: color,
                ),
              ),
            ),

          /// Si version riche → RichText()
          if (spans != null)
            Expanded(
              child: RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                  style: GoogleFonts.fustat(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.35,
                    color: color,
                  ),
                  children: spans!,
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

class _BulletPointRich extends StatelessWidget {
  const _BulletPointRich({required this.spans});

  final List<TextSpan> spans;

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
            child: RichText(
              textAlign: TextAlign.justify,
              text: TextSpan(
                style: GoogleFonts.fustat(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.35,
                  color: isDark
                      ? Colors.white70
                      : const Color(0xFF1F1F1F).withValues(alpha: .92),
                ),
                children: spans,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
