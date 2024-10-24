class VerificationModel {
  final String? message;
  final String? verificationCode;

  VerificationModel({
    this.verificationCode,
    this.message,
  });

  factory VerificationModel.fromJson(Map<String, dynamic> json) => VerificationModel(
        message: json["message"],
        verificationCode: json['verification_code']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "verification_code": verificationCode,
      };
}
