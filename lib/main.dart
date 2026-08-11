import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'database/local_database.dart';
import 'providers/app_providers.dart';
import 'screens/main_shell.dart';
import 'services/seed_service.dart';
import 'services/snackbar_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lokal bazani ochish (server kerak emas — hammasi telefonda).
  await LocalDatabase.init();

  // Birinchi ochilishda demo mahsulotlarni yaratish.
  await SeedService.ensureSeeded();

  runApp(const ProviderScope(child: XaridApp()));
}

class XaridApp extends ConsumerWidget {
  const XaridApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: settings.themeMode,
      home: const MainShell(),
    );
  }
}
