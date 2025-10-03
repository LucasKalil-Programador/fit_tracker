import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tab_index.g.dart';

@riverpod
class TabIndex extends _$TabIndex {
  @override
  int build() => 0;

  void setTab(int page) => state = page;
}
