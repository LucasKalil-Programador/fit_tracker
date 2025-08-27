import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<DatabaseFactory> getDatabaseFactory() async {
  sqfliteFfiInit();
  return databaseFactoryFfi;
}

Future<String> getDatabasePath() async => ':memory:';