import 'package:flutter/material.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PpPerquisitionsPage extends StatelessWidget {
  const PpPerquisitionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/procedure_penale_pages/pp_perquisitions/pp_perquisitions_page.dart",
            "f00001",
            'Page en construction',
          ),
        ),
      ),
    );
  }
}
