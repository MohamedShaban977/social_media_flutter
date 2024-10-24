extension MapExtensions on Map {
  void removeNullValues({List<String> excludedKeys = const []}) => removeWhere(
      (key, value) => value == null && excludedKeys.contains(key) == false);

  int get internalHashCode {
    int result = 0;
    values.forEach((e) => result += e.hashCode);
    return result;
  }
}
