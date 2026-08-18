import 'package:flutter/material.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PADpgPage extends StatelessWidget {
  const PADpgPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/dpg_pages/dpg_page.dart",
            "f00001",
            'Page en construction',
          ),
        ),
      ),
    );
  }
}
