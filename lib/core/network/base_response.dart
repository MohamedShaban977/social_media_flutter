import 'package:equatable/equatable.dart';

import '../utils/json_util.dart';

// {
// "success": true,
// "message": "تمت العملية بنجاح",
// "data": [],
// "statusCode": 200
// }

/// Base Service Response
class BaseResponseEntity<T> extends Equatable {
  final bool success;
  final String message;
  final T? data;
  final int statusCode;

  const BaseResponseEntity({
    required this.success,
    required this.message,
    required this.data,
    required this.statusCode,
  });

  @override
  List<Object?> get props => [success, message, data, statusCode];
}

class BaseResponse<T> extends BaseResponseEntity<T> {
  const BaseResponse({
    required super.success,
    required super.message,
    required super.data,
    required super.statusCode,
  });

  factory BaseResponse.fromJson(Map<String, dynamic> json, [T Function(Map<String, dynamic> data)? fromJson]) {
    return BaseResponse<T>(
      success: json["success"],
      message: json["message"],
      data: JsonUtil.deserializeObject(
        json["data"],
        (data) => fromJson == null
            ? data
            : fromJson(
                data,
              ),
      ),
      statusCode: json["statusCode"],
    );
  }

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data,
        "statusCode": statusCode,
      };
}

/// Base Response collection
class BaseCollectionResponseEntity<T> extends Equatable {
  final bool success;
  final String message;
  final List<T>? data;
  final int statusCode;

  const BaseCollectionResponseEntity({
    required this.message,
    required this.success,
    required this.data,
    required this.statusCode,
  });

  @override
  List<Object?> get props => [success, message, data];
}

class BaseCollectionResponse<T> extends BaseCollectionResponseEntity<T> {
  const BaseCollectionResponse({
    required super.success,
    required super.message,
    required super.data,
    required super.statusCode,
  });

  factory BaseCollectionResponse.fromJson(
    Map<String, dynamic> json,
    T Function(
      dynamic data,
    ) fromJson,
  ) {
    return BaseCollectionResponse<T>(
      success: json["success"],
      message: json["message"],
      data: JsonUtil.deserializeList(
        json["data"],
        (data) => fromJson(
          data,
        ),
      ),
      statusCode: json["statusCode"],
    );
  }
}
