import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GPXSchoolElementsConstitutifsInfractionPage extends StatelessWidget {
  const GPXSchoolElementsConstitutifsInfractionPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/droit_pénale_général_pages/loi_penale/elements_constitutifs_infraction';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF222222).withOpacity(.70);

    final Color cardColor = isDark
        ? const Color(0xFF2F2F2F)
        : const Color(0xFFF7F8FB);
    final Color accent = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);

    TextSpan redLaw(String s) => TextSpan(
      text: s,
      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w800),
    );

    TextSpan normal(String s) => TextSpan(text: s);

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
          "Éléments constitutifs de l’infraction",
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 28),
        children: [
          Text(
            "Les éléments constitutifs de l’infraction",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Toute infraction suppose la réunion de trois éléments : un élément légal, "
            "un élément matériel et un élément moral. Sans l’un d’eux, l’infraction n’existe pas.",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 16),

          // ========================= CHAPITRE 1 =========================
          _ConditionCard(
            title: "CHAPITRE 1 : L’ÉLÉMENT LÉGAL",
            cardColor: cardColor,
            accent: accent,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Sans texte légal, il n’y a pas d’infraction, même si l’acte commis apporte un trouble à l’ordre public.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                normal("Le principe de légalité est posé par "),
                redLaw("l’article 111-3 du Code pénal"),
                normal(
                  " : « nul ne peut être puni pour un crime ou pour un délit dont les éléments ne sont pas définis par la loi, ou pour les contraventions dont les éléments ne sont pas définis par le règlement ».",
                ),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "C’est un principe essentiel sur lequel repose l’ensemble du droit pénal. "
                "Si la norme suprême est la Constitution de 1958, les sources essentielles du droit pénal sont la loi "
                "ainsi que les textes qui lui sont assimilés, et le règlement.",
              ),
              const SizedBox(height: 14),

              const _SubTitle(
                "1.1 — LES LOIS PROPREMENT DITES ET TEXTES ASSIMILÉS",
              ),
              _Paragraph.rich([
                redLaw("L’article 111-2 du Code pénal"),
                normal(
                  " dispose que la loi détermine les crimes et délits et fixe les peines applicables à leurs auteurs.",
                ),
              ]),
              const SizedBox(height: 10),
              const _Paragraph("Certains actes ont aussi valeur de loi :"),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Décisions présidentielles prises en vertu de l’article 16 de la Constitution.",
              ),
              const _BulletPoint(
                text:
                    "Ordonnances, essentiellement celles prises en application de l’article 38 de la Constitution, ratifiées par le Parlement.",
              ),
              const _BulletPoint(
                text: "Décrets-lois (IIIe et IVe Républiques).",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                redLaw("L’article 34 de la Constitution de 1958"),
                normal(
                  " précise que la loi fixe les règles concernant la détermination des crimes et délits, ainsi que les peines qui leur sont applicables.",
                ),
              ]),
              const SizedBox(height: 14),

              const _SubTitle(
                "1.2 — LES TRAITÉS INTERNATIONAUX OU CONVENTIONS INTERNATIONALES",
              ),
              const _Paragraph(
                "Selon la Constitution de 1958, les conventions internationales négociées par le Président de la République, "
                "signées par la France, ratifiées et publiées au Journal officiel ont une valeur supérieure à la loi interne.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                normal("C’est le sens de "),
                redLaw("l’article 55 de la Constitution"),
                normal(
                  ". Les plus importants sont notamment le Traité de Rome instituant la Communauté économique européenne "
                  "et la Convention européenne des droits de l’Homme. Le juge pénal français doit écarter le texte qui méconnaît une disposition du traité.",
                ),
              ]),
              const SizedBox(height: 14),

              const _SubTitle("1.3 — LES RÈGLEMENTS ADMINISTRATIFS"),
              _Paragraph.rich([
                normal(
                  "Ils émanent du pouvoir exécutif (gouvernement) en vertu de ",
                ),
                redLaw("l’article 37 de la Constitution de 1958"),
                normal(
                  ". Ils sont hiérarchisés et ne peuvent aller à l’encontre de la loi.",
                ),
              ]),
              const SizedBox(height: 10),

              const _SubTitle("1.3.1 — Les décrets en Conseil d’État"),
              _Paragraph.rich([
                redLaw("L’article 111-2 alinéa 2 du Code pénal"),
                normal(
                  " dispose : « Le règlement détermine les contraventions et fixe les peines applicables aux contrevenants ».",
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                normal(
                  "Les contraventions, notamment au Code de la route, sont déterminées par des décrets pris en cette forme (",
                ),
                redLaw("articles R. 610-1 et suivants du Code pénal"),
                normal(")."),
              ]),
              const SizedBox(height: 14),

              const _SubTitle("1.3.2 — Les autres règlements"),
              const _Paragraph(
                "Il s’agit des décrets émanant du Président de la République ou du Premier ministre, "
                "des arrêtés pris par les ministres, les préfets, les maires.",
              ),
              const SizedBox(height: 10),
              const _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Tant qu’un décret d’application prévu par une loi pour en permettre la mise en vigueur n’est pas paru, cette loi reste lettre morte.",
                  ),
                ],
              ),
              const SizedBox(height: 14),

              const _SubTitle("1.4 — LES CIRCULAIRES"),
              const _Paragraph(
                "Ce sont des « instructions de service écrites adressées par une autorité supérieure à des agents subordonnés » "
                "(Direction des Affaires criminelles et des grâces). Elles ne sont pas source de droit pénal.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                normal(
                  "Les circulaires et instructions sont publiées sur un site relevant du Premier ministre. Elles sont réputées abrogées si elles n’ont pas été publiées (",
                ),
                redLaw(
                  "article L. 312-2 du Code des relations entre le public et l’administration",
                ),
                normal(")."),
              ]),
              const SizedBox(height: 14),

              const _SubTitle("1.5 — LA JURISPRUDENCE ET LA DOCTRINE"),
              const _BulletPoint(
                text:
                    "La jurisprudence est l’ensemble des décisions rendues par les tribunaux, et plus particulièrement par la Cour de cassation. Le principe de l’interprétation restrictive de la loi pénale a pour but d’empêcher la jurisprudence de devenir une source de droit pénal. Cependant, elle a souvent un rôle interprétatif de la règle de droit pénal.",
              ),
              const _BulletPoint(
                text:
                    "La doctrine consiste en l’énoncé des positions de juristes éminents. Elle n’a pas de valeur normative, et ne peut être qu’une source d’inspiration pour le législateur.",
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ========================= CHAPITRE 2 =========================
          _ConditionCard(
            title: "CHAPITRE 2 : L’ÉLÉMENT MATÉRIEL",
            cardColor: cardColor,
            accent: accent,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "L’élément matériel consiste en l’attitude positive ou négative réprimée par la loi : "
                "c’est la manifestation concrète de la volonté délictueuse du délinquant.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Il peut prendre des formes variées : acte positif ou abstention, acte unique ou pluralité d’actes, "
                "acte instantané ou qui se prolonge dans le temps.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "La seule pensée criminelle n’est pas répréhensible si elle n’est pas matérialisée concrètement. "
                "Ainsi, la résolution criminelle (décision de commettre l’infraction) n’est pas punissable : "
                "il n’existe pas de manifestation extérieure d’une conduite répréhensible ; on est au stade de la pure intention.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Les actes préparatoires échappent également à la répression (ex : collecter des renseignements précis sur les habitudes d’une victime…). "
                "Ils peuvent être équivoques et la personne peut encore se désister.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "L’infraction consommée ne soulève pas de problème. En revanche, peut-on réprimer des actes qui, "
                "sans aller jusqu’à la réalisation complète de l’infraction, manifestent une volonté criminelle ? "
                "C’est la tentative.",
              ),
              const SizedBox(height: 14),

              const _SubTitle("2.1 — LA TENTATIVE PUNISSABLE"),
              _Paragraph.rich([
                redLaw("L’article 121-5 du Code pénal"),
                normal(
                  " dispose : « la tentative est constituée dès lors que, manifestée par un commencement d’exécution, "
                  "elle n’a été suspendue ou n’a manqué son effet qu’en raison de circonstances indépendantes de la volonté de son auteur ».",
                ),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "Pour qu’il y ait tentative, il faut la réunion de deux éléments : "
                "un commencement d’exécution et une absence de désistement volontaire.",
              ),
              const SizedBox(height: 14),

              const _SubTitle("2.1.1 — Le commencement d’exécution"),
              const _SubTitle("2.1.1.1 — Définition"),
              const _Paragraph(
                "Il est nécessaire de distinguer le commencement d’exécution des actes préparatoires qui, eux, ne sont pas punissables. "
                "Le Code pénal ne donne pas de définition du commencement d’exécution.",
              ),
              const SizedBox(height: 12),

              const _SubTitle("2.1.1.2 — La position jurisprudentielle"),
              const _Paragraph(
                "La Cour de cassation estime que la notion de commencement d’exécution est une question de droit soumise à son contrôle. "
                "Elle exige toujours la présence d’un double élément pour admettre l’existence d’un commencement d’exécution :",
              ),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Un acte univoque, caractéristique d’un commencement d’exécution.",
              ),
              const _BulletPoint(
                text:
                    "Une intention irrévocable de réaliser telle infraction précise.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "On est en présence d’un commencement d’exécution lorsque le comportement de l’agent traduit sans ambiguïté "
                "sa volonté de commettre l’infraction.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Dans l’affaire Lacour (Cass. crim. 5/10/1962), la Cour de cassation a décidé que le fait de payer un homme de main "
                "pour commettre un assassinat, et de lui communiquer des renseignements dans ce but, ne constituait pas un commencement d’exécution.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Caractérise la tentative d’évasion le fait, pour des détenus, de commencer à creuser le béton autour de la fenêtre de leur cellule "
                "afin de provoquer le descellement des barreaux (CA Douai 11/08 et 21/09/2004).",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "En revanche, le simple fait d’extérioriser oralement son intention de commettre une infraction n’est pas punissable, "
                "puisque rien ne prouve que l’intéressé passera à l’action.",
              ),
              const SizedBox(height: 14),

              const _SubTitle("2.1.2 — L’absence de désistement volontaire"),
              const _SubTitle("2.1.2.1 — La notion de désistement"),
              _Paragraph.rich([
                redLaw("L’article 121-5 du Code pénal"),
                normal(
                  " précise que la tentative est punissable uniquement si « elle n’a été suspendue (…) qu’en raison de circonstances indépendantes de la volonté de son auteur ».",
                ),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "Si l’interruption de l’action est volontaire (renonciation sans cause extérieure), l’auteur n’est pas punissable. "
                "Peu importe la cause (pitié, remords, crainte du châtiment…).",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Lorsqu’il est déterminé par une cause extérieure, le désistement est involontaire : la tentative est alors punissable "
                "(intervention de la police, passants, résistance de la victime, obstacle matériel : alarme, résistance d’un coffre-fort…).",
              ),
              const SizedBox(height: 14),

              const _SubTitle("2.1.2.2 — Le repentir actif"),
              const _Paragraph(
                "Le désistement doit être antérieur à la consommation de l’infraction. Pour bénéficier de l’impunité, "
                "le délinquant doit abandonner son projet criminel avant la réalisation de l’infraction.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Une fois l’infraction consommée, l’attitude postérieure est sans influence sur la responsabilité pénale "
                "(ex : restitution après un abus de confiance).",
              ),
              const SizedBox(height: 14),

              const _SubTitle("2.1.3 — Le régime juridique de la tentative"),
              _Paragraph.rich([
                normal("Toutes les tentatives ne sont pas punissables. "),
                redLaw("L’article 121-4 du Code pénal"),
                normal(
                  " prévoit que la tentative est systématiquement poursuivie en matière de crime. "
                  "Elle ne peut l’être en matière de délit que si le texte d’incrimination le spécifie. "
                  "La tentative de contravention n’est jamais punissable.",
                ),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "L’auteur d’une tentative est assimilé entièrement, quant à la répression, à l’auteur d’une infraction consommée.",
              ),
              const SizedBox(height: 14),

              const _SubTitle("2.2 — LA TENTATIVE INFRUCTUEUSE"),
              const _Paragraph(
                "L’auteur a fait tout ce qui était en son pouvoir pour que l’infraction se réalise, "
                "celle-ci n’ayant échoué qu’indépendamment de sa volonté et sans intervention extérieure.",
              ),
              const SizedBox(height: 12),

              const _SubTitle("2.2.1 — L’infraction manquée"),
              const _SubTitle("2.2.1.1 — Définition"),
              const _Paragraph(
                "L’infraction manquée suppose une exécution complète des éléments de l’infraction qui ne réussit pas "
                "à la suite de circonstances indépendantes de la volonté de l’auteur.",
              ),
              const SizedBox(height: 8),
              const _IntroBullet(
                text:
                    "Ex : celui qui tire un coup de feu, mais du fait de sa maladresse rate sa victime.",
              ),
              const SizedBox(height: 10),
              const _SubTitle("2.2.1.2 — Répression"),
              _Paragraph.rich([
                normal(
                  "L’infraction manquée est punie comme l’infraction tentée. ",
                ),
                redLaw("L’article 121-5 du Code pénal"),
                normal(
                  " vise la tentative qui « n’a manqué son effet qu’en raison de circonstances indépendantes de la volonté de son auteur ».",
                ),
              ]),
              const SizedBox(height: 14),

              const _SubTitle("2.2.2 — L’infraction impossible"),
              const _SubTitle("2.2.2.1 — Définition"),
              const _Paragraph(
                "L’auteur a mis tous les moyens en œuvre pour accomplir l’infraction, mais celle-ci ne pouvait se réaliser "
                "en raison d’une impossibilité qu’il ignorait.",
              ),
              const SizedBox(height: 8),
              const _Paragraph(
                "Les causes d’impossibilité peuvent être diverses : tenir à l’objet (poche vide), aux moyens inefficaces (coup de feu tiré à blanc)…",
              ),
              const SizedBox(height: 10),
              const _SubTitle("2.2.2.2 — Répression"),
              const _Paragraph(
                "Le cas de l’infraction impossible n’étant pas prévu par la loi, sa répression ne peut se faire que dans le cadre de la tentative. "
                "Elle n’est donc punissable que lorsque la tentative est incriminée (crime et certains délits).",
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ========================= CHAPITRE 3 =========================
          _ConditionCard(
            title: "CHAPITRE 3 : L’ÉLÉMENT MORAL",
            cardColor: cardColor,
            accent: accent,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Il n’y a pas d’infraction sans élément moral : l’acte répréhensible doit être issu de la volonté de son auteur.",
              ),
              const SizedBox(height: 12),

              const _SubTitle("3.1 — DÉFINITION"),
              const _Paragraph(
                "Pour qu’une infraction soit constituée, il est nécessaire qu’existe un dol général : "
                "la conscience ou la volonté d’accomplir un acte illicite.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "La jurisprudence, dans un arrêt de la chambre criminelle de la Cour de cassation du 13 décembre 1956, rappelle "
                "que « toute infraction même non intentionnelle suppose que son auteur ait agi avec intelligence et volonté ».",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Le mobile (raison concrète et personnelle) est indifférent au droit pénal : ce qui compte, c’est la conscience de l’illicéité. "
                "En pratique, le juge peut toutefois en tenir compte dans la détermination de la peine.",
              ),
              const SizedBox(height: 14),

              const _SubTitle("3.2 — FORMES DE L’ÉLÉMENT MORAL"),
              const _SubTitle("3.2.1 — La faute intentionnelle"),
              const _Paragraph(
                "L’auteur a conscience du caractère illicite de son acte et a la volonté de l’accomplir et de produire un résultat dommageable.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                redLaw("L’article 121-3 du Code pénal"),
                normal(
                  " dispose qu’ « il n’y a point de crime ou délit sans intention de le commettre ».",
                ),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "Les infractions pour lesquelles l’élément moral est une faute intentionnelle sont des infractions intentionnelles.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Parfois, la loi exige une intention particulière : c’est le dol spécial (ex : intention de tuer pour le meurtre, volonté de détruire pour la destruction de biens…).",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Le dol peut être aggravé : la préméditation est une forme aggravée d’intention criminelle.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Dol déterminé : le résultat obtenu correspond à celui voulu. Dol indéterminé : le résultat n’est pas connu à l’avance, la sanction dépend du résultat réellement produit.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                normal(
                  "Dol praeter intentionnel : le résultat va au-delà de ce que l’auteur voulait. Exemple : frapper pour blesser mais tuer finalement : ",
                ),
                redLaw("article 222-7 du Code pénal"),
                normal(
                  " (violences ayant entraîné la mort sans intention de la donner).",
                ),
              ]),
              const SizedBox(height: 14),

              const _SubTitle("3.2.2 — La faute non intentionnelle"),
              const _Paragraph(
                "L’individu ne recherche aucun résultat particulier, mais ne respecte pas les valeurs sociales protégées pénalement.",
              ),
              const SizedBox(height: 12),

              const _SubTitle(
                "3.2.2.1 — La faute d’imprudence ou de négligence",
              ),
              _Paragraph.rich([
                redLaw("L’article 121-3 alinéa 3 du Code pénal"),
                normal(
                  " dispose qu’elle consiste en une imprudence, négligence ou manquement à une obligation de prudence ou de sécurité prévue par la loi ou le règlement.",
                ),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "La faute consiste à ne pas avoir prévu qu’un dommage pouvait survenir : l’auteur a fait courir un danger aux autres par son imprudence. "
                "Il n’a ni prévu ni voulu le résultat dommageable.",
              ),
              const SizedBox(height: 12),

              const _SubTitle("3.2.2.1.1 — Formes de la faute"),
              const _Paragraph(
                "Ces fautes s’apprécient par comparaison avec le comportement d’un individu « normalement » adroit, attentif, prudent et diligent. "
                "Pour un professionnel, on se réfère au professionnel moyen ou diligent.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "La faute pénale peut aussi résider dans la violation d’un texte : manquement à une obligation de prudence ou de sécurité prévue par la loi ou le règlement.",
              ),
              const SizedBox(height: 12),

              const _SubTitle("3.2.2.1.2 — Existence d’un lien de causalité"),
              const _Paragraph(
                "Si le lien de causalité est direct, toute imprudence, négligence ou manquement suffit. "
                "Si la causalité est indirecte, il faut prouver une faute caractérisée.",
              ),
              const SizedBox(height: 14),

              const _SubTitle(
                "3.2.2.2 — La faute de mise en danger délibérée de la personne d’autrui",
              ),
              const _Paragraph(
                "La personne a délibérément pris un risque en espérant qu’aucun dommage n’en résulterait.",
              ),
              const SizedBox(height: 8),
              const _IntroBullet(
                text:
                    "Exemple : entrepreneur qui fait monter ses ouvriers sur un échafaudage en sachant qu’il n’est pas conforme aux normes de sécurité.",
              ),
              const SizedBox(height: 10),
              const _Paragraph("Elle suppose :"),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Soit une violation manifestement délibérée d’une législation ou d’une réglementation comportant des prescriptions de sécurité ou de prudence.",
              ),
              const _BulletPoint(
                text:
                    "Soit une faute caractérisée exposant autrui à un risque d’une particulière gravité qu’il n’était pas possible d’ignorer.",
              ),
              const SizedBox(height: 14),

              const _SubTitle("3.2.2.3 — La faute contraventionnelle"),
              const _Paragraph(
                "Elle consiste en la simple violation de la prescription légale ou réglementaire. "
                "Elle est indépendante de la survenance d’un dommage : le simple fait de commettre l’acte interdit suffit.",
              ),
              const SizedBox(height: 8),
              const _IntroBullet(
                text:
                    "Ex : individu qui grille un feu rouge et explique qu’il n’a pas vu qu’il était rouge.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "La responsabilité de l’auteur pourra être écartée s’il prouve la contrainte ou la force majeure.",
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ========================= TABLEAUX (repris en texte structuré) =========================
          _ConditionCard(
            title: "SYNTHÈSE — ÉLÉMENT MATÉRIEL : CONDITIONS",
            cardColor: cardColor,
            accent: accent,
            titleColor: textMain,
            children: const [
              _SubTitle("ÉLÉMENT MATÉRIEL"),
              _Paragraph("ACTE POSITIF :"),
              SizedBox(height: 6),
              _BulletPoint(text: "Une action physique de l’auteur"),
              _BulletPoint(text: "Un résultat"),
              _BulletPoint(text: "Un lien de causalité action / résultat"),
              SizedBox(height: 10),
              _Paragraph("ACTE NÉGATIF :"),
              SizedBox(height: 6),
              _BulletPoint(
                text: "Attitude passive dont il est résulté un dommage",
              ),
              SizedBox(height: 10),
              _SubTitle("TYPOLOGIE"),
              _BulletPoint(
                text:
                    "Infraction de commission : l’individu commet un acte interdit par la loi.",
              ),
              _BulletPoint(
                text:
                    "Infraction d’omission : l’individu omet de réaliser un acte prévu par la loi.",
              ),
              _BulletPoint(text: "Infraction de commission par omission."),
            ],
          ),

          const SizedBox(height: 16),

          _ConditionCard(
            title: "SYNTHÈSE — ÉLÉMENT MORAL",
            cardColor: cardColor,
            accent: accent,
            titleColor: textMain,
            children: const [
              _SubTitle("INTENTION COUPABLE"),
              _BulletPoint(text: "Faute intentionnelle"),
              SizedBox(height: 10),
              _SubTitle("PAS D’INTENTION COUPABLE"),
              _BulletPoint(text: "Faute non intentionnelle"),
              SizedBox(height: 12),
              _SubTitle("DOL GÉNÉRAL"),
              _Paragraph(
                "Volonté d’accomplir un acte en sachant qu’il est défendu par la loi.",
              ),
              SizedBox(height: 10),
              _SubTitle("DOL SPÉCIAL"),
              _Paragraph(
                "Volonté d’accomplir les faits tels qu’ils sont décrits par la loi.",
              ),
              SizedBox(height: 12),
              _SubTitle("FAUTE D’IMPRUDENCE"),
              _Paragraph(
                "Consiste en : maladresse, imprudence, inattention, négligence, manquement à une obligation de prudence ou de sécurité.",
              ),
              SizedBox(height: 12),
              _SubTitle("FAUTE CONTRAVENTIONNELLE"),
              _Paragraph(
                "Elle est présumée et consiste dans la violation de la prescription légale ou réglementaire.",
              ),
            ],
          ),

          const SizedBox(height: 18),
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
