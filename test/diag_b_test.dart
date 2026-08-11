import 'package:flutter_test/flutter_test.dart';

// DIAGNOSTIKA B: hive + repository + seed_service (riverpod siz)
import 'package:xarid_market/database/hive_database.dart';
import 'package:xarid_market/repositories/cart_repository.dart';
import 'package:xarid_market/repositories/favorite_repository.dart';
import 'package:xarid_market/repositories/order_repository.dart';
import 'package:xarid_market/repositories/product_repository.dart';
import 'package:xarid_market/repositories/profile_repository.dart';
import 'package:xarid_market/repositories/settings_repository.dart';
import 'package:xarid_market/services/seed_service.dart';

void main() {
  test('hive va repository kompilyatsiyasi', () {
    expect(HiveDatabase.productsBoxName, isNotEmpty);
    expect(ProductRepository(), isNotNull);
    expect(CartRepository(), isNotNull);
    expect(FavoriteRepository(), isNotNull);
    expect(OrderRepository(), isNotNull);
    expect(ProfileRepository(), isNotNull);
    expect(SettingsRepository(), isNotNull);
    expect(SeedService.runtimeType, isNotNull);
  });
}
