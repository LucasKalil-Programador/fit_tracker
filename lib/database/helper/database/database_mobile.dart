import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:path/path.dart';

Future<DatabaseFactory> getDatabaseFactoryMobile() async => databaseFactory;
Future<String> getDatabasePathMobile() async => join(await getDatabasesPath(), 'fittracker.db');

Future<Database> openDatabaseMobile(
  DatabaseFactory dbFactory,
  String path,
  String? password,
  OpenDatabaseOptions options,
) {
  return openDatabase(
    path,
    password: password,
    version: options.version,
    onConfigure: options.onConfigure,
    onCreate: options.onCreate,
    onUpgrade: options.onUpgrade,
    onDowngrade: options.onDowngrade,
    onOpen: options.onOpen,
    readOnly: options.readOnly,
    singleInstance: options.singleInstance,
  );
}
