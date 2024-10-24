class SuccessMessageModel {
  SuccessMessageModel({
    this.message,
  });

  SuccessMessageModel.fromJson(dynamic json) {
    message = json['message'];
  }

  String? message;
}
