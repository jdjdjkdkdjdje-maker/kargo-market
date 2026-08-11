import '../../models/product.dart';

/// Qidiruv: mahsulot nomi va kategoriyasida moslikni qidiradi.
/// Lokal bazada ishlaydi — internet talab qilinmaydi.
List<Product> searchProducts(List<Product> products, String query) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) return products;
  return products.where((p) {
    return p.name.toLowerCase().contains(q) ||
        p.category.toLowerCase().contains(q) ||
        p.description.toLowerCase().contains(q);
  }).toList();
}
