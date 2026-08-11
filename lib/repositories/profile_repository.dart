import '../database/local_database.dart';
import '../models/profile_data.dart';

/// Profil bilan ishlash (lokal JSON bazasi).
class ProfileRepository {
  static const String _key = 'data';

  ProfileData get() {
    return ProfileData.fromMap(LocalDatabase.profileBox.get(_key) as Map?);
  }

  Future<void> save(ProfileData profile) async {
    await LocalDatabase.profileBox.put(_key, profile.toMap());
  }
}
