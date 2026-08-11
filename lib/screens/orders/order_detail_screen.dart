import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../models/order.dart';
import '../../providers/app_providers.dart';
import '../../services/snackbar_service.dart';
import '../../widgets/order_status_chip.dart';

/// Buyurtma tafsilotlari sahifasi.
class OrderDetailScreen extends ConsumerWidget {
  final String orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(ordersProvider).where((o) => o.id == orderId).firstOrNull;
    if (order == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Buyurtma topilmadi')),
        body: const Center(child: Text('Bu buyurtma mavjud emas')),
      );
    }
    return _OrderDetailBody(order: order);
  }
}

class _OrderDetailBody extends ConsumerWidget {
  final Order order;

  const _OrderDetailBody({required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final notifier = ref.read(ordersProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('Buyurtma ${order.id}'),
        actions: [
          if (order.status == 'Qabul qilindi')
            IconButton(
              tooltip: 'Bekor qilish',
              onPressed: () => _confirmCancel(context, notifier),
              icon: const Icon(Icons.cancel_outlined, color: AppColors.danger),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ---------- Holat karta ----------
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF12241C) : Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.receipt_long_rounded,
                        color: AppColors.primary, size: 22),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Buyurtma raqami: ${order.id}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : AppColors.textDark,
                        ),
                      ),
                    ),
                    OrderStatusChip(status: order.status),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Sana: ${Formatters.dateTime(order.createdAt)}',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.white54 : AppColors.textGrey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'To\'lov: ${order.paymentMethod}',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.white54 : AppColors.textGrey,
                  ),
                ),
                const SizedBox(height: 14),
                // ---------- Holat bosqichlari ----------
                _StatusTimeline(order: order, isDark: isDark),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // ---------- Yetkazib berish ----------
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF12241C) : Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Qabul qiluvchi',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 10),
                _infoRow(Icons.person_outline_rounded, order.customerName, isDark),
                _infoRow(Icons.phone_outlined, order.phone, isDark),
                _infoRow(Icons.location_on_outlined, order.address, isDark),
                if (order.comment.isNotEmpty)
                  _infoRow(Icons.edit_note_rounded, order.comment, isDark),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // ---------- Mahsulotlar ----------
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF12241C) : Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mahsulotlar (${order.itemCount})',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 12),
                for (final item in order.items) ...[
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          item.image,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 48,
                            height: 48,
                            color: isDark
                                ? const Color(0xFF1B3328)
                                : const Color(0xFFEDF2EF),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : AppColors.textDark,
                              ),
                            ),
                            Text(
                              '${item.quantity} × ${Formatters.money(item.price)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? Colors.white54 : AppColors.textGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        Formatters.money(item.total),
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(),
                  ),
                ],
                _sumRow('Mahsulotlar jami', Formatters.money(order.productsTotal), isDark),
                if (order.discount > 0)
                  _sumRow('Chegirma', '-${Formatters.money(order.discount)}', isDark,
                      valueColor: AppColors.success),
                _sumRow(
                  'Yetkazib berish',
                  order.deliveryFee == 0 ? 'Bepul' : Formatters.money(order.deliveryFee),
                  isDark,
                ),
                const Divider(height: 20),
                Row(
                  children: [
                    Text(
                      'Jami',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : AppColors.textDark,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      Formatters.money(order.total),
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // ---------- Demo holat boshqaruvi ----------
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Row(
                  children: [
                    Icon(Icons.info_outline_rounded,
                        color: AppColors.primary, size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Bu demo ilova — holatlar avtomatik o\'zgarmaydi. '
                        'Quyidagi tugma orqali holatni qo\'lda ko\'chirishingiz mumkin.',
                        style: TextStyle(fontSize: 12.5, color: AppColors.textDark),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (order.status != 'Bekor qilindi' &&
                    order.status != 'Yetkazib berildi') ...[
                  OutlinedButton.icon(
                    onPressed: () {
                      notifier.advanceStatus(order.id);
                      SnackbarService.success('Holat yangilandi');
                    },
                    icon: const Icon(Icons.double_arrow_rounded, size: 18),
                    label: const Text('Demo: holatni yangilash'),
                  ),
                  const SizedBox(height: 8),
                ],
                if (order.status == 'Qabul qilindi')
                  TextButton.icon(
                    onPressed: () => _confirmCancel(context, notifier),
                    icon: const Icon(Icons.cancel_outlined, size: 18,
                        color: AppColors.danger),
                    label: const Text('Buyurtmani bekor qilish',
                        style: TextStyle(color: AppColors.danger)),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13.5,
                color: isDark ? Colors.white70 : const Color(0xFF3D4F46),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sumRow(String label, String value, bool isDark, {Color? valueColor}) {
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

  void _confirmCancel(BuildContext context, OrdersNotifier notifier) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Buyurtmani bekor qilish'),
        content: const Text('Buyurtma "Bekor qilindi" holatiga o\'tkaziladi. Davom etasizmi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Yopish'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.danger,
              minimumSize: const Size(0, 44),
            ),
            onPressed: () {
              notifier.cancelOrder(order.id);
              Navigator.of(ctx).pop();
              SnackbarService.show('Buyurtma bekor qilindi');
            },
            child: const Text('Bekor qilish'),
          ),
        ],
      ),
    );
  }
}

/// Holat bosqichlari (time line).
class _StatusTimeline extends StatelessWidget {
  final Order order;
  final bool isDark;

  const _StatusTimeline({required this.order, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final isCancelled = order.status == AppConstants.orderStatusCancelled;

    if (isCancelled) {
      return Row(
        children: [
          const Icon(Icons.cancel_rounded, color: AppColors.danger, size: 20),
          const SizedBox(width: 10),
          Text(
            'Buyurtma bekor qilindi',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : AppColors.textDark,
            ),
          ),
        ],
      );
    }

    final currentIndex = AppConstants.orderStatuses.indexOf(order.status);
    final activeIndex = currentIndex < 0 ? 0 : currentIndex;

    return Column(
      children: List.generate(AppConstants.orderStatuses.length, (index) {
        final active = index <= activeIndex;
        final isLast = index == AppConstants.orderStatuses.length - 1;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: active ? AppColors.primary : Colors.transparent,
                    border: Border.all(
                      color: active ? AppColors.primary : AppColors.textGrey,
                      width: 2,
                    ),
                  ),
                  child: active
                      ? const Icon(Icons.check_rounded,
                          size: 14, color: Colors.white)
                      : null,
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 24,
                    color: active && index < activeIndex
                        ? AppColors.primary
                        : (isDark ? Colors.white12 : const Color(0xFFDDE7E1)),
                  ),
              ],
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  AppConstants.orderStatuses[index],
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight:
                        index == activeIndex ? FontWeight.w800 : FontWeight.w500,
                    color: index == activeIndex
                        ? AppColors.primary
                        : (active
                            ? (isDark ? Colors.white : AppColors.textDark)
                            : (isDark ? Colors.white38 : AppColors.textGrey)),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
