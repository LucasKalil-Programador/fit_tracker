import 'package:fittrackr/entities/exercise.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class DatabaseHelper {
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
    final path = join(await getDatabasesPath(), 'fittracker.db');

    return await openDatabase(
      path, 
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE exercise(
            id TEXT PRIMARY KEY,
            name TEXT,
            load INTEGER,
            reps INTEGER,
            sets INTEGER
          )
        ''');
      },
    );
  }

  Future<int> insertExercise(Exercise exercise) async {
    final db = await database;
    final id = Uuid().v4();
    exercise.id = id;
    return await db.insert('exercise', {'id': id, 'name': exercise.name, 'load': exercise.load, 'reps': exercise.reps, 'sets': exercise.sets});
  }

  Future<int> deleteExercise(Exercise exercise) async {
    final db = await database;
    return await db.delete('exercise', where: 'id = ?', whereArgs: [exercise.id]);
  }

  Future<int> updateExercise(Exercise exercise) async {
    final db = await database;
    return db.update(
      'exercise',
      {
        'name': exercise.name,
        'load': exercise.load,
        'reps': exercise.reps,
        'sets': exercise.sets,
      },
      where: 'id = ?',
      whereArgs: [exercise.id],
    );
  }

  Future<int> clearExercise() async {
    final db = await database;
    return db.delete('exercise');
  }

  Future<List<Exercise>> selectAll() async {
    final db = await database;
    final result = await db.query(
      'exercise',
      orderBy: 'name ASC'
    );

    return result.map((e) => Exercise.fromMap(e)).toList();
  }
}