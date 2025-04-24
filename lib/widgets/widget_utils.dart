import 'package:flutter/material.dart';

void showSnackMessage(BuildContext context, String message, bool sucess) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: sucess 
              ? Theme.of(context).colorScheme.onSurface 
              : Theme.of(context).colorScheme.error,
      ),
    );
  }