class JsonUtil {
  static T? deserializeObject<T>(
    dynamic json,
    T Function(dynamic) fromJson,
  ) {
    return json == null
        ? null
        : fromJson(
            json,
          );
  }

  static List<T>? deserializeList<T>(
    List<dynamic>? list,
    T Function(
      dynamic,
    ) fromJson,
  ) {
    if (list == null) {
      return null;
    } else if (list.isEmpty) {
      return [];
    } else {
      return list
          .map(
            (e) => fromJson(
              e,
            ),
          )
          .toList();
    }
  }

  static String? convertEmptyToNull<String>(
    dynamic json,
    String? Function(dynamic) fromJson,
  ) {
    return json == null || json == '' ? null : fromJson(json);
  }
}
