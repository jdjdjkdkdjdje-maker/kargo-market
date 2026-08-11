import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/app_constants.dart';
import '../core/theme/app_theme.dart';
import '../providers/app_providers.dart';
import '../services/snackbar_service.dart';
import 'cart/cart_screen.dart';
import 'categories/categories_screen.dart';
import 'home/home_screen.dart';
import 'orders/orders_screen.dart';
import 'profile/profile_screen.dart';

/// Asosiy oyna — pastki navigatsiya paneli bilan.
class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  static const _screens = [
    HomeScreen(),
    CategoriesScreen(),
    CartScreen(),
    OrdersScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Birinchi ochilishda oflayn rejim haqida bildirishnoma.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final settings = ref.read(settingsProvider);
      if (!settings.offlineNoticeShown) {
        ref.read(settingsProvider.notifier).markOfflineNoticeShown();
        SnackbarService.show(
            'Internet kerak emas — ilova oflayn rejimda ishlamoqda');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final index = ref.watch(mainTabProvider);
    final cartSummary = ref.watch(cartSummaryProvider);
    final orders = ref.watch(ordersProvider);
    final activeOrders = orders.where((o) => o.status != 'Bekor qilindi').length;

    return Scaffold(
      body: IndexedStack(index: index, children: _screens),
      bottomNavigationBar: _BottomNav(
        currentIndex: index,
        cartCount: cartSummary.itemsCount,
        activeOrders: activeOrders,
        onTap: (i) {
          ref.read(mainTabProvider.notifier).select(i);
          // Kichik tebranish animatsiyasi
          HapticFeedback.selectionClick();
        },
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final int cartCount;
  final int activeOrders;
  final ValueChanged<int> onTap;

  const _BottomNav({
    required this.currentIndex,
    required this.cartCount,
    required this.activeOrders,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F1F18) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.06),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              _NavItem(
                icon: Icons.home_rounded,
                label: 'Bosh sahifa',
                selected: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              _NavItem(
                icon: Icons.grid_view_rounded,
                label: 'Kategoriyalar',
                selected: currentIndex == 1,
                onTap: () => onTap(1),
              ),
              _NavItem(
                icon: Icons.shopping_cart_rounded,
                label: 'Savatcha',
                selected: currentIndex == 2,
                badgeCount: cartCount,
                onTap: () => onTap(2),
              ),
              _NavItem(
                icon: Icons.receipt_long_rounded,
                label: 'Buyurtmalar',
                selected: currentIndex == 3,
                badgeCount: activeOrders > 0 ? activeOrders : null,
                onTap: () => onTap(3),
              ),
              _NavItem(
                icon: Icons.person_rounded,
                label: 'Profil',
                selected: currentIndex == 4,
                onTap: () => onTap(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final int? badgeCount;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.badgeCount,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = selected
        ? AppColors.primary
        : (isDark ? Colors.white54 : AppColors.textGrey);

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  AnimatedScale(
                    scale: selected ? 1.12 : 1.0,
                    duration: const Duration(milliseconds: 220),
                    child: Icon(icon, size: 24, color: color),
                  ),
                  if (badgeCount != null && badgeCount! > 0)
                    Positioned(
                      top: -6,
                      right: -12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isDark ? const Color(0xFF0F1F18) : Colors.white,
                            width: 1.5,
                          ),
                        ),
                        constraints: const BoxConstraints(minWidth: 16),
                        child: Text(
                          badgeCount! > AppConstants.maxBadgeCount
                              ? '99+'
                              : '$badgeCount',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
