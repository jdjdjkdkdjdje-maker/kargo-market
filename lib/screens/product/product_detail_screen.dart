import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../models/product.dart';
import '../../providers/app_providers.dart';
import '../../services/snackbar_service.dart';
import '../../widgets/quantity_stepper.dart';
import '../../widgets/rating_stars.dart';

/// Mahsulot tafsilotlari sahifasi.
class ProductDetailScreen extends ConsumerWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = ref.watch(productByIdProvider(productId));
    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Mahsulot topilmadi')),
        body: const Center(child: Text('Bu mahsulot o\'chirilgan yoki mavjud emas')),
      );
    }
    return _ProductDetailBody(product: product);
  }
}

class _ProductDetailBody extends ConsumerStatefulWidget {
  final Product product;

  const _ProductDetailBody({required this.product});

  @override
  ConsumerState<_ProductDetailBody> createState() => _ProductDetailBodyState();
}

class _ProductDetailBodyState extends ConsumerState<_ProductDetailBody> {
  int _quantity = 1;
  bool _adding = false;

  Product get product => widget.product;

  void _addToCart() {
    if (!product.inStock) return;
    final qty = _quantity.clamp(1, product.stock);
    ref.read(cartProvider.notifier).add(product.id, quantity: qty);
    setState(() => _adding = true);
    Future.delayed(const Duration(milliseconds: 450), () {
      if (mounted) setState(() => _adding = false);
    });
    SnackbarService.success('Mahsulot savatchaga qo\'shildi');
  }

  void _toggleFavorite() {
    final isFav = ref.read(favoritesProvider.notifier).toggle(product.id);
    SnackbarService.show(
      isFav
          ? 'Mahsulot sevimlilarga qo\'shildi'
          : 'Mahsulot sevimlilardan olib tashlandi',
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isFavorite = ref.watch(favoritesProvider).contains(product.id);
    final cartItems = ref.watch(cartProvider);
    final inCartQty = cartItems
        .where((e) => e.productId == product.id)
        .fold<int>(0, (sum, e) => sum + e.quantity);

    final lineTotal = product.price * _quantity;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mahsulot'),
        actions: [
          IconButton(
            onPressed: _toggleFavorite,
            icon: Icon(
              isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: isFavorite ? const Color(0xFFFF5A79) : null,
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // ---------- Katta rasm ----------
          AspectRatio(
            aspectRatio: 1.15,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  product.image,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: isDark ? const Color(0xFF1B3328) : const Color(0xFFEDF2EF),
                    child: const Icon(Icons.image_not_supported_outlined,
                        color: AppColors.textGrey, size: 56),
                  ),
                ),
                if (product.hasDiscount)
                  Positioned(
                    top: 12,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Chegirma -${product.discountPercent}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // ---------- Ma'lumot ----------
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : AppColors.textDark,
                        ),
                      ),
                    ),
                    RatingStars(rating: product.rating, size: 15),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  product.category,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.white54 : AppColors.textGrey,
                  ),
                ),
                const SizedBox(height: 14),
                // ---------- Narx bloki ----------
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF163026) : AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Formatters.money(product.price),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textDark,
                              ),
                            ),
                            if (product.hasDiscount)
                              Text(
                                '${Formatters.money(product.oldPrice)}  (-${product.discountPercent}%)',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isDark ? Colors.white54 : AppColors.textGrey,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                          ],
                        ),
                      ),
                      _StockBadge(inStock: product.inStock, stock: product.stock),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                // ---------- Xususiyatlar ----------
                if (product.features.isNotEmpty) ...[
                  Text(
                    'Mahsulot xususiyatlari',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...product.features.map(
                    (f) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.check_circle_rounded,
                              size: 18, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              f,
                              style: TextStyle(
                                fontSize: 13.5,
                                color: isDark ? Colors.white70 : const Color(0xFF3D4F46),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                // ---------- Tavsif ----------
                Text(
                  'Tavsif',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  product.description,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: isDark ? Colors.white70 : const Color(0xFF3D4F46),
                  ),
                ),
                const SizedBox(height: 20),
                // ---------- Miqdor ----------
                Row(
                  children: [
                    Text(
                      'Miqdor:',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : AppColors.textDark,
                      ),
                    ),
                    const SizedBox(width: 14),
                    QuantityStepper(
                      quantity: _quantity,
                      maxQuantity: product.stock,
                      onDecrease: () => setState(
                          () => _quantity = (_quantity - 1).clamp(1, product.stock).toInt()),
                      onIncrease: () => setState(
                          () => _quantity = (_quantity + 1).clamp(1, product.stock).toInt()),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
      // ---------- Pastki qator ----------
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F1F18) : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.05),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Jami:',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? Colors.white54 : AppColors.textGrey,
                      ),
                    ),
                    Text(
                      Formatters.money(lineTotal),
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: AnimatedScale(
                  scale: _adding ? 0.96 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: FilledButton.icon(
                    onPressed: product.inStock ? _addToCart : null,
                    icon: Icon(
                      _adding ? Icons.check_rounded : Icons.add_shopping_cart_rounded,
                      size: 20,
                    ),
                    label: Text(
                      _adding
                          ? 'Qo\'shildi!'
                          : (product.inStock
                              ? (inCartQty > 0
                                  ? 'Savatchaga qo\'shish (+$inCartQty)'
                                  : 'Savatchaga qo\'shish')
                              : 'Tugagan'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StockBadge extends StatelessWidget {
  final bool inStock;
  final int stock;

  const _StockBadge({required this.inStock, required this.stock});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: inStock ? AppColors.success : AppColors.danger,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        inStock ? 'Mavjud ($stock dona)' : 'Tugagan',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
