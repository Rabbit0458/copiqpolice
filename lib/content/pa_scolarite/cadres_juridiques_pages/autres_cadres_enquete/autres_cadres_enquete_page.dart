import 'package:flutter/material.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaAutresCadresEnquetePage extends StatelessWidget {
  const PaAutresCadresEnquetePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/cadres_juridiques_pages/autres_cadres_enquete/autres_cadres_enquete_page.dart",
            "f00001",
            'Page en construction',
          ),
        ),
      ),
    );
  }
}
