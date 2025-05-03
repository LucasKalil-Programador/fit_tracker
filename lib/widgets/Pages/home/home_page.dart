import 'dart:async';

import 'package:fittrackr/widgets/common/default_graph.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomePage extends StatefulWidget {

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return StaggeredGrid.count(
      crossAxisCount: 4,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        StaggeredGridTile.count(
          crossAxisCellCount: 4,
          mainAxisCellCount: 3,
          child: GraphFromList(texts: [], values: []),
        ),
      ],
    );
  }
}

class GraphFromList extends StatelessWidget {
  final List<double> values;
  final List<String> texts;

  const GraphFromList({
    super.key,
    required this.texts,
    required this.values
  });

  @override
  Widget build(BuildContext context) {
    return DefaultGraph(spots: [
      for(int i = 0; i < values.length; i++)
        FlSpot(i.toDouble(), values[i]),
      ],
      bottomTitlesList: texts);
  }
}


