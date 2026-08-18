import 'package:flutter/material.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class DgpnDgsiPpPage extends StatelessWidget {
  const DgpnDgsiPpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/institution_valeurs_pages/dgpn_dgsi_pp/dgpn_dgsi_pp_page.dart",
            "f00001",
            'Page en construction',
          ),
        ),
      ),
    );
  }
}
