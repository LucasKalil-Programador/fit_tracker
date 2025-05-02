import 'package:fittrackr/database/entities/exercise.dart';
import 'package:fittrackr/states/base_list_state.dart';

class ExercisesState extends BaseListState<Exercise> {
  List<Exercise> sorted() {
    final sortedList = super.clone;
    sortedList.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return sortedList;
  }

  List<Exercise> search(String searchStr) {
    return sorted()
      .where((e) => _searchFilter(e, searchStr.toLowerCase()))
      .toList();
  }

  bool _searchFilter(Exercise exercise, String searchStr) {
    return exercise.name.toLowerCase().contains(searchStr) ||
           [exercise.reps, exercise.amount, exercise.sets].contains(int.tryParse(searchStr));
  }
}