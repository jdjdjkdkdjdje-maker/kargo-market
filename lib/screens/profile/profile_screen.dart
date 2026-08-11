import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/app_providers.dart';
import '../../routes/app_routes.dart';
import '../../services/snackbar_service.dart';

/// Profil bo'limi.
///
/// Maxfiy bo'lim: sahifaning pastki qismidagi versiya matnini
/// uzoq bosib (long-press) turganda "Mahsulotlarni boshqarish" ochiladi.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final orders = ref.watch(ordersProvider);
    final favorites = ref.watch(favoritesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          IconButton(
            tooltip: 'Sozlamalar',
            onPressed: () => AppRoutes.toSettings(context),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ---------- Profil kartasi ----------
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF00A67E), Color(0xFF065F46)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Colors.white.withValues(alpha: 0.5), width: 2),
                  ),
                  child: Center(
                    child: Text(
                      _initials(profile.name),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.name.isEmpty ? 'Mehmon' : profile.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        profile.phone.isEmpty
                            ? 'Telefon raqam kiritilmagan'
                            : profile.phone,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 13,
                        ),
                      ),
                      if (profile.address.isNotEmpty)
                        Text(
                          profile.address,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 13,
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Tahrirlash',
                  onPressed: () => AppRoutes.toEditProfile(context),
                  icon: const Icon(Icons.edit_rounded,
                      color: Colors.white, size: 20),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          // ---------- Menyu ----------
          _MenuTile(
            icon: Icons.receipt_long_rounded,
            title: 'Buyurtmalarim',
            subtitle: '${orders.length} ta buyurtma',
            onTap: () => ref.read(mainTabProvider.notifier).select(3),
          ),
          _MenuTile(
            icon: Icons.favorite_rounded,
            title: 'Sevimlilarim',
            subtitle: '${favorites.length} ta mahsulot',
            onTap: () => AppRoutes.toFavorites(context),
          ),
          _MenuTile(
            icon: Icons.person_outline_rounded,
            title: 'Profilni tahrirlash',
            subtitle: 'Ism, telefon, manzil',
            onTap: () => AppRoutes.toEditProfile(context),
          ),
          _MenuTile(
            icon: Icons.settings_outlined,
            title: 'Sozlamalar',
            subtitle: 'Mavzu, ma\'lumotlar',
            onTap: () => AppRoutes.toSettings(context),
          ),
          _MenuTile(
            icon: Icons.help_outline_rounded,
            title: 'Yordam',
            subtitle: 'Ko\'p so\'raladigan savollar',
            onTap: () => AppRoutes.toHelp(context),
          ),
          const SizedBox(height: 18),
          // ---------- Oflayn rejim kartasi ----------
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF163026) : AppColors.primaryLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Icon(Icons.cloud_off_rounded, color: AppColors.primary, size: 22),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Internet kerak emas — ilova oflayn rejimda ishlamoqda',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // ---------- Versiya (maxfiy bo'lim uchun) ----------
          Center(
            child: GestureDetector(
              onLongPress: () {
                HapticFeedback.mediumImpact();
                SnackbarService.show('Maxfiy bo\'lim ochildi');
                AppRoutes.toAdminPanel(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Text(
                      '${AppConstants.appName} v${AppConstants.appVersion}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white38 : AppColors.textGrey,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '100% oflayn — barcha ma\'lumotlar telefonda',
                      style: TextStyle(
                        fontSize: 10.5,
                        color: isDark ? Colors.white24 : const Color(0xFFB0BCB5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF12241C) : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary, size: 21),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : AppColors.textDark,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12.5,
            color: isDark ? Colors.white54 : AppColors.textGrey,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: isDark ? Colors.white38 : AppColors.textGrey,
        ),
      ),
    );
  }
}
