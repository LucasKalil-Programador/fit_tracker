import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_controller.g.dart';

@Riverpod(keepAlive: true)
class SearchController extends _$SearchController {
  @override
  String build({required String id}) => '';

  void set(String value) => state = value;

  void clear() => state = '';
}