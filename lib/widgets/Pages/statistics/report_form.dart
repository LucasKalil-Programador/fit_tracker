import 'package:fittrackr/database/entities/report_table.dart';
import 'package:fittrackr/l10n/app_localizations.dart';
import 'package:fittrackr/widgets/common/value_input_double_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportForm extends StatefulWidget {
  final void Function(Report report)? onSubmit;
  final void Function(Report? report)? onDispose;
  final ReportTable table;
  final Report? baseReport;

  const ReportForm({
    super.key, required this.table, this.baseReport, this.onSubmit, this.onDispose  
  });

  @override
  State<ReportForm> createState() => _ReportFormState();
}

class _ReportFormState extends State<ReportForm> {
  late AppLocalizations localization;
  final _noteController = TextEditingController(text: "");

  DateTime selectedDate = DateTime.now();
  double value = 0;

  bool submited = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if(widget.baseReport != null) {
      _noteController.text = widget.baseReport!.note;
      value = widget.baseReport!.value;
      selectedDate = DateTime.fromMillisecondsSinceEpoch(widget.baseReport!.reportDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localization.reportValue,
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
                  label: localization.value,
                  suffix: widget.table.valueSuffix,
                  minValue: -1_000_000_000,
                  maxValue: 1_000_000_000,
                  initialValue: value,
                  onChanged: (value) => this.value = value,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: selectedDateDisplay(selectedDate),
              ),
              datetimeSelectorButtons(context),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: submitButton(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget datetimeSelectorButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.calendar_today),
          label: const Text("Select Date"),
          onPressed: () async {
            final DateTime? date = await showDatePicker(
              context: context,
              firstDate: DateTime.fromMillisecondsSinceEpoch(0),
              lastDate: DateTime.now(),
              initialDate: selectedDate,
            );
            if (date != null) {
              setState(() {
                selectedDate = selectedDate.copyWith(
                  day: date.day,
                  month: date.month,
                  year: date.year,
                );
              });
            }
          },
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.access_time),
          label: const Text("Select Time"),
          onPressed: () async {
            final TimeOfDay? time = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.fromDateTime(selectedDate),
            );
            if (time != null) {
              setState(() {
                selectedDate = selectedDate.copyWith(
                  hour: time.hour,
                  minute: time.minute,
                );
              });
            }
          },
        ),
      ],
    );
  }

  Widget selectedDateDisplay(DateTime selectedDate) {
    final dateText = DateFormat.yMMMMd().format(selectedDate); // ex: September 17, 2025
    final timeText = DateFormat.Hm().format(selectedDate);    // ex: 14:05

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Selected Date:",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(dateText),
        Text(timeText),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    if(widget.onDispose != null) {
      widget.onDispose!(submited ? null : getReport());
    }
  }

  Widget noteInput() {
    return TextFormField(
      controller: _noteController,
      decoration: InputDecoration(labelText: localization.notes),
      maxLines: 6,
      validator: (value) {
        if (value == null || value.length > 500) {
          return localization.invalidNote;
        }
        return null;
      },
    );
  }

  Widget submitButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          submited = true;
          if(widget.onSubmit != null) {
            widget.onSubmit!(getReport());
          }
        }
      },
      child: Text(localization.add),
    );
  }

  Report getReport() {
    return Report(
      value: value,
      note: _noteController.text,
      tableId: widget.table.id!,
      reportDate: selectedDate.millisecondsSinceEpoch,
    );
  }
}
