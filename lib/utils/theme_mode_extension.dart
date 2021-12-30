import 'package:flutter/material.dart';

extension ThemeModeExt on ThemeMode {
  /// タイトル文字列
  String get title {
    switch (this) {
      case ThemeMode.system:
        return 'System';
      case ThemeMode.light:
        return 'Lignt';
      case ThemeMode.dark:
        return 'Dark';
    }
  }

  /// サブタイトル文字列
  String get subtitle {
    switch (this) {
      case ThemeMode.system:
        return '端末のシステム設定に追従';
      case ThemeMode.light:
        return '白を基調とした明るいテーマ';
      case ThemeMode.dark:
        return '黒を基調とした暗いテーマ';
    }
  }

  /// アイコン
  IconData get iconData {
    switch (this) {
      case ThemeMode.system:
        return Icons.dashboard_customize;
      case ThemeMode.light:
        return Icons.wb_sunny;
      case ThemeMode.dark:
        return Icons.dark_mode;
    }
  }
}
