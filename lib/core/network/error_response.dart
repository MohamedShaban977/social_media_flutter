class ErrorResponse {
  final String? message;
  final String? errors;

  ErrorResponse({
    this.message,
    this.errors,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) => ErrorResponse(
        message: json["message"],
        errors: json["errors"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "errors": errors,
      };
}
