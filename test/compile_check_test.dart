import 'package:flutter_test/flutter_test.dart';

// DIAGNOSTIKA: faqat providers grafigi
import 'package:xarid_market/providers/app_providers.dart';

void main() {
  test('providers grafigi kompilyatsiyasi', () {
    expect(productsProvider, isNotNull);
  });
}
