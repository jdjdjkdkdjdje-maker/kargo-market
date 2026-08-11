import 'package:flutter/material.dart';

/// Ilova nomi va umumiy doimiylar.
class AppConstants {
  AppConstants._();

  static const String appName = 'Xarid';
  static const String appTagline = 'Oson xarid — oson hayot';
  static const String appVersion = '1.0.0';

  /// Yetkazib berish narxi (so'm).
  static const int deliveryFee = 20000;

  /// Agar buyurtma summasi shu qiymatdan oshsa — yetkazib berish bepul.
  static const int freeDeliveryFrom = 300000;

  /// Savatcha badge'ida ko'rsatiladigan maksimal son.
  static const int maxBadgeCount = 99;

  /// Bosh sahifadagi bo'limlarda ko'rsatiladigan mahsulotlar soni.
  static const int homeSectionLimit = 10;

  /// Buyurtma holatlari (to'liq ro'yxat, tartibi bilan).
  static const List<String> orderStatuses = [
    'Qabul qilindi',
    'Tayyorlanmoqda',
    'Yetkazilmoqda',
    'Yetkazib berildi',
  ];

  static const String orderStatusCancelled = 'Bekor qilindi';

  /// To'lov usullari.
  static const List<String> paymentMethods = ['Naqd pul', 'Karta orqali'];
}

/// Mahsulot kategoriyalari.
class ProductCategory {
  final String name;
  final IconData icon;

  const ProductCategory(this.name, this.icon);
}

class AppCategories {
  AppCategories._();

  static const List<ProductCategory> all = [
    ProductCategory('Telefonlar', Icons.smartphone),
    ProductCategory('Kompyuterlar', Icons.computer),
    ProductCategory('Noutbuklar', Icons.laptop),
    ProductCategory('Planshetlar', Icons.tablet_mac),
    ProductCategory('Televizorlar', Icons.tv),
    ProductCategory('Quloqchinlar', Icons.headphones),
    ProductCategory('Aksessuarlar', Icons.watch),
    ProductCategory('Kiyim-kechak', Icons.checkroom),
    ProductCategory('Oyoq kiyimlar', Icons.snowshoeing),
    ProductCategory('Maishiy texnika', Icons.kitchen),
    ProductCategory('Uy uchun', Icons.chair),
    ProductCategory("Go'zallik", Icons.face_retouching_natural),
    ProductCategory('Sport', Icons.fitness_center),
    ProductCategory('Bolalar mahsulotlari', Icons.toys),
    ProductCategory('Avtomobil mahsulotlari', Icons.directions_car),
  ];

  static IconData iconFor(String category) {
    for (final c in all) {
      if (c.name == category) return c.icon;
    }
    return Icons.category_outlined;
  }
}
