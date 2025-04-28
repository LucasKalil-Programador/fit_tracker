// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
import 'package:fittrackr/database/entities/exercise.dart';
import 'package:fittrackr/database/entities/metadata.dart';
import 'package:fittrackr/database/entities/report.dart';
import 'package:fittrackr/database/entities/tag.dart';
import 'package:fittrackr/database/entities/training_plan.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper with _ExerciseHelper, _MetadataHelper, _TagHelper, _TrainingPlanHelper, _ReportExerciseHelper {
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
          CREATE TABLE training_plan_has_exercise (
            training_plan_id INTEGER NOT NULL,
            exercise_id INTEGER NOT NULL,
            position INTEGER NOT NULL DEFAULT 0,
            PRIMARY KEY (training_plan_id, exercise_id),
            FOREIGN KEY (training_plan_id) REFERENCES training_plan(id) ON DELETE CASCADE,
            FOREIGN KEY (exercise_id) REFERENCES exercise(id) ON DELETE CASCADE
          );
        ''');

        await db.execute('''
          CREATE TABLE exercise_has_tag (
            tag_id INTEGER NOT NULL,
            exercise_id INTEGER NOT NULL,
            PRIMARY KEY (tag_id, exercise_id),
            FOREIGN KEY (tag_id) REFERENCES tag(id) ON DELETE CASCADE,
            FOREIGN KEY (exercise_id) REFERENCES exercise(id) ON DELETE CASCADE
          );
        ''');

        await db.execute('''
          CREATE TABLE training_plan_has_tag (
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

/* CREATE TABLE exercise_has_tag (
  tag_id INTEGER NOT NULL,
  exercise_id INTEGER NOT NULL,
  PRIMARY KEY (tag_id, exercise_id),
  FOREIGN KEY (tag_id) REFERENCES tag(id) ON DELETE CASCADE,
  FOREIGN KEY (exercise_id) REFERENCES exercise(id) ON DELETE CASCADE
); */
  Future<void> setExerciseTagList(Exercise exercise, List<Tag> tags) async {
    final db = await (this as DatabaseHelper).database;
    await db.transaction((txn) async {
      Batch batch = txn.batch();
      var whereArgs = [exercise.id];
      whereArgs.addAll(tags.map((e) => e.id));
      batch.delete(
        'exercise_has_tag',
        where: 'exercise_id = ? AND tag_id NOT IN (${List.filled(tags.length, '?').join(', ')})',
        whereArgs: whereArgs
      );
      for(int i = 0; i < tags.length; i++) {
        batch.insert(
          'exercise_has_tag', 
          {
            'tag_id': tags[i].id,
            'exercise_id': exercise.id
          },
          conflictAlgorithm: ConflictAlgorithm.ignore
        );
      }
      return batch.commit(noResult: true);
    });
  }

  Future<List<Tag>> getExerciseTagList(Exercise exercise) async {
    final db = await (this as DatabaseHelper).database;
    final result = await db.rawQuery(
      '''SELECT t.id, t.name FROM exercise_has_tag 
         INNER JOIN tag t ON tag_id = t.id 
         WHERE exercise_id = ?''',
      [exercise.id]
    );
    return result.map(Tag.fromMap).toList();
  }
}

