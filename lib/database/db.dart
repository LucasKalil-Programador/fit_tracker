// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
import 'package:fittrackr/database/entities/exercise.dart';
import 'package:fittrackr/database/entities/metadata.dart';
import 'package:fittrackr/database/entities/tag.dart';
import 'package:fittrackr/database/entities/training_plan.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper with _ExerciseHelper, _MetadataHelper, _TagHelper, _TrainingPlanHelper {
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
    //final path = join(await getDatabasesPath(), 'fittracker.db');

    final path = ":memory:";
    databaseFactory = databaseFactoryFfi;

    return await openDatabase(
      path, 
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE exercise(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            amount INTEGER NOT NULL,
            reps INTEGER NOT NULL,
            sets INTEGER NOT NULL,
            type TEXT NOT NULL CHECK(type IN ('Cardio', 'Musclework'))
          )
        ''');

        await db.execute('''
          CREATE TABLE training_plan(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE tag(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL UNIQUE
          )
        ''');
        
        await db.execute('''
          CREATE TABLE metadata(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            key TEXT NOT NULL UNIQUE,
            value TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE report_exercise(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            data TEXT NOT NULL,
            report_date INTEGER NOT NULL,
            exercise_id INTEGER NOT NULL,
            FOREIGN KEY (exercise_id) REFERENCES exercise(id)
          )
        ''');

        await db.execute('''
          CREATE TABLE report_training_plan(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            data TEXT NOT NULL,
            report_date INTEGER NOT NULL,
            training_plan_id INTEGER NOT NULL,
            FOREIGN KEY (training_plan_id) REFERENCES training_plan(id)
          )
        ''');

        await db.execute('''
          CREATE TABLE exercise_training_plan (
            training_plan_id INTEGER NOT NULL,
            exercise_id INTEGER NOT NULL,
            position INTEGER NOT NULL DEFAULT 0,
            PRIMARY KEY (training_plan_id, exercise_id),
            FOREIGN KEY (training_plan_id) REFERENCES training_plan(id) ON DELETE CASCADE,
            FOREIGN KEY (exercise_id) REFERENCES exercise(id) ON DELETE CASCADE
          );
        ''');

        await db.execute('''
          CREATE TABLE exercise_tag (
            tag_id INTEGER NOT NULL,
            exercise_id INTEGER NOT NULL,
            PRIMARY KEY (tag_id, exercise_id),
            FOREIGN KEY (tag_id) REFERENCES tag(id) ON DELETE CASCADE,
            FOREIGN KEY (exercise_id) REFERENCES exercise(id) ON DELETE CASCADE
          );
        ''');

        await db.execute('''
          CREATE TABLE training_plan_tag (
            tag_id INTEGER NOT NULL,
            training_plan_id INTEGER NOT NULL,
            PRIMARY KEY (tag_id, training_plan_id),
            FOREIGN KEY (tag_id) REFERENCES tag(id) ON DELETE CASCADE,
            FOREIGN KEY (training_plan_id) REFERENCES training_plan(id) ON DELETE CASCADE
          );
        ''');
      },
    );
  }
}

mixin _ExerciseHelper {
  Future<int> insertExercise(Exercise exercise) async {
    final db = await (this as DatabaseHelper).database;
    exercise.id = await db.insert('exercise', {
      'id': exercise.id,
      'name': exercise.name,
      'amount': exercise.amount,
      'reps': exercise.reps,
      'sets': exercise.sets,
      'type': exercise.type.name,
    });
    return exercise.id!;
  }

  Future<int> deleteExercise(Exercise exercise) async {
    final db = await (this as DatabaseHelper).database;
    return await db.delete('exercise', where: 'id = ?', whereArgs: [exercise.id]);
  }

  Future<int> updateExercise(Exercise exercise) async {
    final db = await (this as DatabaseHelper).database;
    return db.update(
      'exercise',
      {
        'id': exercise.id,
        'name': exercise.name,
        'amount': exercise.amount,
        'reps': exercise.reps,
        'sets': exercise.sets,
        'type': exercise.type.name,
      },
      where: 'id = ?',
      whereArgs: [exercise.id],
    );
  }

  Future<List<Exercise>> selectAllExercise() async {
    final db = await (this as DatabaseHelper).database;
    final result = await db.query(
      'exercise',
      orderBy: 'name ASC'
    );

    return result.map(Exercise.fromMap).toList();
  }

  Future<Exercise?> selectExercise(int id) async {
    final db = await (this as DatabaseHelper).database;
    final result = await db.query('exercise', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? Exercise.fromMap(result.first) : null;
  }
}

mixin _MetadataHelper {
  Future<int> insertMetadata(Metadata metadata) async {
    final db = await (this as DatabaseHelper).database;
    metadata.id = await db.insert('metadata', {
      'id': metadata.id,
      'key': metadata.key,
      'value': metadata.value,
    });
    return metadata.id!;
  }

  Future<int> deleteMetadata(Metadata metadata) async {
    final db = await (this as DatabaseHelper).database;
    return await db.delete('metadata', where: 'id = ?', whereArgs: [metadata.id]);
  }
  
  Future<int> updateMetadata(Metadata metadata) async {
    final db = await (this as DatabaseHelper).database;
    return db.update(
      'metadata',
      {
      'id': metadata.id, 
      'key': metadata.key, 
      'value': metadata.value
      },
      where: 'id = ?',
      whereArgs: [metadata.id],
    );
  }

  Future<List<Metadata>> selectAllMetadata() async {
    final db = await (this as DatabaseHelper).database;
    final result = await db.query('metadata');
    return result.map(Metadata.fromMap).toList();
  }

  Future<Metadata?> selectMetadata(int id) async {
    final db = await (this as DatabaseHelper).database;
    final result = await db.query('metadata', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? Metadata.fromMap(result.first) : null;
  }
}

mixin _TagHelper {
  Future<int> insertTag(Tag tag) async {
    final db = await (this as DatabaseHelper).database;
    tag.id = await db.insert('tag', {
      'id': tag.id,
      'name': tag.name,
    });
    return tag.id!;
  }

  Future<int> deleteTag(Tag tag) async {
    final db = await (this as DatabaseHelper).database;
    return db.delete('tag', where: 'id = ?', whereArgs: [tag.id]);
  }

  Future<int> updateTag(Tag tag) async {
    final db = await (this as DatabaseHelper).database;
    return await db.update(
      'tag',
      {'id': tag.id, 'name': tag.name},
      where: 'id = ?',
      whereArgs: [tag.id],
    );
  }

  Future<List<Tag>> selectAllTag() async {
    final db = await (this as DatabaseHelper).database;
    final result = await db.query('tag');
    return result.map(Tag.fromMap).toList();
  }

  Future<Tag?> selectTag(int id) async {
    final db = await (this as DatabaseHelper).database;
    final result = await db.query('tag', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? Tag.fromMap(result.first) : null;
  }
}

mixin _TrainingPlanHelper {
  Future<int> insertTrainingPlan(TrainingPlan plan) async {
    final db = await (this as DatabaseHelper).database;
    plan.id = await db.insert('training_plan', {
      'id': plan.id,
      'name': plan.name,
    });
    return plan.id!;
  }

  Future<int> deleteTrainingPlan(TrainingPlan plan) async {
    final db = await (this as DatabaseHelper).database;
    return db.delete('training_plan', where: 'id = ?', whereArgs: [plan.id]);
  }

  Future<int> updateTrainingPlan(TrainingPlan plan) async {
    final db = await (this as DatabaseHelper).database;
    return await db.update(
      'training_plan',
      {'id': plan.id, 'name': plan.name},
      where: 'id = ?',
      whereArgs: [plan.id],
    );
  }

  Future<List<TrainingPlan>> selectAllTrainingPlan() async {
    final db = await (this as DatabaseHelper).database;
    final result = await db.query('training_plan');
    return result.map(TrainingPlan.fromMap).toList();
  }

  Future<TrainingPlan?> selectTrainingPlan(int id) async {
    final db = await (this as DatabaseHelper).database;
    final result = await db.query('training_plan', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? TrainingPlan.fromMap(result.first) : null;
  }
}

/* 
- exercise                Implementado
- training_plan           Implementado
- tag                     Implementado
- metadata                Implementado
- report_exercise
- report_training_plan
- exercise_training_plan
- exercise_tag
- training_plan_tag 

Insert
delete
update
selectAll
selectOne(id)
*/

