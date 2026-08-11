import 'package:flutter/material.dart';

import '../models/product.dart';
import 'product_card.dart';

/// Mahsulotlar to'ri (2 ustunli grid).
class ProductGrid extends StatelessWidget {
  final List<Product> products;
  final EdgeInsetsGeometry padding;
  final bool shrinkWrap;

  const ProductGrid({
    super.key,
    required this.products,
    this.padding = const EdgeInsets.fromLTRB(16, 4, 16, 24),
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const SizedBox.shrink();
    }
    return GridView.builder(
      padding: padding,
      shrinkWrap: shrinkWrap,
      physics: shrinkWrap ? const NeverScrollableScrollPhysics() : null,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.62,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) => ProductCard(product: products[index]),
    );
  }
}
