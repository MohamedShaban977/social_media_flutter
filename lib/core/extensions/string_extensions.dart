extension NonNullString on String? {
  String orEmpty() {
    return this ?? '';
  }
}

extension EmptyString on String? {
  String? empty() {
    return this == null ? null : '';
  }

  String capitalize() {
    return "${this?[0].toUpperCase()}${this?.substring(1).toLowerCase()}";
  }
}
