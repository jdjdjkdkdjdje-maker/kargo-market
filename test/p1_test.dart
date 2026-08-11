import 'package:flutter_test/flutter_test.dart';

// DIAGNOSTIKA P1: riverpod API'larining barchasi
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _N1 extends Notifier<int> {
  @override
  int build() => 0;
}

final _p1 = NotifierProvider<_N1, int>(_N1.new);

class _N2 extends AsyncNotifier<List<int>> {
  @override
  Future<List<int>> build() async => <int>[];
}

final _p2 = AsyncNotifierProvider<_N2, List<int>>(_N2.new);

final _p3 = Provider<int>((ref) => 5);
final _p4 = Provider.family<int, String>((ref, s) => s.length);

class _Inline extends Notifier<int> {
  @override
  int build() => 1;
  void mutate() => state = 2;
}

final _p5 = NotifierProvider<_Inline, int>(_Inline.new);

void main() {
  test('riverpod barcha API', () {
    expect(_p1, isNotNull);
    expect(_p2, isNotNull);
    expect(_p3, isNotNull);
    expect(_p4, isNotNull);
    expect(_p5, isNotNull);
    expect(AsyncData<int>(1).value, 1);
    expect(AsyncLoading<int>(), isA<AsyncLoading<int>>());
  });
}
