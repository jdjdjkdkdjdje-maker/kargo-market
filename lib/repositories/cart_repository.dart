import '../database/local_database.dart';
import '../models/cart_item.dart';

/// Savatcha bilan ishlash (lokal JSON bazasi).
class CartRepository {
  static const String _key = 'items';

  List<CartItem> getAll() {
    final raw = LocalDatabase.cartBox.get(_key);
    if (raw == null) return [];
    return (raw as List)
        .map((e) => CartItem.fromMap(e as Map<dynamic, dynamic>))
        .toList();
  }

  Future<void> saveAll(List<CartItem> items) async {
    await LocalDatabase.cartBox.put(_key, items.map((e) => e.toMap()).toList());
  }
}
