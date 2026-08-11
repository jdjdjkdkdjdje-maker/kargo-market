import '../database/local_database.dart';
import '../models/app_settings.dart';

/// Sozlamalar bilan ishlash (lokal JSON bazasi).
class SettingsRepository {
  static const String _key = 'data';

  AppSettings get() {
    return AppSettings.fromMap(LocalDatabase.settingsBox.get(_key) as Map?);
  }

  Future<void> save(AppSettings settings) async {
    await LocalDatabase.settingsBox.put(_key, settings.toMap());
  }
}
