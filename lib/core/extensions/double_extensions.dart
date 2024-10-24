extension NonNullDouble on double? {
  double orZero() {
    return this ?? 0.0;
  }
}
