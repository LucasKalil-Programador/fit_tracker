// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tab_index.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TabIndex)
const tabIndexProvider = TabIndexFamily._();

final class TabIndexProvider extends $NotifierProvider<TabIndex, int> {
  const TabIndexProvider._({
    required TabIndexFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'tabIndexProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$tabIndexHash();

  @override
  String toString() {
    return r'tabIndexProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  TabIndex create() => TabIndex();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TabIndexProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$tabIndexHash() => r'd4910d5ff12c3b6d5244ffc813c2c923f8cb9485';

final class TabIndexFamily extends $Family
    with $ClassFamilyOverride<TabIndex, int, int, int, String> {
  const TabIndexFamily._()
    : super(
        retry: null,
        name: r'tabIndexProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  TabIndexProvider call({required String id}) =>
      TabIndexProvider._(argument: id, from: this);

  @override
  String toString() => r'tabIndexProvider';
}

abstract class _$TabIndex extends $Notifier<int> {
  late final _$args = ref.$arg as String;
  String get id => _$args;

  int build({required String id});
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(id: _$args);
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
