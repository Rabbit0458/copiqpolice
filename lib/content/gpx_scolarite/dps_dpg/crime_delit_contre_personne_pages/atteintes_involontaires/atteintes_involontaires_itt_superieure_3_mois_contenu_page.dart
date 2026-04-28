import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AtteintesInvolontairesIttSuperieure3MoisPage extends StatelessWidget {
  const AtteintesInvolontairesIttSuperieure3MoisPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
    final Color cardDef = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardMat = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardMoral = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardAggr = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardRep = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);

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
          "Atteintes involontaires",
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
            "Atteintes involontaires à l’intégrité de la personne\n(I.T.T. > 3 mois)",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Définition
          _ConditionCard(
            title: "Définition",
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le fait de causer à autrui, dans les conditions et selon les distinctions prévues à l’article 121-3, "
                "par maladresse, imprudence, inattention, négligence ou manquement à une obligation de sécurité ou de prudence "
                "imposée par la loi ou le règlement, une incapacité totale de travail pendant plus de trois mois, constitue une infraction.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: "I — Élément légal",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(text: "Texte d’incrimination : "),
                TextSpan(
                  text: "article 222-19 alinéa 1 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text: " (blessures involontaires avec I.T.T. > 3 mois).",
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Renvoi essentiel : "),
                TextSpan(
                  text: "article 121-3 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " (distinction faute simple / causalité indirecte : faute délibérée ou caractérisée).",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel
          _ConditionCard(
            title: "II — Élément matériel",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Un acte involontaire : la faute"),
              _Paragraph.rich([
                TextSpan(
                  text: "L’article 222-19 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      ", en référence à l’article 121-3, énumère cinq comportements fautifs (liste limitative). "
                      "Les juges doivent caractériser l’un de ces comportements.",
                ),
              ]),
              const SizedBox(height: 10),

              const _SubTitle("1) La faute simple"),
              const _BulletPoint(
                text: "Maladresse, imprudence, inattention, négligence.",
              ),
              const _Paragraph(
                "L’imprudence, la maladresse ou l’inattention consistent à agir sans précautions. "
                "La négligence correspond au fait de ne pas se soucier des conséquences de son abstention.",
              ),
              const SizedBox(height: 8),
              const _Paragraph(
                "Ces fautes sont appréciées par rapport au comportement attendu d’une personne « normalement » "
                "adroite, attentive, prudente et diligente. Le cas échéant, l’appréciation se fait au regard du "
                "professionnel moyen (ou diligent) placé dans la même situation.",
              ),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Manquement à une obligation de sécurité ou de prudence imposée par la loi ou le règlement.",
              ),
              const _Paragraph(
                "Le terme « règlement » vise les actes des autorités administratives à caractère général et impersonnel. "
                "L’inobservation d’une obligation textuelle se suffit en elle-même : il n’est pas nécessaire de se référer "
                "aux devoirs généraux de prudence et de diligence.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Les magistrats doivent pouvoir préciser la source et la nature exacte de l’obligation violée. ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 18 juin 2002)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle("2) La faute caractérisée"),
              const _Paragraph(
                "Si la faute est en lien direct avec le dommage, la faute simple peut suffire. "
                "En cas de causalité indirecte, il faut démontrer une faute délibérée ou caractérisée.",
              ),
              const _Paragraph(
                "La faute caractérisée est une faute lourde exposant autrui à un danger d’une particulière gravité, "
                "et dont l’auteur ne peut ignorer les risques. Elle révèle une gravité supplémentaire (circonstances de l’acte, "
                "fonctions exercées), et apparaît grossière et inacceptable.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudences",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Faute caractérisée : remise volontaire des clés d’un véhicule à une personne sans permis et sous alcool. ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 14 décembre 2010)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: ".\n"),
                  const TextSpan(
                    text:
                        "Médecin du SAMU n’ayant pas posé les bonnes questions. ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 2 décembre 2003)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle("B) Un lien de causalité"),
              const _Paragraph(
                "La faute doit avoir concouru au dommage. La causalité n’a pas à être immédiate : "
                "le dommage peut s’aggraver et s’apprécie dans son dernier état.",
              ),
              const SizedBox(height: 10),

              const _SubTitle("1) Causalité indirecte"),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 121-3 alinéa 4 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : auteurs indirects = personnes qui ont créé ou contribué à créer la situation ayant permis le dommage, "
                      "ou qui n’ont pas pris les mesures permettant de l’éviter.",
                ),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Professionnel de location confiant un scooter des mers à une personne sans permis de navigation (perte de maîtrise : mort et blessures). ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 5 octobre 2004)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "En matière d’accidents du travail, la causalité indirecte peut être retenue contre le chef d’entreprise / directeur d’établissement. ",
                ),
                TextSpan(
                  text: "(Cass. crim., 28 mars 2006)",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Exemples (maire)",
                bodySpans: [
                  const TextSpan(
                    text: "Aire de jeux : buse non fixée écrasant un enfant. ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 20 mars 2001)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: ".\n"),
                  const TextSpan(
                    text:
                        "Pouvoirs de police administrative : absence de réglementation des déplacements de dameuses sur piste de luge. ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 18 mars 2003)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle("2) Causalité directe"),
              const _Paragraph(
                "La circulaire d’application du 11 octobre 2000 évoque une « causalité immédiate » : "
                "frapper/heurter la victime, ou initier/contrôler le mouvement d’un objet ayant heurté la victime.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "La Cour de cassation adopte une approche plus large : peut relever de la causalité directe celui dont le comportement a été un paramètre déterminant du dommage. ",
                ),
                TextSpan(
                  text: "(Cass. crim., 25 septembre 2001)",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 12),

              const _SubTitle("C) Sur la personne d’autrui"),
              const _BulletPoint(text: "Une personne humaine."),
              const _BulletPoint(text: "Une personne vivante."),

              const SizedBox(height: 12),

              const _SubTitle("D) Un dommage"),
              const _Paragraph(
                "Le dommage peut être physique ou psychique : un choc émotionnel peut constituer le résultat. "
                "La victime doit avoir subi une incapacité totale de travail de plus de trois mois.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Élément moral
          _ConditionCard(
            title: "III — Élément moral",
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "L’élément moral n’est pas requis pour les infractions non intentionnelles.",
              ),
              const SizedBox(height: 10),
              const _SubTitle("Exception : violation manifestement délibérée"),
              const _Paragraph(
                "En présence d’une violation manifestement délibérée d’une obligation particulière de sécurité ou de prudence, "
                "il faut établir que l’individu a adopté un comportement risqué en toute connaissance de cause : "
                "conscience des dangers, sans volonté que le dommage se réalise.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes
          _ConditionCard(
            title: "IV — Circonstances aggravantes",
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: "Article 222-19 alinéa 2 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : aggravation en cas de violation manifestement délibérée d’une obligation particulière imposée par la loi ou le règlement.",
                ),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "La violation délibérée d’une circulaire ou du règlement intérieur d’une entreprise ne peut pas constituer la circonstance aggravante.",
              ),
              const SizedBox(height: 14),

              _Paragraph.rich([
                TextSpan(
                  text: "Article 222-19-1 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text: " : trois degrés d’aggravation (conducteur de VTM).",
                ),
              ]),
              const SizedBox(height: 10),
              const _SubTitle("1) Premier degré"),
              const _BulletPoint(
                text:
                    "Lorsque l’atteinte est commise par le conducteur d’un véhicule terrestre à moteur.",
              ),
              const SizedBox(height: 10),
              const _SubTitle("2) Deuxième degré"),
              const _Paragraph(
                "Lorsque le conducteur est auteur d’une violation manifestement délibérée d’une obligation particulière de prudence ou de sécurité, "
                "ou lorsque les blessures involontaires s’accompagnent d’une infraction routière :",
              ),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Conduite en état d’ivresse manifeste / état alcoolique ≥ seuil légal.",
              ),
              const _BulletPoint(
                text: "Refus de se soumettre aux vérifications alcool.",
              ),
              const _BulletPoint(text: "Conduite après usage de stupéfiants."),
              const _BulletPoint(
                text: "Refus de se soumettre aux vérifications stupéfiants.",
              ),
              const _BulletPoint(
                text:
                    "Conduite sans permis / permis annulé, invalidé, suspendu ou retenu.",
              ),
              const _BulletPoint(text: "Excès de vitesse ≥ 50 km/h."),
              const _BulletPoint(text: "Délit de fuite."),
              const SizedBox(height: 10),
              const _SubTitle("3) Troisième degré"),
              const _BulletPoint(
                text:
                    "Lorsque deux ou plusieurs circonstances ci-dessus sont réunies.",
              ),

              const SizedBox(height: 14),

              _Paragraph.rich([
                TextSpan(
                  text: "Article 222-19-2 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : trois degrés d’aggravation (agression par un chien).",
                ),
              ]),
              const SizedBox(height: 10),
              const _SubTitle("NOTA (présomption)"),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "L’absence de faute est présumée lorsque l’animal est, au moment des faits, en action de protection d’un troupeau "
                        "et identifié conformément au code rural et de la pêche maritime. ",
                  ),
                  TextSpan(
                    text: "(art. 222-19-2 II du Code pénal)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 12),
              const _SubTitle("1) Premier degré"),
              const _BulletPoint(
                text:
                    "Lorsque l’infraction résulte de l’agression commise par un chien, à l’encontre du propriétaire/détenteur.",
              ),
              const SizedBox(height: 10),
              const _SubTitle("2) Deuxième degré"),
              const _Paragraph(
                "Lorsque l’infraction est commise dans l’une des situations suivantes :",
              ),
              const SizedBox(height: 8),
              const _BulletPoint(
                text: "Propriété ou détention du chien illicite.",
              ),
              const _BulletPoint(
                text:
                    "Propriétaire/détenteur en état d’ivresse manifeste ou sous stupéfiants.",
              ),
              const _BulletPoint(
                text:
                    "Non-exécution des mesures prescrites par le maire pour prévenir le danger.",
              ),
              const _BulletPoint(text: "Absence de permis de détention."),
              const _BulletPoint(
                text: "Absence de justification de vaccination antirabique.",
              ),
              const _BulletPoint(
                text:
                    "Chien de 1ère/2ème catégorie non muselé ou non tenu en laisse par un majeur.",
              ),
              const _BulletPoint(
                text: "Chien ayant fait l’objet de mauvais traitements.",
              ),
              const SizedBox(height: 10),
              const _SubTitle("3) Troisième degré"),
              const _BulletPoint(
                text:
                    "Lorsque deux ou plusieurs circonstances ci-dessus sont réunies.",
              ),

              const SizedBox(height: 14),

              _Paragraph.rich([
                TextSpan(
                  text: "Article 434-10 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : aggravation lorsque les blessures sont suivies d’un délit de fuite (hors cas déjà prévus à l’article 222-19-1).",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité
          _ConditionCard(
            title: "V — Répression",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              const _SubTitle("Peines encourues — personnes physiques"),

              _Paragraph.rich([
                const TextSpan(text: "Qualification simple : "),
                const TextSpan(
                  text: "2 ans d’emprisonnement et 30 000 € d’amende — ",
                ),
                TextSpan(
                  text: "article 222-19 alinéa 1 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text: "Aggravée (violation manifestement délibérée) : ",
                ),
                const TextSpan(
                  text: "3 ans d’emprisonnement et 45 000 € d’amende — ",
                ),
                TextSpan(
                  text: "article 222-19 alinéa 2 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Aggravée (conducteur — 1er degré) : "),
                const TextSpan(
                  text: "3 ans d’emprisonnement et 45 000 € d’amende — ",
                ),
                TextSpan(
                  text: "article 222-19-1 alinéa 1 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Aggravée (conducteur — 2e degré) : "),
                const TextSpan(
                  text: "5 ans d’emprisonnement et 75 000 € d’amende — ",
                ),
                TextSpan(
                  text: "article 222-19-1 alinéa 2 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Aggravée (conducteur — 3e degré) : "),
                const TextSpan(
                  text: "7 ans d’emprisonnement et 100 000 € d’amende — ",
                ),
                TextSpan(
                  text: "article 222-19-1 alinéa 9 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Aggravée (chien — 1er degré) : "),
                const TextSpan(
                  text: "3 ans d’emprisonnement et 45 000 € d’amende — ",
                ),
                TextSpan(
                  text: "article 222-19-2 alinéa 1 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Aggravée (chien — 2e degré) : "),
                const TextSpan(
                  text: "5 ans d’emprisonnement et 75 000 € d’amende — ",
                ),
                TextSpan(
                  text: "article 222-19-2 alinéa 2 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Aggravée (chien — 3e degré) : "),
                const TextSpan(
                  text: "7 ans d’emprisonnement et 100 000 € d’amende — ",
                ),
                TextSpan(
                  text: "article 222-19-2 alinéa 10 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text: "Aggravée (délit de fuite, hors 222-19-1) : ",
                ),
                const TextSpan(text: "doublement des peines — "),
                TextSpan(
                  text: "article 434-10 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("Personnes morales"),
              _Paragraph.rich([
                const TextSpan(text: "Responsabilité pénale prévue par "),
                TextSpan(
                  text: "l’article 222-21 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " (les personnes morales peuvent être responsables même si la causalité est indirecte, en cas de faute simple).",
                ),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "La chambre criminelle retient la responsabilité des personnes morales pour toute faute non intentionnelle "
                        "de leurs organes ou représentants, même si (à défaut de faute délibérée/caractérisée) la responsabilité "
                        "pénale des personnes physiques ne pourrait être recherchée. ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 24 octobre 2000)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 12),

              const _SubTitle("Tentative & complicité"),
              const _BulletPoint(
                text: "Tentative : NON (le résultat n’est pas souhaité).",
              ),
              const _BulletPoint(
                text:
                    "Complicité : NON (jurisprudence exclut la complicité en matière non intentionnelle).",
              ),
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
