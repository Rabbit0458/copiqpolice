import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaPrincipauxFichiersPage extends StatelessWidget {
  const PaPrincipauxFichiersPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/policier_intervention/patrouille/principaux-fichiers';

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
          tooltip: 'Retour',
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
            "Les principaux fichiers",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          _ConditionCard(
            title: "Pourquoi c’est essentiel",
            cardColor: cardInfo,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "En intervention, les fichiers aident à décider vite et juste (sécurité, conduite à tenir, situation administrative, antécédents, véhicules, objets…). "
                "Mais toute consultation doit être strictement justifiée par le besoin de service.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut (exigé)
          _ConditionCard(
            title: "Cadre légal & déontologie",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(text: "Obligation générale : "),
                lawSpan("article R. 434-21 du Code de la sécurité intérieure"),
                const TextSpan(
                  text:
                      " — connaître et respecter les finalités et règles d’utilisation des fichiers.",
                ),
              ]),
              const SizedBox(height: 10),
              const _NotaBox(
                title: "Point clé",
                bodySpans: [
                  TextSpan(
                    text:
                        "Tout est tracé (consultations mémorisées). Une consultation sans motif légal = risque disciplinaire + pénal.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title:
                "I — LA COMMISSION NATIONALE DE L’INFORMATIQUE ET DES LIBERTÉS (C.N.I.L.)",
            cardColor: cardInfo,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Créée par la loi n° 78-17 du 6 janvier 1978 (informatique, fichiers et libertés), "
                "la CNIL protège les droits des usagers en contrôlant les fichiers informatisés.",
              ),
              SizedBox(height: 10),
              _SubTitle("Missions"),
              _BulletPoint(
                text:
                    "Recenser les fichiers existants en France et vérifier que seules les données autorisées y figurent.",
              ),
              _BulletPoint(
                text:
                    "Contrôler le respect de la vie privée, des libertés et du fonctionnement démocratique.",
              ),
              _BulletPoint(
                text:
                    "Agir spontanément (auto-saisine) ou sur plaintes portées à sa connaissance.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "II — Règles de consultation",
            cardColor: cardRules,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Le policier alimente et consulte les fichiers dans le strict respect des finalités propres à chaque traitement (",
                ),
                lawSpan("article R. 434-21 du C.S.I."),
                const TextSpan(text: ")."),
              ]),
              const SizedBox(height: 12),
              const _SubTitle("A) Obligations à respecter"),
              const _BulletPoint(
                text:
                    "Accès via CHEOPS-NG : chaque utilisateur a un profil/habilitation correspondant à sa mission.",
              ),
              const _BulletPoint(
                text:
                    "Mot de passe personnel (renouvelé tous les 3 mois) : ne jamais le communiquer.",
              ),
              const _BulletPoint(
                text: "Toutes les consultations sont mémorisées (traçabilité).",
              ),
              const _BulletPoint(
                text:
                    "Interrogation légale uniquement si prévue par la loi et pour les besoins exclusifs des missions (administrative/judiciaire).",
              ),
              const _BulletPoint(
                text:
                    "Confidentialité absolue : interdiction de divulguer à la presse, entourage, ou protagonistes d’une enquête.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Contrôle possible par un magistrat. L’absence de mention d’habilitation sur les pièces issues d’une consultation n’emporte pas, à elle seule, nullité (",
                  ),
                  lawSpan("article 15-5 du Code de procédure pénale"),
                  const TextSpan(text: ")."),
                ],
              ),
              const SizedBox(height: 14),
              const _SubTitle("B) Conséquences du non-respect"),
              _ConditionCard(
                title: "Disciplinaires",
                cardColor: cardPink,
                accent: accentPink,
                titleColor: textMain,
                children: const [
                  _BulletPoint(
                    text:
                        "Usage non conforme = faute professionnelle pouvant justifier une sanction disciplinaire.",
                  ),
                  _BulletPoint(
                    text:
                        "Des sanctions existent aussi en cas de consultation non autorisée.",
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _ConditionCard(
                title: "Pénales",
                cardColor: cardAmber,
                accent: accentAmber,
                titleColor: textMain,
                children: [
                  const _Paragraph(
                    "Le Code pénal réprime l’utilisation frauduleuse des données : consultation non autorisée, usage détourné, divulgation à des tiers non autorisés.",
                  ),
                  const SizedBox(height: 10),
                  _Paragraph.rich([
                    const TextSpan(text: "Textes : "),
                    lawSpan(
                      "articles 226-13, 226-17, 226-20 à 226-23 du Code pénal",
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
            "Fichiers opérationnels (fiches synthèse)",
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
            title: "Fichier des Personnes Recherchées (FPR)",
            cardColor: cardInfo,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              const _SubTitle("Finalité"),
              const _Paragraph(
                "Rechercher des personnes (majeures ou mineures) sur tout le territoire national et afficher la conduite à tenir en cas de découverte.",
              ),
              const SizedBox(height: 10),
              const _SubTitle("Base / règles"),
              _Paragraph.rich([
                const TextSpan(text: "Inscription et cadre : "),
                lawSpan("article 230-19 du Code de procédure pénale"),
                const TextSpan(
                  text:
                      " (liste des peines/mesures donnant lieu à inscription : mandats, IST, peines alternatives, interdictions, etc.).",
                ),
              ]),
              const SizedBox(height: 10),
              const _SubTitle("Accès & traçabilité"),
              const _BulletPoint(
                text:
                    "Accessible sur postes CHEOPS-NG aux utilisateurs habilités, pour les besoins exclusifs des missions.",
              ),
              const _BulletPoint(
                text:
                    "Consultations enregistrées : identification du consultant, date/heure, données visionnées.",
              ),
              const SizedBox(height: 10),
              const _SubTitle("Modes d’interrogation"),
              const _BulletPoint(
                text:
                    "Recherche simple : nom (obligatoire), prénom, date de naissance.",
              ),
              const _BulletPoint(
                text:
                    "Autres : par liste (multi-identités), par signalement, par référence (n° partiel/complet).",
              ),
              const SizedBox(height: 10),
              const _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "En cas de découverte, suivre strictement le mémento des conduites à tenir accessible dans l’aide de l’application. Impression d’une fiche possible.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // FOVeS
          _ConditionCard(
            title: "Fichier des Objets et Véhicules Signalés (FOVeS)",
            cardColor: cardRules,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _SubTitle("Finalité"),
              _Paragraph(
                "Découvrir et restituer les véhicules volés / objets perdus ou volés, et surveiller les véhicules/objets signalés (dans NS2I).",
              ),
              SizedBox(height: 10),
              _SubTitle("Contenu (exemples)"),
              _BulletPoint(
                text:
                    "Véhicules (immatriculés ou non), bateaux, aéronefs : vol / surveillance.",
              ),
              _BulletPoint(
                text:
                    "Objets : moyens de paiement, plaques, certificats, moteurs, billets, armes/munitions/explosifs, bijoux, objets d’art, documents…",
              ),
              SizedBox(height: 10),
              _SubTitle("Accès & interrogation"),
              _BulletPoint(
                text: "Accès direct via CHEOPS-NG pour utilisateurs habilités.",
              ),
              _BulletPoint(
                text:
                    "Recherche simple (catégorie), recherche complexe, recherche par procédure, recherche par fichier, identifiant technique.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Police municipale (rappel)",
                bodySpans: [
                  TextSpan(
                    text:
                        "Pas d’accès direct : la recherche est faite par l’utilisateur habilité. Ne communiquer que les infos autorisées (immatriculation, marque, type, couleur…); ne jamais divulguer l’existence d’une surveillance.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // SNPC
          _ConditionCard(
            title: "Système National du Permis de Conduire (SNPC)",
            cardColor: cardInfo,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _SubTitle("Finalité"),
              _Paragraph(
                "Vérifier si une personne est titulaire d’un permis valable.",
              ),
              SizedBox(height: 10),
              _SubTitle("Contenu"),
              _BulletPoint(
                text:
                    "N° de permis, identité, date/autorité de délivrance, catégories, validité, restrictions, conditions.",
              ),
              SizedBox(height: 10),
              _SubTitle("Interrogation"),
              _BulletPoint(
                text:
                    "Via CHEOPS-NG : état civil (nom, prénom, sexe, DDN) ou n° du permis.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // SIV
          _ConditionCard(
            title: "Système d’Immatriculation des Véhicules (SIV)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _SubTitle("Finalité"),
              _Paragraph(
                "Identifier un véhicule et consulter l’historique associé.",
              ),
              SizedBox(height: 10),
              _SubTitle("Contenu"),
              _BulletPoint(
                text:
                    "Libellé complet du certificat d’immatriculation + historique du véhicule.",
              ),
              SizedBox(height: 10),
              _SubTitle("Interrogation (via CHEOPS-NG)"),
              _BulletPoint(
                text:
                    "Recherche simple : immatriculation, VIN, n° certificat (SIV/FNI), CPI, identité titulaire.",
              ),
              _BulletPoint(
                text:
                    "Recherche avancée : critères véhicule / immatriculation / titulaires / caractéristiques (type, genre, marque, couleur…).",
              ),
              _BulletPoint(
                text:
                    "Recherche groupe d’immatriculations, historique véhicule.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Le SIV permet aussi d’enregistrer une immobilisation puis la levée, y compris dans la procédure « véhicule endommagé ».",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // DICEM
          _ConditionCard(
            title:
                "D.I.C.E.M. — Déclaration & identification de certains engins motorisés",
            cardColor: cardInfo,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _SubTitle("Finalité"),
              _Paragraph(
                "Identifier les propriétaires d’engins motorisés non autorisés à circuler sur la voie publique (ex : pit bikes, pocket bikes, mini quads, motocross…).",
              ),
              SizedBox(height: 10),
              _SubTitle("Contenu"),
              _BulletPoint(text: "Numéro d’identification attribué à l’engin."),
              _BulletPoint(
                text:
                    "Identité/coordonnées du déclarant (ou personne morale : RNA/SIRET, représentant).",
              ),
              _BulletPoint(
                text:
                    "Type, marque, modèle, couleur, n° de série, statut (volé/détruit/vendu…).",
              ),
              SizedBox(height: 10),
              _SubTitle("Accès"),
              _BulletPoint(text: "Via CHEOPS-NG."),
            ],
          ),

          const SizedBox(height: 14),

          // EUCARIS / EUVID
          _ConditionCard(
            title:
                "SYSTÈME EUROPÉEN D’IDENTIFICATION DES VÉHICULES (E.U.C.A.R.I.S.)\n"
                "BASE EUROPÉENNE D’IDENTIFICATION DES VÉHICULES (E.U.V.I.D.)",
            cardColor: cardRules,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _SubTitle("EUCARIS — Finalité"),
              _Paragraph(
                "Accéder aux bases relatives aux véhicules immatriculés dans certains États membres de l’UE.",
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    "Infos techniques ; véhicule signalé volé/détruit ; nom/adresse propriétaire/détenteur.",
              ),
              SizedBox(height: 10),
              _SubTitle("EUCARIS — Interrogation"),
              _BulletPoint(
                text: "Plaque ou n° châssis (au moins un obligatoire).",
              ),
              _BulletPoint(text: "Base étrangère à consulter (obligatoire)."),
              _BulletPoint(
                text: "Date de recherche (facultatif) + motif (obligatoire).",
              ),
              SizedBox(height: 12),
              _SubTitle("EUVID (ou EUFID) — Finalité"),
              _Paragraph(
                "Outil Europol pour aider au contrôle/identification d’un véhicule et de ses documents.",
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    "Infos techniques (ex : emplacement n° moteur) par marques/types.",
              ),
              _BulletPoint(
                text: "Modèles de documents d’immatriculation (≈ 50 pays).",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Consultable via CHEOPS-NG (accès aux bases constructeurs selon notes internes).",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // FNUCI
          _ConditionCard(
            title: "F.N.U.C.I. — Fichier national unique des cycles identifiés",
            cardColor: cardInfo,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _SubTitle("Finalité"),
              _Paragraph(
                "Lutter contre le vol/recel/revente illicite et permettre la restitution d’un cycle à son propriétaire.",
              ),
              SizedBox(height: 10),
              _SubTitle("Contenu (principes)"),
              _BulletPoint(
                text:
                    "Identifiant apposé sur le cadre (10 caractères alphanumériques).",
              ),
              _BulletPoint(
                text:
                    "Identité/coordonnées (tél, email) du propriétaire / copropriétaires.",
              ),
              _BulletPoint(
                text:
                    "Type, marque, modèle, couleur + statut (volé, perdu, détruit…).",
              ),
              SizedBox(height: 10),
              _SubTitle("Accès"),
              _BulletPoint(text: "Via CHEOPS-NG ou NEO (tablette/téléphone)."),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Le statut d’un cycle peut être vérifié librement via l’identifiant (utile lors d’un achat d’occasion entre particuliers).",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // TAJ/TPJ
          _ConditionCard(
            title:
                "T.A.J. / T.P.J. — Traitement d’antécédents / procédures judiciaires",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(text: "Dénomination : TAJ conforme à "),
                lawSpan("l’article R. 40-23 du Code de procédure pénale"),
                const TextSpan(text: " (TPJ = usage interne PN)."),
              ]),
              const SizedBox(height: 10),
              const _SubTitle("Finalité & alimentation"),
              const _Paragraph(
                "Contient des données issues des procédures PN/GN (LRPPN/LRPGN) et de coopérations internationales (NS2I). "
                "Concerne notamment personnes mises en cause, victimes, et certaines recherches (causes de la mort, disparitions).",
              ),
              const SizedBox(height: 10),
              const _SubTitle("Accès & types de recherche"),
              const _BulletPoint(
                text: "Accès via CHEOPS-NG avec habilitation personnelle.",
              ),
              const _BulletPoint(
                text:
                    "Onglets : Consultation (cadre judiciaire/administratif), Identifier (données moins précises), Rapprocher (croiser critères).",
              ),
              const SizedBox(height: 10),
              const _NotaBox(
                title: "Procédure (rappel)",
                bodySpans: [
                  TextSpan(
                    text:
                        "Dans une procédure judiciaire, seules les informations TAJ relatives à la procédure en cours peuvent être jointes. "
                        "L’édition « antécédent personne physique » n’est jointe que sur réquisition expresse du magistrat.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // AGDREF
          _ConditionCard(
            title:
                "A.G.D.R.E.F — Application de Gestion des Dossiers des Ressortissants étrangers en France",
            cardColor: cardInfo,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _SubTitle("Finalité"),
              _Paragraph(
                "Connaître la situation administrative d’un ressortissant étranger.",
              ),
              SizedBox(height: 10),
              _SubTitle("Contenu"),
              _BulletPoint(
                text:
                    "N° titre de séjour, identité, nationalité, statut, adresse, validité, situation administrative.",
              ),
              SizedBox(height: 10),
              _SubTitle("Interrogation"),
              _BulletPoint(
                text:
                    "État civil (nom, prénom, sexe) ou n° de titre de séjour.",
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
            children: const [
              _SubTitle("Finalité"),
              _Paragraph(
                "Vérifier la validité des documents émis par les autorités françaises et lutter contre l’usage indu, falsification ou contrefaçon.",
              ),
              SizedBox(height: 10),
              _SubTitle("Documents concernés"),
              _BulletPoint(
                text:
                    "CNI, passeports, titres de séjour avec composant électronique.",
              ),
              SizedBox(height: 10),
              _SubTitle("Interrogation"),
              _BulletPoint(text: "Saisie du type et du numéro du document."),
              SizedBox(height: 10),
              _SubTitle("Traçabilité"),
              _BulletPoint(
                text:
                    "Consultations enregistrées : consultant + date/heure + motif (conservation 3 ans).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ODICOP
          _ConditionCard(
            title:
                "O.D.I.C.O.P — Outil d'Investigation et de Communication Opérationnelle de Police",
            cardColor: cardPink,
            accent: accentPink,
            titleColor: textMain,
            children: [
              const _SubTitle("Caractéristiques"),
              const _BulletPoint(
                text:
                    "Fiches rédigées par chaque enquêteur, validées par la hiérarchie ; validation = mise en ligne.",
              ),
              const _BulletPoint(
                text:
                    "Durée : 3 mois, désactivation automatique ; réactivation possible une seule fois (encore 3 mois).",
              ),
              const SizedBox(height: 10),
              const _SubTitle("Cadre & limites"),
              const _BulletPoint(
                text:
                    "Uniquement pour enquête judiciaire (crime/délit) : suspects, victimes (recherches mort/disparition), exécution sentence pénale.",
              ),
              const _BulletPoint(
                text:
                    "Interdit : personnes recherchées dans un cadre contraventionnel/administratif.",
              ),
              const _BulletPoint(
                text:
                    "Mineurs < 10 ans : pas de données sauf procédures « disparition ».",
              ),
              const SizedBox(height: 10),
              const _SubTitle("Accès & types de fiches"),
              const _BulletPoint(
                text: "Accès via CHEOPS-NG selon profil (droits intégrés).",
              ),
              const _BulletPoint(
                text:
                    "Fiches : recherches, identification, délégations judiciaires, disparitions, notes d’information (sans données perso).",
              ),
              const SizedBox(height: 10),
              const _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Si découverte : désactiver immédiatement la fiche (évite interpellation injustifiée). La fiche est « cachée » et réactivable par le rédacteur.",
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Délégations judiciaires : "),
                lawSpan("article 709 du Code de procédure pénale"),
                const TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // FVA
          _ConditionCard(
            title: "F.V.A — Fichier des véhicules assurés (AGIRA)",
            cardColor: cardInfo,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _SubTitle("Finalité"),
              _Paragraph(
                "Permettre de vérifier la situation d’un véhicule immatriculé en France au regard de l’obligation d’assurance.",
              ),
              SizedBox(height: 10),
              _SubTitle("Accès"),
              _BulletPoint(text: "Via portail sécurisé (CHEOPS/NEO)."),
              SizedBox(height: 10),
              _SubTitle("Important"),
              _BulletPoint(
                text:
                    "Fichier anonymisé : pas de données nominatives sur le propriétaire.",
              ),
              _BulletPoint(
                text:
                    "Deux profils : « simplifié » (APJA) et « détaillé » (OPJ/APJ).",
              ),
              _BulletPoint(
                text:
                    "Délai assureur : jusqu’à 3 jours pour alimenter après contrat/modification.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "En cas de contradiction (documents vs FVA) hors fraude doc : renseigner l’application via l’assureur/courtier (liste) et valider.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // FNAEG
          _ConditionCard(
            title:
                "F.N.A.E.G — Fichier National Automatisé des Empreintes Génétiques",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              const _SubTitle("Finalité / contenu"),
              const _Paragraph(
                "Centralise les profils génétiques issus de traces biologiques et des prélèvements sur personnes (selon cadres légaux).",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Infractions concernées : "),
                lawSpan("article 706-55 du Code de procédure pénale"),
                const TextSpan(
                  text:
                      " (liste : infractions sexuelles, vols, violences, stupéfiants, terrorisme, etc.).",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Recherches mort/disparition : "),
                lawSpan("articles 74, 74-1 et 80-4 du C.P.P."),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _ConditionCard(
                title: "Comparaison (point technique)",
                cardColor: cardAmber,
                accent: accentAmber,
                titleColor: textMain,
                children: const [
                  _Paragraph(
                    "Il est possible d’effectuer un prélèvement pour simple comparaison avec le fichier "
                    "sur une personne soupçonnée, sans enregistrer son profil (selon cadre).",
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const _SubTitle("Refus de prélèvement"),
              _Paragraph.rich([
                const TextSpan(text: "Constitue une infraction : "),
                lawSpan("article 706-56 II du C.P.P."),
                const TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // FAED
          _ConditionCard(
            title: "F.A.E.D — Fichier Automatisé des Empreintes Digitales",
            cardColor: cardRules,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _SubTitle("Finalité"),
              const _Paragraph(
                "Fonds dactyloscopique commun (PN, GN, douane judiciaire) : identification d’auteurs, victimes, personnes décédées, etc.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Cadres cités (exemples) : "),
                lawSpan("articles 74, 74-1 et 80-4 du C.P.P."),
                const TextSpan(text: " (mort/disparition) ; "),
                lawSpan("article 78-3 du C.P.P."),
                const TextSpan(text: " (vérification d’identité) ; "),
                lawSpan("article L. 142-2 du CESEDA"),
                const TextSpan(text: " (identification étranger)."),
              ]),
              const SizedBox(height: 10),
              const _SubTitle("Interrogation"),
              const _BulletPoint(
                text:
                    "Via service PJ / identité judiciaire équipé (terminal) ou IJPP ; envoi des relevés scannés selon procédures.",
              ),
              const SizedBox(height: 10),
              const _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Conservation des données : variable (≈ 15 à 40 ans) selon nature des faits (délits/crimes).",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // FIJAISV
          _ConditionCard(
            title:
                "F.I.J.A.I.S.V — Fichier Judiciaire National Automatisé des Auteurs d’Infractions Sexuelles ou Violentes",
            cardColor: cardInfo,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              const _SubTitle("Finalité"),
              const _Paragraph(
                "Prévenir la récidive et faciliter l’identification des auteurs : identité, adresse/résidences, obligations.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text: "Infractions pouvant entraîner l’inscription : ",
                ),
                lawSpan("article 706-47 alinéa 1 du C.P.P."),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              const _SubTitle("Obligations de la personne"),
              const _BulletPoint(
                text:
                    "Justifier de son adresse (délais et périodicités variables) et déclarer tout changement d’adresse sous 15 jours.",
              ),
              _Paragraph.rich([
                const TextSpan(text: "Sanction du non-respect : "),
                lawSpan("article 706-53-5 du C.P.P."),
                const TextSpan(text: " (2 ans et 30 000 €)."),
              ]),
              const SizedBox(height: 10),
              const _SubTitle("Consultation"),
              const _BulletPoint(
                text:
                    "Par autorités judiciaires ; par OPJ selon cadres (infractions listées ou sur instructions/autorisation). Consultation via portail CHEOPS.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // FIJAIT
          _ConditionCard(
            title:
                "F.I.J.A.I.T — Fichier Judiciaire National Automatisé des Auteurs d’Infractions Terroristes",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              const _SubTitle("Finalité"),
              const _Paragraph(
                "Prévenir le renouvellement d’infractions terroristes et faciliter l’identification des auteurs.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Infractions / cadre d’inscription : "),
                lawSpan("article 706-25-4 alinéa 1 du C.P.P."),
                const TextSpan(text: " ; infractions terroristes "),
                lawSpan("articles 421-1 à 421-6 du Code pénal"),
                const TextSpan(text: " (avec exclusions précisées) ; et "),
                lawSpan("articles L. 224-1 et L. 225-7 du C.S.I."),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              const _SubTitle("Obligations"),
              const _BulletPoint(
                text:
                    "Justification d’adresse (15 jours puis tous les 3 mois), changement d’adresse sous 15 jours, déplacements transfrontaliers à déclarer.",
              ),
              const SizedBox(height: 10),
              const _SubTitle("Accès"),
              const _BulletPoint(
                text:
                    "Autorités judiciaires, OPJ (selon cadres), représentants de l’État et administrations (recrutement/habilitation), greffes pénitentiaires, services habilités (prévention terrorisme).",
              ),
            ],
          ),

          const SizedBox(height: 16),

          _ConditionCard(
            title: "Checklist terrain (ultra simple)",
            cardColor: cardInfo,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _SubTitle("Avant"),
              _IntroBullet(
                text:
                    "Avoir un motif professionnel clair (mission / procédure / contrôle).",
              ),
              _IntroBullet(
                text: "Vérifier que ton habilitation couvre bien le besoin.",
              ),
              SizedBox(height: 10),
              _SubTitle("Pendant"),
              _IntroBullet(
                text:
                    "Consulter uniquement l’info nécessaire (pas de curiosité).",
              ),
              _IntroBullet(
                text: "Appliquer la conduite à tenir affichée (ex : FPR).",
              ),
              SizedBox(height: 10),
              _SubTitle("Après"),
              _IntroBullet(
                text: "Ne jamais divulguer les infos (confidentialité).",
              ),
              _IntroBullet(
                text:
                    "Tracer correctement en procédure uniquement ce qui est utile et autorisé.",
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
