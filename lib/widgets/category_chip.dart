import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

/// Kategoriya tugmasi (ikona + nom).
class CategoryChip extends StatelessWidget {
  final String name;
  final IconData icon;
  final VoidCallback onTap;
  final bool selected;

  const CategoryChip({
    super.key,
    required this.name,
    required this.icon,
    required this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = selected
        ? AppColors.primary
        : (isDark ? const Color(0xFF163026) : Colors.white);
    final fg = selected
        ? Colors.white
        : (isDark ? Colors.white : AppColors.textDark);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected
                ? AppColors.primary
                : (isDark ? Colors.white12 : const Color(0xFFDDE7E1)),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: fg),
            const SizedBox(width: 6),
            Text(
              name,
              style: TextStyle(
                color: fg,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
