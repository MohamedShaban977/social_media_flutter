extension NonNullBool on bool? {
  bool orFalse() {
    return this ?? false;
  }
}
