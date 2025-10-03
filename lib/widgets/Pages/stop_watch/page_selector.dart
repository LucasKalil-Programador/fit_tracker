import 'package:flutter/material.dart';

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
