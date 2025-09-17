import 'package:fittrackr/app.dart';
import 'package:fittrackr/states/state_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const version = "1.0.0";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final states = StateManager();
  await states.initialize();
  
  runApp(
    MultiProvider(
      providers: states.providers(),
      child: App(),
    ),
  );
}
