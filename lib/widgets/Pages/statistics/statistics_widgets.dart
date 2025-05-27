import 'dart:math';

import 'package:fittrackr/database/entities.dart';
import 'package:fittrackr/widgets/common/default_widgets.dart';
import 'package:fittrackr/widgets/common/value_input_double_widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';


// Default Graph

class DefaultGraph extends StatefulWidget {
  final List<FlSpot> spots;
  final double? minY;
  final double? maxY;
  final double? minX;
  final double? maxX;
  final Color borderColor;
  final Color textColor;
  final Color tooltipBackground;
  final Color gradientColorStart;
  final Color gradientColorEnd;
  final String topTitle;
  final List<String>? bottomTitlesList;
  final String leftTitle;
  final String rightTitle;

  const DefaultGraph({
    super.key,
    required this.spots,
    this.minY,
    this.maxY,
    this.minX,
    this.maxX,
    this.borderColor = Colors.white,
    this.textColor = Colors.white,
    this.tooltipBackground = Colors.blueGrey,
    this.gradientColorStart = Colors.blueAccent,
    this.gradientColorEnd = Colors.cyan,
    this.topTitle = "Placeholder: top",
    this.bottomTitlesList,
    this.leftTitle = "Placeholder: left",
    this.rightTitle = "Placeholder: right",
  });

  @override
  State<DefaultGraph> createState() => _DefaultGraphState();
}

class _DefaultGraphState extends State<DefaultGraph> {
  final List<int> selected = [];

  @override
  Widget build(BuildContext context) {
    final lineBarsData = [LineChartBarData(
      showingIndicators: selected,
        spots: widget.spots,
        isCurved: true,
        dotData: FlDotData(show: true),
        barWidth: 4,
        shadow: const Shadow(blurRadius: 8),
        gradient: LinearGradient(
          colors: [widget.gradientColorStart, widget.gradientColorEnd],
        ),
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            colors: [
              widget.gradientColorStart.withValues(alpha: 0.4),
              widget.gradientColorEnd.withValues(alpha: 0.4),
            ],
          ),
        ),
      ),
    ];

    final flTitlesData = FlTitlesData(
      leftTitles: AxisTitles(
        axisNameWidget: Text(widget.leftTitle, style: TextStyle(color: widget.textColor)),
        axisNameSize: 24,
        sideTitles: SideTitles(showTitles: false, reservedSize: 0),
      ),
      rightTitles: AxisTitles(
        axisNameWidget: Text(widget.rightTitle, style: TextStyle(color: widget.textColor)),
        axisNameSize: 24,
        sideTitles: SideTitles(showTitles: false, reservedSize: 0),
      ),
      topTitles: AxisTitles(
        axisNameWidget: Text(widget.topTitle, textAlign: TextAlign.left, style: TextStyle(color: widget.textColor)),
        sideTitles: SideTitles(showTitles: true, reservedSize: 4),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 1,
          getTitlesWidget: (value, meta) => getTitle(value, meta),
          reservedSize: 30,
        ),
      ),
    );
    
    final lineTouchData = LineTouchData(
      enabled: true,
      handleBuiltInTouches: false,
      touchCallback: (event, response) {
        if(response == null || response.lineBarSpots == null) {
          return;
        }
        
        if(event is FlTapUpEvent) {
          final spotIndex = response.lineBarSpots!.first.spotIndex;
          setState(() {
            if(selected.contains(spotIndex)) {
              selected.remove(spotIndex);
            } else {
              selected.add(spotIndex);
            }
          });
        }
        
      },
      touchTooltipData: LineTouchTooltipData(
        getTooltipColor: (touchedSpot) => widget.tooltipBackground,
        tooltipBorderRadius: BorderRadius.circular(8),
        tooltipBorder: BorderSide(width: 2, color: widget.borderColor),
        getTooltipItems: (lineBarsSpot) {
          return lineBarsSpot.map((lineBarSpot) {
            return LineTooltipItem(
              lineBarSpot.y.toString(),
              TextStyle(color: widget.textColor, fontWeight: FontWeight.bold),
            );
          }).toList();
        },
      ),
      getTouchedSpotIndicator: (barData, spotIndexes) {
        return spotIndexes.map((e) {
          return TouchedSpotIndicatorData(
            FlLine(color: widget.borderColor),
            FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) => 
              FlDotCirclePainter(
                radius: 8,
                strokeWidth: 2,
                color: Color.lerp(widget.gradientColorStart, widget.gradientColorEnd, percent / 100)!,
                strokeColor: widget.borderColor
              ),
            )
          );
        },).toList();
      },
    );

    return LineChart(
      LineChartData(
        showingTooltipIndicators: selected.map((e) {
              return ShowingTooltipIndicators([
                LineBarSpot(lineBarsData[0], 0, widget.spots[e]),
              ]);
        },).toList(),
        lineBarsData: lineBarsData,
        lineTouchData: lineTouchData,
        minY: widget.minY ?? getMin(),
        maxY: widget.maxY ?? getMax(),
        minX: widget.minX,
        maxX: widget.maxX,
        gridData: FlGridData(show: false),
        titlesData: flTitlesData,
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            width: 3,
            color: widget.borderColor
          )
        )
      )
    );
  }

  double? getMin() {
    if(widget.spots.isEmpty) return null;

    double min = double.infinity;
    for (var i = 0; i < widget.spots.length; i++) {
      if(min > widget.spots[i].y) {
        min = widget.spots[i].y;
      }
    }
    return min * 0.9;
  }

  double? getMax() {
    if(widget.spots.isEmpty) return null;

    double max = double.negativeInfinity;
    for (var i = 0; i < widget.spots.length; i++) {
      if(max < widget.spots[i].y) {
        max = widget.spots[i].y;
      }
    }
    return max * 1.1;
  }

  Widget getTitle(double value, TitleMeta meta) {
    final style = TextStyle(
      fontWeight: FontWeight.bold,
      fontFamily: 'Digital',
      color: widget.textColor,
    );
    
    final key = value.toInt();
    if ((widget.bottomTitlesList?.length ?? 0) > key) {
      return SideTitleWidget(
        meta: meta,
        child: Text(widget.bottomTitlesList![key], style: style,),
      );
    }
    return Container();
  }
}


