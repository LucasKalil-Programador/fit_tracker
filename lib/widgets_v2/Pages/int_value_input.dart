import 'package:fittrackr/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IntValueInput extends StatefulWidget {
  final ValueChanged<int> onChanged;
  final int value;
  final int? min, max;
  final String? label;
  final String? suffix;  

  const IntValueInput({
    super.key,
    required this.onChanged,
    required this.value,
    this.label,
    this.suffix,
    this.max,
    this.min
  });

  @override
  State<IntValueInput> createState() => _IntValueInputState();
}

class _IntValueInputState extends State<IntValueInput> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.value.toString());
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  void didUpdateWidget(covariant IntValueInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    controller.text = widget.value.toString();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: numberInput(localization),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              if(widget.min == null || widget.value > widget.min!) {
                widget.onChanged.call(widget.value - 1);
              }
            },
            child: const Icon(Icons.remove),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              if(widget.max == null || widget.value < widget.max!) {
                widget.onChanged.call(widget.value + 1);
              }
            },
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  Widget numberInput(AppLocalizations localization) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
      decoration: InputDecoration(labelText: widget.label ?? localization.weight, suffixText: widget.suffix ?? localization.kg),
      onChanged: (value) {
        final number = int.tryParse(controller.text);
        if(number == null) {
          widget.onChanged.call(0);
        } else if(widget.min != null && number < widget.min!) {
          widget.onChanged.call(widget.min!);
        } else if(widget.max != null && number > widget.max!) {
          widget.onChanged.call(widget.max!);
        } else {
          widget.onChanged.call(number);
        }
      },
    );
  }
}