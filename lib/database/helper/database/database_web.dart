import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite_common/sqlite_api.dart';

Future<DatabaseFactory> getDatabaseFactory() async => databaseFactoryFfiWeb;
Future<String> getDatabasePath() async => 'fittracker.db';