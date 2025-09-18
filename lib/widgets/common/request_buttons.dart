import 'package:fittrackr/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class RequestButtons extends StatefulWidget {
  final Function(bool) onPressed;
  final int waitTimeSeconds;

  final String? messageText;
  final String? rejectText;
  final String? acceptText;

  final Color? rejectButtonColor;
  final Color? acceptButtonColor;

  const RequestButtons({
    super.key,
    required this.onPressed,
    this.waitTimeSeconds = 5,
    this.rejectText,
    this.acceptText,
    this.messageText,
    this.rejectButtonColor, 
    this.acceptButtonColor,
  });

  @override
  State<RequestButtons> createState() => _RequestButtonsState();
}

class _RequestButtonsState extends State<RequestButtons> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isDisposed = false;
  bool isSubmited = false;
  late DateTime startTime;
  late int secondsLest;

  @override
  void initState() {
    startTime = DateTime.now();
    secondsLest = widget.waitTimeSeconds;
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.waitTimeSeconds),
    );
    _controller.addListener(() {
      setState(() {
        secondsLest = widget.waitTimeSeconds - DateTime.now().difference(startTime).inSeconds;
        if(secondsLest <= 0) disposeAnimation();
      });
    });
    _controller.repeat();
  }

  @override
  void dispose() {
    disposeAnimation();
    super.dispose();
  }

  void disposeAnimation() {
    if(!isDisposed) _controller.dispose();
    isDisposed = true;
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(widget.messageText ?? localization.acceptTermsMessage),
        ),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.rejectButtonColor,
                ),
                onPressed: () => onSubmit(false),
                child: Text(widget.rejectText ?? localization.reject, textAlign: TextAlign.center),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: secondsLest <= 0 ? widget.acceptButtonColor : Colors.grey,
                ),
                onPressed: () => onSubmit(true),
                child: secondsLest <= 0 ? Text(widget.acceptText ?? localization.accept, textAlign: TextAlign.center,) : Text(localization.secondsLeft(secondsLest)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void onSubmit(bool result) {
    if(isSubmited) return;
    isSubmited = true;
    widget.onPressed(result);
  }
}