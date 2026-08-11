import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/app_constants.dart';
import '../models/app_settings.dart';
import '../models/cart_item.dart';
import '../models/cart_summary.dart';
import '../models/order.dart';
import '../models/order_item.dart';
import '../models/product.dart';
import '../models/profile_data.dart';
import '../repositories/cart_repository.dart';
import '../repositories/favorite_repository.dart';
import '../repositories/order_repository.dart';
import '../repositories/product_repository.dart';
import '../repositories/profile_repository.dart';
import '../repositories/settings_repository.dart';
import '../services/seed_service.dart';

// ======================= Pastki tab boshqaruvi =======================

class MainTabNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void select(int index) => state = index;
}

final mainTabProvider = NotifierProvider<MainTabNotifier, int>(MainTabNotifier.new);

// ======================= Repositories =======================

final productRepoProvider = Provider<ProductRepository>((ref) => ProductRepository());
final cartRepoProvider = Provider<CartRepository>((ref) => CartRepository());
final orderRepoProvider = Provider<OrderRepository>((ref) => OrderRepository());
final favoriteRepoProvider = Provider<FavoriteRepository>((ref) => FavoriteRepository());
final profileRepoProvider = Provider<ProfileRepository>((ref) => ProfileRepository());
final settingsRepoProvider = Provider<SettingsRepository>((ref) => SettingsRepository());

// ======================= Mahsulotlar =======================

class ProductsNotifier extends AsyncNotifier<List<Product>> {
  @override
  Future<List<Product>> build() async {
    // Skeleton loading effekti uchun kichik kechikish.
    await Future<void>.delayed(const Duration(milliseconds: 450));
    final products = ref.read(productRepoProvider).getAll();
    return products;
  }

  Future<void> addProduct(Product product) async {
    ref.read(productRepoProvider).save(product);
    final current = [...state.value ?? []];
    current.add(product);
    state = AsyncData(current);
  }

  Future<void> updateProduct(Product product) async {
    ref.read(productRepoProvider).save(product);
    final current = [...state.value ?? []];
    final index = current.indexWhere((e) => e.id == product.id);
    if (index >= 0) {
      current[index] = product;
    } else {
      current.add(product);
    }
    state = AsyncData(current);
  }

  Future<void> deleteProduct(String id) async {
    ref.read(productRepoProvider).delete(id);
    final current = [...state.value ?? []].where((e) => e.id != id).toList();
    state = AsyncData(current);

    // Savatcha va sevimlilardan ham tozalash.
    ref.read(cartProvider.notifier).removeProductFromCart(id);
    ref.read(favoritesProvider.notifier).removeIfExists(id);
  }

  Future<void> resetDemo() async {
    await SeedService.resetDemoData();
    state = const AsyncLoading();
    state = AsyncData(ref.read(productRepoProvider).getAll());
    ref.invalidate(cartProvider);
    ref.invalidate(ordersProvider);
    ref.invalidate(favoritesProvider);
  }
}

final productsProvider =
    AsyncNotifierProvider<ProductsNotifier, List<Product>>(ProductsNotifier.new);

/// Mahsulotni id bo'yicha topish.
final productByIdProvider =
    Provider.family<Product?, String>((ref, id) {
  final products = ref.watch(productsProvider).value ?? const <Product>[];
  for (final p in products) {
    if (p.id == id) return p;
  }
  return null;
});

/// Kategoriya bo'yicha mahsulotlar.
final productsByCategoryProvider =
    Provider.family<List<Product>, String>((ref, category) {
  final products = ref.watch(productsProvider).value ?? const <Product>[];
  return products.where((p) => p.category == category).toList();
});

// ======================= Savatcha =======================

class CartNotifier extends Notifier<List<CartItem>> {
  @override
  List<CartItem> build() {
    return ref.read(cartRepoProvider).getAll();
  }

  void _save(List<CartItem> items) {
    ref.read(cartRepoProvider).saveAll(items);
    state = items;
  }

