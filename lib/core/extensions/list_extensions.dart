extension NonNullList<T> on List<T>? {
  List<T> orEmpty() {
    return this ?? [];
  }
}
