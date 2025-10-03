import 'package:fittrackr/Controllers/theme/theme_controller.dart';
import 'package:fittrackr/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeSelector extends ConsumerWidget {

  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context)!;
    
    final theme = ref.watch(themeControllerProvider);
    final themeController = ref.read(themeControllerProvider.notifier);

    Map<ThemeMode, String> themeTextMap = {
      ThemeMode.dark: localization.dark,
      ThemeMode.light: localization.light,
      ThemeMode.system: localization.system,
    };
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(localization.theme, style: Theme.of(context).textTheme.titleLarge),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: ThemeMode.values.length,
          itemBuilder: (context, index) {
            final item = ThemeMode.values[index];
            final String text = themeTextMap[item] ?? localization.defaultOption;
            return ListTile(
              title: Text(text),
              leading: Radio<ThemeMode>(
                value: item,
                groupValue: theme,
                onChanged: (theme) {
                  if(theme is ThemeMode) themeController.setTheme(theme);
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
