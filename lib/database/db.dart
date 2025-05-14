// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DatabaseHelper {

  final createTableSql = '''
          CREATE TABLE exercise(
            uuid TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            amount INTEGER NOT NULL,
            reps INTEGER NOT NULL,
            sets INTEGER NOT NULL,
            type TEXT NOT NULL CHECK(type IN ('Cardio', 'Musclework'))
          );
          <query>
          CREATE TABLE training_plan(
            uuid TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            list TEXT NOT NULL
          );
          <query>
          CREATE TABLE metadata(
            key TEXT PRIMARY KEY,
            value TEXT NOT NULL
          );
        ''';

  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if(_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final sqlQuerys = createTableSql.split('<query>');

    final path = join(await getDatabasesPath(), 'fittracker.db');
    
    // databaseFactory = databaseFactoryFfi;
    // final path = ":memory:";

    return await openDatabase(
      path, 
      version: 1,
      onCreate: (db, version) async {
        for (var query in sqlQuerys) {
          await db.execute(query);
        }
      },
    );
  }
}
