import 'package:hauui_flutter/core/extensions/map_extensions.dart';

import 'device_model.dart';

class LoginRequestBody {
  final String? countryCode;
  final String? phoneNumber;

  final String? email;
  final String password;
  final DeviceModel device;

  LoginRequestBody({
    this.countryCode,
    this.phoneNumber,
    this.email,
    required this.password,
    required this.device,
  });

  Map<String, dynamic> toJson() => {
        "country_code": countryCode,
        "phone_number": phoneNumber,
        "email": email,
        "password": password,
        "device": device.toJson(),
      }..removeNullValues();
}
