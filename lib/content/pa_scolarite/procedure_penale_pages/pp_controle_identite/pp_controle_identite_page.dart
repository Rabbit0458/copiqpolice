import 'package:flutter/material.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PpControleIdentitePage extends StatelessWidget {
  const PpControleIdentitePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/procedure_penale_pages/pp_controle_identite/pp_controle_identite_page.dart",
            "f00001",
            'Page en construction',
          ),
        ),
      ),
    );
  }
}
