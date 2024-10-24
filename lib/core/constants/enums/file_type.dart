enum FileType {
  jpg('jpg', 'image/jpeg'),
  png('png', 'image/png'),
  mp4('mp4', 'video/mp4'),
  pdf('pdf', 'application/pdf'),
  image('image', 'image/'),
  video('video', 'video/');

  final String key;
  final String mime;

  const FileType(this.key, this.mime);
}

extension FileTypeExtensions on FileType {
  static FileType? tryParse(String key, {FileType? defaultValue}) {
    try {
      return FileType.values.firstWhere(
        (fileType) => fileType.key == key,
      );
    } on StateError catch (_) {
      return defaultValue;
    }
  }
}
