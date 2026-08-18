import 'package:flutter/material.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaEnqueteFlagrantDelitPage extends StatelessWidget {
  const PaEnqueteFlagrantDelitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/cadres_juridiques_pages/enquete_flagrant_delit/enquete_flagrant_delit_page.dart",
            "f00001",
            'Page en construction',
          ),
        ),
      ),
    );
  }
}