// Table View

class ReportTableView extends StatefulWidget {
  final List<Report> reports;
  final List<String> selected;
  final void Function(List<String>)? onSelectedChanged;
  final void Function(List<Report>)? onReportSorted;
  final void Function(Report)? onDelete;
  final String? suffix;

  const ReportTableView({
    super.key,
    required this.reports,
    required this.selected,
    this.suffix,
    this.onSelectedChanged,
    this.onReportSorted,
    this.onDelete,
  });

  @override
  State<ReportTableView> createState() => _ReportTableViewState();
}

class _ReportTableViewState extends State<ReportTableView> {
  bool sortAscending = false;
  int? sortColumnIndex;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final reportSource = _ReportSource(
      data: widget.reports,
      selected: widget.selected,
      suffix: widget.suffix ?? "",
      onPressNote: (p0) => showFullNote(context, p0),
      onSelectedChanged:
          (p0) => {
            if (widget.onSelectedChanged != null) {
              widget.onSelectedChanged!(widget.selected),
            }
          },
      onDelete: widget.onDelete
    );

    return PaginatedDataTable(
      header: const Text("Tabela completa"),
      sortAscending: sortAscending,
      sortColumnIndex: sortColumnIndex,
      columns: [
        DataColumn(
          label: ValueListenableBuilder(
            valueListenable: reportSource,
            builder: (context, value, child) {
              return Checkbox(
                value: widget.selected.length >= widget.reports.length,
                onChanged: (value) {
                  setState(() {
                    if (widget.selected.length >= widget.reports.length) {
                      widget.selected.clear();
                    } else {
                      if(widget.selected.isNotEmpty) widget.selected.clear();
                      widget.selected.addAll(widget.reports.map((e) => e.id!));
                    }
                  });
                  if(widget.onSelectedChanged != null) widget.onSelectedChanged!(widget.selected);
                },
              );
            },
          ),
          tooltip: "Os itens selecionados serão exibidos no gráfico"
        ),
        DataColumn(label: Text("Data"), onSort: sortByDate, tooltip: "Data em que o valor foi registrado"),
        DataColumn(label: Text("Valor"), numeric: true, onSort: sortByValue, tooltip: "Valor registrado"),
        DataColumn(label: Text("Anotação"), onSort: sortByNote, tooltip: "Observação adicionada pelo usuário"),
        DataColumn(label: Text("Deletar"), tooltip: "Deleta o reporte"),
      ],
      source: reportSource,
    );
  }

  void sortByDate(int columnIndex, bool ascending) {
    setState(() {
      widget.reports.sort(
        (a, b) => sortAscending
                ? a.reportDate.compareTo(b.reportDate)
                : b.reportDate.compareTo(a.reportDate),
      );
      sortAscending = !sortAscending;
      sortColumnIndex = columnIndex;
    }); 
    if(widget.onReportSorted != null) widget.onReportSorted!(widget.reports);
  }

  void sortByValue(int columnIndex, bool ascending) {
    setState(() {
      widget.reports.sort(
        (a, b) => sortAscending
                ? a.value.compareTo(b.value)
                : b.value.compareTo(a.value),
      );
      sortAscending = !sortAscending;
      sortColumnIndex = columnIndex;
    });
    if(widget.onReportSorted != null) widget.onReportSorted!(widget.reports);
  }

  void sortByNote(int columnIndex, bool ascending) {
    setState(() {
      widget.reports.sort(
        (a, b) => sortAscending
                ? a.value.compareTo(b.value)
                : b.value.compareTo(a.value),
      );
      sortAscending = !sortAscending;
      sortColumnIndex = columnIndex;
    });
    if(widget.onReportSorted != null) widget.onReportSorted!(widget.reports);
  }

  Future<void> showFullNote(BuildContext context, Report report) async {
    await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Anotação completa'),
            content: Text(report.note),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Feichar'),
              ),
            ],
          ),
    );
  }
}

