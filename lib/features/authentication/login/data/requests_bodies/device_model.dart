class DeviceModel {
  final String token;

  DeviceModel({
    required this.token,
  });

  Map<String, dynamic> toJson() => {
        "token": token,
      };
}
