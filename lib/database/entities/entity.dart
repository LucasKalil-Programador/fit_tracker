abstract class BaseEntity {
  String? id;

  Map<String, Object?> toMap();

  bool get isValid;
}