class _ReportSource extends DataTableSource implements ValueListenable {
  final List<Report> data;
  final List<String> selected;
  final String suffix;

  final void Function(Report)? onPressNote;
  final void Function(List<String>)? onSelectedChanged;
  final void Function(Report)? onDelete;

  _ReportSource({required this.data, required this.selected, required this.suffix, this.onPressNote, this.onSelectedChanged, this.onDelete});

  String formatDate(int milliseconds) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final day = twoDigits(dateTime.day);
    final month = twoDigits(dateTime.month);
    final year = twoDigits(dateTime.year);
    final hour = twoDigits(dateTime.hour);
    final minute = twoDigits(dateTime.minute);
    
    return "$day/$month/$year $hour:$minute";
  }

  String compactText(String text, int maxLength) {
    if(text.length > maxLength) {
      text = text.substring(0, maxLength);
      text = "$text...";
    }
    return text;
  }

  @override
  DataRow? getRow(int index) {
    final element = data[index];
    return DataRow(
      cells: [
        DataCell(
          Checkbox(
            value: selected.contains(element.id),
            onChanged: (value) {
              if (selected.contains(element.id)) {
                selected.remove(element.id);
              } else {
                selected.add(element.id!);
              }
              if(onSelectedChanged != null) onSelectedChanged!(selected);
              notifyListeners();
            },
          ),
        ),
        DataCell(
          Text(
            formatDate(element.reportDate),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataCell(
          Text(
            "${element.value.toStringAsFixed(2)} $suffix",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataCell(
          Text(
            compactText(element.note, 16),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          onTap: () => {if(onPressNote != null) onPressNote!(element)}
        ),
        DataCell(
          Center(child: Icon(Icons.delete)),
          onTap: () {if(onDelete != null) onDelete!(element);},
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => selected.length;
  
  @override
  get value => selected.length;
}


// Report Form
// TODO: Select date
// TODO: Problema ao digitar no bloco de note
class ReportForm extends StatefulWidget {
  final void Function(Report report)? onSubmit;
  final ReportTable table;

  const ReportForm({
    super.key, required this.table, this.onSubmit 
  });

  @override
  State<ReportForm> createState() => _ReportFormState();
}

class _ReportFormState extends State<ReportForm> {
  final _noteController = TextEditingController(text: "");

  double value = 0;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Reportar valor",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: noteInput(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ValueInputDoubleWidget(
                  label: "Valor",
                  suffix: widget.table.valueSuffix,
                  minValue: -1_000_000_000,
                  maxValue: 1_000_000_000,
                  onChanged: (value) => this.value = value,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: submitButton(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget noteInput() {
    return TextFormField(
      controller: _noteController,
      decoration: const InputDecoration(labelText: "Notas"),
      maxLines: 6,
      validator: (value) {
        if (value == null || value.length > 500) {
          return 'Nota Invalida';
        }
        return null;
      },
    );
  }

  Widget submitButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          Report report = Report(
            value: value,
            note: _noteController.text,
            tableId: widget.table.id!,
            reportDate: DateTime.now().millisecondsSinceEpoch,
          );
          if(widget.onSubmit != null) widget.onSubmit!(report);
        }
      },
      child: Text("Adicionar"),
    );
  }
}


// Report Table Form

class ReportTableForm extends StatefulWidget {
  final Function(ReportTable table)? onSubmit;

  const ReportTableForm({
    super.key, this.onSubmit,
  });

  @override
  State<ReportTableForm> createState() => _ReportTableFormState();
}

class _ReportTableFormState extends State<ReportTableForm> {
  final _desctiptionController = TextEditingController(text: "");
  final _nameController = TextEditingController(text: "");
  final _suffixController = TextEditingController(text: "");

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Criar tabela de progresso",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(padding: const EdgeInsets.all(8.0), child: nameInput()),
            Padding(padding: const EdgeInsets.all(8.0), child: suffixInput()),
            Padding(padding: const EdgeInsets.all(8.0), child: noteInput()),
            Padding(padding: const EdgeInsets.all(8.0), child: submitButton()),
          ],
        ),
      ),
    );
  }

  Widget nameInput() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(labelText: "Nome"),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Nome Invalido';
        }
        return null;
      },
    );
  }

  Widget noteInput() {
    return TextFormField(
      controller: _desctiptionController,
      decoration: const InputDecoration(labelText: "Descrição"),
      maxLines: 8,
      validator: (value) {
        if (value == null || value.length > 500) {
          return 'Descrição invalida';
        }
        return null;
      },
    );
  }

  Widget suffixInput() {
    return TextFormField(
      controller: _suffixController,
      decoration: const InputDecoration(labelText: "Sufixo do valor exemplo: (15 Kg)"),
      validator: (value) {
        if (value == null || value.length > 10) {
          return 'Sufixo Invalido';
        }
        return null;
      },
    );
  }

  Widget submitButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          ReportTable table = ReportTable(
            name: _nameController.text,
            description: _desctiptionController.text,
            valueSuffix: _suffixController.text,
            createdAt: DateTime.now().millisecondsSinceEpoch,
            updatedAt: DateTime.now().millisecondsSinceEpoch,
          );
          if(widget.onSubmit != null) widget.onSubmit!(table);
        }
      },
      child: Text("Adicionar"),
    );
  }
}


