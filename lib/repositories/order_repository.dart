import '../database/hive_database.dart';
import '../models/order.dart';

/// Buyurtmalar bilan ishlash (Hive lokal bazasi).
class OrderRepository {
  static const String _key = 'items';

  List<Order> getAll() {
    final raw = HiveDatabase.ordersBox.get(_key);
    if (raw == null) return [];
    return (raw as List)
        .map((e) => Order.fromMap(e as Map<dynamic, dynamic>))
        .toList();
  }

  void saveAll(List<Order> orders) {
    HiveDatabase.ordersBox.put(_key, orders.map((e) => e.toMap()).toList());
  }
}
