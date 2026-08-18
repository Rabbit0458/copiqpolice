import 'package:flutter/material.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class StupefiantsIdentificationDetectionPage extends StatelessWidget {
  const StupefiantsIdentificationDetectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/policier_intervention_pages/stupefiants_identification_detection/stupefiants_identification_detection_page.dart",
            "f00001",
            'Page en construction',
          ),
        ),
      ),
    );
  }
}
