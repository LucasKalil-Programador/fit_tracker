import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class ValueInputDoubleWidget extends StatefulWidget {
  final ValueChanged<double>? onChanged;

  final String label, suffix;
  final double minValue, maxValue;
  final double? initialValue;

  const ValueInputDoubleWidget({
    super.key,
    this.label = "Peso",
    this.suffix = "Kg",
    this.initialValue,
    this.minValue = 1,
    this.maxValue = 32,
    this.onChanged,
  });

  @override
  State<ValueInputDoubleWidget> createState() => _ValueInputDoubleWidgetState();
}

class _ValueInputDoubleWidgetState extends State<ValueInputDoubleWidget> {
  final TextEditingController _controller = TextEditingController(text: '1');

  double _value = 1;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) _value = widget.initialValue!;
    _controller.text = _value.toString();
    if(widget.onChanged != null) widget.onChanged!.call(_value);
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
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
            decoration: InputDecoration(labelText: widget.label, suffixText: widget.suffix),
            validator: (value) {
              if (_value < widget.minValue || _value > widget.maxValue) {
                  return 'Valor invalido';
                }
                return null;
            },
            onChanged: (val) {
              val = val.replaceAll(",", ".");
              setState(() {
                final parsed = double.tryParse(val);
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
                _value -= 0.5;
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
                _value += 0.5;
                _controller.text = _value.toString();
                widget.onChanged?.call(_value);
              }
            });
          },
          child: const Icon(Icons.add),
        );
  }
}
