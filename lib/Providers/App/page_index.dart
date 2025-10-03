import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'page_index.g.dart';

@riverpod
class PageIndex extends _$PageIndex {
  @override
  int build() => 0;

  void setPage(int page) => state = page;
}
