import '../database/hive_database.dart';
import '../models/app_settings.dart';

/// Sozlamalar bilan ishlash (Hive lokal bazasi).
class SettingsRepository {
  static const String _key = 'data';

  AppSettings get() {
    return AppSettings.fromMap(HiveDatabase.settingsBox.get(_key) as Map?);
  }

  void save(AppSettings settings) {
    HiveDatabase.settingsBox.put(_key, settings.toMap());
  }
}
