import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GPXSchoolResponsabilitePenaleCausesIrresponsabilitePage
    extends StatelessWidget {
  const GPXSchoolResponsabilitePenaleCausesIrresponsabilitePage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/droit_pénale_général_pages/responsabilite_penale/causes_irresponsabilite';

  // ===================== Helpers (articles en rouge) =====================
  TextSpan _red(String s) => TextSpan(
    text: s,
    style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w900),
  );

  TextSpan _t(String s) => TextSpan(text: s);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF121212) : const Color(0xFFF7F7FB);
    final Color textMain = isDark ? Colors.white : const Color(0xFF0B0B0B);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF0B0B0B).withOpacity(.72);

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
          'Causes d’irresponsabilité / atténuation',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 16.2,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 26),
        children: [
          // ========================= HEADER =========================
          Text(
            'Les causes d’irresponsabilité ou d’atténuation de la responsabilité',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21.5,
              height: 1.07,
              color: textMain,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Deux grandes catégories : les causes de non-imputabilité (propres à la personne) '
            'et les faits justificatifs (circonstances extérieures supprimant le caractère infractionnel).',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 18),

          // ========================= INTRO CARD =========================
          _ConditionCard(
            title: 'Idée générale',
            cardColor: isDark
                ? const Color(0xFF1A2430)
                : const Color(0xFFE3F2FD),
            accent: const Color(0xFF1565C0),
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: const [
              _Paragraph(
                "Les causes d’irresponsabilité (ou d’atténuation) se répartissent :\n"
                "• Causes de non-imputabilité : circonstances propres à la personne (trouble psychique, contrainte…).\n"
                "• Faits justificatifs : circonstances extérieures faisant perdre à l’acte son caractère d’infraction.",
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ========================= CHAPITRE 1 =========================
          _ConditionCard(
            title: 'Chapitre 1 — Les causes de non-imputabilité',
            cardColor: isDark
                ? const Color(0xFF20302E)
                : const Color(0xFFE0F2F1),
            accent: const Color(0xFF00897B),
            titleColor: isDark ? Colors.white : const Color(0xFF004D40),
            children: const [
              _IntroBullet(
                text:
                    "Trouble psychique / neuropsychique, contrainte, erreur (droit/fait), minorité…",
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ========================= 1.1 TROUBLE PSYCHIQUE =========================
          _ConditionCard(
            title: '1.1 — Trouble psychique ou neuropsychique',
            cardColor: isDark
                ? const Color(0xFF2A1A1A)
                : const Color(0xFFFFEBEE),
            accent: const Color(0xFFC62828),
            titleColor: isDark ? Colors.white : const Color(0xFFB71C1C),
            children: [
              _Paragraph.rich([
                _t("Selon "),
                _red("l’article 122-1, alinéa 1, du Code pénal"),
                _t(
                  " : « N’est pas pénalement responsable la personne qui était atteinte, au moment des faits, "
                  "d’un trouble psychique ou neuropsychique ayant aboli son discernement ou le contrôle de ses actes ». ",
                ),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "L’irresponsabilité pénale découle d’une perte du libre-arbitre. Toutes les formes de troubles "
                "mentaux destructrices des facultés intellectuelles sont prises en compte, quelle que soit leur origine "
                "(congénitale, âge, accident, maladie…).",
              ),
              const SizedBox(height: 10),
              const _SubTitle('1.1.1 — Discernement aboli : conditions'),
              const _BulletPoint(
                text:
                    "Trouble contemporain de l’infraction : intervalle lucide = responsabilité retenue.",
              ),
              const _BulletPoint(
                text:
                    "Perte totale du discernement : incapacité de comprendre la portée de ses actes / conscience du caractère répréhensible.",
              ),
              const _BulletPoint(
                text:
                    "Trouble prouvé : expertise psychiatrique (avis des experts ne liant pas le juge).",
              ),
              const SizedBox(height: 10),
              const _SubTitle('1.1.1 — Effets'),
              const _Paragraph(
                "La juridiction peut prononcer une déclaration d’irresponsabilité pénale pour cause de trouble mental. "
                "L’infraction n’est pas supprimée : les complices demeurent punissables.",
              ),
              const SizedBox(height: 10),
              const _SubTitle('1.1.1 — Exception (substances psychoactives)'),
              _Paragraph.rich([
                _t(
                  "L’irresponsabilité ne s’applique pas dans le cas prévu par ",
                ),
                _red("l’article 122-1-1 du Code pénal"),
                _t(
                  " : lorsqu’après avoir forgé son projet criminel, la personne consomme volontairement des substances "
                  "psychoactives pour faciliter le passage à l’acte (abolition temporaire).",
                ),
              ]),
              const SizedBox(height: 10),
              const _BulletPoint(
                text: "Volonté de commettre un crime ou un délit.",
              ),
              const _BulletPoint(
                text:
                    "Consommation volontaire aux fins de commettre l’infraction (ou infraction de même nature) ou d’en faciliter la commission.",
              ),
              const _BulletPoint(
                text: "Intoxication dans un temps très voisin de l’action.",
              ),
              const SizedBox(height: 10),
              const _SubTitle('1.1.2 — Discernement altéré : atténuation'),
              _Paragraph.rich([
                _t("Selon "),
                _red("l’article 122-1, alinéa 2, du Code pénal"),
                _t(
                  ", si le trouble a seulement altéré le discernement ou entravé le contrôle des actes, "
                  "la responsabilité pénale demeure, mais le juge doit en tenir compte lors de la peine.",
                ),
              ]),
              const SizedBox(height: 10),
              const _SubTitle('1.1.3 — États voisins'),
              const _BulletPoint(
                text:
                    "Somnambulisme : généralement, irresponsabilité pour les actes commis en état de sommeil.",
              ),
              const _BulletPoint(
                text:
                    "Hypnose : irresponsabilité de la personne hypnotisée ; responsabilité possible de l’hypnotiseur (complicité par provocation).",
              ),
              const SizedBox(height: 10),
              const _SubTitle('Intoxications volontaires'),
              _Paragraph.rich([
                _t(
                  "Si l’altération résulte d’une intoxication volontaire (stupéfiants / alcool excessif), "
                  "la diminution de peine de ",
                ),
                _red("l’article 122-1, alinéa 2, du Code pénal"),
                _t(" n’est pas applicable ("),
                _red("article 122-1-2 du Code pénal"),
                _t(") : la responsabilité pénale est retenue."),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "En revanche, si l’enivrement est fortuit (exposition à l’insu, médicament…), pas de responsabilité.",
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ========================= 1.2 CONTRAINTE =========================
          _ConditionCard(
            title: '1.2 — La contrainte',
            cardColor: isDark
                ? const Color(0xFF102027)
                : const Color(0xFFE0F7FA),
            accent: const Color(0xFF00ACC1),
            titleColor: isDark ? Colors.white : const Color(0xFF006064),
            children: [
              _Paragraph.rich([
                _t("La contrainte est prévue par "),
                _red("l’article 122-2 du Code pénal"),
                _t(
                  " : est irresponsable la personne qui a agi sous l’empire d’une force ou d’une contrainte "
                  "à laquelle elle n’a pu résister.",
                ),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "Force irrésistible supprimant la liberté de décision : contrainte physique ou contrainte morale.",
              ),
              const SizedBox(height: 10),
              const _SubTitle('1.2.1 — Contrainte physique'),
              const _BulletPoint(
                text:
                    "Origine externe : force majeure (cause extérieure naturelle ou humaine).",
              ),
              const _BulletPoint(
                text:
                    "Origine interne : maladie, émotion, fatigue… (rarement retenue pour exonérer).",
              ),
              const SizedBox(height: 10),
              const _SubTitle('Caractères'),
              const _BulletPoint(
                text:
                    "Irrésistible : impossibilité absolue de se conformer à la loi (libre arbitre supprimé).",
              ),
              const _BulletPoint(
                text:
                    "Imprévisible : apprécié sévèrement ; faute antérieure exclut la contrainte.",
              ),
              const SizedBox(height: 10),
              const _SubTitle('1.2.2 — Contrainte morale'),
              const _Paragraph(
                "Pression sur la volonté (cause externe ou interne). Le caractère d’imprévisibilité n’est pas exigé, "
                "mais l’irrésistibilité est exigée et appréciée strictement.",
              ),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Origine externe : menaces illégitimes, pression d’un tiers… (doit être irrésistible).",
              ),
              const _BulletPoint(
                text:
                    "Origine interne : passions / convictions / émotion… n’exonère pas en principe.",
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ========================= 1.3 ERREUR DROIT / FAIT =========================
          _ConditionCard(
            title: '1.3 — Erreur de droit et erreur de fait',
            cardColor: isDark
                ? const Color(0xFF221C2A)
                : const Color(0xFFF3E5F5),
            accent: const Color(0xFF7B1FA2),
            titleColor: isDark ? Colors.white : const Color(0xFF4A148C),
            children: [
              const _Paragraph(
                "L’intention suppose que l’individu ait eu conscience du caractère illégal des actes. "
                "La question se pose en cas d’erreur de droit ou d’erreur de fait.",
              ),
              const SizedBox(height: 10),
              const _SubTitle('1.3.1 — Erreur de droit'),
              _Paragraph.rich([
                _t(
                  "Exception au principe « nul n’est censé ignorer la loi » : ",
                ),
                _red("article 122-3 du Code pénal"),
                _t(
                  " — irresponsabilité si la personne justifie avoir cru, par une erreur sur le droit qu’elle n’était pas "
                  "en mesure d’éviter, pouvoir légitimement accomplir l’acte.",
                ),
              ]),
              const SizedBox(height: 8),
              const _NotaBox(
                title: 'Exemple',
                bodySpans: [
                  TextSpan(
                    text:
                        "Une personne consulte une administration et reçoit un renseignement erroné.",
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const _SubTitle('1.3.2 — Erreur de fait'),
              const _Paragraph(
                "Le Code pénal ne vise pas directement l’erreur de fait : elle porte sur une circonstance de l’infraction. "
                "Effets variables selon l’infraction.",
              ),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Infraction intentionnelle : erreur sur un élément essentiel peut exclure l’intention et donc la responsabilité.",
              ),
              const _BulletPoint(
                text:
                    "Infraction intentionnelle : erreur sur élément accessoire = indifférente (responsabilité subsiste).",
              ),
              const _BulletPoint(
                text:
                    "Infraction non intentionnelle : l’erreur ne supprime pas la faute d’imprudence / négligence (punissable).",
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ========================= 1.4 MINORITÉ =========================
          _ConditionCard(
            title: '1.4 — La minorité',
            cardColor: isDark
                ? const Color(0xFF1B263B)
                : const Color(0xFFE8EAF6),
            accent: const Color(0xFF303F9F),
            titleColor: isDark ? Colors.white : const Color(0xFF1A237E),
            children: [
              _Paragraph.rich([
                _t("Selon "),
                _red("l’article 122-8 du Code pénal"),
                _t(
                  ", les mineurs capables de discernement sont pénalement responsables, "
                  "en tenant compte de l’atténuation liée à l’âge, dans les conditions fixées par le CJPM.",
                ),
              ]),
              const SizedBox(height: 10),
              const _SubTitle('Discernement (CJPM)'),
              _Paragraph.rich([
                _t("Le discernement est un préalable indispensable ("),
                _red(
                  "article L. 11-1 du Code de la justice pénale des mineurs",
                ),
                _t("). Deux présomptions :"),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Moins de 13 ans : présumés ne pas être capables de discernement.",
              ),
              const _BulletPoint(
                text: "Au moins 13 ans : présumés capables de discernement.",
              ),
              const SizedBox(height: 10),
              const _NotaBox(
                title: 'Définition (jurisprudence reprise)',
                bodySpans: [
                  TextSpan(
                    text:
                        "Le discernement : le mineur a « compris et voulu son acte » et est apte à comprendre "
                        "le sens de la procédure pénale dont il fait l’objet.",
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                _t("Éléments pouvant établir (ou renverser) la présomption ("),
                _red("article R. 11-1 CJPM"),
                _t(
                  ") : déclarations, enquête, circonstances, antécédents, expertises…",
                ),
              ]),
              const SizedBox(height: 10),
              const _SubTitle('Moins de 13 ans'),
              const _Paragraph(
                "Aucune peine ne peut être encourue avant 13 ans. Des mesures éducatives peuvent être prononcées "
                "uniquement si le discernement est établi.",
              ),
              const SizedBox(height: 10),
              const _SubTitle('À partir de 13 ans'),
              const _Paragraph(
                "Des mesures éducatives et/ou des peines peuvent être prononcées.",
              ),
              const SizedBox(height: 10),
              const _SubTitle('Atténuation de responsabilité'),
              _Paragraph.rich([
                _t(
                  "Les peines ne sont pas applicables aux mineurs de 13 ans (",
                ),
                _red("article L. 11-4 CJPM"),
                _t("). Le principe d’atténuation est repris par "),
                _red("l’article L. 11-5 CJPM"),
                _t("."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                _t("13 à 16 ans : atténuation obligatoire ("),
                _red("articles L. 121-5 et L. 121-6 CJPM"),
                _t(
                  "). Plus de 16 ans : atténuation facultative, écartable avec motivation spéciale (",
                ),
                _red("article L. 121-7 CJPM"),
                _t(")."),
              ]),
            ],
          ),

          const SizedBox(height: 16),

          // ========================= CHAPITRE 2 =========================
          _ConditionCard(
            title: 'Chapitre 2 — Les faits justificatifs',
            cardColor: isDark
                ? const Color(0xFF2B2B1A)
                : const Color(0xFFFFF8E1),
            accent: const Color(0xFFF9A825),
            titleColor: isDark ? Colors.white : const Color(0xFF5D4037),
            children: const [
              _IntroBullet(
                text:
                    "Ordre de la loi / commandement, légitime défense, état de nécessité, lanceur d’alerte…",
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ========================= 2.1 ORDRE DE LA LOI / AUTORITÉ =========================
          _ConditionCard(
            title:
                '2.1 — Ordre de la loi & commandement de l’autorité légitime',
            cardColor: isDark
                ? const Color(0xFF1A2430)
                : const Color(0xFFE3F2FD),
            accent: const Color(0xFF1565C0),
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: [
              _Paragraph.rich([
                _t("Cadre : "),
                _red("article 122-4 du Code pénal"),
                _t(
                  ". L’ordre/permission de la loi justifie l’acte. "
                  "L’ordre de l’autorité légitime justifie l’action si l’acte n’est pas manifestement illégal.",
                ),
              ]),
              const SizedBox(height: 10),
              const _SubTitle(
                '2.1.1 — Ordre / autorisation de la loi ou du règlement',
              ),
              _Paragraph.rich([
                _t(
                  "Celui qui accomplit un acte prescrit par la loi ou autorisé par des dispositions législatives ou "
                  "réglementaires n’est pas pénalement responsable (",
                ),
                _red("article 122-4 du Code pénal"),
                _t(")."),
              ]),
              const SizedBox(height: 10),
              const _NotaBox(
                title: 'Exemples',
                bodySpans: [
                  TextSpan(
                    text:
                        "• Déclaration de maladies contagieuses : pas de violation du secret pro.\n"
                        "• Concours du citoyen à la justice (arrestation) dans le cadre légal.\n"
                        "• Sports / professions réglementés : actes normaux autorisés si règles respectées.",
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const _SubTitle('Cas exclus'),
              _BulletPoint(
                text:
                    "Autorisation administrative ≠ ordre de la loi (ex : visa administratif).",
              ),
              const _BulletPoint(
                text:
                    "Tolérance de l’administration : inopérante (ne justifie pas l’infraction).",
              ),
              const SizedBox(height: 10),
              const _SubTitle('2.1.2 — Commandement de l’autorité légitime'),
              _Paragraph.rich([
                _t(
                  "Autorité publique civile ou militaire. Irresponsabilité si acte commandé, sauf acte manifestement illégal (",
                ),
                _red("article 122-4 du Code pénal"),
                _t(")."),
              ]),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Pas de justification si ordre manifestement illégal : le subordonné doit refuser.",
              ),
              const _NotaBox(
                title: 'Jurisprudence',
                bodySpans: [
                  TextSpan(
                    text:
                        "Obéir à un ordre manifestement illégal engage la responsabilité pénale (Cass. crim. 25 février 1998).",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ========================= 2.2 LEGITIME DEFENSE =========================
          _ConditionCard(
            title: '2.2 — Légitime défense',
            cardColor: isDark
                ? const Color(0xFF2A1A1A)
                : const Color(0xFFFFEBEE),
            accent: const Color(0xFFC62828),
            titleColor: isDark ? Colors.white : const Color(0xFFB71C1C),
            children: [
              _Paragraph.rich([
                _t("Prévue par "),
                _red("l’article 122-5 du Code pénal"),
                _t(
                  " : impunité pour repousser une agression actuelle et injuste (contre soi ou autrui) "
                  "par une riposte nécessaire et mesurée ; admise aussi (dans des limites strictes) pour les biens.",
                ),
              ]),
              const SizedBox(height: 10),
              const _SubTitle('Conditions'),
              const _BulletPoint(
                text:
                    "Attaque actuelle ou imminente : menace objectivement vraisemblable.",
              ),
              const _BulletPoint(
                text: "Attaque injuste : non fondée en droit.",
              ),
              _BulletPoint(
                text:
                    "Riposte nécessaire et proportionnée (pas de disproportion entre moyens et gravité).",
              ),
              const _BulletPoint(
                text: "Riposte concomitante : sinon = vengeance.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                _t("La justification est exclue « s’il y a disproportion… » ("),
                _red("article 122-5 du Code pénal"),
                _t(")."),
              ]),
              const SizedBox(height: 10),
              const _NotaBox(
                title: 'Jurisprudence',
                bodySpans: [
                  TextSpan(
                    text:
                        "La proportion s’apprécie au regard de l’agression et des moyens employés, indépendamment du résultat (Cass. crim. 17 janvier 2017).",
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const _SubTitle('Légitime défense des biens'),
              _Paragraph.rich([
                _t("Reconnaissance ("),
                _red("article 122-5, alinéa 2, du Code pénal"),
                _t(
                  ") mais strictement encadrée : ne justifie pas un homicide volontaire ; seulement pour interrompre "
                  "un crime ou un délit contre un bien (exclue pour contraventions).",
                ),
              ]),
              const SizedBox(height: 10),
              const _SubTitle('Preuve'),
              const _Paragraph(
                "La jurisprudence impose en pratique à la personne poursuivie de démontrer que les conditions sont réunies.",
              ),
              const SizedBox(height: 10),
              const _SubTitle('Cas privilégiés'),
              _Paragraph.rich([
                _t("Présomption simple dans deux cas ("),
                _red("article 122-6 du Code pénal"),
                _t(") :"),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "1° Repousser, de nuit, l’entrée par effraction, violence ou ruse dans un lieu habité.",
              ),
              const _BulletPoint(
                text:
                    "2° Se défendre contre les auteurs de vols ou pillages exécutés avec violence.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Effets : absence de responsabilité pénale (classement, non-lieu, relaxe/acquittement) et exclusion "
                "de la responsabilité civile (pas de faute).",
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ========================= 2.3 ETAT DE NECESSITE =========================
          _ConditionCard(
            title: '2.3 — État de nécessité',
            cardColor: isDark
                ? const Color(0xFF102027)
                : const Color(0xFFE0F7FA),
            accent: const Color(0xFF00ACC1),
            titleColor: isDark ? Colors.white : const Color(0xFF006064),
            children: [
              _Paragraph.rich([
                _t("Prévu par "),
                _red("l’article 122-7 du Code pénal"),
                _t(
                  " : situation où, pour sauvegarder un intérêt supérieur menacé par un danger actuel ou imminent, "
                  "une personne commet une infraction.",
                ),
              ]),
              const SizedBox(height: 10),
              const _NotaBox(
                title: 'Exemples',
                bodySpans: [
                  TextSpan(
                    text:
                        "Voler un pain pour ne pas mourir de faim ; briser une porte pour accéder à un incendie et l’éteindre.",
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const _SubTitle('Conditions (danger)'),
              const _BulletPoint(
                text: "Danger actuel ou imminent (présent et certain).",
              ),
              const _BulletPoint(
                text: "Danger menaçant une personne ou un bien.",
              ),
              const _BulletPoint(
                text: "Danger ne provenant pas d’une faute antérieure.",
              ),
              const SizedBox(height: 10),
              const _SubTitle('Conditions (acte)'),
              const _BulletPoint(
                text:
                    "Nécessité : l’acte doit être le seul moyen de sauvegarde.",
              ),
              const _BulletPoint(
                text:
                    "Proportionnalité : le bien sacrifié doit être de valeur moindre que le bien sauvegardé.",
              ),
              const SizedBox(height: 10),
              const _NotaBox(
                title: 'Jurisprudence',
                bodySpans: [
                  TextSpan(
                    text:
                        "L’état de nécessité doit être démontré : absence d’autre moyen (Cass. crim. 7 février 2007).",
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const _SubTitle('Effets'),
              const _BulletPoint(
                text: "Absence de responsabilité pénale si dûment établi.",
              ),
              const _BulletPoint(
                text:
                    "Le Code pénal ne tranche pas expressément les conséquences civiles du délit nécessaire.",
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ========================= 2.4 LANCEUR D'ALERTE =========================
          _ConditionCard(
            title: '2.4 — Le lanceur d’alerte',
            cardColor: isDark
                ? const Color(0xFF221C2A)
                : const Color(0xFFF3E5F5),
            accent: const Color(0xFF7B1FA2),
            titleColor: isDark ? Colors.white : const Color(0xFF4A148C),
            children: [
              _Paragraph.rich([
                _t("Cadre : "),
                _red("article 122-9 du Code pénal"),
                _t(
                  " — irresponsabilité en cas d’atteinte à un secret protégé lorsque la divulgation est nécessaire "
                  "et proportionnée, réalisée selon les conditions légales de signalement, et si la personne répond "
                  "aux critères du lanceur d’alerte.",
                ),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "Le texte vise notamment la divulgation et aussi la soustraction/détournement/recels de documents "
                "si connaissance licite et signalement/divulgation conforme. Il est également applicable au complice.",
              ),
              const SizedBox(height: 10),
              const _NotaBox(
                title: 'Point d’attention',
                bodySpans: [
                  TextSpan(
                    text:
                        "Les contraventions ne sont pas systématiquement visées ; les manquements disciplinaires doivent être graves et manifestes.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ========================= CHAPITRE 3 - USAGE DES ARMES (CSI) =========================
          _ConditionCard(
            title: 'Chapitre 3 — Usage des armes par les forces de l’ordre',
            cardColor: isDark
                ? const Color(0xFF2B2B1A)
                : const Color(0xFFFFF8E1),
            accent: const Color(0xFFF9A825),
            titleColor: isDark ? Colors.white : const Color(0xFF5D4037),
            children: [
              _Paragraph.rich([
                _t("Cadre commun : "),
                _red("article L. 435-1 du Code de la sécurité intérieure"),
                _t(
                  " (police et gendarmerie nationales). S’applique aux fonctionnaires actifs de la PN, policiers adjoints "
                  "et réservistes ; encadre armes individuelles, collectives et force intermédiaire.",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 12),

          _ConditionCard(
            title: '3.1 — Trois conditions préalables',
            cardColor: isDark
                ? const Color(0xFF1A2430)
                : const Color(0xFFE3F2FD),
            accent: const Color(0xFF1565C0),
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: const [
              _BulletPoint(text: "Agir dans l’exercice de ses fonctions."),
              _BulletPoint(
                text:
                    "Être en uniforme ou porter des insignes extérieurs et apparents de la qualité (ex. brassard « police »).",
              ),
              _BulletPoint(
                text:
                    "N’utiliser l’arme qu’en cas d’absolue nécessité et de manière strictement proportionnée.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: 'Hors service',
                bodySpans: [
                  TextSpan(
                    text:
                        "Hors des heures de service : usage de l’arme uniquement dans le cadre commun de la légitime défense ou de l’état de nécessité, sauf situation opérationnelle permettant de revêtir les insignes.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          _ConditionCard(
            title: '3.2 — Cinq situations autorisant l’usage',
            cardColor: isDark
                ? const Color(0xFF2A1A1A)
                : const Color(0xFFFFEBEE),
            accent: const Color(0xFFC62828),
            titleColor: isDark ? Colors.white : const Color(0xFFB71C1C),
            children: [
              const _SubTitle('3.2.1 — Légitime défense'),
              _Paragraph.rich([
                _t("Proche du droit commun ("),
                _red("article 122-5 du Code pénal"),
                _t(
                  ") : atteintes à la vie / intégrité contre eux ou un tiers, ou menaces par personnes armées.",
                ),
              ]),
              const SizedBox(height: 10),

              const _SubTitle('3.2.2 — Défense des lieux / personnes confiées'),
              const _Paragraph(
                "Après deux sommations à haute voix, lorsqu’ils ne peuvent défendre autrement les lieux occupés ou "
                "les personnes confiées (ex : commissariat, perquisition, personne interpellée menacée…).",
              ),
              const SizedBox(height: 10),

              const _SubTitle('3.2.3 — Fuite des personnes'),
              const _Paragraph(
                "Après deux sommations, lorsqu’ils ne peuvent contraindre à s’arrêter autrement que par l’usage des armes "
                "une personne cherchant à échapper à leur garde/investigations ET susceptible de commettre dans sa fuite "
                "des atteintes à la vie/intégrité des forces de l’ordre ou d’autrui (dangerosité démontrée).",
              ),
              const SizedBox(height: 10),

              const _SubTitle(
                '3.2.4 — Fuite des véhicules / embarcations / moyens de transport',
              ),
              _Paragraph.rich([
                _t(
                  "Usage possible si unique moyen d’immobiliser un véhicule dont le conducteur n’obtempère pas, "
                  "et dont les occupants sont susceptibles de commettre dans leur fuite des atteintes graves. Référence doctrine : matériels d’immobilisation (",
                ),
                _red("article L. 214-2 du Code de la sécurité intérieure"),
                _t(")."),
              ]),
              const SizedBox(height: 10),

              const _SubTitle('3.2.5 — Périple meurtrier'),
              const _Paragraph(
                "But exclusif : éviter la réitération, dans un temps rapproché, d’un ou plusieurs meurtres/tentatives "
                "venant d’être commis, si raisons réelles et objectives d’estimer la réitération probable au regard des informations disponibles.",
              ),
            ],
          ),

          const SizedBox(height: 12),

          _ConditionCard(
            title: '3.3 — Effet : cause d’irresponsabilité pénale',
            cardColor: isDark
                ? const Color(0xFF20302E)
                : const Color(0xFFE0F2F1),
            accent: const Color(0xFF00897B),
            titleColor: isDark ? Colors.white : const Color(0xFF004D40),
            children: const [
              _Paragraph(
                "Lorsque les conditions préalables sont réunies, le policier qui fait usage de son arme dans l’une des cinq "
                "situations du cadre CSI sera déclaré pénalement irresponsable.",
              ),
            ],
          ),

          const SizedBox(height: 10),
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
