import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../models/profile_data.dart';
import '../../providers/app_providers.dart';
import '../../services/snackbar_service.dart';

/// Sozlamalar sahifasi.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Sozlamalar')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Mavzu',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : AppColors.textDark,
            ),
          ),
          const SizedBox(height: 10),
          _ThemeOption(
            icon: Icons.light_mode_rounded,
            label: 'Yorug\' rejim',
            selected: settings.themeMode == ThemeMode.light,
            onTap: () =>
                ref.read(settingsProvider.notifier).setThemeMode(ThemeMode.light),
          ),
          _ThemeOption(
            icon: Icons.dark_mode_rounded,
            label: 'Qorong\'i rejim',
            selected: settings.themeMode == ThemeMode.dark,
            onTap: () =>
                ref.read(settingsProvider.notifier).setThemeMode(ThemeMode.dark),
          ),
          _ThemeOption(
            icon: Icons.brightness_auto_rounded,
            label: 'Tizim bo\'yicha',
            selected: settings.themeMode == ThemeMode.system,
            onTap: () =>
                ref.read(settingsProvider.notifier).setThemeMode(ThemeMode.system),
          ),
          const SizedBox(height: 20),
          Text(
            'Ma\'lumotlar',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : AppColors.textDark,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF12241C) : Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.restore_rounded,
                      color: AppColors.primary),
                  title: const Text('Demo ma\'lumotlarni tiklash'),
                  subtitle: const Text('Barcha mahsulotlar asl holatiga qaytadi'),
                  onTap: () => _confirmReset(context, ref),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.delete_forever_rounded,
                      color: AppColors.danger),
                  title: const Text('Barcha ma\'lumotlarni tozalash',
                      style: TextStyle(color: AppColors.danger)),
                  subtitle: const Text('Savatcha, buyurtmalar, sevimlilar, profil'),
                  onTap: () => _confirmClearAll(context, ref),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF163026) : AppColors.primaryLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Icon(Icons.lock_outline_rounded,
                    color: AppColors.primary, size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Barcha ma\'lumotlar shu telefonda, Hive lokal bazasida '
                    'saqlanadi. Hech qanday ma\'lumot internetga yuborilmaydi.',
                    style: TextStyle(fontSize: 12.5, color: AppColors.textDark),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              '${AppConstants.appName} v${AppConstants.appVersion}',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white38 : AppColors.textGrey,
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _confirmReset(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Demo ma\'lumotlarni tiklash'),
        content: const Text('Barcha mahsulotlar asl holatiga qaytadi. '
            'Savatcha va buyurtmalar ham tozalanadi. Davom etasizmi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Bekor qilish'),
          ),
          FilledButton(
            onPressed: () async {
              await ref.read(productsProvider.notifier).resetDemo();
              if (ctx.mounted) Navigator.of(ctx).pop();
              SnackbarService.success('Demo ma\'lumotlar tiklandi');
            },
            child: const Text('Tiklash'),
          ),
        ],
      ),
    );
  }

  void _confirmClearAll(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Barcha ma\'lumotlarni tozalash'),
        content: const Text('Savatcha, buyurtmalar, sevimlilar va profil '
            'o\'chiriladi. Amalni bekor qilib bo\'lmaydi!'),
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
            onPressed: () async {
              await ref.read(productsProvider.notifier).resetDemo();
              ref.read(cartProvider.notifier).clear();
              ref.read(profileProvider.notifier).save(const ProfileData());
              ref.invalidate(ordersProvider);
              ref.invalidate(favoritesProvider);
              ref.invalidate(profileProvider);
              if (ctx.mounted) Navigator.of(ctx).pop();
              SnackbarService.success('Barcha ma\'lumotlar tozalandi');
            },
            child: const Text('Tozalash'),
          ),
        ],
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF12241C) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: selected
              ? AppColors.primary
              : (isDark ? Colors.white12 : const Color(0xFFDDE7E1)),
          width: selected ? 1.6 : 1,
        ),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon,
            color: selected ? AppColors.primary : AppColors.textGrey),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 14.5,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: isDark ? Colors.white : AppColors.textDark,
          ),
        ),
        trailing: selected
            ? const Icon(Icons.check_circle_rounded,
                color: AppColors.primary, size: 22)
            : const Icon(Icons.circle_outlined, color: AppColors.textGrey, size: 22),
      ),
    );
  }
}
