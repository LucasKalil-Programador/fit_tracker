// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_form.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ExerciseFormController)
const exerciseFormControllerProvider = ExerciseFormControllerProvider._();

final class ExerciseFormControllerProvider
    extends $NotifierProvider<ExerciseFormController, FormData> {
  const ExerciseFormControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exerciseFormControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exerciseFormControllerHash();

  @$internal
  @override
  ExerciseFormController create() => ExerciseFormController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FormData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FormData>(value),
    );
  }
}

String _$exerciseFormControllerHash() =>
    r'7ddc3a18c49f059df07fee6447f0c61b3ff832f3';

abstract class _$ExerciseFormController extends $Notifier<FormData> {
  FormData build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<FormData, FormData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FormData, FormData>,
              FormData,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
