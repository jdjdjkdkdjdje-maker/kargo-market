import 'package:flutter/material.dart';

/// Ilova sozlamalari.
class AppSettings {
  final ThemeMode themeMode;
  final bool offlineNoticeShown;

  const AppSettings({
    this.themeMode = ThemeMode.light,
    this.offlineNoticeShown = false,
  });

  AppSettings copyWith({ThemeMode? themeMode, bool? offlineNoticeShown}) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      offlineNoticeShown: offlineNoticeShown ?? this.offlineNoticeShown,
    );
  }

  Map<String, dynamic> toMap() => {
        'themeMode': themeMode.index,
        'offlineNoticeShown': offlineNoticeShown,
      };

  factory AppSettings.fromMap(Map<dynamic, dynamic>? map) => AppSettings(
        themeMode: ThemeMode.values[map?['themeMode'] as int? ?? ThemeMode.light.index],
        offlineNoticeShown: map?['offlineNoticeShown'] as bool? ?? false,
      );
}
