import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DemarchesAdministrativesPage extends StatelessWidget {
  const DemarchesAdministrativesPage({super.key});

  static const String routeName = '/gpx/institution/accueil_public/demarches';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
    final Color cardIntro = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardCni = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardMineur = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardPermis = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardEtatCivil = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardVote = isDark
        ? const Color(0xFF202633)
        : const Color(0xFFF3F6FF);

    final Color accentBlue = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color accentGreen = isDark
        ? const Color(0xFF66BB6A)
        : const Color(0xFF2E7D32);
    final Color accentAmber = isDark
        ? const Color(0xFFFFCA28)
        : const Color(0xFFF9A825);
    final Color accentPink = isDark
        ? const Color(0xFFF48FB1)
        : const Color(0xFFC2185B);
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
          "Accueil du public",
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
            "Quelques démarches administratives",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          _ConditionCard(
            title: "But de la fiche",
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Cette page regroupe des repères pratiques (CNI, sortie de territoire du mineur, permis, "
                "passeport, état civil, livret de famille, nationalité, procuration de vote). "
                "Objectif : orienter rapidement le public et sécuriser les démarches.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // I — CNI
          _ConditionCard(
            title: "I — Carte Nationale d’Identité (CNI)",
            cardColor: cardCni,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "La carte nationale d’identité est délivrée gratuitement. Elle n’est pas obligatoire. "
                "Même périmée, elle peut justifier l’identité d’un Français tant que la photo est ressemblante. "
                "En cours de validité, elle permet l’entrée dans certains pays sans passeport (selon règles du pays).",
              ),
              const SizedBox(height: 12),

              const _SubTitle("Durée de validité"),
              const _BulletPoint(
                text: "CNI sécurisée : 15 ans (majeurs) / 10 ans (mineurs).",
              ),
              const _BulletPoint(
                text:
                    "Nouvelle CNI électronique (format carte bancaire) : 10 ans (majeurs et mineurs).",
              ),
              const SizedBox(height: 10),

              _NotaBox(
                title: "Important",
                bodySpans: [
                  const TextSpan(
                    text:
                        "La prolongation de 10 à 15 ans est automatique pour certaines CNI sécurisées (délivrées entre 2004 et 2013 pour des majeurs). "
                        "La date sur le titre n’est pas modifiée. "
                        "Vérifier les pays acceptant l’extension de validité (diplomatie).",
                  ),
                ],
              ),
              const SizedBox(height: 12),

              const _SubTitle("Où la demander ?"),
              const _BulletPoint(
                text:
                    "Dans n’importe quelle mairie équipée d’une station d’enregistrement (pas lié au domicile).",
              ),
              const _BulletPoint(
                text: "Liste des mairies disponibles sur service-public.fr.",
              ),
              const SizedBox(height: 10),

              const _SubTitle("Comment la faire établir ?"),
              const _BulletPoint(
                text: "Pré-demande possible en ligne via ants.gouv.fr.",
              ),
              const _BulletPoint(
                text:
                    "Présence du demandeur indispensable (prise d’empreintes).",
              ),
              const SizedBox(height: 10),

              const _SubTitle("Cas particuliers"),
              const _BulletPoint(
                text:
                    "Mineurs : l’enfant + le responsable légal doivent être présents. Le responsable présente sa propre pièce d’identité.",
              ),
              const _BulletPoint(
                text:
                    "Parents séparés/divorcés : jugement utile uniquement si résidence alternée (inscrire 2 adresses).",
              ),
              const SizedBox(height: 10),

              const _SubTitle("Perte / vol"),
              const _BulletPoint(
                text:
                    "Vol : déclaration préalable en commissariat/gendarmerie (ou autorités locales + consulat à l’étranger) contre récépissé.",
              ),
              const _BulletPoint(
                text:
                    "Perte : si renouvellement immédiat, déclaration faite au guichet lors du dépôt ; sinon déclaration en commissariat/gendarmerie.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // II — SORTIE DU TERRITOIRE DU MINEUR
          _ConditionCard(
            title: "II — Sortie de territoire du mineur",
            cardColor: cardMineur,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Autorisation de sortie du territoire (AST)"),
              const _Paragraph(
                "Un mineur résidant en France qui voyage à l’étranger seul ou sans l’un de ses parents "
                "doit avoir une AST. Un mineur voyageant avec son père ou sa mère n’a pas besoin d’AST.",
              ),
              const SizedBox(height: 10),

              _Paragraph.rich([
                const TextSpan(text: "Formulaire "),
                TextSpan(
                  text: "CERFA n°15646*01",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " disponible sur service-public.fr (aucun passage en mairie/préfecture).",
                ),
              ]),
              const SizedBox(height: 10),

              const _SubTitle("Documents à avoir (voyage sans parent)"),
              const _BulletPoint(
                text:
                    "Pièce d’identité valide du mineur (CNI ou passeport) + visa si nécessaire (selon pays).",
              ),
              const _BulletPoint(
                text:
                    "Photocopie du titre d’identité du parent signataire (valide ou périmé depuis moins de 5 ans).",
              ),
              const _BulletPoint(
                text:
                    "Original de l’AST signée par un parent titulaire de l’autorité parentale.",
              ),
              const SizedBox(height: 12),

              const _SubTitle("B) Opposition à sortie du territoire (OST)"),
              const _Paragraph(
                "En cas d’urgence et face à un risque avéré, un parent peut demander une OST.",
              ),
              const SizedBox(height: 8),
              const _BulletPoint(
                text: "Demande en préfecture / sous-préfecture.",
              ),
              const _BulletPoint(
                text:
                    "Nuits / week-ends / jours fériés : possible en commissariat ou brigade de gendarmerie.",
              ),
              const SizedBox(height: 10),

              _NotaBox(
                title: "Effets",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Si OST décidée : inscription au FPR et signalement au SIS. Durée maximale : 15 jours (non prolongeable).",
                  ),
                ],
              ),
              const SizedBox(height: 12),

              const _SubTitle("C) Interdiction de sortie du territoire (IST)"),
              const _Paragraph(
                "Mesure judiciaire décidée par le JAF (autorité parentale / protection) ou le juge des enfants "
                "(assistance éducative).",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Nota",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Un mineur sous IST peut voyager si les deux parents autorisent expressément : autorisation recueillie au commissariat sur PV (au moins 5 jours avant).",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // III — PERMIS / ÉCHANGES + PERMIS INTERNATIONAL
          _ConditionCard(
            title: "III — Permis de conduire (échanges & permis international)",
            cardColor: cardPermis,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Échanger un permis UE/EEE"),
              const _Paragraph(
                "Concerne les résidents en France titulaires d’un permis délivré par un autre État UE/EEE. "
                "L’échange n’est pas obligatoire sauf dans certains cas (infraction entraînant suspension/retrait, "
                "ou permis obtenu en échange d’un pays tiers sans réciprocité).",
              ),
              const SizedBox(height: 10),

              const _SubTitle("Demande (par courrier)"),
              _Paragraph.rich([
                const TextSpan(text: "Formulaire "),
                TextSpan(
                  text: "CERFA n°14879*01",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " + formulaire "),
                TextSpan(
                  text: "CERFA n°14948*01 (référence 06)",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " (imprimé en couleur)."),
              ]),
              const SizedBox(height: 10),

              const _BulletPoint(
                text:
                    "Copie couleur recto/verso du permis + justificatifs d’identité et de domicile + photos + enveloppe lettre suivie.",
              ),
              const _BulletPoint(
                text: "Dossier adressé au CERT (ou CREPIC si Paris).",
              ),
              const SizedBox(height: 12),

              const _SubTitle("B) Échanger un permis hors UE/EEE"),
              const _Paragraph(
                "Obligatoire pour continuer à conduire : échange à demander dans l’année suivant l’acquisition de la résidence habituelle en France "
                "(sauf étudiants étrangers pendant leurs études).",
              ),
              const SizedBox(height: 10),

              _NotaBox(
                title: "Conditions",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Permis valide, pays pratiquant l’échange, conditions de reconnaissance (traduction officielle si nécessaire, âge requis, absence de suspension/retrait…).",
                  ),
                ],
              ),
              const SizedBox(height: 12),

              const _SubTitle("C) Permis international"),
              const _Paragraph(
                "Certains pays exigent un permis international (traduction officielle du permis français). "
                "Coût : gratuit. Demande par courrier.",
              ),
              const SizedBox(height: 10),

              _Paragraph.rich([
                const TextSpan(text: "Formulaire "),
                TextSpan(
                  text: "CERFA n°14881*01",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " (1er volet) + copies permis/identité/domicile + 2 photos + enveloppe lettre suivie.",
                ),
              ]),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Dossier au CERT Permis internationaux (ou CREPIC si Paris).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // IV — PASSEPORT + ÉTAT CIVIL + LIVRET + NATIONALITÉ
          _ConditionCard(
            title: "IV — Passeport & actes d’état civil",
            cardColor: cardEtatCivil,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _SubTitle("Passeport"),
              _BulletPoint(
                text:
                    "Demande en mairie équipée (pas lié au domicile). Pré-demande possible sur ants.gouv.fr. Présence obligatoire (empreintes).",
              ),
              _BulletPoint(
                text:
                    "Mineur : enfant + responsable légal présents. Un enfant ne peut pas être inscrit sur le passeport d’un parent.",
              ),
              _BulletPoint(
                text:
                    "Validité : 10 ans (majeur) / 5 ans (mineur) / 1 an (urgence, sur justificatifs).",
              ),
              SizedBox(height: 10),

              _SubTitle("Extrait / copie d’acte de naissance"),
              _BulletPoint(
                text:
                    "3 formats : copie intégrale, extrait avec filiation, extrait sans filiation.",
              ),
              _BulletPoint(
                text:
                    "Demande : mairie du lieu de naissance (en ligne, sur place, ou par courrier) ou service central de Nantes pour Français nés à l’étranger.",
              ),
              SizedBox(height: 10),

              _SubTitle("Copie d’acte de décès"),
              _BulletPoint(
                text: "Toute personne peut en demander une (gratuit).",
              ),
              _BulletPoint(
                text:
                    "Demande : mairie du décès / mairie du dernier domicile, ou via service-public.fr, ou Nantes si décès à l’étranger (Français).",
              ),
              SizedBox(height: 10),

              _SubTitle("Livret de famille"),
              _BulletPoint(
                text:
                    "Peut être demandé comme justificatif (CNI/passeport), avec d’autres pièces selon le cas.",
              ),
              _BulletPoint(
                text:
                    "Mise à jour à la charge du titulaire (présentation à chaque changement d’état civil).",
              ),
              SizedBox(height: 10),

              _SubTitle("Certificat de nationalité française"),
              _BulletPoint(
                text:
                    "Prouve la nationalité française (peut être exigé pour 1ère CNI, passeport, concours FP).",
              ),
              _BulletPoint(
                text:
                    "Pas de durée de validité limitée (fait foi jusqu’à preuve contraire).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // X — VOTE PAR PROCURATION
          _ConditionCard(
            title: "V — Vote par procuration",
            cardColor: cardVote,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Permet à un électeur absent (mandant) de choisir un autre électeur (mandataire) "
                "pour voter à sa place.",
              ),
              const SizedBox(height: 10),

              const _SubTitle("Conditions pour le mandataire"),
              const _BulletPoint(
                text:
                    "Inscrit dans la même commune que le mandant (pas forcément même bureau).",
              ),
              const _BulletPoint(
                text:
                    "Ne détient pas plus de 2 procurations (selon règles France/étranger).",
              ),
              const SizedBox(height: 12),

              const _SubTitle("Où faire la démarche ?"),
              const _BulletPoint(
                text:
                    "Commissariat / gendarmerie (où que soit le mandant), ou tribunal judiciaire (domicile / travail).",
              ),
              const SizedBox(height: 10),

              const _SubTitle("Comment faire ?"),
              _Paragraph.rich([
                const TextSpan(
                  text: "Option 1 : formulaire papier sur place.\n",
                ),
                const TextSpan(text: "Option 2 : formulaire "),
                TextSpan(
                  text: "CERFA n°14952*02",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " rempli en ligne puis imprimé (2 feuilles, pas recto-verso) et finalisé au guichet.\n",
                ),
                const TextSpan(
                  text:
                      "Option 3 : demande en ligne via maprocuration.gouv.fr (puis déplacement obligatoire pour validation d’identité).",
                ),
              ]),
              const SizedBox(height: 12),

              _NotaBox(
                title: "Délais",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Même si la procuration peut être établie jusqu’au jour du vote, il est recommandé d’anticiper "
                        "pour éviter que la mairie ne la reçoive trop tard.",
                  ),
                ],
              ),
              const SizedBox(height: 12),

              const _SubTitle("Déroulement du vote"),
              const _BulletPoint(
                text:
                    "Le mandataire vote avec sa propre pièce d’identité, au bureau du mandant.",
              ),
              const _BulletPoint(
                text:
                    "Le mandant peut voter lui-même s’il se présente avant le mandataire.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Synthèse rapide
          _ConditionCard(
            title: "Synthèse (mémo)",
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _BulletPoint(
                text:
                    "CNI/Passeport : mairie équipée + pré-demande possible sur ANTS + empreintes obligatoires.",
              ),
              _BulletPoint(
                text:
                    "Mineur à l’étranger sans parent : AST (CERFA) + pièces d’identité + copie du parent signataire.",
              ),
              _BulletPoint(
                text:
                    "Permis : échanges via CERFA + CERT/CREPIC ; permis international gratuit via CERFA.",
              ),
              _BulletPoint(
                text:
                    "État civil : actes via mairie / en ligne / courrier (Nantes pour Français à l’étranger).",
              ),
              _BulletPoint(
                text:
                    "Vote : procuration possible commissariat/gendarmerie/tribunal + option maprocuration.",
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
