import 'package:flutter/material.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaStupefiantsPage extends StatelessWidget {
  const PaStupefiantsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/stupefiants_pages/stupefiants_page.dart",
            "f00001",
            'Page en construction',
          ),
        ),
      ),
    );
  }
}
