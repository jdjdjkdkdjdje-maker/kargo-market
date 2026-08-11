import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../models/product.dart';
import '../../providers/app_providers.dart';
import '../../routes/app_routes.dart';
import '../../services/snackbar_service.dart';
import '../../widgets/empty_state.dart';

/// Yashirin "Mahsulotlarni boshqarish" bo'limi.
/// (Profil sahifasida versiya matnini uzoq bosib ochiladi)
class AdminPanelScreen extends ConsumerStatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  ConsumerState<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends ConsumerState<AdminPanelScreen> {
  String _query = '';
  String? _categoryFilter;

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mahsulotlarni boshqarish'),
        actions: [
          IconButton(
            tooltip: 'Yopish',
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => AppRoutes.toProductForm(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Qo\'shish'),
      ),
      body: productsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Xatolik: $e')),
        data: (products) {
          if (products.isEmpty) {
            return const EmptyState(
              icon: Icons.inventory_2_outlined,
              title: 'Mahsulotlar yo\'q',
              subtitle: 'Yangi mahsulot qo\'shish uchun tugmani bosing',
            );
          }

          // Filtrlar
          var filtered = products;
          if (_query.trim().isNotEmpty) {
            final q = _query.trim().toLowerCase();
            filtered = filtered
                .where((p) =>
                    p.name.toLowerCase().contains(q) ||
                    p.category.toLowerCase().contains(q))
                .toList();
          }
          if (_categoryFilter != null) {
            filtered =
                filtered.where((p) => p.category == _categoryFilter).toList();
          }

          final categories = products.map((p) => p.category).toSet().toList();
          final totalStock =
              products.fold<int>(0, (sum, p) => sum + p.stock);
          final discountedCount =
              products.where((p) => p.hasDiscount).length;

          return Column(
            children: [
              // ---------- Statistika ----------
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Row(
                  children: [
                    _StatCard(label: 'Jami', value: '${products.length}', icon: Icons.inventory_2_outlined),
                    const SizedBox(width: 8),
                    _StatCard(label: 'Omborda', value: '$totalStock', icon: Icons.warehouse_outlined),
                    const SizedBox(width: 8),
                    _StatCard(label: 'Chegirma', value: '$discountedCount', icon: Icons.percent_rounded),
                  ],
                ),
              ),
              // ---------- Qidiruv va filtr ----------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: TextField(
                          onChanged: (v) => setState(() => _query = v),
                          decoration: const InputDecoration(
                            hintText: 'Mahsulot qidirish...',
                            prefixIcon: Icon(Icons.search_rounded, size: 20),
                            contentPadding: EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    PopupMenuButton<String?>(
                      tooltip: 'Kategoriya filtri',
                      initialValue: _categoryFilter,
                      onSelected: (v) => setState(() => _categoryFilter = v),
                      itemBuilder: (ctx) => [
                        const PopupMenuItem<String?>(
                          value: null,
                          child: Text('Barcha kategoriyalar'),
                        ),
                        for (final c in categories)
                          PopupMenuItem<String?>(
                            value: c,
                            child: Text(c),
                          ),
                      ],
                      child: Container(
                        height: 44,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF163026) : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isDark ? Colors.white12 : const Color(0xFFDDE7E1),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.filter_list_rounded,
                                size: 20, color: AppColors.primary),
                            const SizedBox(width: 6),
                            Text(
                              _categoryFilter ?? 'Barchasi',
                              style: const TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // ---------- Ro'yxat ----------
              Expanded(
                child: filtered.isEmpty
                    ? const EmptyState(
                        icon: Icons.search_off_rounded,
                        title: 'Mahsulot topilmadi',
                        subtitle: 'Qidiruv so\'zini o\'zgartirib ko\'ring',
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
                        itemCount: filtered.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final product = filtered[index];
                          return _AdminProductTile(
                            product: product,
                            isDark: isDark,
                            onEdit: () => AppRoutes.toProductForm(
                                context, productId: product.id),
                            onDelete: () => _confirmDelete(product),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _confirmDelete(Product product) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Mahsulotni o\'chirish'),
        content: Text('"${product.name}" o\'chiriladi. '
            'Mahsulot savatcha va sevimlilardan ham olib tashlanadi. Davom etasizmi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Bekor qilish'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.danger,
              minimumSize: const Size(0, 44),
            ),
            onPressed: () {
              ref.read(productsProvider.notifier).deleteProduct(product.id);
              Navigator.of(ctx).pop();
              SnackbarService.show('Mahsulot o\'chirildi');
            },
            child: const Text('O\'chirish'),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF12241C) : Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? Colors.white54 : AppColors.textGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminProductTile extends StatelessWidget {
  final Product product;
  final bool isDark;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _AdminProductTile({
    required this.product,
    required this.isDark,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF12241C) : Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              product.image,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 56,
                height: 56,
                color: isDark ? const Color(0xFF1B3328) : const Color(0xFFEDF2EF),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.textDark,
                  ),
                ),
                Text(
                  '${product.category} • Omborda: ${product.stock}',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: isDark ? Colors.white54 : AppColors.textGrey,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      Formatters.money(product.price),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                    if (product.hasDiscount) ...[
                      const SizedBox(width: 6),
                      Text(
                        '-${product.discountPercent}%',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.accent,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Tahrirlash',
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined, color: AppColors.primary, size: 20),
          ),
          IconButton(
            tooltip: 'O\'chirish',
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline_rounded,
                color: AppColors.danger, size: 20),
          ),
        ],
      ),
    );
  }
}
