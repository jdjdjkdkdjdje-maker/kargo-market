import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

/// Reyting yulduzlari (5 yulduz + son qiymati).
class RatingStars extends StatelessWidget {
  final double rating;
  final double size;

  const RatingStars({super.key, required this.rating, this.size = 14});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          rating >= 4.5 ? Icons.star_rounded : Icons.star_half_rounded,
          color: AppColors.accent,
          size: size + 2,
        ),
        const SizedBox(width: 3),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(
            fontSize: size - 1,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : AppColors.textDark,
          ),
        ),
      ],
    );
  }
}
