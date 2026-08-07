import 'dart:io';

import 'package:copiqpolice/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'chaque destination littérale utilisée par la scolarité PA est branchée',
    () {
      // Ces chemins identifient des groupes visuels. Une CategoryConfig ayant
      // des sous-catégories ouvre le sélecteur interne et ne pousse jamais sa
      // propre route ; seules les destinations de ses cartes doivent résoudre.
      const nonNavigableGroupRoutes = <String>{
        '/pa/dps_dpg/crimes_nation',
        '/pa/dps_dpg/mineurs_famille',
        '/pa/dps_dpg/procedure_penale',
        '/pa/dps_dpg/sanctions',
        '/pa/dps_dpg/socle_avance/acteurs_pj',
        '/pa/dps_dpg/socle_avance/atteintes_biens',
        '/pa/dps_dpg/socle_avance/atteintes_personnes',
        '/pa/dps_dpg/socle_avance/autorite_etat',
        '/pa/dps_dpg/socle_avance/delits_routiers',
        '/pa/dps_dpg/socle_avance/generalites',
        '/pa/dps_dpg/socle_avance/stupefiants',
        '/pa/dps_dpg/socle_initial/armes_munitions',
        '/pa/dps_dpg/socle_initial/atteintes_biens',
        '/pa/dps_dpg/socle_initial/atteintes_personnes',
        '/pa/dps_dpg/socle_initial/autorite_etat',
        '/pa/dps_dpg/socle_initial/cadres_juridiques',
        '/pa/dps_dpg/socle_initial/circulation',
        '/pa/dps_dpg/socle_initial/controle_identite',
        '/pa/dps_dpg/socle_initial/generalites',
        '/pa/dps_dpg/socle_initial/hierarchie',
        '/pa/dps_dpg/socle_initial/organisation_judiciaire',
        '/pa/institution/accueil_public',
        '/pa/institution/deontologie',
        '/pa/institution/formation_initiale',
        '/pa/institution/hierarchie_info',
        '/pa/institution/histoire',
        '/pa/institution/laicite',
        '/pa/institution/organisation_pn',
        '/pa/memento_circulation/controle_routier',
        '/pa/memento_circulation/equipements',
        '/pa/memento_circulation/procedures',
      };
      final files = <File>[
        ...Directory('lib/content/pa_scolarite')
            .listSync(recursive: true)
            .whereType<File>()
            .where((file) => file.path.endsWith('.dart')),
        File('lib/features/home/home_page_pa_school.dart'),
      ];
      // Inclut aussi les anciens raccourcis (`/sanction`, `/generalite`, etc.)
      // afin qu'une route non canonique ne puisse plus échapper à l'audit.
      final routePattern = RegExp(r'''['"](/[^'"]+)['"]''');
      final referencedRoutes = <String>{};

      for (final file in files) {
        final pattern = file.path.endsWith('home_page_pa_school.dart')
            ? RegExp(r'''['"](/pa/[^'"]+)['"]''')
            : routePattern;
        for (final match in pattern.allMatches(file.readAsStringSync())) {
          referencedRoutes.add(match.group(1)!);
        }
      }

      final resolvableRoutes = <String>{
        ...RouteRegistry.routes.keys,
        ...PaSchoolRouteRegistry.routes.keys,
      };
      final missing =
          referencedRoutes
              .difference(nonNavigableGroupRoutes)
              .difference(resolvableRoutes)
              .toList()
            ..sort();

      expect(
        missing,
        isEmpty,
        reason:
            'Toute carte et sous-carte PA doit ouvrir un écran existant. '
            'Routes manquantes :\n${missing.join('\n')}',
      );
    },
  );

  test('les routes profondes signalées sont toutes disponibles', () {
    const reportedRoutes = <String>{
      '/pa/dps_dpg/atteintes_biens/destructions_degradations/detention_transport_substances_preparation',
      '/pa/dps_dpg/atteintes_biens/destructions_degradations/dangereuses_personnes_intentionnelle',
      '/pa/dps_dpg/atteintes_biens/destructions_degradations/fausses_alertes',
      '/pa/dps_dpg/atteintes_personnes/atteintes_volontaires_integrite/menace_sans_condition',
      '/pa/dps_dpg/atteintes_personnes/atteintes_volontaires_integrite/embuscade',
      '/pa/dps_dpg/atteintes_personnes/atteintes_volontaires_integrite/appels_messages_malveillants_agressions_sonores',
      '/pa/dps_dpg/atteintes_personnes/atteintes_volontaires_integrite/menaces_avec_condition',
      '/pa/dps_dpg/atteintes_personnes/atteintes_volontaires_integrite/tortures_actes_barbarie',
      '/pa/dps_dpg/atteintes_personnes/atteintes_volontaires_integrite/violences_sur_fsi',
    };
    final resolvableRoutes = <String>{
      ...RouteRegistry.routes.keys,
      ...PaSchoolRouteRegistry.routes.keys,
    };

    expect(reportedRoutes.difference(resolvableRoutes), isEmpty);
  });
}
