import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

/// ===================================================================
///  COP'IQ — DROIT AU RESPECT DE LA VIE PRIVÉE
///
///   CHAPITRE 1 — LE RESPECT DE LA VIE PRIVÉE
///     1.1  La vidéoprotection
///     1.2  La protection pénale de la vie privée
///     1.3  La protection civile du respect de la vie privée
///
///   CHAPITRE 2 — LE DROIT AU SECRET DES CORRESPONDANCES
///     2.1  Protection pénale
///     2.2  Exceptions (contrôles, saisies, interceptions)
///
///   CHAPITRE 3 — LE DROIT AU RESPECT DU DOMICILE
///     3.1  Notion de domicile
///     3.2  Violation de domicile
///     3.3  Cas légaux permettant aux policiers de pénétrer dans un domicile
///     3.4  Le cas particulier de la fouille des véhicules
/// ===================================================================
class PaDroitViePriveePage extends StatelessWidget {
  const PaDroitViePriveePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/libertes_publiques/individuelles/droit_vie_privee';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    final Color background = isDark ? const Color(0xFF121212) : Colors.white;
    final Color cardColor = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF7F7F7);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF5D4037);
    final Color textColor = isDark ? Colors.white70 : const Color(0xFF424242);
    final Color accentColor = isDark
        ? const Color(0xFF6A1B9A)
        : const Color(0xFF6A1B9A);
    final Color referenceColor = isDark
        ? const Color(0xFFBA68C8)
        : const Color(0xFF6A1B9A);
    const dangerColor = Color(0xFFFF3B30);

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
          ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00001", "Droit au respect de la vie privée"),
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: titleColor,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 26),
        physics: const BouncingScrollPhysics(),
        children: [
          // =====================================================
          // INTRODUCTION GÉNÉRALE
          // =====================================================
          Text(
            ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00002", "Vie privée, domicile, correspondances et image"),
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
                  ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00003", "Le droit au respect de la vie privée protège la sphère personnelle de chaque individu : domicile, correspondances, image, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00004", "secret des informations relatives à la vie personnelle, familiale, sentimentale, professionnelle, à la santé, au patrimoine, aux opinions, etc. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00005", "Toute atteinte portée à cette sphère ne peut être légale que si elle est expressément prévue par un texte et strictement nécessaire à la réalisation de l’objectif poursuivi. "),
              style: TextStyle(color: textColor),
            ),
          ]),
          const SizedBox(height: 8),
          _Paragraph.rich([
            TextSpan(
              text:
                  ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00006", "La protection de ce droit trouve son fondement dans plusieurs textes juridiques majeurs :\n"),
              style: TextStyle(color: textColor),
            ),
          ]),
           _BulletPoint.rich([
            TextSpan(
              text:
                  ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00007", "l’article 12 de la Déclaration universelle des droits de l’Homme de l’Organisation des Nations unies, qui dispose que : ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00008", "« Nul ne fera l’objet d’immixtions arbitraires dans sa vie privée, sa famille, son domicile ou sa correspondance, ni d’atteintes à son honneur et à sa réputation. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00009", "Toute personne a droit à la protection de la loi contre de telles immixtions ou de telles atteintes » ;"),
            ),
          ]),
           _BulletPoint.rich([
            TextSpan(
              text:
                  ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00010", "l’article 8 de la Convention européenne de sauvegarde des droits de l’Homme et des libertés fondamentales, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00011", "qui consacre le droit de toute personne au respect de sa vie privée et familiale, de son domicile et de sa correspondance ;"),
            ),
          ]),
           _BulletPoint.rich([
            TextSpan(
              text:
                  ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00012", "la Déclaration des droits de l’Homme et du citoyen de 1789, notamment son article 2 qui garantit la liberté, la sûreté et la propriété, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00013", "et son article 9 relatif à la présomption d’innocence ;"),
            ),
          ]),
           _BulletPoint.rich([
            TextSpan(
              text:
                  ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00014", "la loi du 17 juillet 1970, qui assure la protection de la vie privée tant sur le plan pénal que sur le plan civil ;"),
            ),
          ]),
           _BulletPoint.rich([
            TextSpan(
              text:
                  ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00015", "l’article 9 du Code civil, qui énonce que « chacun a droit au respect de sa vie privée » ;"),
            ),
          ]),
           _BulletPoint.rich([
            TextSpan(
              text:
                  ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00016", "de nombreuses incriminations du Code pénal, qui sanctionnent la violation du secret des correspondances, la violation de domicile et diverses atteintes à l’intimité de la vie privée."),
            ),
          ]),
          const SizedBox(height: 8),
          _Paragraph.rich([
            TextSpan(
              text:
                  ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00017", "Le Conseil constitutionnel, après avoir longtemps refusé d’ériger le respect de la vie privée en principe de valeur constitutionnelle, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00018", "a précisé, dans une décision du 18 janvier 1995 rendue à l’occasion de la loi d’orientation et de programmation relative à la sécurité, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00019", "que la méconnaissance du droit au respect de la vie privée pouvait être de nature à porter atteinte à la liberté individuelle. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00020", "Par cette décision, les atteintes les plus graves au droit au respect de la vie privée relevaient alors de la compétence exclusive du juge judiciaire. "),
              style: TextStyle(color: textColor),
            ),
          ]),
          const SizedBox(height: 6),
          _Paragraph.rich([
            TextSpan(
              text:
                  ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00021", "Par la suite, le Conseil constitutionnel a rattaché explicitement ce principe à l’article 2 de la Déclaration des droits de l’Homme et du citoyen ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00022", "dans sa décision du 23 juillet 1999. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00023", "Ce rattachement a renforcé la protection constitutionnelle du droit au respect de la vie privée, qui relève désormais à la fois des juridictions de l’ordre judiciaire et de l’ordre administratif. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00024", "Cette analyse a été confirmée à l’occasion de questions prioritaires de constitutionnalité."),
              style: TextStyle(color: textColor),
            ),
          ]),
          const SizedBox(height: 10),
          _NotaBox(
            title: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00025", "Enjeu opérationnel pour les forces de l’ordre"),
            bodySpans: [
              TextSpan(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00026", "Toute intervention de police peut impliquer, directement ou indirectement, la vie privée : contrôle dans un domicile, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00027", "recueil d’informations personnelles, mise en œuvre de systèmes de vidéoprotection, fouille d’un véhicule, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00028", "exploitation de téléphones ou de messageries, diffusion d’images, interceptions de communications, etc. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00029", "La moindre erreur de base légale ou de procédure peut être constitutive d’une atteinte illégale à la vie privée, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00030", "exposant l’agent et l’institution à des conséquences pénales, civiles et disciplinaires."),
                style: TextStyle(color: textColor),
              ),
            ],
          ),
          const SizedBox(height: 22),

          // =====================================================
          // CHAPITRE 1 — LE RESPECT DE LA VIE PRIVÉE
          // =====================================================
          _HypoCard(
            title:
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00031", "Chapitre 1 — Le respect de la vie privée : un droit général protégé par le droit pénal et par le droit civil"),
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
               _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00032", "La vie privée n’est pas définie de manière précise par la loi du 17 juillet 1970. Les juridictions françaises en ont cependant une conception très large. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00033", "La jurisprudence et la doctrine définissent la vie privée comme le droit, pour tout individu, d’interdire à des tiers d’avoir accès à sa vie personnelle afin d’en préserver l’anonymat et l’intimité. "),
                ),
              ]),
              const SizedBox(height: 6),
               _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00034", "Relèvent ainsi de la vie privée tout ce qui a trait à la vie sentimentale, à la vie familiale, à l’état de santé, à la naissance, à la mort, au patrimoine, à la situation financière, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00035", "aux convictions personnelles, aux loisirs, à la vie professionnelle lorsqu’elle touche à l’intimité, à l’image de la personne, etc. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00036", "Il en résulte que la divulgation de faits relevant de la vie privée n’est licite que si ces faits sont déjà notoirement connus ou si la personne intéressée a donné son consentement. "),
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                 TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00037", "La loi du 17 juillet 1970 a organisé la protection de la vie privée sur deux plans complémentaires : "),
                ),
                TextSpan(
                  text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00038", "un plan pénal"),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                const TextSpan(text: " et "),
                TextSpan(
                  text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00039", "un plan civil."),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
              ]),
              const SizedBox(height: 10),
               _NotaBox(
                title: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00040", "Idée clé"),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00041", "Le droit au respect de la vie privée est une liberté fondamentale bénéficiant d’une double protection : ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00042", "protection pénale (par la création d’infractions spécifiques) et protection civile (par l’action en responsabilité et les mesures d’urgence destinées à faire cesser l’atteinte)."),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // =====================================================
          // 1.1 — LA VIDÉOPROTECTION
          // =====================================================
          _HypoCard(
            title: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00043", "1.1 — La vidéoprotection"),
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
               _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00044", "La loi du 21 janvier 1995 d’orientation et de programmation relative à la sécurité a autorisé le recours aux systèmes de vidéoprotection, anciennement appelés « vidéosurveillance ». ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00045", "Le titre V du Code de la sécurité intérieure, aux articles L. 251-1 et suivants, fixe les dispositions générales, les conditions de fonctionnement, les contrôles, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00046", "les droits d’accès ainsi que les dispositions pénales applicables. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00047", "L’objectif est de concilier la prévention des atteintes à l’ordre public avec la protection de la vie privée."),
                ),
              ]),
              const SizedBox(height: 12),

              // 1.1.1
              Text(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00048", "1.1.1 — Dispositions générales"),
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
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00049", "L’article L. 251-2 du Code de la sécurité intérieure prévoit que des systèmes de vidéoprotection peuvent être mis en œuvre sur la voie publique par les autorités publiques compétentes afin d’assurer notamment :"),
                  style: TextStyle(color: textColor),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00050", "la protection des bâtiments et installations publics et de leurs abords ;"),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00051", "la sauvegarde des installations utiles à la défense nationale ;"),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00052", "la régulation des flux de transport ;")),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00053", "la constatation des infractions aux règles de la circulation ;"),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00054", "la prévention des atteintes à la sécurité des personnes et des biens dans des lieux particulièrement exposés aux risques d’agression, de vol ou de trafic de stupéfiants, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00055", "ainsi que la prévention, dans des zones particulièrement exposées, des fraudes douanières et des délits relatifs à des fonds provenant de ces infractions ;"),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00056", "la prévention des actes de terrorisme, dans les conditions prévues par les articles L. 223-1 et suivants du Code de la sécurité intérieure ;"),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00057", "la prévention des risques naturels ou technologiques ;"),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00058", "le secours aux personnes et la défense contre l’incendie ;"),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00059", "la sécurité des installations accueillant du public dans les parcs d’attraction ;"),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00060", "le contrôle du respect de l’obligation d’assurance de responsabilité civile pour les véhicules terrestres à moteur ;"),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00061", "la prévention et la constatation des infractions relatives à l’abandon d’ordures, de déchets, de matériaux ou d’autres objets."),
                ),
              ]),
              const SizedBox(height: 6),
               _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00062", "Des systèmes de vidéoprotection peuvent également être mis en œuvre dans des lieux et établissements ouverts au public, afin d’y assurer la sécurité des personnes et des biens ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00063", "lorsque ces lieux sont particulièrement exposés à des risques d’agression ou de vol. "),
                ),
              ]),
               _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00064", "Après information du maire de la commune concernée et autorisation des autorités publiques compétentes, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00065", "des commerçants peuvent mettre en œuvre sur la voie publique un système de vidéoprotection pour assurer la protection des abords immédiats de leurs bâtiments et installations ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00066", "dans les lieux particulièrement exposés à des risques d’agression ou de vol. Les conditions de mise en œuvre et les types de bâtiments concernés sont définis par décret en Conseil d’État. "),
                ),
              ]),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00067", "Les opérations de vidéoprotection de la voie publique doivent être réalisées de telle sorte qu’elles ne permettent pas de visualiser l’intérieur des immeubles d’habitation, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00068", "ni, de façon spécifique, les entrées de ces immeubles (article L. 251-3 du Code de la sécurité intérieure)."),
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00069", "Dans chaque département, une commission départementale de vidéoprotection, présidée par un magistrat honoraire ou, à défaut, par une personnalité qualifiée nommée par le premier président de la cour d’appel, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00070", "est chargée de donner un avis au représentant de l’État dans le département (ou, à Paris, au préfet de police) sur les demandes d’autorisation de systèmes de vidéoprotection ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00071", "et d’exercer un contrôle sur les conditions de fonctionnement des systèmes autorisés. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00072", "La personnalité qualifiée est choisie en raison de sa compétence en matière de vidéoprotection ou de libertés individuelles (article L. 251-4 du Code de la sécurité intérieure)."),
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 14),

              // 1.1.2
              Text(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00073", "1.1.2 — Autorisations et conditions de fonctionnement"),
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
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00074", "L’installation d’un système de vidéoprotection est subordonnée à une autorisation du représentant de l’État dans le département ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00075", "(et, à Paris, du préfet de police), délivrée, sauf en matière de défense nationale, après avis de la commission départementale de vidéoprotection. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00076", "Lorsque le système comporte des caméras implantées sur le territoire de plusieurs départements, l’autorisation est délivrée par le représentant de l’État dans le département ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00077", "où est situé le siège social du demandeur ou, si ce siège est à Paris, par le préfet de police, après avis de la commission départementale compétente. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00078", "Les représentants de l’État des autres départements concernés sont informés de cette décision (article L. 252-1 du Code de la sécurité intérieure)."),
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00079", "L’autorisation préfectorale prescrit toutes les précautions utiles, en particulier en ce qui concerne la qualité des personnes chargées de l’exploitation du système et de la visualisation des images, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00080", "ainsi que les mesures nécessaires pour assurer le respect des dispositions des articles L. 251-1 à L. 255-1 du Code de la sécurité intérieure (article L. 252-2). ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00081", "Elle peut prévoir que des agents individuellement désignés et habilités des services de police et de gendarmerie nationales, des douanes, des services d’incendie et de secours, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00082", "ainsi que les agents des services de police municipale et de la Ville de Paris, soient destinataires des images et enregistrements. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00083", "Dans ce cas, l’autorisation précise les modalités de transmission des images, les conditions d’accès aux enregistrements et la durée de conservation des images, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00084", "dans la limite d’un mois à compter de cette transmission ou de cet accès, sans préjudice de la conservation nécessaire à une procédure pénale (article L. 252-3)."),
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00085", "Les systèmes de vidéoprotection sont autorisés pour une durée de cinq ans renouvelable. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00086", "Ils doivent être conformes à des normes techniques fixées par arrêté du ministre de l’Intérieur (article L. 252-4 du Code de la sécurité intérieure). ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00087", "En dehors des cas d’enquête de flagrance, d’enquête préliminaire ou d’information judiciaire, les enregistrements doivent être détruits dans un délai maximum fixé par l’autorisation, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00088", "sans pouvoir excéder un mois (article L. 252-5)."),
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00089", "Lorsque l’urgence et l’exposition particulière à un risque d’actes de terrorisme le justifient (article L. 223-4 du Code de la sécurité intérieure), ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00090", "le représentant de l’État dans le département, et à Paris le préfet de police, peuvent délivrer, sans avis préalable de la commission départementale, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00091", "une autorisation provisoire d’installation d’un système de vidéoprotection pour une durée maximale de quatre mois. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00092", "Le président de la commission est immédiatement informé et peut la réunir afin qu’elle donne un avis sur cette autorisation provisoire. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00093", "Une procédure similaire est prévue en cas de manifestation ou de rassemblement de grande ampleur présentant des risques particuliers pour la sécurité des personnes et des biens ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00094", "(articles L. 252-6 et L. 252-7 du Code de la sécurité intérieure)."),
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 14),

              // 1.1.3
              Text(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00095", "1.1.3 — Contrôle et droit d’accès"),
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
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00096", "La commission départementale de vidéoprotection peut, à tout moment, exercer un contrôle sur les conditions de fonctionnement des systèmes de vidéoprotection, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00097", "sauf en matière de défense nationale, pour vérifier leur conformité aux articles L. 251-2 et L. 251-3 du Code de la sécurité intérieure. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00098", "Elle peut émettre des recommandations et proposer la suspension ou la suppression des dispositifs non autorisés, non conformes à leur autorisation ou faisant l’objet d’un usage anormal. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00099", "Elle informe le maire de la commune concernée de ses propositions (article L. 253-1)."),
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00100", "Les membres de la commission départementale disposent d’un droit d’accès, de six heures à vingt et une heures, aux lieux, locaux, enceintes, installations ou établissements ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00101", "où est mis en œuvre un système de vidéoprotection, à l’exclusion des parties affectées au domicile privé. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00102", "Le procureur de la République territorialement compétent est préalablement informé. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00103", "Le responsable des locaux professionnels privés est informé de son droit de s’opposer à la visite. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00104", "En cas d’opposition, la visite ne peut avoir lieu qu’après autorisation du juge des libertés et de la détention du tribunal judiciaire compétent. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00105", "En cas d’urgence, de gravité des faits ou de risque de destruction de documents, la visite peut être autorisée sans information préalable du responsable, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00106", "sur décision du même juge. La visite se déroule alors sous son autorité et en présence de l’occupant ou de son représentant, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00107", "assisté éventuellement d’un conseil, ou, à défaut, en présence de deux témoins (article L. 253-3)."),
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00108", "À la demande de la commission départementale ou de sa propre initiative, le représentant de l’État dans le département, et à Paris le préfet de police, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00109", "peuvent ordonner la fermeture, pour une durée de trois mois, d’un établissement ouvert au public dans lequel est maintenu un système de vidéoprotection sans autorisation. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00110", "À l’issue de ce délai, si aucune régularisation n’a été demandée, l’autorité administrative peut enjoindre au responsable de démonter le système. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00111", "En cas de refus, une nouvelle mesure de fermeture pour trois mois peut être prise (article L. 253-4). ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00112", "Toute personne intéressée peut saisir la commission départementale de vidéoprotection de toute difficulté liée au fonctionnement d’un système (article L. 253-5)."),
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 12),

              // 1.1.4
              Text(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00113", "1.1.4 — Dispositions pénales"),
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
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00114", "Le fait d’entraver l’action de la commission départementale de vidéoprotection est puni d’un an d’emprisonnement et de quinze mille euros d’amende (article L. 254-1 du Code de la sécurité intérieure). ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00115", "Par ailleurs, le Code pénal sanctionne l’installation de caméras dans des lieux réservés à l’intimité (toilettes, cabines d’essayage, chambres, locaux syndicaux), ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00116", "la conservation d’images au-delà de la durée autorisée, leur diffusion illicite ou le détournement de finalité, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00117", " lorsque les images sont utilisées pour porter atteinte à la vie privée ou à la réputation d’une personne."),
                  style: TextStyle(color: textColor),
                ),
              ]),
            ],
          ),
          const SizedBox(height: 26),

          // =====================================================
          // 1.2 — PROTECTION PÉNALE DE LA VIE PRIVÉE
          // =====================================================
          _HypoCard(
            title: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00118", "1.2 — La protection pénale de la vie privée"),
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
               _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00119", "L’expansion démographique, le développement des moyens d’information et de communication, ainsi que le perfectionnement des techniques de captation de paroles ou d’images, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00120", "constituent des menaces potentielles pour le droit au respect de la vie privée. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00121", "Avant la loi du 17 juillet 1970 tendant à renforcer la garantie des droits individuels, aucune disposition générale ne sanctionnait les atteintes à la vie privée. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00122", "Cette loi a érigé plusieurs atteintes en infractions pénales spécifiques."),
                ),
              ]),
              const SizedBox(height: 12),

              // 1.2.1
              Text(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00123", "1.2.1 — L’atteinte à l’intimité de la vie privée"),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00124", "Article 226-1 du Code pénal : "),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                 TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00125", "est puni le fait, au moyen d’un procédé quelconque, de porter volontairement atteinte à l’intimité de la vie privée d’autrui, notamment :"),
                ),
              ]),
              const SizedBox(height: 4),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00126", "en captant, enregistrant ou transmettant, sans le consentement de leur auteur, des paroles prononcées à titre privé ou confidentiel ;"),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00127", "en fixant, enregistrant ou transmettant, sans le consentement de la personne concernée, l’image d’une personne se trouvant dans un lieu privé ;"),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00128", "en captant, enregistrant ou transmettant, par quelque moyen que ce soit, la localisation, en temps réel ou en différé, d’une personne sans son consentement."),
                ),
              ]),
              const SizedBox(height: 4),
               _NotaBox(
                title: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00129", "Pour les policiers"),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00130", "La captation clandestine d’images, de sons ou de données de localisation par un agent, en dehors de tout cadre légal ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00131", "(enquête, information judiciaire, réquisition d’un magistrat), peut constituer directement une atteinte à l’intimité de la vie privée au sens de l’article 226-1 du Code pénal. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00132", "Cette incrimination fait l’objet d’un développement approfondi dans le fascicule de droit pénal spécial relatif aux crimes et délits contre les personnes."),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 1.2.2
              Text(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00133", "1.2.2 — Conservation, divulgation ou utilisation d’un enregistrement ou d’un document obtenu par une atteinte à la vie privée"),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00134", "Article 226-2 du Code pénal : "),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                 TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00135", "incrimine le fait de conserver, de porter ou de laisser porter à la connaissance du public, ou d’utiliser, un enregistrement ou un document ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00136", "obtenu dans les conditions prévues par l’article 226-1 du Code pénal, sans le consentement de la personne concernée. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00137", "Il s’agit d’une infraction de conséquence, qui sanctionne la diffusion ou l’exploitation d’un enregistrement illicite. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00138", "Cette incrimination fait également l’objet d’un développement spécifique en droit pénal spécial."),
                ),
              ]),
              const SizedBox(height: 12),

              // 1.2.3
              Text(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00139", "1.2.3 — Les caméras piétons"),
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
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00140", "L’article L. 241-1 du Code de la sécurité intérieure pérennise le dispositif des caméras individuelles portées par les agents de la police nationale et les militaires de la gendarmerie nationale ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00141", "dans l’exercice de leurs missions de prévention des atteintes à l’ordre public, de protection de la sécurité des personnes et des biens, et de missions de police judiciaire. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00142", "Ces enregistrements ne peuvent être permanents. Ils peuvent être mis en œuvre en tous lieux, y compris dans des lieux privés, en vue :"),
                  style: TextStyle(color: textColor),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00143", "de la prévention des incidents au cours des interventions ;"),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00144", "du constat des infractions et de la poursuite de leurs auteurs par la collecte de preuves ;"),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00145", "de la formation et de la pédagogie des agents."),
                ),
              ]),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00146", "Lorsque la sécurité des agents ou celle des personnes et des biens est menacée, les images captées au moyen de ces caméras peuvent être transmises en temps réel ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00147", "au poste de commandement du service concerné et aux personnels impliqués dans la conduite de l’intervention. "),
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00148", "Des obligations strictes pèsent sur les fonctionnaires autorisés à porter ces caméras : elles sont fournies par le service, doivent être portées de manière apparente ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00149", "et doivent être dotées d’un signal permettant d’indiquer qu’un enregistrement est en cours ; ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00150", "les personnes filmées doivent être informées, sauf circonstances rendant cette information impossible ; ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00151", "les agents ne peuvent accéder aux enregistrements qu’à la condition que cette consultation soit nécessaire pour faciliter la recherche d’auteurs d’infractions, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00152", "la prévention d’atteintes imminentes à l’ordre public, le secours aux personnes ou l’établissement fidèle des faits dans les comptes rendus d’intervention. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00153", "Les articles R. 241-1 à R. 241-7 du Code de la sécurité intérieure précisent les modalités de traitement des données issues de ces enregistrements. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00154", "Une instruction du premier mars deux mille dix-sept, complétée par une instruction conjointe de la direction générale de la police nationale et de la direction générale de la gendarmerie nationale du dix-neuf novembre deux mille dix-neuf, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00155", "fixe les règles d’emploi opérationnel des caméras piétons."),
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 10),

              // 1.2.4
              Text(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00156", "1.2.4 — Diffusion, sans l’accord de la personne concernée, d’un enregistrement ou d’un document à caractère sexuel"),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
               _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00157", "Article 226-2-1 du Code pénal : "),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: dangerColor,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00158", "incrimine le fait, en l’absence d’accord de la personne pour la diffusion, de porter à la connaissance du public ou d’un tiers tout enregistrement ou tout document ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00159", "portant sur des paroles ou des images présentant un caractère sexuel, obtenu avec le consentement exprès ou présumé de la personne, ou réalisé par elle-même, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00160", "à l’aide d’un des procédés prévus à l’article 226-1 du Code pénal. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00161", "Cette pratique est couramment désignée sous le terme de « pornodivulgation », souvent connue sous l’appellation anglophone « revenge porn ». ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00162", "Cette infraction est détaillée dans le fascicule de droit pénal spécial consacré aux crimes et délits contre les personnes."),
                ),
              ]),
              const SizedBox(height: 10),

              // 1.2.5
              Text(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00163", "1.2.5 — L’atteinte à l’intimité d’une personne : le voyeurisme"),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00164", "Article 226-3-1 du Code pénal : "),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                 TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00165", "définit et réprime le voyeurisme comme « le fait d’user de tout moyen afin d’apercevoir les parties intimes d’une personne que celle-ci, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00166", "du fait de son habillement ou de sa présence dans un lieu clos, a cachées à la vue des tiers, lorsque cela est commis à l’insu ou sans le consentement de la personne ». ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00167", "Cette infraction vise à protéger l’intimité corporelle et la dignité de la personne."),
                ),
              ]),
              const SizedBox(height: 10),

              // 1.2.6
              Text(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00168", "1.2.6 — L’atteinte à la représentation de la personne (montages, trucages, hypertrucages)"),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00169", "Article 226-8 du Code pénal : "),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                 TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00170", "incrimine le fait de porter à la connaissance du public ou d’un tiers, par quelque moyen que ce soit, un montage réalisé avec les paroles ou l’image d’une personne, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00171", "sans son consentement, lorsqu’il n’apparaît pas clairement qu’il s’agit d’un montage ou lorsqu’il n’en est pas fait mention. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00172", "Est également puni, dans les mêmes conditions, le fait de diffuser un contenu visuel ou sonore généré par un traitement algorithmique, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00173", "représentant l’image ou les paroles d’une personne, sans son consentement, lorsqu’il n’apparaît pas à l’évidence qu’il s’agit d’un contenu généré artificiellement ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00174", "ou lorsqu’il n’en est pas fait mention. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00175", "Ce texte vise notamment les hypertrucages (« deepfakes ») créés à l’aide d’outils d’intelligence artificielle. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00176", "L’enjeu principal n’est pas seulement l’intimité, mais la protection de la dignité et de l’honnêteté de la représentation de la personne."),
                ),
              ]),
            ],
          ),
          const SizedBox(height: 26),

          // =====================================================
          // 1.3 — PROTECTION CIVILE DU RESPECT DE LA VIE PRIVÉE
          // =====================================================
          _HypoCard(
            title: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00177", "1.3 — La protection civile du respect de la vie privée"),
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00178", "Article 9 du Code civil : "),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                 TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00179", "énonce que « chacun a droit au respect de sa vie privée ». ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00180", "Les juridictions rappellent fréquemment que toute personne est fondée à fixer elle-même les limites de ce qui peut être rendu public ou non. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00181", "Les personnalités publiques bénéficient, au même titre que toute autre personne, de ce droit au respect de leur vie privée, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00182", "notamment en matière de santé, de vie sentimentale ou familiale."),
                ),
              ]),
              const SizedBox(height: 8),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00183", "De nombreux arrêts ont confirmé cette protection, concernant notamment Brigitte Bardot, Isabelle Adjani, Alain Delon, Jacques Brel, etc., ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00184", "à propos de la publication de photographies ou d’éléments relevant de leur intimité."),
                ),
              ]),
              const SizedBox(height: 4),
               _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00185", "Le droit au respect de la vie privée s’étend au-delà de la mort, incluant le respect dû à la dépouille mortelle. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00186", "La publication, sans l’accord de la famille, de photographies d’une personne célèbre sur son lit de mort a été jugée constitutive d’une atteinte au droit au respect de la vie privée des proches. "),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00187", "Des décisions ont ainsi concerné, par exemple, Jean Gabin, Pauline Carton, Coluche, et d’autres personnalités dont l’image a été diffusée après leur décès sans autorisation."),
                ),
              ]),
              const SizedBox(height: 8),
               _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00188", "Toute divulgation d’aspects de la vie privée d’une personne, sans son consentement, peut être sanctionnée civilement. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00189", "Plusieurs textes fondamentaux encadrent les actions ouvertes à la victime :"),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00190", "article 1240 du Code civil : « tout fait quelconque de l’homme, qui cause à autrui un dommage, oblige celui par la faute duquel il est arrivé à le réparer ». ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00191", "Une atteinte à la vie privée peut donc fonder une action en responsabilité civile ;"),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00192", "article 9, alinéa 2, du Code civil : « les juges peuvent, sans préjudice de la réparation du dommage subi, prescrire toutes mesures, telles que séquestre, saisie et autres, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00193", "propres à empêcher ou faire cesser une atteinte à l’intimité de la vie privée ; ces mesures peuvent, s’il y a urgence, être ordonnées en référé » ;"),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00194", "article 835 du Code de procédure civile : le président du tribunal judiciaire ou le juge des contentieux de la protection peuvent, en référé, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00195", "prescrire les mesures conservatoires ou de remise en état qui s’imposent, pour prévenir un dommage imminent ou faire cesser un trouble manifestement illicite. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00196", "Ce texte fait du juge des référés le juge de droit commun des atteintes à la vie privée en urgence."),
                ),
              ]),
              const SizedBox(height: 8),
               _ExempleBox(
                title: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00197", "Exemple jurisprudentiel"),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00198", "La diffusion de photographies d’une personnalité publique prises dans sa propriété privée, sans son consentement, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00199", "constitue une atteinte à la vie privée, même si la personne est de grande notoriété. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00200", "Le droit à l’information du public ne justifie pas la divulgation d’éléments dépourvus d’intérêt général."),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 26),

          // =====================================================
          // CHAPITRE 2 — LE SECRET DES CORRESPONDANCES
          // =====================================================
          _HypoCard(
            title: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00201", "Chapitre 2 — Le droit au secret des correspondances"),
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
               _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00202", "L’inviolabilité des correspondances, qu’elles soient écrites, téléphoniques ou électroniques, protège la relation – souvent secrète – entre, en principe, deux personnes identifiées. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00203", "Cette protection vise les échanges de pensées et de sentiments par tout moyen de communication : lettres, courriels, messages électroniques, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00204", "services de messagerie instantanée, communications téléphoniques, échanges par voie numérique, etc. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00205", "Toute ingérence dans ce secret constitue, en principe, une infraction pénale, sauf si elle est expressément autorisée par la loi pour des motifs d’ordre public."),
                ),
              ]),
              const SizedBox(height: 12),

              Text(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00206", "2.1 — La protection pénale du droit au secret des correspondances"),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),

              // 2.1.1
              Text(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00207", "2.1.1 — Atteinte au secret des correspondances commise par des particuliers"),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                  color: referenceColor,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00208", "Article 226-15 du Code pénal : "),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                 TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00209", "définit et réprime le fait, commis de mauvaise foi, d’ouvrir, de supprimer, de retarder ou de détourner des correspondances ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00210", "arrivées ou non à destination et adressées à des tiers, ou d’en prendre frauduleusement connaissance. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00211", "Sont également punis, dans les mêmes conditions, le fait d’intercepter, de détourner, d’utiliser ou de divulguer des correspondances émises, transmises ou reçues par voie électronique, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00212", "ou le fait de procéder à l’installation d’appareils permettant de réaliser de telles interceptions. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00213", "Cette infraction est étudiée en détail dans le fascicule de droit pénal spécial relatif aux crimes et délits contre les personnes."),
                ),
              ]),
              const SizedBox(height: 8),

              // 2.1.2
              Text(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00214", "2.1.2 — Atteinte au secret des correspondances commise par des fonctionnaires publics"),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                  color: referenceColor,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00215", "Article 432-9 du Code pénal : "),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                 TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00216", "prévoit que le fait, pour une personne dépositaire de l’autorité publique ou chargée d’une mission de service public, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00217", "agissant dans l’exercice ou à l’occasion de l’exercice de ses fonctions, d’ordonner, de commettre ou de faciliter, hors les cas prévus par la loi, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00218", "le détournement, la suppression ou l’ouverture de correspondances, ou la révélation de leur contenu, est puni de trois ans d’emprisonnement et de quarante-cinq mille euros d’amende. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00219", "Sont également punis, dans les mêmes conditions, les actes d’interception ou de détournement de correspondances électroniques, ou la divulgation de leur contenu, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00220", "commis par ces mêmes personnes ou par les agents d’exploitants de réseaux ouverts au public de communications électroniques ou de fournisseurs de services de télécommunications. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00221", "Cette infraction est étudiée dans le fascicule de droit pénal spécial consacré aux crimes et délits contre la nation, l’État et la paix publique."),
                ),
              ]),
              const SizedBox(height: 12),

              // 2.2
              Text(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00222", "2.2 — Les exceptions au principe d’inviolabilité des correspondances"),
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
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00223", "Ces exceptions sont strictement définies par la loi et justifiées par des motifs d’ordre public : poursuites pénales, lutte contre la criminalité organisée ou le terrorisme, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00224", "sécurité nationale, protection des droits d’autrui, prévention de certaines infractions graves, etc."),
                ),
              ]),
              const SizedBox(height: 8),

              Text(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00225", "2.2.1 — Les contrôles et saisies"),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                  color: referenceColor,
                ),
              ),
              const SizedBox(height: 4),
               _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00226", "Lorsque ces contrôles et saisies sont réalisés dans un cadre judiciaire, ils peuvent être effectués par le juge d’instruction, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00227", "par le procureur de la République en cas de flagrant délit, ou par un officier de police judiciaire agissant sur commission rogatoire ou dans un cadre de flagrance. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00228", "Des contrôles administratifs sont également possibles, par exemple pour la correspondance des personnes détenues (à l’exception des échanges avec leur avocat ou leur aumônier), ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00229", "ou dans certains établissements psychiatriques pour le courrier des malades mentaux. "),
                ),
              ]),
               _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00230", "Dans des contextes particuliers, comme en temps de guerre, dans le cadre de régimes d’exception (état d’urgence, état de siège, état de crise) ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00231", "ou encore en matière de faillite, la correspondance peut faire l’objet de censures ou de contrôles dans le but de protéger les droits d’autrui, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00232", "la masse des créanciers ou la sécurité de l’État."),
                ),
              ]),
              const SizedBox(height: 8),

              Text(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00233", "2.2.2 — Les interceptions de correspondances émises par la voie des communications électroniques"),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                  color: referenceColor,
                ),
              ),
              const SizedBox(height: 4),
               _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00234", "Il convient de distinguer les interceptions ordonnées par l’autorité judiciaire dans le cadre du droit commun ou de la criminalité et de la délinquance organisées, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00235", "et les interceptions dites « de sécurité », autorisées à des fins de renseignement."),
                ),
              ]),
              const SizedBox(height: 6),

              Text(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00236", "2.2.2.1 — Les interceptions ordonnées par l’autorité judiciaire en droit commun"),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                  color: referenceColor,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00237", "Les articles 100 à 100-8 du Code de procédure pénale encadrent les interceptions judiciaires de correspondances émises par la voie des télécommunications. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00238", "Ces interceptions ne peuvent être ordonnées que si la peine encourue pour l’infraction est au moins égale à trois ans d’emprisonnement ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00239", "et si les nécessités de l’information l’exigent. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00240", "Elles sont décidées par le juge d’instruction, par une décision écrite et motivée, pour une durée maximale de quatre mois, renouvelable dans les mêmes conditions de forme. "),
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 4),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00241", "Lorsque l’interception vise le cabinet ou le domicile d’un avocat, le bâtonnier doit être informé ;"),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00242", "lorsque la personne visée est un parlementaire, le président de l’assemblée concernée doit être informé préalablement ;"),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00243", "lorsque l’interception concerne un magistrat, le premier président ou le procureur général de la juridiction où il réside doit être informé."),
                ),
              ]),
              const SizedBox(height: 8),

              Text(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00244", "2.2.2.1.2 — Les interceptions dans le cadre de la criminalité et de la délinquance organisées"),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                  color: referenceColor,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00245", "L’article 706-95 du Code de procédure pénale permet, lorsque les nécessités d’une enquête de flagrance ou d’une enquête préliminaire portant sur des infractions ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00246", "relevant des articles 706-73 et 706-73-1 (criminalité et délinquance organisées) l’exigent, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00247", "au juge des libertés et de la détention, saisi par le procureur de la République, d’autoriser l’interception, l’enregistrement et la transcription de correspondances électroniques ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00248", "pour une durée maximale d’un mois, renouvelable une fois dans les mêmes conditions. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00249", "Les opérations sont réalisées sous le contrôle du juge des libertés et de la détention. "),
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00250", "L’article 706-95-1 du Code de procédure pénale permet également, dans les mêmes domaines, d’autoriser l’accès à distance, à l’insu de la personne visée, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00251", "aux correspondances stockées par voie électronique, au moyen d’un identifiant informatique. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00252", "Les données ainsi obtenues peuvent être saisies, enregistrées ou copiées sur tout support. "),
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 8),

              Text(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00253", "2.2.2.2 — Les interceptions de sécurité et l’accès aux données de connexion"),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                  color: referenceColor,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00254", "La loi du vingt-quatre juillet deux mille quinze relative au renseignement a donné un cadre légal aux techniques mises en œuvre par les services de renseignement, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00255", "et notamment aux interceptions de sécurité et aux accès aux données de connexion. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00256", "Elle a instauré un régime d’autorisation administrative qui concerne l’ensemble des techniques de recueil de renseignement. "),
                  style: TextStyle(color: textColor),
                ),
              ]),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00257", "L’autorisation d’une interception de sécurité est délivrée par le Premier ministre, par une décision écrite et motivée, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00258", "pour une durée maximale de quatre mois renouvelable (article L. 821-4 du Code de la sécurité intérieure). ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00259", "Cette décision doit préciser la ou les techniques utilisées, le service demandeur, la ou les finalités et motifs des mesures, la durée de validité, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00260", "ainsi que les personnes, lieux ou véhicules concernés (article L. 821-2). "),
                  style: TextStyle(color: textColor),
                ),
              ]),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00261", "La Commission nationale de contrôle des techniques de renseignement, autorité administrative indépendante, veille à ce que ces techniques soient mises en œuvre ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00262", "conformément aux dispositions du Code de la sécurité intérieure (article L. 833-1). ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00263", "Même dans la lutte contre le terrorisme ou la criminalité organisée, le secret des correspondances demeure la règle : ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00264", "toute ingérence doit rester exceptionnelle, nécessaire et proportionnée."),
                  style: TextStyle(color: textColor),
                ),
              ]),
            ],
          ),
          const SizedBox(height: 26),

          // =====================================================
          // CHAPITRE 3 — LE DROIT AU RESPECT DU DOMICILE
          // =====================================================
          _HypoCard(
            title: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00265", "Chapitre 3 — Le droit au respect du domicile"),
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              // 3.1
              Text(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00266", "3.1 — La notion de domicile"),
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
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00267", "La chambre criminelle de la Cour de cassation a jugé, le vingt-deux janvier mille neuf cent quatre-vingt-dix-sept, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00268", "que constitue un domicile « non seulement le lieu où une personne a son principal établissement, mais encore le lieu où, qu’elle y habite ou non, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00269", "elle a le droit de se dire chez elle, quels que soient le titre juridique de son occupation et l’affectation donnée aux locaux ». ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00270", "La notion de domicile comprend donc aussi bien le domicile légal, la résidence habituelle que le lieu de séjour occasionnel, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00271", "à condition qu’il protège l’intimité de la personne."),
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00272", "La protection attachée au domicile ne recouvre pas exactement la distinction entre lieux publics et lieux privés. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00273", "Dans les établissements ouverts au public, comme un hôpital ou un centre d’accueil pour personnes toxicomanes, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00274", "il convient de distinguer :"),
                  style: TextStyle(color: textColor),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00275", "les espaces publics (halls d’accueil, salles d’attente), où les forces de l’ordre peuvent procéder à des contrôles ou à des interpellations ;"),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00276", "les espaces privés (chambres de patients, bureaux individuels du personnel), qui doivent être considérés comme des domiciles et bénéficier de la protection afférente."),
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00277", "Pour tenir compte de certaines situations, la Cour de cassation a développé la notion de « lieu normalement clos ». ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00278", "Même lorsqu’un endroit ne constitue pas à proprement parler un domicile, il n’est pas pour autant libre d’accès pour les forces de l’ordre s’il est normalement fermé au public. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00279", "Ces lieux bénéficient alors d’une protection proche de celle accordée au domicile."),
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00280", "Sont considérés comme des domiciles, notamment :"),
                  style: TextStyle(color: textColor),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00281", "l’appartement loué, la maison de campagne, la maison de vacances, la demeure momentanément inoccupée ;"),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00282", "les dépendances d’une maison se trouvant dans l’enceinte ou à proximité immédiate de celle-ci, dès lors qu’elles en constituent le prolongement : débarras, garage, balcon, terrasse, poulailler, remise, cour close d’un immeuble, etc. ;"),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00283", "le logement occupé sans titre mais paisiblement, la chambre d’hôtel ;"),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00284", "le bureau ou les locaux professionnels fermés au public (pendant les heures de fermeture) ;"),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00285", "le véhicule aménagé pour l’habitation, la caravane, la roulotte, la tente servant de résidence ;"),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00286", "le yacht de plaisance, le voilier de haute mer ou la péniche habitable."),
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00287", "La jurisprudence a également admis que certains lieux peuvent être assimilés au domicile, par exemple :"),
                  style: TextStyle(color: textColor),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00288", "un box fermé non attenant au domicile ;")),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00289", "un garage situé dans un parking souterrain, lorsque ce garage est considéré comme l’annexe du domicile principal."),
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00290", "À l’inverse, ne sont pas considérés comme des domiciles :"),
                  style: TextStyle(color: textColor),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00291", "le logement vide de meubles entre deux locations ;"),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00292", "l’immeuble en construction ;")),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00293", "l’appartement partiellement détruit et devenu inhabitable ;"),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00294", "la cour non close d’un immeuble ;")),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00295", "la hutte de chasse dépourvue d’aménagement pour l’habitation ;"),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00296", "le local exclusivement réservé à la vente ;")),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00297", "le bloc opératoire (même si l’accès en est strictement limité pour des raisons médicales) ;"),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00298", "le casier d’une consigne de gare ;")),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00299", "le véhicule automobile qui ne se trouve pas au domicile et qui n’est pas aménagé pour l’habitation ;"),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00300", "le bateau ne comportant aucun aménagement intérieur destiné à l’habitation."),
                ),
              ]),
              const SizedBox(height: 12),

              // 3.2
              Text(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00301", "3.2 — La violation de domicile"),
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
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00302", "Le domicile est traditionnellement décrit comme « inviolable et sacré ». ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00303", "Toute personne qui pénètre, hors des cas prévus par la loi, dans le domicile d’autrui commet une violation de domicile."),
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 6),
              Text(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00304", "3.2.1 — Violation de domicile commise par un particulier"),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                  color: referenceColor,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00305", "Article 226-4 du Code pénal : "),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                 TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00306", "incrimine le fait, pour un particulier, de s’introduire dans le domicile d’autrui à l’aide de manœuvres, de menaces, de voies de fait ou de contrainte, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00307", "hors les cas où la loi le permet, ainsi que le fait de se maintenir dans ce domicile après s’y être introduit dans ces conditions. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00308", "Constitue également un domicile, au sens de ce texte, tout local d’habitation contenant des biens meubles appartenant à la personne, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00309", "qu’elle y habite ou non, qu’il s’agisse de sa résidence principale ou secondaire. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00310", "Cette infraction est analysée en détail dans le fascicule de droit pénal spécial relatif aux crimes et délits contre les personnes."),
                ),
              ]),
              const SizedBox(height: 8),
              Text(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00311", "3.2.2 — Violation de domicile commise par un fonctionnaire"),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                  color: referenceColor,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00312", "Article 432-8 du Code pénal : "),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                 TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00313", "prévoit que le fait, pour une personne dépositaire de l’autorité publique ou chargée d’une mission de service public, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00314", "agissant dans l’exercice ou à l’occasion de l’exercice de ses fonctions, de s’introduire ou de tenter de s’introduire dans le domicile d’autrui contre le gré de celui-ci, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00315", "hors les cas prévus par la loi, est puni de deux ans d’emprisonnement et de trente mille euros d’amende. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00316", "Cette infraction appartient au droit pénal spécial des crimes et délits contre la nation, l’État et la paix publique."),
                ),
              ]),
              const SizedBox(height: 12),

              // 3.3
              Text(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00317", "3.3 — Les cas légaux permettant aux policiers de pénétrer dans un domicile"),
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
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00318", "Certaines dispositions légales autorisent les forces de l’ordre à pénétrer dans un domicile, y compris sans le consentement de l’occupant. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00319", "On distingue les introductions possibles même en dehors des heures légales et celles qui ne peuvent avoir lieu que pendant les heures légales. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00320", "En principe, les heures légales d’intervention sont fixées entre six heures et vingt et une heures (article 59 du Code de procédure pénale)."),
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 8),

              Text(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00321", "3.3.1 — Les cas d’introduction possibles même en dehors des heures légales"),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                  color: referenceColor,
                ),
              ),
              const SizedBox(height: 4),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00322", "Réclamation faite de l’intérieur de la maison (article 59 du Code de procédure pénale) : il s’agit de l’appel au secours, de cris ou de hurlements laissant présumer un danger. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00323", "L’introduction est justifiée même si l’appel s’avère ensuite fantaisiste ;"),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00324", "Maison atteinte ou menacée par un incendie ou une inondation : la réclamation de l’intérieur n’est pas nécessaire, le péril peut même être ignoré des occupants ;"),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00325", "Assistance à personne en péril (article 223-6, alinéa 2, du Code pénal) : dès lors que des indices sérieux laissent penser qu’une personne est en grave danger dans un domicile ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00326", "(appel sans réponse, odeur suspecte, absence anormale d’une personne vivant seule, etc.), l’introduction est justifiée par l’obligation de porter assistance ;"),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00327", "Intervention de police administrative en cas de danger imminent pour la sécurité des personnes (par exemple en matière d’admission en soins psychiatriques sans consentement) ;"),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00328", "Mise en œuvre de dispositions spéciales relatives à la criminalité et à la délinquance organisées (articles 706-73 et 706-73-1 du Code de procédure pénale) : ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00329", "des visites domiciliaires, perquisitions et saisies peuvent avoir lieu en dehors des heures légales, sous conditions de contrôle judiciaire strict ;"),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00330", "Perquisitions en dehors des heures légales autorisées pour certains crimes graves contre les personnes, lorsque les nécessités de l’enquête de flagrance ou de l’information l’exigent ;"),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00331", "Visites domiciliaires destinées à prévenir des actes de terrorisme, dans le cadre des dispositions du Code de la sécurité intérieure issues de la loi du trente octobre deux mille dix-sept : ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00332", "la visite ne peut en principe commencer avant six heures ni après vingt et une heures, sauf autorisation spéciale du juge des libertés et de la détention ;"),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00333", "État de nécessité : certaines introductions sont justifiées par la nécessité de faire cesser un danger actuel ou imminent, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00334", "par exemple pour interrompre une fuite de gaz ou arrêter une alarme causant un trouble grave au voisinage."),
                ),
              ]),
              const SizedBox(height: 10),

              Text(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00335", "3.3.2 — Les cas d’introduction pendant les heures légales"),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                  color: referenceColor,
                ),
              ),
              const SizedBox(height: 4),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00336", "Exécution d’un mandat d’amener, d’un mandat d’arrêt ou d’un mandat de recherche : la visite du domicile a pour but d’appréhender la personne visée, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00337", "en principe à son dernier domicile connu ;"),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00338", "Exécution de décisions de condamnation et de contraintes judiciaires ;"),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00339", "Interpellation d’une personne recherchée, dans le respect des heures légales ;"),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00340", "Réalisation de perquisitions dans le cadre d’enquêtes criminelles ou délictuelles (articles 56 et suivants du Code de procédure pénale) ;"),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00341", "Réalisation d’opérations de contrôle prévues par certaines réglementations, notamment en matière de droit du travail, de lutte contre le travail dissimulé, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00342", "de séjour irrégulier ou de règles d’hygiène ;"),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00343", "Arrestation d’une personne en vue de l’exécution d’une peine privative de liberté : sur autorisation du ministère public, l’entrée dans le domicile de la personne condamnée ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00344", "a pour unique but de l’appréhender (article 716-5 du Code de procédure pénale)."),
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00345", "Certains lieux bénéficient d’une protection renforcée : les locaux diplomatiques (convention de Vienne du dix-huit avril mille neuf cent soixante et un), ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00346", "ainsi que les bâtiments de l’Assemblée nationale et du Sénat. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00347", "L’introduction des forces de l’ordre dans ces lieux n’est possible que sous des conditions très strictes, notamment avec le consentement du chef de mission diplomatique ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00348", "ou sur réquisition du président de l’assemblée concernée."),
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 12),

              // 3.4
              Text(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00349", "3.4 — Le cas particulier de la fouille des véhicules"),
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
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00350", "La fouille des véhicules, comme les contrôles d’identité, pose des questions sensibles en matière de libertés publiques. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00351", "La loi du dix-huit mars deux mille trois pour la sécurité intérieure a cherché à concilier le respect de la liberté individuelle et l’efficacité des investigations policières, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00352", "en encadrant l’intervention du procureur de la République et les pouvoirs des officiers de police judiciaire. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00353", "En principe, un véhicule n’est pas assimilé à un domicile, sauf s’il est spécialement aménagé pour être habité. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00354", "La fouille d’un véhicule n’est pas juridiquement une perquisition, mais elle porte tout de même atteinte à la vie privée et doit respecter des conditions strictes."),
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 10),

              Text(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00355", "3.4.1 — Sur réquisitions écrites du procureur de la République (article 78-2-2 du Code de procédure pénale)"),
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
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00356", "L’article 78-2-2 du Code de procédure pénale prévoit, dans des paragraphes distincts, les contrôles d’identité, les visites de véhicules, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00357", "les inspections visuelles et fouilles des bagages, ainsi que la visite des navires. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00358", "Aux fins de recherche et de poursuite de certaines infractions graves (actes de terrorisme, infractions liées aux armes de destruction massive, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00359", "infractions en matière d’armes ou d’explosifs, vols, recel, trafic de stupéfiants, etc.), le procureur de la République peut requérir, par écrit, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00360", "les officiers de police judiciaire, assistés le cas échéant des agents de police judiciaire et des agents de police judiciaire adjoints, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00361", "pour procéder à la visite de véhicules et à l’inspection ou à la fouille de bagages dans des lieux déterminés et pour une durée limitée, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00362", "qui ne peut excéder vingt-quatre heures, renouvelable une fois par décision motivée."),
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 6),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00363", "Les véhicules spécialement aménagés à usage d’habitation et effectivement utilisés comme résidence ne peuvent être visités que selon les règles applicables aux perquisitions et visites domiciliaires."),
                ),
              ]),
              const SizedBox(height: 8),

              Text(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00364", "3.4.1.1 — La visite des véhicules"),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                  color: referenceColor,
                ),
              ),
              const SizedBox(height: 4),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00365", "Lorsque le véhicule est en circulation, il ne peut être immobilisé que le temps strictement nécessaire au déroulement de la visite, en présence du conducteur ;"),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00366", "lorsque le véhicule est à l’arrêt ou en stationnement, la visite doit avoir lieu en présence du conducteur ou du propriétaire du véhicule. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00367", "À défaut, l’officier ou l’agent de police judiciaire doit requérir une personne ne relevant pas de son autorité administrative ; ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00368", "la présence de cette personne extérieure n’est pas requise si la visite comporte des risques graves pour la sécurité des personnes et des biens ;"),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00369", "en cas de découverte d’une infraction, ou si le conducteur ou le propriétaire le demande, ou si la visite a eu lieu hors leur présence, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00370", "un procès-verbal mentionnant le lieu et les dates et heures de début et de fin des opérations doit être établi. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00371", "Un exemplaire est remis à l’intéressé, un autre transmis sans délai au procureur de la République."),
                ),
              ]),
              const SizedBox(height: 8),

              Text(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00372", "3.4.1.2 — L’inspection des bagages"),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                  color: referenceColor,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00373", "Dans les mêmes conditions et pour les mêmes infractions, les officiers de police judiciaire, assistés le cas échéant des agents de police judiciaire et des agents de police judiciaire adjoints, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00374", "peuvent procéder à l’inspection visuelle ou à la fouille des bagages en tous lieux accessibles au public. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00375", "Les propriétaires de ces bagages ne peuvent être retenus que le temps strictement nécessaire aux opérations, qui doivent se dérouler en leur présence. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00376", "En cas de découverte d’une infraction ou si le propriétaire le demande, un procès-verbal précisant le lieu, les dates et heures de début et de fin des opérations est établi ; ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00377", "un exemplaire est remis à l’intéressé et un autre transmis au procureur de la République."),
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00378", "La loi du vingt-huit avril deux mille vingt-cinq relative au renforcement de la sûreté dans les transports permet aux officiers de police judiciaire et aux agents de police judiciaire ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00379", "de la police nationale et de la gendarmerie, territorialement compétents, de prendre eux-mêmes l’initiative de procéder à des inspections visuelles des bagages ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00380", "et, avec le consentement du propriétaire, à leur fouille dans les gares et sur les lignes des réseaux ferroviaires et guidés. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00381", "Les mêmes dispositions s’appliquent aux services de transport public routier de personnes, y compris dans les aménagements où ces services déposent ou prennent en charge des passagers."),
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 8),

              Text(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00382", "3.4.1.3 — La visite des navires"),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                  color: referenceColor,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00383", "La visite des navires effectuée sur le fondement de l’article 78-2-2 du Code de procédure pénale ne peut entraîner une immobilisation ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00384", "que pour la durée strictement nécessaire aux opérations, sans pouvoir excéder douze heures. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00385", "La visite se déroule en présence du capitaine ou de son représentant et peut porter sur les extérieurs, les cales, les soutes et les locaux, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00386", "à l’exception de ceux aménagés à usage d’habitation, qui relèvent du régime des perquisitions domiciliaires."),
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 12),

              Text(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00387", "3.4.2 — En cas de crime ou de délit flagrant (article 78-2-3 du Code de procédure pénale)"),
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
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00388", "Lorsqu’il existe, à l’égard du conducteur ou d’un passager d’un véhicule, une ou plusieurs raisons plausibles de soupçonner qu’il a commis, en tant qu’auteur ou complice, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00389", "un crime ou un délit flagrant, les officiers de police judiciaire, assistés le cas échéant des agents de police judiciaire et des agents de police judiciaire adjoints, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00390", "peuvent procéder à la visite des véhicules circulant ou arrêtés sur la voie publique ou dans des lieux accessibles au public. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00391", "Les modalités d’organisation sont similaires à celles prévues à l’article 78-2-2 du Code de procédure pénale, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00392", "mais ces opérations ne nécessitent pas, cette fois, de réquisitions écrites du procureur de la République."),
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 10),

              Text(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00393", "3.4.3 — Autres hypothèses de fouille de véhicule"),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),

              Text(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00394", "3.4.3.1 — La procédure de flagrant délit (articles 53 et suivants du Code de procédure pénale)"),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                  color: referenceColor,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00395", "Au-delà de la simple constatation du délit flagrant au sens de l’article 78-2-3, l’officier de police judiciaire peut, dans le cadre des investigations de flagrance, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00396", "visiter un véhicule et exiger l’ouverture du coffre afin de rechercher des éléments de preuve, sur le fondement des articles 53 et suivants du Code de procédure pénale. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00397", "Il est fortement recommandé d’utiliser alors le formalisme applicable aux perquisitions (information de la personne, présence de témoins, procès-verbal détaillé)."),
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 8),

              Text(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00398", "3.4.3.2 — Les actes accomplis en exécution d’une commission rogatoire"),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                  color: referenceColor,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00399", "Dans le cadre d’une information judiciaire, le juge d’instruction peut, par commission rogatoire, autoriser les officiers de police judiciaire à fouiller des véhicules. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00400", "Ces opérations se déroulent alors selon les mêmes formes que pour une perquisition ordinaire, sous le contrôle du magistrat instructeur."),
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 8),

              Text(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00401", "3.4.3.3 — L’enquête préliminaire"),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                  color: referenceColor,
                ),
              ),
              const SizedBox(height: 4),
               _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00402", "En enquête préliminaire, la contrainte doit rester exceptionnelle. Ni l’officier de police judiciaire ni l’agent de police judiciaire ne peuvent procéder d’autorité à la fouille d’un véhicule. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00403", "Ils doivent obtenir l’assentiment du propriétaire ou du conducteur, cet accord étant consigné dans un procès-verbal. "),
                ),
              ]),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00404", "La jurisprudence assimile la fouille d’un véhicule à une perquisition dès lors qu’elle permet une intrusion dans l’intimité de la vie privée. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00405", "En l’absence de texte spécial l’autorisant, une telle fouille ne peut être réalisée, en enquête préliminaire, qu’avec le consentement recueilli dans les formes prévues par l’article 76 du Code de procédure pénale. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00406", "La méconnaissance de cette formalité entraîne la nullité de l’acte si la personne intéressée justifie d’un grief."),
                  style: TextStyle(color: referenceColor),
                ),
              ]),
              const SizedBox(height: 8),

              Text(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00407", "3.4.3.4 — Pour prévenir une atteinte grave à la sécurité des personnes et des biens (article 78-2-4 du Code de procédure pénale)"),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                  color: referenceColor,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00408", "Pour prévenir une atteinte grave à la sécurité des personnes et des biens, les officiers de police judiciaire, et, sur leur ordre et sous leur responsabilité, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00409", "les agents de police judiciaire et les agents de police judiciaire adjoints, peuvent procéder, dans les conditions fixées par l’article 78-2-4 du Code de procédure pénale, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00410", "non seulement aux contrôles d’identité prévus par l’article 78-2, mais également à la visite des véhicules et à l’inspection visuelle ou à la fouille des bagages. "),
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00411", "Ces opérations sont en principe réalisées avec l’accord du conducteur ou du propriétaire du bagage. À défaut, elles peuvent être effectuées sur instructions du procureur de la République, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00412", "communiquées par tous moyens. Le véhicule peut être immobilisé pour une durée qui ne peut excéder trente minutes. "),
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 4),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00413", "Pour la visite des véhicules : lorsque le véhicule est en circulation, la visite doit avoir lieu en présence du conducteur ; ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00414", "lorsque le véhicule est à l’arrêt ou en stationnement, la visite doit se dérouler en présence du conducteur ou du propriétaire. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00415", "À défaut, l’officier ou l’agent de police judiciaire requiert la présence d’une personne ne relevant pas de son autorité administrative, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00416", "sauf si la visite comporte des risques graves pour la sécurité des personnes et des biens ;"),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00417", "Pour l’inspection visuelle des bagages ou leur fouille : celles-ci se font en présence du propriétaire, qui ne peut être retenu que le temps strictement nécessaire aux opérations, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00418", "sans pouvoir excéder trente minutes."),
                ),
              ]),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00419", "En cas de découverte d’une infraction, ou si le conducteur ou le propriétaire du véhicule ou du bagage le demande, ou encore si la visite a eu lieu hors la présence de ces personnes, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00420", "un procès-verbal doit être établi. Il mentionne le lieu, ainsi que les dates et heures de début et de fin des opérations. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00421", "Un exemplaire est remis à l’intéressé et un autre est transmis sans délai au procureur de la République."),
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 10),

              Text(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00422", "3.4.3.5 — Pour rechercher les auteurs d’une participation à une manifestation en étant porteur d’une arme (article 78-2-5 du Code de procédure pénale)"),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                  color: referenceColor,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00423", "Sur réquisitions écrites du procureur de la République, les officiers de police judiciaire, et, sous leur contrôle, les agents de police judiciaire et les agents de police judiciaire adjoints, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00424", "peuvent, sur les lieux d’une manifestation sur la voie publique et à ses abords immédiats, mettre en œuvre un dispositif spécifique afin de rechercher les personnes ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00425", "ayant participé à cette manifestation en étant porteuses d’une arme. "),
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 4),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00426", "Ils peuvent procéder à l’inspection visuelle des bagages des personnes et, avec leur consentement, à leur fouille, dans les conditions prévues pour les inspections et fouilles de l’article 78-2-2 ;"),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00427", "Ils peuvent visiter les véhicules circulant, arrêtés ou stationnant sur la voie publique ou dans des lieux accessibles au public, dans les mêmes conditions que celles prévues au même article 78-2-2."),
                ),
              ]),
              const SizedBox(height: 4),
               _NotaBox(
                title: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00428", "Point important"),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00429", "Dans le cadre de l’article 78-2-5 du Code de procédure pénale, les contrôles d’identité sont exclus du dispositif : ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00430", "seules sont autorisées l’inspection ou la fouille des bagages et la visite des véhicules, dans les limites strictement définies par les réquisitions du procureur de la République."),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 30),

          // =====================================================
          // CONCLUSION GÉNÉRALE
          // =====================================================
          _HypoCard(
            title:
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00431", "Conclusion — Vie privée et travail policier : un équilibre permanent"),
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00432", "Le droit au respect de la vie privée irrigue une grande partie de l’activité des forces de l’ordre : contrôles d’identité, visites de véhicules, ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00433", "perquisitions, exploitation d’images, interceptions de correspondances, recours à la vidéoprotection ou aux caméras individuelles. ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00434", "Chaque acte de police doit pouvoir se rattacher à un texte précis, respecter les formes légales et demeurer strictement nécessaire et proportionné à l’objectif poursuivi. "),
                  style: TextStyle(color: textColor),
                ),
                 TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00435", "En l’absence de base légale claire, la mesure est susceptible de constituer une atteinte illicite au droit au respect de la vie privée."),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: dangerColor,
                  ),
                ),
              ]),
              const SizedBox(height: 10),
               _NotaBox(
                title: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00436", "Réflexe opérationnel pour l’agent"),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00437", "Avant toute mesure susceptible d’affecter la vie privée (domicile, véhicule, bagages, correspondances, images, données numériques), ") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00438", "l’agent devrait systématiquement se poser trois questions :\n") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00439", "1) Quel texte fonde concrètement mon action ?\n") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00440", "2) Ai-je respecté l’ensemble des garanties procédurales (heures légales, autorisation, information, consentement, présence de témoins, procès-verbal) ?\n") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00441", "3) La mesure est-elle réellement nécessaire et proportionnée au but poursuivi ?\n\n") + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart", "f00442", "Si l’une de ces réponses est incertaine, il est prudent de réévaluer la décision, d’en référer à la hiérarchie ou de solliciter l’avis du parquet."),
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
        text ?? "",
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
          Text("• ", style: TextStyle(fontSize: 15, height: 1.4, color: color)),
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
        ? const Color(0xFF42A5F5)
        : const Color(0xFF1E88E5);
    final Color bgColor = isDark
        ? const Color(0xFF0D1B26)
        : const Color(0xFFE3F2FD);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF5D4037);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: isDark ? .65 : .9),
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: borderColor, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title :",
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
                    : const Color(0xFF102027).withValues(alpha: .95),
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
              text: "$title : ",
              style: TextStyle(fontWeight: FontWeight.w900, color: titleColor),
            ),
            ...bodySpans,
          ],
        ),
      ),
    );
  }
}
