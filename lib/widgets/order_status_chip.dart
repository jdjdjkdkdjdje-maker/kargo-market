import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

/// Buyurtma holati belgisi (rang bilan).
class OrderStatusChip extends StatelessWidget {
  final String status;

  const OrderStatusChip({super.key, required this.status});

  Color get _color {
    switch (status) {
      case 'Qabul qilindi':
        return AppColors.info;
      case 'Tayyorlanmoqda':
        return AppColors.warning;
      case 'Yetkazilmoqda':
        return AppColors.primary;
      case 'Yetkazib berildi':
        return AppColors.success;
      case 'Bekor qilindi':
        return AppColors.danger;
      default:
        return AppColors.textGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: _color,
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
