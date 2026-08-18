import 'package:flutter/material.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class ConduiteVpPage extends StatelessWidget {
  const ConduiteVpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/policier_intervention_pages/conduite_vp/conduite_vp_page.dart",
            "f00001",
            'Page en construction',
          ),
        ),
      ),
    );
  }
}
