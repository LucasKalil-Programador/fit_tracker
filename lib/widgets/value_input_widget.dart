import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class ValueInputWidget extends StatefulWidget {
  final ValueChanged<int>? onChanged;

  final String label, suffix;
  final int minValue, maxValue;
  final int? initialValue;

  const ValueInputWidget({
    super.key,
    this.label = "Peso",
    this.suffix = "Kg",
    this.initialValue,
    this.minValue = 1,
    this.maxValue = 32,
    this.onChanged,
  });

  @override
  State<ValueInputWidget> createState() => _ValueInputWidgetState();
}

class _ValueInputWidgetState extends State<ValueInputWidget> {
  final TextEditingController _controller = TextEditingController(text: '1');

  int _value = 1;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) _value = widget.initialValue!;
    _controller.text = _value.toString();
    widget.onChanged!.call(_value);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: numberInput(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: decrementButton(),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: incrementButton(),
        ),
      ],
    );
  }

  TextFormField numberInput() {
    return TextFormField(
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
                final parsed = int.tryParse(val);
                if(parsed != null && parsed >= widget.minValue) {
                    _value = parsed > widget.maxValue ? widget.maxValue : parsed;
                    widget.onChanged?.call(_value);
                }
              });
            },
          );
  }

  Widget decrementButton() {
    return ElevatedButton(
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
        );
  }

  Widget incrementButton() {
    return ElevatedButton(
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
        );
  }
}
