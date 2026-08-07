import 'package:flutter/material.dart';

import '../../content/pa_exam/culture_generale/pa_cg_hub_pages.dart';
import '../../content/pa_exam/photolangage/pa_photolangage_core.dart';
import '../../content/pa_exam/psycotechniques/pa_tests_psy_hub_pages.dart';

class PaProgressModuleMeta {
  const PaProgressModuleMeta({
    required this.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.route,
  });
  final String key;
  final String label;
  final IconData icon;
  final Color color;
  final String route;
}

const paProgressModules = <String, PaProgressModuleMeta>{
  'culture_generale': PaProgressModuleMeta(
    key: 'culture_generale',
    label: 'Culture générale',
    icon: Icons.public_rounded,
    color: Color(0xFF2563EB),
    route: PaCgRoutes.entrainementsQcm,
  ),
  'psychotechnique': PaProgressModuleMeta(
    key: 'psychotechnique',
    label: 'Tests psychotechniques',
    icon: Icons.psychology_alt_rounded,
    color: Color(0xFF7C3AED),
    route: PaTestsPsyRoutes.entrainementsQcm,
  ),
  'francais': PaProgressModuleMeta(
    key: 'francais',
    label: 'Français',
    icon: Icons.translate_rounded,
    color: Color(0xFFDB2777),
    route: PaCgRoutes.exFrancais,
  ),
  'institution': PaProgressModuleMeta(
    key: 'institution',
    label: 'Institution policière',
    icon: Icons.local_police_rounded,
    color: Color(0xFF0F766E),
    route: PaCgRoutes.exPolice,
  ),
  'photolangage': PaProgressModuleMeta(
    key: 'photolangage',
    label: 'Photolangage',
    icon: Icons.photo_camera_back_rounded,
    color: Color(0xFFEA580C),
    route: PaPhotolangageRoutes.entrainements,
  ),
};

PaProgressModuleMeta paModuleMeta(String key) =>
    paProgressModules[key] ??
    const PaProgressModuleMeta(
      key: 'autres',
      label: 'Autres entraînements',
      icon: Icons.school_rounded,
      color: Color(0xFF64748B),
      route: PaCgRoutes.home,
    );

String paModuleKeyFromNames(String moduleName, String quizName) {
  final value = '$moduleName $quizName'.toLowerCase();
  if (value.contains('photo')) return 'photolangage';
  if (value.contains('psycho') ||
      value.contains('logique') ||
      value.contains('calcul') ||
      value.contains('concentration') ||
      value.contains('attention')) {
    return 'psychotechnique';
  }
  if (value.contains('fran') || value.contains('verbal')) return 'francais';
  if (value.contains('police') || value.contains('institution')) {
    return 'institution';
  }
  if (value.contains('culture') || value.contains('connaissance')) {
    return 'culture_generale';
  }
  return 'autres';
}
