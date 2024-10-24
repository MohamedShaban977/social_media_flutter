import 'package:hauui_flutter/core/extensions/map_extensions.dart';

class CheckUserExistsRequestBody {
  CheckUserExistsRequestBody({
    this.countryCode,
    this.phoneNumber,
    this.email,
  });

  String? countryCode;
  String? phoneNumber;
  String? email;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['country_code'] = countryCode;
    map['phone_number'] = phoneNumber;
    map['email'] = email;
    return map..removeNullValues();
  }
}
