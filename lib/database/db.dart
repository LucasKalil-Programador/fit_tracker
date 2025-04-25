import 'package:fittrackr/entities/exercise.dart';
import 'package:fittrackr/entities/timer.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            load INTEGER NOT NULL,
            reps INTEGER NOT NULL,
            sets INTEGER NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE timer(
            id INTEGER PRIMARY KEY AUTOINCREMENT ,
            paused_time INTEGER,
            start_time INTEGER,
            paused INTEGER
          )
        ''');
      },
    );
  }

  Future<int> insertExercise(Exercise exercise) async {
    final db = await database;
    exercise.id = await db.insert('exercise', {'name': exercise.name, 'load': exercise.load, 'reps': exercise.reps, 'sets': exercise.sets});
    return exercise.id!;
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

  Future<int> insertTimer(Timer timer) async {
    final db = await database;
    int id = await db.insert('timer', {
      'start_time': timer.startTime?.millisecondsSinceEpoch,
      'paused_time': timer.pausedTime?.millisecondsSinceEpoch,
      'paused': timer.paused ? 1 : 0,
    });
    timer.id = id;
    return id;
  }

  Future<int> updateTimer(Timer timer) async {
    final db = await database;
    return db.update('timer', {
      'start_time': timer.startTime?.millisecondsSinceEpoch,
      'paused_time': timer.pausedTime?.millisecondsSinceEpoch,
      'paused': timer.paused? 1 : 0
    },
    where: 'id = ?',
    whereArgs: [timer.id]
    );
  }

  Future<Timer?> selectOne(int id) async {
    final db = await database;
    final result = await db.query('timer', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? Timer.fromMap(result.first): null;
  }
}