  /// Mahsulotni savatchaga qo'shish. Qaytarilgan qiymat: qo'shilgan umumiy son.
  int add(String productId, {int quantity = 1}) {
    final items = [...state];
    final index = items.indexWhere((e) => e.productId == productId);
    int added;
    if (index >= 0) {
      items[index].quantity += quantity;
      added = items[index].quantity;
    } else {
      items.add(CartItem(productId: productId, quantity: quantity));
      added = quantity;
    }
    _save(items);
    return added;
  }

  void increment(String productId) {
    final items = [...state];
    final index = items.indexWhere((e) => e.productId == productId);
    if (index >= 0) {
      items[index].quantity += 1;
      _save(items);
    }
  }

  void decrement(String productId) {
    final items = [...state];
    final index = items.indexWhere((e) => e.productId == productId);
    if (index < 0) return;
    if (items[index].quantity <= 1) {
      items.removeAt(index);
    } else {
      items[index].quantity -= 1;
    }
    _save(items);
  }

  void remove(String productId) {
    final items = [...state].where((e) => e.productId != productId).toList();
    _save(items);
  }

  void removeProductFromCart(String productId) {
    remove(productId);
  }

  void clear() {
    _save([]);
  }
}

final cartProvider = NotifierProvider<CartNotifier, List<CartItem>>(CartNotifier.new);

class CartSummaryNotifier extends Notifier<CartSummary> {
  @override
  CartSummary build() {
    final items = ref.watch(cartProvider);
    final products = ref.watch(productsProvider).value ?? const <Product>[];

    var itemsCount = 0;
    var productsTotal = 0;
    var discount = 0;

    for (final item in items) {
      Product? product;
      for (final p in products) {
        if (p.id == item.productId) {
          product = p;
          break;
        }
      }
      if (product == null) continue;
      itemsCount += item.quantity;
      productsTotal += product.price * item.quantity;
      discount += (product.oldPrice - product.price) * item.quantity;
    }

    if (discount < 0) discount = 0;

    final deliveryFee =
        (productsTotal >= AppConstants.freeDeliveryFrom || productsTotal == 0)
            ? 0
            : AppConstants.deliveryFee;

    return CartSummary(
      itemsCount: itemsCount,
      productsTotal: productsTotal,
      discount: discount,
      deliveryFee: deliveryFee,
      total: productsTotal - discount + deliveryFee,
    );
  }
}

final cartSummaryProvider =
    NotifierProvider<CartSummaryNotifier, CartSummary>(CartSummaryNotifier.new);

// ======================= Sevimlilar =======================

class FavoritesNotifier extends Notifier<List<String>> {
  @override
  List<String> build() {
    return ref.read(favoriteRepoProvider).getAll();
  }

  bool isFavorite(String productId) => state.contains(productId);

  /// Qaytarilgan qiymat: endi sevimlimi (true) yoki olib tashlandimi (false).
  bool toggle(String productId) {
    final items = [...state];
    if (items.contains(productId)) {
      items.remove(productId);
    } else {
      items.add(productId);
    }
    ref.read(favoriteRepoProvider).saveAll(items);
    state = items;
    return items.contains(productId);
  }

  void removeIfExists(String productId) {
    if (state.contains(productId)) {
      toggle(productId);
    }
  }
}

final favoritesProvider =
    NotifierProvider<FavoritesNotifier, List<String>>(FavoritesNotifier.new);

// ======================= Buyurtmalar =======================

class OrdersNotifier extends Notifier<List<Order>> {
  @override
  List<Order> build() {
    return ref.read(orderRepoProvider).getAll();
  }

