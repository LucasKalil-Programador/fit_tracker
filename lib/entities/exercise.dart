class Exercise {
  final String name;
  final int load;
  final int reps;
  final int series;

  const Exercise({
    required this.name,
    required this.load,
    required this.reps,
    required this.series,
  });

  @override
  String toString() {
    return 'Exercise(name: $name, load: $load kg, reps: $reps, series: $series)';
  }
}
