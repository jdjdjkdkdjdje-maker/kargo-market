import '../database/hive_database.dart';
import '../repositories/product_repository.dart';
import 'seed_data.dart';

/// Birinchi ochilishda demo mahsulotlarni yaratish.
class SeedService {
  SeedService._();

  static const String _seededKey = 'seeded_v1';

  static Future<void> ensureSeeded() async {
    final settings = HiveDatabase.settingsBox;
    final alreadySeeded = settings.get(_seededKey) as bool? ?? false;
    if (alreadySeeded) return;

    final repo = ProductRepository();
    repo.replaceAll(SeedData.products());

    await settings.put(_seededKey, true);
  }

  /// Demo ma'lumotlarni qayta tiklash (sozlamalar va profil saqlanadi).
  static Future<void> resetDemoData() async {
    final repo = ProductRepository();
    repo.replaceAll(SeedData.products());

    await HiveDatabase.cartBox.clear();
    await HiveDatabase.ordersBox.clear();
    await HiveDatabase.favoritesBox.clear();
    await HiveDatabase.settingsBox.put(_seededKey, true);
  }
}
