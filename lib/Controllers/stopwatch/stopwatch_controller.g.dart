// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stopwatch_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(StopwatchController)
const stopwatchControllerProvider = StopwatchControllerProvider._();

final class StopwatchControllerProvider
    extends $NotifierProvider<StopwatchController, List<StopWatch>> {
  const StopwatchControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stopwatchControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stopwatchControllerHash();

  @$internal
  @override
  StopwatchController create() => StopwatchController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<StopWatch> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<StopWatch>>(value),
    );
  }
}

String _$stopwatchControllerHash() =>
    r'6fc357884897cbe99086caa65a48d448200a04c0';

abstract class _$StopwatchController extends $Notifier<List<StopWatch>> {
  List<StopWatch> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<StopWatch>, List<StopWatch>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<StopWatch>, List<StopWatch>>,
              List<StopWatch>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
