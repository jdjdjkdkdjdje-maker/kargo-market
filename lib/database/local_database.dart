import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Lokal ma'lumotlar bazasi — JSON fayllarga asoslangan.
///
/// Server yo'q — barcha ma'lumotlar telefonning ichki xotirasidagi
/// JSON fayllarda saqlanadi va ilova yopilganda ham, telefon qayta
/// ishga tushirilganda ham yo'qolmaydi.
class LocalDatabase {
  LocalDatabase._();

  static const String productsBoxName = 'xarid_products';
  static const String cartBoxName = 'xarid_cart';
  static const String ordersBoxName = 'xarid_orders';
  static const String favoritesBoxName = 'xarid_favorites';
  static const String profileBoxName = 'xarid_profile';
  static const String settingsBoxName = 'xarid_settings';

  static Directory? _dir;
  static final Map<String, LocalBox> _boxes = {};

  static Future<void> init() async {
    _dir = await getApplicationDocumentsDirectory();
    _boxes.clear();
  }

  static LocalBox open(String name) {
    final box = LocalBox(_dir!, name);
    _boxes[name] = box;
    return box;
  }

  static LocalBox productsBox => _boxes.putIfAbsent(productsBoxName, () => open(productsBoxName));
  static LocalBox cartBox => _boxes.putIfAbsent(cartBoxName, () => open(cartBoxName));
  static LocalBox ordersBox => _boxes.putIfAbsent(ordersBoxName, () => open(ordersBoxName));
  static LocalBox favoritesBox => _boxes.putIfAbsent(favoritesBoxName, () => open(favoritesBoxName));
  static LocalBox profileBox => _boxes.putIfAbsent(profileBoxName, () => open(profileBoxName));
  static LocalBox settingsBox => _boxes.putIfAbsent(settingsBoxName, () => open(settingsBoxName));
}

/// Bitta "quti" — bitta JSON fayl.
class LocalBox {
  final Directory dir;
  final String name;
  late final File _file;
  Map<String, dynamic> _data = {};
  bool _loaded = false;

  LocalBox(this.dir, this.name) {
    _file = File('${dir.path}/$name.json');
  }

  void _ensureLoaded() {
    if (_loaded) return;
    _loaded = true;
    try {
      if (_file.existsSync()) {
        final raw = jsonDecode(_file.readAsStringSync());
        if (raw is Map) {
          _data = raw.map((k, v) => MapEntry(k.toString(), v));
        }
      }
    } catch (_) {
      _data = {};
    }
  }

  dynamic get(String key) {
    _ensureLoaded();
    return _data[key];
  }

  Future<void> put(String key, dynamic value) async {
    _ensureLoaded();
    _data[key] = value;
    await _write();
  }

  Future<void> clear() async {
    _data = {};
    await _write();
  }

  Future<void> _write() async {
    try {
      await _file.writeAsString(jsonEncode(_data));
    } catch (_) {
      // Fayl yozishda xato bo'lsa — indamay o'tkazamiz (lokal demo).
    }
  }
}
