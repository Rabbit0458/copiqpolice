import 'package:flutter/material.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class InstitutionPage extends StatelessWidget {
  const InstitutionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Institutions')),
      body: Center(
        child: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/shared/institution_page.dart",
            "f00001",
            'Contenu Institutions',
          ),
        ),
      ),
    );
  }
}
