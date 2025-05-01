// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DatabaseHelper {

  final create_table_sql = '''
          CREATE TABLE exercise(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            amount INTEGER NOT NULL,
            reps INTEGER NOT NULL,
            sets INTEGER NOT NULL,
            type TEXT NOT NULL CHECK(type IN ('Cardio', 'Musclework'))
          );
          <query>
          CREATE TABLE training_plan(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL
          );
          <query>
          CREATE TABLE tag(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL UNIQUE
          );
          <query>
          CREATE TABLE metadata(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            key TEXT NOT NULL UNIQUE,
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
    final sql_querys = create_table_sql.split('<query>');

    final path = join(await getDatabasesPath(), 'fittracker.db');
    
    // databaseFactory = databaseFactoryFfi;
    // final path = ":memory:";

    return await openDatabase(
      path, 
      version: 1,
      onCreate: (db, version) async {
        for (var query in sql_querys) await db.execute(query);
      },
    );
  }
}
