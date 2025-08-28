import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite_common/sqlite_api.dart';

Future<DatabaseFactory> getDatabaseFactoryWeb() async => databaseFactoryFfiWeb;
Future<String> getDatabasePathWeb() async => 'fittracker.db';

Future<Database> openDatabaseWeb(
  DatabaseFactory dbFactory,
  String path,
  OpenDatabaseOptions options,
) => dbFactory.openDatabase(path, options: options);

