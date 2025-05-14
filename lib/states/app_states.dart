import 'package:fittrackr/database/entities.dart';
import 'package:fittrackr/states/base_list_state.dart';

// ExercisesState

class ExercisesState extends BaseListState<Exercise> {
  List<Exercise> sorted() {
    final sortedList = super.clone;
    sortedList.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return sortedList;
  }

  List<Exercise> search(String searchStr) {
    return where((e) => _searchFilter(e, searchStr.toLowerCase())).toList();
  }

  bool _searchFilter(Exercise exercise, String searchStr) {
    return exercise.name.toLowerCase().contains(searchStr) ||
           [exercise.reps, exercise.amount, exercise.sets].contains(int.tryParse(searchStr));
  }
}

// TrainingPlanState

class TrainingPlanState extends BaseListState<TrainingPlan> {
  
}

// ReportTableState

class ReportTableState extends BaseListState<ReportTable> {
  
}

// ReportState

class ReportState extends BaseListState<Report> {
  List<Report> getByTable(String tableId) {
    return where((e) => e.tableId == tableId)
    .toList();
  }
}