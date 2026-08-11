import '../database/local_database.dart';
import '../models/order.dart';

/// Buyurtmalar bilan ishlash (lokal JSON bazasi).
class OrderRepository {
  static const String _key = 'items';

  List<Order> getAll() {
    final raw = LocalDatabase.ordersBox.get(_key);
    if (raw == null) return [];
    return (raw as List)
        .map((e) => Order.fromMap(e as Map<dynamic, dynamic>))
        .toList();
  }

  Future<void> saveAll(List<Order> orders) async {
    await LocalDatabase.ordersBox.put(_key, orders.map((e) => e.toMap()).toList());
  }
}
