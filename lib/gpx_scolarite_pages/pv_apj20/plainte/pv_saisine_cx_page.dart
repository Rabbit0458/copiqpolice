import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PVPvSaisineCxPage extends StatelessWidget {
  const PVPvSaisineCxPage({super.key});

  static const String routeName = '/gpx/pv_apj20/plainte/pv_saisine_cx';

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
    final Color cardDef = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardHow = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardModels = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardOnline = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);

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
          "Plainte",
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
            "PV de saisine — contre X",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 22,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: "I — Élément légal",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Les officiers et agents de police judiciaire sont tenus de recevoir les plaintes, y compris si le service est territorialement incompétent (transmission si besoin). — ",
                ),
                TextSpan(
                  text: "article 15-3 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "La plainte peut également être déposée par voie électronique (atteintes aux biens, auteur inconnu), sans pouvoir être imposée à la victime. — ",
                ),
                TextSpan(
                  text: "article 15-3-1 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Dans tous les cas : dépôt de plainte = procès-verbal + récépissé immédiat, et copie si la victime le demande.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Définition
          _ConditionCard(
            title: "Définition",
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "La plainte « contre X » est utilisée lorsque l’auteur n’est pas identifié. "
                "Le PV de saisine formalise la déclaration de la victime et fixe une base claire pour diligenter les premières investigations.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "L’objectif n’est pas seulement de « raconter » : il faut rendre le dossier exploitable (qualification, pistes, actes à réaliser, preuves).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Comment le faire (checklist opérationnelle)
          _ConditionCard(
            title: "II — Contenu indispensable (checklist)",
            cardColor: cardHow,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Situer les faits (temps / espace)"),
              const _BulletPoint(
                text:
                    "Date/heure (ou période) la plus précise possible, et chronologie simple.",
              ),
              const _BulletPoint(
                text:
                    "Lieu précis (adresse, étage, parties communes, parking, voie publique…).",
              ),
              const _BulletPoint(
                text:
                    "Contexte : comment la victime découvre les faits, première constatation.",
              ),
              const SizedBox(height: 12),
              const _SubTitle("B) Décrire l’infraction et le mode opératoire"),
              const _BulletPoint(
                text:
                    "Ce qui s’est passé (faits matériels), ce que la victime a vu/entendu/constaté.",
              ),
              const _BulletPoint(
                text:
                    "Mode opératoire : accès, effraction, ruse, fraude, moyen utilisé, timing.",
              ),
              const _BulletPoint(
                text:
                    "Éléments techniques utiles : identifiants, numéros, IBAN, pseudo, URL, plateforme, IMEI, immatriculation…",
              ),
              const SizedBox(height: 12),
              const _SubTitle("C) Exploitabilité immédiate"),
              const _BulletPoint(
                text:
                    "Signalements : description auteur(s) si aperçu(s), tenue, direction de fuite, véhicule.",
              ),
              const _BulletPoint(
                text:
                    "Objets/biens : liste détaillée (marque, modèle, série, valeur, particularités).",
              ),
              const _BulletPoint(
                text:
                    "Préjudice : matériel, financier, moral (montants, dates de débits, factures).",
              ),
              const _BulletPoint(
                text:
                    "Pièces remises : captures, mails, messages, relevés, factures, certificats… (à mentionner en ANNEXE).",
              ),
              const SizedBox(height: 12),
              _NotaBox(
                title: "Astuce rédaction",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Écrire simple, factuel, chronologique. Faire ressortir : « quoi / quand / où / comment / preuves ». "
                        "Le PV doit permettre d’engager des actes sans recontacter immédiatement la victime.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Modèles
          _ConditionCard(
            title: "III — Modèles de procès-verbaux",
            cardColor: cardModels,
            accent: accentPink,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Deux grands types de modèles peuvent être utilisés selon la situation.",
              ),
              const SizedBox(height: 12),
              const _SubTitle("A) Procès-verbal ordinaire (P.V.O.)"),
              const _BulletPoint(
                text:
                    "Utilisé lorsque la victime connaît l’auteur (personne dénommée) ou quand le dossier ne nécessite pas de recherches complexes immédiates.",
              ),
              const _BulletPoint(
                text:
                    "Exemples : violences entre époux, dégradations, violences en général (selon contexte).",
              ),
              const SizedBox(height: 12),
              const _SubTitle("B) Procès-verbaux normalisés (contre inconnu)"),
              const _BulletPoint(
                text:
                    "Conçus pour le recueil des plaintes contre X (atteintes aux biens, auteur inconnu).",
              ),
              const _BulletPoint(
                text:
                    "Exemples : PV de voie publique, C.R.I. (Compte-Rendu d’Infraction Initiale), compte-rendu complémentaire.",
              ),
              const _BulletPoint(
                text:
                    "Exemples : vol de véhicule immatriculé, découverte/restitution de véhicule, usage frauduleux de moyen de paiement…",
              ),
              const SizedBox(height: 12),
              _NotaBox(
                title: "But",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Standardiser la collecte d’informations clés pour gagner du temps et sécuriser la qualité du PV (rubriques complètes).",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Services en ligne
          _ConditionCard(
            title: "IV — Services en ligne",
            cardColor: cardOnline,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Plainte en ligne"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Service accessible aux usagers pour une plainte par voie électronique (atteintes aux biens, auteur inconnu). — ",
                ),
                TextSpan(
                  text: "article 15-3-1 du Code de procédure pénale",
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
                  text:
                      "Les infractions concernées sont listées notamment par ",
                ),
                TextSpan(
                  text: "l’article D. 8-2-1 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " (atteintes aux biens : appropriations frauduleuses, destructions/dégradations, délit de fuite, certaines contraventions…).",
                ),
              ]),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Deux traitements : plainte entièrement dématérialisée (si aucun acte en présence requis) ou plainte finalisée en présentiel.",
              ),
              const _BulletPoint(
                text:
                    "La plainte en ligne ne dispense pas d’une audition ultérieure si la nature/gravitée des faits le justifie.",
              ),

              const SizedBox(height: 14),

              const _SubTitle("B) THÉSÉE (e-escroqueries)"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Pour les escroqueries commises sur internet : télédéclaration / plainte via le téléservice THÉSÉE (traitement harmonisé des enquêtes et signalements e-escroqueries). Référence mentionnée : ",
                ),
                TextSpan(
                  text: "article A 1er du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Rappel",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Les infractions visées (exemples) : e-escroquerie, e-chantage, e-extorsion (selon les cas et connexités).",
                  ),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle(
                "C) Signalement VSS (violences sexuelles et sexistes)",
              ),
              const _Paragraph(
                "Portail accessible 24h/24 et 7j/7 via une messagerie de type « tchat », permettant d’échanger avec des policiers formés à l’accueil des victimes de violences sexuelles, sexistes ou conjugales.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Objectif",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Faciliter le premier contact, orienter, sécuriser l’accueil et préparer une prise en charge adaptée (plainte, audition, protection).",
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
