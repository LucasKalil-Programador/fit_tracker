import 'package:fittrackr/database/entities.dart';
import 'package:fittrackr/states/base_list_state.dart';

class ExercisesState extends BaseListState<Exercise> {
  ExercisesState({super.dbProxy, super.loadDatabase, super.useRollback});

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

class ReportState extends BaseListState<Report> {
  ReportState({super.dbProxy, super.loadDatabase, super.useRollback});

  List<Report> getByTable(String tableId) => where((e) => e.tableId == tableId).toList();
}

class TrainingPlanState extends BaseListState<TrainingPlan> { TrainingPlanState({super.dbProxy, super.loadDatabase, super.useRollback}); }

class ReportTableState extends BaseListState<ReportTable> { ReportTableState({super.dbProxy, super.loadDatabase, super.useRollback}); }