  /// Yangi buyurtma yaratish va saqlash.
  Future<Order> placeOrder({
    required List<CartItem> cartItems,
    required String name,
    required String phone,
    required String address,
    required String comment,
    required String paymentMethod,
  }) async {
    final products = ref.read(productRepoProvider).getAll();
    final items = <OrderItem>[];

    for (final item in cartItems) {
      Product? product;
      for (final p in products) {
        if (p.id == item.productId) {
          product = p;
          break;
        }
      }
      if (product == null) continue;
      items.add(OrderItem(
        productId: product.id,
        name: product.name,
        image: product.image,
        price: product.price,
        oldPrice: product.oldPrice,
        quantity: item.quantity,
      ));
    }

    var productsTotal = 0;
    var discount = 0;
    for (final item in items) {
      productsTotal += item.total;
      discount += (item.oldPrice - item.price) * item.quantity;
    }
    if (discount < 0) discount = 0;

    final deliveryFee = (productsTotal >= AppConstants.freeDeliveryFrom || productsTotal == 0)
        ? 0
        : AppConstants.deliveryFee;

    final now = DateTime.now();
    final orders = [...state];
    final seq = (orders.length + 1) % 1000;
    final id = 'X-${now.year.toString().substring(2)}'
        '${now.month.toString().padLeft(2, '0')}'
        '${now.day.toString().padLeft(2, '0')}-'
        '${seq.toString().padLeft(3, '0')}';

    final order = Order(
      id: id,
      createdAt: now,
      items: items,
      productsTotal: productsTotal,
      discount: discount,
      deliveryFee: deliveryFee,
      total: productsTotal - discount + deliveryFee,
      customerName: name,
      phone: phone,
      address: address,
      comment: comment,
      paymentMethod: paymentMethod,
      status: 'Qabul qilindi',
      statusUpdatedAt: now,
    );

    orders.insert(0, order);
    ref.read(orderRepoProvider).saveAll(orders);
    state = orders;

    // Buyurtma qilingan mahsulotlar omboridan sonini kamaytirish.
    final productRepo = ref.read(productRepoProvider);
    for (final item in items) {
      final p = productRepo.getById(item.productId);
      if (p != null && p.stock >= item.quantity) {
        productRepo.save(p.copyWith(stock: p.stock - item.quantity));
      }
    }
    ref.invalidate(productsProvider);

    return order;
  }

  void updateStatus(String orderId, String newStatus) {
    final orders = [...state];
    final index = orders.indexWhere((e) => e.id == orderId);
    if (index < 0) return;
    orders[index].status = newStatus;
    orders[index].statusUpdatedAt = DateTime.now();
    ref.read(orderRepoProvider).saveAll(orders);
    state = orders;
  }

  /// Demo uchun: keyingi holatga o'tkazish.
  void advanceStatus(String orderId) {
    final order = state.where((e) => e.id == orderId).firstOrNull;
    if (order == null) return;
    final currentIndex = AppConstants.orderStatuses.indexOf(order.status);
    if (currentIndex < 0 || currentIndex >= AppConstants.orderStatuses.length - 1) return;
    updateStatus(orderId, AppConstants.orderStatuses[currentIndex + 1]);
  }

  void cancelOrder(String orderId) {
    updateStatus(orderId, AppConstants.orderStatusCancelled);
  }
}

final ordersProvider =
    NotifierProvider<OrdersNotifier, List<Order>>(OrdersNotifier.new);

// ======================= Profil =======================

class ProfileNotifier extends Notifier<ProfileData> {
  @override
  ProfileData build() {
    return ref.read(profileRepoProvider).get();
  }

  void save(ProfileData profile) {
    ref.read(profileRepoProvider).save(profile);
    state = profile;
  }
}

final profileProvider = NotifierProvider<ProfileNotifier, ProfileData>(ProfileNotifier.new);

// ======================= Sozlamalar =======================

class SettingsNotifier extends Notifier<AppSettings> {
  @override
  AppSettings build() {
    return ref.read(settingsRepoProvider).get();
  }

  void setThemeMode(ThemeMode mode) {
    final settings = state.copyWith(themeMode: mode);
    ref.read(settingsRepoProvider).save(settings);
    state = settings;
  }

  void markOfflineNoticeShown() {
    final settings = state.copyWith(offlineNoticeShown: true);
    ref.read(settingsRepoProvider).save(settings);
    state = settings;
  }
}

final settingsProvider =
    NotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);

// ======================= Qidiruv =======================
// Qidiruv funksiyasi alohida faylda: lib/core/utils/search.dart
