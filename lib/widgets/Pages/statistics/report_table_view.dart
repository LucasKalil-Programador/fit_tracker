import 'dart:math';

import 'package:fittrackr/database/entities.dart';
import 'package:fittrackr/widgets/Pages/statistics/report_table.dart';
import 'package:fittrackr/widgets/Pages/statistics/default_graph.dart';
import 'package:fittrackr/widgets/common/default_widgets.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

enum ReportViewPeriod {last7, last30, lifeTime}

class ReportView extends StatefulWidget {
  final List<Report>? reports;
  final ReportTable? table;

  const ReportView({
    super.key,
    required this.reports,
    required this.table,
  });

  @override
  State<ReportView> createState() => _ReportViewState();
}

class _ReportViewState extends State<ReportView> {
  late final Map<ReportViewPeriod, List<String>> periodMap;
  ReportViewPeriod? period = ReportViewPeriod.last7;

  final List<Report> reports = [];
  final List<String> selected = [];

  List<String>? bottomTitles;
  List<FlSpot>? spots;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DefaultDivider(),
        Padding(
          padding: const EdgeInsets.all(32),
          child: AspectRatio(
            aspectRatio: 1.5,
            child: DefaultGraph(
              spots: spots ?? [],
              bottomTitlesList: bottomTitles ?? [],
            ),
          ),
        ),
        DefaultDivider(),
        Column(
          children: [
            ListTile(
              title: const Text("Ultimos 7 dias"),
              leading: Radio(
                value: ReportViewPeriod.last7,
                groupValue: period,
                onChanged: onPeriodSelected,
              ),
            ),
            ListTile(
              title: const Text("Ultimos 30 dias"),
              leading: Radio(
                value: ReportViewPeriod.last30,
                groupValue: period,
                onChanged: onPeriodSelected,
              ),
            ),
            ListTile(
              title: const Text("Desde o início"),
              leading: Radio(
                value: ReportViewPeriod.lifeTime,
                groupValue: period,
                onChanged: onPeriodSelected,
              ),
            ),
          ],
        ),
        ReportTableView(
          reports: reports,
          selected: selected,
          suffix: widget.table?.valueSuffix,
          onSelectedChanged: (reportsId) {
            period = null;
            generateSpots();
          },
          onReportSorted: (reports) {
            generateSpots();
          },
        ),
      ],
    );
  }

  Map<ReportViewPeriod, List<String>> createPeriodMap() {
    Map<ReportViewPeriod, List<String>> periodMap = {};
    periodMap[ReportViewPeriod.last7] = List.unmodifiable(
      reports.sublist(0, min(7, reports.length)).map((e) => e.id!).toList(),
    );
    periodMap[ReportViewPeriod.last30] = List.unmodifiable(
      reports.sublist(0, min(30, reports.length)).map((e) => e.id!).toList(),
    );
    periodMap[ReportViewPeriod.lifeTime] = List.unmodifiable(
      reports.map((e) => e.id!).toList(),
    );
    return Map.unmodifiable(periodMap);
  }

  String formatDate(int milliseconds) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final day = twoDigits(dateTime.day);
    final month = twoDigits(dateTime.month);
    final year = twoDigits(dateTime.year);
    
    
    return "$day/$month/$year";
  }

  void generateSpots() {
    List<String> bottomTitles = [];
    List<FlSpot> spots = [];

    for (var element in reports) {
      if(selected.contains(element.id)) {
        spots.add(FlSpot(spots.length.toDouble(), element.value));
        if (bottomTitles.length == 0 ||
            bottomTitles.length == selected.length - 1 ||
            bottomTitles.length == (selected.length / 2).toInt()) {
          bottomTitles.add(formatDate(element.reportDate));
        } else {
          bottomTitles.add("");
        }
      }
    }

    setState(() {
      this.bottomTitles = bottomTitles;
      this.spots = spots;
    });
  }

  @override
  void initState() {
    super.initState();
    
    if(widget.reports != null) {
      reports.addAll(List.from(widget.reports!));
      reports.sort((a, b) => b.reportDate.compareTo(a.reportDate));
      
      this.periodMap = createPeriodMap();
      selected.addAll(this.periodMap[ReportViewPeriod.last7]!);
      generateSpots();
    }
  }

  void onPeriodSelected(ReportViewPeriod? value) {
    period = value!;
    selected.clear();
    selected.addAll(periodMap[value] ?? []);
    generateSpots();
  }
}
