import 'package:copiqpolice/features/home/profil_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    GoogleFonts.config.allowRuntimeFetching = false;
    await Supabase.initialize(
      url: 'https://profile-layout.invalid',
      anonKey: 'layout-test',
      httpClient: MockClient((_) async => http.Response('{}', 200)),
      authOptions: const FlutterAuthClientOptions(autoRefreshToken: false),
    );
  });

  tearDownAll(() => Supabase.instance.dispose());

  testWidgets('Profil respecte le viewport et rend toute la carte accessible', (
    tester,
  ) async {
    final profileKey = GlobalKey();
    final barKey = GlobalKey();
    addTearDown(() => tester.view.resetPhysicalSize());
    addTearDown(() => tester.view.resetDevicePixelRatio());
    tester.view.devicePixelRatio = 1;

    Future<void> show(
      Size size,
      double inset,
      bool extended,
      double scale,
      TargetPlatform platform,
      double barHeight,
    ) async {
      tester.view.physicalSize = size;
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(platform: platform),
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              padding: EdgeInsets.only(top: 24, bottom: inset),
              viewPadding: EdgeInsets.only(top: 24, bottom: inset),
              textScaler: TextScaler.linear(scale),
            ),
            child: child!,
          ),
          home: Scaffold(
            extendBody: extended,
            body: SafeArea(
              bottom: extended,
              child: ProfilPage(key: profileKey),
            ),
            bottomNavigationBar: SizedBox(
              key: barKey,
              height: barHeight + inset,
            ),
          ),
        ),
      );
      await tester.pump();
    }

    await show(const Size(414, 896), 34, false, 1, TargetPlatform.iOS, 80);
    // Le chargement réel attend au maximum six secondes une session absente.
    for (var i = 0; i < 12; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 600)),
      );
      await tester.pump(const Duration(milliseconds: 650));
    }

    for (final platform in [TargetPlatform.iOS, TargetPlatform.android]) {
      for (final extended in [false, true]) {
        for (final size in [
          const Size(320, 568),
          const Size(375, 667),
          const Size(414, 896),
          const Size(844, 390),
        ]) {
          for (final scale in [1.0, 1.8]) {
            await show(
              size,
              platform == TargetPlatform.iOS ? 34 : 24,
              extended,
              scale,
              platform,
              extended ? 100 : 80,
            );
            final list = find.descendant(
              of: find.byType(ProfilPage),
              matching: find.byType(ListView),
            );
            expect(list, findsOneWidget);
            final scrollable = find.descendant(
              of: list,
              matching: find.byType(Scrollable),
            );
            final state = tester.state<ScrollableState>(scrollable);
            state.position.jumpTo(0);
            await tester.pump();
            expect(
              tester.getBottomLeft(list).dy,
              lessThanOrEqualTo(tester.getTopLeft(find.byKey(barKey)).dy),
            );
            final legal = find.text('Informations légales');
            await tester.scrollUntilVisible(legal, 120, scrollable: scrollable);
            await tester.ensureVisible(legal);
            await tester.pumpAndSettle();
            expect(legal.hitTestable(), findsOneWidget);
            state.position.jumpTo(state.position.maxScrollExtent);
            await tester.pumpAndSettle();
            final card = find.ancestor(of: legal, matching: find.byType(Card));
            expect(
              tester.getBottomLeft(card).dy,
              lessThan(tester.getTopLeft(find.byKey(barKey)).dy),
            );
            expect(find.text('Déconnexion').hitTestable(), findsOneWidget);
            expect(tester.takeException(), isNull);
          }
        }
      }
    }
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
