import 'package:flutter/material.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PAArmesMunitionsPage extends StatelessWidget {
  const PAArmesMunitionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/armes_munitions_pages/armes_munitions_page.dart",
            "f00001",
            'Page en construction',
          ),
        ),
      ),
    );
  }
}
