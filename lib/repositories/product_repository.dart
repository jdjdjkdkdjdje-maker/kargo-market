import '../database/hive_database.dart';
import '../models/product.dart';

/// Mahsulotlar bilan ishlash (Hive lokal bazasi).
class ProductRepository {
  static const String _key = 'items';

  List<Product> getAll() {
    final raw = HiveDatabase.productsBox.get(_key);
    if (raw == null) return [];
    return (raw as List)
        .map((e) => Product.fromMap(e as Map<dynamic, dynamic>))
        .toList();
  }

  Product? getById(String id) {
    for (final p in getAll()) {
      if (p.id == id) return p;
    }
    return null;
  }

  void save(Product product) {
    final list = getAll();
    final index = list.indexWhere((e) => e.id == product.id);
    if (index >= 0) {
      list[index] = product;
    } else {
      list.add(product);
    }
    HiveDatabase.productsBox.put(_key, list.map((e) => e.toMap()).toList());
  }

  void delete(String id) {
    final list = getAll().where((e) => e.id != id).toList();
    HiveDatabase.productsBox.put(_key, list.map((e) => e.toMap()).toList());
  }

  void replaceAll(List<Product> products) {
    HiveDatabase.productsBox.put(_key, products.map((e) => e.toMap()).toList());
  }
}
