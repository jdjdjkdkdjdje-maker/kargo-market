import 'package:flutter_test/flutter_test.dart';
import 'package:xarid_market/core/constants/app_constants.dart';
import 'package:xarid_market/core/utils/formatters.dart';
import 'package:xarid_market/models/order.dart';
import 'package:xarid_market/models/order_item.dart';
import 'package:xarid_market/models/product.dart';
import 'package:xarid_market/providers/app_providers.dart';
import 'package:xarid_market/services/seed_data.dart';

void main() {
  group('Formatters', () {
    test('pul formatlash', () {
      expect(Formatters.money(2499000), '2 499 000 so\'m');
      expect(Formatters.money(1000), '1 000 so\'m');
      expect(Formatters.money(99), '99 so\'m');
      expect(Formatters.money(100000000), '100 000 000 so\'m');
    });

    test('chegirma foizi', () {
      expect(Formatters.discountPercent(2500000, 3000000), 17);
      expect(Formatters.discountPercent(3000000, 3000000), 0);
      expect(Formatters.discountPercent(3000000, 2500000), 0);
    });

    test('sana formati', () {
      final date = DateTime(2026, 8, 11);
      expect(Formatters.date(date), '11-avgust, 2026');
      expect(Formatters.shortDate(date), '11.08.2026');
    });
  });

  group('Product model', () {
    test('toMap/fromMap aylanishi', () {
      const product = Product(
        id: 'p01',
        name: 'Nova X10',
        category: 'Telefonlar',
        price: 2499000,
        oldPrice: 2999000,
        description: 'Tavsif',
        image: 'assets/products/p01.jpg',
        rating: 4.7,
        stock: 24,
        isNew: true,
        isPopular: true,
        features: ['Xususiyat 1', 'Xususiyat 2'],
      );
      final restored = Product.fromMap(product.toMap());
      expect(restored.id, product.id);
      expect(restored.name, product.name);
      expect(restored.price, product.price);
      expect(restored.oldPrice, product.oldPrice);
      expect(restored.rating, product.rating);
      expect(restored.stock, product.stock);
      expect(restored.isNew, true);
      expect(restored.isPopular, true);
      expect(restored.features.length, 2);
      expect(restored.discountPercent, 17);
      expect(restored.hasDiscount, true);
      expect(restored.inStock, true);
    });

    test('chegirmasiz mahsulot', () {
      const product = Product(
        id: 'pX',
        name: 'Oddiy',
        category: 'Uy uchun',
        price: 100000,
        oldPrice: 100000,
        description: '',
        image: 'assets/products/p01.jpg',
        rating: 4.0,
        stock: 0,
      );
      expect(product.hasDiscount, false);
      expect(product.discountPercent, 0);
      expect(product.inStock, false);
    });
  });

  group('Order model', () {
    test('buyurtma summasi hisobi', () {
      const item = OrderItem(
        productId: 'p01',
        name: 'Nova X10',
        image: 'assets/products/p01.jpg',
        price: 2499000,
        oldPrice: 2999000,
        quantity: 2,
      );
      expect(item.total, 4998000);

      final order = Order(
        id: 'X-260811-001',
        createdAt: DateTime(2026, 8, 11),
        items: const [item],
        productsTotal: 4998000,
        discount: 1000000,
        deliveryFee: 20000,
        total: 4018000,
        customerName: 'Aziz',
        phone: '+998901234567',
        address: 'Toshkent',
        paymentMethod: 'Naqd pul',
        status: 'Qabul qilindi',
      );
      expect(order.itemCount, 2);

      final restored = Order.fromMap(order.toMap());
      expect(restored.id, order.id);
      expect(restored.items.length, 1);
      expect(restored.total, 4018000);
      expect(restored.status, 'Qabul qilindi');
    });
  });

  group('Demo mahsulotlar', () {
    test('kamida 30 ta mahsulot', () {
      final products = SeedData.products();
      expect(products.length, greaterThanOrEqualTo(30));
    });

    test('barcha kategoriyalar qamrab olingan', () {
      final products = SeedData.products();
      final categories = products.map((p) => p.category).toSet();
      for (final category in AppCategories.all) {
        expect(categories.contains(category.name), isTrue,
            reason: '${category.name} kategoriyasida mahsulot yo\'q');
      }
    });

    test('har bir mahsulotda rasm va narx bor', () {
      for (final p in SeedData.products()) {
        expect(p.image.startsWith('assets/products/'), isTrue,
            reason: p.name);
        expect(p.price, greaterThan(0), reason: p.name);
        expect(p.oldPrice, greaterThanOrEqualTo(p.price), reason: p.name);
        expect(p.rating, inInclusiveRange(0, 5), reason: p.name);
      }
    });

    test('mahsulot id lari takrorlanmaydi', () {
      final products = SeedData.products();
      final ids = products.map((p) => p.id).toSet();
      expect(ids.length, products.length);
    });
  });

  group('Qidiruv', () {
    test('nom bo\'yicha qidiradi', () {
      final products = SeedData.products();
      final result = searchProducts(products, 'telefon');
      expect(result, isNotEmpty);
      expect(result.every((p) =>
          p.name.toLowerCase().contains('telefon') ||
          p.category.toLowerCase().contains('telefon') ||
          p.description.toLowerCase().contains('telefon')), isTrue);
    });

    test('kategoriya bo\'yicha qidiradi', () {
      final products = SeedData.products();
      final result = searchProducts(products, 'sport');
      expect(result, isNotEmpty);
    });

    test('bo\'sh so\'rov barchasini qaytaradi', () {
      final products = SeedData.products();
      expect(searchProducts(products, '').length, products.length);
    });
  });
}
