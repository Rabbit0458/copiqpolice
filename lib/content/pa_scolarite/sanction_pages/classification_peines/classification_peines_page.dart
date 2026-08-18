import 'package:flutter/material.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaClassificationPeinesPage extends StatelessWidget {
  const PaClassificationPeinesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/sanction_pages/classification_peines/classification_peines_page.dart",
            "f00001",
            'Page en construction',
          ),
        ),
      ),
    );
  }
}
