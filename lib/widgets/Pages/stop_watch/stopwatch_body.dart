import 'package:fittrackr/Controllers/stopwatch/stopwatch_controller.dart';
import 'package:fittrackr/l10n/app_localizations.dart';
import 'package:fittrackr/widgets/Pages/stop_watch/stopwatch_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StopwatchBody extends ConsumerWidget {
  final int index;

  const StopwatchBody({super.key, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context)!;
    final controller = ref.watch(
      stopwatchControllerProvider.select((value) {
        if (index < value.length) return value[index];
      }),
    ) ?? StopWatch();
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface.withAlpha(32),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: StopwatchWidget(stopWatchController: controller),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          spacing: 24,
          children: [
            Expanded(child: resetButton(localization, ref)),
            Expanded(child: playPausedButton(localization, ref, controller)),
          ],
        ),
      ],
    );
  }

  ElevatedButton resetButton(AppLocalizations localization, WidgetRef ref) {
    return ElevatedButton.icon(
      onPressed: () {
        ref.read(stopwatchControllerProvider.notifier).resetAt(index);
      },
      label: Text(localization.reset, softWrap: false),
      icon: const Icon(Icons.refresh),
    );
  }

  ElevatedButton playPausedButton(AppLocalizations localization, WidgetRef ref, StopWatch stopwatch) {
    final label = stopwatch.isPaused
            ? (stopwatch.isZeroed
                ? Text(localization.start, softWrap: false)
                : Text(localization.resume, softWrap: false))
            : Text(localization.pause, softWrap: false);

    var icon = stopwatch.isPaused
              ? const Icon(Icons.play_arrow)
              : const Icon(Icons.pause);

    return ElevatedButton.icon(
      onPressed: () {
          final notifier = ref.read(stopwatchControllerProvider.notifier);
          if (stopwatch.isPaused) {
              notifier.startAt(index);
          } else {
            notifier.pauseAt(index);
          }
      },
      label: label,
      icon: icon,
    );
  }
}
