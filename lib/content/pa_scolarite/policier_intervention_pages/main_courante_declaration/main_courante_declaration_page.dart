import 'package:flutter/material.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class MainCouranteDeclarationPage extends StatelessWidget {
  const MainCouranteDeclarationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/policier_intervention_pages/main_courante_declaration/main_courante_declaration_page.dart",
            "f00001",
            'Page en construction',
          ),
        ),
      ),
    );
  }
}
