import 'package:hive_flutter/hive_flutter.dart';

/// Hive orqali lokal ma'lumotlar bazasi.
///
/// Server yo'q — barcha ma'lumotlar telefonning ichki xotirasida saqlanadi
/// va ilova yopilganda ham, telefon qayta ishga tushirilganda ham yo'qolmaydi.
class HiveDatabase {
  HiveDatabase._();

  static const String productsBoxName = 'xarid_products';
  static const String cartBoxName = 'xarid_cart';
  static const String ordersBoxName = 'xarid_orders';
  static const String favoritesBoxName = 'xarid_favorites';
  static const String profileBoxName = 'xarid_profile';
  static const String settingsBoxName = 'xarid_settings';

  static late Box productsBox;
  static late Box cartBox;
  static late Box ordersBox;
  static late Box favoritesBox;
  static late Box profileBox;
  static late Box settingsBox;

  static Future<void> init() async {
    await Hive.initFlutter();

    productsBox = await Hive.openBox(productsBoxName);
    cartBox = await Hive.openBox(cartBoxName);
    ordersBox = await Hive.openBox(ordersBoxName);
    favoritesBox = await Hive.openBox(favoritesBoxName);
    profileBox = await Hive.openBox(profileBoxName);
    settingsBox = await Hive.openBox(settingsBoxName);
  }

  /// Barcha lokal ma'lumotlarni tozalash (sozlamalar saqlanadi).
  static Future<void> clearAll() async {
    await productsBox.clear();
    await cartBox.clear();
    await ordersBox.clear();
    await favoritesBox.clear();
    await profileBox.clear();
  }
}
