import 'package:fittrackr/database/entities/exercise.dart';
import 'package:fittrackr/database/entities/report_table.dart';
import 'package:fittrackr/database/entities/training_history.dart';
import 'package:fittrackr/database/entities/training_plan.dart';
import 'package:fittrackr/states/base_list_state.dart';

class ExercisesState extends BaseListState<Exercise> {
  ExercisesState({super.dbProxy, super.loadDatabase});

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
  ReportState({super.dbProxy, super.loadDatabase});

  List<Report> getByTable(String tableId) => where((e) => e.tableId == tableId).toList();
}

class TrainingPlanState extends BaseListState<TrainingPlan> { TrainingPlanState({super.dbProxy, super.loadDatabase}); }

class TrainingHistoryState extends BaseListState<TrainingHistory> { 
  TrainingHistoryState({super.dbProxy, super.loadDatabase}); 
  
  List<TrainingHistory> sorted() {
    final sortedList = super.clone;
    sortedList.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return sortedList;
  }
}

class ReportTableState extends BaseListState<ReportTable> { ReportTableState({super.dbProxy, super.loadDatabase}); }
