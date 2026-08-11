import 'package:flutter_test/flutter_test.dart';

// DIAGNOSTIKA P2: hive/hive_flutter API'larining barchasi
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

Box<int>? _boxRef;

Future<void> _dummyInit() async {
  await Hive.initFlutter('test_temp_path');
  _boxRef = await Hive.openBox<int>('diag_box');
  await Hive.close();
  await Hive.deleteFromDisk();
}

void main() {
  test('hive API kompilyatsiyasi', () {
    expect(Hive.boxExists('x'), isFalse);
    expect(_boxRef, isNull);
    expect(_dummyInit, isA<Future<void> Function()>());
  });
}
