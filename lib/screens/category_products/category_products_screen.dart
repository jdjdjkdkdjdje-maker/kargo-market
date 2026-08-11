import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../providers/app_providers.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/product_grid.dart';
import '../../widgets/skeleton.dart';

/// Kategoriya mahsulotlari sahifasi.
/// Agar [category] bo'sh bo'lsa — barcha mahsulotlar ko'rsatiladi.
class CategoryProductsScreen extends ConsumerWidget {
  final String category;

  const CategoryProductsScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final title = category.isEmpty ? 'Barcha mahsulotlar' : category;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: productsAsync.when(
        loading: () => ListView(
          padding: const EdgeInsets.all(16),
          children: List.generate(
            4,
            (_) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: const ProductCardSkeleton(),
            ),
          ),
        ),
        error: (e, _) => EmptyState(
          icon: Icons.error_outline,
          title: 'Xatolik yuz berdi',
          subtitle: e.toString(),
        ),
        data: (products) {
          final filtered = category.isEmpty
              ? products
              : products.where((p) => p.category == category).toList();

          if (filtered.isEmpty) {
            return EmptyState(
              icon: Icons.inventory_2_outlined,
              title: 'Mahsulot topilmadi',
              subtitle: 'Bu kategoriyada hozircha mahsulot yo\'q',
              buttonText: 'Bosh sahifaga qaytish',
              onButtonTap: () => Navigator.of(context).pop(),
            );
          }

          final grid = ProductGrid(products: filtered);
          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    '${filtered.length} ta mahsulot',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.white54 : AppColors.textGrey,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(child: grid),
            ],
          );
        },
      ),
    );
  }
}
