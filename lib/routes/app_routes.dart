import 'package:flutter/material.dart';

import '../core/utils/transitions.dart';
import '../screens/admin/admin_panel_screen.dart';
import '../screens/admin/product_form_screen.dart';
import '../screens/cart/cart_screen.dart';
import '../screens/categories/categories_screen.dart';
import '../screens/category_products/category_products_screen.dart';
import '../screens/checkout/checkout_screen.dart';
import '../screens/favorites/favorites_screen.dart';
import '../screens/help/help_screen.dart';
import '../screens/orders/order_detail_screen.dart';
import '../screens/product/product_detail_screen.dart';
import '../screens/profile/edit_profile_screen.dart';
import '../screens/search/search_screen.dart';
import '../screens/settings/settings_screen.dart';

/// Sahifalar orasidagi navigatsiya yordamchisi.
/// Har bir o'tish yengil animatsiya bilan amalga oshiriladi.
class AppRoutes {
  AppRoutes._();

  static void push(BuildContext context, Widget page) {
    Navigator.of(context).push(AppTransitions.slide(page));
  }

  static void pushBottom(BuildContext context, Widget page) {
    Navigator.of(context).push(AppTransitions.bottomSheet(page));
  }

  static void replace(BuildContext context, Widget page) {
    Navigator.of(context).pushReplacement(AppTransitions.slide(page));
  }

  static void toProductDetail(BuildContext context, String productId) {
    push(context, ProductDetailScreen(productId: productId));
  }

  static void toCategory(BuildContext context, String category) {
    push(context, CategoryProductsScreen(category: category));
  }

  static void toSearch(BuildContext context) {
    push(context, const SearchScreen());
  }

  static void toCategories(BuildContext context) {
    push(context, const CategoriesScreen());
  }

  static void toCart(BuildContext context) {
    push(context, const CartScreen());
  }

  static void toCheckout(BuildContext context) {
    pushBottom(context, const CheckoutScreen());
  }

  static void toOrderDetail(BuildContext context, String orderId) {
    push(context, OrderDetailScreen(orderId: orderId));
  }

  static void toFavorites(BuildContext context) {
    push(context, const FavoritesScreen());
  }

  static void toEditProfile(BuildContext context) {
    push(context, const EditProfileScreen());
  }

  static void toSettings(BuildContext context) {
    push(context, const SettingsScreen());
  }

  static void toHelp(BuildContext context) {
    push(context, const HelpScreen());
  }

  static void toAdminPanel(BuildContext context) {
    push(context, const AdminPanelScreen());
  }

  static void toProductForm(BuildContext context, {String? productId}) {
    push(context, ProductFormScreen(productId: productId));
  }
}
