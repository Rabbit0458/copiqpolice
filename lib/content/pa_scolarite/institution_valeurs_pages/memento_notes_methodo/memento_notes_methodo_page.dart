import 'package:flutter/material.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class MementoNotesMethodoPage extends StatelessWidget {
  const MementoNotesMethodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/institution_valeurs_pages/memento_notes_methodo/memento_notes_methodo_page.dart",
            "f00001",
            'Page en construction',
          ),
        ),
      ),
    );
  }
}
