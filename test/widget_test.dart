import 'package:flutter_test/flutter_test.dart';
import 'package:copiqpolice/main.dart';

void main() {
  test('application bootstrap routes are registered', () {
    expect(RouteRegistry.routes, contains('/home-bootstrap'));
    expect(RouteRegistry.routes, contains('/mode_picker'));
    expect(RouteRegistry.routes, contains('/grade_picker'));
  });
}
