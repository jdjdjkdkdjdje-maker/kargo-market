import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../models/cart_item.dart';
import '../../models/cart_summary.dart';
import '../../models/product.dart';
import '../../providers/app_providers.dart';
import '../../routes/app_routes.dart';
import '../../services/snackbar_service.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/quantity_stepper.dart';

/// Savatcha sahifasi.
class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final products = ref.watch(productsProvider).value ?? const <Product>[];
    final summary = ref.watch(cartSummaryProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Savatchadagi har bir mahsulotni to'liq ma'lumot bilan bog'lash.
    final rows = <(CartItem, Product)>[];
    for (final item in cartItems) {
      for (final p in products) {
        if (p.id == item.productId) {
          rows.add((item, p));
          break;
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Savatcha (${summary.itemsCount})'),
        actions: [
          if (rows.isNotEmpty)
            TextButton(
              onPressed: () => _confirmClear(context, ref),
              child: const Text(
                'Tozalash',
                style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.w700),
              ),
            ),
        ],
      ),
      body: rows.isEmpty
          ? const EmptyState(
              icon: Icons.shopping_cart_outlined,
              title: 'Savatcha bo\'sh',
              subtitle: 'Mahsulotlarni savatchaga qo\'shing va xaridni boshlang',
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: rows.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final (item, product) = rows[index];
                      return _CartItemCard(
                        item: item,
                        product: product,
                        onIncrement: () => ref
                            .read(cartProvider.notifier)
                            .increment(product.id),
                        onDecrement: () => ref
                            .read(cartProvider.notifier)
                            .decrement(product.id),
                        onRemove: () {
                          ref.read(cartProvider.notifier).remove(product.id);
                          SnackbarService.show('Mahsulot savatchadan olib tashlandi');
                        },
                      );
                    },
                  ),
                ),
                // ---------- Yakuniy hisob ----------
                _SummaryCard(summary: summary),
              ],
            ),
    );
  }

  void _confirmClear(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Savatchani tozalash'),
        content: const Text('Barcha mahsulotlar savatchadan olib tashlanadi. Davom etasizmi?'),
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
              ref.read(cartProvider.notifier).clear();
              Navigator.of(ctx).pop();
              SnackbarService.show('Savatcha tozalandi');
            },
            child: const Text('Tozalash'),
          ),
        ],
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final CartItem item;
  final Product product;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const _CartItemCard({
    required this.item,
    required this.product,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF12241C) : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => AppRoutes.toProductDetail(context, product.id),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                product.image,
                width: 84,
                height: 84,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 84,
                  height: 84,
                  color: isDark ? const Color(0xFF1B3328) : const Color(0xFFEDF2EF),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  Formatters.money(product.price),
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
                if (!product.inStock)
                  const Text(
                    'Tugagan',
                    style: TextStyle(color: AppColors.danger, fontSize: 12),
                  ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    QuantityStepper(
                      quantity: item.quantity,
                      maxQuantity: product.stock,
                      onDecrease: onDecrement,
                      onIncrease: onIncrease,
                    ),
                    const Spacer(),
                    Text(
                      Formatters.money(product.price * item.quantity),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white70 : AppColors.textGrey,
                      ),
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      onPressed: onRemove,
                      icon: const Icon(Icons.delete_outline_rounded,
                          color: AppColors.danger, size: 20),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final CartSummary summary;

  const _SummaryCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF12241C) : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.06),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _row('Mahsulotlar jami', Formatters.money(summary.productsTotal), isDark),
              _row('Chegirma', '-${Formatters.money(summary.discount)}',
                  isDark, valueColor: AppColors.success),
              _row(
                'Yetkazib berish',
                summary.deliveryFee == 0 ? 'Bepul' : Formatters.money(summary.deliveryFee),
                isDark,
                valueColor:
                    summary.deliveryFee == 0 ? AppColors.success : null,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Divider(),
              ),
              Row(
                children: [
                  Text(
                    'Yakuniy summa',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : AppColors.textDark,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    Formatters.money(summary.total),
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              if (summary.deliveryFee > 0)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    '${Formatters.money(AppConstants.freeDeliveryFrom - summary.productsTotal)} '
                    'qolgan bo\'lsa — yetkazib berish bepul',
                    style: TextStyle(
                      fontSize: 11.5,
                      color: isDark ? Colors.white54 : AppColors.textGrey,
                    ),
                  ),
                ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => AppRoutes.toCheckout(context),
                  icon: const Icon(Icons.arrow_forward_rounded, size: 20),
                  label: const Text('Buyurtma berish'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value, bool isDark,
      {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13.5,
              color: isDark ? Colors.white70 : AppColors.textGrey,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: valueColor ?? (isDark ? Colors.white : AppColors.textDark),
            ),
          ),
        ],
      ),
    );
  }
}
