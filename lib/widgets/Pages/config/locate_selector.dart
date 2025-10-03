import 'package:fittrackr/Controllers/locale/locale_controller.dart';
import 'package:fittrackr/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocateSelector extends ConsumerWidget {
  const LocateSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context)!;

    final locale = ref.watch(localeControllerProvider);
    final localeController = ref.read(localeControllerProvider.notifier);

    Map<Locale, String> localeTextMap = {
      Locale("pt"): localization.portugueseLanguage,
      Locale("en"): localization.englishLanguage, 
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: [
        Center(child: Text(localization.languageTitle, style: Theme.of(context).textTheme.titleLarge)),
        LayoutBuilder(builder: (context, constraints) => 
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: DropdownMenu<Locale?>(
                initialSelection: locale,
                width: constraints.maxWidth,
                dropdownMenuEntries: [
                    for (var supLocale in AppLocalizations.supportedLocales)
                      DropdownMenuEntry(value: supLocale, label: localeTextMap[supLocale] ?? supLocale.languageCode),
                  DropdownMenuEntry(value: null, label: localization.system)
                ],
                onSelected: localeController.setLocale,
              )
            ),
        ),
      ],
    );
  }
}