// Report View

enum _ReportViewPeriod {last7, last30, lifeTime}

class ReportView extends StatefulWidget {
  final List<Report>? reports;
  final ReportTable? table;

  final void Function(Report)? onDelete;

  const ReportView({
    super.key,
    required this.reports,
    required this.table, 
    this.onDelete,
  });

  @override
  State<ReportView> createState() => _ReportViewState();
}

class _ReportViewState extends State<ReportView> {
  Map<_ReportViewPeriod, List<String>> periodMap = {};
  _ReportViewPeriod? period = _ReportViewPeriod.last7;

  final List<Report> reports = [];
  final List<String> selected = [];

  List<String>? bottomTitles;
  List<FlSpot>? spots;

  @override
  void initState() {
    super.initState();
    
    if(widget.reports != null) {
      reports.addAll(List.from(widget.reports!));
      reports.sort((a, b) => b.reportDate.compareTo(a.reportDate));
      
      periodMap = createPeriodMap();
      selected.addAll(periodMap[_ReportViewPeriod.last7]!);
      generateSpots();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
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
              borderColor: colorScheme.onPrimaryContainer,
              tooltipBackground: colorScheme.primaryContainer,
              textColor: colorScheme.onSurface,
              topTitle: "Gráfico interativo",
              rightTitle: widget.table == null ? "" : widget.table!.valueSuffix,
              leftTitle: widget.table == null ? "" : widget.table!.valueSuffix,
            ),
          ),
        ),
        DefaultDivider(),
        Column(
          children: [
            ListTile(
              title: const Text("Ultimos 7 dias"),
              leading: Radio(
                value: _ReportViewPeriod.last7,
                groupValue: period,
                onChanged: onPeriodSelected,
              ),
            ),
            ListTile(
              title: const Text("Ultimos 30 dias"),
              leading: Radio(
                value: _ReportViewPeriod.last30,
                groupValue: period,
                onChanged: onPeriodSelected,
              ),
            ),
            ListTile(
              title: const Text("Desde o início"),
              leading: Radio(
                value: _ReportViewPeriod.lifeTime,
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
          onDelete: widget.onDelete,
        ),
      ],
    );
  }

  Map<_ReportViewPeriod, List<String>> createPeriodMap() {
    Map<_ReportViewPeriod, List<String>> periodMap = {};
    periodMap[_ReportViewPeriod.last7] = List.unmodifiable(
      reports.sublist(0, min(7, reports.length)).map((e) => e.id!).toList(),
    );
    periodMap[_ReportViewPeriod.last30] = List.unmodifiable(
      reports.sublist(0, min(30, reports.length)).map((e) => e.id!).toList(),
    );
    periodMap[_ReportViewPeriod.lifeTime] = List.unmodifiable(
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
        if (bottomTitles.isEmpty ||
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

  void onPeriodSelected(_ReportViewPeriod? value) {
    period = value!;
    selected.clear();
    selected.addAll(periodMap[value] ?? []);
    generateSpots();
  }
}
