// lib/home/category_detail_cards_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ======== MODELES (compat avec tes configs) ========
class CategoryConfig {
  final String label;
  final String badge; // ex: "Concepts de base"
  final String
  image; // image de couverture de la catégorie (non utilisé par carte fille)
  final String route; // route de la page "d'ensemble" (celle-ci)
  final List<SubCategoryConfig> subcategories;
  const CategoryConfig({
    required this.label,
    required this.badge,
    required this.image,
    required this.route,
    required this.subcategories,
  });
}

class SubCategoryConfig {
  final String label;
  final String route;
  const SubCategoryConfig({required this.label, required this.route});
}

/// ===================================================
///   PAGE "DÉTAIL D’UNE CATÉGORIE" — Cartes enfants
///   UI identique à la page Généralités déjà en place
/// ===================================================
class CategoryDetailCardsPage extends StatelessWidget {
  const CategoryDetailCardsPage({super.key, required this.category});

  final CategoryConfig category;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Fond
    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF222222).withOpacity(.70);
    final Color iconOnImage = Colors.white;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_ios_new, color: textMain),
          tooltip: 'Retour',
        ),
        title: Text(
          category.label,
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        itemCount: category.subcategories.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, i) {
          final sub = category.subcategories[i];
          return _ModuleCard(
            tag: sub.route, // tag unique = route
            title: sub.label,
            subtitle: _subtitleFor(sub.label),
            imagePath: _imageFor(sub.label),
            textMain: textMain,
            textSoft: textSoft,
            iconOnImage: iconOnImage,
            isDark: isDark,
            onTap: () => Navigator.of(context).pushNamed(sub.route),
          );
        },
      ),
    );
  }

  // -------- Heuristiques images (une image par thème) --------
  String _imageFor(String label) {
    final l = label.toLowerCase();

    // Généralités
    if (l.contains('classification'))
      return 'assets/images/classification.jpeg';
    if (l.contains('infraction'))
      return 'assets/images/infraction_materiel.jpeg';
    if (l.contains('tentative')) return 'assets/images/infraction_legal.jpeg';
    if (l.contains('complic')) return 'assets/images/complicite.jpeg';
    if (l.contains('légitime') || l.contains('legitime')) {
      return 'assets/images/legitime_defense.jpeg';
    }
    if (l.contains('armes') || l.contains('cadre légal')) {
      return 'assets/images/armes_munitions.jpeg';
    }
    if (l.contains('libert')) return 'assets/images/libertes_publiques.jpeg';
    if (l.contains('rétention') || l.contains('retention')) {
      return 'assets/images/retention.jpeg';
    }

    // Cadres juridiques
    if (l.contains('cadres d\'enquête') || l.contains('cadres d’enquête')) {
      return 'assets/images/cadres_juridiques.jpeg';
    }
    if (l.contains('flagrant')) return 'assets/images/gavel_desk.jpg';
    if (l.contains('préliminaire') || l.contains('preliminaire')) {
      return 'assets/images/justice_balance.jpg';
    }
    if (l.contains('autres cadres')) return 'assets/images/gavel_desk_2.jpg';

    // Procédure pénale
    if (l.contains('garde à vue') || l.contains('garde a vue')) {
      return 'assets/images/gav.jpeg';
    }
    if (l.contains('perquisition')) return 'assets/images/perquisition.jpeg';
    if (l.contains('auditions')) return 'assets/images/auditions_pv.jpeg';
    if (l.contains('mesures de contrainte')) {
      return 'assets/images/mesures_contrainte.jpeg';
    }
    if (l.contains('saisies') ||
        l.contains('scellés') ||
        l.contains('scelles')) {
      return 'assets/images/saisies_scelles.jpeg';
    }
    if (l.contains('contrôle d’identité') ||
        l.contains('controle d\'identite') ||
        l.contains('contrôles d’identité') ||
        l.contains('controles d’identite')) {
      return 'assets/images/controle_identite.jpeg';
    }
    if (l.contains('infractions spécifiques')) {
      return 'assets/images/infractions_specifiques.jpeg';
    }
    if (l.contains('procès-verbal') ||
        l.contains('proces-verbal') ||
        l.contains('pv')) {
      return 'assets/images/pv_regles.jpeg';
    }

    // Droit pénal général
    if (l.contains('loi pénale') || l.contains('loi penale')) {
      return 'assets/images/droit_penal_general.jpeg';
    }
    if (l.contains('responsabilité pénale') ||
        l.contains('responsabilite penale')) {
      return 'assets/images/droit_penal_general_2.jpeg';
    }

    // Sanction
    if (l.contains('peines') || l.contains('sûreté') || l.contains('surete')) {
      return 'assets/images/sanction.jpeg';
    }
    if (l.contains('aggravation')) return 'assets/images/aggravations.jpeg';
    if (l.contains('pluralité') || l.contains('pluralite')) {
      return 'assets/images/pluralite_infractions.jpeg';
    }

    // Contre la personne
    if (l.contains('mise en danger'))
      return 'assets/images/mise_en_danger.jpeg';
    if (l.contains('viol') || l.contains('agressions sexuelles')) {
      return 'assets/images/viol_agressions.jpeg';
    }
    if (l.contains('enlèvement') || l.contains('enlevement')) {
      return 'assets/images/enlevement.jpeg';
    }
    if (l.contains('diffusion d’images') || l.contains('diffusion d\'images')) {
      return 'assets/images/diffusion_images.jpeg';
    }
    if (l.contains('dignité') || l.contains('dignite')) {
      return 'assets/images/dignite.jpeg';
    }
    if (l.contains('personnalité') || l.contains('personnalite')) {
      return 'assets/images/personnalite.jpeg';
    }
    if (l.contains('involontaires')) {
      return 'assets/images/atteintes_involontaires.jpeg';
    }
    if (l.contains('volontaires à la vie') ||
        l.contains('volontaires a la vie')) {
      return 'assets/images/atteintes_vie.jpeg';
    }
    if (l.contains('volontaires à l’intégrité') ||
        l.contains('volontaires a l’integrite') ||
        l.contains('integrite')) {
      return 'assets/images/atteintes_integrite.jpeg';
    }

    // Mineurs & famille
    if (l.contains('mineurs')) return 'assets/images/mineurs_famille.jpeg';
    if (l.contains('jaf')) return 'assets/images/ordonnances_jaf.jpeg';
    if (l.contains('autorité parentale') || l.contains('autorite parentale')) {
      return 'assets/images/autorite_parentale.jpeg';
    }
    if (l.contains('abandon de famille')) {
      return 'assets/images/abandon_famille.jpeg';
    }

    // Contre la nation
    if (l.contains('association de malfaiteurs')) {
      return 'assets/images/association_malfaiteurs.jpeg';
    }
    if (l.contains('abus d’autorité') || l.contains('abus d\'autorite')) {
      return 'assets/images/abus_autorite.jpeg';
    }
    if (l.contains('action de la justice')) {
      return 'assets/images/action_justice.jpeg';
    }
    if (l.contains('administration par des particuliers')) {
      return 'assets/images/administration_particuliers.jpeg';
    }
    if (l.contains('faux') && l.contains('usage')) {
      return 'assets/images/faux_usage_faux.jpeg';
    }
    if (l.contains('probité') || l.contains('probite')) {
      return 'assets/images/probite.jpeg';
    }

    // Contre les biens
    if (l.contains('recel')) return 'assets/images/recel.jpeg';
    if (l.contains('vol')) return 'assets/images/vol.jpeg';
    if (l.contains('stad')) return 'assets/images/stad.jpeg';
    if (l.contains('chèques') ||
        l.contains('cheques') ||
        l.contains('contrefa')) {
      return 'assets/images/contrefacons.jpeg';
    }
    if (l.contains('destructions') ||
        l.contains('dégradations') ||
        l.contains('degradations')) {
      return 'assets/images/destructions.jpeg';
    }
    if (l.contains('voisines du vol')) {
      return 'assets/images/voisines_vol.jpeg';
    }

    // Circulation
    if (l.contains('stupéfiants') || l.contains('stupefiants')) {
      return 'assets/images/conduite_stupefiants.jpeg';
    }
    if (l.contains('ivresse')) return 'assets/images/ivresse.jpeg';
    if (l.contains('état alcoolique') || l.contains('etat alcoolique')) {
      return 'assets/images/etat_alcoolique.jpeg';
    }
    if (l.contains('assurance')) return 'assets/images/defaut_assurance.jpeg';
    if (l.contains('permis')) return 'assets/images/defaut_permis.jpeg';
    if (l.contains('délit de fuite') || l.contains('delit de fuite')) {
      return 'assets/images/delit_fuite.jpeg';
    }
    if (l.contains('excès de vitesse') || l.contains('exces de vitesse')) {
      return 'assets/images/grand_exces_vitesse.jpeg';
    }
    if (l.contains('vérifications') || l.contains('verifications')) {
      return 'assets/images/refus_verifications.jpeg';
    }
    if (l.contains('obtempérer') || l.contains('obtemperer')) {
      return 'assets/images/refus_obtemperer.jpeg';
    }
    if (l.contains('rodéo') || l.contains('rodeo')) {
      return 'assets/images/rodeo_motorise.jpeg';
    }
    if (l.contains('plaques') || l.contains('inscriptions')) {
      return 'assets/images/plaques_inscriptions.jpeg';
    }
    if (l.contains('incitation') ||
        l.contains('organisation') ||
        l.contains('promotion')) {
      return 'assets/images/incitation_organisation.jpeg';
    }

    // Armes
    if (l.contains('classification des armes')) {
      return 'assets/images/armes_munitions.jpeg';
    }
    if (l.contains('définitions') || l.contains('definitions')) {
      return 'assets/images/armes_definitions.jpeg';
    }
    if (l.contains('introduction')) return 'assets/images/armes_intro.jpeg';
    if (l.contains('cat. a') ||
        l.contains('cat. b') ||
        l.contains('cat a') ||
        l.contains('cat b')) {
      return 'assets/images/armes_cat_ab.jpeg';
    }
    if (l.contains('cat. c') ||
        l.contains('cat. d') ||
        l.contains('cat c') ||
        l.contains('cat d')) {
      return 'assets/images/armes_cat_cd.jpeg';
    }
    if (l.contains('matériels de guerre') ||
        l.contains('materiels de guerre')) {
      return 'assets/images/armes_materiels_guerre.jpeg';
    }
    if (l.contains('acquisition') ||
        l.contains('détention') ||
        l.contains('detention')) {
      return 'assets/images/armes_acquisition_detention.jpeg';
    }
    if (l.contains('port') || l.contains('transport')) {
      return 'assets/images/armes_port_transport.jpeg';
    }

    // Libertés publiques
    if (l.contains('introduction générale') ||
        l.contains('introduction generale')) {
      return 'assets/images/libertes_intro.jpeg';
    }
    if (l.contains('garanties')) return 'assets/images/libertes_garanties.jpeg';
    if (l.contains('expression collectives')) {
      return 'assets/images/libertes_expression.jpeg';
    }
    if (l.contains('vie privée') || l.contains('vie privee')) {
      return 'assets/images/libertes_vie_privee.jpeg';
    }

    // Stups
    if (l.contains('stupéfiants') || l.contains('stupefiants')) {
      return 'assets/images/stupefiants.jpeg';
    }
    if (l.contains('cession') || l.contains('offre illicite')) {
      return 'assets/images/stup_cession_offre.jpeg';
    }
    if (l.contains('direction') || l.contains('organisation')) {
      return 'assets/images/stup_direction_org.jpeg';
    }
    if (l.contains('facilitation'))
      return 'assets/images/stup_facilitation.jpeg';
    if (l.contains('production') || l.contains('fabrication')) {
      return 'assets/images/stup_production.jpeg';
    }
    if (l.contains('provocation d’un majeur') ||
        l.contains('provocation d\'un majeur')) {
      return 'assets/images/stup_provocation.jpeg';
    }
    if (l.contains('blanchiment')) return 'assets/images/stup_blanchiment.jpeg';
    if (l.contains('transport') ||
        l.contains('détention') ||
        l.contains('detention')) {
      return 'assets/images/stup_transport_detention.jpeg';
    }
    if (l.contains('importation') || l.contains('exportation')) {
      return 'assets/images/stup_import_export.jpeg';
    }
    if (l.contains('usage illicite')) return 'assets/images/stup_usage.jpeg';

    // Défaut
    return 'assets/images/generalite.jpeg';
  }

  String _subtitleFor(String label) {
    final l = label.toLowerCase();

    // Généralités
    if (l.contains('classification')) return 'Concepts de base';
    if (l.contains('infraction')) return 'Éléments légal, matériel & moral';
    if (l.contains('tentative')) return 'Actes non consommés mais punissables';
    if (l.contains('complic')) return 'Participation punissable à l’infraction';
    if (l.contains('légitime') || l.contains('legitime')) {
      return 'Protection immédiate et nécessaire';
    }
    if (l.contains('armes')) return 'Usage et régimes applicables';
    if (l.contains('libert')) return 'Droits fondamentaux et garanties';
    if (l.contains('rétention') || l.contains('retention')) {
      return 'Mesures temporaires en locaux de police';
    }

    // Cadres juridiques
    if (l.contains('cadres d\'enquête') || l.contains('cadres d’enquête')) {
      return 'Choix & cadre légal des investigations';
    }
    if (l.contains('flagrant')) return 'Conditions, pouvoirs, portée';
    if (l.contains('préliminaire') || l.contains('preliminaire')) {
      return 'Investigations sous contrôle du parquet';
    }
    if (l.contains('autres cadres'))
      return 'Enquête sous commissions / rogatoires';

    // Procédure pénale
    if (l.contains('garde à vue') || l.contains('garde a vue')) {
      return 'Cadre, droits, auditions, délais';
    }
    if (l.contains('perquisition')) return 'Conditions, perquisitions, saisies';
    if (l.contains('auditions')) return 'Formalisme & rédaction des PV';
    if (l.contains('mesures de contrainte'))
      return 'Rétentions, fouilles, réquisitions';
    if (l.contains('saisies') ||
        l.contains('scellés') ||
        l.contains('scelles')) {
      return 'Saisies, conservation et scellés';
    }
    if (l.contains('contrôle d’identité') ||
        l.contains('controle d\'identite') ||
        l.contains('contrôles d’identité')) {
      return 'Vérifications et suites';
    }
    if (l.contains('infractions spécifiques')) {
      return 'Stupéfiants, armes, roulage';
    }
    if (l.contains('procès-verbal') ||
        l.contains('proces-verbal') ||
        l.contains('pv')) {
      return 'Structure, mentions, signatures';
    }

    // Par défaut
    return 'Module';
  }
}

