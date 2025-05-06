import 'package:fittrackr/database/entities/report.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ReportTableView extends StatefulWidget {
  final List<Report> reports;
  final List<String> selected;
  final void Function(List<String>)? onSelectedChanged;
  final void Function(List<Report>)? onReportSorted;
  final String? suffix;

  const ReportTableView({super.key, required this.reports, required this.selected, this.suffix, this.onSelectedChanged, this.onReportSorted});

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
    final reportSource = ReportSource(
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
    );

    return PaginatedDataTable(
      header: Text("Tabela de completa"),
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

class ReportSource extends DataTableSource implements ValueListenable {
  final List<Report> data;
  final List<String> selected;
  final String suffix;

  final void Function(Report)? onPressNote;
  final void Function(List<String>)? onSelectedChanged;

  ReportSource({required this.data, required this.selected, required this.suffix, this.onPressNote, this.onSelectedChanged});

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
      text = text + "...";
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