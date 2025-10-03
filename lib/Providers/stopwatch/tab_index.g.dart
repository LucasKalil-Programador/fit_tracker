// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tab_index.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TabIndex)
const tabIndexProvider = TabIndexProvider._();

final class TabIndexProvider extends $NotifierProvider<TabIndex, int> {
  const TabIndexProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tabIndexProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tabIndexHash();

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
}

String _$tabIndexHash() => r'7e0008890249c20f73fb4855bb1b0e0a62390717';

abstract class _$TabIndex extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
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
