import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PrincipauxFichiersPage extends StatelessWidget {
  const PrincipauxFichiersPage({super.key});

  static const String routeName =
      '/gpx/intervention/patrouille/principaux-fichiers';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Cards
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardInfo = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardRules = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardAmber = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardPink = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);

    // Accents
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

    TextSpan lawSpan(String txt) {
      return TextSpan(
        text: txt,
        style: const TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
      );
    }

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textMain),
          tooltip: ScolariteText.value(
            "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          "Patrouille",
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
            ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
              "f00002",
              "Les principaux fichiers",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
              "f00003",
              "Pourquoi c’est essentiel",
            ),
            cardColor: cardInfo,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                      "f00004",
                      "En intervention, les fichiers aident à décider vite et juste (sécurité, conduite à tenir, situation administrative, antécédents, véhicules, objets…). ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                      "f00005",
                      "Mais toute consultation doit être strictement justifiée par le besoin de service.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut (exigé)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
              "f00006",
              "Cadre légal & déontologie",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                    "f00007",
                    "Obligation générale : ",
                  ),
                ),
                lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                    "f00008",
                    "article R. 434-21 du Code de la sécurité intérieure",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                    "f00009",
                    " — connaître et respecter les finalités et règles d’utilisation des fichiers.",
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00010",
                  "Point clé",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                      "f00011",
                      "Tout est tracé (consultations mémorisées). Une consultation sans motif légal = risque disciplinaire + pénal.",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
              "f00012",
              "I — LA COMMISSION NATIONALE DE L’INFORMATIQUE ET DES LIBERTÉS (C.N.I.L.)",
            ),
            cardColor: cardInfo,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                      "f00013",
                      "Créée par la loi n° 78-17 du 6 janvier 1978 (informatique, fichiers et libertés), ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                      "f00014",
                      "la CNIL protège les droits des usagers en contrôlant les fichiers informatisés.",
                    ),
              ),
              SizedBox(height: 10),
              _SubTitle("Missions"),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00015",
                  "Recenser les fichiers existants en France et vérifier que seules les données autorisées y figurent.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00016",
                  "Contrôler le respect de la vie privée, des libertés et du fonctionnement démocratique.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00017",
                  "Agir spontanément (auto-saisine) ou sur plaintes portées à sa connaissance.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
              "f00018",
              "II — Règles de consultation",
            ),
            cardColor: cardRules,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                    "f00019",
                    "Le policier alimente et consulte les fichiers dans le strict respect des finalités propres à chaque traitement (",
                  ),
                ),
                lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                    "f00020",
                    "article R. 434-21 du C.S.I.",
                  ),
                ),
                const TextSpan(text: ")."),
              ]),
              const SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00021",
                  "A) Obligations à respecter",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00022",
                  "Accès via CHEOPS-NG : chaque utilisateur a un profil/habilitation correspondant à sa mission.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00023",
                  "Mot de passe personnel (renouvelé tous les 3 mois) : ne jamais le communiquer.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00024",
                  "Toutes les consultations sont mémorisées (traçabilité).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00025",
                  "Interrogation légale uniquement si prévue par la loi et pour les besoins exclusifs des missions (administrative/judiciaire).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00026",
                  "Confidentialité absolue : interdiction de divulguer à la presse, entourage, ou protagonistes d’une enquête.",
                ),
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                      "f00027",
                      "Contrôle possible par un magistrat. L’absence de mention d’habilitation sur les pièces issues d’une consultation n’emporte pas, à elle seule, nullité (",
                    ),
                  ),
                  lawSpan(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                      "f00028",
                      "article 15-5 du Code de procédure pénale",
                    ),
                  ),
                  const TextSpan(text: ")."),
                ],
              ),
              const SizedBox(height: 14),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00029",
                  "B) Conséquences du non-respect",
                ),
              ),
              _ConditionCard(
                title: "Disciplinaires",
                cardColor: cardPink,
                accent: accentPink,
                titleColor: textMain,
                children: [
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                      "f00030",
                      "Usage non conforme = faute professionnelle pouvant justifier une sanction disciplinaire.",
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                      "f00031",
                      "Des sanctions existent aussi en cas de consultation non autorisée.",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00032",
                  "Pénales",
                ),
                cardColor: cardAmber,
                accent: accentAmber,
                titleColor: textMain,
                children: [
                  _Paragraph(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                      "f00033",
                      "Le Code pénal réprime l’utilisation frauduleuse des données : consultation non autorisée, usage détourné, divulgation à des tiers non autorisés.",
                    ),
                  ),
                  const SizedBox(height: 10),
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                        "f00034",
                        "Textes : ",
                      ),
                    ),
                    lawSpan(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                        "f00035",
                        "articles 226-13, 226-17, 226-20 à 226-23 du Code pénal",
                      ),
                    ),
                    const TextSpan(text: "."),
                  ]),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // =========================
          // FICHES / FICHIERS
          // =========================
          Text(
            ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
              "f00036",
              "Fichiers opérationnels (fiches synthèse)",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 18,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // FPR
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
              "f00037",
              "Fichier des Personnes Recherchées (FPR)",
            ),
            cardColor: cardInfo,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00038",
                  "Finalité",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00039",
                  "Rechercher des personnes (majeures ou mineures) sur tout le territoire national et afficher la conduite à tenir en cas de découverte.",
                ),
              ),
              const SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00040",
                  "Base / règles",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                    "f00041",
                    "Inscription et cadre : ",
                  ),
                ),
                lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                    "f00042",
                    "article 230-19 du Code de procédure pénale",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                    "f00043",
                    " (liste des peines/mesures donnant lieu à inscription : mandats, IST, peines alternatives, interdictions, etc.).",
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00044",
                  "Accès & traçabilité",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00045",
                  "Accessible sur postes CHEOPS-NG aux utilisateurs habilités, pour les besoins exclusifs des missions.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00046",
                  "Consultations enregistrées : identification du consultant, date/heure, données visionnées.",
                ),
              ),
              const SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00047",
                  "Modes d’interrogation",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00048",
                  "Recherche simple : nom (obligatoire), prénom, date de naissance.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00049",
                  "Autres : par liste (multi-identités), par signalement, par référence (n° partiel/complet).",
                ),
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                      "f00050",
                      "En cas de découverte, suivre strictement le mémento des conduites à tenir accessible dans l’aide de l’application. Impression d’une fiche possible.",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // FOVeS
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
              "f00051",
              "Fichier des Objets et Véhicules Signalés (FOVeS)",
            ),
            cardColor: cardRules,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00052",
                  "Finalité",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00053",
                  "Découvrir et restituer les véhicules volés / objets perdus ou volés, et surveiller les véhicules/objets signalés (dans NS2I).",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00054",
                  "Contenu (exemples)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00055",
                  "Véhicules (immatriculés ou non), bateaux, aéronefs : vol / surveillance.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00056",
                  "Objets : moyens de paiement, plaques, certificats, moteurs, billets, armes/munitions/explosifs, bijoux, objets d’art, documents…",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00057",
                  "Accès & interrogation",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00058",
                  "Accès direct via CHEOPS-NG pour utilisateurs habilités.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00059",
                  "Recherche simple (catégorie), recherche complexe, recherche par procédure, recherche par fichier, identifiant technique.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00060",
                  "Police municipale (rappel)",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                      "f00061",
                      "Pas d’accès direct : la recherche est faite par l’utilisateur habilité. Ne communiquer que les infos autorisées (immatriculation, marque, type, couleur…); ne jamais divulguer l’existence d’une surveillance.",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // SNPC
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
              "f00062",
              "Système National du Permis de Conduire (SNPC)",
            ),
            cardColor: cardInfo,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00063",
                  "Finalité",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00064",
                  "Vérifier si une personne est titulaire d’un permis valable.",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle("Contenu"),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00065",
                  "N° de permis, identité, date/autorité de délivrance, catégories, validité, restrictions, conditions.",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle("Interrogation"),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00066",
                  "Via CHEOPS-NG : état civil (nom, prénom, sexe, DDN) ou n° du permis.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // SIV
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
              "f00067",
              "Système d’Immatriculation des Véhicules (SIV)",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00068",
                  "Finalité",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00069",
                  "Identifier un véhicule et consulter l’historique associé.",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle("Contenu"),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00070",
                  "Libellé complet du certificat d’immatriculation + historique du véhicule.",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00071",
                  "Interrogation (via CHEOPS-NG)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00072",
                  "Recherche simple : immatriculation, VIN, n° certificat (SIV/FNI), CPI, identité titulaire.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00073",
                  "Recherche avancée : critères véhicule / immatriculation / titulaires / caractéristiques (type, genre, marque, couleur…).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00074",
                  "Recherche groupe d’immatriculations, historique véhicule.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                      "f00075",
                      "Le SIV permet aussi d’enregistrer une immobilisation puis la levée, y compris dans la procédure « véhicule endommagé ».",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // DICEM
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
              "f00076",
              "D.I.C.E.M. — Déclaration & identification de certains engins motorisés",
            ),
            cardColor: cardInfo,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00077",
                  "Finalité",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00078",
                  "Identifier les propriétaires d’engins motorisés non autorisés à circuler sur la voie publique (ex : pit bikes, pocket bikes, mini quads, motocross…).",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle("Contenu"),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00079",
                  "Numéro d’identification attribué à l’engin.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00080",
                  "Identité/coordonnées du déclarant (ou personne morale : RNA/SIRET, représentant).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00081",
                  "Type, marque, modèle, couleur, n° de série, statut (volé/détruit/vendu…).",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00082",
                  "Accès",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00083",
                  "Via CHEOPS-NG.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // EUCARIS / EUVID
          _ConditionCard(
            title:
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00084",
                  "SYSTÈME EUROPÉEN D’IDENTIFICATION DES VÉHICULES (E.U.C.A.R.I.S.)\n",
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00085",
                  "BASE EUROPÉENNE D’IDENTIFICATION DES VÉHICULES (E.U.V.I.D.)",
                ),
            cardColor: cardRules,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00086",
                  "EUCARIS — Finalité",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00087",
                  "Accéder aux bases relatives aux véhicules immatriculés dans certains États membres de l’UE.",
                ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00088",
                  "Infos techniques ; véhicule signalé volé/détruit ; nom/adresse propriétaire/détenteur.",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00089",
                  "EUCARIS — Interrogation",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00090",
                  "Plaque ou n° châssis (au moins un obligatoire).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00091",
                  "Base étrangère à consulter (obligatoire).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00092",
                  "Date de recherche (facultatif) + motif (obligatoire).",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00093",
                  "EUVID (ou EUFID) — Finalité",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00094",
                  "Outil Europol pour aider au contrôle/identification d’un véhicule et de ses documents.",
                ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00095",
                  "Infos techniques (ex : emplacement n° moteur) par marques/types.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00096",
                  "Modèles de documents d’immatriculation (≈ 50 pays).",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                      "f00097",
                      "Consultable via CHEOPS-NG (accès aux bases constructeurs selon notes internes).",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // FNUCI
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
              "f00098",
              "F.N.U.C.I. — Fichier national unique des cycles identifiés",
            ),
            cardColor: cardInfo,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00099",
                  "Finalité",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00100",
                  "Lutter contre le vol/recel/revente illicite et permettre la restitution d’un cycle à son propriétaire.",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00101",
                  "Contenu (principes)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00102",
                  "Identifiant apposé sur le cadre (10 caractères alphanumériques).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00103",
                  "Identité/coordonnées (tél, email) du propriétaire / copropriétaires.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00104",
                  "Type, marque, modèle, couleur + statut (volé, perdu, détruit…).",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00105",
                  "Accès",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00106",
                  "Via CHEOPS-NG ou NEO (tablette/téléphone).",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                      "f00107",
                      "Le statut d’un cycle peut être vérifié librement via l’identifiant (utile lors d’un achat d’occasion entre particuliers).",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // TAJ/TPJ
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
              "f00108",
              "T.A.J. / T.P.J. — Traitement d’antécédents / procédures judiciaires",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                    "f00109",
                    "Dénomination : TAJ conforme à ",
                  ),
                ),
                lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                    "f00110",
                    "l’article R. 40-23 du Code de procédure pénale",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                    "f00111",
                    " (TPJ = usage interne PN).",
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00112",
                  "Finalité & alimentation",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                      "f00113",
                      "Contient des données issues des procédures PN/GN (LRPPN/LRPGN) et de coopérations internationales (NS2I). ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                      "f00114",
                      "Concerne notamment personnes mises en cause, victimes, et certaines recherches (causes de la mort, disparitions).",
                    ),
              ),
              const SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00115",
                  "Accès & types de recherche",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00116",
                  "Accès via CHEOPS-NG avec habilitation personnelle.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00117",
                  "Onglets : Consultation (cadre judiciaire/administratif), Identifier (données moins précises), Rapprocher (croiser critères).",
                ),
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00118",
                  "Procédure (rappel)",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                          "f00119",
                          "Dans une procédure judiciaire, seules les informations TAJ relatives à la procédure en cours peuvent être jointes. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                          "f00120",
                          "L’édition « antécédent personne physique » n’est jointe que sur réquisition expresse du magistrat.",
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // AGDREF
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
              "f00121",
              "A.G.D.R.E.F — Application de Gestion des Dossiers des Ressortissants étrangers en France",
            ),
            cardColor: cardInfo,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00122",
                  "Finalité",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00123",
                  "Connaître la situation administrative d’un ressortissant étranger.",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle("Contenu"),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00124",
                  "N° titre de séjour, identité, nationalité, statut, adresse, validité, situation administrative.",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle("Interrogation"),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00125",
                  "État civil (nom, prénom, sexe) ou n° de titre de séjour.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // DOCVERIF
          _ConditionCard(
            title: "DOCVERIF",
            cardColor: cardRules,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00126",
                  "Finalité",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00127",
                  "Vérifier la validité des documents émis par les autorités françaises et lutter contre l’usage indu, falsification ou contrefaçon.",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00128",
                  "Documents concernés",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00129",
                  "CNI, passeports, titres de séjour avec composant électronique.",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle("Interrogation"),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00130",
                  "Saisie du type et du numéro du document.",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00131",
                  "Traçabilité",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00132",
                  "Consultations enregistrées : consultant + date/heure + motif (conservation 3 ans).",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ODICOP
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
              "f00133",
              "O.D.I.C.O.P — Outil d'Investigation et de Communication Opérationnelle de Police",
            ),
            cardColor: cardPink,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00134",
                  "Caractéristiques",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00135",
                  "Fiches rédigées par chaque enquêteur, validées par la hiérarchie ; validation = mise en ligne.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00136",
                  "Durée : 3 mois, désactivation automatique ; réactivation possible une seule fois (encore 3 mois).",
                ),
              ),
              const SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00137",
                  "Cadre & limites",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00138",
                  "Uniquement pour enquête judiciaire (crime/délit) : suspects, victimes (recherches mort/disparition), exécution sentence pénale.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00139",
                  "Interdit : personnes recherchées dans un cadre contraventionnel/administratif.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00140",
                  "Mineurs < 10 ans : pas de données sauf procédures « disparition ».",
                ),
              ),
              const SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00141",
                  "Accès & types de fiches",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00142",
                  "Accès via CHEOPS-NG selon profil (droits intégrés).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00143",
                  "Fiches : recherches, identification, délégations judiciaires, disparitions, notes d’information (sans données perso).",
                ),
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                      "f00144",
                      "Si découverte : désactiver immédiatement la fiche (évite interpellation injustifiée). La fiche est « cachée » et réactivable par le rédacteur.",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                    "f00145",
                    "Délégations judiciaires : ",
                  ),
                ),
                lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                    "f00146",
                    "article 709 du Code de procédure pénale",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // FVA
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
              "f00147",
              "F.V.A — Fichier des véhicules assurés (AGIRA)",
            ),
            cardColor: cardInfo,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00148",
                  "Finalité",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00149",
                  "Permettre de vérifier la situation d’un véhicule immatriculé en France au regard de l’obligation d’assurance.",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00150",
                  "Accès",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00151",
                  "Via portail sécurisé (CHEOPS/NEO).",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle("Important"),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00152",
                  "Fichier anonymisé : pas de données nominatives sur le propriétaire.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00153",
                  "Deux profils : « simplifié » (APJA) et « détaillé » (OPJ/APJ).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00154",
                  "Délai assureur : jusqu’à 3 jours pour alimenter après contrat/modification.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                      "f00155",
                      "En cas de contradiction (documents vs FVA) hors fraude doc : renseigner l’application via l’assureur/courtier (liste) et valider.",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // FNAEG
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
              "f00156",
              "F.N.A.E.G — Fichier National Automatisé des Empreintes Génétiques",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00157",
                  "Finalité / contenu",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00158",
                  "Centralise les profils génétiques issus de traces biologiques et des prélèvements sur personnes (selon cadres légaux).",
                ),
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                    "f00159",
                    "Infractions concernées : ",
                  ),
                ),
                lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                    "f00160",
                    "article 706-55 du Code de procédure pénale",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                    "f00161",
                    " (liste : infractions sexuelles, vols, violences, stupéfiants, terrorisme, etc.).",
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                    "f00162",
                    "Recherches mort/disparition : ",
                  ),
                ),
                lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                    "f00163",
                    "articles 74, 74-1 et 80-4 du C.P.P.",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00164",
                  "Comparaison (point technique)",
                ),
                cardColor: cardAmber,
                accent: accentAmber,
                titleColor: textMain,
                children: [
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                          "f00165",
                          "Il est possible d’effectuer un prélèvement pour simple comparaison avec le fichier ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                          "f00166",
                          "sur une personne soupçonnée, sans enregistrer son profil (selon cadre).",
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00167",
                  "Refus de prélèvement",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                    "f00168",
                    "Constitue une infraction : ",
                  ),
                ),
                lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                    "f00169",
                    "article 706-56 II du C.P.P.",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // FAED
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
              "f00170",
              "F.A.E.D — Fichier Automatisé des Empreintes Digitales",
            ),
            cardColor: cardRules,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00171",
                  "Finalité",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00172",
                  "Fonds dactyloscopique commun (PN, GN, douane judiciaire) : identification d’auteurs, victimes, personnes décédées, etc.",
                ),
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                    "f00173",
                    "Cadres cités (exemples) : ",
                  ),
                ),
                lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                    "f00174",
                    "articles 74, 74-1 et 80-4 du C.P.P.",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                    "f00175",
                    " (mort/disparition) ; ",
                  ),
                ),
                lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                    "f00176",
                    "article 78-3 du C.P.P.",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                    "f00177",
                    " (vérification d’identité) ; ",
                  ),
                ),
                lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                    "f00178",
                    "article L. 142-2 du CESEDA",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                    "f00179",
                    " (identification étranger).",
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              const _SubTitle("Interrogation"),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00180",
                  "Via service PJ / identité judiciaire équipé (terminal) ou IJPP ; envoi des relevés scannés selon procédures.",
                ),
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                      "f00181",
                      "Conservation des données : variable (≈ 15 à 40 ans) selon nature des faits (délits/crimes).",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // FIJAISV
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
              "f00182",
              "F.I.J.A.I.S.V — Fichier Judiciaire National Automatisé des Auteurs d’Infractions Sexuelles ou Violentes",
            ),
            cardColor: cardInfo,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00183",
                  "Finalité",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00184",
                  "Prévenir la récidive et faciliter l’identification des auteurs : identité, adresse/résidences, obligations.",
                ),
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                    "f00185",
                    "Infractions pouvant entraîner l’inscription : ",
                  ),
                ),
                lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                    "f00186",
                    "article 706-47 alinéa 1 du C.P.P.",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00187",
                  "Obligations de la personne",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00188",
                  "Justifier de son adresse (délais et périodicités variables) et déclarer tout changement d’adresse sous 15 jours.",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                    "f00189",
                    "Sanction du non-respect : ",
                  ),
                ),
                lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                    "f00190",
                    "article 706-53-5 du C.P.P.",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                    "f00191",
                    " (2 ans et 30 000 €).",
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              const _SubTitle("Consultation"),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00192",
                  "Par autorités judiciaires ; par OPJ selon cadres (infractions listées ou sur instructions/autorisation). Consultation via portail CHEOPS.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // FIJAIT
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
              "f00193",
              "F.I.J.A.I.T — Fichier Judiciaire National Automatisé des Auteurs d’Infractions Terroristes",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00194",
                  "Finalité",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00195",
                  "Prévenir le renouvellement d’infractions terroristes et faciliter l’identification des auteurs.",
                ),
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                    "f00196",
                    "Infractions / cadre d’inscription : ",
                  ),
                ),
                lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                    "f00197",
                    "article 706-25-4 alinéa 1 du C.P.P.",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                    "f00198",
                    " ; infractions terroristes ",
                  ),
                ),
                lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                    "f00199",
                    "articles 421-1 à 421-6 du Code pénal",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                    "f00200",
                    " (avec exclusions précisées) ; et ",
                  ),
                ),
                lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                    "f00201",
                    "articles L. 224-1 et L. 225-7 du C.S.I.",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              const _SubTitle("Obligations"),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00202",
                  "Justification d’adresse (15 jours puis tous les 3 mois), changement d’adresse sous 15 jours, déplacements transfrontaliers à déclarer.",
                ),
              ),
              const SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00203",
                  "Accès",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00204",
                  "Autorités judiciaires, OPJ (selon cadres), représentants de l’État et administrations (recrutement/habilitation), greffes pénitentiaires, services habilités (prévention terrorisme).",
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
              "f00205",
              "Checklist terrain (ultra simple)",
            ),
            cardColor: cardInfo,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle("Avant"),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00206",
                  "Avoir un motif professionnel clair (mission / procédure / contrôle).",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00207",
                  "Vérifier que ton habilitation couvre bien le besoin.",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle("Pendant"),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00208",
                  "Consulter uniquement l’info nécessaire (pas de curiosité).",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00209",
                  "Appliquer la conduite à tenir affichée (ex : FPR).",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00210",
                  "Après",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00211",
                  "Ne jamais divulguer les infos (confidentialité).",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart",
                  "f00212",
                  "Tracer correctement en procédure uniquement ce qui est utile et autorisé.",
                ),
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
