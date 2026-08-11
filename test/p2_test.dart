import 'package:flutter_test/flutter_test.dart';

// DIAGNOSTIKA P2: hive API'larining barchasi (hive_flutter siz)
import 'package:hive/hive.dart';

Box<int>? _boxRef;

void main() {
  test('hive API kompilyatsiyasi', () {
    expect(Hive.boxExists('x'), isFalse);
    expect(_boxRef, isNull);
    expect(Hive, isNotNull);
  });
}
