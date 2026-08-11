import 'package:flutter_test/flutter_test.dart';

// DIAGNOSTIKA: butun ilova (main.dart) import grafigi kompilyatsiyasi.
// Agar bu fayl yuklansa — barcha Dart kodi to'g'ri kompilyatsiya bo'ladi.
import 'package:xarid_market/main.dart';

void main() {
  test('butun ilova kompilyatsiyasi', () {
    expect(XaridApp, isNotNull);
  });
}
