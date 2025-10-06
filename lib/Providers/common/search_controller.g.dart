// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SearchController)
const searchControllerProvider = SearchControllerFamily._();

final class SearchControllerProvider
    extends $NotifierProvider<SearchController, String> {
  const SearchControllerProvider._({
    required SearchControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'searchControllerProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$searchControllerHash();

  @override
  String toString() {
    return r'searchControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SearchController create() => SearchController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SearchControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$searchControllerHash() => r'd897f626cdbda78de729025d55f105e2d1021076';

final class SearchControllerFamily extends $Family
    with
        $ClassFamilyOverride<SearchController, String, String, String, String> {
  const SearchControllerFamily._()
    : super(
        retry: null,
        name: r'searchControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  SearchControllerProvider call({required String id}) =>
      SearchControllerProvider._(argument: id, from: this);

  @override
  String toString() => r'searchControllerProvider';
}

abstract class _$SearchController extends $Notifier<String> {
  late final _$args = ref.$arg as String;
  String get id => _$args;

  String build({required String id});
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(id: _$args);
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
