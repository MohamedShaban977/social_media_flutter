import 'package:hauui_flutter/core/extensions/map_extensions.dart';

class ForgetPasswordRequestBody {
  final String? countryCode;
  final String? phoneNumber;
  final String? email;

  ForgetPasswordRequestBody({
    this.countryCode,
    this.phoneNumber,
    this.email,
  });

  Map<String, dynamic> toJson() => {
        "email": email,
        "country_code": countryCode,
        "phone_number": phoneNumber,
      }..removeNullValues();
}
