import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../models/product.dart';
import '../../providers/app_providers.dart';
import '../../routes/app_routes.dart';
import '../../widgets/banner_carousel.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/product_card.dart';
import '../../widgets/section_header.dart';
import '../../widgets/skeleton.dart';

/// Bosh sahifa.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider);
    final cartSummary = ref.watch(cartSummaryProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: () async => ref.refresh(productsProvider.future),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const SizedBox(height: 10),
              // ---------- Sarlavha (logotip + savatcha) ----------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(13),
                        child: Image.asset(
                          'assets/brand/logo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            AppConstants.appName,
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textDark,
                            ),
                          ),
                          Text(
                            AppConstants.appTagline,
                            style: TextStyle(
                              fontSize: 11.5,
                              color: isDark ? Colors.white54 : AppColors.textGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Savatcha tugmasi
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        IconButton(
                          onPressed: () => AppRoutes.toCart(context),
                          icon: const Icon(Icons.shopping_cart_outlined, size: 25),
                          color: AppColors.textDark,
                          style: IconButton.styleFrom(
                            backgroundColor: isDark
                                ? const Color(0xFF163026)
                                : Colors.white,
                            padding: const EdgeInsets.all(10),
                          ),
                        ),
                        if (cartSummary.itemsCount > 0)
                          Positioned(
                            top: -4,
                            right: -4,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.accent,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: isDark
                                        ? const Color(0xFF0B1712)
                                        : AppColors.background,
                                    width: 2),
                              ),
                              child: Text(
                                cartSummary.itemsCount > AppConstants.maxBadgeCount
                                    ? '99+'
                                    : '${cartSummary.itemsCount}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              // ---------- Qidiruv oynasi ----------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GestureDetector(
                  onTap: () => AppRoutes.toSearch(context),
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF163026) : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isDark ? Colors.white12 : const Color(0xFFE3EAE6),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search_rounded,
                            color: AppColors.textGrey, size: 22),
                        const SizedBox(width: 10),
                        Text(
                          'Mahsulot qidirish...',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? Colors.white38 : AppColors.textGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // ---------- Kategoriyalar ----------
              SizedBox(
                height: 38,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: AppCategories.all.length,
                  separatorBuilder: (__, ___) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final category = AppCategories.all[index];
                    return CategoryChip(
                      name: category.name,
                      icon: category.icon,
                      onTap: () => AppRoutes.toCategory(context, category.name),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              // ---------- Bannerlar ----------
              const BannerCarousel(),
              const SizedBox(height: 18),
              // ---------- Bo'limlar ----------
              productsAsync.when(
                loading: () => const Column(
                  children: [
                    SectionHeader(title: 'Mashhur mahsulotlar'),
                    SkeletonRow(),
                    SectionHeader(title: 'Yangi mahsulotlar'),
                    SkeletonRow(),
                  ],
                ),
                error: (e, _) => Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(
                    'Ma\'lumotlarni o\'qishda xatolik: $e',
                    textAlign: TextAlign.center,
                  ),
                ),
                data: (products) {
                  if (products.isEmpty) {
                    return const SizedBox(height: 200);
                  }

                  final popular =
                      products.where((p) => p.isPopular).toList();
                  final fresh = products.where((p) => p.isNew).toList();
                  final discounted =
                      products.where((p) => p.hasDiscount).toList();
                  final recommended = [...products]
                    ..sort((a, b) => b.rating.compareTo(a.rating));

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (popular.isNotEmpty) ...[
                        SectionHeader(
                          title: 'Mashhur mahsulotlar',
                          onSeeAll: () => AppRoutes.toCategory(context, ''),
                        ),
                        _ProductRow(products: popular),
                      ],
                      if (fresh.isNotEmpty) ...[
                        const SizedBox(height: 18),
                        SectionHeader(
                          title: 'Yangi mahsulotlar',
                          onSeeAll: () => AppRoutes.toCategory(context, ''),
                        ),
                        _ProductRow(products: fresh),
                      ],
                      if (discounted.isNotEmpty) ...[
                        const SizedBox(height: 18),
                        SectionHeader(
                          title: 'Chegirmadagi mahsulotlar',
                          onSeeAll: () => AppRoutes.toCategory(context, ''),
                        ),
                        _ProductRow(products: discounted),
                      ],
                      if (recommended.isNotEmpty) ...[
                        const SizedBox(height: 18),
                        SectionHeader(
                          title: 'Sizga tavsiya etamiz',
                          onSeeAll: () => AppRoutes.toCategory(context, ''),
                        ),
                        _ProductRow(products: recommended),
                      ],
                      const SizedBox(height: 24),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Gorizontal mahsulotlar qatori.
class _ProductRow extends StatelessWidget {
  final List<Product> products;

  const _ProductRow({required this.products});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        separatorBuilder: (__, ___) => const SizedBox(width: 12),
        itemBuilder: (context, index) =>
            ProductCard(product: products[index]),
      ),
    );
  }
}
