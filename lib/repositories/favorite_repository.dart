import '../database/hive_database.dart';

/// Sevimlilar bilan ishlash (Hive lokal bazasi).
class FavoriteRepository {
  static const String _key = 'ids';

  List<String> getAll() {
    final raw = HiveDatabase.favoritesBox.get(_key);
    if (raw == null) return [];
    return (raw as List).cast<String>();
  }

  void saveAll(List<String> ids) {
    HiveDatabase.favoritesBox.put(_key, ids);
  }
}
