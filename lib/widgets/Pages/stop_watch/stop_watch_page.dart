import 'dart:convert';

import 'package:fittrackr/states/metadata_state.dart';
import 'package:fittrackr/widgets/Pages/stop_watch/stop_watch_widgets.dart';
import 'package:flutter/material.dart';
import 'package:fittrackr/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class StopWatchPage extends StatefulWidget {
  const StopWatchPage({super.key});

  @override
  State<StopWatchPage> createState() => _StopWatchPageState();
}

class _StopWatchPageState extends State<StopWatchPage> with TickerProviderStateMixin {
  late final localization = AppLocalizations.of(context)!;
  late List<StopWatchController> controllers;
  late TabController tabController;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    controllers = loadControllers();
    tabController = TabController(length: controllers.length, vsync: this);
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              itemCount: controllers.length,
              controller: pageController,
              onPageChanged: (index) {
                setState(() => tabController.index = index);
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: StopWatchBody(controller: controllers[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PageSelector(
              tabController: tabController,
              onPageChanged: onPageSelectorChange,
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
              setState(() => removeStopWatch(tabController.index));
              onPageSelectorChange(tabController.index, 250);
            },
            child: const Icon(Icons.remove),
          ),
          FloatingActionButton(
            onPressed: () {
              if(isAnimating) return;
              setState(() => addNewStopWatch());
              onPageSelectorChange(controllers.length - 1, 250);
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  void addNewStopWatch() {
    if (controllers.length >= 8) return;
    final initialController = StopWatchController();
    initialController.addListener(onControllerChanged);
    controllers.add(initialController);
    onControllerChanged();

    tabController.dispose();
    tabController = TabController(
      initialIndex: tabController.index,
      length: controllers.length,
      vsync: this,
    );
  }

  void removeStopWatch(int index) {
    if(controllers.length <= 1) return;
    controllers.removeAt(index);
    onControllerChanged();

    tabController.dispose();
    tabController = TabController(
      initialIndex: tabController.index == 0 ? 0 : tabController.index - 1,
      length: controllers.length,
      vsync: this,
    );
  }

  static const stopWatchPageKey = "stop_watch_page:timers";

  void onControllerChanged() {
   final metadate = Provider.of<MetadataState>(context, listen: false);
   List<Map<String, String?>> controllersMap = [
      for (var element in controllers) 
        element.toJson(),
   ]; 
   metadate.put(stopWatchPageKey, jsonEncode(controllersMap));
  }

  List<StopWatchController> loadControllers() {
    List<StopWatchController> controllers = [];
    final metadate = Provider.of<MetadataState>(context, listen: false);
    if(metadate.containsKey(stopWatchPageKey)) {
      List<dynamic> data = jsonDecode(metadate.get(stopWatchPageKey)!);
      for (var element in data) {
        final controller = StopWatchController.fromJson(element);
        if(controller != null) {
          controller.addListener(onControllerChanged);
          controllers.add(controller);
        }
      }
    }
    if(controllers.isNotEmpty) return controllers;
    
    final initialController = StopWatchController();
    initialController.addListener(onControllerChanged);
    return [initialController];
  }

  bool isAnimating = false;
  void onPageSelectorChange(int index, [int milliseconds = 350]) async {
    if(isAnimating) return;

    if(index >= controllers.length) {
      index = 0;
    } else if(index < 0) {
      index = controllers.length - 1;
    }

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

class PageSelector extends StatelessWidget {
  final TabController tabController;
  final void Function(int index)? onPageChanged;

  const PageSelector({
    super.key,
    required this.tabController, 
    this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          splashRadius: 16,
          padding: EdgeInsets.zero,
          onPressed: () {
            if(onPageChanged != null) onPageChanged!(tabController.index - 1);
          },
          icon: Icon(Icons.arrow_left_rounded),
        ),
        TabPageSelector(
          controller: tabController,
          color: Theme.of(context).colorScheme.surface,
          selectedColor: Theme.of(context).colorScheme.primary,
        ),
        IconButton(
          splashRadius: 16,
          padding: EdgeInsets.zero,
          onPressed: () {
            if(onPageChanged != null) onPageChanged!(tabController.index + 1);
          },
          icon: Icon(Icons.arrow_right_rounded),
        ),
      ],
    );
  }
}


class StopWatchBody extends StatefulWidget {
  final StopWatchController? controller;

  const StopWatchBody({super.key, this.controller});

  @override
  State<StopWatchBody> createState() => _StopWatchBodyState();
}

class _StopWatchBodyState extends State<StopWatchBody> {
  late final localization = AppLocalizations.of(context)!;
  late StopWatchController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller!;
    if(widget.controller == null) {
      controller = StopWatchController();
    } else {
      controller = widget.controller!;
    }
  }

  @override
  void didUpdateWidget(covariant StopWatchBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(widget.controller == null) {
      controller = StopWatchController();
    } else {
      controller = widget.controller!;
    }
  }

  @override
  Widget build(BuildContext context) {
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
            child: StopWatchWidget(stopWatchController: controller),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          spacing: 24,
          children: [
            Expanded(child: resetButton()),
            Expanded(child: playPausedButton()),
          ],
        ),
      ],
    );
  }

  ElevatedButton resetButton() {
    return ElevatedButton.icon(
      onPressed: () {
        setState(() {
          controller.reset();
        });
      },
      label: Text(localization.reset, softWrap: false),
      icon: const Icon(Icons.refresh),
    );
  }

  ElevatedButton playPausedButton() {
    final label = controller.isPaused
            ? (controller.isZeroed
                ? Text(localization.start, softWrap: false)
                : Text(localization.resume, softWrap: false))
            : Text(localization.pause, softWrap: false);

    var icon = controller.isPaused
              ? const Icon(Icons.play_arrow)
              : const Icon(Icons.pause);

    return ElevatedButton.icon(
      onPressed: () {
        setState(() {
          if (controller.isPaused) {
            controller.start();
          } else {
            controller.pause();
          }
        });
      },
      label: label,
      icon: icon,
    );
  }
}
