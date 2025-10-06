import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tab_index.g.dart';

@Riverpod(keepAlive: true)
class TabIndex extends _$TabIndex {
  @override
  int build({required String id}) => 0;

  void setTab(int page) => state = page;
}