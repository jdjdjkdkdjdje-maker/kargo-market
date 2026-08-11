import '../database/hive_database.dart';
import '../models/profile_data.dart';

/// Profil bilan ishlash (Hive lokal bazasi).
class ProfileRepository {
  static const String _key = 'data';

  ProfileData get() {
    return ProfileData.fromMap(HiveDatabase.profileBox.get(_key) as Map?);
  }

  void save(ProfileData profile) {
    HiveDatabase.profileBox.put(_key, profile.toMap());
  }
}