/// ===================== MINI-COMPONENT =====================
class _ModuleCard extends StatelessWidget {
  const _ModuleCard({
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.textMain,
    required this.textSoft,
    required this.iconOnImage,
    required this.isDark,
    required this.onTap,
  });

  final String tag;
  final String title;
  final String subtitle;
  final String imagePath;
  final Color textMain;
  final Color textSoft;
  final Color iconOnImage;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color badgeBg = Colors.white.withOpacity(isDark ? 0.14 : 0.10);
    final Color borderClr = Colors.white.withOpacity(isDark ? 0.18 : 0.14);

    return GestureDetector(
      onTap: onTap,
      child: Semantics(
        button: true,
        label: '$title — découvrir',
        child: Container(
          height: 190,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: Colors.transparent,
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Hero(
                tag: 'hero_$tag',
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  filterQuality: FilterQuality.high,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(.25),
                      Colors.black.withOpacity(.55),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: badgeBg,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: borderClr),
                      ),
                      child: Text(
                        'Module',
                        style: GoogleFonts.fustat(
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.fustat(
                        fontWeight: FontWeight.w900,
                        fontSize: 26,
                        color: Colors.white,
                        height: 1.05,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.fustat(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.white.withOpacity(.85),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(right: 16, bottom: 16, child: _RoundCTA(onTap: onTap)),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoundCTA extends StatelessWidget {
  const _RoundCTA({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(.12),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 22,
              ),
              const SizedBox(width: 6),
              Text(
                'Découvrir',
                style: GoogleFonts.fustat(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
