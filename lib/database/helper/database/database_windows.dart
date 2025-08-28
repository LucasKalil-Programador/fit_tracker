import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<DatabaseFactory> getDatabaseFactoryDesktop() async {
  sqfliteFfiInit();
  return databaseFactoryFfi;
}

Future<String> getDatabasePathDesktop() async => ':memory:';

Future<Database> openDatabaseDesktop(
  DatabaseFactory dbFactory,
  String path,
  OpenDatabaseOptions options,
) => dbFactory.openDatabase(path, options: options);

