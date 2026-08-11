import '../database/local_database.dart';
import '../repositories/product_repository.dart';
import 'seed_data.dart';

/// Birinchi ochilishda demo mahsulotlarni yaratish.
class SeedService {
  SeedService._();

  static const String _seededKey = 'seeded_v1';

  static Future<void> ensureSeeded() async {
    final settings = LocalDatabase.settingsBox;
    final alreadySeeded = settings.get(_seededKey) as bool? ?? false;
    if (alreadySeeded) return;

    final repo = ProductRepository();
    await repo.replaceAll(SeedData.products());

    await settings.put(_seededKey, true);
  }

  /// Demo ma'lumotlarni qayta tiklash (sozlamalar va profil saqlanadi).
  static Future<void> resetDemoData() async {
    final repo = ProductRepository();
    await repo.replaceAll(SeedData.products());

    await LocalDatabase.cartBox.clear();
    await LocalDatabase.ordersBox.clear();
    await LocalDatabase.favoritesBox.clear();
    await LocalDatabase.settingsBox.put(_seededKey, true);
  }
}
