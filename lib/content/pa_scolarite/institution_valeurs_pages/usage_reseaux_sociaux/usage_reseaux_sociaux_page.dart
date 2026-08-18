import 'package:flutter/material.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class UsageReseauxSociauxPage extends StatelessWidget {
  const UsageReseauxSociauxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/institution_valeurs_pages/usage_reseaux_sociaux/usage_reseaux_sociaux_page.dart",
            "f00001",
            'Page en construction',
          ),
        ),
      ),
    );
  }
}
