import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/app_providers.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/product_grid.dart';
import '../../widgets/skeleton.dart';

/// Sevimlilar bo'limi (lokal saqlanadi).
class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider);
    final favoriteIds = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Sevimlilar (${favoriteIds.length})')),
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
          final favorites = products
              .where((p) => favoriteIds.contains(p.id))
              .toList();
          if (favorites.isEmpty) {
            return const EmptyState(
              icon: Icons.favorite_border_rounded,
              title: 'Sevimlilar bo\'sh',
              subtitle: 'Mahsulotdagi yurakcha tugmasini bosib '
                  'sevimlilarga qo\'shing',
            );
          }
          return ProductGrid(products: favorites);
        },
      ),
    );
  }
}
