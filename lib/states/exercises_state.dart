import 'package:fittrackr/database/entities/exercise.dart';
import 'package:fittrackr/states/base_list_state.dart';

class ExercisesState extends BaseListState<Exercise> {
  List<Exercise> sorted() {
    final sortedList = super.clone;
    sortedList.sort((a, b) => a.name.compareTo(b.name));
    return sortedList;
  }
}