import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

/// ===================================================================
///  COP'IQ — CONTRÔLE DE LA CONSTITUTIONNALITÉ DES LOIS
///
///  D’après le polycopié :
///
///   I.  Constitution, suprématie et distinction constitutions souples / rigides
///   II. Procédure de révision de la Constitution
///   III. Procédure de contrôle de la Constitution
///   IV. Contrôle effectif : voie d’exception, juridiction constitutionnelle,
///       question prioritaire de constitutionnalité (QPC).
/// ===================================================================
class PaControleConstitutionnaliteLoisPage extends StatelessWidget {
  const PaControleConstitutionnaliteLoisPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/libertes_publiques/garanties/controle_constitutionnalite_lois';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    final Color background = isDark ? const Color(0xFF121212) : Colors.white;
    final Color cardColor = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF7F7F7);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF5D4037);
    final Color textColor = isDark ? Colors.white70 : const Color(0xFF424242);
    final Color accentColor = isDark
        ? const Color(0xFF00796B)
        : const Color(0xFF00695C);
    final Color referenceColor = isDark
        ? const Color(0xFF80CBC4)
        : const Color(0xFF00897B);

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
          ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00001", 'Contrôle de la constitutionnalité des lois'),
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 17,
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
            ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00002", 'Le contrôle de la constitutionnalité des lois'),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 6),
           _Paragraph.rich([
            TextSpan(
              text:
                  ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00003", 'La Constitution est la norme suprême de l’État : toutes les lois devraient lui être conformes. ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00004", 'Mais cette supériorité n’a de sens que si elle est accompagnée d’un mécanisme de contrôle. ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00005", 'Comprendre qui contrôle, quand et comment, est indispensable pour mesurer la solidité de la protection des libertés publiques.'),
            ),
          ]),
          const SizedBox(height: 16),
          _NotaBox(
            title: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00006", 'Idée-clé'),
            bodySpans: [
              TextSpan(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00007", 'Sans contrôle de constitutionnalité effectif, la supériorité de la Constitution resterait purement théorique : ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00008", 'une loi portant atteinte aux libertés pourrait être appliquée malgré tout. Le contrôle est donc un outil central de l’État de droit.'),
                style: TextStyle(color: textColor),
              ),
            ],
          ),
          const SizedBox(height: 22),

          // =====================================================
          // I — CONSTITUTION SOUPLE / RIGIDE & SUPRÉMATIE
          // =====================================================
          _HypoCard(
            title: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00009", 'I — Suprématie constitutionnelle et types de Constitution'),
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
               _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00010", 'Dans la plupart des États modernes, la Constitution est considérée comme une norme ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00011", 'supérieure aux autres, notamment aux lois ordinaires. Mais cette supériorité ne se ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00012", 'manifeste pas de la même manière partout : tout dépend du type de Constitution adopté.'),
              ),
              const SizedBox(height: 10),
               _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00013", 'Constitution souple : '),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00014", 'la Constitution peut être révisée par la même procédure que la loi ordinaire. ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00015", 'Elle a, en pratique, la même valeur juridique que les lois votées par le Parlement. ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00016", 'La loi n’est pas tenue de respecter un texte supérieur intangible.'),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00017", 'Constitution rigide : '),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00018", 'la révision constitutionnelle obéit à une procédure distincte et plus exigeante ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00019", '(majorités renforcées, référendum, etc.). La Constitution est alors clairement ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00020", 'supérieure aux lois ordinaires, qui doivent impérativement lui être conformes.'),
                ),
              ]),
              const SizedBox(height: 8),
              _NotaBox(
                title: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00021", 'Conséquence pratique'),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00022", 'Dans un système de Constitution souple, la supériorité de la Constitution est faible ou inexistante. ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00023", 'Dans un système rigide, elle devient un véritable outil de protection des droits fondamentaux, ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00024", 'à condition d’être assortie d’un mécanisme de contrôle efficace.'),
                    style: TextStyle(color: textColor),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // =====================================================
          // CHAPITRE 1 — PROCÉDURE DE RÉVISION
          // =====================================================
          _HypoCard(
            title: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00025", 'Chapitre 1 — La procédure de révision de la Constitution'),
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children:  [
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00026", 'La manière dont on révise la Constitution dépend du type de régime : souple ou rigide. ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00027", 'Cette procédure révèle le degré de protection accordé au texte constitutionnel.'),
              ),
              SizedBox(height: 10),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00028", 'Dans un État à Constitution souple : '),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00029", 'la Constitution peut être modifiée par le même procédé que la loi ordinaire ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00030", '(même organe, même majorité, même procédure). Elle est donc facilement révisable.'),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00031", 'Dans un État à Constitution rigide : '),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00032", 'une procédure spécifique est prévue : intervention obligatoire du peuple, ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00033", 'majorité qualifiée, double vote, délai entre les lectures… L’idée est de ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00034", 'rendre la révision plus solennelle et plus difficile, afin de préserver la stabilité du texte.'),
                ),
              ]),
              SizedBox(height: 8),
              _ExempleBox(
                title: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00035", 'Exemple français'),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00036", 'En France, l’article 89 de la Constitution de 1958 prévoit que la révision doit être ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00037", 'adoptée en termes identiques par l’Assemblée nationale et le Sénat, puis approuvée ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00038", 'par référendum ou par le Parlement réuni en Congrès à la majorité des 3/5. ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00039", 'On est donc clairement dans un régime de Constitution rigide.'),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // =====================================================
          // CHAPITRE 2 — PROCÉDURE DE CONTRÔLE DE LA CONSTITUTION
          // =====================================================
          _HypoCard(
            title: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00040", 'Chapitre 2 — La procédure de contrôle de la Constitution'),
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children:  [
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00041", 'Au-delà de la révision, se pose la question du respect quotidien de la Constitution par les lois. ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00042", 'Là encore, tout dépend du système adopté.'),
              ),
              SizedBox(height: 10),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00043", 'Dans une Constitution souple : '),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00044", 'la loi ordinaire n’est pas tenue de respecter les règles inscrites dans la Constitution. ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00045", 'Elle peut même les contredire sans qu’aucune sanction particulière ne soit prévue. ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00046", 'La supériorité de la Constitution reste alors largement théorique.'),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00047", 'Dans une Constitution rigide : '),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00048", 'toute loi doit respecter la Constitution et les textes qui en font partie intégrante ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00049", '(déclarations de droits, préambules, chartes). Toute norme législative contraire ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00050", 'est dite inconstitutionnelle et devrait être écartée ou annulée.'),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00051", 'Il devient alors indispensable de prévoir un mécanisme de contrôle pour constater ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00052", 'l’inconstitutionnalité et empêcher l’application de la loi contraire. Sans cela, ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00053", 'la supériorité de la Constitution resterait sans effet concret.'),
              ),
            ],
          ),

          const SizedBox(height: 26),

          // =====================================================
          // CHAPITRE 3 — CONTRÔLE EFFECTIF DE LA CONSTITUTIONNALITÉ
          // =====================================================
          _HypoCard(
            title:
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00054", 'Chapitre 3 — Le contrôle effectif de la constitutionnalité des lois'),
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
               _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00055", 'L’exercice réel du contrôle suppose la saisine d’organes juridictionnels compétents. ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00056", 'Deux grands modèles existent classiquement : le contrôle par voie d’exception et le ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00057", 'contrôle par une juridiction constitutionnelle spécialisée. En France, s’ajoute un ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00058", 'mécanisme original : la question prioritaire de constitutionnalité (QPC).'),
              ),
              const SizedBox(height: 14),

              // 3.1 – Voie d’exception
              Text(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00059", '3.1 — Le contrôle de la constitutionnalité des lois par voie d’exception'),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
               _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00060", 'Dans ce système (emblématique des États-Unis), n’importe quel juge ordinaire peut, ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00061", 'à l’occasion d’un litige, vérifier la conformité de la loi qu’il doit appliquer à la Constitution. ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00062", 'S’il estime que la loi est contraire à la Constitution, il refuse simplement de l’appliquer au litige en cours.'),
              ),
              const SizedBox(height: 6),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00063", 'Le juge ne “supprime” pas la loi : il écarte son application dans l’affaire dont il est saisi. ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00064", 'Si une juridiction supérieure confirme cette analyse (Cour suprême, Cour de cassation…), ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00065", 'la norme inconstitutionnelle cessera progressivement d’être appliquée dans tout l’ordre juridique.'),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00066", 'Ce contrôle est diffus (tout juge peut l’exercer) et concret (lié à un litige précis). ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00067", 'Il offre une protection fine mais au prix d’une certaine incertitude juridique.'),
                ),
              ]),
              const SizedBox(height: 14),

              // 3.2 – Juridiction constitutionnelle
              Text(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00068", '3.2 — Le contrôle par une juridiction constitutionnelle'),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                 TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00069", 'Dans ce modèle, le contrôle est confié à un organe spécialisé : une juridiction constitutionnelle. ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00070", 'En France, il s’agit du '),
                ),
                TextSpan(
                  text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00071", 'Conseil constitutionnel'),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                 TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00072", ', créé par la Constitution de 1958. Cette juridiction a vocation à écarter toute disposition législative ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00073", 'contraire à la Constitution et à empêcher son entrée en vigueur.'),
                ),
              ]),
              const SizedBox(height: 6),
               _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00074", 'Contrôle a priori : '),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00075", 'en France, le Conseil constitutionnel peut être saisi avant la promulgation d’une loi. ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00076", 'La saisine est possible par le Président de la République, le Premier ministre, ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00077", 'les présidents de l’Assemblée nationale ou du Sénat, ou encore par 60 députés ou 60 sénateurs.'),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00078", 'Effet de la décision : '),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00079", 'une disposition déclarée inconstitutionnelle ne peut être promulguée ni appliquée. ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00080", 'Le contrôle est donc abstrait (portant sur le texte lui-même) et concentré (exercé par une seule juridiction).'),
                ),
              ]),
              const SizedBox(height: 14),

              // 3.3 – QPC
              Text(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00081", '3.3 — La question prioritaire de constitutionnalité (QPC)'),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                 TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00082", 'La révision du 23 juillet 2008 a introduit dans la Constitution de 1958 l’article 61-1. ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00083", 'Il permet à tout justiciable de soutenir, à l’occasion d’un procès en cours, qu’une disposition législative ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00084", 'porte atteinte aux droits et libertés que la Constitution garantit. '),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00085", 'Si la question est sérieuse, le Conseil constitutionnel peut être saisi pour trancher.'),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: referenceColor,
                  ),
                ),
              ]),
              const SizedBox(height: 8),
               _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00086", 'La procédure se déroule en trois grandes étapes, encadrées par une loi organique et un décret de 2010 :'),
              ),
              const SizedBox(height: 6),
               _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00087", '1) Devant la juridiction saisie du litige : '),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00088", 'la partie invoque la QPC. La juridiction vérifie si la disposition est applicable au litige, ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00089", 'si elle n’a pas déjà été déclarée conforme dans les mêmes circonstances et si la question présente un caractère sérieux. ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00090", 'Si ces conditions sont réunies, elle transmet la QPC au Conseil d’État ou à la Cour de cassation.'),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00091", '2) Devant le Conseil d’État ou la Cour de cassation : '),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00092", 'la haute juridiction exerce un second filtre. Elle dispose d’un délai limité pour décider ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00093", 's’il y a lieu de renvoyer la question au Conseil constitutionnel. En cas de refus, la juridiction ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00094", 'initiale statue sur le litige sans renvoi.'),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00095", '3) Devant le Conseil constitutionnel : '),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00096", 'saisi par renvoi, le Conseil se prononce sur la conformité de la disposition législative ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00097", 'aux droits et libertés garantis par la Constitution. Sa décision a une portée générale : ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00098", 'si la disposition est jugée inconstitutionnelle, elle est abrogée et ne peut plus être appliquée, ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00099", 'sauf réintroduction ultérieure dans un contexte de “changement de circonstances”.'),
                ),
              ]),
              const SizedBox(height: 8),
              _NotaBox(
                title: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00100", 'Intérêt de la QPC'),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00101", 'La QPC permet de contrôler des lois déjà en vigueur, souvent anciennes, à partir de situations concrètes. ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00102", 'Elle renforce considérablement la protection des libertés publiques, en donnant la parole au justiciable lui-même.'),
                    style: TextStyle(color: textColor),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 26),

          // ====================== SYNTHÈSE FINALE ======================
          _HypoCard(
            title: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00103", 'Synthèse — Lire la loi à la lumière de la Constitution'),
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children:  [
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00104", 'Pour le policier, la Constitution n’est pas un texte abstrait réservé aux juristes : ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00105", 'elle irrigue l’ensemble des lois qu’il applique au quotidien. Savoir qu’une mesure peut ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00106", 'être contrôlée, censurée ou abrogée en cas d’atteinte excessive aux droits fondamentaux ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00107", 'est un repère essentiel dans l’exercice de ses missions.'),
              ),
              SizedBox(height: 8),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00108", 'Toujours garder à l’esprit la hiérarchie des normes : la loi n’est valable ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00109", 'que si elle respecte la Constitution et les textes qui en font partie intégrante.'),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00110", 'Les mécanismes de contrôle (Conseil constitutionnel, QPC, conventions internationales) ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart", "f00111", 'sont des garde-fous qui protègent le citoyen… mais aussi le policier, en lui fournissant un cadre juridique clair.'),
                ),
              ]),
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
  const _ExempleBox({required this.bodySpans, this.title = 'NOTA'});

  final String title;
  final List<TextSpan> bodySpans;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color borderColor = isDark
        ? const Color(0xFF26A69A)
        : const Color(0xFF00897B);
    final Color bgColor = isDark
        ? const Color(0xFF00332B)
        : const Color(0xFFE0F2F1);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF5D4037);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: isDark ? .70 : .95),
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
                    : const Color(0xFF00251A).withValues(alpha: .95),
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
