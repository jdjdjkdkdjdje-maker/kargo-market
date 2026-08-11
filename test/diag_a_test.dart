import 'package:flutter_test/flutter_test.dart';

// DIAGNOSTIKA A: riverpod + modellar (hive siz)
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xarid_market/models/app_settings.dart';
import 'package:xarid_market/models/cart_item.dart';
import 'package:xarid_market/models/cart_summary.dart';
import 'package:xarid_market/models/profile_data.dart';

final _diagProvider = Provider<int>((ref) => 42);

class _DiagNotifier extends Notifier<int> {
  @override
  int build() => 1;
}

final _diagNotifierProvider = NotifierProvider<_DiagNotifier, int>(_DiagNotifier.new);

void main() {
  test('riverpod va modellar kompilyatsiyasi', () {
    expect(_diagProvider, isNotNull);
    expect(_diagNotifierProvider, isNotNull);
    const s = AppSettings();
    expect(s.themeMode.index, 0);
    final ci = CartItem(productId: 'x', quantity: 1);
    expect(ci.quantity, 1);
    const cs = CartSummary(itemsCount: 0, productsTotal: 0, discount: 0, deliveryFee: 0, total: 0);
    expect(cs.total, 0);
    const pd = ProfileData();
    expect(pd.isEmpty, isTrue);
  });
}
