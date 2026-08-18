import 'package:flutter/material.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class SecuriteFouilleIntegralePage extends StatelessWidget {
  const SecuriteFouilleIntegralePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/policier_intervention_pages/securite_fouille_integrale/securite_fouille_integrale_page.dart",
            "f00001",
            'Page en construction',
          ),
        ),
      ),
    );
  }
}
