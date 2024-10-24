import 'package:easy_localization/easy_localization.dart';

///Example of enum with all utilities you might need
enum DummyEnum {
  const1('const1_key', 'const1_name'),
  const2('const2_key', 'const2_name'),
  const3('const3_key', 'const3_name');

  final String key;
  final String name;

  const DummyEnum(this.key, this.name);
}

extension DummyEnumExtensions on DummyEnum {
  ///Map the enum to the string that needs to be shown on the UI
  String toStr() => name.tr();

  ///Get enum based on the given key
  static DummyEnum? tryParse(String key, {DummyEnum? defaultValue}) {
    try {
      return DummyEnum.values.firstWhere(
        (dummyEnum) => dummyEnum.key == key,
      );
    } on StateError catch (_) {
      return defaultValue;
    }
  }
}
