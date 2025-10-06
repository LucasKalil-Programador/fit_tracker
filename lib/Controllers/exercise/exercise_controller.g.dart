// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ExerciseController)
const exerciseControllerProvider = ExerciseControllerProvider._();

final class ExerciseControllerProvider
    extends $NotifierProvider<ExerciseController, List<Exercise>> {
  const ExerciseControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exerciseControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exerciseControllerHash();

  @$internal
  @override
  ExerciseController create() => ExerciseController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Exercise> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Exercise>>(value),
    );
  }
}

String _$exerciseControllerHash() =>
    r'e5612a5633a6afc7cd24c5784e0601978761ea59';

abstract class _$ExerciseController extends $Notifier<List<Exercise>> {
  List<Exercise> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<Exercise>, List<Exercise>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<Exercise>, List<Exercise>>,
              List<Exercise>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
