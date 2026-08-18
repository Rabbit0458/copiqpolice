import 'package:flutter/material.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class OrganisationPnPage extends StatelessWidget {
  const OrganisationPnPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/institution_valeurs_pages/organisation_pn/organisation_pn_page.dart",
            "f00001",
            'Page en construction',
          ),
        ),
      ),
    );
  }
}
