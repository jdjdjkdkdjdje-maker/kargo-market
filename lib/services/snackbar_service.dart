import 'package:flutter/material.dart';

/// Global messenger kaliti — istalgan joydan xabar ko'rsatish uchun.
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

/// O'zbekcha bildirishnomalar (snackbar).
class SnackbarService {
  SnackbarService._();

  static void show(String message, {bool isError = false}) {
    final messenger = rootScaffoldMessengerKey.currentState;
    if (messenger == null) return;

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                isError ? Icons.error_outline : Icons.check_circle_outline,
                color: isError ? const Color(0xFFFFCDD2) : const Color(0xFFA7F3D0),
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(child: Text(message)),
            ],
          ),
          duration: const Duration(seconds: 2),
        ),
      );
  }

  static void success(String message) => show(message);

  static void error(String message) => show(message, isError: true);
}
