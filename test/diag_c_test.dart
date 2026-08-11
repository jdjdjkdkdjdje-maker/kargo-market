import 'package:flutter_test/flutter_test.dart';

// DIAGNOSTIKA C: faqat flutter_riverpod paketi
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _p = Provider<int>((ref) => 7);

void main() {
  test('riverpod paketi yuklanadi', () {
    expect(_p, isNotNull);
  });
}
