import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_theme.dart';
import '../core/utils/formatters.dart';
import '../models/product.dart';
import '../providers/app_providers.dart';
import '../routes/app_routes.dart';
import '../services/snackbar_service.dart';
import 'rating_stars.dart';

/// Mahsulot kartasi — bosh sahifa, qidiruv, kategoriya va sevimlilarda ishlatiladi.
class ProductCard extends ConsumerStatefulWidget {
  final Product product;
  final double width;

  const ProductCard({super.key, required this.product, this.width = 170});

  @override
  ConsumerState<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends ConsumerState<ProductCard> {
  bool _isAdding = false;

  Product get product => widget.product;

  void _addToCart() {
    if (!product.inStock) return;

    setState(() => _isAdding = true);
    ref.read(cartProvider.notifier).add(product.id);

    Future.delayed(const Duration(milliseconds: 350), () {
      if (mounted) setState(() => _isAdding = false);
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
    final favorites = ref.watch(favoritesProvider);
    final isFavorite = favorites.contains(product.id);

    return GestureDetector(
      onTap: () => AppRoutes.toProductDetail(context, product.id),
      child: Container(
        width: widget.width,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF12241C) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ----- Rasm + belgilar -----
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset(
                    product.image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: isDark ? const Color(0xFF1B3328) : const Color(0xFFEDF2EF),
                      child: const Icon(Icons.image_not_supported_outlined,
                          color: AppColors.textGrey),
                    ),
                  ),
                ),
                if (product.hasDiscount)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '-${product.discountPercent}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: FavoriteButton(
                    isFavorite: isFavorite,
                    onTap: _toggleFavorite,
                  ),
                ),
                if (product.isNew)
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'YANGI',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                if (!product.inStock)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.45),
                      alignment: Alignment.center,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.65),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Tugagan',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            // ----- Ma'lumot -----
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  RatingStars(rating: product.rating),
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Formatters.money(product.price),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textDark,
                              ),
                            ),
                            if (product.hasDiscount)
                              Text(
                                Formatters.money(product.oldPrice),
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: isDark ? Colors.white38 : AppColors.textGrey,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                          ],
                        ),
                      ),
                      // Savatchaga qo'shish tugmasi
                      AnimatedScale(
                        scale: _isAdding ? 0.82 : 1.0,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOutBack,
                        child: InkWell(
                          onTap: product.inStock ? _addToCart : null,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: product.inStock
                                  ? AppColors.primary
                                  : (isDark ? const Color(0xFF1B3328) : const Color(0xFFE3E9E5)),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _isAdding ? Icons.check_rounded : Icons.shopping_cart_outlined,
                              size: 19,
                              color: product.inStock ? Colors.white : AppColors.textGrey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Yurakcha (sevimlilar) tugmasi — animatsiyali.
class FavoriteButton extends StatefulWidget {
  final bool isFavorite;
  final VoidCallback onTap;

  const FavoriteButton({super.key, required this.isFavorite, required this.onTap});

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool _pressed = false;

  @override
  void didUpdateWidget(covariant FavoriteButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isFavorite != widget.isFavorite && widget.isFavorite) {
      setState(() => _pressed = true);
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) setState(() => _pressed = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 1.35 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutBack,
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.25),
            shape: BoxShape.circle,
          ),
          child: Icon(
            widget.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            size: 18,
            color: widget.isFavorite ? const Color(0xFFFF5A79) : Colors.white,
          ),
        ),
      ),
    );
  }
}
