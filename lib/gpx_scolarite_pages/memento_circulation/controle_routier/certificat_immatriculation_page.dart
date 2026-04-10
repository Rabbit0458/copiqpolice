import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CertificatImmatriculationPage extends StatelessWidget {
  const CertificatImmatriculationPage({super.key});

  static const String routeName =
      '/gpx/memento_circulation/controle_routier/certificat_immatriculation';

  static const Color _lawRed = Color(0xFFE53935);

  TextSpan _lawSpan(String text) => TextSpan(
    text: text,
    style: const TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
  );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardRules = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardUseCases = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardProvisoire = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardInfra = isDark
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
          "Contrôle routier",
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
            "Les certificats d’immatriculation",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Définition / idée générale
          _ConditionCard(
            title: "Définition",
            cardColor: cardInfra,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "La procédure d’immatriculation donne lieu à la délivrance d’un certificat d’immatriculation "
                "comportant un numéro à reporter sur la ou les plaques. Certains véhicules et remorques sont soumis "
                "à immatriculation, selon leur nature et leur PTAC.",
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
                _lawSpan("R. 322-1"),
                const TextSpan(text: " à "),
                _lawSpan("R. 322-8 du Code de la route"),
                const TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Champ d’application
          _ConditionCard(
            title: "II — Véhicules concernés",
            cardColor: cardRules,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Doivent être immatriculés :\n"
                "• Les véhicules à moteur (sauf cyclomobiles légers et engins de déplacement personnel motorisés) ;\n"
                "• Les remorques de PTAC > 500 kg ;\n"
                "• Les semi-remorques (sauf véhicules/appareils agricoles remorqués de PTAC < 1,5 t).",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Le numéro d’immatriculation doit être reporté sur la ou les plaques. ",
                ),
                const TextSpan(text: "("),
                TextSpan(
                  text: "NATINF 7543",
                  style: GoogleFonts.fustat(fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: ")"),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(text: "Depuis le "),
                  TextSpan(
                    text: "15 avril 2009",
                    style: GoogleFonts.fustat(fontWeight: FontWeight.w900),
                  ),
                  const TextSpan(
                    text:
                        ", le certificat délivré à tout véhicule mis en circulation pour la première fois comporte un numéro attribué à titre définitif.",
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Les certificats délivrés avant le 15 avril 2009 (« carte grise ») restent valables : "
                "les véhicules concernés peuvent continuer à circuler avec ce document et les plaques correspondantes.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Séries / numérotation
          _ConditionCard(
            title: "III — Séries et format d’immatriculation",
            cardColor: cardUseCases,
            accent: accentPink,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Il existe deux séries d’immatriculation :\n"
                "• Série normale\n"
                "• Série diplomatique",
              ),
              const SizedBox(height: 10),
              const _SubTitle("A) Série normale"),
              const _Paragraph(
                "Le numéro attribué à titre définitif se compose de trois blocs :\n"
                "• 2 lettres – 3 chiffres – 2 lettres (séparés par des tirets)\n"
                "Exemple : AA-111-AA",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "NOTA 1",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Jusqu’au 30 juin 2015, le numéro définitif des cyclomoteurs était composé de 1 à 2 lettres, "
                        "2 à 3 chiffres, 1 lettre, avec un espace entre les blocs (ex : A 11 A, ZZ 999 Z).",
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "NOTA 2",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Les lettres I, O et U ne sont pas utilisées (confusion avec 1, 0 et V). "
                        "L’association « SS » est interdite conformément aux dispositions du ",
                  ),
                  _lawSpan("Code pénal"),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 12),
              const _SubTitle("B) Usages particuliers (série normale)"),
              const _BulletPoint(text: "Administration civile de l’État."),
              const _BulletPoint(text: "Véhicule militaire."),
              const _BulletPoint(
                text:
                    "Véhicule agricole : numéro d’exploitation attribué par le ministre de l’intérieur.",
              ),
              const _BulletPoint(
                text:
                    "Véhicule de démonstration : comporte une date de fin de validité de l’usage.",
              ),
              const SizedBox(height: 12),
              const _SubTitle("C) Détention du certificat à bord"),
              const _Paragraph(
                "Le titulaire du certificat (ou son préposé) doit être à bord du véhicule. "
                "Pour les motocyclettes et cyclomoteurs, il peut être présent sur ou à bord d’un véhicule suiveur.\n\n"
                "En cas de prêt du véhicule, le bénéficiaire doit présenter une attestation nominative de mise à disposition "
                "(validité limitée à 10 jours maximum).",
              ),
              const SizedBox(height: 12),
              const _SubTitle(
                "D) Mentions d’usage : collection / transit / zones franches",
              ),
              const _Paragraph(
                "• Véhicule de collection : intérêt historique, construit ou immatriculé pour la première fois il y a au moins 30 ans, "
                "non produit, maintenu dans son état d’origine. Usage personnel, sans restriction géographique.\n\n"
                "• Véhicule en transit temporaire : véhicules privés acquis neufs en France (exonération droits/TVA) destinés à l’exportation "
                "par des résidents hors UE en séjour temporaire. Validité : 6 mois, prorogeable une fois.\n\n"
                "• Véhicule importé en transit : véhicules de personnes bénéficiant d’exonérations douanières/fiscales ; durée fixée par les douanes.\n\n"
                "• Véhicule zone franche (Pays de Gex / Haute-Savoie) : marques étrangères, exemption de droits de douane ; "
                "validité cesse dès que le propriétaire est domicilié hors zone.",
              ),
              const SizedBox(height: 12),
              const _SubTitle("E) Série diplomatique"),
              const _Paragraph(
                "Pour les véhicules de statut diplomatique ou assimilé, le certificat comporte :\n"
                "• Un numéro définitivement assigné ;\n"
                "• Un numéro spécifique lié au statut.",
              ),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "CMD / CD : missions diplomatiques ou organisations internationales (ex : 100 CMD 20, 500 CD 100, U 300 CD 20).",
              ),
              const _BulletPoint(
                text:
                    "C : fonctionnaires du corps consulaire (ex : 105 C 1.75).",
              ),
              const _BulletPoint(
                text:
                    "K : fonctionnaires internationaux (ex : 105 K 100, U 305 K 10).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Certificats provisoires
          _ConditionCard(
            title: "IV — Certificats provisoires d’immatriculation",
            cardColor: cardProvisoire,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(text: "Voir "),
                TextSpan(
                  text: "NATINF 6234",
                  style: GoogleFonts.fustat(fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              const _SubTitle("A) CPI"),
              const _Paragraph(
                "Le certificat provisoire d’immatriculation (CPI) est un document sécurisé indiquant notamment "
                "le numéro définitif. Il permet de circuler pendant 1 mois.\n"
                "• 8 mois : véhicules de location courte durée\n"
                "• 3 mois : véhicule en attente d’immatriculation diplomatique",
              ),
              const SizedBox(height: 12),
              const _SubTitle("B) CPI WW"),
              const _Paragraph(
                "Délivrable notamment pour : véhicules neufs vendus, véhicules importés (dossier incomplet/en cours), "
                "véhicules exportés, véhicules d’occasion destinés à l’exportation, engins agricoles neufs.\n\n"
                "Identique au CPI sauf :\n"
                "• numéro WW-111-AA\n"
                "• validité : 2 mois prorogeable une fois (3 mois si engins agricoles).",
              ),
              const SizedBox(height: 12),
              const _SubTitle("C) Certificat W garage"),
              const _Paragraph(
                "Permet à un véhicule utilisé par un professionnel de l’automobile, à des fins professionnelles, "
                "de circuler à titre provisoire sur le territoire national.\n\n"
                "Délivré pour l’année civile en cours, sous forme d’un CI définitif avec la mention « certificat W garage » "
                "et le millésime. Numéro : W-111-AA.\n\n"
                "La circulation simultanée de plusieurs véhicules sous couvert du même numéro W garage est interdite.",
              ),
              const SizedBox(height: 12),
              const _SubTitle("D) Certificat WW DPTC"),
              const _Paragraph(
                "Permet à un véhicule relevant d’une expérimentation de conduite à délégation partielle ou totale "
                "de circuler sur les voies publiques.\n"
                "Durée maximale de l’autorisation : 2 ans.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Formalités (pédagogique + structuré)
          _ConditionCard(
            title: "V — Formalités administratives",
            cardColor: cardRules,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _SubTitle(
                "A) Changement de propriétaire (vente / cession)",
              ),
              _Paragraph.rich([
                const TextSpan(text: "Voir "),
                TextSpan(
                  text: "NATINF 28690",
                  style: GoogleFonts.fustat(fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              const _Paragraph(
                "L’ancien propriétaire doit notamment remettre à l’acquéreur :\n"
                "• Le certificat de cession (ou code de cession / cession électronique) ;\n"
                "• Le certificat d’immatriculation avec mention « vendu le… » ou « cédé le… », date + signature, "
                "et coupon détachable (sauf cession à professionnel) ;\n"
                "• Un certificat de situation administrative (< 15 jours) ;\n"
                "• Le contrôle technique (< 6 mois) si véhicule > 4 ans.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Dans les 15 jours, le vendeur déclare la cession (récépissé délivré) : ",
                ),
                TextSpan(
                  text: "NATINF 6237",
                  style: GoogleFonts.fustat(fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Dans le délai d’un mois, l’acquéreur demande un CI à son nom : ",
                ),
                TextSpan(
                  text: "NATINF 7544",
                  style: GoogleFonts.fustat(fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 12),
              const _NotaBox(
                title: "Pratique",
                bodySpans: [
                  TextSpan(
                    text:
                        "La circulation sous couvert du coupon détachable ou du CPI est possible pendant 1 mois. "
                        "Dès l’obtention du CPI, la revente du véhicule est possible.",
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const _SubTitle("B) Changement de domicile"),
              _Paragraph.rich([
                const TextSpan(text: "Voir "),
                TextSpan(
                  text: "NATINF 6224",
                  style: GoogleFonts.fustat(fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              const _Paragraph(
                "Le certificat portant l’ancienne adresse est valable 1 mois.\n"
                "• 1 à 3 déclarations : envoi d’une étiquette autocollante à apposer.\n"
                "• 4e déclaration : délivrance d’un nouveau certificat.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "NOTA",
                bodySpans: [
                  const TextSpan(
                    text:
                        "La notion de domicile est unique (lieu du principal établissement). Les résidences peuvent être multiples. "
                        "Références : ",
                  ),
                  _lawSpan("articles 102 à 111 du Code civil"),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 12),
              const _SubTitle("C) Cession pour destruction"),
              const _Paragraph(
                "La vente/cession pour destruction (sauf cession à un assureur) se fait auprès d’un démolisseur/broyeur agréé.\n"
                "Le propriétaire remet le CI avec mention « vendu/cédé le … pour destruction » + signature.\n"
                "Le professionnel remet une copie de déclaration d’achat pour destruction et informe le ministre de l’intérieur.",
              ),
              const SizedBox(height: 12),
              const _SubTitle("D) Perte ou vol : duplicata"),
              const _Paragraph(
                "Après déclaration de perte/vol, le propriétaire demande un duplicata.\n"
                "Le récépissé de déclaration de perte/vol est valable 1 mois.",
              ),
              const SizedBox(height: 12),
              const _SubTitle("E) Transformation notable"),
              _Paragraph.rich([
                const TextSpan(text: "Voir "),
                TextSpan(
                  text: "NATINF 6241",
                  style: GoogleFonts.fustat(fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              const _Paragraph(
                "Tout véhicule ayant subi des transformations notables modifiant les caractéristiques du CI "
                "doit faire l’objet d’une nouvelle réception, et le propriétaire doit demander un nouveau CI "
                "dans le mois suivant la transformation (ex : camionnette aménagée en transport de personnes).",
              ),
              const SizedBox(height: 10),
              const _NotaBox(
                title: "NOTA",
                bodySpans: [
                  TextSpan(
                    text:
                        "Certains engins de compétition/loisirs non destinés à circuler (ex : pocket-bike) ne sont pas soumis à réception "
                        "et ne peuvent pas recevoir de certificat d’immatriculation : interdits de circulation sur voie publique/lieux ouverts.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Infractions / NATINF
          _ConditionCard(
            title: "VI — Infractions (NATINF) & bases légales",
            cardColor: cardInfra,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              const _SubTitle("Infractions principales"),
              _Paragraph.rich([
                TextSpan(
                  text: "NATINF 7543",
                  style: GoogleFonts.fustat(fontWeight: FontWeight.w900),
                ),
                const TextSpan(
                  text:
                      " — Mise en circulation sans certificat d’immatriculation (base : ",
                ),
                _lawSpan("R. 322-1 du Code de la route"),
                const TextSpan(text: ")."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: "NATINF 6234",
                  style: GoogleFonts.fustat(fontWeight: FontWeight.w900),
                ),
                const TextSpan(
                  text:
                      " — Utilisation non conforme d’un certificat provisoire / titre provisoire (base : ",
                ),
                _lawSpan("R. 322-3 du Code de la route"),
                const TextSpan(text: ")."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: "NATINF 7544",
                  style: GoogleFonts.fustat(fontWeight: FontWeight.w900),
                ),
                const TextSpan(
                  text:
                      " — Maintien en circulation après cession sans CI au nom du nouveau propriétaire (base : ",
                ),
                _lawSpan("R. 322-5 du Code de la route"),
                const TextSpan(
                  text: ") — AF min. 4e classe, immobilisation possible.",
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: "NATINF 6237",
                  style: GoogleFonts.fustat(fontWeight: FontWeight.w900),
                ),
                const TextSpan(
                  text:
                      " — Non-déclaration de cession dans les 15 jours (base : ",
                ),
                _lawSpan("R. 322-4 du Code de la route"),
                const TextSpan(text: ") — AF min. 4e classe."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: "NATINF 6224",
                  style: GoogleFonts.fustat(fontWeight: FontWeight.w900),
                ),
                const TextSpan(
                  text:
                      " — Non-déclaration de changement de domicile dans le mois (base : ",
                ),
                _lawSpan("R. 322-7 du Code de la route"),
                const TextSpan(text: ") — AF min. 4e classe."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: "NATINF 6241",
                  style: GoogleFonts.fustat(fontWeight: FontWeight.w900),
                ),
                const TextSpan(
                  text:
                      " — Non-déclaration de transformation dans le mois (base : ",
                ),
                _lawSpan("R. 322-8 du Code de la route"),
                const TextSpan(text: ") — AF min. 4e classe."),
              ]),
              const SizedBox(height: 12),
              _NotaBox(
                title: "Attention",
                bodySpans: [
                  TextSpan(
                    text: "NATINF 28690",
                    style: GoogleFonts.fustat(fontWeight: FontWeight.w900),
                  ),
                  const TextSpan(
                    text:
                        " : déclaration mensongère certifiant la cession (y compris destruction). "
                        "Les A.P.J.A. ne sont pas habilités à constater les délits par procès-verbal.",
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
