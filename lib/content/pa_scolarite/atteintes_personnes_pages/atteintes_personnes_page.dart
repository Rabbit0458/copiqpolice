import 'package:flutter/material.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PAAtteintesPersonnesPage extends StatelessWidget {
  const PAAtteintesPersonnesPage({super.key});

  static const String routeName = '/pa/dps_dpg/atteintes_personnes';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_personnes_page.dart",
            "f00001",
            'Page en construction',
          ),
        ),
      ),
    );
  }
}
