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
          <query>
          CREATE TABLE report_exercise(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            data TEXT NOT NULL,
            report_date INTEGER NOT NULL,
            exercise_id INTEGER NOT NULL,
            FOREIGN KEY (exercise_id) REFERENCES exercise(id)
          );
          <query>
          CREATE TABLE report_training_plan(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            data TEXT NOT NULL,
            report_date INTEGER NOT NULL,
            training_plan_id INTEGER NOT NULL,
            FOREIGN KEY (training_plan_id) REFERENCES training_plan(id)
          );
          <query>
          CREATE TABLE training_plan_has_exercise (
            training_plan_id INTEGER NOT NULL,
            exercise_id INTEGER NOT NULL,
            position INTEGER NOT NULL DEFAULT 0,
            PRIMARY KEY (training_plan_id, exercise_id),
            FOREIGN KEY (training_plan_id) REFERENCES training_plan(id) ON DELETE CASCADE,
            FOREIGN KEY (exercise_id) REFERENCES exercise(id) ON DELETE CASCADE
          );
          <query>
          CREATE TABLE exercise_has_tag (
            tag_id INTEGER NOT NULL,
            exercise_id INTEGER NOT NULL,
            PRIMARY KEY (tag_id, exercise_id),
            FOREIGN KEY (tag_id) REFERENCES tag(id) ON DELETE CASCADE,
            FOREIGN KEY (exercise_id) REFERENCES exercise(id) ON DELETE CASCADE
          );
          <query>
          CREATE TABLE training_plan_has_tag (
            tag_id INTEGER NOT NULL,
            training_plan_id INTEGER NOT NULL,
            PRIMARY KEY (tag_id, training_plan_id),
            FOREIGN KEY (tag_id) REFERENCES tag(id) ON DELETE CASCADE,
            FOREIGN KEY (training_plan_id) REFERENCES training_plan(id) ON DELETE CASCADE
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
