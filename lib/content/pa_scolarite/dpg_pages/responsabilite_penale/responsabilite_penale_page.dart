import 'package:flutter/material.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PAResponsabilitePenalePage extends StatelessWidget {
  const PAResponsabilitePenalePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/dpg_pages/responsabilite_penale/responsabilite_penale_page.dart",
            "f00001",
            'Page en construction',
          ),
        ),
      ),
    );
  }
}
