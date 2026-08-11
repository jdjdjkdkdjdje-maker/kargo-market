import '../database/local_database.dart';
import '../models/product.dart';

/// Mahsulotlar bilan ishlash (lokal JSON bazasi).
class ProductRepository {
  static const String _key = 'items';

  List<Product> getAll() {
    final raw = LocalDatabase.productsBox.get(_key);
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

  Future<void> save(Product product) async {
    final list = getAll();
    final index = list.indexWhere((e) => e.id == product.id);
    if (index >= 0) {
      list[index] = product;
    } else {
      list.add(product);
    }
    await LocalDatabase.productsBox.put(_key, list.map((e) => e.toMap()).toList());
  }

  Future<void> delete(String id) async {
    final list = getAll().where((e) => e.id != id).toList();
    await LocalDatabase.productsBox.put(_key, list.map((e) => e.toMap()).toList());
  }

  Future<void> replaceAll(List<Product> products) async {
    await LocalDatabase.productsBox.put(_key, products.map((e) => e.toMap()).toList());
  }
}
