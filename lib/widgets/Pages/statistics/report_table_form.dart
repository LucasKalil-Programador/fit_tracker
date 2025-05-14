import 'package:fittrackr/database/entities.dart';
import 'package:flutter/material.dart';

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
