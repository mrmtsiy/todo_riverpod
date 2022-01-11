import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app_riverpod/view_model/controller/theme_controller.dart';
import 'package:todo_app_riverpod/utils/theme_mode_extension.dart';

class ThemeListView extends HookConsumerWidget {
  const ThemeListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeSelector = ref.read(themeSelectorProvider.notifier);
    final currentThemeMode = ref.watch(themeSelectorProvider);

    return ListView.builder(
      itemCount: 2,
      itemBuilder: (_, index) {
        final themeMode = ThemeMode.values[index];
        return RadioListTile<ThemeMode>(
          value: themeMode,
          groupValue: currentThemeMode,
          onChanged: (newTheme) {
            themeSelector.change(newTheme!);
          },
          title: Text(themeMode.title),
          subtitle: Text(themeMode.subtitle),
          secondary: Icon(themeMode.iconData),
          controlAffinity: ListTileControlAffinity.trailing,
        );
      },
    );
  }
}
