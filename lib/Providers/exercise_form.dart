import 'package:fittrackr/Models/exercise.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'exercise_form.g.dart';

@Riverpod(keepAlive: true)
class ExerciseFormController extends _$ExerciseFormController {
  @override
  FormData build() {
    return const FormData(
      type: ExerciseType.musclework,
      name: "",
      amount: 1,
      sets: 1,
      reps: 1,
    );
  }

  void update(FormData newData) {
    state = newData;
  }

  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  void updateType(ExerciseType type) {
    state = state.copyWith(type: type);
  }

  void updateAmount(int amount) {
    state = state.copyWith(amount: amount);
  }

  void updateSets(int sets) {
    state = state.copyWith(sets: sets);
  }

  void updateReps(int reps) {
    state = state.copyWith(reps: reps);
  }

  void clear() {
    state = build();
  }
}

class FormData {
  final ExerciseType type;
  final String name;
  final int amount;
  final int sets;
  final int reps;

  const FormData({
    required this.type,
    required this.amount,
    required this.name,
    required this.sets,
    required this.reps,
  });

  FormData copyWith({
    ExerciseType? type,
    String? name,
    int? amount,
    int? sets,
    int? reps,
  }) {
    return FormData(
      type: type ?? this.type,
      amount: amount ?? this.amount,
      name: name ?? this.name,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
    );
  }
}
