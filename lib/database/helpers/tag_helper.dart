/* // import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';

import 'package:fittrackr/database/db.dart';
import 'package:fittrackr/database/entities/base_entity.dart';
import 'package:fittrackr/database/entities/exercise.dart';
import 'package:fittrackr/database/entities/tag.dart';
import 'package:fittrackr/database/entities/training_plan.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

mixin TagHelper {
  Future<int> insertTag(Tag tag) async {
    final db = await (this as DatabaseHelper).database;
    tag.id = await db.insert('tag', {'name': tag.name});
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

  /* CREATE TABLE training_plan_has_tag (
  tag_id INTEGER NOT NULL,
  training_plan_id INTEGER NOT NULL,
  PRIMARY KEY (tag_id, training_plan_id),
  FOREIGN KEY (tag_id) REFERENCES tag(id) ON DELETE CASCADE,
  FOREIGN KEY (training_plan_id) REFERENCES training_plan(id) ON DELETE CASCADE
); 
CREATE TABLE exercise_has_tag (
  tag_id INTEGER NOT NULL,
  exercise_id INTEGER NOT NULL,
  PRIMARY KEY (tag_id, exercise_id),
  FOREIGN KEY (tag_id) REFERENCES tag(id) ON DELETE CASCADE,
  FOREIGN KEY (exercise_id) REFERENCES exercise(id) ON DELETE CASCADE
); */
  Future<void> setTagList<T extends BaseEntity>(T entity, List<Tag> tags) async {
    final db = await (this as DatabaseHelper).database;
    if(T == Exercise || T == TrainingPlan) {
      final table = T == Exercise ? 'exercise_has_tag' : 'training_plan_has_tag';
      final column = T == Exercise ? 'exercise_id' : 'training_plan_id';
      await db.transaction((txn) async {
        Batch batch = txn.batch();
        var whereArgs = [entity.id];
        whereArgs.addAll(tags.map((e) => e.id));
        batch.delete(
          table,
          where:
              '$column = ? AND tag_id NOT IN (${List.filled(tags.length, '?').join(', ')})',
          whereArgs: whereArgs,
        );
        for (int i = 0; i < tags.length; i++) {
          batch.insert(table, {
            'tag_id': tags[i].id,
            '$column': entity.id,
          }, conflictAlgorithm: ConflictAlgorithm.ignore);
        }
        return batch.commit(noResult: true);
      });
    }
  }

  Future<List<Tag>> getTagList<T extends BaseEntity>(T entity) async {
    final db = await (this as DatabaseHelper).database;
    if (T == Exercise || T == TrainingPlan) {
      final query = T == Exercise ? '''
         SELECT t.id, t.name FROM exercise_has_tag 
         INNER JOIN tag t ON tag_id = t.id 
         WHERE exercise_id = ? 
         ''' : '''
         SELECT t.id, t.name FROM training_plan_has_tag 
         INNER JOIN tag t ON tag_id = t.id
         WHERE training_plan_id = ?
      ''';
      final result = await db.rawQuery(query, [entity.id],);
      return result.map(Tag.fromMap).toList();
    }
    return List.empty();
  }
}
 */