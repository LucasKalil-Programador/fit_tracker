import 'package:fittrackr/database/entities/report.dart';
import 'package:fittrackr/database/entities/report_table.dart';
import 'package:fittrackr/widgets/common/value_input_double_widget.dart';
import 'package:flutter/material.dart';

class ReportForm extends StatefulWidget {
  final void Function(Report report)? onSubmit;
  final ReportTable table;


  ReportForm({
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
          style: const TextStyle(fontWeight: FontWeight.bold),
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
  