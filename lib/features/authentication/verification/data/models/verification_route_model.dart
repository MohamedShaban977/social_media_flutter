import 'package:hauui_flutter/core/constants/enums/verification_type.dart';
import 'package:hauui_flutter/core/constants/enums/verify_by.dart';

class VerificationRouteModel {
  final String title;
  final VerifyBy verifyBy;
  final VerificationType navigationFromWhere;
  final String senderData;
  final int? userId;
  final String? verificationCode;

  VerificationRouteModel({
    required this.title,
    required this.verifyBy,
    required this.navigationFromWhere,
    required this.senderData,
    this.userId,
    this.verificationCode,
  }) : assert(
          navigationFromWhere == VerificationType.register && userId != null ||
              navigationFromWhere == VerificationType.forgetPassword && userId == null,
        );

  factory VerificationRouteModel.fromJson(Map<String, dynamic> json) => VerificationRouteModel(
        title: json["title"],
        userId: json["user_id"],
        verifyBy: VerifyBy.values.byName(json["verify_by"]),
        navigationFromWhere: VerificationType.values.byName(json["navigationFromWhere"]),
        senderData: json["senderData"],
        verificationCode: json["verification_code"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "user_id": userId,
        "verify_by": verifyBy.name,
        "navigationFromWhere": navigationFromWhere.name,
        "senderData": senderData,
        "verification_code": verificationCode,
      };
}
