import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class ValueInputWidget extends StatefulWidget {
  final ValueChanged<int>? onChanged;

  final String label;
  final String suffix;

  final int minValue;
  final int maxValue;

  const ValueInputWidget({super.key, this.label = "Peso", this.suffix = "Kg", this.minValue = 1, this.maxValue = 32, this.onChanged});

  @override
  State<ValueInputWidget> createState() => _ValueInputWidgetState();
}

class _ValueInputWidgetState extends State<ValueInputWidget> {
  int _value = 1;
  final TextEditingController _controller = TextEditingController(text: '1');

  @override
  Widget build(BuildContext context) {
    widget.onChanged!.call(_value);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: TextFormField(
              controller: _controller,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(labelText: widget.label, suffixText: widget.suffix),
              validator: (value) {
                if (_value < widget.minValue || _value > widget.maxValue) {
                    return 'Valor invalido';
                  }
                  return null;
              },
              onChanged: (val) {
                setState(() {
                  _value = int.tryParse(val) ?? 0;
                  if(_value > widget.maxValue) {
                    _value = widget.maxValue;
                  }
                  widget.onChanged?.call(_value);
                  _controller.text = _value.toString();
                });
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                if (_value > widget.minValue) { 
                  _value--;
                  _controller.text = _value.toString();
                  widget.onChanged?.call(_value);
                }
              });
            },
            child: const Icon(Icons.remove),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                if(_value < widget.maxValue) {
                  _value++;
                  _controller.text = _value.toString();
                  widget.onChanged?.call(_value);
                }
              });
            },
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
