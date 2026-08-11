import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/validators.dart';
import '../../models/profile_data.dart';
import '../../providers/app_providers.dart';
import '../../services/snackbar_service.dart';

/// Buyurtma berish sahifasi (server yo'q — buyurtma telefonda yaratiladi).
class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _commentController = TextEditingController();
  String _paymentMethod = 'Naqd pul';
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(profileProvider);
    if (profile.name.isNotEmpty) _nameController.text = profile.name;
    if (profile.phone.isNotEmpty) _phoneController.text = profile.phone;
    if (profile.address.isNotEmpty) _addressController.text = profile.address;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_submitting) return;
    if (!_formKey.currentState!.validate()) {
      SnackbarService.error('Formani to\'g\'ri to\'ldiring');
      return;
    }

    final cartItems = ref.read(cartProvider);
    if (cartItems.isEmpty) {
      SnackbarService.error('Savatcha bo\'sh');
      return;
    }

    setState(() => _submitting = true);

    try {
      final order = await ref.read(ordersProvider.notifier).placeOrder(
            cartItems: cartItems,
            name: _nameController.text.trim(),
            phone: _phoneController.text.trim(),
            address: _addressController.text.trim(),
            comment: _commentController.text.trim(),
            paymentMethod: _paymentMethod,
          );

      ref.read(cartProvider.notifier).clear();

      // Profilni avtomatik saqlash (keyingi safar uchun).
      final newProfile = ProfileData(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
      );
      if (!newProfile.isEmpty) {
        ref.read(profileProvider.notifier).save(newProfile);
      }

      if (!mounted) return;
      _showSuccessDialog(order.id, order.total);
    } catch (e) {
      if (!mounted) return;
      SnackbarService.error('Buyurtma yaratishda xatolik: $e');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _showSuccessDialog(String orderId, int total) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.check_circle_rounded,
            color: AppColors.success, size: 56),
        title: const Text('Buyurtma qabul qilindi!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Buyurtma raqami: $orderId',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text('Summa: ${Formatters.money(total)}'),
            const SizedBox(height: 12),
            const Text(
              'Buyurtma telefon xotirasida saqlandi. '
              'Holatini "Buyurtmalar" bo\'limidan kuzatishingiz mumkin.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13),
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // dialog
              Navigator.of(context).pop(); // checkout sahifasi
              SnackbarService.success('Buyurtma muvaffaqiyatli yaratildi');
            },
            child: const Text('Yaxshi'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final summary = ref.watch(cartSummaryProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Buyurtma berish')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ---------- Yetkazib berish ma'lumotlari ----------
            Text(
              'Yetkazib berish',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nameController,
              validator: Validators.requiredName,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Ismingiz',
                hintText: 'Masalan: Aziz',
                prefixIcon: Icon(Icons.person_outline_rounded, size: 20),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phoneController,
              validator: Validators.requiredPhone,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Telefon raqamingiz',
                hintText: '+998 90 123 45 67',
                prefixIcon: Icon(Icons.phone_outlined, size: 20),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _addressController,
              validator: Validators.requiredAddress,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Manzil',
                hintText: 'Shahar, ko\'cha, uy raqami',
                prefixIcon: Icon(Icons.location_on_outlined, size: 20),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _commentController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Izoh (ixtiyoriy)',
                hintText: 'Qo\'shimcha ma\'lumot...',
                prefixIcon: Icon(Icons.edit_note_rounded, size: 20),
              ),
            ),
            const SizedBox(height: 22),
            // ---------- To'lov usuli ----------
            Text(
              'To\'lov usuli',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            _PaymentOption(
              icon: Icons.payments_rounded,
              title: 'Naqd pul',
              subtitle: 'Buyurtmani qabul qilganda to\'laysiz',
              selected: _paymentMethod == 'Naqd pul',
              onTap: () => setState(() => _paymentMethod = 'Naqd pul'),
            ),
            const SizedBox(height: 10),
            _PaymentOption(
              icon: Icons.credit_card_rounded,
              title: 'Karta orqali',
              subtitle: 'Karta ma\'lumotlari buyurtma vaqtida kiritiladi',
              selected: _paymentMethod == 'Karta orqali',
              onTap: () => setState(() => _paymentMethod = 'Karta orqali'),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline_rounded,
                      color: AppColors.primary, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Bu demo ilova — to\'lov amalga oshirilmaydi. '
                      'Buyurtma faqat telefonda saqlanadi.',
                      style: TextStyle(fontSize: 12.5, color: AppColors.textDark),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            // ---------- Yakuniy ----------
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF12241C) : Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _sumRow('Mahsulotlar jami', Formatters.money(summary.productsTotal), isDark),
                  _sumRow('Chegirma', '-${Formatters.money(summary.discount)}', isDark,
                      valueColor: AppColors.success),
                  _sumRow(
                    'Yetkazib berish',
                    summary.deliveryFee == 0
                        ? 'Bepul'
                        : Formatters.money(summary.deliveryFee),
                    isDark,
                  ),
                  const Divider(height: 20),
                  Row(
                    children: [
                      Text(
                        'Jami',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : AppColors.textDark,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        Formatters.money(summary.total),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 54,
              child: FilledButton.icon(
                onPressed: _submitting ? null : _submit,
                icon: _submitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2.5, color: Colors.white),
                      )
                    : const Icon(Icons.check_circle_outline_rounded, size: 22),
                label: Text(
                  _submitting
                      ? 'Yaratilmoqda...'
                      : 'Buyurtmani tasdiqlash — ${Formatters.money(summary.total)}',
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
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
}

class _PaymentOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primaryLight
              : (isDark ? const Color(0xFF12241C) : Colors.white),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? AppColors.primary
                : (isDark ? Colors.white12 : const Color(0xFFDDE7E1)),
            width: selected ? 1.8 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : AppColors.primaryLight,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(icon, color: selected ? Colors.white : AppColors.primary, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : AppColors.textDark,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white54 : AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: selected ? AppColors.primary : AppColors.textGrey,
                  width: 2,
                ),
              ),
              child: selected
                  ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
