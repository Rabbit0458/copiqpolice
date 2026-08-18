import 'package:flutter/material.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PAAtteintesBiensPage extends StatelessWidget {
  const PAAtteintesBiensPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/atteintes_biens_pages/atteintes_biens_page.dart",
            "f00001",
            'Page en construction',
          ),
        ),
      ),
    );
  }
}
