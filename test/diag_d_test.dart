import 'package:flutter_test/flutter_test.dart';

// DIAGNOSTIKA D: faqat hive_flutter paketi
import 'package:hive_flutter/hive_flutter.dart';

void main() {
  test('hive_flutter paketi yuklanadi', () {
    expect(Hive.boxExists('test'), isFalse);
  });
}
