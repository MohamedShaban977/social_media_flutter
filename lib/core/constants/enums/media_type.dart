enum MediaType {
  video,
  image;
}

extension MediaTypeExtensions on MediaType {
  static MediaType tryParse(String key, {required MediaType defaultValue}) {
    return MediaType.values.firstWhere((element) => element.name == key, orElse: () => defaultValue);
  }
}
