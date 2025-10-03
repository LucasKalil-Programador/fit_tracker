import 'package:fittrackr/app.dart';
import 'package:fittrackr/states/state_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';

const version = "RC 1.0.1";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final states = StateManager();
  await states.initialize();
  
  runApp(
    ProviderScope(
      child: MultiProvider(
        providers: states.providers(), 
        child: App()
      ),
    ),
  );
}
