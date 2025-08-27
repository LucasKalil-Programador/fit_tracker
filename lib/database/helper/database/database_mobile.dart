import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<DatabaseFactory> getDatabaseFactory() async => databaseFactory;
Future<String> getDatabasePath() async => join(await getDatabasesPath(), 'fittracker.db');