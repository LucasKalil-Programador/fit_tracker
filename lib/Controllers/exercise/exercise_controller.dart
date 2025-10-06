import 'package:fittrackr/Models/exercise.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'exercise_controller.g.dart';

@Riverpod(keepAlive: true)
class ExerciseController extends _$ExerciseController {
  @override
  List<Exercise> build() => const [];

  String _generateUniqueId() {
    final existingIds = state.map((e) => e.id).toSet();
    String newId;
    do {
      newId = const Uuid().v4();
    } while (existingIds.contains(newId));
    return newId;
  }

  Exercise add(Exercise exercise) {
    final existingIds = state.map((e) => e.id).toSet();

    final id = (exercise.id != null && !existingIds.contains(exercise.id))
        ? exercise.id!
        : _generateUniqueId();

    final newExercise = exercise.withValues(id: id);
    state = List.unmodifiable([...state, newExercise]);
    return newExercise;
  }

  bool updateById(String id, Exercise newExercise) {
    final index = state.indexWhere((e) => e.id == id);
    if (index == -1) return false;

    state = List.unmodifiable([
      for (int i = 0; i < state.length; i++)
        if (i == index)
          newExercise.withValues(id: id)
        else
          state[i],
    ]);
    return true;
  }

  void removeById(String id) {
    state = List.unmodifiable(
      state.where((e) => e.id != id),
    );
  }

  void clear() {
    state = const [];
  }
}
