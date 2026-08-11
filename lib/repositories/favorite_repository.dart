import '../database/local_database.dart';

/// Sevimlilar bilan ishlash (lokal JSON bazasi).
class FavoriteRepository {
  static const String _key = 'ids';

  List<String> getAll() {
    final raw = LocalDatabase.favoritesBox.get(_key);
    if (raw == null) return [];
    return (raw as List).cast<String>();
  }

  Future<void> saveAll(List<String> ids) async {
    await LocalDatabase.favoritesBox.put(_key, ids);
  }
}
