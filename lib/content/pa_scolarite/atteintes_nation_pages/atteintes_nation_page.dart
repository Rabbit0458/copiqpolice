import 'package:flutter/material.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PAAtteinteNationPage extends StatelessWidget {
  const PAAtteinteNationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/atteintes_nation_pages/atteintes_nation_page.dart",
            "f00001",
            'Page en construction',
          ),
        ),
      ),
    );
  }
}