mixin _MetadataHelper {
  Future<int> insertMetadata(Metadata metadata) async {
    final db = await (this as DatabaseHelper).database;
    metadata.id = await db.insert('metadata', {
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
      {'name': tag.name},
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
      {'name': plan.name},
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

/* CREATE TABLE training_plan_has_exercise (
    training_plan_id INTEGER NOT NULL,
    exercise_id INTEGER NOT NULL,
    position INTEGER NOT NULL DEFAULT 0,
    PRIMARY KEY (training_plan_id, exercise_id),
    FOREIGN KEY (training_plan_id) REFERENCES training_plan(id) ON DELETE CASCADE,
    FOREIGN KEY (exercise_id) REFERENCES exercise(id) ON DELETE CASCADE
); */
  Future<void> setPlanExerciseList(TrainingPlan plan, List<Exercise> exercises) async {
    final db = await (this as DatabaseHelper).database;
    await db.transaction((txn) async {
      Batch batch = txn.batch();
      var whereArgs = [plan.id];
      whereArgs.addAll(exercises.map((e) => e.id));
      batch.delete(
        'training_plan_has_exercise',
        where:
            'training_plan_id = ? AND exercise_id NOT IN (${List.filled(exercises.length, '?').join(', ')})',
        whereArgs: whereArgs,
      );
      for (int i = 0; i < exercises.length; i++) {
        batch.insert(
          'training_plan_has_exercise',
          {
            'training_plan_id': plan.id,
            'exercise_id': exercises[i].id,
            'position': i,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      return await batch.commit(noResult: true);
    });
  }

  Future<List<Exercise>> getPlanExerciseList(TrainingPlan plan) async {
    final db = await (this as DatabaseHelper).database;
    final result = await db.rawQuery(
      '''SELECT position, e.id, e.name, e.amount, e.reps, e.sets, e.type FROM training_plan_has_exercise 
         INNER JOIN exercise e ON exercise_id = e.id 
         WHERE training_plan_id = ?''',
      [plan.id]
    );
    var resultList = result.toList();
    resultList.sort((e1, e2) => (e1['position'] as int).compareTo(e2['position'] as int));

    return resultList.map(Exercise.fromMap).toList();
  }

/* CREATE TABLE training_plan_has_tag (
  tag_id INTEGER NOT NULL,
  training_plan_id INTEGER NOT NULL,
  PRIMARY KEY (tag_id, training_plan_id),
  FOREIGN KEY (tag_id) REFERENCES tag(id) ON DELETE CASCADE,
  FOREIGN KEY (training_plan_id) REFERENCES training_plan(id) ON DELETE CASCADE
); */
  Future<void> setTrainingPlanTagList(TrainingPlan plan, List<Tag> tags) async {
    final db = await (this as DatabaseHelper).database;
    await db.transaction((txn) async {
      Batch batch = txn.batch();
      var whereArgs = [plan.id];
      whereArgs.addAll(tags.map((e) => e.id));
      batch.delete(
        'training_plan_has_tag',
        where:
            'training_plan_id = ? AND tag_id NOT IN (${List.filled(tags.length, '?').join(', ')})',
        whereArgs: whereArgs,
      );
      for (int i = 0; i < tags.length; i++) {
        batch.insert('training_plan_has_tag', {
          'tag_id': tags[i].id,
          'training_plan_id': plan.id,
        }, conflictAlgorithm: ConflictAlgorithm.ignore);
      }
      return batch.commit(noResult: true);
    });
  }

  Future<List<Tag>> getTrainingPlanTagList(TrainingPlan plan) async {
    final db = await (this as DatabaseHelper).database;
    final result = await db.rawQuery(
      '''SELECT t.id, t.name FROM training_plan_has_tag 
         INNER JOIN tag t ON tag_id = t.id
         WHERE training_plan_id = ?
      ''',
      [plan.id]
    );
    return result.map(Tag.fromMap).toList();
  }
}

mixin _ReportExerciseHelper {
  Future<int> insertReport<T>(Report<T> report) async {
    final db = await (this as DatabaseHelper).database;
    
    if(T == Exercise) {
      report.id = await db.insert('report_exercise', {
        'data': report.data,
        'report_date': report.reportDate,
        'exercise_id': (report.object as Exercise).id,
      });
      return report.id!;
    } else if(T == TrainingPlan) {
      report.id = await db.insert('report_training_plan', {
        'data': report.data,
        'report_date': report.reportDate,
        'training_plan_id': (report.object as TrainingPlan).id,
      });
      return report.id!;
    }

    return 0;
  }

  Future<int> deleteReport(Report<Object> report) async {
    final db = await (this as DatabaseHelper).database;
    if(report.object is Exercise) {
      return db.delete('report_exercise', where: 'id = ?', whereArgs: [report.id]);
    } else if(report.object is TrainingPlan) {
      return db.delete('report_training_plan', where: 'id = ?', whereArgs: [report.id]);
    }
    return 0;
  }

  Future<int> updateReport(Report<Object> report) async {
    final db = await (this as DatabaseHelper).database;
    if(report.object is Exercise) {
      return await db.update('report_exercise', 
      {
        'data': report.data,
        'report_date': report.reportDate,
        'exercise_id': (report.object as Exercise).id,
      },
      where: 'id = ?',
      whereArgs: [report.id]
      );
    } else if(report.object is TrainingPlan) {
      return await db.update('report_training_plan', 
      {
        'data': report.data,
        'report_date': report.reportDate,
        'training_plan_id': (report.object as TrainingPlan).id,
      },
      where: 'id = ?',
      whereArgs: [report.id]
      );
    }
    return 0;
  }

  Future<List<Report<T>>> selectAllReport<T>() async {
    final db = await (this as DatabaseHelper).database;
    if(T == Exercise) {
      final result = await db.rawQuery('''
        SELECT r.id, r.data, r.report_date, r.exercise_id, e.name, e.amount, e.reps, e.sets, e.type FROM report_exercise r 
        INNER JOIN exercise e ON e.id = r.exercise_id
      ''');
      return result.map(Report.fromMap<T>).toList();
    } else if(T == TrainingPlan) {
      final result = await db.rawQuery('''
        SELECT r.id, r.data, r.report_date, r.training_plan_id, e.name FROM report_training_plan r 
        INNER JOIN training_plan e ON e.id = r.training_plan_id
      ''');
      return result.map(Report.fromMap<T>).toList();
    }

    return List.empty(growable: true);
  }

  Future<Report<T>?> selectReport<T>(int id) async {
    final db = await (this as DatabaseHelper).database;
    if(T == Exercise) {
      final result = await db.rawQuery('''
          SELECT r.id, r.data, r.report_date, r.exercise_id, e.name, e.amount, e.reps, e.sets, e.type FROM report_exercise r 
          INNER JOIN exercise e ON e.id = r.exercise_id
          WHERE r.id = ?
        ''', [id]);
      return result.isNotEmpty ? Report.fromMap<T>(result.first) : null;
    } else if(T == TrainingPlan) {
      final result = await db.rawQuery('''
        SELECT r.id, r.data, r.report_date, r.training_plan_id, e.name FROM report_training_plan r 
        INNER JOIN training_plan e ON e.id = r.training_plan_id
        WHERE r.id = ?
      ''', [id]);
      return result.isNotEmpty ? Report.fromMap<T>(result.first) : null;
    }
    return null;
  }
}

/* 
- exercise                   Implementado
- training_plan              Implementado
- tag                        Implementado
- metadata                   Implementado
- report_exercise            Implementado
- report_training_plan       Implementado
- training_plan_has_exercise Implementado
- exercise_has_tag           Implementado
- training_plan_has_tag      Implementado

Insert
delete
update
selectAll
selectOne(id)
*/

