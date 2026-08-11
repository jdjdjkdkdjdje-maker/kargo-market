/// Lokal profil ma'lumotlari (login serveri yo'q — hammasi telefonda).
class ProfileData {
  final String name;
  final String phone;
  final String address;

  const ProfileData({
    this.name = '',
    this.phone = '',
    this.address = '',
  });

  bool get isEmpty => name.isEmpty && phone.isEmpty && address.isEmpty;

  ProfileData copyWith({String? name, String? phone, String? address}) {
    return ProfileData(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'phone': phone,
        'address': address,
      };

  factory ProfileData.fromMap(Map<dynamic, dynamic>? map) => ProfileData(
        name: map?['name'] as String? ?? '',
        phone: map?['phone'] as String? ?? '',
        address: map?['address'] as String? ?? '',
      );
}
