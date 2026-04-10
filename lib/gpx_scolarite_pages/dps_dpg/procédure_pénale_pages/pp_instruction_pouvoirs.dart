import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PPInstructionPouvoirsPage extends StatelessWidget {
  const PPInstructionPouvoirsPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/procédure_pénale_pages/pp_instruction_pouvoirs';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF222222).withOpacity(.70);

    final Color cardLight = isDark
        ? const Color(0xFF424242)
        : const Color(0xFFF5F7FB);
    final Color cardAccent = isDark
        ? const Color(0xFF90CAF9)
        : const Color(0xFF1565C0);

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
          "Pouvoirs du juge d'instruction",
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        children: [
          // ====================== TITRE PRINCIPAL ===========================
          Text(
            "Chapitre 3 – Les pouvoirs du juge d'instruction",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),

          Text(
            "Rôle général du juge d’instruction, constatations matérielles, recours aux experts, "
            "auditions des témoins, témoins assistés, personnes mises en examen et parties civiles.",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),

          const SizedBox(height: 18),

          ////////////////////////////////////////////////////////////////////
          // 3.1 – CARACTÈRES GÉNÉRAUX
          ////////////////////////////////////////////////////////////////////
          const _SubTitle('3.1 – Caractères généraux'),

          _ConditionCard(
            title: "3.1 – Caractères généraux de l'instruction",
            cardColor: cardLight,
            accent: cardAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Le juge d’instruction a pour première mission de rechercher avec précision les "
                      "circonstances dans lesquelles l’infraction a été commise, ainsi que les conditions "
                      "dans lesquelles les différentes personnes concernées y ont participé. Il doit aussi "
                      "porter son attention sur la personnalité du mis en cause, prise en compte au moment "
                      "de la répression, mais également sur la personnalité de la victime. Cette exigence est "
                      "rappelée par ",
                ),
                TextSpan(
                  text: "l’Article 81-1 du Code de procédure pénale",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                const TextSpan(
                  text:
                      ", qui consacre l’importance de la recherche de la vérité tout en tenant compte "
                      "de la situation personnelle des protagonistes.",
                ),
              ]),
              const SizedBox(height: 8),

              _Paragraph.rich([
                const TextSpan(
                  text:
                      "La recherche de la vérité doit être menée de la manière la plus objective possible. "
                      "Pour y parvenir, le juge instruit à charge et à décharge : il doit rechercher et "
                      "examiner avec soin tous les éléments susceptibles soit de confirmer la culpabilité "
                      "de la personne mise en cause, soit au contraire de la disculper. Ce principe d’objectivité "
                      "et de double regard est au cœur de ",
                ),
                TextSpan(
                  text: "l’Article 81 alinéa 1 du Code de procédure pénale",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),

              const _Paragraph(
                "Pour mener à bien cette mission délicate, le juge d’instruction dispose de mesures "
                "très diverses : mandats de justice, contrôle judiciaire, détention provisoire, commissions "
                "rogatoires, expertises, auditions, perquisitions, saisies… Certaines de ces mesures font l’objet "
                "d’un traitement détaillé dans d’autres chapitres (mandats, contrôle judiciaire, détention "
                "provisoire, commissions rogatoires). Dans ce chapitre, l’accent est mis sur les constatations "
                "matérielles et les différentes catégories de personnes que le juge peut entendre.",
              ),
            ],
          ),

          const SizedBox(height: 18),

          ////////////////////////////////////////////////////////////////////
          // 3.2 – LES CONSTATATIONS MATÉRIELLES
          ////////////////////////////////////////////////////////////////////
          const _SubTitle('3.2 – Les constatations matérielles'),

          _ConditionCard(
            title: '3.2.1 – Les constatations effectuées par le juge',
            cardColor: cardLight,
            accent: cardAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Le juge d’instruction peut procéder lui-même à un certain nombre de constatations "
                      "matérielles venant compléter celles déjà effectuées par les services d’enquête. "
                      "Dans ce cadre, ",
                ),
                TextSpan(
                  text: "l’Article 92 du Code de procédure pénale",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                const TextSpan(
                  text:
                      " l’autorise à se transporter sur les lieux pour effectuer toutes constatations utiles "
                      "ou procéder à des perquisitions, le cas échéant en donnant avis au procureur de la "
                      "République qui peut l’accompagner.",
                ),
              ]),
              const SizedBox(height: 8),

              const _Paragraph(
                "Lors de ces déplacements, le juge d’instruction est assisté de son greffier, chargé de "
                "rédiger le procès-verbal des constatations. Cet acte de procédure doit être signé par le "
                "juge et par le greffier. Le juge peut se déplacer, être assisté de son greffier et, sans "
                "être obligé de dresser un procès-verbal détaillé pour chaque observation, doit diriger et "
                "contrôler personnellement l’exécution d’une éventuelle commission rogatoire.",
              ),
              const SizedBox(height: 8),

              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Il peut également, dans le cadre de l’exécution d’une commission rogatoire, "
                      "ordonner la prolongation de gardes à vue déjà décidées, conformément aux conditions "
                      "posées par ",
                ),
                TextSpan(
                  text: "l’Article 152 alinéa 3 du Code de procédure pénale",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.red.shade700,
                  ),
                ),
                const TextSpan(
                  text:
                      ". Certaines constatations peuvent aussi être réalisées au cabinet du juge, qui examine "
                      "les pièces saisies et évalue leur intérêt pour l’information.",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 16),

          _ConditionCard(
            title: '3.2.2 – L’expertise',
            cardColor: cardLight,
            accent: cardAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Lorsque la technicité d’une question dépasse ses compétences juridiques, le juge "
                      "d’instruction peut recourir à des experts. L’expertise est encadrée par ",
                ),
                TextSpan(
                  text: "les Articles 156 à 169-1 du Code de procédure pénale",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                const TextSpan(
                  text:
                      " et a pour objet l’examen de questions d’ordre technique nécessitant, au-delà de "
                      "constatations objectives, une véritable interprétation spécialisée : police scientifique, "
                      "balistique, faux documents, médecine légale, psychiatrie, biologie, chimie, toxicologie, "
                      "comptabilité, etc.",
                ),
              ]),
              const SizedBox(height: 10),

              const _SubTitle('3.2.2.1 – La nomination des experts'),

              _Paragraph.rich([
                const TextSpan(
                  text:
                      "L’initiative d’une expertise peut appartenir au ministère public, au juge d’instruction "
                      "qui ordonne d’office, à l’une des parties ou encore au témoin assisté. Lorsque le juge "
                      "refuse de donner suite à une demande d’expertise, il doit rendre une ordonnance motivée "
                      "dans le délai d’un mois à compter de la demande, conformément à ",
                ),
                TextSpan(
                  text: "l’Article 156 du Code de procédure pénale",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),

              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Les experts sont en principe choisis parmi les personnes physiques ou morales "
                      "inscrites sur les listes nationales ou régionales dressées par les juridictions. "
                      "Cette organisation est prévue par ",
                ),
                TextSpan(
                  text: "l’Article 157 du Code de procédure pénale",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                const TextSpan(
                  text:
                      ", qui permet également de recourir à des services spécialisés, notamment les services "
                      "de police technique et scientifique de la police nationale et de la gendarmerie nationale. "
                      "L’Article 157-2 du Code de procédure pénale prévoit ces recours. Dans des cas exceptionnels, "
                      "le juge peut désigner un expert non inscrit sur ces listes, à condition de motiver "
                      "expressément ce choix.",
                ),
              ]),

              const SizedBox(height: 12),
              const _SubTitle('3.2.2.2 – Le déroulement de l’expertise'),

              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Avant d’exercer leurs fonctions, les experts inscrits sur les listes prêtent serment "
                      "« d’apporter leur concours à la justice, en leur honneur et en leur conscience ». Ce serment "
                      "est prêté devant la cour d’appel dont ils dépendent ou, pour certains experts, devant la "
                      "juridiction désignée. Les modalités de ce serment sont prévues par ",
                ),
                TextSpan(
                  text: "l’Article 160 du Code de procédure pénale",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                const TextSpan(
                  text:
                      ". Les experts non inscrits sur une liste prêtent serment devant le juge d’instruction "
                      "ou le magistrat désigné.",
                ),
              ]),
              const SizedBox(height: 8),

              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Les experts accomplissent leur mission sous le contrôle du juge d’instruction, qui doit "
                      "être tenu informé des opérations en cours et peut prendre toute mesure utile. Ce contrôle "
                      "est rappelé par ",
                ),
                TextSpan(
                  text: "l’Article 156 alinéa 3 du Code de procédure pénale",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                const TextSpan(text: " et par les dispositions de "),
                TextSpan(
                  text: "l’Article 161 alinéa 3 du Code de procédure pénale",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                const TextSpan(
                  text:
                      ". Les pièces à conviction placées sous scellés peuvent, après inventaire, être mises "
                      "à la disposition des experts qui, le cas échéant, peuvent ouvrir les scellés et procéder "
                      "à l’inventaire des objets, en application de ",
                ),
                TextSpan(
                  text: "l’Article 163 du Code de procédure pénale",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.red.shade700,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),

              _Paragraph.rich([
                const TextSpan(
                  text:
                      "À l’issue de leurs opérations, les experts rédigent un rapport détaillé exposant la nature "
                      "des investigations réalisées et leurs conclusions. Ce rapport doit être signé par les experts, "
                      "mentionner les noms et qualités des personnes les ayant assistés et être déposé entre les mains "
                      "du greffier, qui dresse procès-verbal de dépôt conformément à ",
                ),
                TextSpan(
                  text: "l’Article 166 du Code de procédure pénale",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                const TextSpan(
                  text:
                      ". Avec l’accord du juge d’instruction, les conclusions peuvent être communiquées au procureur "
                      "de la République, aux officiers de police judiciaire chargés de l’exécution d’une commission "
                      "rogatoire ou aux parties.",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 20),

          ////////////////////////////////////////////////////////////////////
          // 3.3 – LES AUDITIONS
          ////////////////////////////////////////////////////////////////////
          const _SubTitle('3.3 – Les auditions'),

          _ConditionCard(
            title: '3.3.1 – Les auditions de témoins',
            cardColor: cardLight,
            accent: cardAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Le juge d’instruction peut entendre toute personne susceptible d’apporter des éléments "
                      "utiles à la manifestation de la vérité. Les règles applicables aux témoins sont précisées "
                      "par ",
                ),
                TextSpan(
                  text: "les Articles 101 à 113-8 du Code de procédure pénale",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),

              const _SubTitle('3.3.1.1 – Les personnes concernées'),

              _Paragraph.rich([
                const TextSpan(
                  text:
                      "En vertu de ces dispositions, le juge d’instruction peut faire citer devant lui, par huissier "
                      "ou par agent de la force publique, toute personne dont la déposition lui paraît utile. Si la "
                      "personne régulièrement citée ne comparaît pas ou refuse de comparaître, elle peut y être "
                      "contrainte par la force publique. En outre, ",
                ),
                TextSpan(
                  text: "l’Article 105 du Code de procédure pénale",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                const TextSpan(
                  text:
                      " impose au juge d’entendre comme témoins les personnes contre lesquelles existent des indices "
                      "graves ou concordants d’avoir participé à l’infraction, sauf à les placer sous un autre statut.",
                ),
              ]),
              const SizedBox(height: 8),

              const _SubTitle(
                '3.3.1.2 – Les formalités attachées à l’audition',
              ),

              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Les témoins doivent être entendus séparément et hors la présence des parties, sauf en cas de "
                      "confrontation. Il est dressé procès-verbal de leurs déclarations, conformément à ",
                ),
                TextSpan(
                  text: "l’Article 102 du Code de procédure pénale",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                const TextSpan(
                  text:
                      ". Le juge vérifie l’identité du témoin et précise ses liens éventuels avec les parties – "
                      "parenté, alliance, lien de service – en application de ",
                ),
                TextSpan(
                  text: "l’Article 103 du Code de procédure pénale",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                const TextSpan(
                  text:
                      ". Le témoin prête serment de dire toute la vérité, rien que la vérité.",
                ),
              ]),
              const SizedBox(height: 8),

              _Paragraph.rich([
                const TextSpan(
                  text: "Les obligations du témoin sont détaillées par ",
                ),
                TextSpan(
                  text: "l’Article 109 du Code de procédure pénale",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                const TextSpan(
                  text:
                      " : il doit comparaître, prêter serment et déposer. Certaines catégories de personnes sont toutefois "
                      "dispensées de l’obligation de prêter serment ou de déposer, notamment les proches parents du mis en "
                      "cause et les mineurs, conformément à ",
                ),
                TextSpan(
                  text: "l’Article 335 du Code de procédure pénale",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                const TextSpan(
                  text:
                      " et aux textes relatifs à la protection de la famille et aux liens de parenté.",
                ),
              ]),
              const SizedBox(height: 8),

              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Certaines personnes sont tenues au secret professionnel et ne peuvent déposer qu’avec l’autorisation "
                      "de la personne concernée ou dans les limites fixées par ",
                ),
                TextSpan(
                  text: "l’Article 131-26 du Code pénal",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.red.shade700,
                  ),
                ),
                const TextSpan(
                  text:
                      ". Quant aux journalistes professionnels, ils bénéficient d’une protection spécifique quant à leurs "
                      "sources d’information.",
                ),
              ]),
              const SizedBox(height: 8),

              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Le non-respect par le témoin de ses obligations peut être sanctionné pénalement. Ainsi, ",
                ),
                TextSpan(
                  text: "l’Article 434-15-1 du Code pénal",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.red.shade700,
                  ),
                ),
                const TextSpan(
                  text:
                      " punit d’une amende pouvant aller jusqu’à 3 750 euros le témoin qui, sans motif légitime, "
                      "refuse de comparaître ou de déposer devant le juge d’instruction ou devant un officier de "
                      "police judiciaire agissant sur commission rogatoire.",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 18),

          _ConditionCard(
            title: '3.3.2 – Les auditions de témoins assistés',
            cardColor: cardLight,
            accent: cardAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Le témoin assisté occupe une position intermédiaire entre le simple témoin et la personne "
                      "mise en examen. Ce statut concerne des personnes à l’égard desquelles pèsent des soupçons plus "
                      "ou moins sérieux mais pour lesquelles la mise en examen n’est pas encore envisagée. Il est "
                      "notamment organisé par ",
                ),
                TextSpan(
                  text: "l’Article 80-1 du Code de procédure pénale",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),

              const _SubTitle('3.3.2.1 – Les personnes concernées'),

              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Sont notamment témoins assistés, de plein droit ou à la demande, les personnes nommément "
                      "visées dans un réquisitoire introductif ou supplétif du procureur de la République, celles "
                      "contre lesquelles existent des indices graves ou concordants, ainsi que les personnes visées "
                      "par une plainte ou une plainte avec constitution de partie civile. Ces situations sont visées "
                      "par ",
                ),
                TextSpan(
                  text:
                      "les Articles 113-1, 113-2 et 113-6 du Code de procédure pénale",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),

              const _SubTitle('3.3.2.2 – Les droits du témoin assisté'),

              _IntroBullet(
                text:
                    "Assistance d’un avocat, désigné par lui ou d’office, avec accès au dossier de la procédure.",
              ),
              _IntroBullet(
                text:
                    "Droit d’obtenir l’interprétation ou la traduction des pièces essentielles du dossier.",
              ),
              _IntroBullet(
                text:
                    "Droit de demander des confrontations et de formuler des requêtes en annulation.",
              ),
              _IntroBullet(
                text:
                    "Droit de demander son renvoi devant une juridiction de jugement ou la clôture de la procédure "
                    "lorsqu’aucun acte d’instruction n’a été accompli depuis quatre mois, en application de ",
              ),
              _Paragraph.rich([
                TextSpan(
                  text: "l’Article 175-1 du Code de procédure pénale",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.red.shade700,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),

              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Le témoin assisté est avisé de la fin de l’information, peut présenter des observations et "
                      "soulever des nullités au moment où le juge statue sur le règlement du dossier, conformément à ",
                ),
                TextSpan(
                  text: "l’Article 175 du Code de procédure pénale",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),

              _Paragraph.rich([
                const TextSpan(
                  text:
                      "En cas de non-respect de ses obligations de comparution, le témoin assisté ne peut pas, "
                      "devant le juge d’instruction, faire l’objet d’une contrainte par la force publique lorsqu’il "
                      "est seulement convoqué par un officier de police judiciaire : en effet, ",
                ),
                TextSpan(
                  text: "l’Article 152 du Code de procédure pénale",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.red.shade700,
                  ),
                ),
                const TextSpan(
                  text:
                      " subordonne l’audition d’un témoin assisté par un officier de police judiciaire à une demande "
                      "expresse de ce dernier.",
                ),
              ]),
              const SizedBox(height: 8),

              const _SubTitle('3.3.2.4 – La mise en examen du témoin assisté'),

              _Paragraph.rich([
                const TextSpan(
                  text:
                      "La mise en examen d’un témoin assisté peut intervenir à sa demande ou à l’initiative du juge "
                      "d’instruction lorsque ce dernier estime que des indices graves ou concordants rendent vraisemblable "
                      "sa participation à l’infraction. ",
                ),
                TextSpan(
                  text: "L’Article 113-6 alinéa 2 du Code de procédure pénale",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                const TextSpan(
                  text:
                      " précise que, dans certains cas, le juge a la faculté de maintenir la personne sous le statut "
                      "de témoin assisté s’il n’est pas en mesure de réunir des indices suffisamment graves ou concordants.",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 20),

          _ConditionCard(
            title: '3.3.3 – Les interrogatoires de la personne mise en examen',
            cardColor: cardLight,
            accent: cardAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: [
              _SubTitle('3.3.3.1 – Les personnes concernées'),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "La mise en examen suppose, à peine de nullité, l’existence d’indices graves ou concordants "
                      "rendant vraisemblable la participation de la personne à l’infraction. Cette condition est posée par ",
                ),
                TextSpan(
                  text: "l’Article 80-1 du Code de procédure pénale",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                const TextSpan(
                  text:
                      ". Lorsque la mise en examen n’est pas possible ou pas nécessaire, le juge peut recourir au statut "
                      "de témoin assisté.",
                ),
              ]),
              const SizedBox(height: 8),

              _SubTitle(
                '3.3.3.2 – L’interrogatoire de première comparution d’une personne non témoin assisté',
              ),

              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Quand le juge envisage de mettre en examen une personne qui n’a pas encore le statut de témoin "
                      "assisté, il doit procéder à un interrogatoire de première comparution, conformément aux exigences de ",
                ),
                TextSpan(
                  text: "l’Article 116 du Code de procédure pénale",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                const TextSpan(
                  text:
                      ". En matière criminelle, cet interrogatoire fait l’objet d’un enregistrement audiovisuel, en application de ",
                ),
                TextSpan(
                  text: "l’Article 116-1 du Code de procédure pénale",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                const TextSpan(
                  text:
                      ". L’Article 80-2 du Code de procédure pénale permet en outre au juge de convoquer la personne par lettre "
                      "recommandée, dans un délai compris entre dix jours et deux mois.",
                ),
              ]),
              const SizedBox(height: 8),

              const _SubTitle('3.3.3.3 – Particularités'),

              const _IntroBullet(
                text: "La personne mise en examen ne prête pas serment.",
              ),
              _IntroBullet(
                text:
                    "Elle peut demander à être entendue à nouveau, demander des confrontations ou la réalisation d’actes "
                    "d’instruction complémentaires, notamment sur le fondement de ",
              ),
              _Paragraph.rich([
                TextSpan(
                  text: "l’Article 82-1 du Code de procédure pénale",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),

              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Le procureur de la République et les avocats peuvent prendre la parole au cours des interrogatoires pour "
                      "formuler des observations ou poser des questions, mais c’est le juge d’instruction qui dirige les débats, "
                      "conformément à ",
                ),
                TextSpan(
                  text: "l’Article 120 du Code de procédure pénale",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 20),

          _ConditionCard(
            title: '3.3.4 – Les auditions de parties civiles',
            cardColor: cardLight,
            accent: cardAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: [
              const _SubTitle('3.3.4.1 – Personnes concernées'),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Toute personne qui se prétend lésée par un crime ou un délit peut se constituer partie civile devant le "
                      "juge d’instruction en déposant plainte, conformément à ",
                ),
                TextSpan(
                  text: "l’Article 85 du Code de procédure pénale",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                const TextSpan(
                  text:
                      ". La constitution de partie civile déclenche en principe l’action publique si la plainte est recevable.",
                ),
              ]),
              const SizedBox(height: 8),

              _Paragraph.rich([
                const TextSpan(
                  text:
                      "La constitution de partie civile peut être formée par simple déclaration écrite ou orale, sans formalisme "
                      "rigide, comme le rappelle ",
                ),
                TextSpan(
                  text: "l’Article 87 du Code de procédure pénale",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                const TextSpan(text: ". D’autres textes, tels que "),
                TextSpan(
                  text: "l’Article 80-3 du Code de procédure pénale",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                const TextSpan(
                  text:
                      ", encadrent l’information de la victime sur ses droits, sa possibilité de se constituer partie civile et les "
                      "délais pour demander la clôture de la procédure.",
                ),
              ]),
              const SizedBox(height: 8),

              const _SubTitle(
                '3.3.4.3 – Effets de la constitution de partie civile pour la victime',
              ),

              const _BulletPoint(
                text:
                    "La victime devient pleinement partie à la procédure et peut intervenir dans le déroulement de l’information.",
              ),
              const _BulletPoint(
                text:
                    "Elle peut demander l’annulation d’actes, faire appel de certaines décisions et solliciter la clôture de l’instruction "
                    "lorsque aucun acte n’a été accompli depuis quatre mois.",
              ),
              const _BulletPoint(
                text:
                    "Elle obtient le droit d’être informée régulièrement de l’avancement du dossier.",
              ),

              const SizedBox(height: 8),

              const _SubTitle('3.3.4.4 – Particularités'),

              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Lors de sa première audition, la partie civile est avisée de ses droits, notamment de la possibilité de formuler des "
                      "demandes d’actes et des requêtes en annulation, ainsi que des délais dans lesquels elle peut demander la clôture de la "
                      "procédure. Ces informations découlent notamment de ",
                ),
                TextSpan(
                  text: "l’Article 89-1 du Code de procédure pénale",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                const TextSpan(text: " et de "),
                TextSpan(
                  text: "l’Article 175-1 du Code de procédure pénale",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),

              _Paragraph.rich([
                const TextSpan(
                  text:
                      "La partie civile ne prête pas serment. Elle peut demander à être entendue par le juge d’instruction, mais ne peut être "
                      "auditionnée qu’en présence de son avocat, sauf renonciation expresse. Lors de l’exécution d’une commission rogatoire, ",
                ),
                TextSpan(
                  text: "l’Article 152 du Code de procédure pénale",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.red.shade700,
                  ),
                ),
                const TextSpan(
                  text:
                      " précise que l’audition d’une partie civile par un officier de police judiciaire ne peut intervenir qu’à la demande de celle-ci.",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 22),

          const _NotaBox(
            title: 'À RETENIR',
            bodySpans: [
              TextSpan(
                text:
                    "Le juge d’instruction dispose de pouvoirs très étendus : constatations sur les lieux, recours à des experts, "
                    "audition de témoins, mise en place du statut de témoin assisté, mise en examen et prise en compte des droits "
                    "de la partie civile. Ces pouvoirs sont strictement encadrés par le Code de procédure pénale – en particulier "
                    "les Articles 81-1, 92, 156 à 169-1, 101 à 113-8, 80-1, 113-1 à 113-7, 116, 120, 85, 87 et 175-1 – afin de concilier "
                    "efficacité de l’enquête, respect des droits de la défense et protection des victimes.",
              ),
            ],
          ),

          const SizedBox(height: 26),
        ],
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////////
//                   TES WIDGETS PERSONNALISÉS EXACTS                       ///
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
