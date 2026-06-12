import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaDroitsObligationsPoliciersPage extends StatelessWidget {
  const PaDroitsObligationsPoliciersPage({super.key});

  static const String routeName =
      '/pa/institution/deontologie/droits_obligations';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardMat = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
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
          "Déontologie",
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
            "Les droits et obligations des policiers",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Contexte
          _ConditionCard(
            title: "Contexte",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le Code général de la fonction publique (CGFP) garantit des droits et fixe des obligations aux agents publics. "
                "Qu’ils soient fonctionnaires ou agents contractuels (ex. policiers adjoints), les policiers y sont soumis.\n\n"
                "D’autres textes (CSI, RGEPN…) prévoient des dispositions spécifiques à la fonction policière. "
                "Le respect des valeurs du code de déontologie conditionne la légitimité et l’efficacité de l’action policière.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Références / “élément légal” en haut
          _ConditionCard(
            title: "Références principales",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _SubTitle("Textes de base"),
              _IntroBullet(
                text:
                    "Code général de la fonction publique (CGFP) : droits & obligations des agents publics.",
              ),
              _IntroBullet(
                text:
                    "Code de la sécurité intérieure (CSI) : règles déontologiques et particularités policières.",
              ),
              _IntroBullet(
                text:
                    "Règlement général d’emploi de la Police nationale (RGEPN) : cadre interne (hiérarchie, réserve, discipline…).",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Avant la prise de fonctions, tout agent de la Police nationale prête serment : servir avec dignité et loyauté la République, ses principes et sa Constitution.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // I — Droits et obligations “fonction publique”
          _ConditionCard(
            title: "I — Statut de la fonction publique",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Cette partie regroupe les garanties et obligations applicables à tous les agents publics, "
                "avec des points d’attention propres à la fonction policière.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // A — Garanties générales
          _ConditionCard(
            title: "A) Garanties générales (droits)",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _SubTitle("1) Liberté d’opinion"),
              _Paragraph.rich([
                TextSpan(text: "Garantie par le "),
                TextSpan(
                  text: "CGFP (art. L. 111-1 et L. 137-2)",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : la liberté d’opinion est garantie aux agents publics.",
                ),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    "Les opinions (politiques, syndicales, religieuses, philosophiques) ne doivent pas figurer dans le dossier individuel.",
              ),

              SizedBox(height: 12),

              _SubTitle("2) Liberté d’expression"),
              _Paragraph.rich([
                TextSpan(text: "Prévue par le "),
                TextSpan(
                  text: "CGFP (art. L. 121-2)",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    "Dans le service : neutralité = liberté d’expression exclue dans l’exercice des fonctions.",
              ),
              _BulletPoint(
                text:
                    "Hors service : liberté relative (opinions, engagements, manifestations…), avec limite = obligation de réserve.",
              ),

              SizedBox(height: 12),

              _SubTitle("3) Non-discrimination"),
              _Paragraph.rich([
                TextSpan(text: "Interdiction via le "),
                TextSpan(
                  text: "CGFP (art. L. 131-1 à L. 131-6, L. 133-1, L. 133-2)",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text: " : aucune distinction directe/indirecte.",
                ),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    "Aucune discrimination (opinions, origine, orientation/identité de genre, âge, situation familiale, grossesse, santé, apparence, handicap…).",
              ),
              _BulletPoint(text: "Aucune distinction en raison du sexe."),
              _BulletPoint(
                text: "Aucun agent ne doit subir d’agissement sexiste.",
              ),

              SizedBox(height: 12),

              _SubTitle("4) Droit syndical"),
              _Paragraph.rich([
                TextSpan(text: "Reconnu notamment par "),
                TextSpan(
                  text: "CSI (art. L. 411-3)",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: "CGFP (art. L. 113-1)",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: ", avec cadre "),
                TextSpan(
                  text: "décret n° 82-447 du 28 mai 1982",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " + références RGEPN."),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    "Créer/adhérer/exercer des mandats syndicaux : oui, dans la défense des intérêts professionnels.",
              ),
              _BulletPoint(
                text:
                    "Respect du secret professionnel et du secret de l’enquête et de l’instruction.",
              ),
              _BulletPoint(
                text:
                    "Activité syndicale compatible avec le code de déontologie et le fonctionnement du service.",
              ),

              SizedBox(height: 12),

              _SubTitle("5) Protection fonctionnelle"),
              _Paragraph.rich([
                TextSpan(text: "Prévue par le "),
                TextSpan(
                  text: "CGFP (art. L. 134-1 à L. 134-11)",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " et par le "),
                TextSpan(
                  text: "CSI (art. R. 434-7)",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    "L’État défend l’agent contre attaques, menaces, violences, injures, diffamations, outrages…",
              ),
              _BulletPoint(
                text:
                    "Peut concerner aussi conjoint, enfants et ascendants directs.",
              ),
              _BulletPoint(
                text:
                    "Si absence de faute personnelle : accompagnement et protection juridique en cas de poursuites.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // B — Obligations générales
          _ConditionCard(
            title: "B) Obligations générales",
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              const _SubTitle("1) Obéissance hiérarchique"),
              const _Paragraph.rich([
                TextSpan(text: "Principe posé par "),
                TextSpan(
                  text: "CGFP (art. L. 121-10)",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: ", "),
                TextSpan(
                  text: "CSI (art. R. 434-5)",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " et références statutaires."),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Se conformer aux instructions du supérieur hiérarchique.",
              ),
              const _BulletPoint(
                text:
                    "Exception : ordre manifestement illégal et compromettant gravement un intérêt public.",
              ),
              const _Paragraph(
                "Idée clé : la légalité prime sur le devoir d’obéissance (discipline + loyauté attendues).",
              ),

              const SizedBox(height: 12),

              const _SubTitle("2) Secret professionnel & discrétion"),
              const _Paragraph.rich([
                TextSpan(text: "Fondé sur "),
                TextSpan(
                  text: "CGFP (art. L. 121-6 et L. 121-7)",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: ", et renforcé par "),
                TextSpan(
                  text: "RGEPN (113-10, 133-6)",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " + "),
                TextSpan(
                  text: "CSI (art. R. 434-8 et R. 434-12)",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "La violation expose à sanctions pénales + disciplinaires, et peut engager la responsabilité civile.",
              ),
              const _BulletPoint(
                text:
                    "Respect du secret de l’enquête et de l’instruction + discrétion professionnelle.",
              ),
              const _BulletPoint(
                text:
                    "Interdiction de divulguer à une personne non autorisée (même en interne) des infos connues du fait des fonctions.",
              ),
              const SizedBox(height: 10),
              const _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Réseaux sociaux / blogs : l’usage doit rester compatible avec ces obligations. Ne pas rendre visibles des renseignements professionnels (opérations, modalités d’intervention, photos/propos portant atteinte à l’institution…).",
                  ),
                ],
              ),

              const SizedBox(height: 12),

              const _SubTitle("3) Probité"),
              const _Paragraph.rich([
                TextSpan(text: "Prévue par "),
                TextSpan(
                  text: "CGFP (art. L. 121-1)",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: "CSI (art. R. 434-9)",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " : agir avec désintéressement."),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Interdiction d’intérêts personnels opposés (même indirectement) à ceux de l’administration.",
              ),
              const _BulletPoint(
                text:
                    "Interdiction de se prévaloir de sa qualité pour obtenir un avantage personnel.",
              ),
              const SizedBox(height: 10),
              _ConditionCard(
                title: "Infractions pénales typiques liées à la probité",
                cardColor: isDark
                    ? const Color(0xFF1B1B1B)
                    : const Color(0xFFFFFFFF),
                accent: accentGrey,
                titleColor: textMain,
                children: const [
                  _Paragraph.rich([
                    TextSpan(text: "• Corruption — "),
                    TextSpan(
                      text: "art. 432-11 1° du Code pénal",
                      style: TextStyle(
                        color: _lawRed,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    TextSpan(text: "."),
                  ]),
                  _Paragraph.rich([
                    TextSpan(text: "• Trafic d’influence — "),
                    TextSpan(
                      text: "art. 432-11 2° du Code pénal",
                      style: TextStyle(
                        color: _lawRed,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    TextSpan(text: "."),
                  ]),
                  _Paragraph.rich([
                    TextSpan(text: "• Concussion — "),
                    TextSpan(
                      text: "art. 432-10 du Code pénal",
                      style: TextStyle(
                        color: _lawRed,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    TextSpan(text: "."),
                  ]),
                  _Paragraph.rich([
                    TextSpan(text: "• Prise illégale d’intérêts — "),
                    TextSpan(
                      text: "art. 432-12 du Code pénal",
                      style: TextStyle(
                        color: _lawRed,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    TextSpan(text: "."),
                  ]),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // II — Particularismes policiers
          _ConditionCard(
            title: "II — Particularismes statutaires (fonction policière)",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Ces règles renforcent les exigences professionnelles : hiérarchie, réserve, dignité, impartialité, disponibilité… "
                "Elles s’appliquent fortement aux policiers du fait de leurs missions d’ordre public.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "A) Obligations générales (spécifiques police)",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _SubTitle("1) Principe hiérarchique"),
              _Paragraph.rich([
                TextSpan(text: "Références : "),
                TextSpan(
                  text: "CSI (art. R. 434-4)",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " + "),
                TextSpan(
                  text: "RGEPN (111-1, 111-6, 113-1, 131-4, 133-1)",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    "L’autorité hiérarchique donne des instructions précises.",
              ),
              _BulletPoint(
                text:
                    "Le policier rend compte de l’exécution des ordres (ou des raisons de leur inexécution).",
              ),
              _BulletPoint(
                text:
                    "Le policier rend compte de tout fait (service/hors service) pouvant entraîner convocation par autorité de police/juridiction/contrôle.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Policiers adjoints : pas de principe hiérarchique entre eux. Ils sont subordonnés aux personnels sous l’autorité desquels ils sont placés — ",
                  ),
                  TextSpan(
                    text: "art. 131-1 RGEPN",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 12),

              _SubTitle("2) Devoir de réserve"),
              _Paragraph.rich([
                TextSpan(text: "Références : "),
                TextSpan(
                  text: "RGEPN (113-10, 133-6)",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: "CSI (art. R. 434-29)",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    "Plus stricte chez les policiers : modération dans l’expression des opinions en service et hors service.",
              ),
              _BulletPoint(
                text:
                    "Un manque de retenue peut entraîner des sanctions disciplinaires.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Les fonctionnaires candidats ou investis de responsabilités syndicales disposent d’une plus grande liberté d’expression.",
                  ),
                ],
              ),

              SizedBox(height: 12),

              _SubTitle(
                "3) Interdiction de faire grève (personnels actifs)",
              ),
              _Paragraph.rich([
                TextSpan(text: "Référence : "),
                TextSpan(
                  text: "CGFP (art. L. 114-3)",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    "Disposition dérogatoire justifiée par l’ordre public : toute cessation concertée ou acte collectif d’indiscipline caractérisé peut être sanctionné.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: "Policiers adjoints : droit de grève admis — ",
                  ),
                  TextSpan(
                    text: "RGEPN (133-28)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 12),

              _SubTitle("4) Dignité"),
              _Paragraph.rich([
                TextSpan(text: "Références : "),
                TextSpan(
                  text: "CGFP (art. L. 121-1)",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: ", "),
                TextSpan(
                  text: "RGEPN (133-2, 133-7)",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: ", "),
                TextSpan(
                  text: "CSI (art. R. 434-12)",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    "Comportement exemplaire en toute circonstance (service/hors service), y compris sur les réseaux sociaux.",
              ),
              _BulletPoint(
                text:
                    "S’abstenir d’actes/propos/comportements nuisant à la considération portée à l’institution.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Exemple jurisprudentiel : révocation d’un GPX pour des échanges racistes/discriminatoires via messagerie. ",
                  ),
                  TextSpan(
                    text: "(C.E., n° 474289, 28/12/2023)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 12),

              _SubTitle("5) Indépendance"),
              _Paragraph.rich([
                TextSpan(text: "Références : "),
                TextSpan(
                  text: "décret n° 95-654 (art. 59 et 60)",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: ", "),
                TextSpan(
                  text: "RGEPN (113-12, 113-13)",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: ", "),
                TextSpan(
                  text: "CSI (art. R. 434-12)",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    "Interdiction de se prévaloir de sa qualité pour collecter des fonds/dons ou mandater un intermédiaire.",
              ),
              _BulletPoint(
                text:
                    "Interdiction de diffuser dans les locaux de police des publications/tracts à caractère raciste, xénophobe, politique, appelant à l’indiscipline…",
              ),

              SizedBox(height: 12),

              _SubTitle("6) Discernement & impartialité"),
              _Paragraph.rich([
                TextSpan(text: "Références : "),
                TextSpan(
                  text: "CSI (art. R. 434-10 et R. 434-11)",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    "Choisir la meilleure réponse légale selon les risques/menaces et les délais d’action.",
              ),
              _BulletPoint(
                text:
                    "Agir avec professionnalisme : équité, neutralité, laïcité, sans discrimination.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "B) Obligations spécifiques (exemples)",
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _SubTitle("1) Activité du conjoint / concubin"),
              _Paragraph.rich([
                TextSpan(text: "Références : "),
                TextSpan(
                  text: "décret n° 95-654 (art. 30)",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: "RGEPN (111-6)",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _Paragraph(
                "L’autorité compétente peut prendre des mesures pour sauvegarder l’intérêt du service si l’activité du conjoint/concubin "
                "jette le discrédit sur la fonction policière ou crée une équivoque préjudiciable.",
              ),

              SizedBox(height: 12),

              _SubTitle("2) Disponibilité"),
              _Paragraph(
                "Le policier doit se rendre disponible tout au long du service, en conservant une attitude d’intérêt face aux demandes "
                "(information, assistance, intervention).",
              ),

              SizedBox(height: 12),

              _SubTitle("3) Obligation de résidence"),
              _Paragraph.rich([
                TextSpan(text: "Référence : "),
                TextSpan(
                  text: "décret n° 95-654 (art. 24)",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    "Résider au lieu d’affectation (ou à distance permettant rappel inopiné dans les délais les plus brefs).",
              ),
              _BulletPoint(
                text:
                    "Tout changement de résidence doit être signalé par voie hiérarchique, avec date.",
              ),

              SizedBox(height: 12),

              _SubTitle("4) Obligation d’agir même hors service"),
              _Paragraph.rich([
                TextSpan(text: "Références : "),
                TextSpan(
                  text: "décret n° 95-654 (art. 19)",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: ", "),
                TextSpan(
                  text: "CSI (art. R. 434-19)",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: ", "),
                TextSpan(
                  text: "RGEPN (113-3, 132-2, 133-3)",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    "Devoir d’intervenir de sa propre initiative ou sur réquisition (aide à personne en danger, prévention/répression des troubles à l’ordre public, protection personnes & biens).",
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Cela va au-delà de l’assistance à personne en péril du ",
                ),
                TextSpan(
                  text: "Code pénal (art. 223-6)",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Les textes n’imposent pas « l’héroïsme à tout prix » : le policier conserve une marge d’appréciation (moyens, moment d’intervention…).",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // III — Cumul d’activité
          _ConditionCard(
            title: "III — Cumul d’activité",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph.rich([
                TextSpan(text: "Cadre : "),
                TextSpan(
                  text: "décret n° 2020-69 du 30/01/2020",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " — principe : l’agent public consacre l’intégralité de son activité professionnelle aux tâches confiées.",
                ),
              ]),
              SizedBox(height: 12),
              _SubTitle("A) Activités privées strictement interdites"),
              _Paragraph.rich([
                TextSpan(text: "Référence : "),
                TextSpan(
                  text: "CGFP (art. L. 123-1)",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    "Participation à la direction de sociétés/associations à but lucratif.",
              ),
              _BulletPoint(
                text:
                    "Consultations/expertises/plaidoiries contre une personne publique (sauf exception).",
              ),
              _BulletPoint(
                text:
                    "Prise/détention d’intérêts compromettant l’indépendance dans une entreprise en lien/contrôle avec l’administration.",
              ),
              _BulletPoint(
                text:
                    "Création/reprise d’entreprise (certaines formes/inscriptions) selon le texte.",
              ),
              _BulletPoint(
                text:
                    "Cumul d’un emploi permanent à temps complet avec un ou plusieurs autres emplois permanents à temps complet.",
              ),

              SizedBox(height: 12),

              _SubTitle("B) Activités librement autorisées"),
              _Paragraph.rich([
                TextSpan(text: "Référence : "),
                TextSpan(
                  text: "CGFP (art. L. 123-2)",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    "Gestion du patrimoine personnel/familial (limite : devenir dirigeant/gérant/commerçant).",
              ),
              _BulletPoint(
                text:
                    "Production d’œuvres de l’esprit (si compatible déontologie et réelle production).",
              ),
              _BulletPoint(
                text:
                    "Activité bénévole au profit de personnes publiques ou privées sans but lucratif.",
              ),

              SizedBox(height: 12),

              _SubTitle("C) Activités soumises à autorisation"),
              _Paragraph.rich([
                TextSpan(text: "Référence : "),
                TextSpan(
                  text: "CGFP (art. L. 123-8 et L. 123-7)",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    "Création/reprise d’entreprise avec service à temps partiel (durée max 3 ans + 1 an).",
              ),
              _BulletPoint(
                text:
                    "Activités accessoires possibles (enseignement, expertise, sport/culture, services à la personne, vente de biens produits personnellement…).",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Limites police : l’activité ne doit pas porter atteinte au fonctionnement, à l’indépendance, ni à la neutralité du service, "
                        "et ne doit pas placer l’agent en situation de méconnaître la prise illégale d’intérêts — ",
                  ),
                  TextSpan(
                    text: "Code pénal (art. 432-12)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 12),

              _SubTitle("D) Formalisme de la demande"),
              _BulletPoint(
                text:
                    "Demande écrite à l’autorité hiérarchique (accusé de réception).",
              ),
              _BulletPoint(
                text: "Tout changement substantiel = nouvelle demande.",
              ),
              _BulletPoint(
                text:
                    "L’administration peut s’opposer à tout moment si l’intérêt du service le justifie (activité plus accessoire, infos erronées, etc.).",
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
                    : const Color(0xFF1F1F1F).withValues(alpha: .92),
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
