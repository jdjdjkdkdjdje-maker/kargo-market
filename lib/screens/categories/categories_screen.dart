import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/app_providers.dart';
import '../../routes/app_routes.dart';

/// Kategoriyalar bo'limi.
class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsProvider).value ?? const [];

    int countOf(String category) =>
        products.where((p) => p.category == category).length;

    return Scaffold(
      appBar: AppBar(title: const Text('Kategoriyalar')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: AppCategories.all.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final category = AppCategories.all[index];
          final count = countOf(category.name);
          return _CategoryTile(
            category: category,
            count: count,
            onTap: () => AppRoutes.toCategory(context, category.name),
          );
        },
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final ProductCategory category;
  final int count;
  final VoidCallback onTap;

  const _CategoryTile({
    required this.category,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: isDark ? const Color(0xFF12241C) : Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(category.icon, color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  category.name,
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.textDark,
                  ),
                ),
              ),
              Text(
                '$count',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.white38 : AppColors.textGrey,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right_rounded,
                color: isDark ? Colors.white38 : AppColors.textGrey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
