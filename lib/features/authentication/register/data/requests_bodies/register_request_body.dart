import 'package:hauui_flutter/core/extensions/map_extensions.dart';
import 'package:hauui_flutter/features/authentication/login/data/requests_bodies/device_model.dart';

class RegisterRequestBody {
  final String? name;
  final String? email;
  final String? password;
  final String? verifyBy;
  final String? countryCode;
  final String? phoneNumber;
  final DeviceModel? device;

  RegisterRequestBody({
    this.name,
    this.email,
    this.password,
    this.verifyBy,
    this.countryCode,
    this.phoneNumber,
    this.device,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'password': password,
        'verify_by': verifyBy,
        'country_code': countryCode,
        'phone_number': phoneNumber,
        'device': device?.toJson()
      }..removeNullValues();
}
