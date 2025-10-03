import 'dart:math';

import 'package:fittrackr/Controllers/stopwatch/stopwatch_controller.dart';
import 'package:fittrackr/Providers/stopwatch/tab_index.dart';
import 'package:fittrackr/l10n/app_localizations.dart';
import 'package:fittrackr/widgets/Pages/stop_watch/page_selector.dart';
import 'package:fittrackr/widgets/Pages/stop_watch/stopwatch_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StopWatchPage extends ConsumerStatefulWidget {
  const StopWatchPage({super.key});

  @override
  ConsumerState<StopWatchPage> createState() => _StopWatchPageState();
}

class _StopWatchPageState extends ConsumerState<StopWatchPage> with TickerProviderStateMixin {
  late final localization = AppLocalizations.of(context)!;
  late TabController tabController;
  late PageController pageController;

  @override
  void dispose() {
    pageController.dispose();
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stopwatches = ref.watch(stopwatchControllerProvider);
    final tabIndex = min(ref.watch(tabIndexProvider), stopwatches.length - 1);
    
    tabController = TabController(
      initialIndex: tabIndex,
      length: stopwatches.length,
      vsync: this,
    );
    pageController = PageController();
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          localization.timer,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              itemCount: stopwatches.length,
              controller: pageController,
              onPageChanged: (index) => ref.read(tabIndexProvider.notifier).setTab(index),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: StopwatchBody(index: index,),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PageSelector(
              tabController: tabController,
              onPageChanged: (index) => onPageSelectorChange(index, stopwatches.length),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        spacing: 16,
        children: [
          FloatingActionButton(
            onPressed: () {
              if(isAnimating) return;
              removeStopWatch(stopwatches, tabController.index);
              onPageSelectorChange(tabController.index, stopwatches.length, 250);
            },
            child: const Icon(Icons.remove),
          ),
          FloatingActionButton(
            onPressed: () {
              if(isAnimating) return;
              addNewStopWatch(stopwatches);
              onPageSelectorChange(stopwatches.length, stopwatches.length, 250);
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  void addNewStopWatch(List<StopWatch> stopwatches) {
    if (stopwatches.length >= 8) return;
    ref.read(stopwatchControllerProvider.notifier)
      .add(StopWatch());
  }

  void removeStopWatch(List<StopWatch> stopwatches, int index) {
    if(stopwatches.length <= 1) return;
    ref.read(stopwatchControllerProvider.notifier)
      .removeAt(index);
  }

  bool isAnimating = false;
  void onPageSelectorChange(int index, int length, [int milliseconds = 350]) async {
    if(isAnimating) return;
    isAnimating = true;

    try {
      await pageController.animateToPage(
        index,
        duration: Duration(milliseconds: milliseconds),
        curve: Curves.easeInOut,
      );
    } finally {
      isAnimating = false;
    } 
  }
}
