import 'package:flutter/material.dart';

import 'pa_exam_progress_source_registry.dart';

const gpxProgressModules = <String, PaProgressModuleMeta>{
  'culture_generale': PaProgressModuleMeta(
    key: 'culture_generale',
    label: 'Culture générale',
    icon: Icons.public_rounded,
    color: Color(0xFF2563EB),
    route: '/gpx_exam/concours/culture_generale_actualite',
  ),
  'psychotechnique': PaProgressModuleMeta(
    key: 'psychotechnique',
    label: 'Tests psychotechniques',
    icon: Icons.psychology_alt_rounded,
    color: Color(0xFF7C3AED),
    route: '/gpx_exam/concours/tests_psychotechniques/calcul_rapide',
  ),
  'langue_etrangere': PaProgressModuleMeta(
    key: 'langue_etrangere',
    label: 'Langue étrangère',
    icon: Icons.translate_rounded,
    color: Color(0xFFDB2777),
    route: '/gpx_exam/concours/langue_etrangere/exemples_anglais',
  ),
  'institution': PaProgressModuleMeta(
    key: 'institution',
    label: 'Institution policière',
    icon: Icons.local_police_rounded,
    color: Color(0xFF0F766E),
    route: '/gpx_exam/concours/culture_generale_police_securite',
  ),
  'cas_pratique': PaProgressModuleMeta(
    key: 'cas_pratique',
    label: 'Cas pratiques',
    icon: Icons.description_rounded,
    color: Color(0xFFEA580C),
    route: '/gpx_exam/concours/cas_pratique/welcome',
  ),
};

PaProgressModuleMeta gpxModuleMeta(String key) =>
    gpxProgressModules[key] ??
    const PaProgressModuleMeta(
      key: 'autres',
      label: 'Autres entraînements',
      icon: Icons.school_rounded,
      color: Color(0xFF64748B),
      route: '/gpx_exam/concours/culture_generale_actualite',
    );

String gpxModuleKeyFromNames(String moduleName, String quizName) {
  final value = '$moduleName $quizName'
      .toLowerCase()
      .replaceAll('é', 'e')
      .replaceAll('è', 'e')
      .replaceAll('ê', 'e');
  if (value.contains('cas pratique')) return 'cas_pratique';
  if (value.contains('psycho') ||
      value.contains('logique') ||
      value.contains('calcul') ||
      value.contains('concentration') ||
      value.contains('attention') ||
      value.contains('spatial')) {
    return 'psychotechnique';
  }
  if (value.contains('langue') ||
      value.contains('anglais') ||
      value.contains('espagnol') ||
      value.contains('allemand')) {
    return 'langue_etrangere';
  }
  if (value.contains('police') || value.contains('institution')) {
    return 'institution';
  }
  if (value.contains('culture') ||
      value.contains('histoire') ||
      value.contains('geograph') ||
      value.contains('science') ||
      value.contains('droit') ||
      value.contains('actualite') ||
      value.contains('sport')) {
    return 'culture_generale';
  }
  return 'autres';
}
